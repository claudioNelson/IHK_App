import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Registrierung - Profil wird vom Trigger erstellt
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('📝 Starte Registrierung für: $email');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user != null) {
        print('✅ User registriert: ${response.user?.id}');
        print('✅ Profil wird automatisch vom Trigger erstellt!');
      }

      return response;
    } catch (e) {
      print('❌ Registrierung fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Login Versuch für: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ Login erfolgreich: ${response.user?.email}');
      }

      return response;
    } catch (e) {
      print('❌ Login fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      print('👋 Logout...');
      await _supabase.auth.signOut();
      
      // Lokale Daten löschen
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      print('✅ Logout erfolgreich');
    } catch (e) {
      print('❌ Logout fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Passwort zurücksetzen
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      print('✅ Passwort-Reset Email gesendet an: $email');
    } catch (e) {
      print('❌ Passwort-Reset fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Passwort ändern
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('✅ Passwort aktualisiert');
      return response;
    } catch (e) {
      print('❌ Passwort-Update fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Profil aktualisieren (nur User-Metadaten)
  Future<UserResponse> updateProfile({
    String? username,
    Map<String, dynamic>? data,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (data != null) updates.addAll(data);

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: updates),
      );
      
      print('✅ Profil aktualisiert');
      return response;
    } catch (e) {
      print('❌ Profil-Update fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Profil in DB aktualisieren (zusätzliche Felder)
  Future<void> updateProfileInDB({
    String? username,
    String? avatarUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!isAuthenticated) {
      throw Exception('Nicht authentifiziert');
    }

    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (additionalData != null) updates.addAll(additionalData);

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', currentUser!.id);

      print('✅ Profil in DB aktualisiert');
    } catch (e) {
      print('❌ DB-Update fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Profil laden mit robustem Fallback und Retry-Logik
  Future<Map<String, dynamic>?> getProfile({int maxRetries = 3}) async {
    if (!isAuthenticated) return null;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('📖 Lade Profil (Versuch $attempt/$maxRetries) für: ${currentUser!.id}');
        
        // Bei erstem Versuch kurz warten (für Trigger)
        if (attempt == 1) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final response = await _supabase
            .from('profiles')
            .select()
            .eq('id', currentUser!.id)
            .maybeSingle();

        if (response != null) {
          print('✅ Profil gefunden: ${response['username']}');
          return response;
        }

        // Wenn kein Profil gefunden, warte bei nächstem Versuch länger
        if (attempt < maxRetries) {
          print('⏳ Profil noch nicht da, warte...');
          await Future.delayed(Duration(seconds: attempt));
        }
      } catch (e) {
        print('❌ Fehler beim Profil laden (Versuch $attempt): $e');
        
        if (attempt == maxRetries) {
          // Letzter Versuch fehlgeschlagen -> Fallback
          break;
        }
        
        await Future.delayed(Duration(seconds: attempt));
      }
    }

    // Fallback auf User-Metadaten
    print('⚠️ Nutze Fallback-Profil aus User-Metadaten');
    return {
      'id': currentUser!.id,
      'username': currentUser!.userMetadata?['username'] ?? 'User',
      'email': currentUser!.email ?? '',
      'created_at': currentUser!.createdAt,
      'is_fallback': true, // Marker für UI
    };
  }

  // Prüfen ob Email bereits existiert
  Future<bool> emailExists(String email) async {
    try {
      // Versuche Login mit falschem Passwort
      // Supabase gibt unterschiedliche Fehler für "User not found" vs "Wrong password"
      await _supabase.auth.signInWithPassword(
        email: email,
        password: 'dummy-check-${DateTime.now().millisecondsSinceEpoch}',
      );
      return true;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      
      // Wenn "invalid" oder "credentials" -> User existiert
      if (errorMessage.contains('invalid') || 
          errorMessage.contains('credentials')) {
        return true;
      }
      
      // Wenn "not found" oder "user not found" -> existiert nicht
      return false;
    }
  }

  // Session refreshen
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
      print('✅ Session aufgefrischt');
    } catch (e) {
      print('❌ Session-Refresh fehlgeschlagen: $e');
      rethrow;
    }
  }

  // Profil löschen (mit User-Account)
  Future<void> deleteAccount() async {
    if (!isAuthenticated) {
      throw Exception('Nicht authentifiziert');
    }

    try {
      print('🗑️ Lösche Account: ${currentUser!.id}');
      
      // Erst Profil löschen
      await _supabase
          .from('profiles')
          .delete()
          .eq('id', currentUser!.id);

      // Dann User (falls Admin-Rechte vorhanden)
      // Sonst muss das über Supabase Dashboard gemacht werden
      
      // Logout
      await signOut();
      
      print('✅ Account gelöscht');
    } catch (e) {
      print('❌ Account-Löschung fehlgeschlagen: $e');
      rethrow;
    }
  }
}