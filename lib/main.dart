import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ybvwjmaicoffitngtmzl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlidndqbWFpY29mZml0bmd0bXpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQyMjI3MjAsImV4cCI6MjA2OTc5ODcyMH0.JzSoVS9P5RxtNx4C2Zou_-NJbQq3TdcJd39L8WC4wGo',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHK App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: NavRoot(),
    );
  }
}



/// ============================================================================
/// NAVIGATION SHELL (Bottom Tabs via Material NavigationBar)
/// ============================================================================

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  State<NavRoot> createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _index = 0;

  // KEIN const – da einige Kinder nicht-const sind (z.B. ModulListe, AdminPanel).
  late final List<Widget> _pages = [
    _NavKeepAlive(child: ModulListe()),
    _NavKeepAlive(child: SimulationPage()),
    _NavKeepAlive(child: AdminPanel()),
    _NavKeepAlive(child: ProfilePage()),
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

/// Hält die State der Kinder beim Tabwechsel am Leben (kein Reload).
class _NavKeepAlive extends StatefulWidget {
  final Widget child;
  const _NavKeepAlive({required this.child, super.key});

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

/// ============================================================================
/// Platzhalter-Seiten für Tabs (lauffähig, später ersetzen)
/// ============================================================================

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
      body: const Center(
        child: Text('Hier kommt deine Simulation hin.'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Einstellungen'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Benutzername'),
            subtitle: Text('Max Mustermann'),
          ),
          const Divider(),
          SwitchListTile(
            value: true,
            onChanged: (v) {},
            title: const Text('Benachrichtigungen'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Abmelden'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout (Demo)')),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// AB HIER: DEIN BESTEHENDER CODE – STRUKTUR UNVERÄNDERT
/// ============================================================================

class ModulListe extends StatefulWidget {
  @override
  _ModulListeState createState() => _ModulListeState();
}

class _ModulListeState extends State<ModulListe> {
  List<dynamic> module = [];
  Map<int, int> anzahlFragen = {};
  Map<int, int> beantworteteFragen = {};

  @override
  void initState() {
    super.initState();
    ladeModule();
  }

  Future<void> ladeModule() async {
    final response = await supabase.from('module').select().order('id');
    for (var modul in response) {
      final fragen = await supabase
          .from('fragen')
          .select('id')
          .eq('modul_id', modul['id']);
      anzahlFragen[modul['id']] = fragen.length;
      beantworteteFragen[modul['id']] = await _ladeModulFortschritt(modul['id']);
    }
    setState(() => module = response);
  }

  Future<int> _ladeModulFortschritt(int modulId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'fortschritt_modul_$modulId';
    final value = prefs.get(key);
    if (value is List<String>) return value.length;
    await prefs.remove(key);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lernmodule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Admin',
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanel()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
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
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(modul['name'] ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(modul['beschreibung'] ?? '',
                      style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (fertig / gesamt).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.green,
                    minHeight: 6,
                  ),
                  SizedBox(height: 4),
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

/* ------------------------- THEMEN LISTE (UNTERMODULE) --------------------- */

class ThemenListe extends StatefulWidget {
  final int modulId;
  final String modulName;
  const ThemenListe({required this.modulId, required this.modulName});

  @override
  State<ThemenListe> createState() => _ThemenListeState();
}

class _ThemenListeState extends State<ThemenListe> {
  List<dynamic> themen = [];
  bool loading = true;
  Map<int, double> cachedScores = {}; // score je Thema (0..100)
  Map<int, int> themenRequired = {};  // required_score je Thema

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _loadThemen();
    await _loadScores();
    setState(() => loading = false);
  }

  Future<void> _loadThemen() async {
    final res = await supabase
        .from('themen')
        .select('id, name, beschreibung, sort_index, required_score, unlocked_by')
        .eq('module_id', widget.modulId)
        .order('sort_index, id');
    themen = res;
    for (final t in res) {
      themenRequired[t['id'] as int] = (t['required_score'] ?? 80) as int;
    }
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    for (final t in themen) {
      final id = t['id'] as int;
      final key = _scoreKey(widget.modulId, id);
      final val = prefs.getDouble(key) ?? 0.0;
      cachedScores[id] = val;
    }
  }

  static String _scoreKey(int modulId, int themaId) =>
      'score_mod_${modulId}_thema_${themaId}';

  bool _isUnlocked(Map<String, dynamic> thema) {
    final int? unlockedBy = thema['unlocked_by'] as int?;
    if (unlockedBy == null) return true; // erstes Thema
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
                            setState(() {});
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

/* ----------------------------- TEST FRAGEN ------------------------------- */

class TestFragen extends StatefulWidget {
  final int modulId;
  final String modulName;
  final int? themaId;

  TestFragen({required this.modulId, required this.modulName, this.themaId});

  @override
  _TestFragenState createState() => _TestFragenState();
}

class _TestFragenState extends State<TestFragen> {
  List<dynamic> fragen = [];
  int aktuelleFrage = 0;
  int richtig = 0;
  bool fertig = false;
  bool antwortGewaehlt = false;
  bool istAntwortRichtig = false;
  String erklaerung = '';
  int? pressedIndex;

  @override
  void initState() {
    super.initState();
    ladeFragen();
  }

  Future<void> ladeFragen() async {
    final query = supabase
        .from('fragen')
        .select('*, antworten(id, text, ist_richtig, erklaerung)')
        .eq('modul_id', widget.modulId);

    if (widget.themaId != null) {
      query.eq('thema_id', widget.themaId);
    }

    final response = await query.order('id');
    setState(() => fragen = response);
  }

  Future<void> speichereFortschritt(int frageId) async {
    final prefs = await SharedPreferences.getInstance();
    final keyModule = 'fortschritt_mod_${widget.modulId}';
    final gespeichert = prefs.getStringList(keyModule) ?? [];
    if (!gespeichert.contains(frageId.toString())) {
      gespeichert.add(frageId.toString());
      await prefs.setStringList(keyModule, gespeichert);
    }
  }

  Future<void> _speichereThemaScore() async {
    if (widget.themaId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final percent = fragen.isEmpty ? 0.0 : (richtig / fragen.length) * 100.0;
    await prefs.setDouble('score_mod_${widget.modulId}_thema_${widget.themaId}', percent);
  }

  void pruefeAntwort(bool korrekt, String erklaerungText, int frageId) {
    setState(() {
      antwortGewaehlt = true;
      istAntwortRichtig = korrekt;
      erklaerung = erklaerungText;
      pressedIndex = null;
      if (korrekt) {
        richtig++;
        speichereFortschritt(frageId);
      }
    });
  }

  void naechsteFrage() async {
    if (aktuelleFrage + 1 < fragen.length) {
      setState(() {
        aktuelleFrage++;
        antwortGewaehlt = false;
        erklaerung = '';
      });
    } else {
      await _speichereThemaScore();
      setState(() => fertig = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fragen.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.modulName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (fertig) {
      final prozent = ((richtig / fragen.length) * 100).round();
      return Scaffold(
        appBar: AppBar(title: Text(widget.modulName)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text('Test abgeschlossen!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Du hast $richtig von ${fragen.length} Fragen richtig. ($prozent%)'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zur Themenübersicht'),
              ),
            ],
          ),
        ),
      );
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
          Padding(
            padding: const EdgeInsets.all(16.0), // benannt ✅
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (aktuelleFrage + 1) / fragen.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.indigo,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text('Frage ${aktuelleFrage + 1} von ${fragen.length}',
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // benannt ✅
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // benannt ✅
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(frage['frage'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: !antwortGewaehlt
                              ? Column(
                                  children: [
                                    for (int i = 0; i < antworten.length; i++)
                                      AnimatedScale(
                                        duration: const Duration(milliseconds: 150),
                                        scale: 1.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6.0), // benannt ✅
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.indigo.shade50,
                                              foregroundColor: Colors.black,
                                              padding: const EdgeInsets.all(14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              pruefeAntwort(
                                                antworten[i]['ist_richtig'] == true,
                                                (antworten[i]['erklaerung'] ??
                                                        frage['erklaerung'] ??
                                                        '') as String,
                                                frage['id'],
                                              );
                                            },
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(antworten[i]['text']),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: istAntwortRichtig
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            istAntwortRichtig
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: istAntwortRichtig
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            istAntwortRichtig ? 'Richtig!' : 'Falsch!',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: istAntwortRichtig
                                                  ? Colors.green.shade800
                                                  : Colors.red.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...antworten.map(
                                      (a) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0), // benannt ✅
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: a['ist_richtig'] == true
                                                ? Colors.green.shade100
                                                : Colors.red.shade100,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.all(14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: null,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(a['text']),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Card(
                                      color: Colors.blue.shade50,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0), // benannt ✅
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Erklärung:',
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              erklaerung.isNotEmpty
                                                  ? erklaerung
                                                  : 'Keine Erklärung vorhanden.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (antwortGewaehlt)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // benannt ✅
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: naechsteFrage,
                  child: const Center(child: Text('Nächste Frage')),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<dynamic> module = [];
  int? selectedModuleId;

  List<dynamic> themen = [];
  List<dynamic> fragen = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  /* --------------------------- Laden --------------------------- */

  Future<void> _loadModules() async {
    setState(() => loading = true);
    try {
      final mods = await supabase.from('module').select('id, name').order('id');
      setState(() => module = mods);
    } catch (e) {
      _snack('Fehler beim Laden der Module: $e');
    } finally {
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
          .select(
              'id, frage, erklaerung, modul_id, thema_id, antworten(id, text, ist_richtig, erklaerung)')
          .eq('modul_id', modulId)
          .order('id');
      setState(() => fragen = res);
    } catch (e) {
      _snack('Fehler beim Laden der Fragen: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /* ------------------ Dialoge: Frage bearbeiten/anlegen ------------------ */

  Future<void> _editFrageDialog(Map<String, dynamic> frage) async {
    final frageCtrl = TextEditingController(text: frage['frage'] ?? '');
    final erkCtrl =
        TextEditingController(text: (frage['erklaerung'] ?? '').toString());
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
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('— Kein Thema —'),
                    ),
                    ...themen.map<DropdownMenuItem<int?>>(
                      (t) => DropdownMenuItem(
                        value: t['id'] as int,
                        child: Text(t['name'] ?? ''),
                      ),
                    ),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
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
                if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
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

  Future<void> _addFrageDialog() async {
    if (selectedModuleId == null) return;
    final frageCtrl = TextEditingController();
    final erkCtrl = TextEditingController();
    int? selectedThemaId;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Neue Frage anlegen'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('— Kein Thema —'),
                  ),
                  ...themen.map<DropdownMenuItem<int?>>(
                    (t) => DropdownMenuItem(
                      value: t['id'] as int,
                      child: Text(t['name'] ?? ''),
                    ),
                  ),
                ],
                onChanged: (v) => selectedThemaId = v,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: erkCtrl,
                decoration: const InputDecoration(
                  labelText: 'Erklärung (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () async {
              try {
                final inserted = await supabase
                    .from('fragen')
                    .insert({
                      'frage': frageCtrl.text.trim(),
                      'erklaerung': erkCtrl.text.trim(),
                      'schwierigkeitsgrad': 'leicht',
                      'modul_id': selectedModuleId,
                      'thema_id': selectedThemaId,
                    })
                    .select('id')
                    .single();
                Navigator.pop(context);
                _snack('Frage angelegt (ID ${inserted['id']})');
                if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
              } catch (e) {
                _snack('Fehler beim Anlegen: $e');
              }
            },
            child: const Text('Anlegen'),
          ),
        ],
      ),
    );
  }

  /* ------------------ Dialog: Neues Thema anlegen ------------------ */

  Future<void> _addThemaDialog() async {
    if (selectedModuleId == null) return;
    final nameCtrl = TextEditingController();
    final beschrCtrl = TextEditingController();
    final scoreCtrl = TextEditingController(text: '80');
    int? unlockedBy;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Neues Thema anlegen'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: beschrCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: scoreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Benötigter Score (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  value: unlockedBy,
                  decoration: const InputDecoration(
                    labelText: 'Freischalten nach Thema',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('— Kein vorheriges Thema —'),
                    ),
                    ...themen.map<DropdownMenuItem<int?>>(
                      (t) => DropdownMenuItem(
                        value: t['id'] as int,
                        child: Text(t['name'] ?? ''),
                      ),
                    ),
                  ],
                  onChanged: (v) => unlockedBy = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase.from('themen').insert({
                  'module_id': selectedModuleId,
                  'name': nameCtrl.text.trim(),
                  'beschreibung': beschrCtrl.text.trim(),
                  'required_score': int.tryParse(scoreCtrl.text) ?? 80,
                  'unlocked_by': unlockedBy,
                  'sort_index': (themen.length + 1),
                });
                Navigator.pop(context);
                _snack('Thema angelegt');
                if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
              } catch (e) {
                _snack('Fehler beim Anlegen: $e');
              }
            },
            child: const Text('Anlegen'),
          ),
        ],
      ),
    );
  }

  /* ---------------- Antworten-Dialoge & Löschen ---------------- */

  Future<void> _editAntwortDialog(Map<String, dynamic> antwort) async {
    final textCtrl = TextEditingController(text: antwort['text'] ?? '');
    final erkCtrl =
        TextEditingController(text: (antwort['erklaerung'] ?? '').toString());
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
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
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
                  if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
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

  Future<void> _addAntwortDialog(int frageId) async {
    final textCtrl = TextEditingController();
    final erkCtrl = TextEditingController();
    bool istRichtig = false;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setSB) => AlertDialog(
          title: const Text('Neue Antwort anlegen'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    labelText: 'Erklärung (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await supabase.from('antworten').insert({
                    'frage_id': frageId,
                    'text': textCtrl.text.trim(),
                    'ist_richtig': istRichtig,
                    'erklaerung': erkCtrl.text.trim(),
                  });
                  Navigator.pop(context);
                  _snack('Antwort angelegt');
                  if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
                } catch (e) {
                  _snack('Fehler beim Anlegen: $e');
                }
              },
              child: const Text('Anlegen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFrage(Map<String, dynamic> frage) async {
    final id = frage['id'] as int;
    final text = (frage['frage'] ?? '').toString();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Frage löschen?'),
        content: Text(
          'Willst du die Frage\n\n"$text"\n\nwirklich löschen? '
          'Alle zugehörigen Antworten werden ebenfalls entfernt.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await supabase.from('antworten').delete().eq('frage_id', id);
      await supabase.from('fragen').delete().eq('id', id);
      _snack('Frage gelöscht');
      if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
    } catch (e) {
      _snack('Fehler beim Löschen der Frage: $e');
    }
  }

  Future<void> _confirmDeleteAntwort(Map<String, dynamic> antwort) async {
    final id = antwort['id'] as int;
    final text = (antwort['text'] ?? '').toString();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Antwort löschen?'),
        content: Text('Willst du die Antwort\n\n"$text"\n\nwirklich löschen?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await supabase.from('antworten').delete().eq('id', id);
      _snack('Antwort gelöscht');
      if (selectedModuleId != null) _loadFragenForModule(selectedModuleId!);
    } catch (e) {
      _snack('Fehler beim Löschen der Antwort: $e');
    }
  }

  /* ------------------ Danger Zone: Modul-Inhalte löschen ------------------ */

  Future<void> _nukeModule({required bool alsoDeleteModule}) async {
    if (selectedModuleId == null) return;

    final moduleName = module.firstWhere(
      (m) => m['id'] == selectedModuleId,
      orElse: () => {'name': 'Unbekannt'},
    )['name'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(alsoDeleteModule
            ? 'Modul + Inhalte löschen?'
            : 'Alle Inhalte dieses Moduls löschen?'),
        content: Text(
          alsoDeleteModule
              ? 'Achtung! Das Modul „$moduleName“ UND alle zugehörigen Themen, Fragen und Antworten werden endgültig gelöscht.'
              : 'Achtung! Alle Themen, Fragen und Antworten von „$moduleName“ werden endgültig gelöscht. Das Modul bleibt bestehen.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ja, löschen'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => loading = true);
    try {
      final res = await supabase.rpc('delete_module_data', params: {
        'p_module_id': selectedModuleId,
        'p_delete_module': alsoDeleteModule,
      });

      String summary;
      if (res is List && res.isNotEmpty) {
        final r = res.first as Map<String, dynamic>;
        summary =
            'Antworten: ${r['deleted_antworten']}, Fragen: ${r['deleted_fragen']}, Themen: ${r['deleted_themen']}, Modul: ${r['deleted_module']}';
      } else if (res is Map<String, dynamic>) {
        summary =
            'Antworten: ${res['deleted_antworten']}, Fragen: ${res['deleted_fragen']}, Themen: ${res['deleted_themen']}, Modul: ${res['deleted_module']}';
      } else {
        summary = 'Gelöscht (Details unbekannt)';
      }

      _snack('Erfolg: $summary');

      await _loadModules();
      if (alsoDeleteModule) {
        setState(() {
          selectedModuleId = null;
          fragen = [];
          themen = [];
        });
      } else if (selectedModuleId != null) {
        await _loadFragenForModule(selectedModuleId!);
      }
    } catch (e) {
      _snack('Fehler beim Löschen: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  /* ----------------------------- UI ----------------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin – Inhalte bearbeiten'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: (selectedModuleId != null)
          ? FloatingActionButton.extended(
              onPressed: _addFrageDialog,
              icon: const Icon(Icons.add),
              label: const Text('Frage'),
            )
          : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text('Module', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      if (selectedModuleId != null) ...[
                        const Divider(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), // benannt ✅
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Thema'),
                            onPressed: _addThemaDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), // benannt ✅
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Danger Zone',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700])),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete_forever),
                                label: const Text('Nur Inhalte löschen'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () => _nukeModule(alsoDeleteModule: false),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.warning_amber_rounded),
                                label: const Text('Modul + Inhalte löschen'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () => _nukeModule(alsoDeleteModule: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: selectedModuleId == null
                      ? const Center(child: Text('Bitte ein Modul auswählen.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12), // benannt ✅
                          itemCount: fragen.length,
                          itemBuilder: (context, i) {
                            final f = fragen[i];
                            final List<dynamic> antw = (f['antworten'] ?? []) as List<dynamic>;

                            String themaName = '— Kein Thema —';
                            final tid = f['thema_id'] as int?;
                            if (tid != null) {
                              final hit = themen.firstWhere(
                                (t) => t['id'] == tid,
                                orElse: () => null,
                              );
                              if (hit != null) themaName = hit['name'] ?? themaName;
                            }

                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0), // benannt ✅
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Q${f['id']}: ${f['frage']}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Frage bearbeiten',
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editFrageDialog(f),
                                        ),
                                        IconButton(
                                          tooltip: 'Frage löschen',
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                          onPressed: () => _confirmDeleteFrage(f),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Thema: $themaName',
                                        style: TextStyle(color: Colors.grey[700])),
                                    const SizedBox(height: 6),
                                    if ((f['erklaerung'] ?? '').toString().isNotEmpty)
                                      Text('Erkl.: ${f['erklaerung']}',
                                          style: TextStyle(color: Colors.grey[700])),
                                    const SizedBox(height: 8),
                                    const Text('Antworten:',
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    ...antw.map((a) {
                                      final bool ok = a['ist_richtig'] == true;
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: ok ? Colors.green.shade50 : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: ok ? Colors.green.shade200 : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(a['text'] ?? ''),
                                          subtitle: (a['erklaerung'] != null &&
                                                  (a['erklaerung'] as String).trim().isNotEmpty)
                                              ? Text(a['erklaerung'])
                                              : null,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'Antwort bearbeiten',
                                                icon: const Icon(Icons.edit),
                                                onPressed: () => _editAntwortDialog(
                                                    a as Map<String, dynamic>),
                                              ),
                                              IconButton(
                                                tooltip: 'Antwort löschen',
                                                icon: const Icon(Icons.delete_outline),
                                                color: Colors.red,
                                                onPressed: () => _confirmDeleteAntwort(
                                                    a as Map<String, dynamic>),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: () => _addAntwortDialog(f['id'] as int),
                                        icon: const Icon(Icons.add),
                                        label: const Text('Antwort hinzufügen'),
                                      ),
                                    ),
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
