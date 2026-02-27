import 'widgets/auth_wrapper.dart';
import 'widgets/navigation/nav_root.dart';
import 'screens/auth/login_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/app_cache_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lernarena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const AppInitializer(),
    );
  }
}

// Initialisiert App und zeigt Splash Screen
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🔄 Initialisiere Supabase...');

      await Supabase.initialize(
        url: 'https://ybvwjmaicoffitngtmzl.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlidndqbWFpY29mZml0bmd0bXpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQyMjI3MjAsImV4cCI6MjA2OTc5ODcyMH0.JzSoVS9P5RxtNx4C2Zou_-NJbQq3TdcJd39L8WC4wGo',
      );

      print('✅ Supabase initialisiert');

      final session = Supabase.instance.client.auth.currentSession;
      print(
        '🔐 Aktuelle Session: ${session != null ? "Eingeloggt" : "Nicht eingeloggt"}',
      );

      if (session != null) {
        await AppCacheService().preloadAllData();
      }

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      print('❌ Fehler bei Initialisierung: $e');
      if (mounted) {
        setState(() => _initialized = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SplashScreen();
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      return const AuthWrapper(
        authenticatedChild: NavRoot(),
        unauthenticatedChild: LoginScreen(),
      );
    }

    return FutureBuilder<bool>(
      future: SharedPreferences.getInstance().then(
        (p) => p.getBool('hasSeenOnboarding') ?? false,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SplashScreen();
        if (snapshot.data == true) return const LoginScreen();
        return const OnboardingScreen();
      },
    );
  }
}
