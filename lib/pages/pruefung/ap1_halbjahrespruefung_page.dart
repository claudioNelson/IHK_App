// lib/pages/pruefung/ap1_halbjahrespruefung_page.dart
import 'package:flutter/material.dart';
import 'package:ihk_app/widgets/rechenaufgaben_widget.dart';
import 'package:ihk_app/widgets/tabellen_widget.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class Ap1HalbjahrespruefungPage extends StatefulWidget {
  const Ap1HalbjahrespruefungPage({super.key});

  @override
  State<Ap1HalbjahrespruefungPage> createState() =>
      _Ap1HalbjahrespruefungPageState();
}

class _Ap1HalbjahrespruefungPageState
    extends State<Ap1HalbjahrespruefungPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final Map<String, dynamic> _antworten = {};

  static const List<_AufgabeInfo> _aufgaben = [
    _AufgabeInfo('💼', 'OfficeMedia GmbH', 'Multifunktionsgerät'),
    _AufgabeInfo('☁️', 'CodeCraft Solutions', 'Software-Abos'),
    _AufgabeInfo('🖧', 'NetConnect IT', 'Server & Hosting'),
  ];

  void _goToPage(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _speichern() {
    debugPrint('Antworten: $_antworten');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Antworten gespeichert!'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_indigoDark, _indigo, _indigoLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 16),
                child: Column(
                  children: [
                    // Title Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'AP1 – Halbjahresprüfung',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.save_rounded,
                              color: Colors.white),
                          tooltip: 'Antworten speichern',
                          onPressed: _speichern,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Aufgaben-Tabs (als Chips)
                    Row(
                      children: List.generate(_aufgaben.length, (i) {
                        final isActive = i == _currentIndex;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _goToPage(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                  left: i == 0 ? 8 : 4,
                                  right: i == _aufgaben.length - 1 ? 8 : 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _aufgaben[i].emoji,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Aufgabe ${i + 1}',
                                    style: TextStyle(
                                      color: isActive
                                          ? _indigo
                                          : Colors.white70,
                                      fontSize: 11,
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Aufgaben-Titel ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(_currentIndex),
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(_aufgaben[_currentIndex].emoji,
                        style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aufgabe ${_currentIndex + 1} – ${_aufgaben[_currentIndex].firma}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _aufgaben[_currentIndex].thema,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Pfeile
                  if (_currentIndex > 0)
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded,
                          color: _indigo),
                      onPressed: () => _goToPage(_currentIndex - 1),
                    ),
                  if (_currentIndex < _aufgaben.length - 1)
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded,
                          color: _indigo),
                      onPressed: () => _goToPage(_currentIndex + 1),
                    ),
                ],
              ),
            ),
          ),

          // ── PageView ─────────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [
                _buildAufgabe1(),
                _buildAufgabe2(),
                _buildAufgabe3(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── AUFGABE 1 ──────────────────────────────────────────────────────────────

  Widget _buildAufgabe1() {
    return _AufgabeScroll(children: [
      TabellenWidget(
        frage:
            'Die OfficeMedia GmbH möchte ein neues Multifunktionsgerät für das Büro '
            'anschaffen. Drei Modelle stehen zur Auswahl.\n\n'
            'Bewerten Sie die drei Geräte anhand der vorgegebenen Kriterien. '
            'Vergeben Sie je Kriterium pro Zeile die Werte von 1 bis 3, wobei '
            '3 den besten und 1 den schlechtesten Wert darstellt.',
        punkte: 6,
        kriterien: const [
          'Anschaffungskosten',
          'Druckkosten je Seite (S/W)',
          'Druckkosten je Seite (Farbe)',
          'Druckgeschwindigkeit',
          'Scan-Geschwindigkeit',
          'Wartungsaufwand',
        ],
        optionen: const ['Gerät A', 'Gerät B', 'Gerät C'],
        bewertungsSkala: const [1, 2, 3],
        hinweis:
            'Pro Zeile: 3 = bestes Gerät, 1 = schlechtestes Gerät.',
        zeigeSumme: true,
        onAnswerChanged: (b) => _antworten['aufgabe1_matrix'] = b,
      ),
      RechenaufgabenWidget(
        frage:
            'Im letzten Monat wurden 18.400 Seiten gedruckt. Davon 13.600 Seiten '
            'S/W (0,04 EUR/Seite) und 4.800 Seiten Farbe (0,09 EUR/Seite).\n\n'
            'Berechnen Sie die gesamten Druckkosten und geben Sie den Rechenweg an.',
        punkte: 3,
        hinweis:
            'S/W: 13.600 × 0,04 EUR | Farbe: 4.800 × 0,09 EUR | Summe beider',
        zeigeRechenweg: true,
        onAnswerChanged: (a, r) =>
            _antworten['aufgabe1_druckkosten'] = {'antwort': a, 'rechenweg': r},
      ),
    ]);
  }

  // ─── AUFGABE 2 ──────────────────────────────────────────────────────────────

  Widget _buildAufgabe2() {
    return _AufgabeScroll(children: [
      RechenaufgabenWidget(
        frage:
            'CodeCraft Solutions bietet ein Projektmanagement-Tool im Abo-Modell:\n'
            '• Benutzer 1–15: 22,00 EUR/Benutzer/Monat\n'
            '• Ab dem 16. Benutzer: 15,00 EUR/Benutzer/Monat\n\n'
            'Ein Kunde bucht 28 Benutzerlizenzen. Berechnen Sie die monatlichen '
            'Gesamtkosten mit Rechenweg.',
        punkte: 4,
        hinweis: '(15 × 22,00 EUR) + (13 × 15,00 EUR)',
        zeigeRechenweg: true,
        onAnswerChanged: (a, r) =>
            _antworten['aufgabe2_staffel'] = {'antwort': a, 'rechenweg': r},
      ),
      RechenaufgabenWidget(
        frage:
            'Ein Kunde hat 18 Lizenzen à 24,00 EUR/Monat. Bei Jahreszahlung erhält '
            'er 6 % Skonto auf die Jahressumme.\n\n'
            'Berechnen Sie die zu zahlende Jahressumme nach Skonto.',
        punkte: 3,
        hinweis:
            'Monatskosten = 18 × 24,00 EUR | Jahreskosten × 12 | – 6 % Skonto',
        zeigeRechenweg: true,
        onAnswerChanged: (a, r) =>
            _antworten['aufgabe2_skonto'] = {'antwort': a, 'rechenweg': r},
      ),
      TabellenWidget(
        frage:
            'Ein Systemhaus sucht einen Cloud-Backup-Anbieter. Drei Tarife kommen in '
            'die Auswahl.\n\n'
            'Bewerten Sie die Tarife (3 = vorteilhaftester, 1 = ungünstigster).',
        punkte: 5,
        kriterien: const [
          'Monatliche Kosten',
          'Verfügbare Speichergröße',
          'Garantierte Verfügbarkeit (SLA)',
          'Supportzeiten',
          'Skalierbarkeit/Erweiterbarkeit',
        ],
        optionen: const ['Tarif Standard', 'Tarif Business', 'Tarif Premium'],
        bewertungsSkala: const [1, 2, 3],
        hinweis:
            'Monatliche Kosten: günstigster = 3. Verfügbarkeit: höchste = 3.',
        zeigeSumme: true,
        onAnswerChanged: (b) => _antworten['aufgabe2_matrix'] = b,
      ),
    ]);
  }

  // ─── AUFGABE 3 ──────────────────────────────────────────────────────────────

  Widget _buildAufgabe3() {
    return _AufgabeScroll(children: [
      RechenaufgabenWidget(
        frage:
            'Die NetConnect IT GmbH betreibt einen Server im RZ:\n'
            '• Strom: 145,00 EUR/Monat\n'
            '• Rackmiete: 210,00 EUR/Monat\n'
            '• Monitoring: 55,00 EUR/Monat\n'
            '• Einmalige Einrichtung: 480,00 EUR (über 3 Jahre)\n\n'
            'Berechnen Sie die durchschnittlichen monatlichen Gesamtkosten über 3 Jahre.',
        punkte: 3,
        hinweis:
            '36 Monate | Fixkosten: 145 + 210 + 55 | Einrichtung: 480 / 36',
        zeigeRechenweg: true,
        onAnswerChanged: (a, r) =>
            _antworten['aufgabe3_server'] = {'antwort': a, 'rechenweg': r},
      ),
      RechenaufgabenWidget(
        frage:
            'Pro Monat laufen 12 Kundenprojekte über den Server. Die monatlichen '
            'Gesamtkosten betragen 1.020,00 EUR.\n\n'
            'Berechnen Sie die Serverkosten pro Projekt und Monat (2 Nachkommastellen).',
        punkte: 4,
        hinweis: '1.020,00 EUR / 12',
        zeigeRechenweg: true,
        onAnswerChanged: (a, r) =>
            _antworten['aufgabe3_projekt'] = {'antwort': a, 'rechenweg': r},
      ),
      TabellenWidget(
        frage:
            'Ein Start-up wählt ein Hosting-Modell (Webhosting, vServer, PaaS).\n\n'
            'Bewerten Sie die Varianten (3 = vorteilhafteste, 1 = ungünstigste).',
        punkte: 5,
        kriterien: const [
          'Einrichtung/Aufwand',
          'Laufende Kosten',
          'Skalierbarkeit',
          'Administrationsaufwand',
          'Flexibilität der Konfiguration',
        ],
        optionen: const ['Webhosting', 'vServer', 'PaaS'],
        bewertungsSkala: const [1, 2, 3],
        hinweis:
            'Perspektive des Start-ups: wenig Personal, begrenztes Budget, Wachstum möglich.',
        zeigeSumme: true,
        onAnswerChanged: (b) => _antworten['aufgabe3_hosting_matrix'] = b,
      ),
    ]);
  }
}

// ─── Helper Widgets ────────────────────────────────────────────────────────────

class _AufgabeScroll extends StatelessWidget {
  final List<Widget> children;

  const _AufgabeScroll({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: children
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: c,
              ))
          .toList(),
    );
  }
}

class _AufgabeInfo {
  final String emoji;
  final String firma;
  final String thema;

  const _AufgabeInfo(this.emoji, this.firma, this.thema);
}