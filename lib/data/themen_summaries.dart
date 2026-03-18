// lib/data/themen_summaries.dart
// Zusammenfassungen für alle Themen — nach thema_id

const Map<int, Map<String, dynamic>> themenSummaries = {

  // ── NETZWERKE (9004) ─────────────────────────────────────────────────────

  9401: {
    'title': 'Netzwerk-Grundlagen',
    'emoji': '🌐',
    'sections': [
      {
        'heading': 'OSI- vs. TCP/IP-Modell',
        'text':
            'Das OSI-Modell hat 7 Schichten (Physical → Application), TCP/IP nur 4 (Network Access, Internet, Transport, Application). In der Praxis wird TCP/IP verwendet, OSI dient als Referenzmodell.\n\nMerkhilfe OSI von unten: "Phy-Da-Ve-Tr-Si-Da-An"',
      },
      {
        'heading': 'MAC- vs. IP-Adresse',
        'text':
            'MAC-Adresse: 48 Bit, Hardware-Adresse, eindeutig pro Netzwerkkarte (z.B. 00:1A:2B:3C:4D:5E). Wird in Schicht 2 verwendet.\n\nIP-Adresse: Logische Adresse, änderbar, wird für Routing verwendet (Schicht 3). IPv4 = 32 Bit, IPv6 = 128 Bit.',
      },
      {
        'heading': 'Wichtige Protokolle',
        'text':
            'Ping (ICMP): Testet Erreichbarkeit eines Hosts\nARP: Löst IP-Adressen in MAC-Adressen auf\nDHCP: Vergibt IP-Adressen automatisch\nDNS: Löst Domainnamen in IP-Adressen auf',
      },
      {
        'heading': 'Hub vs. Switch',
        'text':
            'Hub (Schicht 1): Sendet Daten an ALLE Ports — ineffizient, Kollisionen möglich.\nSwitch (Schicht 2): Lernt MAC-Adressen und sendet nur an den richtigen Port — effizient, keine Kollisionen.',
      },
    ],
  },

  9402: {
    'title': 'IP & Subnetze Basics',
    'emoji': '📊',
    'sections': [
      {
        'heading': 'IPv4-Aufbau',
        'text':
            'Eine IPv4-Adresse besteht aus 32 Bit = 4 Oktette (0-255).\nBeispiel: 192.168.1.100\nNetzanteil + Hostanteil werden durch die Subnetzmaske getrennt.',
      },
      {
        'heading': 'Subnetzmaske & CIDR',
        'text':
            '/24 = 255.255.255.0 → 254 Hosts\n/25 = 255.255.255.128 → 126 Hosts\n/26 = 255.255.255.192 → 62 Hosts\n/27 = 255.255.255.224 → 30 Hosts\n/28 = 255.255.255.240 → 14 Hosts\n\nFormel: Hosts = 2^(32-Präfix) - 2',
      },
      {
        'heading': 'Netz- & Broadcastadresse',
        'text':
            'Netzadresse: Erste Adresse im Subnetz (Host-Bits alle 0) — nicht nutzbar\nBroadcast: Letzte Adresse (Host-Bits alle 1) — nicht nutzbar\n\nBeispiel: 192.168.1.0/24\nNetz: 192.168.1.0\nBroadcast: 192.168.1.255\nNutzbar: 192.168.1.1 – 192.168.1.254',
      },
      {
        'heading': 'Private IP-Bereiche',
        'text':
            'Klasse A: 10.0.0.0/8\nKlasse B: 172.16.0.0/12\nKlasse C: 192.168.0.0/16\n\nDiese Adressen sind nicht im Internet routbar — nur für interne Netze.',
      },
    ],
  },

  9403: {
    'title': 'Switching & VLANs',
    'emoji': '🔀',
    'sections': [
      {
        'heading': 'Switch-Funktionsweise',
        'text':
            'Ein Switch lernt MAC-Adressen durch Beobachten des Netzverkehrs und speichert sie in der MAC-Adresstabelle (CAM-Table). Eingehende Frames werden nur an den richtigen Port weitergeleitet.',
      },
      {
        'heading': 'VLAN (Virtual LAN)',
        'text':
            'VLANs trennen ein physisches Netzwerk in mehrere logische Netze auf.\nVorteile: Sicherheit (Abteilungen isolieren), Broadcast-Reduzierung, Flexibilität.\n\nAccess Port: Gehört zu einem VLAN (für Endgeräte)\nTrunk Port: Trägt mehrere VLANs (zwischen Switches)',
      },
      {
        'heading': 'Spanning Tree Protocol (STP)',
        'text':
            'Verhindert Schleifen in geswitchten Netzwerken. Deaktiviert redundante Pfade, aktiviert sie aber bei Ausfall.\n\nBegriffe: Root Bridge, Root Port, Designated Port, Blocked Port',
      },
      {
        'heading': 'EtherChannel / Link Aggregation',
        'text':
            'Mehrere physische Links werden zu einem logischen Link zusammengefasst → mehr Bandbreite + Redundanz.\nProtokolle: LACP (IEEE 802.3ad) oder PAgP (Cisco)',
      },
    ],
  },

  9404: {
    'title': 'Routing & Dienste',
    'emoji': '🗺️',
    'sections': [
      {
        'heading': 'Router & Routing',
        'text':
            'Ein Router verbindet verschiedene Netzwerke (Schicht 3) und leitet Pakete anhand der IP-Adresse weiter.\n\nRouting-Tabelle: Enthält Netzwerke + nächsten Hop + Metrik\nDefault Route: 0.0.0.0/0 → wird verwendet wenn kein spezifischer Eintrag passt',
      },
      {
        'heading': 'Statisches vs. Dynamisches Routing',
        'text':
            'Statisch: Routen manuell eingetragen. Einfach, aber kein Failover.\n\nDynamisch: Router tauschen Routing-Infos aus.\nRIP: Distanz-Vektor, max. 15 Hops\nOSPF: Link-State, schnell, skalierbar\nBGP: Zwischen Autonomen Systemen (Internet)',
      },
      {
        'heading': 'NAT (Network Address Translation)',
        'text':
            'Übersetzt private IP-Adressen in öffentliche. Ermöglicht vielen Geräten mit einer öffentlichen IP ins Internet.\n\nSNAT/Masquerading: Viele interne → eine externe IP\nDNAT/Port Forwarding: Externe Anfragen zu internem Server weiterleiten',
      },
      {
        'heading': 'Wichtige Netzwerkdienste',
        'text':
            'DHCP: Automatische IP-Vergabe (Port 67/68 UDP)\nDNS: Namensauflösung (Port 53 TCP/UDP)\nNTP: Zeitsynchronisation (Port 123 UDP)\nSNMP: Netzwerkverwaltung (Port 161 UDP)',
      },
    ],
  },

  9405: {
    'title': 'Security & Troubleshooting',
    'emoji': '🛡️',
    'sections': [
      {
        'heading': 'Firewall-Typen',
        'text':
            'Paketfilter: Prüft IP/Port, zustandslos, einfach\nStateful Inspection: Verfolgt Verbindungszustand\nApplication Layer Firewall (WAF): Versteht Anwendungsprotokolle\nNext-Gen Firewall (NGFW): IDS/IPS, Deep Packet Inspection',
      },
      {
        'heading': 'VPN',
        'text':
            'Verschlüsselter Tunnel über unsicheres Netz.\n\nSite-to-Site VPN: Verbindet zwei Standorte\nRemote Access VPN: Einzelner Nutzer ins Firmennetz\n\nProtokolle: IPSec, OpenVPN, WireGuard\nIPSec-Modi: Transport (End-to-End) vs. Tunnel (Gateway-to-Gateway)',
      },
      {
        'heading': 'Häufige Angriffe',
        'text':
            'ARP-Spoofing: Falsche MAC-Adressen verbreiten → Man-in-the-Middle\nDDoS: Server mit Anfragen überfluten\nPort Scanning: Offene Ports erkunden (nmap)\nSNMP-Angriffe: Community Strings erraten',
      },
      {
        'heading': 'Troubleshooting-Befehle',
        'text':
            'ping: Erreichbarkeit testen\ntraceroute/tracert: Pfad zum Ziel anzeigen\nnslookup/dig: DNS-Abfragen\nnetstat/ss: Aktive Verbindungen anzeigen\nipconfig/ip addr: IP-Konfiguration anzeigen\nwireshark/tcpdump: Netzverkehr analysieren',
      },
    ],
  },

  // ── DATENBANKEN (9003) ───────────────────────────────────────────────────

  9301: {
    'title': 'Relationale Grundlagen',
    'emoji': '🗃️',
    'sections': [
      {
        'heading': 'Grundbegriffe',
        'text':
            'Tabelle (Relation): Speichert Daten in Zeilen (Tupel) und Spalten (Attribute)\nPrimärschlüssel (PK): Eindeutiger Bezeichner einer Zeile — darf nicht NULL sein\nFremdschlüssel (FK): Verweist auf PK einer anderen Tabelle\nIndex: Beschleunigt Abfragen auf häufig gesuchte Spalten',
      },
      {
        'heading': 'Beziehungstypen',
        'text':
            '1:1 — Ein Datensatz gehört zu genau einem anderen (z.B. Person → Ausweis)\n1:n — Ein Datensatz zu vielen (z.B. Kunde → Bestellungen)\nn:m — Viele zu viele → braucht Zwischentabelle (z.B. Schüler ↔ Kurse)',
      },
      {
        'heading': 'ER-Modell',
        'text':
            'Entity-Relationship-Modell visualisiert Daten und ihre Beziehungen.\n\nEntität: Ein Objekt (z.B. Kunde)\nAttribut: Eigenschaft einer Entität (z.B. Name)\nBeziehung: Verbindung zwischen Entitäten\n\nNotationen: Chen-Notation, Krähenfuß-Notation (Crow\'s Foot)',
      },
      {
        'heading': 'ACID-Eigenschaften',
        'text':
            'Atomicity: Transaktion ganz oder gar nicht\nConsistency: Datenbank bleibt konsistent\nIsolation: Transaktionen beeinflussen sich nicht\nDurability: Abgeschlossene Transaktionen bleiben gespeichert',
      },
    ],
  },

  9302: {
    'title': 'SQL Basics',
    'emoji': '💬',
    'sections': [
      {
        'heading': 'Grundlegende Befehle',
        'text':
            'SELECT spalte FROM tabelle — Daten lesen\nINSERT INTO tabelle (sp1, sp2) VALUES (v1, v2) — Einfügen\nUPDATE tabelle SET spalte=wert WHERE bedingung — Ändern\nDELETE FROM tabelle WHERE bedingung — Löschen',
      },
      {
        'heading': 'WHERE & Operatoren',
        'text':
            'WHERE name = \'Max\' — Gleichheit\nWHERE alter > 18 — Vergleich\nWHERE name LIKE \'M%\' — Muster (% = beliebig viele Zeichen)\nWHERE id IN (1,2,3) — Liste\nWHERE alter BETWEEN 18 AND 30 — Bereich\nWHERE name IS NULL — NULL-Prüfung',
      },
      {
        'heading': 'ORDER BY & LIMIT',
        'text':
            'ORDER BY name ASC — aufsteigend\nORDER BY name DESC — absteigend\nLIMIT 10 — nur 10 Ergebnisse\nOFFSET 20 — ab dem 21. Ergebnis (Pagination)',
      },
      {
        'heading': 'Aggregatfunktionen',
        'text':
            'COUNT(*) — Anzahl der Zeilen\nSUM(preis) — Summe\nAVG(preis) — Durchschnitt\nMIN/MAX(preis) — Minimum/Maximum\n\nMit GROUP BY:\nSELECT land, COUNT(*) FROM kunden GROUP BY land\nHAVING COUNT(*) > 10 — Filtert nach Aggregation',
      },
    ],
  },

  9303: {
    'title': 'SQL Vertieft',
    'emoji': '🔗',
    'sections': [
      {
        'heading': 'JOIN-Typen',
        'text':
            'INNER JOIN: Nur übereinstimmende Zeilen beider Tabellen\nLEFT JOIN: Alle Zeilen links + übereinstimmende rechts (fehlende = NULL)\nRIGHT JOIN: Alle Zeilen rechts + übereinstimmende links\nFULL OUTER JOIN: Alle Zeilen beider Tabellen\nCROSS JOIN: Kartesisches Produkt (alle Kombinationen)',
      },
      {
        'heading': 'Subqueries',
        'text':
            'Eine Abfrage innerhalb einer Abfrage:\nSELECT * FROM kunden WHERE id IN (SELECT kunden_id FROM bestellungen WHERE betrag > 100)\n\nKorrelierte Subquery: Bezieht sich auf äußere Abfrage — langsamer, aber mächtig',
      },
      {
        'heading': 'Views',
        'text':
            'Eine gespeicherte SELECT-Abfrage die wie eine Tabelle verwendet wird:\nCREATE VIEW vip_kunden AS SELECT * FROM kunden WHERE umsatz > 10000\n\nVorteile: Wiederverwendbarkeit, Sicherheit (nur bestimmte Spalten zeigen)',
      },
      {
        'heading': 'Stored Procedures & Trigger',
        'text':
            'Stored Procedure: Gespeicherter SQL-Code der aufgerufen werden kann\nFunktion: Gibt Wert zurück\nTrigger: Wird automatisch bei INSERT/UPDATE/DELETE ausgeführt\n\nVorteil: Logik in der Datenbank, weniger Netzwerkverkehr',
      },
    ],
  },

  9304: {
    'title': 'Design & Normalisierung',
    'emoji': '📐',
    'sections': [
      {
        'heading': '1. Normalform (1NF)',
        'text':
            'Jede Spalte enthält atomare (unteilbare) Werte — keine Listen oder Gruppen.\n\n❌ Falsch: Telefonnummern = "01234, 05678"\n✅ Richtig: Separate Zeilen oder Tabelle für Telefonnummern',
      },
      {
        'heading': '2. Normalform (2NF)',
        'text':
            '1NF erfüllt + jedes Nicht-Schlüsselattribut hängt vom GESAMTEN Primärschlüssel ab (keine partiellen Abhängigkeiten).\n\nRelevant bei zusammengesetzten PKs:\n❌ Bestellung(ArtikelID, KundeID, KundeName) → KundeName hängt nur von KundeID ab',
      },
      {
        'heading': '3. Normalform (3NF)',
        'text':
            '2NF erfüllt + keine transitiven Abhängigkeiten (Nicht-Schlüssel darf nicht von anderem Nicht-Schlüssel abhängen).\n\n❌ Mitarbeiter(ID, AbteilungsID, AbteilungsLeiter) → AbteilungsLeiter hängt von AbteilungsID ab\n✅ Auslagern in eigene Abteilungstabelle',
      },
      {
        'heading': 'DDL-Befehle',
        'text':
            'CREATE TABLE: Tabelle erstellen\nALTER TABLE: Tabelle ändern (Spalte hinzufügen/löschen)\nDROP TABLE: Tabelle löschen\nCREATE INDEX: Index erstellen\n\nConstraints: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT',
      },
    ],
  },

  9305: {
    'title': 'Transaktionen & Indexe',
    'emoji': '⚙️',
    'sections': [
      {
        'heading': 'Transaktionen',
        'text':
            'BEGIN/START TRANSACTION — Transaktion starten\nCOMMIT — Änderungen speichern\nROLLBACK — Änderungen rückgängig machen\nSAVEPOINT — Zwischenpunkt für partielles Rollback\n\nACID garantiert Zuverlässigkeit (Atomicity, Consistency, Isolation, Durability)',
      },
      {
        'heading': 'Isolation Levels',
        'text':
            'READ UNCOMMITTED: Liest uncommittete Daten (Dirty Read möglich)\nREAD COMMITTED: Nur committete Daten (Standard bei vielen DBs)\nREPEATABLE READ: Gleiche Abfrage liefert gleiche Ergebnisse\nSERIALIZABLE: Höchste Isolation, Transaktionen wie sequenziell',
      },
      {
        'heading': 'Indexe',
        'text':
            'Beschleunigen SELECT-Abfragen, verlangsamen INSERT/UPDATE/DELETE.\n\nB-Tree Index: Standard, gut für Vergleiche (<, >, BETWEEN)\nHash Index: Nur für Gleichheit (=)\nComposite Index: Mehrere Spalten\n\nCREATE INDEX idx_name ON tabelle(spalte)',
      },
      {
        'heading': 'Deadlocks & Performance',
        'text':
            'Deadlock: Zwei Transaktionen warten gegenseitig aufeinander → DB bricht eine ab.\n\nPerformance-Tipps:\nEXPLAIN/EXPLAIN ANALYZE: Abfrageplan anzeigen\nIndexe auf WHERE/JOIN-Spalten\nN+1 Problem vermeiden (JOINs statt Schleifen)',
      },
    ],
  },

  // ── PROGRAMMIERUNG (9007) ────────────────────────────────────────────────

  9701: {
    'title': 'Syntax & Grundlagen',
    'emoji': '💻',
    'sections': [
      {
        'heading': 'Variablen & Datentypen',
        'text':
            'Primitive Typen: int, float/double, boolean, char, String\nDeklaration: int alter = 25;\nKonstanten: final/const (Java/Dart) oder const (JS)\n\nTypkonvertierung: Implizit (automatisch) vs. Explizit (Cast)',
      },
      {
        'heading': 'Operatoren',
        'text':
            'Arithmetisch: + - * / % (Modulo)\nVergleich: == != < > <= >=\nLogisch: && (AND) || (OR) ! (NOT)\nZuweisung: = += -= *= /=\nTernär: bedingung ? wert_wenn_true : wert_wenn_false',
      },
      {
        'heading': 'Ein- & Ausgabe',
        'text':
            'Python: input() / print()\nJava: Scanner / System.out.println()\nJavaScript: prompt() / console.log()\n\nFormatierung: String-Interpolation ("Hallo \${name}") oder Format-Methoden',
      },
      {
        'heading': 'Kommentare & Konventionen',
        'text':
            '// Einzeiliger Kommentar\n/* Mehrzeiliger Kommentar */\n\nNaming Conventions:\ncamelCase: Variablen & Methoden (meinName)\nPascalCase: Klassen (MeinKlasse)\nSNAKE_CASE: Konstanten (MAX_WERT)',
      },
    ],
  },

  9702: {
    'title': 'Kontroll- & Datenstrukturen',
    'emoji': '🔄',
    'sections': [
      {
        'heading': 'Kontrollstrukturen',
        'text':
            'if/else if/else: Bedingte Ausführung\nswitch/case: Mehrere Werte prüfen\nwhile: Schleife solange Bedingung true\ndo-while: Mindestens einmal ausführen\nfor: Zählschleife\nfor-each/for-in: Über Collection iterieren',
      },
      {
        'heading': 'Arrays & Listen',
        'text':
            'Array: Feste Größe, gleicher Datentyp, Index ab 0\nint[] zahlen = {1, 2, 3, 4, 5};\n\nListe (ArrayList/List): Dynamische Größe\nZugriff: zahlen[0], Länge: zahlen.length\n\nMehrdimensional: int[][] matrix = new int[3][3]',
      },
      {
        'heading': 'Maps & Sets',
        'text':
            'Map (HashMap): Schlüssel-Wert-Paare, kein Duplikat bei Keys\nmap.put("key", value) / map.get("key")\n\nSet (HashSet): Keine Duplikate, keine Reihenfolge\n\nStack: LIFO (Last In First Out)\nQueue: FIFO (First In First Out)',
      },
      {
        'heading': 'Funktionen & Methoden',
        'text':
            'Rückgabetyp methodenName(Parameter) { return wert; }\n\nvoid: Kein Rückgabewert\nParameter: by value (Kopie) vs. by reference (Original)\nÜberladung: Gleicher Name, verschiedene Parameter\nRekursion: Methode ruft sich selbst auf — braucht Abbruchbedingung!',
      },
    ],
  },

  9703: {
    'title': 'OOP & Fehlerbehandlung',
    'emoji': '🏗️',
    'sections': [
      {
        'heading': '4 Säulen der OOP',
        'text':
            'Kapselung: Daten verstecken (private), nur über Methoden zugreifbar\nVererbung: Klasse erbt von Elternklasse (extends/Sohn : Vater)\nPolymorphismus: Gleiche Methode, verschiedenes Verhalten\nAbstraktion: Komplexität verstecken, nur Wesentliches zeigen',
      },
      {
        'heading': 'Klassen & Objekte',
        'text':
            'Klasse: Bauplan/Vorlage\nObjekt: Instanz einer Klasse\n\nKonstruktor: Spezielle Methode zur Initialisierung\nthis: Verweis auf aktuelles Objekt\nstatic: Gehört zur Klasse, nicht zum Objekt\n\nGetter/Setter: Kontrollierter Zugriff auf Attribute',
      },
      {
        'heading': 'Abstrakte Klassen & Interfaces',
        'text':
            'Abstrakte Klasse: Kann nicht instanziiert werden, kann abstrakte Methoden haben\nInterface: Nur Methodendeklarationen (kein Code) → Vertrag\n\nKlasse kann mehrere Interfaces implementieren aber nur eine Klasse erben.',
      },
      {
        'heading': 'Fehlerbehandlung',
        'text':
            'try { riskanter Code }\ncatch (Exception e) { Fehlerbehandlung }\nfinally { wird immer ausgeführt }\n\nException werfen: throw new IllegalArgumentException("Fehler")\n\nEigene Exceptions: class MeineException extends Exception {}',
      },
    ],
  },

  9704: {
    'title': 'Build, Git & Tests',
    'emoji': '🔧',
    'sections': [
      {
        'heading': 'Git Grundlagen',
        'text':
            'git init — Repository erstellen\ngit add . — Änderungen stagen\ngit commit -m "Nachricht" — Snapshot speichern\ngit push — Auf Remote hochladen\ngit pull — Vom Remote laden\ngit clone URL — Repository kopieren',
      },
      {
        'heading': 'Git Branching',
        'text':
            'git branch feature — Branch erstellen\ngit checkout feature — Branch wechseln\ngit merge feature — Branch zusammenführen\ngit rebase — Commits auf anderen Branch übertragen\n\nGitFlow: main → develop → feature/bugfix branches',
      },
      {
        'heading': 'Unit Tests',
        'text':
            'AAA-Prinzip: Arrange (Setup), Act (Ausführen), Assert (Prüfen)\n\nTestarten:\nUnit Test: Einzelne Methode/Klasse\nIntegration Test: Zusammenspiel mehrerer Komponenten\nEnd-to-End Test: Gesamtes System\n\nMocking: Abhängigkeiten durch Fake-Objekte ersetzen',
      },
      {
        'heading': 'Build & Dependency Management',
        'text':
            'Maven/Gradle (Java): Build-Tool + Dependency Management\nnpm/yarn (JavaScript): Package Manager\npip (Python): Package Manager\n\nSemantic Versioning: MAJOR.MINOR.PATCH (z.B. 2.1.3)\nCI/CD: Automatisches Bauen und Deployen bei jedem Commit',
      },
    ],
  },

  9705: {
    'title': 'Algorithmen & Secure Coding',
    'emoji': '🧮',
    'sections': [
      {
        'heading': 'Sortieralgorithmen',
        'text':
            'Bubble Sort: O(n²) — einfach, langsam\nSelection Sort: O(n²) — findet immer Minimum\nInsertion Sort: O(n²) — gut für fast-sortierte Daten\nMerge Sort: O(n log n) — stabil, rekursiv\nQuick Sort: O(n log n) durchschnittlich — in-place\n\nFür die IHK: Bubble Sort + Merge Sort kennen!',
      },
      {
        'heading': 'Suchalgorithmen',
        'text':
            'Lineare Suche: O(n) — durchsucht jedes Element\nBinäre Suche: O(log n) — nur auf sortierten Arrays\n\nBeispiel Binäre Suche:\nMitte prüfen → wenn kleiner: links suchen → wenn größer: rechts suchen',
      },
      {
        'heading': 'Big-O Notation',
        'text':
            'Beschreibt Zeitkomplexität im worst-case:\nO(1) — Konstant (Array-Zugriff)\nO(log n) — Logarithmisch (Binäre Suche)\nO(n) — Linear (Lineare Suche)\nO(n log n) — Quasilinear (Merge Sort)\nO(n²) — Quadratisch (Bubble Sort)\nO(2^n) — Exponentiell (Brute Force)',
      },
      {
        'heading': 'Secure Coding',
        'text':
            'SQL-Injection verhindern: Prepared Statements verwenden\nXSS verhindern: User-Input escapen/sanitizen\nCSRF: Tokens verwenden\nPasswörter: Niemals im Klartext — bcrypt/argon2 zum Hashen\n\nPrinzip: Minimale Rechte (Least Privilege), Defense in Depth',
      },
    ],
  },

  // ── IT-SICHERHEIT (9008) ─────────────────────────────────────────────────

  9801: {
    'title': 'Sicherheits-Grundlagen',
    'emoji': '🔒',
    'sections': [
      {
        'heading': 'CIA-Triade',
        'text':
            'Confidentiality (Vertraulichkeit): Nur Berechtigte haben Zugriff\nIntegrity (Integrität): Daten sind unverändert und korrekt\nAvailability (Verfügbarkeit): Systeme sind erreichbar wenn gebraucht\n\nErweiterung: + Authenticity (Echtheit) + Non-Repudiation (Nichtabstreitbarkeit)',
      },
      {
        'heading': 'Bedrohungsarten',
        'text':
            'Malware: Viren, Trojaner, Ransomware, Spyware, Rootkits\nSocial Engineering: Phishing, Spear-Phishing, Vishing (Telefon), Pretexting\nInsider-Bedrohungen: Böswillige oder fahrlässige Mitarbeiter\nAPT: Advanced Persistent Threat — langfristige, gezielte Angriffe',
      },
      {
        'heading': 'Schutzmaßnahmen (technisch)',
        'text':
            'Firewall: Filtert Netzwerkverkehr\nIDS/IPS: Erkennt/verhindert Angriffe\nAntivirus/EDR: Erkennt Schadsoftware\nPatch Management: Sicherheitslücken schließen\nBackup: Regelmäßige Datensicherung nach 3-2-1-Regel',
      },
      {
        'heading': 'Schutzmaßnahmen (organisatorisch)',
        'text':
            'ISMS: Information Security Management System (ISO 27001)\nSicherheitsrichtlinien: Passwortregeln, Clean Desk Policy\nSchulungen: Security Awareness Training\nZugriffskontrolle: Need-to-Know-Prinzip, minimale Rechte',
      },
    ],
  },

  9802: {
    'title': 'Netz- & Web-Basics',
    'emoji': '🌐',
    'sections': [
      {
        'heading': 'Häufige Netzwerkangriffe',
        'text':
            'Man-in-the-Middle (MitM): Kommunikation abfangen und ggf. manipulieren\nARP-Poisoning: Falsche MAC-Adressen in ARP-Cache schreiben\nDNS-Spoofing: Falsche DNS-Antworten senden\nDDoS: Server mit Anfragen überfluten\nPort Scanning: Offene Dienste erkunden',
      },
      {
        'heading': 'Web-Angriffe (OWASP Top 10)',
        'text':
            'SQL-Injection: Schadcode in DB-Abfragen einschleusen\nXSS (Cross-Site Scripting): JavaScript in Webseite einschleusen\nCSRF: Opfer unbewusst Anfragen ausführen lassen\nBroken Authentication: Schwache Passwörter, Session-Übernahme\nInsecure Direct Object Reference: IDs manipulieren um fremde Daten zu sehen',
      },
      {
        'heading': 'HTTPS & TLS',
        'text':
            'TLS (Transport Layer Security) verschlüsselt HTTP-Verbindungen.\n\nTLS-Handshake:\n1. Client Hello (unterstützte Algorithmen)\n2. Server Hello + Zertifikat\n3. Schlüsselaustausch\n4. Verschlüsselte Kommunikation\n\nZertifikate: Von CA (Certificate Authority) signiert',
      },
      {
        'heading': 'Firewall & DMZ',
        'text':
            'DMZ (Demilitarisierte Zone): Netz zwischen Internet und internem Netz für öffentliche Server (Webserver, Mailserver).\n\nFirewallregeln: Whitelist (alles verboten außer...) ist sicherer als Blacklist\nStateful vs. Stateless: Stateful verfolgt Verbindungszustand',
      },
    ],
  },

  9803: {
    'title': 'Auth & Kryptografie',
    'emoji': '🔐',
    'sections': [
      {
        'heading': 'Authentifizierung',
        'text':
            'Wissensfaktor: Passwort, PIN\nBesitzfaktor: Smartcard, Token, Smartphone\nBiometrischer Faktor: Fingerabdruck, Gesicht\n\nMFA/2FA: Kombination aus ≥2 Faktoren\nSSO (Single Sign-On): Einmal anmelden, überall Zugriff',
      },
      {
        'heading': 'Symmetrische Verschlüsselung',
        'text':
            'Gleicher Schlüssel zum Ver- und Entschlüsseln.\nVorteil: Schnell\nNachteil: Schlüsselaustausch-Problem\n\nAlgorithmen: AES (128/256 Bit) — Standard heute\nVeraltet: DES (56 Bit — unsicher!), 3DES',
      },
      {
        'heading': 'Asymmetrische Verschlüsselung',
        'text':
            'Public Key (öffentlich): Zum Verschlüsseln/Signaturprüfen\nPrivate Key (geheim): Zum Entschlüsseln/Signieren\n\nAlgorithmen: RSA, ECC (Elliptic Curve)\nVerwendung: HTTPS, SSH, E-Mail-Verschlüsselung (PGP)\n\nDigitale Signatur: Mit Private Key signieren → Public Key prüfen',
      },
      {
        'heading': 'Hashfunktionen',
        'text':
            'Einweg-Funktion: Hash lässt sich nicht zurückrechnen\nGleicher Input → immer gleicher Hash\nKleiner Input-Unterschied → komplett anderer Hash\n\nAlgorithmen: SHA-256, SHA-3 (sicher), MD5/SHA-1 (veraltet!)\nVerwendung: Passwörter speichern (mit Salt!), Integrität prüfen',
      },
    ],
  },

  9804: {
    'title': 'Betrieb & Incident Response',
    'emoji': '🚨',
    'sections': [
      {
        'heading': 'Incident Response Phasen',
        'text':
            '1. Preparation: ISMS, Playbooks, Tools vorbereiten\n2. Identification: Angriff erkennen (SIEM, Logs)\n3. Containment: Ausbreitung stoppen (System isolieren)\n4. Eradication: Ursache beseitigen (Malware entfernen)\n5. Recovery: Systeme wiederherstellen\n6. Lessons Learned: Was verbessern?',
      },
      {
        'heading': 'Logging & Monitoring',
        'text':
            'SIEM (Security Information and Event Management): Sammelt und analysiert Logs zentral\n\nWichtige Logs: System, Auth, Firewall, Application\nLog-Analyse: Korrelation von Ereignissen\nRetention: Logs ausreichend lange aufbewahren (DSGVO beachten)',
      },
      {
        'heading': 'Patch & Vulnerability Management',
        'text':
            'CVE (Common Vulnerabilities and Exposures): Eindeutige ID für Sicherheitslücken\nCVSS-Score: 0-10, bewertet Schwere einer Lücke\n\nProzess: Scan → Bewerten → Priorisieren → Patchen → Verifizieren\n\nZero-Day: Lücke ohne verfügbaren Patch',
      },
      {
        'heading': 'BCM & Notfallplanung',
        'text':
            'BCM (Business Continuity Management): Betrieb auch bei Störungen aufrechterhalten\n\nRTO (Recovery Time Objective): Wie lange darf der Ausfall dauern?\nRPO (Recovery Point Objective): Wie viel Datenverlust ist akzeptabel?\n\nNotfallplan, Backup-Konzept, Ausweichstandort',
      },
    ],
  },

  9805: {
    'title': 'Secure Dev & Advanced',
    'emoji': '🛡️',
    'sections': [
      {
        'heading': 'Secure Development Lifecycle',
        'text':
            'Sicherheit von Anfang an einbauen (Shift Left):\n\nThreat Modeling: Bedrohungen früh identifizieren\nCode Reviews: Sicherheitsrelevanten Code prüfen\nSAST: Statische Code-Analyse\nDAST: Dynamische Tests (laufende Anwendung)\nPenetration Testing: Angriff simulieren',
      },
      {
        'heading': 'Secure Coding Prinzipien',
        'text':
            'Input Validation: Alle Eingaben prüfen/bereinigen\nOutput Encoding: XSS verhindern\nPrepared Statements: SQL-Injection verhindern\nLeast Privilege: Minimale Rechte\nFail Securely: Bei Fehler in sicheren Zustand\nDefense in Depth: Mehrere Sicherheitsschichten',
      },
      {
        'heading': 'PKI & Zertifikate',
        'text':
            'PKI (Public Key Infrastructure): Verwaltung von digitalen Zertifikaten\n\nCA (Certificate Authority): Vertrauenswürdige Stelle die Zertifikate ausstellt\nRoot CA → Intermediate CA → End-Entity Zertifikat\n\nX.509: Standard für digitale Zertifikate\nCRL/OCSP: Zertifikate widerrufen',
      },
      {
        'heading': 'Compliance & Standards',
        'text':
            'ISO 27001: ISMS-Standard\nBSI Grundschutz: Deutscher IT-Sicherheitsstandard\nDSGVO: Datenschutz in der EU\nPCI-DSS: Kreditkartendaten-Sicherheit\nSOC 2: Cloud-Dienstleister-Audit\n\nPentesting: White-Box, Grey-Box, Black-Box',
      },
    ],
  },

  // ── BETRIEBSSYSTEME & LINUX (9005) ───────────────────────────────────────

  9501: {
    'title': 'OS- & Shell-Grundlagen',
    'emoji': '🖥️',
    'sections': [
      {
        'heading': 'Betriebssystem-Aufgaben',
        'text':
            'Prozessverwaltung: CPU-Zeit auf Prozesse verteilen\nSpeicherverwaltung: RAM zuweisen und freigeben\nDateisystemverwaltung: Dateien lesen/schreiben\nGerätemanagement: Hardware ansprechen (Treiber)\nBenutzerverwaltung: Zugriffsrechte verwalten',
      },
      {
        'heading': 'Kernel-Typen',
        'text':
            'Monolithischer Kernel: Alles im Kernel-Space (Linux)\n→ Schnell, aber Absturz des Kernels = Systemabsturz\n\nMikrokernel: Nur Basics im Kernel, Rest in User-Space (Minix)\n→ Stabiler, aber langsamer\n\nHybridkernel: Mischung (Windows NT, macOS)',
      },
      {
        'heading': 'Shell-Grundlagen',
        'text':
            'Shell: Kommandozeileninterpreter zwischen Nutzer und Kernel\n\nBash: Standard auf Linux/macOS\nZsh: Modernere Alternative\nPowerShell: Windows\n\nPrompt: user@hostname:~/pfad\$\n~ = Home-Verzeichnis\n/ = Root-Verzeichnis',
      },
      {
        'heading': 'Grundlegende Befehle',
        'text':
            'pwd — Aktuellen Pfad anzeigen\nls -la — Dateien auflisten (inkl. versteckte)\ncd /pfad — Verzeichnis wechseln\nmkdir name — Ordner erstellen\nrm -rf ordner — Ordner löschen (Vorsicht!)\ncp quelle ziel — Kopieren\nmv quelle ziel — Verschieben/Umbenennen\ncat datei — Inhalt anzeigen',
      },
    ],
  },

  9502: {
    'title': 'Linux CLI & Tools Basics',
    'emoji': '⌨️',
    'sections': [
      {
        'heading': 'Textverarbeitung',
        'text':
            'grep "muster" datei — Text suchen\ngrep -r "muster" /pfad — Rekursiv suchen\nsed \'s/alt/neu/g\' datei — Text ersetzen\nawk \'{print \$1}\' datei — Spalten verarbeiten\ncut -d"," -f1 datei — Spalten ausschneiden\nsort datei — Sortieren\nuniq — Duplikate entfernen',
      },
      {
        'heading': 'Pipes & Redirects',
        'text':
            '| (Pipe): Ausgabe als Eingabe weiterleiten\nls -la | grep ".txt" — Nur .txt Dateien\n\n> — Ausgabe in Datei (überschreiben)\n>> — Ausgabe anhängen\n< — Eingabe aus Datei\n2> — Fehlerausgabe umleiten\n\nBeispiel: ls /etc 2>/dev/null | sort > liste.txt',
      },
      {
        'heading': 'Paketverwaltung',
        'text':
            'Debian/Ubuntu (apt):\napt update — Paketliste aktualisieren\napt install paket — Installieren\napt remove paket — Deinstallieren\napt upgrade — Alle Pakete aktualisieren\n\nRHEL/CentOS (yum/dnf):\ndnf install paket\ndnf update',
      },
      {
        'heading': 'Hilfsbefehle',
        'text':
            'man befehl — Handbuch anzeigen\nbefehl --help — Kurzhilfe\nwhich befehl — Pfad des Befehls\nhistory — Befehlshistorie\ntab — Autovervollständigung\nstrg+c — Prozess abbrechen\nstrg+z — Prozess pausieren',
      },
    ],
  },

  9503: {
    'title': 'Dateien & Berechtigungen',
    'emoji': '📁',
    'sections': [
      {
        'heading': 'Linux-Dateisystem',
        'text':
            '/ — Root\n/home — Benutzerverzeichnisse\n/etc — Konfigurationsdateien\n/var — Variable Daten (Logs)\n/tmp — Temporäre Dateien\n/bin, /usr/bin — Programme\n/lib — Bibliotheken\n/proc — Kernel-Infos (virtuell)',
      },
      {
        'heading': 'Berechtigungen (rwx)',
        'text':
            'r (read=4), w (write=2), x (execute=1)\n\n-rwxr-xr-- = Besitzer: rwx, Gruppe: r-x, Andere: r--\n\nOktal: 755 = rwxr-xr-x\n       644 = rw-r--r--\n       600 = rw-------\n\nchmod 755 datei — Rechte setzen\nchown user:gruppe datei — Besitzer ändern',
      },
      {
        'heading': 'Spezielle Berechtigungen',
        'text':
            'SUID (4xxx): Programm läuft mit Rechten des Besitzers\nSGID (2xxx): Programm läuft mit Gruppenrechten\nSticky Bit (1xxx): Nur Besitzer kann löschen (z.B. /tmp)\n\nBeispiel: chmod 4755 datei (SUID setzen)',
      },
      {
        'heading': 'Links & Suche',
        'text':
            'Hard Link: ln quelle ziel — Zeigt auf gleiche Inode\nSymbolic Link: ln -s quelle ziel — Wie Verknüpfung\n\nfind /pfad -name "*.log" — Dateien suchen\nfind /pfad -mtime -7 — Letzte 7 Tage geändert\nfind /pfad -size +100M — Größer als 100MB\nlocate dateiname — Schnellsuche (Index)',
      },
    ],
  },

  9504: {
    'title': 'Prozesse & Systemdienste',
    'emoji': '⚙️',
    'sections': [
      {
        'heading': 'Prozessverwaltung',
        'text':
            'ps aux — Alle Prozesse anzeigen\ntop / htop — Prozesse live beobachten\nkill PID — Prozess beenden (SIGTERM)\nkill -9 PID — Prozess zwangsbeenden (SIGKILL)\npkill name — Nach Name beenden\nnohup befehl & — Im Hintergrund, auch nach Logout',
      },
      {
        'heading': 'Prozess-Zustände',
        'text':
            'Running (R): Wird gerade ausgeführt\nSleeping (S): Wartet auf Ereignis\nDisk Sleep (D): Wartet auf I/O (nicht unterbrechbar)\nZombie (Z): Beendet, aber noch nicht vom Parent abgeholt\nStopped (T): Pausiert (strg+z)',
      },
      {
        'heading': 'Systemd & Services',
        'text':
            'systemctl start dienst — Starten\nsystemctl stop dienst — Stoppen\nsystemctl restart dienst — Neustart\nsystemctl status dienst — Status anzeigen\nsystemctl enable dienst — Autostart aktivieren\nsystemctl disable dienst — Autostart deaktivieren\njournalctl -u dienst — Logs anzeigen',
      },
      {
        'heading': 'Cronjobs',
        'text':
            'crontab -e — Cronjobs bearbeiten\n\nFormat: Minute Stunde Tag Monat Wochentag Befehl\n\n* * * * * — Jede Minute\n0 2 * * * — Täglich um 2:00 Uhr\n0 9 * * 1 — Jeden Montag um 9:00 Uhr\n*/5 * * * * — Alle 5 Minuten\n\n@reboot — Bei Systemstart',
      },
    ],
  },

  9505: {
    'title': 'Security & Scripting',
    'emoji': '🔐',
    'sections': [
      {
        'heading': 'SSH',
        'text':
            'ssh user@host — Verbinden\nssh -p 2222 user@host — Anderer Port\nssh-keygen — Schlüsselpaar erzeugen\nssh-copy-id user@host — Public Key übertragen\n\nKonfiguration: /etc/ssh/sshd_config\nWichtig: PermitRootLogin no, PasswordAuthentication no',
      },
      {
        'heading': 'Bash-Scripting Grundlagen',
        'text':
            '#!/bin/bash — Shebang (erste Zeile)\nvariable="wert" — Variable setzen\necho \$variable — Ausgeben\n\nif [ "\$var" = "wert" ]; then\n  echo "wahr"\nfi\n\nfor i in 1 2 3; do echo \$i; done\n\nwhile [ \$x -lt 10 ]; do x=\$((x+1)); done',
      },
      {
        'heading': 'Nützliche Sicherheitsbefehle',
        'text':
            'last — Letzte Logins anzeigen\nwho — Aktuell eingeloggte Nutzer\nnetstat -tulpn / ss -tulpn — Offene Ports\nufw status — Firewall-Status (Ubuntu)\niptables -L — Firewall-Regeln\nfail2ban-client status — Brute-Force-Schutz',
      },
      {
        'heading': 'Logs & Diagnose',
        'text':
            'journalctl -f — Logs live verfolgen\njournalctl --since "1 hour ago" — Letzte Stunde\ntail -f /var/log/syslog — Systemlog verfolgen\ndmesg — Kernel-Meldungen\nlsof -i :80 — Wer nutzt Port 80?\ndf -h — Festplattenplatz\nfree -h — RAM-Auslastung',
      },
    ],
  },

  // ── IT-GRUNDLAGEN & HARDWARE (9006) ──────────────────────────────────────

  9601: {
    'title': 'Hardware-Basics',
    'emoji': '🖥️',
    'sections': [
      {
        'heading': 'CPU',
        'text':
            'Holt Befehle, dekodiert und führt sie aus (Fetch-Decode-Execute).\n\nKerne: Mehrere unabhängige Prozessorkerne\nTakt: GHz = Milliarden Zyklen/Sekunde\nCache: L1 (schnell/klein) → L2 → L3 (langsam/groß)\n\nHyper-Threading: Ein Kern simuliert zwei logische Kerne',
      },
      {
        'heading': 'Mainboard & Bus',
        'text':
            'Northbridge: Verbindet CPU, RAM, GPU (heute meist in CPU integriert)\nSouthbridge: Verbindet USB, SATA, PCIe\n\nBusse: PCIe (Grafikkarte, NVMe), SATA (Festplatten), USB, M.2\n\nBIOS/UEFI: Firmware, startet Hardware und lädt Bootloader',
      },
      {
        'heading': 'RAM-Typen',
        'text':
            'DRAM: Dynamisch, braucht Refresh (normaler RAM)\nSRAM: Statisch, schnell, teuer (Cache)\nDDR4/DDR5: Aktueller Standard\n\nECC RAM: Fehlerkorrektur (Server)\nDual-Channel: Zwei RAM-Riegel für doppelte Bandbreite',
      },
      {
        'heading': 'Netzteil & Formfaktoren',
        'text':
            'Wirkungsgrad: 80 PLUS Bronze/Silver/Gold/Platinum\nFormfaktoren: ATX (Desktop), mATX, ITX (klein)\n\nStromanschlüsse: 24-Pin Mainboard, 8-Pin CPU, PCIe 6/8-Pin GPU\n\nThermal Design Power (TDP): Wärme die ein Prozessor erzeugt',
      },
    ],
  },

  9602: {
    'title': 'Storage & Dateisysteme',
    'emoji': '💾',
    'sections': [
      {
        'heading': 'Speichertypen',
        'text':
            'HDD (Magnetisch): Günstig, viel Kapazität, langsam (~100 MB/s)\nSSD SATA: Schneller (~500 MB/s), gleicher Anschluss wie HDD\nNVMe SSD: Sehr schnell (3000-7000 MB/s), PCIe-Anschluss\n\nOptisch: CD (700MB), DVD (4,7GB), Blu-Ray (25GB)',
      },
      {
        'heading': 'Dateisysteme',
        'text':
            'NTFS: Windows-Standard, große Dateien, Rechte, Journal\nFAT32: Kompatibel, max 4GB pro Datei, kein Journal\nexFAT: USB-Sticks, große Dateien, kein Journal\next4: Linux-Standard, Journal, groß\nXFS: Große Dateien, gut für Server\nZFS/Btrfs: Modern, Snapshots, RAID integriert',
      },
      {
        'heading': 'RAID (Wiederholung)',
        'text':
            'RAID 0: Striping, kein Schutz, maximale Kapazität\nRAID 1: Mirroring, 1 Ausfall tolerierbar\nRAID 5: Parität verteilt, 1 Ausfall, mind. 3 Platten\nRAID 6: Doppelte Parität, 2 Ausfälle, mind. 4 Platten\nRAID 10: Mirror+Stripe, schnell+sicher, mind. 4 Platten',
      },
      {
        'heading': 'Partitionierung',
        'text':
            'MBR (Master Boot Record): Max 4 primäre Partitionen, max 2TB\nGPT (GUID Partition Table): Bis 128 Partitionen, >2TB, moderner Standard\n\nTools: fdisk, parted (Linux), Datenträgerverwaltung (Windows)\n\nSwap: Auslagerungspartition wenn RAM voll (langsamer)',
      },
    ],
  },

  9603: {
    'title': 'RAM & Performance',
    'emoji': '🚀',
    'sections': [
      {
        'heading': 'Speicherhierarchie',
        'text':
            'Register: Direkt in CPU, < 1ns, Bytes\nL1-Cache: 1-2ns, 32-128 KB pro Kern\nL2-Cache: 3-10ns, 256KB-4MB\nL3-Cache: 10-40ns, 8-64MB\nRAM: 50-100ns, GB-Bereich\nSSD: 100µs, TB-Bereich\nHDD: 10ms, TB-Bereich',
      },
      {
        'heading': 'Virtueller Speicher',
        'text':
            'Betriebssystem simuliert mehr RAM durch Auslagerung auf Festplatte (Swap/Auslagerungsdatei).\n\nPage: Speicherblock (4KB) der ausgelagert wird\nPage Fault: Zugriff auf ausgelagerte Seite → muss eingelesen werden\nThrashing: Zu viel Swapping → System wird extrem langsam',
      },
      {
        'heading': 'Performance-Engpässe',
        'text':
            'CPU-Bottleneck: CPU ist zu langsam (hohe CPU-Auslastung)\nRAM-Bottleneck: Zu wenig RAM → Swapping\nI/O-Bottleneck: Festplatte zu langsam\nNetzwerk-Bottleneck: Zu wenig Bandbreite\n\nTools: top/htop (CPU/RAM), iotop (Disk I/O), iftop (Netzwerk)',
      },
      {
        'heading': 'Benchmarking',
        'text':
            'sysbench: CPU, RAM, Disk testen\ndd: Schreib-/Lesegeschwindigkeit\nfio: Professionelles I/O-Benchmarking\niperf3: Netzwerkbandbreite\n\nLatenz vs. Throughput:\nLatenz = Wie lange dauert eine Anfrage?\nThroughput = Wie viele Anfragen pro Sekunde?',
      },
    ],
  },

  9604: {
    'title': 'Virtualisierung & Cloud',
    'emoji': '☁️',
    'sections': [
      {
        'heading': 'Virtualisierungstypen',
        'text':
            'Typ-1 Hypervisor (Bare Metal): Direkt auf Hardware (VMware ESXi, Hyper-V, KVM)\nTyp-2 Hypervisor (Hosted): Auf Betriebssystem (VirtualBox, VMware Workstation)\n\nContainer: Kein eigener Kernel, teilt Host-Kernel (Docker)\n→ Leichter, schneller, aber weniger Isolation',
      },
      {
        'heading': 'Cloud-Servicemodelle',
        'text':
            'IaaS (Infrastructure as a Service): VM, Netzwerk, Storage (AWS EC2, Azure VM)\nPaaS (Platform as a Service): Laufzeitumgebung (Heroku, Google App Engine)\nSaaS (Software as a Service): Fertige Software (Office 365, Salesforce)\n\nFaustregel: IaaS = Zutaten, PaaS = Küche, SaaS = Fertiggericht',
      },
      {
        'heading': 'Cloud-Deployment-Modelle',
        'text':
            'Public Cloud: Ressourcen geteilt, kostengünstig (AWS, Azure, GCP)\nPrivate Cloud: Eigene Infrastruktur, mehr Kontrolle\nHybrid Cloud: Mix aus public und private\nMulti-Cloud: Mehrere Cloud-Anbieter nutzen\n\nShared Responsibility Model: Anbieter = Infrastruktur, Kunde = Daten/Anwendungen',
      },
      {
        'heading': 'Skalierung',
        'text':
            'Horizontal (Scale Out): Mehr Server hinzufügen\nVertikal (Scale Up): Größerer Server\n\nElastizität: Automatisch skalieren je nach Last\nAuto-Scaling: Regeln definieren wann neue Instanzen gestartet werden\n\nHigh Availability: Redundanz, keine Single Points of Failure',
      },
    ],
  },

  9605: {
    'title': 'Security & Troubleshooting (HW)',
    'emoji': '🔧',
    'sections': [
      {
        'heading': 'Hardware-Sicherheit',
        'text':
            'TPM (Trusted Platform Module): Chip für kryptografische Schlüssel\nSecure Boot: Nur signierte Software beim Start\nFull Disk Encryption: BitLocker (Windows), LUKS (Linux)\n\nPhysische Sicherheit: Serverräume absichern, Kensington Lock, keine USB-Geräte',
      },
      {
        'heading': 'Häufige Hardware-Fehler',
        'text':
            'Kein Start: Netzteil defekt, RAM falsch eingesetzt, POST-Fehler\nAbsturz (BSOD/Kernel Panic): Überhitzung, defektes RAM, Treiber\nLangsam: Festplatte fast voll, zu wenig RAM, Malware, Überhitzung\nKein Netzwerk: Kabel, Treiber, IP-Konfiguration prüfen',
      },
      {
        'heading': 'Diagnose-Tools',
        'text':
            'memtest86: RAM testen\nCrystalDiskInfo: Festplattenzustand (S.M.A.R.T.)\nHWiNFO/HWMonitor: Temperaturen, Spannungen\nEvent-Viewer (Windows): System-Logs\n\nS.M.A.R.T.: Festplatten-Selbstdiagnose\nReallocated Sectors: Defekte Sektoren — Festplatte tauschen!',
      },
      {
        'heading': 'Troubleshooting-Methodik',
        'text':
            '1. Problem definieren\n2. Informationen sammeln\n3. Hypothese aufstellen\n4. Lösung testen\n5. Ergebnis dokumentieren\n\nOSI Top-Down: Von Layer 7 nach unten\nOSI Bottom-Up: Von Layer 1 nach oben\nDivide & Conquer: In der Mitte anfangen',
      },
    ],
  },

  // ── WEBENTWICKLUNG (9009) ────────────────────────────────────────────────

  9901: {
    'title': 'HTML/CSS/HTTP Basics',
    'emoji': '🌐',
    'sections': [
      {
        'heading': 'HTML-Grundstruktur',
        'text':
            '<!DOCTYPE html>\n<html lang="de">\n  <head>\n    <meta charset="UTF-8">\n    <title>Seite</title>\n  </head>\n  <body>\n    Inhalt\n  </body>\n</html>\n\nSemanische Tags: header, nav, main, section, article, footer',
      },
      {
        'heading': 'CSS-Grundlagen',
        'text':
            'Selektor { Eigenschaft: Wert; }\n\nSelektoren:\n#id — ID-Selektor\n.klasse — Klassen-Selektor\ntag — Element-Selektor\na:hover — Pseudo-Klasse\n\nBox-Modell: Content → Padding → Border → Margin\nFlex/Grid: Moderne Layout-Systeme',
      },
      {
        'heading': 'HTTP-Grundlagen',
        'text':
            'HTTP-Methoden:\nGET — Daten abrufen (kein Body)\nPOST — Daten senden\nPUT — Ressource ersetzen\nPATCH — Teilweise aktualisieren\nDELETE — Ressource löschen\n\nStatusCodes: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error',
      },
      {
        'heading': 'HTTP-Header & Cookies',
        'text':
            'Request-Header: Accept, Authorization, Content-Type\nResponse-Header: Content-Type, Set-Cookie, Cache-Control, CORS\n\nCookies: Kleine Datenstücke im Browser\nSession-Cookie: Gelöscht wenn Browser geschlossen\nPersistent Cookie: Bis Ablaufdatum\n\nHTTPS = HTTP + TLS-Verschlüsselung',
      },
    ],
  },

  9902: {
    'title': 'JavaScript & DOM',
    'emoji': '⚡',
    'sections': [
      {
        'heading': 'JS-Grundlagen',
        'text':
            'let/const/var — Variablen\nArrow Functions: const fn = (x) => x * 2\nTemplate Literals: `Hallo \${name}`\nDestructuring: const {a, b} = obj\nSpread: [...arr1, ...arr2]\nOptional Chaining: obj?.property?.value',
      },
      {
        'heading': 'DOM-Manipulation',
        'text':
            'document.getElementById("id")\ndocument.querySelector(".klasse")\ndocument.querySelectorAll("p")\n\nelement.innerHTML = "<b>Text</b>"\nelement.textContent = "Text"\nelement.classList.add("aktiv")\nelement.setAttribute("href", "/link")\ndocument.createElement("div")\nparent.appendChild(kind)',
      },
      {
        'heading': 'Events',
        'text':
            'element.addEventListener("click", function(e) {\n  console.log(e.target);\n});\n\nWichtige Events: click, submit, keydown, change, load, DOMContentLoaded\n\ne.preventDefault() — Standardverhalten verhindern\ne.stopPropagation() — Event-Bubbling stoppen',
      },
      {
        'heading': 'Async JavaScript',
        'text':
            'Callback: Funktion die nach Abschluss aufgerufen wird\nPromise: .then().catch().finally()\nasync/await: Sauberere Syntax für Promises\n\nfetch("https://api.example.com/data")\n  .then(res => res.json())\n  .then(data => console.log(data))\n  .catch(err => console.error(err))',
      },
    ],
  },

  9903: {
    'title': 'Backend & REST',
    'emoji': '⚙️',
    'sections': [
      {
        'heading': 'REST-Prinzipien',
        'text':
            'REST (Representational State Transfer):\n1. Stateless: Jede Anfrage enthält alle Infos\n2. Client-Server-Trennung\n3. Cacheable: Antworten können gecacht werden\n4. Uniform Interface: Einheitliche URLs\n\nRESTful URL-Beispiele:\nGET /users — Alle Nutzer\nGET /users/42 — Nutzer #42\nPOST /users — Neuen Nutzer erstellen\nPUT /users/42 — Nutzer #42 aktualisieren',
      },
      {
        'heading': 'JSON',
        'text':
            'JavaScript Object Notation — Standard für API-Daten:\n{\n  "name": "Max",\n  "alter": 25,\n  "aktiv": true,\n  "tags": ["it", "azubi"],\n  "adresse": {\n    "stadt": "Berlin"\n  }\n}\n\nJSON.parse() — String → Objekt\nJSON.stringify() — Objekt → String',
      },
      {
        'heading': 'Authentifizierung in APIs',
        'text':
            'API Key: Einfacher Schlüssel im Header\nBasic Auth: Base64(user:passwort) — nur mit HTTPS!\nJWT (JSON Web Token): Signiertes Token mit Claims\n→ Header.Payload.Signatur\nOAuth 2.0: Delegierte Autorisierung (Login mit Google)\nBearer Token: Authorization: Bearer <token>',
      },
      {
        'heading': 'Datenbanken im Backend',
        'text':
            'ORM (Object-Relational Mapper): SQL-Datenbank als Objekte nutzen\nSQL: PostgreSQL, MySQL, SQLite\nNoSQL: MongoDB (Dokumente), Redis (Key-Value)\n\nN+1 Problem: Für jedes Objekt eine DB-Anfrage → JOIN nutzen!\nConnection Pooling: Verbindungen wiederverwenden',
      },
    ],
  },

  9904: {
    'title': 'Deployment & CI/CD',
    'emoji': '🚀',
    'sections': [
      {
        'heading': 'Deployment-Strategien',
        'text':
            'Blue/Green: Zwei identische Umgebungen, Traffic umschalten\nCanary: Neue Version nur für kleinen % der Nutzer\nRolling Update: Server nacheinander aktualisieren\nRecreate: Alles stoppen, dann neu starten (Downtime!)\n\nZero Downtime Deployment: Kein Ausfall beim Update',
      },
      {
        'heading': 'CI/CD Pipeline',
        'text':
            'CI (Continuous Integration):\n→ Code committen → automatisch bauen + testen\n\nCD (Continuous Delivery/Deployment):\n→ Automatisch in Staging/Production deployen\n\nPipeline-Schritte: Checkout → Build → Test → Lint → Security Scan → Deploy\n\nTools: GitHub Actions, GitLab CI, Jenkins, CircleCI',
      },
      {
        'heading': 'Docker Grundlagen',
        'text':
            'Image: Vorlage (unveränderlich)\nContainer: Laufende Instanz eines Images\n\ndocker build -t app . — Image bauen\ndocker run -p 3000:3000 app — Container starten\ndocker ps — Laufende Container\ndocker logs container — Logs anzeigen\n\nDockerfile: Anleitung zum Image-Bauen',
      },
      {
        'heading': 'Umgebungen',
        'text':
            'Development: Lokale Entwicklung\nStaging/Testing: Testumgebung wie Production\nProduction: Live-System für Endnutzer\n\nUmgebungsvariablen: .env Dateien, nie in Git!\nSecrets Management: Vault, AWS Secrets Manager\n\nInfrastructure as Code: Terraform, Ansible',
      },
    ],
  },

  9905: {
    'title': 'Security & Performance (Web)',
    'emoji': '🛡️',
    'sections': [
      {
        'heading': 'OWASP Top 10 (Web)',
        'text':
            '1. Broken Access Control\n2. Cryptographic Failures\n3. Injection (SQL, NoSQL, OS)\n4. Insecure Design\n5. Security Misconfiguration\n6. Vulnerable Components\n7. Auth Failures\n8. Data Integrity Failures\n9. Logging Failures\n10. SSRF (Server-Side Request Forgery)',
      },
      {
        'heading': 'CORS & CSP',
        'text':
            'CORS (Cross-Origin Resource Sharing): Browser-Policy die verhindert dass Websites fremde APIs aufrufen.\nAccess-Control-Allow-Origin: * — Alle erlauben (unsicher!)\n\nCSP (Content Security Policy): Verhindert XSS durch Whitelist erlaubter Quellen.\nContent-Security-Policy: default-src \'self\'',
      },
      {
        'heading': 'Web Performance',
        'text':
            'Core Web Vitals:\nLCP (Largest Contentful Paint): < 2.5s\nFID/INP (Interactivity): < 100ms\nCLS (Cumulative Layout Shift): < 0.1\n\nOptimierungen: Bilder komprimieren, CSS/JS minifizieren, Caching, CDN, Lazy Loading, Code Splitting',
      },
      {
        'heading': 'Caching',
        'text':
            'Browser Cache: Cache-Control Header\nCDN Cache: Statische Dateien weltweit verteilen\nApplication Cache: Redis/Memcached für DB-Abfragen\n\nCache-Control: max-age=3600, public\nETag: Eindeutiger Hash für Ressource\nLast-Modified: Wann zuletzt geändert\n\nCache Invalidation: Schwierigste Problem in der Informatik!',
      },
    ],
  },

  // ── CLOUD & DEVOPS (9010) ────────────────────────────────────────────────

  10001: {
    'title': 'Cloud-Grundlagen',
    'emoji': '☁️',
    'sections': [
      {
        'heading': 'Cloud-Servicemodelle',
        'text':
            'IaaS: VM, Storage, Netzwerk — du verwaltest OS + Apps (AWS EC2, Azure VM)\nPaaS: Laufzeitumgebung — du verwaltest nur Apps (Heroku, App Engine)\nSaaS: Fertige Software — du nutzt nur (Gmail, Salesforce)\n\nFaaS/Serverless: Funktionen ausführen ohne Server (AWS Lambda)',
      },
      {
        'heading': 'Regionen & Availability Zones',
        'text':
            'Region: Geografischer Bereich (z.B. eu-west-1 = Irland)\nAvailability Zone (AZ): Rechenzentrum innerhalb einer Region\nEdge Location: CDN-Knoten für geringe Latenz\n\nBest Practice: Über mehrere AZs verteilen → Hochverfügbarkeit\nReplicate across regions → Disaster Recovery',
      },
      {
        'heading': 'Shared Responsibility Model',
        'text':
            'Cloud-Anbieter verantwortet:\n→ Physische Infrastruktur, Netzwerk, Hypervisor\n\nKunde verantwortet:\n→ Betriebssystem, Anwendungen, Daten, IAM\n→ Netzwerkkonfiguration, Verschlüsselung\n\nBei SaaS: Anbieter = fast alles, Kunde = nur Daten',
      },
      {
        'heading': 'Abrechnung & Kostenoptimierung',
        'text':
            'Pay-as-you-go: Nur für tatsächliche Nutzung bezahlen\nReserved Instances: 1-3 Jahre im Voraus → bis 72% günstiger\nSpot Instances: Überschusskapazität günstig nutzen (kann unterbrochen werden)\n\nKostenoptimierung: Richtige Instanzgröße, Auto-Scaling, Unused Resources löschen',
      },
    ],
  },

  10002: {
    'title': 'CI/CD & GitOps',
    'emoji': '🔄',
    'sections': [
      {
        'heading': 'CI/CD Grundlagen',
        'text':
            'Continuous Integration: Automatisch bauen und testen bei jedem Commit\nContinuous Delivery: Jederzeit deploybar — manueller Trigger\nContinuous Deployment: Vollautomatisch deployen\n\nZiel: Schnelle, zuverlässige Releases ohne manuelle Fehler',
      },
      {
        'heading': 'GitOps',
        'text':
            'Git als einzige Quelle der Wahrheit für Infrastruktur.\n\nPrinzipien:\n1. Gesamte Infrastruktur als Code in Git\n2. Automatische Synchronisation zum Cluster\n3. Abweichungen werden automatisch korrigiert\n\nTools: ArgoCD, Flux CD',
      },
      {
        'heading': 'Pipeline-Aufbau',
        'text':
            'Typische Pipeline:\n1. Trigger (Push/PR)\n2. Checkout Code\n3. Dependencies installieren\n4. Tests ausführen\n5. Build erstellen\n6. Security Scan (SAST)\n7. Container-Image bauen & pushen\n8. Deploy to Staging\n9. Integration Tests\n10. Deploy to Production',
      },
      {
        'heading': 'Branching-Strategien',
        'text':
            'GitFlow: main, develop, feature/*, release/*, hotfix/*\nGitHub Flow: main + feature branches, PR → merge\nTrunk-Based Development: Alle auf main, Feature Flags\n\nConventional Commits:\nfeat: neues Feature\nfix: Bugfix\ndocs: Dokumentation\nchore: Wartung',
      },
    ],
  },

  10003: {
    'title': 'Container & Kubernetes',
    'emoji': '🐳',
    'sections': [
      {
        'heading': 'Docker',
        'text':
            'Image: Unveränderliche Vorlage (Layer-basiert)\nContainer: Laufende Instanz\nRegistry: Docker Hub, ECR, GCR\n\nWichtige Befehle:\ndocker build -t name:tag .\ndocker run -d -p 8080:80 name\ndocker-compose up -d\ndocker exec -it container bash',
      },
      {
        'heading': 'Kubernetes Objekte',
        'text':
            'Pod: Kleinste deploybare Einheit (1+ Container)\nDeployment: Verwaltet Pod-Replikas\nService: Stabiler Endpunkt für Pods\nIngress: HTTP-Routing von außen\nConfigMap: Konfiguration\nSecret: Sensible Daten\nNamespace: Logische Trennung',
      },
      {
        'heading': 'kubectl Befehle',
        'text':
            'kubectl get pods — Pods anzeigen\nkubectl describe pod name — Details\nkubectl logs pod name — Logs\nkubectl apply -f datei.yaml — Ressource erstellen\nkubectl delete pod name — Pod löschen\nkubectl exec -it pod -- bash — Shell öffnen\nkubectl scale deployment app --replicas=3',
      },
      {
        'heading': 'Kubernetes-Konzepte',
        'text':
            'Declarative Configuration: YAML beschreibt Zielzustand\nSelf-Healing: Ausgefallene Pods werden neu gestartet\nRolling Updates: Pods nacheinander aktualisieren\nHPA (Horizontal Pod Autoscaler): Automatisch skalieren\nLiveness/Readiness Probes: Health Checks\nResource Requests/Limits: CPU/RAM begrenzen',
      },
    ],
  },

  10004: {
    'title': 'IaC & Observability',
    'emoji': '📊',
    'sections': [
      {
        'heading': 'Infrastructure as Code',
        'text':
            'Infrastruktur durch Code definieren statt manuell.\n\nTerraform: Cloud-agnostisch, deklarativ\nAnsible: Konfigurationsmanagement, agentlos\nPulumi: IaC mit echten Programmiersprachen\n\nVorteile: Reproduzierbar, versionierbar, automatisierbar\nterraform init → plan → apply → destroy',
      },
      {
        'heading': 'Monitoring & Metriken',
        'text':
            'Die 4 goldenen Signale:\n1. Latency: Wie lange dauern Anfragen?\n2. Traffic: Wie viele Anfragen?\n3. Errors: Fehlerrate\n4. Saturation: Wie ausgelastet ist das System?\n\nTools: Prometheus (Metriken sammeln), Grafana (Visualisieren)',
      },
      {
        'heading': 'Logging & Tracing',
        'text':
            'Logging: Strukturierte Logs (JSON), zentral sammeln\nELK Stack: Elasticsearch, Logstash, Kibana\nLoki + Grafana: Leichtgewichtiger\n\nDistributed Tracing: Anfragen durch Microservices verfolgen\nJaeger, Zipkin, OpenTelemetry\n\nCorrelation ID: Anfrage durch alle Services verfolgen',
      },
      {
        'heading': 'Alerting',
        'text':
            'Alertmanager: Prometheus-Komponente für Benachrichtigungen\nPagerDuty/OpsGenie: On-Call Management\n\nGute Alerts:\n→ Actionable (klare Handlungsanweisung)\n→ Nicht zu viele (Alert Fatigue vermeiden)\n→ Severity-Level: critical, warning, info\n\nRunbooks: Schritt-für-Schritt Anleitungen bei Vorfällen',
      },
    ],
  },

  10005: {
    'title': 'Reliability & Kosten',
    'emoji': '💰',
    'sections': [
      {
        'heading': 'SRE & SLAs',
        'text':
            'SLI (Service Level Indicator): Messbare Metrik (z.B. 99% der Anfragen < 200ms)\nSLO (Service Level Objective): Internes Ziel (z.B. 99.9% Verfügbarkeit)\nSLA (Service Level Agreement): Vertragliche Vereinbarung mit Kunden\n\nError Budget: 100% - SLO = erlaubte Ausfallzeit\n99.9% = 8.7 Stunden/Jahr Downtime erlaubt',
      },
      {
        'heading': 'Hochverfügbarkeit',
        'text':
            'Single Point of Failure (SPOF) vermeiden\nRedundanz: Mehrere Instanzen, mehrere AZs\nLoad Balancer: Traffic auf mehrere Server verteilen\nHealth Checks: Kranke Server aus Rotation nehmen\nCircuit Breaker: Bei Fehlern Requests stoppen\nRetry + Timeout: Mit Backoff',
      },
      {
        'heading': 'Chaos Engineering',
        'text':
            'Absichtlich Fehler einführen um Schwachstellen zu finden.\n\nPrinzipien:\n1. Steady State definieren\n2. Hypothese aufstellen\n3. Experimente im Production (mit Vorsicht!)\n4. Ergebnisse analysieren\n\nTools: Chaos Monkey (Netflix), Gremlin, LitmusChaos',
      },
      {
        'heading': 'FinOps & Kostenoptimierung',
        'text':
            'FinOps: Cloud-Kosten transparent und optimiert verwalten\n\nStrategien:\nRight Sizing: Richtige Instanzgröße wählen\nReserved/Spot Instances nutzen\nUngenutzte Ressourcen löschen\nAuto-Scaling: Nur zahlen was gebraucht wird\nCost Allocation Tags: Kosten Projekten zuordnen\n\nTools: AWS Cost Explorer, Azure Cost Management',
      },
    ],
  },

  // ── DATENSTRUKTUREN & ALGORITHMEN (9011) ─────────────────────────────────

  10101: {
    'title': 'Grundlagen & Notation',
    'emoji': '🧮',
    'sections': [
      {
        'heading': 'Was ist eine Datenstruktur?',
        'text':
            'Eine Datenstruktur organisiert Daten so, dass bestimmte Operationen effizient durchgeführt werden können.\n\nAbstrakter Datentyp (ADT): Definiert Operationen ohne Implementierung\nKonkrete Implementierung: Array, LinkedList, Tree...\n\nWahl der richtigen Datenstruktur = größter Performance-Hebel',
      },
      {
        'heading': 'Big-O Notation',
        'text':
            'Beschreibt Zeitkomplexität im Worst-Case:\nO(1) — Konstant: Array-Zugriff per Index\nO(log n) — Logarithmisch: Binäre Suche\nO(n) — Linear: Alle Elemente durchgehen\nO(n log n) — Merge Sort, Heap Sort\nO(n²) — Quadratisch: Bubble Sort\nO(2^n) — Exponentiell: Brute Force\n\nZiel: Möglichst kleine Komplexität!',
      },
      {
        'heading': 'Rekursion',
        'text':
            'Eine Funktion die sich selbst aufruft.\n\nZwei Teile:\n1. Basisfall: Abbruchbedingung\n2. Rekursiver Fall: Selbstaufruf\n\nBeispiel Fakultät:\nfak(n) = if n==0: return 1\n         else: return n * fak(n-1)\n\nCall Stack wächst mit jedem Aufruf → Stack Overflow bei zu tiefer Rekursion',
      },
      {
        'heading': 'Arrays',
        'text':
            'Feste Größe, gleicher Datentyp, Index ab 0.\n\nOperationen:\nZugriff: O(1) — Direktzugriff per Index\nSuche: O(n) — Durchsuchen\nEinfügen am Ende: O(1) amortisiert\nEinfügen in Mitte: O(n) — alle verschieben\nLöschen in Mitte: O(n)\n\nZwei-dimensionales Array: int[3][4] = 3 Zeilen, 4 Spalten',
      },
    ],
  },

  10102: {
    'title': 'Lineare & verkettete Strukturen',
    'emoji': '🔗',
    'sections': [
      {
        'heading': 'Linked List',
        'text':
            'Knoten mit Wert + Zeiger auf nächsten Knoten.\n\nEinfach verkettet: node → node → node → null\nDoppelt verkettet: ← node ↔ node ↔ node →\nKreisliste: Letzter zeigt auf ersten\n\nEinfügen/Löschen: O(1) wenn Position bekannt\nSuche: O(n)\nKein Direktzugriff per Index',
      },
      {
        'heading': 'Stack (LIFO)',
        'text':
            'Last In — First Out\n\nOperationen:\npush(x): Element oben drauflegen — O(1)\npop(): Oberstes Element entfernen — O(1)\npeek(): Oberstes Element ansehen — O(1)\nisEmpty(): Leer? — O(1)\n\nAnwendungen: Undo-Funktion, Klammerüberprüfung, Methodenaufrufe (Call Stack)',
      },
      {
        'heading': 'Queue (FIFO)',
        'text':
            'First In — First Out\n\nOperationen:\nenqueue(x): Hinten einfügen — O(1)\ndequeue(): Vorne entfernen — O(1)\nfront(): Vorderstes ansehen — O(1)\n\nVarianten:\nDeque: Beidseitig\nPriority Queue: Höchste Priorität zuerst\n\nAnwendungen: Druckerwarteschlange, BFS, Aufgabenplanung',
      },
      {
        'heading': 'ArrayList vs. LinkedList',
        'text':
            'ArrayList:\n+ Direktzugriff O(1)\n+ Cache-freundlich\n- Einfügen/Löschen O(n)\n\nLinkedList:\n+ Einfügen/Löschen O(1)\n+ Kein Resize nötig\n- Kein Direktzugriff O(n)\n- Mehr Speicher (Zeiger)\n\nFaustregel: ArrayList wenn viel gelesen wird, LinkedList wenn viel eingefügt/gelöscht wird',
      },
    ],
  },

  10103: {
    'title': 'Bäume & Heaps',
    'emoji': '🌳',
    'sections': [
      {
        'heading': 'Binärbaum',
        'text':
            'Jeder Knoten hat max. 2 Kinder (links, rechts).\n\nBegriffe:\nWurzel: Oberster Knoten\nBlatt: Knoten ohne Kinder\nHöhe: Längster Pfad von Wurzel zu Blatt\nTiefe: Abstand von Wurzel\n\nVollständiger Binärbaum: Alle Ebenen voll\nBalancierter Baum: Höhe ≈ log(n)',
      },
      {
        'heading': 'Binary Search Tree (BST)',
        'text':
            'Links < Eltern < Rechts\n\nOperationen:\nSuche: O(log n) im Durchschnitt\nEinfügen: O(log n)\nLöschen: O(log n)\n\nProblem: Kann entarten → O(n) wenn unsortiert eingefügt\n\nSelbstbalancierende Bäume: AVL-Tree, Red-Black-Tree → immer O(log n)',
      },
      {
        'heading': 'Traversierung',
        'text':
            'Inorder (Links-Wurzel-Rechts): Sortierte Reihenfolge beim BST\nPreorder (Wurzel-Links-Rechts): Baum kopieren\nPostorder (Links-Rechts-Wurzel): Baum löschen\n\nBFS (Breadth-First): Ebene für Ebene (Queue)\nDFS (Depth-First): Tief in einen Zweig (Stack/Rekursion)',
      },
      {
        'heading': 'Heap',
        'text':
            'Max-Heap: Eltern ≥ Kinder → Wurzel = Maximum\nMin-Heap: Eltern ≤ Kinder → Wurzel = Minimum\n\nOperationen:\ninsert: O(log n)\nextractMax/Min: O(log n)\npeek: O(1)\n\nAnwendungen: Priority Queue, Heap Sort\n\nAls Array gespeichert:\nLinkes Kind: 2i+1\nRechtes Kind: 2i+2\nElternteil: (i-1)/2',
      },
    ],
  },

  10104: {
    'title': 'Graphen & Sortieren',
    'emoji': '🗺️',
    'sections': [
      {
        'heading': 'Graph-Grundlagen',
        'text':
            'Knoten (Vertices) + Kanten (Edges)\n\nGerichtet: Kanten haben Richtung (A→B)\nUngerichtet: Kanten ohne Richtung (A—B)\nGewichtet: Kanten haben Kosten/Gewicht\n\nDarstellung:\nAdjazenzmatrix: 2D-Array, O(V²) Speicher\nAdjazenzliste: Liste pro Knoten, O(V+E) Speicher',
      },
      {
        'heading': 'Graphensuche',
        'text':
            'BFS (Breadth-First Search):\n→ Level für Level, Queue\n→ Kürzester Pfad (ungewichtet)\n→ O(V+E)\n\nDFS (Depth-First Search):\n→ So tief wie möglich, Stack\n→ Zyklen erkennen, Topologische Sortierung\n→ O(V+E)\n\nDijkstra: Kürzester Pfad mit Gewichten, O((V+E) log V)',
      },
      {
        'heading': 'Sortieralgorithmen',
        'text':
            'Bubble Sort: O(n²) — vergleicht benachbarte Elemente\nSelection Sort: O(n²) — findet immer kleinste Element\nInsertion Sort: O(n²) — fügt in sortierte Liste ein, gut bei fast-sortierten Daten\nMerge Sort: O(n log n) — Divide & Conquer, stabil\nQuick Sort: O(n log n) durchschnittlich — Pivot wählen\nHeap Sort: O(n log n) — Heap nutzen',
      },
      {
        'heading': 'Wichtige Algorithmen',
        'text':
            'Lineare Suche: O(n)\nBinäre Suche: O(log n) — nur sortiertes Array\n\nDynamic Programming: Teilprobleme lösen und merken (Memoization)\nGreedy: Immer lokal bestes wählen\nDivide & Conquer: Problem aufteilen, lösen, zusammenführen\n\nFür IHK: Bubble Sort Trace + Binäre Suche können!',
      },
    ],
  },

  10105: {
    'title': 'Komplexität & Optimierung',
    'emoji': '⚡',
    'sections': [
      {
        'heading': 'Zeitkomplexität',
        'text':
            'Best Case: Optimal (Ω-Notation)\nAverage Case: Durchschnitt (Θ-Notation)\nWorst Case: Schlechtester Fall (O-Notation)\n\nPraxisrelevant: Meist Worst Case\n\nO(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2^n) < O(n!)',
      },
      {
        'heading': 'Raumkomplexität',
        'text':
            'Wie viel Speicher braucht ein Algorithmus?\n\nIn-place: O(1) Zusatzspeicher (Insertion Sort, Quick Sort)\nAuxiliary Space: O(n) (Merge Sort braucht Extra-Array)\n\nTime-Space-Tradeoff:\nMehr Speicher → schneller (Caching, DP)\nWeniger Speicher → langsamer',
      },
      {
        'heading': 'Optimierungstechniken',
        'text':
            'Memoization (Top-Down DP): Ergebnisse cachen\nTabulation (Bottom-Up DP): Tabelle aufbauen\nTwo Pointers: Zwei Zeiger im Array\nSliding Window: Fenstergröße verschieben\nBinary Search on Answer: Nicht im Array, sondern im Lösungsraum suchen',
      },
      {
        'heading': 'P vs NP (Grundverständnis)',
        'text':
            'P: Probleme die in polynomieller Zeit lösbar sind (O(n^k))\nNP: Probleme deren Lösung schnell verifiziert werden kann\nNP-hard: Mindestens so schwer wie alle NP-Probleme\nNP-vollständig: In NP + NP-hard\n\nBeispiele NP-vollständig: Travelling Salesman, Rucksackproblem\n\nFür Praxis: Approximations-Algorithmen oder Heuristiken',
      },
    ],
  },

  // ── WISO (9002) ──────────────────────────────────────────────────────────

  9201: {
    'title': 'Wirtschafts- & Rechtsgrundlagen',
    'emoji': '⚖️',
    'sections': [
      {
        'heading': 'Wirtschaftskreislauf',
        'text':
            'Haushalte verkaufen Arbeitskraft → Unternehmen\nUnternehmen zahlen Lohn → Haushalte kaufen Waren\nStaat: Nimmt Steuern, gibt Subventionen, reguliert\nAusland: Import/Export\n\nBIP (Bruttoinlandsprodukt): Gesamtwert aller produzierten Waren & Dienste',
      },
      {
        'heading': 'Wirtschaftssysteme',
        'text':
            'Marktwirtschaft: Angebot & Nachfrage bestimmen Preise\nPlanwirtschaft: Staat bestimmt Produktion und Preise\nSoziale Marktwirtschaft (Deutschland): Freier Markt + sozialer Ausgleich\n\nKonjunkturzyklus: Aufschwung → Hochkonjunktur → Abschwung → Rezession',
      },
      {
        'heading': 'Rechtliche Grundlagen',
        'text':
            'BGB: Zivilrecht, Vertragsrecht, Schuldrecht\nHGB: Handelsrecht für Kaufleute\nGmbHG/AktG: Gesellschaftsrecht\nStGB: Strafrecht\n\nGerichtszüge: Amtsgericht → Landgericht → Oberlandesgericht → BGH\n\nVerjährung: Regelverjährung 3 Jahre',
      },
      {
        'heading': 'Wettbewerbsrecht',
        'text':
            'UWG: Gesetz gegen unlauteren Wettbewerb\nGWB: Kartellgesetz\nMarkenrecht: Schutz von Marken\nUrheberrecht: Schutz geistigen Eigentums\n\nKartell: Illegale Absprachen zwischen Wettbewerbern\nMonopol: Ein Anbieter bestimmt Markt',
      },
    ],
  },

  9202: {
    'title': 'Arbeits- & Tarifrecht',
    'emoji': '👔',
    'sections': [
      {
        'heading': 'Arbeitsvertrag',
        'text':
            'Bestandteile: Tätigkeit, Arbeitszeit, Vergütung, Urlaub, Kündigungsfristen\n\nProbezeit: Max. 6 Monate\nKündigung: Ordentlich (mit Frist) oder außerordentlich (fristlos, wichtiger Grund)\nKündigungsschutzgesetz: Ab 10 Mitarbeitern, nach 6 Monaten\n\nAllgemeines Gleichbehandlungsgesetz (AGG): Diskriminierungsschutz',
      },
      {
        'heading': 'Ausbildungsrecht',
        'text':
            'BBiG (Berufsbildungsgesetz): Regelt Ausbildungsverhältnisse\n\nPflichten Ausbildender: Ausbilden, zahlen, freistelln für Schule\nPflichten Auszubildender: Lernbemühung, Weisungen befolgen, Schweigepflicht\n\nUrlaub: Mindest-21 Werktage, unter 18 Jahren mehr\nBerichtshefte: Pflicht!',
      },
      {
        'heading': 'Tarifrecht',
        'text':
            'Tarifvertrag: Zwischen Gewerkschaft und Arbeitgeberverband\nGehalt, Arbeitszeit, Urlaub kollektiv geregelt\n\nGewerkschaft: Ver.di, IG Metall, Verdi\nKampfmittel: Streik (Arbeitnehmer) vs. Aussperrung (Arbeitgeber)\nSchlichtung: Vermittlung bei Konflikten\n\nMindestlohn: Gesetzlicher Mindestlohn (aktuell prüfen!)',
      },
      {
        'heading': 'Betriebsrat',
        'text':
            'Interessenvertretung der Arbeitnehmer im Betrieb\nAb 5 Mitarbeitern wählbar\n\nMitbestimmungsrechte:\nInformationsrecht: Muss informiert werden\nAnhörungsrecht: Muss gehört werden\nMitbestimmungsrecht: Muss zustimmen (z.B. Überstunden)\n\nBetrVG: Betriebsverfassungsgesetz',
      },
    ],
  },

  9203: {
    'title': 'Sozialversicherung & Entgelt',
    'emoji': '💰',
    'sections': [
      {
        'heading': 'Sozialversicherungszweige',
        'text':
            '5 Zweige (Merkwort: KRUPPU):\nKrankenversicherung: Gesundheitskosten (~14,6% + Zusatz)\nRentenversicherung: Altersvorsorge (~18,6%)\nUnfallversicherung: Berufsunfälle (nur AG zahlt)\nPflegeversicherung: Pflegekosten (~3,4%)\nArbeitslosenversicherung: ALG I (~2,6%)\n\nBeitrag je ~50% AG + AN',
      },
      {
        'heading': 'Gehaltsberechnung',
        'text':
            'Brutto: Vereinbartes Gehalt\n- Lohnsteuer (nach Steuerklasse)\n- Solidaritätszuschlag\n- Kirchensteuer (optional)\n- AN-Anteil Sozialversicherung\n= Netto: Ausgezahlter Betrag\n\nSteuerklassen: I (Ledig), II (Alleinerziehend), III/V (Ehepaar), IV (Ehepaar gleich), VI (Zweitjob)',
      },
      {
        'heading': 'Lohnfortzahlung',
        'text':
            'Krankheit: 6 Wochen Lohnfortzahlung durch AG, dann Krankengeld (KK)\nMutterschaft: Mutterschutz 6 Wochen vor, 8 Wochen nach Geburt\nElternzeit: Bis 3 Jahre, Elterngeld vom Staat\nUrlaub: Gesetzlich 20 Tage (5-Tage-Woche), Urlaubsgeld möglich',
      },
      {
        'heading': 'Beendigung des Arbeitsverhältnisses',
        'text':
            'Ordentliche Kündigung: Mit gesetzlicher/vertraglicher Frist\nAußerordentliche Kündigung: Fristlos bei wichtigem Grund\nAufhebungsvertrag: Einvernehmlich\nBefristung: Ende automatisch, kein Kündigungsschutz\n\nAbfindung: Keine gesetzliche Pflicht, oft verhandelt\nZeugnis: Pflicht, wohlwollendes Zeugnis',
      },
    ],
  },

  9204: {
    'title': 'Unternehmensformen & Verträge',
    'emoji': '🏢',
    'sections': [
      {
        'heading': 'Rechtsformen im Überblick',
        'text':
            'Einzelunternehmen: 1 Person, volle Haftung\nGbR: ≥2 Personen, gesamtschuldnerisch\nOHG: Kaufleute, gesamtschuldnerisch\nKG: Komplementär (voll) + Kommanditist (begrenzt)\nGmbH: Min. 25.000€ Stammkapital, beschränkte Haftung\nAG: Min. 50.000€ Grundkapital, Aktien',
      },
      {
        'heading': 'GmbH vs. AG',
        'text':
            'GmbH:\n→ Gesellschafter, Geschäftsführer, ggf. Aufsichtsrat\n→ Nicht börsennotiert\n→ GmbHG\n\nAG:\n→ Aktionäre, Vorstand, Aufsichtsrat, Hauptversammlung\n→ Kann börsennotiert sein\n→ AktG\n→ Vorstand führt, Aufsichtsrat kontrolliert',
      },
      {
        'heading': 'Vertragsarten',
        'text':
            'Kaufvertrag: Ware gegen Geld (§ 433 BGB)\nWerkvertrag: Herstellung eines Werkes (§ 631)\nDienstvertrag: Tätigkeit ohne Erfolgsversprechen (§ 611)\nMietvertrag: Zeitweise Nutzung (§ 535)\nLeasingvertrag: Miete mit Option\nLizenzvertrag: Nutzungsrecht\n\nIT-Verträge: SLA, AÜV, Rahmenvertrag',
      },
      {
        'heading': 'Vertragsrecht',
        'text':
            'Angebot + Annahme = Vertrag\nFormfreiheit: Meist keine Pflichtform, aber Schriftform ratsam\n\nNichtigkeit: Von Anfang an ungültig (Geschäftsunfähige)\nAnfechtbarkeit: Kann angefochten werden (Irrtum, Täuschung)\n\nGewährleistung: 2 Jahre gesetzlich bei Kauf\nGarantie: Freiwillig vom Hersteller',
      },
    ],
  },

  9205: {
    'title': 'IT-Recht & Datenschutz',
    'emoji': '🔏',
    'sections': [
      {
        'heading': 'DSGVO Grundlagen',
        'text':
            'Datenschutz-Grundverordnung gilt in ganz EU seit Mai 2018.\n\nGrundsätze: Zweckbindung, Datensparsamkeit, Transparenz, Richtigkeit, Speicherbegrenzung\n\nRechtsgrundlagen für Verarbeitung:\n→ Einwilligung, Vertrag, gesetzliche Pflicht, berechtigtes Interesse\n\nBußgelder: Bis 4% des weltweiten Jahresumsatzes',
      },
      {
        'heading': 'Betroffenenrechte',
        'text':
            'Recht auf Auskunft (Art. 15)\nRecht auf Berichtigung (Art. 16)\nRecht auf Löschung ("Recht auf Vergessenwerden", Art. 17)\nRecht auf Einschränkung (Art. 18)\nRecht auf Datenübertragbarkeit (Art. 20)\nWiderspruchsrecht (Art. 21)\n\nDSB (Datenschutzbeauftragter): Ab 20 Personen mit Datenverarbeitung',
      },
      {
        'heading': 'IT-spezifisches Recht',
        'text':
            'Urheberrecht: Software automatisch geschützt\nLizenzarten: Proprietär, Open Source (GPL, MIT, Apache)\nSoftwarevertrag: Kauf, Miete (SaaS), Lizenz\n\nTKG: Telekommunikationsgesetz\nITSiG: IT-Sicherheitsgesetz\nKritische Infrastruktur (KRITIS): Besondere Schutzpflichten',
      },
      {
        'heading': 'Impressum & Compliance',
        'text':
            'Impressumspflicht: Gewerbliche Webseiten (TMG)\nCookies: Einwilligung erforderlich (außer technisch notwendig)\nNewsletter: Double-Opt-In\n\nCompliance: Einhaltung gesetzlicher Vorschriften\nISO 27001: IT-Sicherheitsmanagement\nSOC 2: Cloud-Dienstleister\n\nDatenpanne: Innerhalb 72h melden!',
      },
    ],
  },

  // ── RECHNUNGSWESEN (9001) ────────────────────────────────────────────────

  9101: {
    'title': 'Buchführung Grundlagen',
    'emoji': '📒',
    'sections': [
      {
        'heading': 'Buchführungspflicht',
        'text':
            'Kaufleute nach HGB: Doppelte Buchführung Pflicht\nFreiberufler/Kleinunternehmer: Einnahmen-Überschuss-Rechnung (EÜR)\n\nGrundsätze ordnungsmäßiger Buchführung (GoB):\n→ Vollständigkeit, Richtigkeit, Zeitgerechtheit, Klarheit\n→ Keine Buchung ohne Beleg!',
      },
      {
        'heading': 'Doppelte Buchführung',
        'text':
            'Jeder Geschäftsvorfall wird auf zwei Konten gebucht.\nSoll (links) = Haben (rechts)\n\nAktivkonto: Vermögen (Soll = Zugang)\nPassivkonto: Schulden/EK (Haben = Zugang)\nAufwandskonto: Kosten (Soll = Zugang)\nErtragskonto: Einnahmen (Haben = Zugang)',
      },
      {
        'heading': 'Kontenrahmen',
        'text':
            'SKR 03 / SKR 04: Standard-Kontenrahmen\n\nKlasse 0: Anlage- und Kapitalkonten\nKlasse 1: Finanz- und Privatkonten\nKlasse 2: Abgrenzungskonten\nKlasse 3: Waren- und Leistungsverkehr\nKlasse 4: Betriebliche Aufwendungen\nKlasse 6/7: Kostenarten',
      },
      {
        'heading': 'Buchungssätze',
        'text':
            'Format: Sollkonto an Habenkonto\n\nBeispiele:\nWareneinkauf auf Ziel:\nWaren 1.000 an Verbindlichkeiten 1.000\n\nZahlung der Verbindlichkeit:\nVerbindlichkeiten 1.000 an Bank 1.000\n\nGehaltszahlung:\nLöhne 3.000 an Bank 3.000',
      },
    ],
  },

  9102: {
    'title': 'Bilanz & GuV',
    'emoji': '📊',
    'sections': [
      {
        'heading': 'Bilanz',
        'text':
            'Momentaufnahme des Vermögens zu einem Stichtag.\n\nAktiva (Mittelverwendung) = Passiva (Mittelherkunft)\n\nAktiva:\nAnlagevermögen (langfristig): Maschinen, Gebäude\nUmlaufvermögen (kurzfristig): Waren, Forderungen, Kasse\n\nPassiva:\nEigenkapital: Eigentümerbeiträge + Gewinn\nFremdkapital: Verbindlichkeiten, Rückstellungen',
      },
      {
        'heading': 'GuV (Gewinn- und Verlustrechnung)',
        'text':
            'Zeigt Erträge und Aufwendungen einer Periode.\n\nErträge - Aufwendungen = Gewinn/Verlust\n\nErträge: Umsatzerlöse, sonstige Erträge\nAufwendungen: Material, Personal, Abschreibungen, Zinsen\n\nEBIT: Gewinn vor Zinsen und Steuern\nEBITDA: + Abschreibungen',
      },
      {
        'heading': 'Bilanzkennzahlen',
        'text':
            'Eigenkapitalquote = EK / Gesamtkapital × 100\n(>30% gilt als gut)\n\nLiquidität 1. Grades = Zahlungsmittel / kurzfristige Verbindlichkeiten\n(>20%)\n\nLiquidität 2. Grades = (ZM + Forderungen) / kfr. Verbindlichkeiten\n(>100%)\n\nAnlagendeckung = EK / Anlagevermögen × 100',
      },
      {
        'heading': 'Abschreibungen',
        'text':
            'Wertverlust von Anlagegütern über die Nutzungsdauer.\n\nLinear: Gleiche Abschreibung jedes Jahr\nJährliche AfA = Anschaffungskosten / Nutzungsdauer\n\nDegressiv: Fallende Abschreibung\nSofortabschreibung: GWG bis 800€ netto\n\nAfA-Tabellen: Steuerliche Nutzungsdauern vom Finanzamt',
      },
    ],
  },

  9103: {
    'title': 'Kostenrechnung',
    'emoji': '🧮',
    'sections': [
      {
        'heading': 'Kostenartenrechnung',
        'text':
            'Welche Kosten entstehen?\n\nEinzelkosten: Direkt dem Produkt zurechenbar (Material, Fertigungslohn)\nGemeinkosten: Nicht direkt zurechenbar (Miete, Strom, Gehalt Verwaltung)\n\nFixkosten: Unabhängig von Menge (Miete)\nVariable Kosten: Steigen mit Menge (Material)\nGesamtkosten = Fixkosten + (variable Stückkosten × Menge)',
      },
      {
        'heading': 'Kostenstellenrechnung',
        'text':
            'Wo entstehen Kosten?\n\nKostenstellen: Abteilungen (Fertigung, Verwaltung, Vertrieb)\nBetriebsabrechnungsbogen (BAB): Gemeinkosten auf Kostenstellen verteilen\n\nZuschlagssatz = Gemeinkosten / Einzelkosten × 100',
      },
      {
        'heading': 'Kalkulation',
        'text':
            'Selbstkostenpreis berechnen:\n\nMaterialeinzelkosten\n+ Materialgemeinkosten (+ Zuschlag)\n= Materialkosten\n+ Fertigungseinzelkosten\n+ Fertigungsgemeinkosten\n= Herstellkosten\n+ Verwaltungsgemeinkosten\n+ Vertriebsgemeinkosten\n= Selbstkosten\n+ Gewinnaufschlag\n= Nettoverpreis',
      },
      {
        'heading': 'Break-Even-Analyse',
        'text':
            'Ab welcher Menge wird Gewinn gemacht?\n\nBreak-Even-Menge = Fixkosten / (Preis - variable Stückkosten)\nDeckungsbeitrag (DB) = Preis - variable Stückkosten\n\nBeispiel:\nFixkosten: 10.000€\nPreis: 50€\nVariable Kosten: 30€\nDB = 20€\nBEP = 10.000 / 20 = 500 Stück',
      },
    ],
  },

  9104: {
    'title': 'Steuern',
    'emoji': '🏛️',
    'sections': [
      {
        'heading': 'Umsatzsteuer (MwSt)',
        'text':
            'Regelsteuersatz: 19%\nErmäßigt: 7% (Lebensmittel, Bücher)\nKleinunternehmerregelung: Bis 22.000€ Umsatz → keine MwSt\n\nVorsteuer: USt die du bezahlst (Eingangsrechnung)\nUmsatzsteuer: USt die du berechnest (Ausgangsrechnung)\nZahllast = Umsatzsteuer - Vorsteuer',
      },
      {
        'heading': 'Einkommensteuer',
        'text':
            'Natürliche Personen zahlen ESt\nGrundfreibetrag: ~12.000€/Jahr (aktuell prüfen)\nProgressiver Steuersatz: Mehr Einkommen → höherer Satz\nSpitzensteuersatz: 42% (ab ~62.000€)\nReichensteuersatz: 45% (ab ~277.000€)\n\nSteuerklassen beeinflussen Lohnsteuer-Abzug',
      },
      {
        'heading': 'Körperschaftsteuer & GewSt',
        'text':
            'Körperschaftsteuer: 15% auf Gewinne von GmbH/AG\nSolidaritätszuschlag: 5,5% der KSt (für Großverdiener)\n\nGewerbesteuer: Gemeinde, Hebesatz variiert (~400%)\nSteuermesszahl: 3,5%\nGewSt = Gewerbeertrag × 3,5% × Hebesatz',
      },
      {
        'heading': 'Steuerfristen',
        'text':
            'USt-Voranmeldung: Monatlich/vierteljährlich\nUSt-Jahreserklärung: 31. Juli des Folgejahres\nESt-Erklärung: 31. Juli (mit Steuerberater: 28. Feb. übernächstes Jahr)\n\nSteuerliche Aufbewahrungsfristen:\n10 Jahre: Buchungsbelege, Bilanzen\n6 Jahre: Geschäftsbriefe',
      },
    ],
  },

  9105: {
    'title': 'IT-Kalkulation & Investitionen',
    'emoji': '💻',
    'sections': [
      {
        'heading': 'IT-Projektkosten',
        'text':
            'Personalkosten: Stunden × Stundensatz\nHardwarekosten: Anschaffung + Wartung\nSoftwarekosten: Lizenzen, SaaS-Abos\nInfrastrukturkosten: Server, Netzwerk, Cloud\nIndirekte Kosten: Schulungen, Support\n\nTCO (Total Cost of Ownership): Alle Kosten über Lebenszyklus',
      },
      {
        'heading': 'Make-or-Buy-Entscheidung',
        'text':
            'Eigentwicklung (Make):\n+ Maßgeschneidert, kein Vendor Lock-in\n- Teuer, zeitaufwändig, Wartung selbst\n\nKauf/SaaS (Buy):\n+ Schnell verfügbar, Support inklusive\n- Weniger flexibel, laufende Kosten\n\nEntscheidungskriterien: Kosten, Zeit, Know-how, strategische Relevanz',
      },
      {
        'heading': 'Investitionsrechnung',
        'text':
            'Statische Methoden:\nKostenvergleich: Gesamtkosten pro Periode\nGewinnvergleich: Gewinn pro Periode\nAmortisation = Investition / jährlicher Rückfluss\n\nDynamische Methoden:\nKapitalwert (NPV): Zukunftswerte abdiskontieren\nInterner Zinsfuß (IRR): Rendite der Investition',
      },
      {
        'heading': 'Leasing vs. Kauf',
        'text':
            'Kauf:\n+ Eigentum, Abschreibung möglich\n- Hohe Anfangsinvestition\n\nLeasing:\n+ Geringere Liquiditätsbelastung\n+ Immer neue Hardware\n- Kein Eigentum, langfristige Bindung\n\nFinanzierungsleasing: Bilanzneutral\nOperating-Leasing: Wie Miete',
      },
    ],
  },

  // ── PROJEKTMANAGEMENT MODUL (15) ─────────────────────────────────────────

  101: {
    'title': 'Scrum & Agile Methoden',
    'emoji': '🔄',
    'sections': [
      {
        'heading': 'Agile Grundprinzipien',
        'text':
            'Agiles Manifest (2001) — 4 Werte:\n1. Individuen > Prozesse\n2. Software > Dokumentation\n3. Kundenzusammenarbeit > Vertragsverhandlung\n4. Reaktion auf Veränderung > Plan befolgen\n\nIterativ: Kurze Zyklen statt langer Planung',
      },
      {
        'heading': 'Scrum-Rollen',
        'text':
            'Product Owner: Priorisiert Backlog, vertritt Kunden\nScrum Master: Moderiert, beseitigt Hindernisse\nEntwicklungsteam: 3-9 Personen, selbstorganisiert\n\nKein klassischer Projektleiter! Scrum Master ≠ Chef',
      },
      {
        'heading': 'Scrum-Events',
        'text':
            'Sprint: 1-4 Wochen, feste Länge\nSprint Planning: Was wird im Sprint gemacht?\nDaily Scrum: 15 Min täglich (Was gestern, heute, Hindernisse?)\nSprint Review: Demo für Stakeholder\nSprint Retrospektive: Team reflektiert Zusammenarbeit',
      },
      {
        'heading': 'Scrum-Artefakte',
        'text':
            'Product Backlog: Priorisierte Liste aller Anforderungen\nSprint Backlog: Was im aktuellen Sprint umgesetzt wird\nIncrement: Potenziell auslieferbares Produkt nach Sprint\n\nUser Story: "Als [Nutzer] möchte ich [Funktion] um [Nutzen] zu haben"\nDefinition of Done (DoD): Kriterien für "fertig"',
      },
    ],
  },

  102: {
    'title': 'Wasserfallmodell',
    'emoji': '💧',
    'sections': [
      {
        'heading': 'Phasen des Wasserfalls',
        'text':
            '1. Anforderungsanalyse: Was soll das System können?\n2. Systemdesign: Architektur, Technologien\n3. Implementierung: Programmieren\n4. Testen: Fehler finden und beheben\n5. Deployment: Auslieferung\n6. Wartung: Betrieb und Pflege\n\nJede Phase muss abgeschlossen sein vor nächster!',
      },
      {
        'heading': 'Vor- und Nachteile',
        'text':
            'Vorteile:\n+ Klare Struktur, gute Planbarkeit\n+ Gut bei festen Anforderungen\n+ Umfangreiche Dokumentation\n\nNachteile:\n- Änderungen spät teuer\n- Kunde sieht erst am Ende etwas\n- Risiken werden spät erkannt\n- Schlecht bei unklaren Anforderungen',
      },
      {
        'heading': 'Wann Wasserfall?',
        'text':
            'Geeignet für:\n→ Behörden, Militär, Luft- und Raumfahrt\n→ Feste gesetzliche Anforderungen\n→ Große, komplexe Systeme mit stabilen Anforderungen\n→ Sicherheitskritische Software\n\nNicht geeignet für:\n→ Schnell ändernde Anforderungen\n→ Innovative Produkte\n→ Startups',
      },
      {
        'heading': 'V-Modell',
        'text':
            'Erweiterung des Wasserfalls — jede Entwicklungsphase hat entsprechende Testphase:\n\nAnforderungsanalyse ↔ Abnahmetest\nSystemdesign ↔ Systemtest\nArchitektur ↔ Integrationstest\nModuldesign ↔ Modultest\n\nV-Modell XT: Deutscher Standard für Behördenprojekte',
      },
    ],
  },

  103: {
    'title': 'Netzplantechnik & Gantt',
    'emoji': '📅',
    'sections': [
      {
        'heading': 'Netzplan',
        'text':
            'Visualisiert Abhängigkeiten zwischen Vorgängen.\n\nKnoten = Vorgänge\nPfeile = Abhängigkeiten\n\nBerechnungen:\nFrühester Anfang (FA): Wie früh kann Vorgang starten?\nFrühestes Ende (FE): FA + Dauer\nSpätestes Ende (SE): Rückwärtsrechnung\nSpätester Anfang (SA): SE - Dauer\nPuffer = SA - FA',
      },
      {
        'heading': 'Kritischer Pfad',
        'text':
            'Längster Weg durch den Netzplan = Gesamtdauer des Projekts.\n\nKritische Vorgänge: Puffer = 0\nVerspätung kritischer Vorgänge = Projektverzug!\n\nCritical Path Method (CPM): Mathematische Berechnung\nPERT: Mit Wahrscheinlichkeiten (optimistisch/pessimistisch/wahrscheinlich)',
      },
      {
        'heading': 'Gantt-Diagramm',
        'text':
            'Balkendiagramm — Zeit auf X-Achse, Vorgänge auf Y-Achse.\n\nVorteile:\n+ Einfach zu verstehen\n+ Übersichtliche Zeitplanung\n+ Zeigt Parallelen und Abhängigkeiten\n\nNachteile:\n- Zeigt keine Ressourcen\n- Bei komplexen Projekten unübersichtlich',
      },
      {
        'heading': 'Ressourcenplanung',
        'text':
            'Kapazitätsplanung: Wer kann wann wie viel?\n\nÜberlastung: Mehr Arbeit als Kapazität\nUnterlastung: Weniger Arbeit als Kapazität\n\nRessourcennivellierung: Gleichmäßige Auslastung\nCrashing: Mehr Ressourcen = schneller (mit Kosten)\nFast Tracking: Parallelisierung kritischer Vorgänge',
      },
    ],
  },

  104: {
    'title': 'Projektanalyse',
    'emoji': '🔍',
    'sections': [
      {
        'heading': 'Stakeholder-Analyse',
        'text':
            'Wer ist vom Projekt betroffen?\n\nMatrix: Einfluss × Interesse\nHoher Einfluss + Hohes Interesse: Aktiv einbinden\nHoher Einfluss + Niedriges Interesse: Zufrieden stellen\nNiedriger Einfluss + Hohes Interesse: Informieren\nNiedriger Einfluss + Niedriges Interesse: Beobachten',
      },
      {
        'heading': 'Risikoanalyse',
        'text':
            'Risiken identifizieren, bewerten, behandeln.\n\nBewertung: Eintrittswahrscheinlichkeit × Schadensausmaß\n\nStrategien:\nVermeiden: Risiko eliminieren\nReduzieren: Wahrscheinlichkeit senken\nÜbertragen: Versicherung, Outsourcing\nAkzeptieren: Bewusst eingehen\n\nRisikoregister: Alle Risiken dokumentieren',
      },
      {
        'heading': 'Projektdokumentation',
        'text':
            'Projektauftrag: Ziel, Umfang, Budget, Zeitplan\nLastenheft: Was soll das System können? (Auftraggeber)\nPflichtenheft: Wie wird es umgesetzt? (Auftragnehmer)\nTestprotokoll: Testergebnisse\nAbnahmeprotokoll: Kunde bestätigt Fertigstellung',
      },
      {
        'heading': 'Earned Value Management',
        'text':
            'Fortschrittscontrolling:\n\nPV (Planned Value): Geplante Kosten bis jetzt\nEV (Earned Value): Wert der geleisteten Arbeit\nAC (Actual Cost): Tatsächliche Kosten\n\nSV (Schedule Variance) = EV - PV (negativ = Verzug)\nCV (Cost Variance) = EV - AC (negativ = über Budget)',
      },
    ],
  },

  // ── QUALITÄTSMANAGEMENT (16) ─────────────────────────────────────────────

  105: {
    'title': 'Total Quality Management',
    'emoji': '⭐',
    'sections': [
      {
        'heading': 'TQM-Grundprinzipien',
        'text':
            'Kundenorientierung: Qualität aus Kundensicht\nMitarbeiterorientierung: Qualität ist Aufgabe aller\nProzessorientierung: Prozesse optimieren\nKontinuierliche Verbesserung (KVP/Kaizen)\n\nDEMING-Kreis (PDCA):\nPlan → Do → Check → Act (→ wiederholen)',
      },
      {
        'heading': 'ISO 9001',
        'text':
            'Internationaler Standard für Qualitätsmanagementsysteme.\n\nAnforderungen:\n→ Dokumentiertes QMS\n→ Prozessorientierung\n→ Kundenfokus\n→ Führung und Engagement\n→ Kontinuierliche Verbesserung\n\nZertifizierung durch akkreditierte Zertifizierungsstelle',
      },
      {
        'heading': 'Qualitätskosten',
        'text':
            'Verhütungskosten: Schulungen, präventive Maßnahmen\nPrüfkosten: Tests, Audits\nFehlerkosten intern: Nacharbeit, Ausschuss\nFehlerkosten extern: Gewährleistung, Imageschaden\n\nFaustregel: 1€ Verhütung spart 10€ Fehlerkosten!',
      },
      {
        'heading': 'Qualitätswerkzeuge',
        'text':
            '7 Qualitätswerkzeuge (Q7):\n1. Fehlersammelkarte\n2. Histogramm\n3. Pareto-Diagramm (80/20-Regel)\n4. Ishikawa (Fischgrät-Diagramm)\n5. Regelkarte\n6. Streudiagramm\n7. Flussdiagramm\n\nPareto: 20% der Ursachen → 80% der Fehler',
      },
    ],
  },

  106: {
    'title': 'Softwarequalität',
    'emoji': '💎',
    'sections': [
      {
        'heading': 'ISO 25010 Qualitätsmerkmale',
        'text':
            'Funktionale Eignung: Tut es was es soll?\nZuverlässigkeit: Läuft es stabil?\nPerformanz: Wie schnell?\nSicherheit: Schutz vor unbefugtem Zugriff\nWartbarkeit: Wie leicht zu ändern?\nPortabilität: Läuft auf verschiedenen Systemen?\nBenutzbarkeit: Wie nutzerfreundlich?',
      },
      {
        'heading': 'Code-Qualität',
        'text':
            'Lesbarkeit: Sauberer, verständlicher Code\nWartbarkeit: Leicht zu ändern\nTestbarkeit: Einfach testbar\nWiederverwendbarkeit: DRY-Prinzip (Don\'t Repeat Yourself)\n\nCode Smells: Zeichen für schlechten Code\nRefactoring: Code verbessern ohne Verhalten zu ändern\nTechnische Schulden: Kurzfristige Lösungen die langfristig Probleme machen',
      },
      {
        'heading': 'SOLID-Prinzipien',
        'text':
            'S — Single Responsibility: Klasse hat genau eine Aufgabe\nO — Open/Closed: Offen für Erweiterung, geschlossen für Änderung\nL — Liskov Substitution: Unterklassen ersetzen Elternklassen\nI — Interface Segregation: Kleine, spezifische Interfaces\nD — Dependency Inversion: Abhängigkeiten umkehren (Interfaces nutzen)',
      },
      {
        'heading': 'Metriken',
        'text':
            'Lines of Code (LOC): Größe des Codes\nZyklomatische Komplexität: Anzahl der Pfade durch Code\nCode Coverage: % des Codes der getestet ist\nTechnische Schulden: Geschätzter Refactoring-Aufwand\n\nSonarQube: Tool zur automatischen Code-Analyse',
      },
    ],
  },

  107: {
    'title': 'Testverfahren',
    'emoji': '🧪',
    'sections': [
      {
        'heading': 'Testarten',
        'text':
            'Unit Test: Einzelne Methode/Klasse\nIntegrationstest: Zusammenspiel von Komponenten\nSystemtest: Gesamtes System\nAbnahmetest (UAT): Kunde testet\n\nRegressionstest: Sicherstellen dass Änderungen nichts kaputtmachen\nLasttest/Stresstest: Performance unter Last\nSicherheitstest: Penetrationstest, Vulnerability Scan',
      },
      {
        'heading': 'Black-Box vs. White-Box',
        'text':
            'Black-Box: Nur Ein-/Ausgabe bekannt, keine Kenntnisse des Codes\n→ Äquivalenzklassen, Grenzwertanalyse\n\nWhite-Box: Tester kennt den Code\n→ Anweisungsüberdeckung, Zweigüberdeckung\n\nGrey-Box: Mischung beider',
      },
      {
        'heading': 'Testmethoden',
        'text':
            'Äquivalenzklassenanalyse: Eingaben in Gruppen aufteilen\nGrenzwertanalyse: Grenzen der Äquivalenzklassen testen\nZustandsbasiertes Testen: Zustandsmaschinen testen\nExploratives Testen: Ohne Testfälle erkunden\n\nTestautomatisierung: Selenium (Web), JUnit, pytest, Cypress',
      },
      {
        'heading': 'Fehlermanagement',
        'text':
            'Fehler-Lebenszyklus:\nOffen → In Bearbeitung → Behoben → Verifiziert → Geschlossen\n\nBugtracker: Jira, GitHub Issues\nSchweregrade: Critical, Major, Minor, Trivial\nPriorität: Wann muss es behoben werden?\n\nTestprotokoll: Alle Tests und Ergebnisse dokumentieren',
      },
    ],
  },

  108: {
    'title': 'Standards & Barrierefreiheit',
    'emoji': '♿',
    'sections': [
      {
        'heading': 'Wichtige IT-Standards',
        'text':
            'ISO/IEC 27001: Informationssicherheit\nISO 9001: Qualitätsmanagementsystem\nISO 25010: Softwarequalität\nIEEE 830: Software Requirements Specification\n\nDIN: Deutsches Institut für Normung\nIEEE: Institute of Electrical and Electronics Engineers',
      },
      {
        'heading': 'WCAG & Barrierefreiheit',
        'text':
            'WCAG (Web Content Accessibility Guidelines):\n\n4 Prinzipien (POUR):\nPercivable: Wahrnehmbar (Alt-Texte, Kontrast)\nOperable: Bedienbar (Tastaturnavigation)\nUnderstandable: Verständlich (klare Sprache)\nRobust: Robust (funktioniert mit Hilfstechnologien)\n\nLevel A, AA, AAA',
      },
      {
        'heading': 'Rechtliche Anforderungen',
        'text':
            'BITV 2.0: Barrierefreie IT-Verordnung (öffentliche Stellen)\nEAA (European Accessibility Act): Ab 2025 auch private Unternehmen\n\nScreenreader: NVDA, JAWS (Windows), VoiceOver (macOS/iOS)\n\nARIA: Accessible Rich Internet Applications\nrole, aria-label, aria-hidden für bessere Zugänglichkeit',
      },
      {
        'heading': 'Nachhaltige IT',
        'text':
            'Green IT: Umweltfreundliche IT-Nutzung\n\nMaßnahmen:\nEnergiesparmodus, Cloud-Konsolidierung\nHardware länger nutzen (Refurbished)\nRechenzentren: PUE-Wert (Power Usage Effectiveness)\nHome-Office statt Pendeln\n\nCO₂-Fußabdruck von Software berücksichtigen',
      },
    ],
  },

  // ── GESCHÄFTSPROZESSE & ORGANISATION (17) ────────────────────────────────

  109: {
    'title': 'Marktformen',
    'emoji': '🏪',
    'sections': [
      {
        'heading': 'Marktformen nach Anbieter/Nachfrager',
        'text':
            '           | 1 Anbieter | Wenige | Viele\nViele NF:  | Monopol    | Oligopol| Polypol\nWenige NF: | Nachfrage- | Beid.   | Angebots-\n           | monopol    | Oligop. | oligopol\n1 NF:      | Beid.Mono  | ...     | Nachfrage-\n           |            |         | monopol',
      },
      {
        'heading': 'Marktgleichgewicht',
        'text':
            'Angebot = Nachfrage → Gleichgewichtspreis\n\nNachfragekurve: Fällt (höherer Preis → weniger Nachfrage)\nAngebotskurve: Steigt (höherer Preis → mehr Angebot)\n\nPreiselastizität: Wie stark reagiert Nachfrage auf Preisänderungen?\nElastisch: Starke Reaktion (Luxusgüter)\nUnelastisch: Schwache Reaktion (Grundbedarf)',
      },
      {
        'heading': 'Marktversagen',
        'text':
            'Externe Effekte: Kosten/Nutzen die Dritte tragen (Umweltverschmutzung)\nÖffentliche Güter: Nicht ausschließbar, nicht rival (Straßen)\nInformationsasymmetrie: Verkäufer weiß mehr als Käufer\nMonopolmacht: Preise über Grenzkosten\n\nStaat greift ein: Steuern, Subventionen, Regulierung',
      },
      {
        'heading': 'Unternehmensstrategien',
        'text':
            'Porter\'s Wettbewerbsstrategien:\nKostenführerschaft: Günstigster Anbieter\nDifferenzierung: Einzigartiges Produkt\nNischenstrategie: Fokus auf Marktsegment\n\nAnsoff-Matrix:\nMarktdurchdringung → Marktentwicklung\n↓\nProduktentwicklung → Diversifikation',
      },
    ],
  },

  110: {
    'title': 'Leitungssysteme & Führung',
    'emoji': '👥',
    'sections': [
      {
        'heading': 'Aufbauorganisation',
        'text':
            'Einliniensystem: Jeder hat genau einen Vorgesetzten\n+ Klare Verantwortung\n- Langer Informationsweg\n\nMehrliniensystem: Mehrere Vorgesetzte möglich\n+ Kurze Wege\n- Kompetenzprobleme\n\nStabliniensystem: Linie + beratende Stabsstellen\nMatrixorganisation: Fach- und Projektverantwortung gleichzeitig',
      },
      {
        'heading': 'Führungsstile',
        'text':
            'Autoritär: Chef entscheidet allein, klare Ansagen\nKooperativ/Demokratisch: Team wird einbezogen\nLaissez-faire: Team entscheidet selbst\n\nSituativer Führungsstil: Je nach Situation anpassen\n\nHersey & Blanchard: Reifegrad des Mitarbeiters bestimmt Stil',
      },
      {
        'heading': 'Motivation',
        'text':
            'Maslow\'s Bedürfnispyramide (von unten):\n1. Physiologisch (Essen, Schlaf)\n2. Sicherheit (Job, Wohnung)\n3. Soziales (Team, Freunde)\n4. Wertschätzung (Anerkennung)\n5. Selbstverwirklichung\n\nHerzberg: Hygienefaktoren vs. Motivatoren\nIntrinsisch vs. Extrinsisch',
      },
      {
        'heading': 'Kommunikation',
        'text':
            '4 Seiten einer Nachricht (Schulz von Thun):\n1. Sachinhalt: Was teile ich mit?\n2. Selbstoffenbarung: Was zeige ich von mir?\n3. Beziehung: Wie stehe ich zu dir?\n4. Appell: Was will ich erreichen?\n\nAktives Zuhören, Ich-Botschaften, Gewaltfreie Kommunikation',
      },
    ],
  },

  111: {
    'title': 'Wirtschaftlichkeit',
    'emoji': '📈',
    'sections': [
      {
        'heading': 'Wirtschaftlichkeitsprinzip',
        'text':
            'Maximalprinzip: Mit gegebenem Aufwand max. Ertrag\nMinimalprinzip: Gegebenes Ziel mit min. Aufwand\n\nWirtschaftlichkeit = Ertrag / Aufwand\n(> 1 = wirtschaftlich)\n\nProduktivität = Output / Input\nRentabilität = Gewinn / Kapital × 100',
      },
      {
        'heading': 'Kosten-Nutzen-Analyse',
        'text':
            'Alle Kosten und Nutzen einer Maßnahme gegenüberstellen.\n\nQuantifizierbare Nutzen: Kosteneinsparung, Umsatzsteigerung\nQualitative Nutzen: Kundenzufriedenheit, Image\n\nNutzwertanalyse: Alternativen nach gewichteten Kriterien bewerten\nSchritte: Kriterien → Gewichten → Bewerten → Berechnen',
      },
      {
        'heading': 'Kennzahlen',
        'text':
            'ROI = (Gewinn / Investition) × 100\nRoI-Beispiel: 10.000€ Gewinn / 50.000€ Investition = 20%\n\nAmortisationszeit = Investition / jährlicher Rückfluss\n\nEBIT = Umsatz - Kosten (ohne Zinsen, Steuern)\nEBITDA = EBIT + Abschreibungen',
      },
      {
        'heading': 'Vergleichsrechnung',
        'text':
            'Angebotsvergleich:\n1. Listenpreis\n- Rabatt\n= Zieleinkaufspreis\n- Skonto (bei Zahlung innerhalb Frist)\n= Bareinkaufspreis\n+ Bezugskosten\n= Bezugspreis\n\nSKonto nutzen wenn: Skonto-% > Zinssatz der Bank',
      },
    ],
  },

  112: {
    'title': 'Beschaffung & Kommunikation',
    'emoji': '📦',
    'sections': [
      {
        'heading': 'Beschaffungsprozess',
        'text':
            '1. Bedarfsermittlung\n2. Lieferantenauswahl\n3. Angebotseinholung\n4. Angebotsvergleich\n5. Bestellung\n6. Wareneingang & Prüfung\n7. Rechnungsprüfung\n8. Zahlung\n\nRFQ (Request for Quotation): Angebotsanfrage',
      },
      {
        'heading': 'Lagerung & Logistik',
        'text':
            'Just-in-Time: Lieferung genau wenn benötigt\nMindestbestand: Sicherheitspuffer\nMeldebestand: Zeitpunkt für Nachbestellung\nHöchstbestand: Maximale Lagerkapazität\n\nABC-Analyse:\nA-Güter: Hoher Wert, geringe Menge (80% Wert)\nB-Güter: Mittlerer Wert\nC-Güter: Niedriger Wert, große Menge',
      },
      {
        'heading': 'Geschäftskommunikation',
        'text':
            'Geschäftsbrief nach DIN 5008:\nAbsender, Empfänger, Datum, Betreff, Anrede, Text, Gruß, Unterschrift\n\nE-Mail: Betreff klar, kurze Absätze, professionelle Signatur\n\nProtokoll: Teilnehmer, TOP, Beschlüsse, Verantwortliche\nLastenheft vs. Pflichtenheft: Auftraggeber vs. Auftragnehmer',
      },
      {
        'heading': 'ERP-Systeme',
        'text':
            'Enterprise Resource Planning: Integrierte Unternehmenssoftware\n\nModule: Finanzen, Personal, Einkauf, Vertrieb, Produktion, Lager\n\nSAP: Marktführer im ERP-Bereich\nS/4HANA: Aktuelle SAP-Version\n\nVorteile: Einheitliche Datenbasis, Prozessautomatisierung\nNachteile: Teuer, komplex, Anpassungsaufwand',
      },
    ],
  },

  // ── BETRIEBSWIRTSCHAFT (1) ───────────────────────────────────────────────

  1: {
    'title': 'Kostenrechnung',
    'emoji': '🧮',
    'sections': [
      {
        'heading': 'Kostenartenrechnung',
        'text':
            'Welche Kosten entstehen?\n\nEinzelkosten: Direkt einem Produkt zurechenbar\nGemeinkosten: Nicht direkt zurechenbar\nFixkosten: Unabhängig von der Menge (Miete)\nVariable Kosten: Steigen mit der Menge (Material)',
      },
      {
        'heading': 'Kalkulation',
        'text':
            'Herstellkosten\n+ Verwaltungsgemeinkosten\n+ Vertriebsgemeinkosten\n= Selbstkosten\n+ Gewinn\n= Verkaufspreis\n\nZuschlagssatz = Gemeinkosten / Einzelkosten × 100',
      },
      {
        'heading': 'Break-Even-Analyse',
        'text':
            'Break-Even-Menge = Fixkosten / Deckungsbeitrag\nDeckungsbeitrag = Preis - variable Stückkosten\n\nBeispiel:\nFK: 5.000€, Preis: 20€, var. K: 10€\nDB = 10€\nBEP = 500 Stück',
      },
      {
        'heading': 'Kennzahlen',
        'text':
            'Wirtschaftlichkeit = Ertrag / Aufwand\nProduktivität = Output / Input\nRentabilität = Gewinn / Kapital × 100\nAmortisation = Investition / Rückfluss p.a.',
      },
    ],
  },

  2: {
    'title': 'Controlling',
    'emoji': '📊',
    'sections': [
      {
        'heading': 'Was ist Controlling?',
        'text':
            'Planung, Steuerung und Kontrolle von Unternehmenszielen.\n\nStrategisches Controlling: Langfristig (3-5 Jahre)\nOperatives Controlling: Kurzfristig (< 1 Jahr)\n\nAufgaben: Planen, Informieren, Koordinieren, Kontrollieren',
      },
      {
        'heading': 'Kennzahlen & KPIs',
        'text':
            'KPI (Key Performance Indicator): Messbare Leistungskennzahl\n\nFinanzkennzahlen: Umsatz, Gewinn, ROI, EBIT\nOperative KPIs: Durchlaufzeit, Fehlerquote, Liefertreue\n\nBalanced Scorecard: Finanzen, Kunden, Prozesse, Lernen',
      },
      {
        'heading': 'Budgetierung',
        'text':
            'Jahresbudget: Geplante Einnahmen und Ausgaben\nSoll-Ist-Vergleich: Abweichungsanalyse\n\nAbweichung = Ist - Soll\nPositiv (Ertrag über Plan oder Kosten unter Plan)\nNegativ (Ertrag unter Plan oder Kosten über Plan)',
      },
      {
        'heading': 'SWOT-Analyse',
        'text':
            'Strengths (Stärken): Intern, positiv\nWeaknesses (Schwächen): Intern, negativ\nOpportunities (Chancen): Extern, positiv\nThreats (Bedrohungen): Extern, negativ\n\nZiel: Strategien ableiten aus Stärken/Chancen und Schwächen/Risiken minimieren',
      },
    ],
  },

  3: {
    'title': 'Vertragsrecht',
    'emoji': '📜',
    'sections': [
      {
        'heading': 'Vertragsschluss',
        'text':
            'Angebot + Annahme = Vertrag\nBeide Parteien müssen sich einig sein (Konsens)\n\nAngebot: Verbindlich, fristgebunden\nAnnahme: Muss rechtzeitig erfolgen\nFormfreiheit: Meist keine Pflichtform\nAusnahmen: Immobilien (Notar), Bürgschaften (Schrift)',
      },
      {
        'heading': 'Kaufvertragspflichten',
        'text':
            'Verkäufer: Ware übergeben + Eigentum übertragen\nKäufer: Ware abnehmen + Kaufpreis zahlen\n\nMängelgewährleistung: 2 Jahre gesetzlich\nMängel melden: Sofort nach Entdeckung\nRechte: Nacherfüllung, Rücktritt, Minderung, Schadensersatz',
      },
      {
        'heading': 'Vertragsarten in der IT',
        'text':
            'Kaufvertrag: Software/Hardware einmalig kaufen\nWerkvertrag: Individualsoftware entwickeln lassen\nDienstvertrag: IT-Fachkraft beschäftigen\nMietvertrag/SaaS: Cloud-Dienste nutzen\nLizenzvertrag: Software nutzen (nicht besitzen)',
      },
      {
        'heading': 'AGB & Verbraucherschutz',
        'text':
            'AGB: Vorformulierte Bedingungen\nUnwirksam: Überraschende Klauseln, unangemessene Benachteiligung\n\nVerbraucher: Natürliche Person außerhalb Gewerbe\nWiderrufsrecht: 14 Tage online/Fernabsatz\nGewährleistung: 2 Jahre auch bei privaten Käufern',
      },
    ],
  },
};