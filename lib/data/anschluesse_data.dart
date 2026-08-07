// lib/data/anschluesse_data.dart
//
// Datengrundlage für das Anschlüsse-Quiz (Systemintegration).
// Jeder Anschluss hat zwei Bilder:
//   assets/anschluesse/labeled/<id>.png  → mit Beschriftung (Lern-Modus)
//   assets/anschluesse/quiz/<id>.png     → ohne Beschriftung (Quiz-Fragen)

class Anschluss {
  final String id;
  final String name;
  final String kurzinfo; // eine Zeile, steht unter dem Namen
  final String erklaerung; // Feedback-Text nach der Antwort

  const Anschluss({
    required this.id,
    required this.name,
    required this.kurzinfo,
    required this.erklaerung,
  });

  String get labeledAsset => 'assets/anschluesse/labeled/$id.png';
  String get quizAsset => 'assets/anschluesse/quiz/$id.png';
}

const List<Anschluss> anschluesse = [
  Anschluss(
    id: 'usb_a',
    name: 'USB-A',
    kurzinfo: 'Klassischer USB-Anschluss · Tastatur, Maus, Sticks',
    erklaerung:
        'USB-A ist der klassische, rechteckige USB-Anschluss. Er passt nur in einer Richtung und steckt an fast jedem PC. Typisch für Tastatur, Maus und USB-Sticks.',
  ),
  Anschluss(
    id: 'usb_b',
    name: 'USB-B',
    kurzinfo: 'Quadratisch mit abgeschrägten Ecken · Drucker, Scanner',
    erklaerung:
        'USB-B erkennst du an der fast quadratischen Form mit zwei abgeschrägten Ecken. Der Klassiker an Druckern und Scannern.',
  ),
  Anschluss(
    id: 'micro_usb',
    name: 'Micro-USB',
    kurzinfo: 'Flacher Trapez-Stecker · ältere Smartphones, Zubehör',
    erklaerung:
        'Micro-USB ist klein und trapezförmig, passt nur in einer Richtung. Vor USB-C der Standard bei Smartphones; heute noch bei Powerbanks und günstigem Zubehör verbreitet.',
  ),
  Anschluss(
    id: 'usb_c',
    name: 'USB-C',
    kurzinfo: 'Oval und symmetrisch · Daten, Laden, Video',
    erklaerung:
        'USB-C ist oval und komplett symmetrisch, du kannst ihn also beidseitig einstecken. Er überträgt Daten, Strom (Power Delivery) und sogar Video (DisplayPort Alt Mode).',
  ),
  Anschluss(
    id: 'hdmi',
    name: 'HDMI (Typ A)',
    kurzinfo: 'Digital · Bild + Ton in einem Kabel',
    erklaerung:
        'HDMI hat die charakteristische Form mit zwei abgeschrägten unteren Ecken (symmetrisch!). Überträgt digital Bild UND Ton, Standard bei Monitoren, TVs und Beamern.',
  ),
  Anschluss(
    id: 'displayport',
    name: 'DisplayPort',
    kurzinfo: 'Digital · nur EINE abgeschrägte Ecke · PC-Monitore',
    erklaerung:
        'DisplayPort sieht HDMI ähnlich, hat aber nur EINE abgeschrägte Ecke (asymmetrisch). Das ist DER Unterschied fürs Erkennen. Verbreitet an PC-Grafikkarten und Büro-Monitoren.',
  ),
  Anschluss(
    id: 'vga',
    name: 'VGA (D-Sub 15)',
    kurzinfo: 'Analog · 15 Pins in 3 Reihen · meist blau',
    erklaerung:
        'VGA ist der blaue, trapezförmige Stecker mit 15 Pins in 3 Reihen und Rändelschrauben. Überträgt ANALOG und nur Bild, kein Ton. An alten Monitoren und Beamern.',
  ),
  Anschluss(
    id: 'dvi_d',
    name: 'DVI-D',
    kurzinfo: 'Digital · breiter Stecker mit Pin-Raster',
    erklaerung:
        'DVI ist der breite, meist weiße Stecker mit dem großen Pin-Raster. DVI-D überträgt nur digital und nur Bild. Der Nachfolger von VGA, inzwischen selbst von HDMI/DisplayPort abgelöst.',
  ),
  Anschluss(
    id: 'rj45',
    name: 'RJ45 (Ethernet)',
    kurzinfo: 'Netzwerk · Twisted Pair · 8 Adern (8P8C)',
    erklaerung:
        'RJ45 ist der Netzwerkstecker mit 8 Kontakten (8P8C) und Rastnase. Verbindet PCs, Switches und Router über Twisted-Pair-Kabel. Absoluter Prüfungsklassiker!',
  ),
  Anschluss(
    id: 'rj11',
    name: 'RJ11',
    kurzinfo: 'Telefon/DSL · schmaler als RJ45',
    erklaerung:
        'RJ11 sieht aus wie ein geschrumpfter RJ45: schmaler, nur 4 bis 6 Kontakte. Für Telefonleitungen und DSL-Anschlüsse. Verwechslungsgefahr mit RJ45 ist eine beliebte Prüfungsfalle.',
  ),
  Anschluss(
    id: 'sata_data',
    name: 'SATA (Daten)',
    kurzinfo: 'Schmaler L-Stecker · 7 Kontakte',
    erklaerung:
        'Der SATA-Datenanschluss ist schmal, hat 7 Kontakte und die typische L-Form (verpolungssicher). Verbindet Festplatten und SSDs mit dem Mainboard.',
  ),
  Anschluss(
    id: 'sata_power',
    name: 'SATA (Strom)',
    kurzinfo: 'Breiter L-Stecker · 15 Kontakte · vom Netzteil',
    erklaerung:
        'Der SATA-Stromanschluss ist deutlich BREITER als der Datenanschluss und hat 15 Kontakte. Kommt vom Netzteil. Merkhilfe: Strom = breit, Daten = schmal.',
  ),
  Anschluss(
    id: 'ps2',
    name: 'PS/2',
    kurzinfo: 'Rund (Mini-DIN, 6-polig) · alte Tastaturen/Mäuse',
    erklaerung:
        'PS/2 ist der runde Mini-DIN-Anschluss mit 6 Pins. Früher Standard für Tastatur (lila) und Maus (grün). Heute durch USB ersetzt, taucht aber gern in Prüfungen auf.',
  ),
  Anschluss(
    id: 'klinke',
    name: 'Klinke 3,5 mm',
    kurzinfo: 'Analog · Audio · Kopfhörer, Mikrofon',
    erklaerung:
        'Der 3,5-mm-Klinkenstecker überträgt analoge Audiosignale. Die Ringe am Stecker trennen die Kanäle (z. B. links/rechts/Masse). Für Kopfhörer, Lautsprecher und Mikrofone.',
  ),
  Anschluss(
    id: 'lwl_lc',
    name: 'LWL (LC-Duplex)',
    kurzinfo: 'Glasfaser · Licht statt Strom · Duplex-Stecker',
    erklaerung:
        'LWL steht für Lichtwellenleiter (Glasfaser): Daten werden als Licht übertragen — schnell, über große Distanzen und unempfindlich gegen elektromagnetische Störungen. LC-Duplex hat zwei Stecker: eine Faser pro Richtung.',
  ),
  Anschluss(
    id: 'm2',
    name: 'M.2 (Key M)',
    kurzinfo: 'Interner Steckplatz · NVMe-/SATA-SSDs',
    erklaerung:
        'M.2 ist der flache Steckplatz direkt auf dem Mainboard, vor allem für moderne NVMe-SSDs. Die Kerbe (Key) bestimmt, welche Karten passen — Key M ist der Standard für schnelle SSDs.',
  ),
];
