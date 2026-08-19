// lib/data/kurse/sql_datensaetze.dart
//
// Die Übungsdatenbanken des SQL-Kurses.
//
// Bewusst EIN durchgehendes Szenario statt wechselnder Spielzeugtabellen:
// die "Nordwind GmbH", ein Handelsbetrieb. Wer in Lektion 9 einen JOIN
// schreibt, kennt die Tabellen dann schon aus Lektion 3 und muss sich nur
// noch auf das Neue konzentrieren.
//
// Spalten- und Tabellennamen sind deutsch — genau wie in IHK-Prüfungsaufgaben.

class SqlDatensatz {
  final String name;
  final String titel;
  final String beschreibung;

  /// CREATE TABLE + INSERT, wird vor jeder Abfrage frisch aufgebaut.
  final String schema;

  /// Für die Tabellenübersicht in der App.
  final Map<String, List<String>> tabellen;

  const SqlDatensatz({
    required this.name,
    required this.titel,
    required this.beschreibung,
    required this.schema,
    required this.tabellen,
  });
}

// ───────────────────────────────────────────────────────────────────────────
// Nordwind GmbH — Handelsbetrieb
// ───────────────────────────────────────────────────────────────────────────

const _nordwindSchema = r'''
CREATE TABLE abteilungen (
  abteilung_id INTEGER PRIMARY KEY,
  name         TEXT NOT NULL,
  standort     TEXT NOT NULL
);

CREATE TABLE mitarbeiter (
  mitarbeiter_id INTEGER PRIMARY KEY,
  name           TEXT    NOT NULL,
  abteilung_id   INTEGER REFERENCES abteilungen(abteilung_id),
  gehalt         INTEGER NOT NULL,
  eintritt       TEXT    NOT NULL
);

CREATE TABLE kunden (
  kunden_id  INTEGER PRIMARY KEY,
  name       TEXT NOT NULL,
  ort        TEXT NOT NULL,
  plz        TEXT NOT NULL,
  land       TEXT NOT NULL,
  kunde_seit TEXT NOT NULL
);

CREATE TABLE artikel (
  artikel_id  INTEGER PRIMARY KEY,
  bezeichnung TEXT    NOT NULL,
  kategorie   TEXT    NOT NULL,
  preis       REAL    NOT NULL,
  bestand     INTEGER NOT NULL
);

CREATE TABLE bestellungen (
  bestell_id INTEGER PRIMARY KEY,
  kunden_id  INTEGER REFERENCES kunden(kunden_id),
  datum      TEXT NOT NULL,
  status     TEXT NOT NULL
);

CREATE TABLE positionen (
  position_id INTEGER PRIMARY KEY,
  bestell_id  INTEGER REFERENCES bestellungen(bestell_id),
  artikel_id  INTEGER REFERENCES artikel(artikel_id),
  menge       INTEGER NOT NULL
);

INSERT INTO abteilungen VALUES
  (1, 'Vertrieb',   'Hamburg'),
  (2, 'Lager',      'Bremen'),
  (3, 'IT',         'Hamburg'),
  (4, 'Buchhaltung','Hamburg');

INSERT INTO mitarbeiter VALUES
  (1,  'Anna Berger',     1, 3800, '2019-03-01'),
  (2,  'Bilal Yilmaz',    1, 4100, '2017-09-15'),
  (3,  'Clara Wenzel',    2, 2900, '2021-01-04'),
  (4,  'Deniz Aydin',     2, 3050, '2020-06-22'),
  (5,  'Erik Sandmann',   3, 5200, '2016-02-01'),
  (6,  'Fatima Nouri',    3, 4800, '2022-08-01'),
  (7,  'Georg Hillmann',  4, 3600, '2018-11-12'),
  (8,  'Hanna Voigt',     1, 3950, '2023-04-03'),
  (9,  'Ivan Petrov',     2, 2850, '2024-01-08'),
  (10, 'Jana Kruse',      3, 4500, '2023-10-16'),
  (11, 'Kemal Öztürk',    4, 3400, '2022-02-14'),
  (12, 'Lena Fricke',  NULL, 3200, '2025-05-05');

INSERT INTO kunden VALUES
  (1,  'Elektro Mayer GmbH',   'Hamburg',   '20095', 'DE', '2019-04-11'),
  (2,  'Technik Nord AG',      'Kiel',      '24103', 'DE', '2020-01-30'),
  (3,  'Bürowelt Schmitt',     'Köln',      '50667', 'DE', '2021-07-02'),
  (4,  'CompuStore Wien',      'Wien',      '1010',  'AT', '2021-09-19'),
  (5,  'Digital Basel AG',     'Basel',     '4051',  'CH', '2022-03-08'),
  (6,  'Hansa IT Service',     'Bremen',    '28195', 'DE', '2022-05-25'),
  (7,  'Müller Elektronik',    'München',   '80331', 'DE', '2023-02-17'),
  (8,  'Nordlicht Systeme',    'Rostock',   '18055', 'DE', '2023-06-01'),
  (9,  'Alpen Computer GmbH',  'Innsbruck', '6020',  'AT', '2024-02-29'),
  (10, 'Rheinland Technik',    'Köln',      '50674', 'DE', '2024-08-13'),
  (11, 'Ostsee Datentechnik',  'Lübeck',    '23552', 'DE', '2025-01-20'),
  (12, 'Zürich Office Supply', 'Zürich',    '8001',  'CH', '2025-06-04');

INSERT INTO artikel VALUES
  (1,  'Laptop ProBook 14',    'Computer',    899.00,  12),
  (2,  'Laptop UltraSlim 13',  'Computer',   1249.00,   5),
  (3,  'Desktop Tower T400',   'Computer',    749.00,   8),
  (4,  'Monitor 24 Zoll',      'Peripherie',  189.00,  34),
  (5,  'Monitor 27 Zoll 4K',   'Peripherie',  429.00,  11),
  (6,  'Tastatur mechanisch',  'Peripherie',   89.00,  56),
  (7,  'Maus ergonomisch',     'Peripherie',   45.00,  78),
  (8,  'Headset Office',       'Peripherie',   69.00,  41),
  (9,  'SSD 1 TB',             'Speicher',    109.00,  63),
  (10, 'SSD 2 TB',             'Speicher',    189.00,  27),
  (11, 'USB-Stick 128 GB',     'Speicher',     19.00, 140),
  (12, 'Netzwerkkabel 5m',     'Netzwerk',      8.50, 220),
  (13, 'Switch 8-Port',        'Netzwerk',     59.00,  19),
  (14, 'WLAN-Router AX',       'Netzwerk',    129.00,  14),
  (15, 'Dockingstation USB-C', 'Peripherie',  159.00,   0);

INSERT INTO bestellungen VALUES
  (1001, 1,  '2025-01-15', 'geliefert'),
  (1002, 3,  '2025-02-03', 'geliefert'),
  (1003, 1,  '2025-02-28', 'geliefert'),
  (1004, 5,  '2025-03-11', 'storniert'),
  (1005, 2,  '2025-03-24', 'geliefert'),
  (1006, 7,  '2025-04-08', 'geliefert'),
  (1007, 4,  '2025-04-19', 'offen'),
  (1008, 1,  '2025-05-02', 'geliefert'),
  (1009, 6,  '2025-05-21', 'geliefert'),
  (1010, 8,  '2025-06-09', 'offen'),
  (1011, 3,  '2025-06-27', 'geliefert'),
  (1012, 10, '2025-07-14', 'geliefert'),
  (1013, 2,  '2025-08-01', 'offen'),
  (1014, 9,  '2025-08-18', 'geliefert'),
  (1015, 11, '2025-09-05', 'offen');

INSERT INTO positionen VALUES
  (1,  1001, 1,  2), (2,  1001, 4,  4), (3,  1001, 6,  4),
  (4,  1002, 9,  10),(5,  1002, 11, 25),
  (6,  1003, 2,  1), (7,  1003, 5,  2), (8,  1003, 15, 1),
  (9,  1004, 3,  3),
  (10, 1005, 12, 50),(11, 1005, 13, 2), (12, 1005, 14, 1),
  (13, 1006, 1,  1), (14, 1006, 7,  3),
  (15, 1007, 4,  6), (16, 1007, 8,  6),
  (17, 1008, 10, 4), (18, 1008, 9,  2), (19, 1008, 11, 10),
  (20, 1009, 3,  2), (21, 1009, 6,  2), (22, 1009, 7,  2),
  (23, 1010, 5,  3),
  (24, 1011, 2,  2), (25, 1011, 15, 2),
  (26, 1012, 12, 100),
  (27, 1013, 1,  3), (28, 1013, 4,  3), (29, 1013, 9,  3),
  (30, 1014, 14, 2), (31, 1014, 13, 1),
  (32, 1015, 8,  10),(33, 1015, 7,  10);
''';

const nordwind = SqlDatensatz(
  name: 'nordwind',
  titel: 'Nordwind GmbH',
  beschreibung:
      'Ein Handelsbetrieb für IT-Hardware: Kunden, Artikel, Bestellungen '
      'und Mitarbeiter. Diese Datenbank begleitet dich durch den ganzen Kurs.',
  schema: _nordwindSchema,
  tabellen: {
    'kunden': ['kunden_id', 'name', 'ort', 'plz', 'land', 'kunde_seit'],
    'artikel': ['artikel_id', 'bezeichnung', 'kategorie', 'preis', 'bestand'],
    'bestellungen': ['bestell_id', 'kunden_id', 'datum', 'status'],
    'positionen': ['position_id', 'bestell_id', 'artikel_id', 'menge'],
    'mitarbeiter': [
      'mitarbeiter_id',
      'name',
      'abteilung_id',
      'gehalt',
      'eintritt',
    ],
    'abteilungen': ['abteilung_id', 'name', 'standort'],
  },
);

/// Alle verfügbaren Datensätze, Zugriff über den Namen aus der Aufgabe.
const Map<String, SqlDatensatz> sqlDatensaetze = {
  'nordwind': nordwind,
};
