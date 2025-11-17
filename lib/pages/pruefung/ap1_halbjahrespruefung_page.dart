import 'package:flutter/material.dart';

// Passe diese Imports an deinen Pfad an:
import 'package:ihk_app/widgets/rechenaufgaben_widget.dart';
import 'package:ihk_app/widgets/tabellen_widget.dart';

class Ap1HalbjahrespruefungPage extends StatefulWidget {
  const Ap1HalbjahrespruefungPage({Key? key}) : super(key: key);

  @override
  State<Ap1HalbjahrespruefungPage> createState() =>
      _Ap1HalbjahrespruefungPageState();
}

class _Ap1HalbjahrespruefungPageState extends State<Ap1HalbjahrespruefungPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Hier sammeln wir alle Antworten – kannst du später in Supabase/Datenbank speichern.
  final Map<String, dynamic> _antworten = {};

  void _goToPage(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _speichern() {
    // Hier könntest du Supabase-Insert/Update machen
    debugPrint('Antworten Prüfungsdurchlauf: $_antworten');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Antworten lokal gespeichert (Demo).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AP1 – Halbjahresprüfung Simulation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _speichern,
            tooltip: 'Antworten speichern',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          _buildAufgabe1(),
          _buildAufgabe2(),
          _buildAufgabe3(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_1),
            label: 'Aufgabe 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_2),
            label: 'Aufgabe 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_3),
            label: 'Aufgabe 3',
          ),
        ],
      ),
    );
  }

  // ------------------ AUFGABE 1 ------------------

  Widget _buildAufgabe1() {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Aufgabe 1 – OfficeMedia GmbH (Multifunktionsgerät)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // 1a) Entscheidungsmatrix – TabellenWidget
        TabellenWidget(
          frage:
              'Die OfficeMedia GmbH möchte ein neues Multifunktionsgerät für das Büro '
              'anschaffen. Drei Modelle stehen zur Auswahl.\n\n'
              'Bewerten Sie die drei Geräte anhand der vorgegebenen Kriterien. '
              'Vergeben Sie je Kriterium pro Zeile die Werte von 1 bis 3, wobei '
              '3 den besten und 1 den schlechtesten Wert darstellt. Jedes Gerät '
              'darf je Kriterium nur einmal vorkommen.',
          punkte: 6,
          kriterien: const [
            'Anschaffungskosten',
            'Druckkosten je Seite (S/W)',
            'Druckkosten je Seite (Farbe)',
            'Druckgeschwindigkeit',
            'Scan-Geschwindigkeit',
            'Wartungsaufwand',
          ],
          optionen: const [
            'Gerät A',
            'Gerät B',
            'Gerät C',
          ],
          bewertungsSkala: const [1, 2, 3],
          hinweis:
              'Nutzen Sie zur Bewertung die technischen Daten aus der Aufgabenstellung '
              'bzw. Anlage. Pro Zeile: 3 = bestes Gerät, 1 = schlechtestes Gerät.',
          zeigeSumme: true,
          onAnswerChanged: (bewertungen) {
            _antworten['aufgabe1_matrix'] = bewertungen;
          },
        ),

        // 1b) Rechenaufgabe – Druckkosten
        RechenaufgabenWidget(
          frage: 'Im letzten Monat wurden mit dem bisherigen Gerät insgesamt '
              '18.400 Seiten gedruckt. Davon waren 13.600 Seiten in Schwarz-Weiß '
              'und 4.800 Seiten in Farbe.\n\n'
              'Die Kosten betragen:\n'
              '• 0,04 EUR je S/W-Seite\n'
              '• 0,09 EUR je Farbseite\n\n'
              'Berechnen Sie die gesamten Druckkosten des letzten Monats und geben Sie '
              'Ihren Rechenweg an.',
          punkte: 3,
          hinweis: 'S/W-Seiten: 13.600 × 0,04 EUR\n'
              'Farbseiten: 4.800 × 0,09 EUR\n'
              'Gesamtkosten = Kosten S/W + Kosten Farbe',
          zeigeRechenweg: true,
          onAnswerChanged: (antwort, rechenweg) {
            _antworten['aufgabe1_druckkosten'] = {
              'antwort': antwort,
              'rechenweg': rechenweg,
            };
          },
        ),
      ],
    );
  }

  // ------------------ AUFGABE 2 ------------------

  Widget _buildAufgabe2() {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Aufgabe 2 – CodeCraft Solutions (Software-Abos)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // 2a) Staffelpreis-Lizenzen
        RechenaufgabenWidget(
          frage: 'Die CodeCraft Solutions GmbH bietet ein Projektmanagement-Tool im '
              'Abo-Modell an.\n\n'
              'Preisstruktur pro Benutzer und Monat:\n'
              '• Benutzer 1–15: 22,00 EUR je Benutzer\n'
              '• Benutzer ab dem 16.: 15,00 EUR je Benutzer\n\n'
              'Ein Kunde möchte 28 Benutzerlizenzen buchen.\n'
              'Berechnen Sie die monatlichen Gesamtkosten für diesen Kunden und geben '
              'Sie Ihren Rechenweg an.',
          punkte: 4,
          hinweis: 'Gesamtkosten = (15 × 22,00 EUR) + (13 × 15,00 EUR)',
          zeigeRechenweg: true,
          onAnswerChanged: (antwort, rechenweg) {
            _antworten['aufgabe2_staffel'] = {
              'antwort': antwort,
              'rechenweg': rechenweg,
            };
          },
        ),

        // 2b) Jahreskosten mit Skonto
        RechenaufgabenWidget(
          frage: 'Für einen anderen Kunden berechnet CodeCraft Solutions monatlich '
              '18 Lizenzen zu je 24,00 EUR.\n'
              'Wenn der Kunde die Gebühr für ein ganzes Jahr im Voraus bezahlt, '
              'erhält er 6 % Skonto auf die Jahressumme.\n\n'
              'Berechnen Sie die zu zahlende Jahressumme nach Abzug des Skontos und '
              'geben Sie den Rechenweg an.',
          punkte: 3,
          hinweis: 'Monatskosten = 18 × 24,00 EUR\n'
              'Jahreskosten = Monatskosten × 12\n'
              'Skonto: 6 % auf Jahreskosten',
          zeigeRechenweg: true,
          onAnswerChanged: (antwort, rechenweg) {
            _antworten['aufgabe2_skonto'] = {
              'antwort': antwort,
              'rechenweg': rechenweg,
            };
          },
        ),

        // 2c) Tabelle – Tarife vergleichen
        TabellenWidget(
          frage: 'Ein Systemhaus sucht einen geeigneten Cloud-Backup-Anbieter für seine '
              'Kunden. Drei Tarife eines Anbieters kommen in die engere Auswahl.\n\n'
              'Bewerten Sie die Tarife anhand der genannten Kriterien. Vergeben Sie je '
              'Kriterium pro Zeile einmal die Werte 1, 2 und 3, wobei 3 den günstigsten '
              'bzw. vorteilhaftesten Tarif und 1 den ungünstigsten Tarif beschreibt.',
          punkte: 5,
          kriterien: const [
            'Monatliche Kosten',
            'Verfügbare Speichergröße',
            'Garantierte Verfügbarkeit (SLA)',
            'Supportzeiten',
            'Skalierbarkeit/Erweiterbarkeit',
          ],
          optionen: const [
            'Tarif Standard',
            'Tarif Business',
            'Tarif Premium',
          ],
          bewertungsSkala: const [1, 2, 3],
          hinweis:
              'Bei „Monatliche Kosten“ erhält der günstigste Tarif die 3, der teuerste die 1. '
              'Bei „Verfügbarkeit“ erhält die höchste Verfügbarkeit die 3 usw.',
          zeigeSumme: true,
          onAnswerChanged: (bewertungen) {
            _antworten['aufgabe2_matrix'] = bewertungen;
          },
        ),
      ],
    );
  }

  // ------------------ AUFGABE 3 ------------------

  Widget _buildAufgabe3() {
    return ListView(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Aufgabe 3 – NetConnect IT (Server & Hosting)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // 3a) Serverkosten über Laufzeit
        RechenaufgabenWidget(
          frage: 'Die NetConnect IT GmbH betreibt einen Anwendungsserver im Rechenzentrum.\n\n'
              'Kostenstruktur:\n'
              '• Stromkosten: 145,00 EUR pro Monat\n'
              '• Miete Rackplatz: 210,00 EUR pro Monat\n'
              '• Monitoring-Service: 55,00 EUR pro Monat\n'
              '• Einmalige Einrichtungsgebühr: 480,00 EUR (Berechnung über 3 Jahre)\n\n'
              'Berechnen Sie die durchschnittlichen monatlichen Gesamtkosten des '
              'Servers über den Zeitraum von drei Jahren und geben Sie Ihren '
              'Rechenweg an.',
          punkte: 3,
          hinweis: 'Zeitraum: 36 Monate\n'
              'Monatliche Fixkosten: 145 + 210 + 55\n'
              'Einrichtungskosten: 480 / 36 Monate',
          zeigeRechenweg: true,
          onAnswerChanged: (antwort, rechenweg) {
            _antworten['aufgabe3_server'] = {
              'antwort': antwort,
              'rechenweg': rechenweg,
            };
          },
        ),

        // 3b) Kosten je Projekt
        RechenaufgabenWidget(
          frage: 'Im Durchschnitt laufen pro Monat 12 Kundenprojekte über den Server '
              'der NetConnect IT GmbH.\n'
              'Die durchschnittlichen monatlichen Gesamtkosten des Servers wurden mit '
              '1.020,00 EUR ermittelt.\n\n'
              'Berechnen Sie die durchschnittlichen Serverkosten pro Projekt und Monat '
              'und geben Sie den Rechenweg an. Runden Sie auf zwei Nachkommastellen.',
          punkte: 4,
          hinweis: 'Kosten je Projekt = 1.020,00 EUR / 12',
          zeigeRechenweg: true,
          onAnswerChanged: (antwort, rechenweg) {
            _antworten['aufgabe3_projekt'] = {
              'antwort': antwort,
              'rechenweg': rechenweg,
            };
          },
        ),

        // 3c) Hosting-Entscheidungsmatrix
        TabellenWidget(
          frage: 'Ein Start-up möchte seine neue Webanwendung bereitstellen und überlegt, '
              'welches Hosting-Modell verwendet werden soll.\n\n'
              'Es stehen drei Varianten zur Auswahl: klassisches Webhosting, '
              'virtueller Server (vServer) und Plattform-as-a-Service (PaaS).\n\n'
              'Bewerten Sie die Varianten für jedes Kriterium mit den Werten 1 bis 3, '
              'wobei 3 jeweils die günstigste bzw. vorteilhafteste Variante darstellt.',
          punkte: 5,
          kriterien: const [
            'Einrichtung/Aufwand',
            'Laufende Kosten',
            'Skalierbarkeit',
            'Administrationsaufwand',
            'Flexibilität der Konfiguration',
          ],
          optionen: const [
            'Webhosting',
            'vServer',
            'PaaS',
          ],
          bewertungsSkala: const [1, 2, 3],
          hinweis:
              'Perspektive des Start-ups: wenig Personal, begrenztes Budget, aber Wachstum möglich.',
          zeigeSumme: true,
          onAnswerChanged: (bewertungen) {
            _antworten['aufgabe3_hosting_matrix'] = bewertungen;
          },
        ),
      ],
    );
  }
}
