// lib/services/billing_service.dart
//
// Google Play Billing für Lernarena Premium.
//
// Produkte (Play Console):
//   Abo-ID:      lernarena_premium
//   Base Plans:  monthly (11,99 €/Monat) · half-year (47,99 €/6 Monate) · annual (84,99 €/Jahr) — dt. Endpreise inkl. MwSt.
//
// Ablauf:
//   1. init() beim App-Start → lädt Produkte + lauscht auf Kauf-Events.
//   2. buy(plan) startet den Google-Play-Kaufdialog.
//   3. Bei erfolgreichem Kauf schickt die App den purchaseToken an die
//      Edge Function `verify-purchase`. Die prüft den Kauf DIREKT bei
//      Google (Play Developer API) und schaltet erst dann Premium frei —
//      inklusive echtem Ablaufdatum aus dem Google-Abo.
//   4. restorePurchases() läuft über denselben Weg (z. B. nach
//      Neuinstallation oder automatischer Abo-Verlängerung).

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'subscription_service.dart';

/// Die drei wählbaren Premium-Pläne.
enum PremiumPlan { monthly, halfYear, annual }

extension PremiumPlanX on PremiumPlan {
  /// Base-Plan-ID wie in der Play Console angelegt.
  String get basePlanId {
    switch (this) {
      case PremiumPlan.monthly:
        return 'monthly';
      case PremiumPlan.halfYear:
        return 'half-year';
      case PremiumPlan.annual:
        return 'annual';
    }
  }

  /// Wert für profiles.premium_tier in Supabase.
  String get tier {
    switch (this) {
      case PremiumPlan.monthly:
        return 'monthly';
      case PremiumPlan.halfYear:
        return 'half-year';
      case PremiumPlan.annual:
        return 'yearly';
    }
  }

  /// Laufzeit in Tagen (inkl. 7 Tage Kulanz, analog zur Grace Period).
  int get durationDays {
    switch (this) {
      case PremiumPlan.monthly:
        return 31 + 7;
      case PremiumPlan.halfYear:
        return 183 + 7;
      case PremiumPlan.annual:
        return 365 + 7;
    }
  }

  /// Statischer Anzeigepreis als Fallback, falls Google Play die
  /// Produktdaten (noch) nicht liefert. Entspricht den deutschen
  /// Endpreisen inkl. MwSt.
  String get fallbackPrice {
    switch (this) {
      case PremiumPlan.monthly:
        return '11,99 €';
      case PremiumPlan.halfYear:
        return '47,99 €';
      case PremiumPlan.annual:
        return '84,99 €';
    }
  }

  /// Fallback-Preis als Zahl (für die €/Monat-Berechnung).
  double get fallbackRawPrice {
    switch (this) {
      case PremiumPlan.monthly:
        return 11.99;
      case PremiumPlan.halfYear:
        return 47.99;
      case PremiumPlan.annual:
        return 84.99;
    }
  }

  /// Laufzeit in Monaten (für die €/Monat-Anzeige).
  int get months {
    switch (this) {
      case PremiumPlan.monthly:
        return 1;
      case PremiumPlan.halfYear:
        return 6;
      case PremiumPlan.annual:
        return 12;
    }
  }
}

