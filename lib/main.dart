// import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'widgets/navigation/nav_root.dart';
import 'screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -------------------------------------------------------------
// App-Start
// -------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const MyApp());
}

// -------------------------------------------------------------
// Root App
// -------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHK App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: AuthWrapper(
        authenticatedChild: const NavRoot(),
        unauthenticatedChild: const LoginScreen(),
      ),
    );
  }
}