import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatefulWidget {
  final Widget authenticatedChild;
  final Widget unauthenticatedChild;
  
  const AuthWrapper({
    super.key,
    required this.authenticatedChild,
    required this.unauthenticatedChild,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _checkingAuth = true;
  bool _isAuthenticated = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    try {
      print('🔍 Prüfe initiale Session...');
      
      // Kurze Verzögerung für Supabase-Initialisierung
      await Future.delayed(const Duration(milliseconds: 300));
      
      final session = Supabase.instance.client.auth.currentSession;
      
      print(session != null 
        ? '✅ Session gefunden: ${session.user.email}'
        : '❌ Keine Session vorhanden'
      );
      
      if (!mounted) return;
      
      setState(() {
        _isAuthenticated = session != null;
        _checkingAuth = false;
        _error = null;
      });
    } catch (e) {
      print('❌ Auth Check Error: $e');
      
      if (!mounted) return;
      
      setState(() {
        _isAuthenticated = false;
        _checkingAuth = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Zeige Loading während Initial-Check
    if (_checkingAuth) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                'Authentifizierung prüfen...',
                style: TextStyle(fontSize: 16),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Fehler: $_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Debug-Button falls es zu lange dauert
              TextButton.icon(
                icon: const Icon(Icons.skip_next),
                label: const Text('Direkt zum Login'),
                onPressed: () {
                  setState(() {
                    _checkingAuth = false;
                    _isAuthenticated = false;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    // StreamBuilder für Auth-Änderungen
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      initialData: _buildInitialAuthState(),
      builder: (context, snapshot) {
        // Error Handling
        if (snapshot.hasError) {
          print('❌ Auth Stream Error: ${snapshot.error}');
          return _buildErrorScreen(snapshot.error.toString());
        }

        // Während Stream verbindet, nutze cached Status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _isAuthenticated
              ? widget.authenticatedChild
              : widget.unauthenticatedChild;
        }

        final session = snapshot.data?.session;
        final event = snapshot.data?.event;

        // Debug-Output für Auth-Events
        if (event != null) {
          print('🔐 Auth Event: $event');
          if (session != null) {
            print('   User: ${session.user.email}');
          }
        }

        // Entscheide basierend auf Session
        if (session != null) {
          return widget.authenticatedChild;
        } else {
          return widget.unauthenticatedChild;
        }
      },
    );
  }

  // Hilfsmethode: Initial AuthState bauen
  AuthState _buildInitialAuthState() {
    final currentSession = Supabase.instance.client.auth.currentSession;
    final event = currentSession != null
        ? AuthChangeEvent.signedIn
        : AuthChangeEvent.signedOut;
    
    return AuthState(event, currentSession);
  }

  // Hilfsmethode: Error Screen
  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Authentifizierungsfehler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
                onPressed: () {
                  setState(() {
                    _checkingAuth = true;
                    _error = null;
                  });
                  _checkInitialSession();
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _checkingAuth = false;
                    _isAuthenticated = false;
                  });
                },
                child: const Text('Zum Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}