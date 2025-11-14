import 'services/auth_service.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/new_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'async_match_progress.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;


// -------------------------------------------------------------
// App-Start
// -------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔄 Initialisiere Supabase...');
  
  await Supabase.initialize(
    url: 'https://ybvwjmaicoffitngtmzl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlidndqbWFpY29mZml0bmd0bXpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQyMjI3MjAsImV4cCI6MjA2OTc5ODcyMH0.JzSoVS9P5RxtNx4C2Zou_-NJbQq3TdcJd39L8WC4wGo',
  );

  print('✅ Supabase initialisiert');
  
  final session = Supabase.instance.client.auth.currentSession;
  print('🔐 Aktuelle Session: ${session != null ? "Eingeloggt" : "Nicht eingeloggt"}');

  runApp(const MyApp());
}

// -------------------------------------------------------------
// Root
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
        authenticatedChild: NavRoot(),
        unauthenticatedChild: LoginScreen(),
      ),
    );
  }
}

// -------------------------------------------------------------
// NAVIGATION SHELL (Bottom Tabs)
// -------------------------------------------------------------
class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _index = 0;

  late final List<Widget> _pages = [
    const _NavKeepAlive(child: ModulListe()),
    const _NavKeepAlive(child: SimulationPage()),
    const _NavKeepAlive(child: AdminPanel()),
    const _NavKeepAlive(child: NewProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Module',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Simulation',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

/// Hält die State der Kinder beim Tabwechsel am Leben
class _NavKeepAlive extends StatefulWidget {
  final Widget child;
  const _NavKeepAlive({required this.child});

  @override
  State<_NavKeepAlive> createState() => _NavKeepAliveState();
}

class _NavKeepAliveState extends State<_NavKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// -------------------------------------------------------------
// Simulation Page
// -------------------------------------------------------------
class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prüfungssimulation'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Async-Match (Beta)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Spiele asynchron gegen andere: Match erstellen oder zufällig beitreten.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.sports_esports),
                        label: const Text('AsyncMatch starten'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AsyncMatchDemoPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text(
                  'Hier kommt deine Simulation hin.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// MODUL LISTE
// -------------------------------------------------------------
class ModulListe extends StatefulWidget {
  const ModulListe({super.key});

  @override
  State<ModulListe> createState() => _ModulListeState();
}

class _ModulListeState extends State<ModulListe> {
  final supabase = Supabase.instance.client;
  
  List<dynamic> module = [];
  Map<int, int> anzahlFragen = {};
  Map<int, int> beantworteteFragen = {};

  @override
  void initState() {
    super.initState();
    ladeModule();
  }

  Future<void> ladeModule() async {
    try {
      final response = await supabase.from('module').select().order('id');
      
      for (var modul in response) {
        final fragen = await supabase
            .from('fragen')
            .select('id')
            .eq('modul_id', modul['id']);
        anzahlFragen[modul['id']] = fragen.length;
        beantworteteFragen[modul['id']] = await _ladeModulFortschritt(
          modul['id'],
        );
      }
      
      if (!mounted) return;
      setState(() => module = response);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Module: $e')),
      );
    }
  }

  Future<int> _ladeModulFortschritt(int modulId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'fortschritt_modul_$modulId';
      final value = prefs.get(key);
      if (value is List<String>) return value.length;
      await prefs.remove(key);
      return 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lernmodule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Admin',
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanel()),
              );
            },
          ),
        ],
      ),
      body: module.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: module.length,
              itemBuilder: (context, index) {
                final modul = module[index];
                final modulId = modul['id'];
                final gesamt = anzahlFragen[modulId] ?? 1;
                final fertig = beantworteteFragen[modulId] ?? 0;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ThemenListe(
                        modulId: modul['id'],
                        modulName: modul['name'],
                      ),
                    ),
                  ).then((_) => ladeModule()),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modul['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          modul['beschreibung'] ?? '',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (fertig / gesamt).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                          minHeight: 6,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$fertig / $gesamt Fragen richtig beantwortet',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.grey[100],
    );
  }
}

// -------------------------------------------------------------
// THEMEN LISTE
// -------------------------------------------------------------
class ThemenListe extends StatefulWidget {
  final int modulId;
  final String modulName;
  
  const ThemenListe({
    super.key,
    required this.modulId,
    required this.modulName,
  });

  @override
  State<ThemenListe> createState() => _ThemenListeState();
}

class _ThemenListeState extends State<ThemenListe> {
  final supabase = Supabase.instance.client;
  
  List<dynamic> themen = [];
  bool loading = true;
  Map<int, double> cachedScores = {};
  Map<int, int> themenRequired = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _loadThemen();
    await _loadScores();
    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> _loadThemen() async {
    try {
      final res = await supabase
          .from('themen')
          .select(
            'id, name, beschreibung, sort_index, required_score, unlocked_by',
          )
          .eq('module_id', widget.modulId)
          .order('sort_index, id');
      
      if (!mounted) return;
      
      themen = res;
      for (final t in res) {
        themenRequired[t['id'] as int] = (t['required_score'] ?? 80) as int;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Themen: $e')),
      );
    }
  }

