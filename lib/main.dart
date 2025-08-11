import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: ModulListe(),
    );
  }
}

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
    final response = await supabase.from('module').select();
    for (var modul in response) {
      final fragen = await supabase
          .from('fragen')
          .select('id')
          .eq('modul_id', modul['id']);
      anzahlFragen[modul['id']] = fragen.length;
      beantworteteFragen[modul['id']] = await ladeFortschritt(modul['id']);
    }
    setState(() {
      module = response;
    });
  }

  Future<int> ladeFortschritt(int modulId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'fortschritt_modul_$modulId';
    final value = prefs.get(key);
    if (value is List<String>) {
      return value.length;
    } else {
      await prefs.remove(key);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lernmodule', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
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
                builder: (_) => TestFragen(
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



class TestFragen extends StatefulWidget {
  final int modulId;
  final String modulName;

  TestFragen({required this.modulId, required this.modulName});

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

  @override
  void initState() {
    super.initState();
    ladeFragen();
  }

  Future<void> ladeFragen() async {
    final response = await supabase
        .from('fragen')
        // NEU: Erklärungen pro Antwort mitladen
        .select('*, antworten(id, text, ist_richtig, erklaerung)')
        .eq('modul_id', widget.modulId);
    setState(() {
      fragen = response;
    });
  }

  Future<void> speichereFortschritt(int frageId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'fortschritt_modul_${widget.modulId}';
    final gespeichert = prefs.getStringList(key) ?? [];
    if (!gespeichert.contains(frageId.toString())) {
      gespeichert.add(frageId.toString());
      await prefs.setStringList(key, gespeichert);
    }
  }

  void pruefeAntwort(bool korrekt, String erklaerungText, int frageId) {
    setState(() {
      antwortGewaehlt = true;
      istAntwortRichtig = korrekt;
      erklaerung = erklaerungText;
      if (korrekt) {
        richtig++;
        speichereFortschritt(frageId);
      }
    });
  }

  void naechsteFrage() {
    if (aktuelleFrage + 1 < fragen.length) {
      setState(() {
        aktuelleFrage++;
        antwortGewaehlt = false;
        erklaerung = '';
      });
    } else {
      setState(() {
        fertig = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fragen.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.modulName)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (fertig) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.modulName)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              SizedBox(height: 20),
              Text(
                'Test abgeschlossen!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Du hast $richtig von ${fragen.length} Fragen richtig.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Zurück zur Modulauswahl'),
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
          // Fortschrittsleiste
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (aktuelleFrage + 1) / fragen.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.indigo,
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Text(
                  'Frage ${aktuelleFrage + 1} von ${fragen.length}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          frage['frage'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        if (!antwortGewaehlt)
                          ...antworten.map(
                            (a) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo.shade50,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.all(14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => pruefeAntwort(
                                  a['ist_richtig'] == true,
                                  // NEU: zuerst Antwort-Erklärung, sonst Fragen-Erklärung
                                  a['erklaerung'] ?? frage['erklaerung'] ?? '',
                                  frage['id'],
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(a['text']),
                                ),
                              ),
                            ),
                          )
                        else ...[
                          // NEU: Feedback-Banner (Richtig/Falsch)
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
                          SizedBox(height: 16),

                          // Antworten farbig markieren (wie gehabt)
                          ...antworten.map(
                            (a) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: a['ist_richtig'] == true
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.all(14),
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
                          SizedBox(height: 20),

                          // Erklärungskarte (wie gehabt, jetzt mit neuer Quelle)
                          Card(
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Erklärung:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
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
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: naechsteFrage,
                  child: Center(child: Text('Nächste Frage')),
                ),
              ),
            )
        ],
      ),
    );
  }
}