class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  static const String subscriptionId = 'lernarena_premium';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  /// Pro Base Plan das passende Google-Play-Produkt (für Preis + Kauf).
  final Map<PremiumPlan, ProductDetails> _products = {};

  bool _available = false;
  bool _initialized = false;

  /// Welcher Plan zuletzt zum Kauf angetippt wurde — damit wir beim
  /// Kauf-Event wissen, welche Laufzeit freigeschaltet werden soll.
  PremiumPlan? _pendingPlan;

  /// Feuert `true`, sobald ein Kauf erfolgreich verarbeitet und Premium
  /// freigeschaltet wurde. UI (Kauf-Sheet) hört hierauf.
  final StreamController<bool> _premiumActivated =
      StreamController<bool>.broadcast();
  Stream<bool> get onPremiumActivated => _premiumActivated.stream;

  /// Feuert bei Kauf-Fehlern/Abbrüchen mit einer kurzen Meldung.
  final StreamController<String> _purchaseError =
      StreamController<String>.broadcast();
  Stream<String> get onPurchaseError => _purchaseError.stream;

  bool get isAvailable => _available;

  /// Anzeigepreis für einen Plan (echter Google-Play-Preis oder Fallback).
  String priceFor(PremiumPlan plan) =>
      _products[plan]?.price ?? plan.fallbackPrice;

  /// Preis als Zahl (echter Google-Play-Preis oder Fallback) —
  /// für die €/Monat-Berechnung im Kauf-Sheet.
  double rawPriceFor(PremiumPlan plan) =>
      _products[plan]?.rawPrice ?? plan.fallbackRawPrice;

  // ─── INIT ────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _available = await _iap.isAvailable();
      debugPrint('💳 Billing verfügbar: $_available');
      if (!_available) return;

      // Auf Kauf-Events lauschen (Käufe, Restores, Fehler)
      _purchaseSub = _iap.purchaseStream.listen(
        _onPurchaseUpdates,
        onError: (e) => debugPrint('❌ purchaseStream Fehler: $e'),
      );

      await loadProducts();
    } catch (e) {
      debugPrint('❌ BillingService init Fehler: $e');
    }
  }

  Future<void> loadProducts() async {
    if (!_available) return;
    try {
      final response = await _iap.queryProductDetails({subscriptionId});
      if (response.error != null) {
        debugPrint('❌ queryProductDetails: ${response.error!.message}');
        return;
      }

      _products.clear();
      // Auf Android liefert Google pro Base Plan / Angebot einen eigenen
      // ProductDetails-Eintrag (gleiche Produkt-ID). Wir ordnen sie über
      // die Base-Plan-ID zu.
      for (final pd in response.productDetails) {
        final basePlanId = _basePlanIdOf(pd);
        for (final plan in PremiumPlan.values) {
          if (basePlanId == plan.basePlanId) {
            _products[plan] = pd;
          }
        }
      }
      debugPrint(
        '💳 Produkte geladen: '
        '${_products.map((k, v) => MapEntry(k.basePlanId, v.price))}',
      );
    } catch (e) {
      debugPrint('❌ loadProducts Fehler: $e');
    }
  }

  String? _basePlanIdOf(ProductDetails pd) {
    try {
      if (pd is GooglePlayProductDetails) {
        final index = pd.subscriptionIndex;
        final offers = pd.productDetails.subscriptionOfferDetails;
        if (index != null && offers != null && index < offers.length) {
          return offers[index].basePlanId;
        }
      }
    } catch (e) {
      debugPrint('⚠️ basePlanId nicht lesbar: $e');
    }
    return null;
  }

  // ─── KAUF ────────────────────────────────────────────────

  /// Startet den Google-Play-Kaufdialog für den gewählten Plan.
  /// Liefert false, wenn der Kauf gar nicht gestartet werden konnte.
  Future<bool> buy(PremiumPlan plan) async {
    if (!_available) {
      _purchaseError.add(
        'Google Play Billing ist auf diesem Gerät nicht verfügbar.',
      );
      return false;
    }

    var product = _products[plan];
    if (product == null) {
      await loadProducts();
      product = _products[plan];
    }
    if (product == null) {
      _purchaseError.add(
        'Produkt konnte nicht geladen werden. Bitte später erneut versuchen.',
      );
      return false;
    }

    _pendingPlan = plan;
    try {
      final param = PurchaseParam(productDetails: product);
      // Abos laufen bei in_app_purchase über buyNonConsumable.
      return await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      debugPrint('❌ buy Fehler: $e');
      _purchaseError.add('Kauf konnte nicht gestartet werden.');
      return false;
    }
  }

  /// Stellt frühere Käufe wieder her (Neuinstallation, Gerätewechsel,
  /// Abo-Verlängerung). Löst bei aktiven Abos restored-Events aus.
  Future<void> restorePurchases() async {
    if (!_available) return;
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('❌ restorePurchases Fehler: $e');
    }
  }

  // ─── KAUF-EVENTS ─────────────────────────────────────────

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      debugPrint(
        '💳 Purchase-Update: ${purchase.productID} → ${purchase.status}',
      );

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          await _grantPremium(purchase, fresh: true);
          break;
        case PurchaseStatus.restored:
          await _grantPremium(purchase, fresh: false);
          break;
        case PurchaseStatus.error:
          debugPrint('❌ Kauf-Fehler: ${purchase.error?.message}');
          _purchaseError.add('Der Kauf wurde nicht abgeschlossen.');
          break;
        case PurchaseStatus.canceled:
          _purchaseError.add('Kauf abgebrochen.');
          break;
        case PurchaseStatus.pending:
          // z. B. Zahlung in Bearbeitung — Google meldet sich erneut.
          break;
      }

      // Pflicht: Kauf gegenüber Google bestätigen (sonst automatische
      // Rückerstattung nach 3 Tagen).
      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
        } catch (e) {
          debugPrint('❌ completePurchase Fehler: $e');
        }
      }
    }
  }

  /// Schaltet Premium über die serverseitige Belegprüfung frei.
  ///
  /// Die App schickt nur den purchaseToken — der Server fragt bei Google
  /// nach, ob der Kauf echt und aktiv ist, ermittelt Plan + echtes
  /// Ablaufdatum aus dem Abo und schreibt erst dann Premium in Supabase.
  ///
  /// fresh = true  → neuer Kauf (UI wartet auf onPremiumActivated).
  /// fresh = false → Restore/Verlängerung (gleicher Prüfweg).
  Future<void> _grantPremium(
    PurchaseDetails purchase, {
    required bool fresh,
  }) async {
    if (purchase.productID != subscriptionId) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('⚠️ Kauf ohne eingeloggten User — kein Grant möglich.');
      return;
    }

    try {
      // Der purchaseToken von Google Play — der Nachweis des Kaufs.
      final token = purchase.verificationData.serverVerificationData;
      if (token.isEmpty) {
        throw Exception('Kein purchaseToken vorhanden');
      }

      final res = await Supabase.instance.client.functions.invoke(
        'verify-purchase',
        body: {'purchaseToken': token},
      );

      final data = res.data is Map ? Map<String, dynamic>.from(res.data) : null;
      if (data == null || data['ok'] != true) {
        throw Exception(data?['error'] ?? 'Status ${res.status}');
      }

      await SubscriptionService().refresh();
      _pendingPlan = null;

      debugPrint(
        '✅ Premium verifiziert & aktiviert '
        '(tier: ${data['tier']}, bis: ${data['premiumUntil']})',
      );
      if (fresh) _premiumActivated.add(true);
    } catch (e) {
      debugPrint('❌ Premium-Freischaltung fehlgeschlagen: $e');
      _purchaseError.add(
        'Kauf erfolgreich, aber Freischaltung fehlgeschlagen. '
        'Bitte App neu starten oder Support kontaktieren.',
      );
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}
