// lib/services/subscription_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service zum Verwalten des Premium-Status eines Users.
///
/// Singleton — Status wird einmal pro Session gecacht.
/// `refresh()` aufrufen um neu zu laden (z.B. nach Stripe-Checkout).
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final _supabase = Supabase.instance.client;

  bool _isPremium = false;
  String? _premiumTier; // monthly, yearly, lifetime
  DateTime? _premiumUntil;
  bool _loaded = false;

  // ─── Public API ─────────────────────────────────

  /// Ist der aktuelle User Premium?
  bool get isPremium => _isPremium;

  /// Welches Tier? (monthly, yearly, lifetime, null = free)
  String? get tier => _premiumTier;

  /// Bei Abos: wann läuft's ab? Lifetime = null
  DateTime? get expiresAt => _premiumUntil;

  /// War der Status schon mal geladen?
  bool get isLoaded => _loaded;

  /// Lädt den Premium-Status aus der DB.
  /// Sollte beim App-Start oder nach Login aufgerufen werden.
  Future<void> load() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _resetState();
      _loaded = true;
      return;
    }

    try {
      final profile = await _supabase
          .from('profiles')
          .select('is_premium, premium_until, premium_tier')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        _resetState();
        _loaded = true;
        return;
      }

      final isPremiumDb = profile['is_premium'] == true;
      final untilStr = profile['premium_until'] as String?;
      final tier = profile['premium_tier'] as String?;

      DateTime? until;
      if (untilStr != null) {
        until = DateTime.tryParse(untilStr);
      }

      // Prüfen ob Abo abgelaufen ist
      bool stillPremium = isPremiumDb;
      if (isPremiumDb && tier != 'lifetime' && until != null) {
        if (until.isBefore(DateTime.now())) {
          stillPremium = false;
          // DB updaten — Abo ist abgelaufen
          await _supabase
              .from('profiles')
              .update({'is_premium': false})
              .eq('id', user.id);
        }
      }

      _isPremium = stillPremium;
      _premiumTier = tier;
      _premiumUntil = until;
      _loaded = true;

      debugPrint('✅ Subscription loaded: isPremium=$_isPremium, tier=$tier');
    } catch (e) {
      debugPrint('❌ Subscription load error: $e');
      _resetState();
      _loaded = true;
    }
  }

  /// Aktualisiert den Status (z.B. nach Stripe-Checkout).
  Future<void> refresh() async {
    _loaded = false;
    await load();
  }

  /// Wird aufgerufen wenn der User ausloggt.
  void clear() {
    _resetState();
    _loaded = false;
  }

  void _resetState() {
    _isPremium = false;
    _premiumTier = null;
    _premiumUntil = null;
  }

  // ─── Feature-Checks (für UI) ────────────────────

  /// Sind IHK-Prüfungen verfügbar?
  bool get canAccessIhkExams => _isPremium;

  /// Sind Zertifikate verfügbar?
  bool get canAccessCertificates => _isPremium;

  // ─── Helper ─────────────────────────────────────

  /// Returns "Premium" oder "Free"
  String get tierLabel => _isPremium ? 'Premium' : 'Free';

  /// Returns DateTime in lesbarem Format oder "Lifetime"
  String get expiryLabel {
    if (!_isPremium) return 'Free';
    if (_premiumTier == 'lifetime') return 'Lifetime';
    if (_premiumUntil == null) return 'Aktiv';
    final now = DateTime.now();
    final days = _premiumUntil!.difference(now).inDays;
    if (days < 0) return 'Abgelaufen';
    if (days < 30) return 'Läuft in $days Tagen ab';
    final months = (days / 30).round();
    return 'Läuft in $months Monaten ab';
  }
}
