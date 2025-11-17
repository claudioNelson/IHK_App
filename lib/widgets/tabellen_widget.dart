import 'package:flutter/material.dart';

/// Widget für Tabellen-Aufgaben in der Prüfungssimulation
/// 
/// Beispiel aus AP1 Prüfung Aufgabe 1a:
/// Entscheidungsmatrix mit Bewertungen 1-3 für verschiedene Kriterien
/// 
/// Features:
/// - Flexible Zeilen und Spalten
/// - Dropdown-Auswahl für Bewertungen
/// - Automatische Summen-Berechnung
/// - Responsive Design
class TabellenWidget extends StatefulWidget {
  final String frage;
  final int punkte;
  final List<String> kriterien; // Zeilen
  final List<String> optionen; // Spalten (z.B. "Gerät 1", "Gerät 2", "Gerät 3")
  final List<int> bewertungsSkala; // z.B. [1, 2, 3]
  final String? hinweis;
  final bool zeigeSumme;
  final Function(Map<String, Map<String, int>> bewertungen) onAnswerChanged;
  final Map<String, Map<String, int>>? initialBewertungen;

  const TabellenWidget({
    Key? key,
    required this.frage,
    required this.punkte,
    required this.kriterien,
    required this.optionen,
    this.bewertungsSkala = const [1, 2, 3],
    this.hinweis,
    this.zeigeSumme = true,
    required this.onAnswerChanged,
    this.initialBewertungen,
  }) : super(key: key);

  @override
  State<TabellenWidget> createState() => _TabellenWidgetState();
}

class _TabellenWidgetState extends State<TabellenWidget> {
  // Speichert Bewertungen: kriterium -> option -> wert
  late Map<String, Map<String, int>> _bewertungen;

  @override
  void initState() {
    super.initState();
    
    // Initialisiere Bewertungen
    _bewertungen = widget.initialBewertungen ?? {};
    
    // Stelle sicher, dass alle Kriterien existieren
    for (var kriterium in widget.kriterien) {
      _bewertungen.putIfAbsent(kriterium, () => {});
    }
  }

  void _updateBewertung(String kriterium, String option, int? wert) {
    setState(() {
      if (wert != null) {
        _bewertungen[kriterium]![option] = wert;
      } else {
        _bewertungen[kriterium]!.remove(option);
      }
    });
    widget.onAnswerChanged(_bewertungen);
  }

  int _calculateSum(String option) {
    int sum = 0;
    for (var kriterium in widget.kriterien) {
      sum += _bewertungen[kriterium]?[option] ?? 0;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frage-Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.punkte} ${widget.punkte == 1 ? "Punkt" : "Punkte"}',
                    style: TextStyle(
                      color: Colors.purple.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.table_chart, color: Colors.purple, size: 20),
                const SizedBox(width: 4),
                const Text(
                  'Bewertungsmatrix',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Frage
            Text(
              widget.frage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            
            // Hinweis (optional)
            if (widget.hinweis != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.hinweis!,
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Tabelle
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header-Zeile
                  Row(
                    children: [
                      // Leere Ecke
                      Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Text(
                            'Kriterien',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      // Spalten-Header
                      ...widget.optionen.map((option) => Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                    ],
                  ),
                  
                  // Kriterien-Zeilen
                  ...widget.kriterien.map((kriterium) => Row(
                    children: [
                      // Kriterium-Name
                      Container(
                        width: 180,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            kriterium,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Bewertungs-Dropdowns
                      ...widget.optionen.map((option) => Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: DropdownButton<int>(
                            value: _bewertungen[kriterium]?[option],
                            hint: const Text('—'),
                            isExpanded: true,
                            underline: Container(),
                            items: widget.bewertungsSkala.map((wert) {
                              return DropdownMenuItem(
                                value: wert,
                                child: Center(
                                  child: Text(
                                    wert.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (wert) {
                              _updateBewertung(kriterium, option, wert);
                            },
                          ),
                        ),
                      )),
                    ],
                  )),
                  
                  // Summen-Zeile (optional)
                  if (widget.zeigeSumme) Row(
                    children: [
                      // "Ergebnis" Label
                      Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Center(
                          child: Text(
                            'Ergebnis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      // Summen
                      ...widget.optionen.map((option) {
                        final sum = _calculateSum(option);
                        return Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Center(
                            child: Text(
                              sum.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            
            // Legende
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, 
                    color: Colors.orange.shade700, 
                    size: 18
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bewertung: ${widget.bewertungsSkala.first} = schlechteste, '
                      '${widget.bewertungsSkala.last} = beste',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Beispiel-Verwendung:
/// 
/// ```dart
/// TabellenWidget(
///   frage: 'Vervollständigen Sie aufgrund der vorliegenden Werte die '
///          'Entscheidungsmatrix zur Auswahl des geeignetsten Multifunktionsgeräts. '
///          'Bestimmen Sie für jedes Kriterium pro Zeile eine Rangfolge der '
///          'Multifunktionsgeräte, indem Sie die Werte von 1 bis 3 vergeben, '
///          'wobei 3 der beste und 1 der schlechteste Wert ist.',
///   punkte: 6,
///   kriterien: [
///     'Geschwindigkeit Druck',
///     'Geschwindigkeit Scan',
///     'Wartungskosten',
///     'Preis',
///   ],
///   optionen: [
///     'Multifunktionsgerät 1',
///     'Multifunktionsgerät 2',
///     'Multifunktionsgerät 3',
///   ],
///   bewertungsSkala: [1, 2, 3],
///   zeigeSumme: true,
///   onAnswerChanged: (bewertungen) {
///     print('Bewertungen: $bewertungen');
///     // Speichere in Datenbank
///   },
/// )
/// ```