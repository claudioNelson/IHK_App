import 'package:flutter/material.dart';
import '../widgets/rechenaufgaben_widget.dart';
import '../widgets/tabellen_widget.dart';

/// Demo-Screen zum Testen der Prüfungs-Widgets
class PruefungsDemoScreen extends StatefulWidget {
  const PruefungsDemoScreen({super.key});

  @override
  State<PruefungsDemoScreen> createState() => _PruefungsDemoScreenState();
}

class _PruefungsDemoScreenState extends State<PruefungsDemoScreen> {
  // Speichere Antworten
  Map<String, Map<String, int>>? _tabellenAntwort;
  double? _rechenAntwort;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Demo - Aufgabe 1'),
        backgroundColor: Colors.blue,
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info-Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'IHK Prüfung - Aufgabe 1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Die Kanzlei möchte neue Multifunktionsgeräte anschaffen. '
                  'Monatlicher Druck: 2.000 Seiten S/W, 500 Seiten Farbe.',
                  style: TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tabellen-Widget
          TabellenWidget(
            frage: '1a) Bewerten Sie die drei Multifunktionsgeräte nach '
                   'den gegebenen Kriterien. Vergeben Sie Punkte von 1-3, '
                   'wobei 3 die beste Bewertung ist.',
            punkte: 6,
            kriterien: [
              'Geschwindigkeit Druck',
              'Geschwindigkeit Scan',
              'Wartungskosten',
              'Preis',
            ],
            optionen: [
              'Gerät 1',
              'Gerät 2',
              'Gerät 3',
            ],
            bewertungsSkala: const [1, 2, 3],
            zeigeSumme: true,
            onAnswerChanged: (bewertungen) {
              setState(() {
                _tabellenAntwort = bewertungen;
              });
              print('✅ Tabelle gespeichert: $bewertungen');
            },
          ),
          
          const SizedBox(height: 24),
          
          // Technische Daten
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technische Daten zur Orientierung:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 8),
                Text('Gerät 1: 40 S/min Druck, 20 S/min Scan, 50€/M, 3.456€', 
                  style: TextStyle(fontSize: 12)),
                Text('Gerät 2: 62 S/min Druck, 50 S/min Scan, 10€/M, 2.844€', 
                  style: TextStyle(fontSize: 12)),
                Text('Gerät 3: 50 S/min Druck, 40 S/min Scan, 15€/M, 1.656€', 
                  style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Rechenaufgaben-Widget
          RechenaufgabenWidget(
            frage: '1ac) Berechnen Sie die monatlichen Kosten für das Gerät.\n\n'
                   'Gegeben:\n'
                   '• Druck: 0,05 EUR pro Seite S/W\n'
                   '• Farbe: 0,07 EUR pro Seite Farbe\n'
                   '• Nutzungsdauer: 36 Monate\n\n'
                   'Berechnen Sie die Kosten je Monat. Runden Sie auf ganze EUR.',
            punkte: 3,
            hinweis: '2.000 Seiten S/W + 500 Seiten Farbe pro Monat',
            zeigeRechenweg: true,
            onAnswerChanged: (antwort, rechenweg) {
              setState(() {
                _rechenAntwort = antwort;
              });
              print('✅ Rechenaufgabe gespeichert: $antwort EUR');
              if (rechenweg != null) {
                print('   Rechenweg: $rechenweg');
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Status-Anzeige
          if (_tabellenAntwort != null || _rechenAntwort != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Antworten werden automatisch gespeichert',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_tabellenAntwort != null)
                    Text('✓ Tabelle: ${_tabellenAntwort!.length} Kriterien bewertet',
                      style: const TextStyle(fontSize: 13)),
                  if (_rechenAntwort != null)
                    Text('✓ Rechenaufgabe: ${_rechenAntwort!.toStringAsFixed(2)} EUR',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          
          const SizedBox(height: 100), // Platz für FAB
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Zeige Zusammenfassung
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Antworten-Übersicht'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deine Antworten:', 
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Tabelle: ${_tabellenAntwort != null ? "✓ Ausgefüllt" : "✗ Nicht ausgefüllt"}'),
                  Text('Rechenaufgabe: ${_rechenAntwort != null ? "✓ Beantwortet" : "✗ Nicht beantwortet"}'),
                  if (_rechenAntwort != null) ...[
                    const SizedBox(height: 8),
                    Text('Ergebnis: ${_rechenAntwort!.toStringAsFixed(2)} EUR',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Schließen'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.info_outline),
        label: const Text('Status'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}