  Future<void> _loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final t in themen) {
        final id = t['id'] as int;
        final key = _scoreKey(widget.modulId, id);
        final val = prefs.getDouble(key) ?? 0.0;
        cachedScores[id] = val;
      }
    } catch (e) {
      // Fehler beim Laden der Scores ignorieren
    }
  }

  static String _scoreKey(int modulId, int themaId) =>
      'score_mod_${modulId}_thema_$themaId';

  bool _isUnlocked(Map<String, dynamic> thema) {
    final int? unlockedBy = thema['unlocked_by'] as int?;
    if (unlockedBy == null) return true;
    final double prevScore = cachedScores[unlockedBy] ?? 0.0;
    final int needed = themenRequired[unlockedBy] ?? 80;
    return prevScore >= needed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.modulName} • Themen'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : themen.isEmpty
              ? const Center(child: Text('Keine Themen vorhanden'))
              : ListView.builder(
                  itemCount: themen.length,
                  itemBuilder: (context, i) {
                    final t = themen[i] as Map<String, dynamic>;
                    final id = t['id'] as int;
                    final unlocked = _isUnlocked(t);
                    final score = cachedScores[id] ?? 0.0;
                    
                    return Opacity(
                      opacity: unlocked ? 1.0 : 0.5,
                      child: ListTile(
                        title: Text(t['name'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((t['beschreibung'] ?? '').toString().isNotEmpty)
                              Text(t['beschreibung']),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: (score / 100).clamp(0.0, 1.0),
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade300,
                                    color: score >= (t['required_score'] ?? 80)
                                        ? Colors.green
                                        : Colors.indigo,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('${score.toStringAsFixed(0)}%'),
                              ],
                            ),
                          ],
                        ),
                        leading: Icon(
                          unlocked ? Icons.lock_open : Icons.lock_outline,
                          color: unlocked ? Colors.green : Colors.grey,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: unlocked
                            ? () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TestFragen(
                                      modulId: widget.modulId,
                                      modulName: '${widget.modulName} • ${t['name']}',
                                      themaId: id,
                                    ),
                                  ),
                                );
                                await _load();
                              }
                            : () {
                                final prevId = t['unlocked_by'];
                                final need = themenRequired[prevId] ?? 80;
                                final have = cachedScores[prevId] ?? 0.0;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Dieses Thema ist gesperrt. Vorheriges Thema mindestens $need% (aktuell ${have.toStringAsFixed(0)}%).',
                                    ),
                                  ),
                                );
                              },
                      ),
                    );
                  },
                ),
    );
  }
}

// -------------------------------------------------------------
// TEST FRAGEN
// -------------------------------------------------------------

class TestFragen extends StatefulWidget {
  final int modulId;
  final String modulName;
  final int? themaId;

  const TestFragen({
    super.key,
    required this.modulId,
    required this.modulName,
    this.themaId,
  });

  @override
  State<TestFragen> createState() => _TestFragenState();
}

class _TestFragenState extends State<TestFragen> with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  
  List<dynamic> fragen = [];
  int aktuelleFrage = 0;
  int richtig = 0;
  int falsch = 0;
  bool fertig = false;
  bool antwortGewaehlt = false;
  bool istAntwortRichtig = false;
  String erklaerung = '';
  int? gewaehlteAntwortId;
  int? richtigeAntwortId;
  
  // KI State
  bool generatingExplanation = false;
  String? aiError;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    ladeFragen();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> ladeFragen() async {
    try {
      final query = supabase
          .from('fragen')
          .select('*, antworten(id, text, ist_richtig, erklaerung)')
          .eq('modul_id', widget.modulId);

      if (widget.themaId != null) {
        query.eq('thema_id', widget.themaId);
      }

      final response = await query.order('id');
      if (!mounted) return;
      
      setState(() => fragen = response);
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Fragen: $e')),
      );
    }
  }

  Future<void> speichereFortschritt(int frageId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keyModule = 'fortschritt_mod_${widget.modulId}';
      final gespeichert = prefs.getStringList(keyModule) ?? [];
      if (!gespeichert.contains(frageId.toString())) {
        gespeichert.add(frageId.toString());
        await prefs.setStringList(keyModule, gespeichert);
      }
    } catch (e) {
      print('Fehler beim Speichern: $e');
    }
  }

  Future<void> _speichereThemaScore() async {
    if (widget.themaId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final percent = fragen.isEmpty ? 0.0 : (richtig / fragen.length) * 100.0;
      await prefs.setDouble(
        'score_mod_${widget.modulId}_thema_${widget.themaId}',
        percent,
      );
    } catch (e) {
      print('Fehler beim Speichern des Scores: $e');
    }
  }

  // ============================================================================
  // KI ERKLÄRUNGS-GENERATOR (LIVE)
  // ============================================================================
  
