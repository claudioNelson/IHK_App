// lib/services/billing_service.dart
//
// In-App-Käufe für Lernarena Premium (Google Play Billing + Apple StoreKit).
//
// Produkte:
//   Google Play: EIN Abo `lernarena_premium` mit drei Base Plans
//                monthly · half-year · annual
//   App Store:   DREI Abos in der Gruppe "Lernarena Premium"
//                lernarena_premium_monthly · lernarena_premium_halfyear ·
//                lernarena_premium_annual   (Apple kennt keine Base Plans)
//   Preise (dt. Endpreise inkl. MwSt.): 11,99 €/Monat · 47,99 €/6 Monate ·
//   84,99 €/Jahr — auf beiden Plattformen gleich.
//
// Ablauf:
//   1. init() beim App-Start → lädt Produkte + lauscht auf Kauf-Events.
//   2. buy(plan) startet den Store-Kaufdialog.
//   3. Bei erfolgreichem Kauf schickt die App den Kaufnachweis an eine
//      Edge Function, die DIREKT beim Store nachfragt und erst dann Premium
//      freischaltet — inklusive echtem Ablaufdatum aus dem Abo:
//        Android → `verify-purchase`      (purchaseToken, Play Developer API)
//        iOS     → `verify-purchase-ios`  (signierte StoreKit-2-Transaktion,
//                                          App Store Server API)
//   4. restorePurchases() läuft über denselben Weg (z. B. nach
//      Neuinstallation oder automatischer Abo-Verlängerung).
//
// iOS seit 1.6 (05.09.2026): StoreKit 2 (in_app_purchase_storekit ≥ 0.4,
// iOS ≥ 15). `serverVerificationData` ist dort die JWS-Transaktion.
//
// Angebote (seit 10.09.2026, Aktion "Pruefungs-Endspurt"): Google liefert
// je Base Plan und Angebot einen eigenen ProductDetails-Eintrag; wir waehlen
// den mit der guenstigsten ersten Zahlung, das Offer-Token geht damit
// automatisch in den Kauf. priceFor() liefert den regulaeren Preis,
// angebotFor() das Einfuehrungsangebot. Apple wendet Einfuehrungsangebote im
// Kaufdialog selbst an, dort nichts zu tun.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart'
    show SubscriptionOfferDetailsWrapper;
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

  /// Produkt-ID wie in App Store Connect angelegt (je Laufzeit ein Abo).
  String get appleProductId {
    switch (this) {
      case PremiumPlan.monthly:
        return 'lernarena_premium_monthly';
      case PremiumPlan.halfYear:
        return 'lernarena_premium_halfyear';
      case PremiumPlan.annual:
        return 'lernarena_premium_annual';
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

/// Einfuehrungsangebot auf einem Plan (Google Play: Angebot auf dem Base
/// Plan, vom Store nur geliefert, wenn der Nutzer berechtigt ist).
class PlanAngebot {
  /// Preis der ersten Zahlung(en), z. B. "5,99 €".
  final String einfuehrungsPreis;

  /// Regulaerer Preis danach, z. B. "11,99 €".
  final String regulaerPreis;

  /// Anzahl der verguenstigten Abrechnungsperioden (1 = erster Monat).
  final int perioden;

  const PlanAngebot({
    required this.einfuehrungsPreis,
    required this.regulaerPreis,
    required this.perioden,
  });
}

class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  /// Google-Play-Abo-ID (ein Produkt, drei Base Plans).
  static const String subscriptionId = 'lernarena_premium';

  /// Kauf über den App Store (StoreKit) statt Google Play?
  static bool get _isApple => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  /// Produkt-IDs, die beim Store abgefragt werden.
  static Set<String> get _productIds => _isApple
      ? PremiumPlan.values.map((p) => p.appleProductId).toSet()
      : {subscriptionId};

  /// Name der Edge Function für die serverseitige Belegprüfung.
  static String get _verifyFunction =>
      _isApple ? 'verify-purchase-ios' : 'verify-purchase';

  /// Name des Stores für Fehlermeldungen.
  static String get _storeName => _isApple ? 'App Store' : 'Google Play';

  /// In-App-Purchase-Instanz. `late` + Initializer = wird erst beim ersten
  /// Zugriff erzeugt — auf nicht unterstützten Plattformen (Windows/Linux/
  /// Web) greifen wir dank Platform-Check nie darauf zu und vermeiden so
  /// den LateInitializationError beim App-Start.
  late final InAppPurchase _iap = InAppPurchase.instance;

  /// Plattformen, auf denen in_app_purchase eine Implementierung hat.
  static bool get platformSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
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

  /// Feuert, sobald der Store einen Kauf gemeldet hat und die
  /// serverseitige Belegprüfung läuft (UI: "Kauf wird bestätigt …").
  final StreamController<void> _purchaseVerifying =
      StreamController<void>.broadcast();
  Stream<void> get onPurchaseVerifying => _purchaseVerifying.stream;

  bool get isAvailable => _available;

  /// Regulaerer Anzeigepreis für einen Plan (Store-Preis oder Fallback).
  /// Bei einem Google-Angebot ist `pd.price` der Einfuehrungspreis; der
  /// regulaere Preis steht in der letzten Preisphase.
  String priceFor(PremiumPlan plan) {
    final pd = _products[plan];
    if (pd == null) return plan.fallbackPrice;
    final phasen = _offerOf(pd)?.pricingPhases;
    if (phasen != null && phasen.length > 1) return phasen.last.formattedPrice;
    return pd.price;
  }

  /// Regulaerer Preis als Zahl — für die €/Monat-Berechnung im Kauf-Sheet.
  double rawPriceFor(PremiumPlan plan) {
    final pd = _products[plan];
    if (pd == null) return plan.fallbackRawPrice;
    final phasen = _offerOf(pd)?.pricingPhases;
    if (phasen != null && phasen.length > 1) {
      return phasen.last.priceAmountMicros / 1000000;
    }
    return pd.rawPrice;
  }

  /// Waehrungssymbol des Store-Produkts (Storefront des Nutzers), fuer die
  /// €/Monat-Zeile im Kauf-Sheet. Sandbox-Konten haben oft eine US-Storefront
  /// und liefern Dollar - dann darf da kein festes Euro-Zeichen stehen.
  String currencySymbolFor(PremiumPlan plan) =>
      _products[plan]?.currencySymbol ?? '€';

  /// Einfuehrungsangebot, das Google Play fuer diesen Nutzer auf dem Plan
  /// liefert (null = keins oder nicht berechtigt). Apple: Einfuehrungs-
  /// angebote wendet StoreKit im Kaufdialog selbst an; die App zeigt dort
  /// nur den Hinweistext der Aktion (aktions_service.dart).
  PlanAngebot? angebotFor(PremiumPlan plan) {
    final pd = _products[plan];
    if (pd == null) return null;
    final offer = _offerOf(pd);
    if (offer == null || offer.offerId == null) return null;
    final phasen = offer.pricingPhases;
    if (phasen.length < 2) return null;
    final erste = phasen.first;
    return PlanAngebot(
      einfuehrungsPreis: erste.formattedPrice,
      regulaerPreis: phasen.last.formattedPrice,
      perioden: erste.billingCycleCount == 0 ? 1 : erste.billingCycleCount,
    );
  }

  // ─── INIT ────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Auf Windows/Linux/Web gibt es kein Billing — sauber überspringen
    // statt mit LateInitializationError zu crashen. _available bleibt
    // false, alle anderen Methoden sind damit automatisch abgesichert.
    if (!platformSupported) {
      debugPrint('💳 Billing: Plattform nicht unterstützt — übersprungen');
      return;
    }

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
      final response = await _iap.queryProductDetails(_productIds);
      if (response.error != null) {
        debugPrint('❌ queryProductDetails: ${response.error!.message}');
        return;
      }
      if (response.notFoundIDs.isNotEmpty) {
        // iOS: typisch, wenn der Vertrag für bezahlte Apps nicht aktiv ist
        // oder die Abos in App Store Connect noch nicht "Bereit" sind.
        debugPrint('⚠️ Produkte nicht gefunden: ${response.notFoundIDs}');
      }

      _products.clear();
      // Was der Store liefert, pro Eintrag: Base Plan, Angebots-ID, erste
      // Preisphase. Ohne das raet man nur, warum ein Angebot fehlt.
      for (final pd in response.productDetails) {
        final o = _offerOf(pd);
        debugPrint(
          '💳 Store-Eintrag ${pd.id}: basePlan=${o?.basePlanId} '
          'offer=${o?.offerId} phasen=${o?.pricingPhases.map((f) => f.formattedPrice).join(' > ') ?? pd.price}',
        );
      }
      for (final pd in response.productDetails) {
        for (final plan in PremiumPlan.values) {
          final passt = _isApple
              // App Store: je Laufzeit ein eigenes Produkt.
              ? pd.id == plan.appleProductId
              // Google Play: pro Base Plan UND pro Angebot ein
              // ProductDetails-Eintrag mit derselben Produkt-ID ->
              // Zuordnung ueber die Base-Plan-ID.
              : _basePlanIdOf(pd) == plan.basePlanId;
          if (!passt) continue;
          // Google liefert nur Angebote, fuer die der Nutzer berechtigt
          // ist. Liegt zu einem Base Plan mehr als ein Eintrag vor, nehmen
          // wir den mit der guenstigsten ersten Zahlung (Aktion vor
          // Grundpreis). Das Offer-Token haengt an diesem Eintrag und geht
          // beim Kauf automatisch mit.
          final bisher = _products[plan];
          if (bisher == null || _erstePhase(pd) < _erstePhase(bisher)) {
            _products[plan] = pd;
          }
        }
      }
      debugPrint(
        '💳 Produkte geladen ($_storeName): '
        '${_products.map((k, v) => MapEntry(k.name, v.price))}',
      );
    } catch (e) {
      debugPrint('❌ loadProducts Fehler: $e');
    }
  }

  String? _basePlanIdOf(ProductDetails pd) => _offerOf(pd)?.basePlanId;

  /// Der Google-Play-Eintrag (Base Plan + ggf. Angebot), zu dem dieses
  /// ProductDetails gehoert. null auf Apple oder wenn nicht lesbar.
  SubscriptionOfferDetailsWrapper? _offerOf(ProductDetails pd) {
    try {
      if (pd is GooglePlayProductDetails) {
        final index = pd.subscriptionIndex;
        final offers = pd.productDetails.subscriptionOfferDetails;
        if (index != null && offers != null && index < offers.length) {
          return offers[index];
        }
      }
    } catch (e) {
      debugPrint('⚠️ Angebot nicht lesbar: $e');
    }
    return null;
  }

  /// Betrag der ersten Zahlung in Micros (zum Vergleich der Eintraege).
  int _erstePhase(ProductDetails pd) {
    final phasen = _offerOf(pd)?.pricingPhases;
    if (phasen == null || phasen.isEmpty) return (pd.rawPrice * 1000000).round();
    return phasen.first.priceAmountMicros;
  }

  // ─── KAUF ────────────────────────────────────────────────

  /// Startet den Google-Play-Kaufdialog für den gewählten Plan.
  /// Liefert false, wenn der Kauf gar nicht gestartet werden konnte.
  Future<bool> buy(PremiumPlan plan) async {
    // Gäste dürfen nicht kaufen — das Abo würde an einem anonymen
    // Account hängen und wäre bei Deinstallation verloren.
    if (Supabase.instance.client.auth.currentUser?.isAnonymous == true) {
      _purchaseError.add(
        'Bitte erstelle zuerst einen Account, um Premium zu kaufen.',
      );
      return false;
    }

    if (!_available) {
      _purchaseError.add(
        'Käufe über den $_storeName sind auf diesem Gerät nicht verfügbar.',
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

      // Pflicht: Kauf gegenüber dem Store bestätigen (Google: sonst
      // automatische Rückerstattung nach 3 Tagen; Apple: Transaktion
      // bleibt sonst offen und wird bei jedem Start erneut gemeldet).
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
  /// Die App schickt nur den Kaufnachweis — der Server fragt beim Store
  /// nach, ob der Kauf echt und aktiv ist, ermittelt Plan + echtes
  /// Ablaufdatum aus dem Abo und schreibt erst dann Premium in Supabase.
  ///   Android: purchaseToken            → verify-purchase
  ///   iOS:     JWS-Transaktion (StoreKit 2) → verify-purchase-ios
  ///
  /// fresh = true  → neuer Kauf (UI wartet auf onPremiumActivated).
  /// fresh = false → Restore/Verlängerung (gleicher Prüfweg).
  Future<void> _grantPremium(
    PurchaseDetails purchase, {
    required bool fresh,
  }) async {
    if (!_productIds.contains(purchase.productID)) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('⚠️ Kauf ohne eingeloggten User — kein Grant möglich.');
      return;
    }

    if (fresh) _purchaseVerifying.add(null);

    try {
      // Google: purchaseToken. Apple (StoreKit 2): signierte Transaktion.
      final token = purchase.verificationData.serverVerificationData;
      if (token.isEmpty) {
        throw Exception('Kein Kaufnachweis vorhanden');
      }

      final res = await Supabase.instance.client.functions.invoke(
        _verifyFunction,
        body: _isApple
            ? {'transactionJws': token, 'productId': purchase.productID}
            : {'purchaseToken': token},
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
      // Server-Meldung durchreichen, wenn es eine gibt (z. B. "Dieses Abo
      // ist bereits mit einem anderen Lernarena-Konto verknüpft" bei
      // Status 409 aus verify-purchase / verify-purchase-ios).
      String? serverText;
      if (e is FunctionException) {
        final d = e.details;
        if (d is Map && d['error'] is String) serverText = d['error'] as String;
      }
      _purchaseError.add(
        serverText ??
            'Kauf erfolgreich, aber Freischaltung fehlgeschlagen. '
                'Bitte App neu starten oder Support kontaktieren.',
      );
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}