Future<String?> _generateLiveExplanation({
  required String frage,
  required String richtigeAntwort,
  required String falscheAntwort,
}) async {
  print('🤖 Starte KI-Generierung (Gemini)...');
  print('📝 Frage: $frage');
  
  try {
    print('📡 Sende Request an Gemini API...');
    
    final apiKey = 'AIzaSyDyHPkXXFC52DX3wquuy-Ui4F9_gbPtUF4'; 
    
    final response = await http.post(
  Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey'),
  headers: {
    'Content-Type': 'application/json',
  },
  // ... rest bleibt gleich
  // ... rest bleibt gleich
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': '''Du bist ein geduldiger IHK-Prüfungsexperte. Ein Lernender hat diese Frage falsch beantwortet.

Frage: $frage
Falsche Antwort: $falscheAntwort
Richtige Antwort: $richtigeAntwort

Erstelle eine hilfreiche, lehrreiche Erklärung (2-3 Sätze) die:
- Erklärt WARUM die richtige Antwort korrekt ist
- Den häufigen Denkfehler aufzeigt
- Dem Lernenden hilft, es beim nächsten Mal richtig zu machen
- Motivierend und freundlich formuliert ist
- Fachlich präzise ist

Antworte NUR mit der Erklärung auf Deutsch, ohne Einleitung oder Markdown.'''
              }
            ]
          }
        ]
      }),
    );

    print('📨 Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📨 Response Data: $data');
      
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        final explanation = text.toString().trim();
        print('✅ Erklärung generiert: $explanation');
        return explanation;
      }
    } else {
      print('❌ API Error: ${response.statusCode}');
      print('❌ Body: ${response.body}');
    }
    
    return null;
  } catch (e, stackTrace) {
    print('❌ KI-Fehler: $e');
    print('❌ StackTrace: $stackTrace');
    return null;
  }
}
  Future<void> pruefeAntwort(int antwortId, bool korrekt, String erklaerungText, int frageId) async {
    if (!mounted || antwortGewaehlt) return;
    
    final frage = fragen[aktuelleFrage];
    final antworten = frage['antworten'] as List<dynamic>;
    final richtigeAntwort = antworten.firstWhere(
      (a) => a['ist_richtig'] == true,
      orElse: () => antworten.first,
    );
    final gewaehlteAntwort = antworten.firstWhere((a) => a['id'] == antwortId);
    
    setState(() {
      antwortGewaehlt = true;
      istAntwortRichtig = korrekt;
      gewaehlteAntwortId = antwortId;
      richtigeAntwortId = richtigeAntwort['id'];
      
      if (korrekt) {
        richtig++;
        speichereFortschritt(frageId);
        // Bei richtiger Antwort: Vorhandene Erklärung verwenden
        erklaerung = richtigeAntwort['erklaerung']?.toString().trim() ?? 
                     frage['erklaerung']?.toString().trim() ?? 
                     'Sehr gut! Das ist die richtige Antwort.';
      } else {
        falsch++;
        // Bei falscher Antwort: Prüfe ob Erklärung vorhanden
        final vorhandeneErklaerung = richtigeAntwort['erklaerung']?.toString().trim() ?? 
                                      frage['erklaerung']?.toString().trim();
        
        if (vorhandeneErklaerung != null && vorhandeneErklaerung.isNotEmpty) {
          erklaerung = vorhandeneErklaerung;
        } else {
          // Keine Erklärung vorhanden -> KI generieren!
          erklaerung = 'Lade Erklärung...';
          generatingExplanation = true;
          aiError = null;
        }
      }
    });
    
    // KI-Erklärung generieren wenn falsch und keine vorhanden
    if (!korrekt && (erklaerung == 'Lade Erklärung...')) {
      final aiErklaerung = await _generateLiveExplanation(
        frage: frage['frage'] as String,
        richtigeAntwort: richtigeAntwort['text'] as String,
        falscheAntwort: gewaehlteAntwort['text'] as String,
      );
      
      if (!mounted) return;
      
      setState(() {
        generatingExplanation = false;
        
        if (aiErklaerung != null) {
          erklaerung = aiErklaerung;
          
          // Optional: Speichere in DB für nächstes Mal
          _saveExplanationToDB(richtigeAntwort['id'] as int, aiErklaerung);
        } else {
          erklaerung = 'Die richtige Antwort lautet: ${richtigeAntwort['text']}';
          aiError = 'Erklärung konnte nicht generiert werden';
        }
      });
    }
  }

  Future<void> _saveExplanationToDB(int antwortId, String erklaerung) async {
    try {
      await supabase
          .from('antworten')
          .update({'erklaerung': erklaerung})
          .eq('id', antwortId);
      print('✅ Erklärung in DB gespeichert');
    } catch (e) {
      print('⚠️ Konnte Erklärung nicht speichern: $e');
    }
  }

  void naechsteFrage() async {
    if (aktuelleFrage + 1 < fragen.length) {
      if (!mounted) return;
      
      _animationController.reset();
      
      setState(() {
        aktuelleFrage++;
        antwortGewaehlt = false;
        erklaerung = '';
        gewaehlteAntwortId = null;
        richtigeAntwortId = null;
        generatingExplanation = false;
        aiError = null;
      });
      
      _animationController.forward();
    } else {
      await _speichereThemaScore();
      if (!mounted) return;
      setState(() => fertig = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fragen.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.modulName),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (fertig) {
      return _buildErgebnisScreen();
    }

    final frage = fragen[aktuelleFrage];
    final antworten = (frage['antworten'] as List<dynamic>).toList()..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modulName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildFrageCard(frage),
                      const SizedBox(height: 20),
                      
                      if (!antwortGewaehlt)
                        _buildAntwortenListe(antworten, frage['id'])
                      else
                        _buildErgebnisCard(antworten),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          if (antwortGewaehlt) _buildWeiterButton(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    final progress = (aktuelleFrage + 1) / fragen.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frage ${aktuelleFrage + 1}/${fragen.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _buildStatChip(Icons.check_circle, richtig, Colors.green),
                  const SizedBox(width: 8),
                  _buildStatChip(Icons.cancel, falsch, Colors.red),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.indigo,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrageCard(Map<String, dynamic> frage) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.quiz,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Frage ${aktuelleFrage + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              frage['frage'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAntwortenListe(List<dynamic> antworten, int frageId) {
    return Column(
      children: antworten.asMap().entries.map((entry) {
        final index = entry.key;
        final antwort = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAntwortButton(antwort, frageId),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAntwortButton(Map<String, dynamic> antwort, int frageId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => pruefeAntwort(
          antwort['id'],
          antwort['ist_richtig'] == true,
          antwort['erklaerung'] ?? '',
          frageId,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.indigo,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  antwort['text'],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErgebnisCard(List<dynamic> antworten) {
    return Column(
      children: [
        // Feedback Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: istAntwortRichtig 
              ? Colors.green.shade50 
              : Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: istAntwortRichtig 
                ? Colors.green.shade200 
                : Colors.red.shade200,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                istAntwortRichtig ? Icons.check_circle : Icons.cancel,
                color: istAntwortRichtig ? Colors.green : Colors.red,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      istAntwortRichtig ? 'Richtig! 🎉' : 'Leider falsch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: istAntwortRichtig 
                          ? Colors.green.shade800 
                          : Colors.red.shade800,
                      ),
                    ),
                    if (!istAntwortRichtig)
                      Text(
                        generatingExplanation 
                          ? 'KI erstellt Erklärung...'
                          : 'Schau dir die Erklärung an',
                        style: TextStyle(
                          color: Colors.red.shade700,
                        ),
                      ),
                  ],
                ),
              ),
              if (generatingExplanation)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Antworten anzeigen
        ...antworten.map((a) {
          final istRichtig = a['ist_richtig'] == true;
          final wurdeGewaehlt = a['id'] == gewaehlteAntwortId;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: istRichtig 
                  ? Colors.green.shade50 
                  : (wurdeGewaehlt ? Colors.red.shade50 : Colors.grey.shade50),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: istRichtig 
                    ? Colors.green 
                    : (wurdeGewaehlt ? Colors.red : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    istRichtig ? Icons.check_circle : 
                    (wurdeGewaehlt ? Icons.cancel : Icons.circle_outlined),
                    color: istRichtig ? Colors.green : 
                    (wurdeGewaehlt ? Colors.red : Colors.grey),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      a['text'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: istRichtig ? FontWeight.bold : FontWeight.normal,
                        color: istRichtig ? Colors.green.shade900 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        
        // Erklärung (mit KI-Loading oder fertige Erklärung)
        if (erklaerung.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      generatingExplanation 
                        ? Icons.auto_awesome 
                        : Icons.lightbulb,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      generatingExplanation ? 'KI erklärt...' : 'Erklärung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    if (generatingExplanation) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  erklaerung,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.blue.shade900,
                  ),
                ),
                if (aiError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '⚠️ $aiError',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeiterButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: generatingExplanation ? null : naechsteFrage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (generatingExplanation)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Text(
                  aktuelleFrage + 1 >= fragen.length 
                    ? 'Ergebnis anzeigen' 
                    : 'Nächste Frage',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (!generatingExplanation) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErgebnisScreen() {
    final prozent = ((richtig / fragen.length) * 100).round();
    final Color scoreColor = prozent >= 80 
      ? Colors.green 
      : (prozent >= 50 ? Colors.orange : Colors.red);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modulName),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scoreColor.withOpacity(0.2),
                      scoreColor.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(color: scoreColor, width: 8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$prozent%',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        prozent >= 80 ? 'Bestanden!' : 'Weiter üben',
                        style: TextStyle(
                          fontSize: 16,
                          color: scoreColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildStatRow(
                        'Richtig beantwortet',
                        '$richtig / ${fragen.length}',
                        Colors.green,
                        Icons.check_circle,
                      ),
                      const Divider(height: 32),
                      _buildStatRow(
                        'Falsch beantwortet',
                        '$falsch / ${fragen.length}',
                        Colors.red,
                        Icons.cancel,
                      ),
                      const Divider(height: 32),
                      _buildStatRow(
                        'Erfolgsquote',
                        '$prozent%',
                        scoreColor,
                        Icons.trending_up,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück zur Übersicht'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    aktuelleFrage = 0;
                    richtig = 0;
                    falsch = 0;
                    fertig = false;
                    antwortGewaehlt = false;
                  });
                  ladeFragen();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Nochmal üben'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
// -------------------------------------------------------------
// ADMIN PANEL
// -------------------------------------------------------------
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final supabase = Supabase.instance.client;
  
  List<dynamic> module = [];
  int? selectedModuleId;
  List<dynamic> themen = [];
  List<dynamic> fragen = [];
  bool loading = false;
  
  // KI Generation State
  Map<int, bool> generatingAI = {}; // antwort_id -> loading
  Map<int, String> aiErrors = {}; // antwort_id -> error message

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => loading = true);
    try {
      final mods = await supabase.from('module').select('id, name').order('id');
      if (!mounted) return;
      setState(() => module = mods);
    } catch (e) {
      _snack('Fehler beim Laden der Module: $e');
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> _loadThemen(int modulId) async {
    try {
      final res = await supabase
          .from('themen')
          .select('id, name, beschreibung, sort_index, required_score, unlocked_by')
          .eq('module_id', modulId)
          .order('sort_index, name');
      if (!mounted) return;
      setState(() => themen = res);
    } catch (e) {
      _snack('Fehler beim Laden der Themen: $e');
    }
  }

  Future<void> _loadFragenForModule(int modulId) async {
    setState(() {
      loading = true;
      selectedModuleId = modulId;
      fragen = [];
      themen = [];
    });
    try {
      await _loadThemen(modulId);
      final res = await supabase
          .from('fragen')
          .select('id, frage, erklaerung, modul_id, thema_id, antworten(id, text, ist_richtig, erklaerung)')
          .eq('modul_id', modulId)
          .order('id');
      if (!mounted) return;
      setState(() => fragen = res);
    } catch (e) {
      _snack('Fehler beim Laden der Fragen: $e');
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ============================================================================
  // KI ERKLÄRUNGS-GENERATOR
  // ============================================================================
  
  Future<void> _generateAIExplanation({
    required int antwortId,
    required String frage,
    required String antwort,
  }) async {
    setState(() {
      generatingAI[antwortId] = true;
      aiErrors.remove(antwortId);
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 1000,
          'messages': [
            {
              'role': 'user',
              'content': '''Du bist ein IHK-Prüfungsexperte. Erstelle eine präzise, lehrreiche Erklärung (1-2 Sätze) für diese Frage und Antwort:

Frage: $frage
Richtige Antwort: $antwort

Die Erklärung soll:
- Kurz und verständlich sein (max. 2 Sätze)
- Den Lerneffekt maximieren
- Erklären WARUM die Antwort richtig ist
- Fachlich korrekt sein
- Auf Deutsch sein

Antworte NUR mit der Erklärung, ohne Einleitung oder Markdown.'''
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['content'] != null && data['content'].isNotEmpty) {
          final erklaerung = data['content'][0]['text'].toString().trim();
          
          // Speichere in Supabase
          await supabase
              .from('antworten')
              .update({'erklaerung': erklaerung})
              .eq('id', antwortId);
          
          if (!mounted) return;
          
          _snack('✅ Erklärung generiert und gespeichert!');
          
          // Reload Fragen
          if (selectedModuleId != null) {
            await _loadFragenForModule(selectedModuleId!);
          }
        } else {
          throw Exception('Keine Erklärung erhalten');
        }
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        aiErrors[antwortId] = e.toString();
      });
      _snack('❌ Fehler: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        generatingAI[antwortId] = false;
      });
    }
  }

  // Generiere Erklärungen für ALLE richtigen Antworten einer Frage
  Future<void> _generateAllExplanations(Map<String, dynamic> frage) async {
    final antworten = (frage['antworten'] ?? []) as List<dynamic>;
    final richtigeAntworten = antworten.where((a) => a['ist_richtig'] == true).toList();
    
    if (richtigeAntworten.isEmpty) {
      _snack('⚠️ Keine richtige Antwort gefunden');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('KI-Erklärungen generieren?'),
        content: Text(
          'Soll Claude Erklärungen für ${richtigeAntworten.length} richtige Antwort(en) erstellen?\n\n'
          'Dies überschreibt vorhandene Erklärungen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generieren'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    for (final antwort in richtigeAntworten) {
      await _generateAIExplanation(
        antwortId: antwort['id'] as int,
        frage: frage['frage'] as String,
        antwort: antwort['text'] as String,
      );
      
      // Kurze Pause zwischen Requests
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // ============================================================================
  // BESTEHENDE ADMIN FUNCTIONS (Dialoge, etc.)
  // ============================================================================
  
  Future<void> _editFrageDialog(Map<String, dynamic> frage) async {
    final frageCtrl = TextEditingController(text: frage['frage'] ?? '');
    final erkCtrl = TextEditingController(text: (frage['erklaerung'] ?? '').toString());
    int? selectedThemaId = frage['thema_id'] as int?;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Frage bearbeiten'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: frageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Fragetext',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  value: selectedThemaId,
                  decoration: const InputDecoration(
                    labelText: 'Thema (Untermodul)',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int?>(value: null, child: Text('— Kein Thema —')),
                    ...themen.map<DropdownMenuItem<int?>>((t) => DropdownMenuItem(
                      value: t['id'] as int,
                      child: Text(t['name'] ?? ''),
                    )),
                  ],
                  onChanged: (v) => selectedThemaId = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: erkCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Erklärung (Frage, Fallback)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase
                    .from('fragen')
                    .update({
                      'frage': frageCtrl.text.trim(),
                      'erklaerung': erkCtrl.text.trim(),
                      'thema_id': selectedThemaId,
                    })
                    .eq('id', frage['id']);
                Navigator.pop(context);
                _snack('Frage aktualisiert');
                if (selectedModuleId != null) {
                  _loadFragenForModule(selectedModuleId!);
                }
              } catch (e) {
                _snack('Fehler beim Speichern: $e');
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Future<void> _editAntwortDialog(Map<String, dynamic> antwort, String frageText) async {
    final textCtrl = TextEditingController(text: antwort['text'] ?? '');
    final erkCtrl = TextEditingController(text: (antwort['erklaerung'] ?? '').toString());
    bool istRichtig = (antwort['ist_richtig'] == true);

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setSB) => AlertDialog(
          title: const Text('Antwort bearbeiten'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: textCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Antworttext',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Ist richtig?'),
                    value: istRichtig,
                    onChanged: (v) => setSB(() => istRichtig = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: erkCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Erklärung (Antwort-spezifisch)',
                      border: OutlineInputBorder(),
                      helperText: 'Oder nutze KI-Generator unten ⬇️',
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 12),
                  
                  // KI-Generator Button
                  if (istRichtig)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Mit KI generieren'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _generateAIExplanation(
                          antwortId: antwort['id'] as int,
                          frage: frageText,
                          antwort: textCtrl.text.trim(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await supabase
                      .from('antworten')
                      .update({
                        'text': textCtrl.text.trim(),
                        'ist_richtig': istRichtig,
                        'erklaerung': erkCtrl.text.trim(),
                      })
                      .eq('id', antwort['id']);
                  Navigator.pop(context);
                  _snack('Antwort aktualisiert');
                  if (selectedModuleId != null) {
                    _loadFragenForModule(selectedModuleId!);
                  }
                } catch (e) {
                  _snack('Fehler beim Speichern: $e');
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // UI BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin – KI-gestützte Verwaltung'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.purple),
            tooltip: 'KI-Features',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('KI-Funktionen'),
                    ],
                  ),
                  content: const Text(
                    'Diese Version nutzt Claude AI um automatisch lehrreiche Erklärungen zu generieren.\n\n'
                    '• Klicke auf "🤖 KI" bei einer Frage um alle Erklärungen zu generieren\n'
                    '• Oder bearbeite einzelne Antworten und nutze "Mit KI generieren"\n\n'
                    'Die Erklärungen werden automatisch in der Datenbank gespeichert.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Verstanden'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Sidebar: Module
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Module',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: module.length,
                          itemBuilder: (context, i) {
                            final m = module[i];
                            final active = selectedModuleId == m['id'];
                            return ListTile(
                              selected: active,
                              selectedTileColor: Colors.indigo.shade50,
                              title: Text(m['name'] ?? ''),
                              onTap: () => _loadFragenForModule(m['id']),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                
                // Main Content: Fragen
                Expanded(
                  child: selectedModuleId == null
                      ? const Center(child: Text('Bitte ein Modul auswählen.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: fragen.length,
                          itemBuilder: (context, i) {
                            final f = fragen[i];
                            final List<dynamic> antw = (f['antworten'] ?? []) as List<dynamic>;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Frage Header
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Q${f['id']}: ${f['frage']}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // KI Button für alle Antworten
                                        IconButton(
                                          tooltip: 'KI-Erklärungen für alle generieren',
                                          icon: const Icon(Icons.auto_awesome, color: Colors.purple),
                                          onPressed: () => _generateAllExplanations(f as Map<String, dynamic>),
                                        ),
                                        IconButton(
                                          tooltip: 'Frage bearbeiten',
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editFrageDialog(f as Map<String, dynamic>),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Antworten
                                    const Text(
                                      'Antworten:',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    ...antw.map((a) {
                                      final bool ok = a['ist_richtig'] == true;
                                      final int aId = a['id'] as int;
                                      final bool isGenerating = generatingAI[aId] == true;
                                      final String? error = aiErrors[aId];
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: ok ? Colors.green.shade50 : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: ok ? Colors.green.shade200 : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(a['text'] ?? ''),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if ((a['erklaerung'] ?? '').toString().trim().isNotEmpty)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 4),
                                                      child: Text(
                                                        '💡 ${a['erklaerung']}',
                                                        style: TextStyle(
                                                          color: Colors.blue.shade800,
                                                          fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ),
                                                  if (error != null)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 4),
                                                      child: Text(
                                                        '❌ $error',
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // KI Button für einzelne Antwort
                                                  if (ok && !isGenerating)
                                                    IconButton(
                                                      tooltip: 'KI-Erklärung generieren',
                                                      icon: const Icon(Icons.auto_awesome, size: 20),
                                                      color: Colors.purple,
                                                      onPressed: () => _generateAIExplanation(
                                                        antwortId: aId,
                                                        frage: f['frage'] as String,
                                                        antwort: a['text'] as String,
                                                      ),
                                                    ),
                                                  if (isGenerating)
                                                    const Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                                      child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(strokeWidth: 2),
                                                      ),
                                                    ),
                                                  IconButton(
                                                    tooltip: 'Antwort bearbeiten',
                                                    icon: const Icon(Icons.edit, size: 20),
                                                    onPressed: () => _editAntwortDialog(
                                                      a as Map<String, dynamic>,
                                                      f['frage'] as String,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
// ======================= AsyncDuelService ============================
class AsyncDuelService {
  final c = Supabase.instance.client;

  Future<String> createMatch({int count = 10}) async {
    final id = await c.rpc(
      'create_async_match_any',
      params: {'p_count': count},
    );
    return id as String;
  }

  Future<String?> joinRandomMatch() async {
    final id = await c.rpc('join_random_open_match');
    return id == null ? null : id as String;
  }

  Future<bool> submitAnswer({
    required String matchId,
    required int idx,
    required int answerId,
  }) async {
    final done = await c.rpc(
      'submit_async_answer',
      params: {'p_match': matchId, 'p_idx': idx, 'p_antwort_id': answerId},
    );
    return (done as bool? ?? false);
  }

  Future<String> tryFinalize(String matchId) async {
    final status = await c.rpc(
      'try_finalize_match',
      params: {'p_match': matchId},
    );
    return status as String;
  }

  Future<Map<String, dynamic>> loadMatch(String matchId) async {
    final q = await c
        .from('match_questions')
        .select(
          'idx, frage_id, fragen:frage_id(id, frage, antworten(id, text, ist_richtig))',
        )
        .eq('match_id', matchId)
        .order('idx');

    final myId = c.auth.currentUser?.id;
    final myAnswers = (myId == null)
        ? <dynamic>[]
        : await c
              .from('match_answers')
              .select('idx, antwort_id, is_correct')
              .eq('match_id', matchId)
              .eq('user_id', myId);

    return {'questions': q, 'myAnswers': myAnswers};
  }

  Future<Map<String, dynamic>?> loadScores(String matchId) async {
    final rows = await c
        .from('match_scores')
        .select()
        .eq('match_id', matchId)
        .maybeSingle();
    return rows;
  }
}

// ============================================================================
// ASYNC MATCH – Demo-Seite
// ============================================================================
class AsyncMatchDemoPage extends StatefulWidget {
  const AsyncMatchDemoPage({super.key});

  @override
  State<AsyncMatchDemoPage> createState() => _AsyncMatchDemoPageState();
}

class _AsyncMatchDemoPageState extends State<AsyncMatchDemoPage> {
  final _svc = AsyncDuelService();
  AsyncMatchProgressStore? _store;
  AsyncMatchProgress? _progress;
  String? _matchId;
  bool _busy = false;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  Future<void> _attachProgress(String matchId) async {
    _store ??= await AsyncMatchProgressStore.instance;
    _progress = await _store!.ensure(_userId, matchId);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _createMatch() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.createMatch(count: 10);
      _matchId = id;
      await _attachProgress(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Erstellen: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinRandom() async {
    setState(() => _busy = true);
    try {
      final id = await _svc.joinRandomMatch();
      if (id == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kein offenes Match gefunden')),
        );
        return;
      }
      _matchId = id;
      await _attachProgress(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Beitreten: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMatch = _matchId != null && _progress != null;
    final info = hasMatch
        ? 'Match: $_matchId • Aktuelle Frage: ${_progress!.currentIdx + 1}'
        : 'Kein aktives Match';

    return Scaffold(
      appBar: AppBar(title: const Text('AsyncMatch (Beta)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_busy) const LinearProgressIndicator(),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(info),
              subtitle: const Text('Fortschritt wird lokal gespeichert.'),
              trailing: hasMatch
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AsyncMatchPlayPage(matchId: _matchId!),
                          ),
                        );
                      },
                      child: const Text('Weiter spielen'),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Match erstellen'),
                onPressed: _busy ? null : _createMatch,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.shuffle),
                label: const Text('Zufällig beitreten'),
                onPressed: _busy ? null : _joinRandom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ASYNC MATCH – Spielseite
// ============================================================================
class AsyncMatchPlayPage extends StatefulWidget {
  final String matchId;
  const AsyncMatchPlayPage({super.key, required this.matchId});

  @override
  State<AsyncMatchPlayPage> createState() => _AsyncMatchPlayPageState();
}

class _AsyncMatchPlayPageState extends State<AsyncMatchPlayPage> {
  final _svc = AsyncDuelService();

  AsyncMatchProgressStore? _store;
  AsyncMatchProgress? _progress;

  List<dynamic> _questions = [];
  int _idx = 0;
  bool _loading = true;

  bool _answered = false;
  bool _submitting = false;
  bool _wasCorrect = false;
  int? _selectedAnswerId;

  bool _matchCompleted = false;
  Map<String, dynamic>? _finalScores;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'local';

  @override
  void initState() {
    super.initState();
    _init();
  }

Future<void> _init() async {
  try {
    print('🟢 _init() gestartet für Match: ${widget.matchId}');
    
    _store ??= await AsyncMatchProgressStore.instance;
    _progress = await _store!.ensure(_userId, widget.matchId);
    _idx = (_progress!.currentIdx).clamp(0, 1 << 30);

    print('🟡 Lade Match-Daten...');
    final data = await _svc.loadMatch(widget.matchId);
    print('🟢 Match-Daten geladen: ${data}');
    
    final q = (data['questions'] as List<dynamic>).toList()
      ..sort((a, b) => (a['idx'] as int).compareTo(b['idx'] as int));
    
    print('🟢 Anzahl Fragen: ${q.length}');
    _questions = q;

    if (_idx >= _questions.length) {
      print('⚠️ Alle Fragen beantwortet, finalisiere...');
      await _tryFinalize();
    }
  } catch (e, stackTrace) {
    print('🔴 FEHLER in _init:');
    print('🔴 Error: $e');
    print('🔴 StackTrace: $stackTrace');
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fehler beim Laden: $e')),
    );
  } finally {
    if (!mounted) return;
    setState(() => _loading = false);
  }
}

  Future<void> _submit(int answerId, bool correct) async {
    if (_submitting || _answered) return;
    
    setState(() {
      _submitting = true;
      _selectedAnswerId = answerId;
    });

    final q = _questions[_idx];
    
    try {
      final ok = await _svc.submitAnswer(
        matchId: widget.matchId,
        idx: q['idx'] as int,
        answerId: answerId,
      );

      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Antwort nicht akzeptiert ❌')),
          );
          setState(() {
            _submitting = false;
            _selectedAnswerId = null;
          });
        }
        return;
      }

      _progress!.answers[_idx] = answerId;
      await _store!.save(_progress!);

      if (mounted) {
        setState(() {
          _answered = true;
          _wasCorrect = correct;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Senden: $e')),
        );
        setState(() {
          _submitting = false;
          _selectedAnswerId = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _nextQuestion() async {
    final nextIdx = _idx + 1;
    
    if (nextIdx >= _questions.length) {
      await _tryFinalize();
      return;
    }

    _progress!.currentIdx = nextIdx;
    await _store!.save(_progress!);

    setState(() {
      _idx = nextIdx;
      _answered = false;
      _wasCorrect = false;
      _selectedAnswerId = null;
    });
  }

  Future<void> _tryFinalize() async {
    try {
      final status = await _svc.tryFinalize(widget.matchId);
      
      if (status == 'finalized') {
        final scores = await _svc.loadScores(widget.matchId);
        if (mounted) {
          setState(() {
            _matchCompleted = true;
            _finalScores = scores;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _matchCompleted = true;
            _finalScores = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Finalisieren: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match spielen')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match spielen')),
        body: const Center(child: Text('Keine Fragen im Match.')),
      );
    }

    if (_matchCompleted) {
      return _buildCompletionScreen();
    }

    final q = _questions[_idx];
    final frage = q['fragen'] as Map<String, dynamic>;

    final List<Map<String, dynamic>> answers =
        (frage['antworten'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList()
          ..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text('Frage ${_idx + 1} von ${_questions.length}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_idx + 1) / _questions.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.indigo,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  'Match: ${widget.matchId.substring(0, 8)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (frage['frage'] ?? '').toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_answered) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _wasCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _wasCorrect
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _wasCorrect
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _wasCorrect ? 'Richtig! ✓' : 'Falsch ✗',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _wasCorrect
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Column(
                          children: [
                            for (final a in answers)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                    backgroundColor: _answered
                                        ? (a['ist_richtig'] == true
                                            ? Colors.green.shade100
                                            : (_selectedAnswerId == a['id']
                                                ? Colors.red.shade100
                                                : Colors.grey.shade100))
                                        : Colors.indigo.shade50,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: (_submitting || _answered)
                                      ? null
                                      : () => _submit(
                                          (a['id'] as num).toInt(),
                                          (a['ist_richtig'] == true),
                                        ),
                                  child: Row(
                                    children: [
                                      if (_answered &&
                                          a['ist_richtig'] == true)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      if (_answered &&
                                          _selectedAnswerId == a['id'] &&
                                          a['ist_richtig'] != true)
                                        const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      if (_answered) const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          (a['text'] ?? '').toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_answered)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: _nextQuestion,
                  child: Text(
                    _idx + 1 >= _questions.length
                        ? 'Match abschließen'
                        : 'Nächste Frage',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    if (_finalScores == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Match abgeschlossen'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Warte auf den anderen Spieler...',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Status aktualisieren'),
                onPressed: () => _tryFinalize(),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zurück zur Übersicht'),
              ),
            ],
          ),
        ),
      );
    }

    final p1Score = _finalScores!['player1_score'] as int? ?? 0;
    final p2Score = _finalScores!['player2_score'] as int? ?? 0;
    final myUserId = _userId;
    final p1Id = _finalScores!['player1_id'] as String?;
    
    final myScore = (p1Id == myUserId) ? p1Score : p2Score;
    final oppScore = (p1Id == myUserId) ? p2Score : p1Score;
    
    final won = myScore > oppScore;
    final draw = myScore == oppScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Ergebnis'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                won
                    ? Icons.emoji_events
                    : (draw ? Icons.handshake : Icons.sentiment_neutral),
                size: 80,
                color: won
                    ? Colors.amber
                    : (draw ? Colors.blue : Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                won ? 'Gewonnen! 🎉' : (draw ? 'Unentschieden' : 'Verloren'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dein Score:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '$myScore',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Gegner:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '$oppScore',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück zur Übersicht'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}