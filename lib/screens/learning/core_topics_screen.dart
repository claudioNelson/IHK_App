// lib/screens/learning/core_topics_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network_practice_screen.dart';
import 'raid_practice_screen.dart';
import 'dns_port_practice_screen.dart';
import '../../services/app_cache_service.dart';
import 'security_practice_screen.dart';
import 'osi_practice_screen.dart';
import 'backup_practice_screen.dart';
import 'binary_practice_screen.dart';
import 'kernthemen_info_screen.dart';
import 'database_practice_screen.dart';
import 'project_management_practice_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

// ── Zusammenfassungen pro Thema ──────────────────────────────────────────────
const Map<int, Map<String, dynamic>> _summaries = {
  18: {
    'title': 'Netzwerk & Subnetting',
    'emoji': '🌐',
    'sections': [
      {
        'heading': 'IP-Adressen',
        'text':
            'Eine IPv4-Adresse besteht aus 32 Bit, aufgeteilt in 4 Oktette (z.B. 192.168.1.1). Der Netzanteil wird durch die Subnetzmaske bestimmt.',
      },
      {
        'heading': 'Subnetzmaske',
        'text':
            'Die Subnetzmaske trennt Netz- und Hostteil. /24 bedeutet 24 Bit Netzanteil → 256 Adressen, davon 254 nutzbar (erste = Netzadresse, letzte = Broadcast).',
      },
      {
        'heading': 'CIDR-Notation',
        'text':
            '/24 = 255.255.255.0 → 254 Hosts\n/25 = 255.255.255.128 → 126 Hosts\n/26 = 255.255.255.192 → 62 Hosts\n/27 = 255.255.255.224 → 30 Hosts',
      },
      {
        'heading': 'Wichtige Formeln',
        'text':
            'Anzahl Hosts = 2^(32-Präfix) - 2\nNetzadresse = IP AND Maske\nBroadcast = Netzadresse OR (NOT Maske)',
      },
    ],
  },
  20: {
    'title': 'RAID-Systeme',
    'emoji': '💾',
    'sections': [
      {
        'heading': 'Was ist RAID?',
        'text':
            'RAID (Redundant Array of Independent Disks) kombiniert mehrere Festplatten zu einem logischen Laufwerk für mehr Leistung und/oder Ausfallsicherheit.',
      },
      {
        'heading': 'RAID 0 — Striping',
        'text':
            'Daten werden auf alle Platten verteilt. Keine Redundanz! Fällt eine Platte aus → alles weg. Kapazität = n × Plattengröße. Vorteil: maximale Geschwindigkeit.',
      },
      {
        'heading': 'RAID 1 — Mirroring',
        'text':
            'Daten werden gespiegelt. 1 Platte kann ausfallen. Kapazität = Plattengröße (nicht n × Plattengröße!). Vorteil: einfache Redundanz.',
      },
      {
        'heading': 'RAID 5 — Striping mit Parität',
        'text':
            'Daten + Paritätsinformationen verteilt. Mindestens 3 Platten. 1 Platte kann ausfallen. Kapazität = (n-1) × Plattengröße.',
      },
      {
        'heading': 'RAID 6',
        'text':
            'Wie RAID 5, aber doppelte Parität. 2 Platten können ausfallen. Mindestens 4 Platten. Kapazität = (n-2) × Plattengröße.',
      },
      {
        'heading': 'RAID 10 (1+0)',
        'text':
            'Kombination aus RAID 1 und RAID 0. Mindestens 4 Platten. Hohe Geschwindigkeit + Redundanz. Kapazität = n/2 × Plattengröße.',
      },
    ],
  },
  21: {
    'title': 'DNS & Ports',
    'emoji': '📡',
    'sections': [
      {
        'heading': 'Was ist DNS?',
        'text':
            'Das Domain Name System übersetzt Domainnamen in IP-Adressen. Ohne DNS müsste man sich alle IP-Adressen merken.',
      },
      {
        'heading': 'DNS-Auflösung',
        'text':
            '1. Browser fragt lokalen Cache\n2. Fragt DNS-Resolver (meist Router)\n3. Fragt Root-Nameserver\n4. Fragt TLD-Nameserver (.de, .com)\n5. Fragt autoritativen Nameserver',
      },
      {
        'heading': 'Wichtige Ports',
        'text':
            'HTTP: 80\nHTTPS: 443\nFTP: 21\nSSH: 22\nSMTP: 25\nDNS: 53\nRDP: 3389\nMySQL: 3306\nPostgreSQL: 5432',
      },
      {
        'heading': 'TCP vs UDP',
        'text':
            'TCP: verbindungsorientiert, zuverlässig, langsamer (HTTP, FTP, SSH)\nUDP: verbindungslos, schneller, kein Handshake (DNS, Streaming, VoIP)',
      },
    ],
  },
  22: {
    'title': 'IT-Sicherheit',
    'emoji': '🔒',
    'sections': [
      {
        'heading': 'CIA-Triade',
        'text':
            'Confidentiality (Vertraulichkeit): Nur Berechtigte haben Zugriff\nIntegrity (Integrität): Daten sind unverändert\nAvailability (Verfügbarkeit): System ist erreichbar',
      },
      {
        'heading': 'Angriffsmethoden',
        'text':
            'Phishing: Gefälschte E-Mails/Webseiten\nBrute Force: Alle Passwörter ausprobieren\nMan-in-the-Middle: Kommunikation abfangen\nDDoS: Server mit Anfragen überfluten\nSQL-Injection: Schadcode in Datenbankabfragen',
      },
      {
        'heading': 'Schutzmaßnahmen',
        'text':
            'Firewall: Filtert Netzwerkverkehr\nVPN: Verschlüsselte Verbindung\nSSL/TLS: Verschlüsselung bei Übertragung\n2FA: Zwei-Faktor-Authentifizierung\nBackups: Regelmäßige Datensicherung',
      },
      {
        'heading': 'Verschlüsselung',
        'text':
            'Symmetrisch: Gleicher Schlüssel für Ver- und Entschlüsselung (AES)\nAsymmetrisch: Public Key verschlüsselt, Private Key entschlüsselt (RSA)\nHashfunktion: Einweg-Verschlüsselung (SHA-256, MD5)',
      },
    ],
  },
  23: {
    'title': 'OSI-Modell',
    'emoji': '📶',
    'sections': [
      {
        'heading': 'Die 7 Schichten',
        'text':
            '7. Anwendung (Application) — HTTP, FTP, DNS\n6. Darstellung (Presentation) — SSL, Codierung\n5. Sitzung (Session) — Verbindungsaufbau\n4. Transport — TCP, UDP, Ports\n3. Vermittlung (Network) — IP, Router\n2. Sicherung (Data Link) — MAC, Switch\n1. Bitübertragung (Physical) — Kabel, Hub',
      },
      {
        'heading': 'Merkhilfe',
        'text':
            'Von unten nach oben:\n"Phy-Da-Ve-Tr-Si-Da-An"\noder: "Please Do Not Throw Sausage Pizza Away"',
      },
      {
        'heading': 'Wichtige Geräte',
        'text':
            'Hub → Schicht 1 (Physical)\nSwitch → Schicht 2 (Data Link)\nRouter → Schicht 3 (Network)\nFirewall → Schicht 3-7',
      },
      {
        'heading': 'PDUs pro Schicht',
        'text':
            'Schicht 1: Bits\nSchicht 2: Frames\nSchicht 3: Pakete\nSchicht 4: Segmente (TCP) / Datagramme (UDP)',
      },
    ],
  },
  24: {
    'title': 'Backup-Strategien',
    'emoji': '🗄️',
    'sections': [
      {
        'heading': 'Backup-Arten',
        'text':
            'Vollbackup: Alle Daten werden gesichert. Vorteil: einfache Wiederherstellung. Nachteil: zeitaufwändig, viel Speicher.\n\nInkrementelles Backup: Nur Änderungen seit letztem Backup. Vorteil: schnell, wenig Speicher. Nachteil: Wiederherstellung aufwändiger.\n\nDifferenzielles Backup: Änderungen seit letztem Vollbackup. Kompromiss zwischen beiden.',
      },
      {
        'heading': '3-2-1 Regel',
        'text':
            '3 Kopien der Daten\n2 verschiedene Speichermedien\n1 Kopie an einem externen Ort (z.B. Cloud)',
      },
      {
        'heading': 'Generationenprinzip',
        'text':
            'Großvater-Vater-Sohn Prinzip:\nSohn: tägliche Backups (5 Tage)\nVater: wöchentliche Backups (4 Wochen)\nGroßvater: monatliche Backups (12 Monate)',
      },
      {
        'heading': 'RPO & RTO',
        'text':
            'RPO (Recovery Point Objective): Maximaler Datenverlust in Zeit — wie alt darf das letzte Backup sein?\nRTO (Recovery Time Objective): Maximale Ausfallzeit — wie lange darf die Wiederherstellung dauern?',
      },
    ],
  },
  25: {
    'title': 'Binär & Hexadezimal',
    'emoji': '🔢',
    'sections': [
      {
        'heading': 'Zahlensysteme',
        'text':
            'Dezimal (Basis 10): 0-9\nBinär (Basis 2): 0-1\nHexadezimal (Basis 16): 0-9, A-F\n\nA=10, B=11, C=12, D=13, E=14, F=15',
      },
      {
        'heading': 'Dezimal → Binär',
        'text':
            'Durch 2 teilen, Rest notieren (von unten lesen):\n13 ÷ 2 = 6 Rest 1\n6 ÷ 2 = 3 Rest 0\n3 ÷ 2 = 1 Rest 1\n1 ÷ 2 = 0 Rest 1\n→ 13 = 1101',
      },
      {
        'heading': 'Binär → Dezimal',
        'text':
            'Stellenwerte: 128-64-32-16-8-4-2-1\n1101 = 8+4+0+1 = 13\n11111111 = 128+64+32+16+8+4+2+1 = 255',
      },
      {
        'heading': 'Hex ↔ Binär',
        'text':
            'Jede Hex-Stelle = 4 Bit:\nF = 1111\nA = 1010\n0 = 0000\nFF = 11111111 = 255\nBeispiel: IPv6 nutzt Hex-Schreibweise',
      },
    ],
  },
  26: {
    'title': 'Datenbanken & SQL',
    'emoji': '🗃️',
    'sections': [
      {
        'heading': 'Grundbegriffe',
        'text':
            'Tabelle: Speichert Daten in Zeilen und Spalten\nPrimärschlüssel (PK): Eindeutiger Bezeichner\nFremdschlüssel (FK): Verweis auf anderen PK\nIndex: Beschleunigt Abfragen',
      },
      {
        'heading': 'Wichtige SQL-Befehle',
        'text':
            'SELECT * FROM tabelle WHERE bedingung\nINSERT INTO tabelle VALUES (...)\nUPDATE tabelle SET feld=wert WHERE ...\nDELETE FROM tabelle WHERE ...\nJOIN: Tabellen verknüpfen',
      },
      {
        'heading': 'Normalformen',
        'text':
            '1NF: Atomare Werte, keine Wiederholungsgruppen\n2NF: 1NF + keine partiellen Abhängigkeiten\n3NF: 2NF + keine transitiven Abhängigkeiten',
      },
      {
        'heading': 'JOIN-Typen',
        'text':
            'INNER JOIN: Nur übereinstimmende Datensätze\nLEFT JOIN: Alle links + übereinstimmende rechts\nRIGHT JOIN: Alle rechts + übereinstimmende links\nFULL JOIN: Alle Datensätze beider Tabellen',
      },
    ],
  },
  27: {
    'title': 'Projektmanagement',
    'emoji': '📋',
    'sections': [
      {
        'heading': 'Projektphasen',
        'text':
            '1. Initiierung: Projektidee, Machbarkeit\n2. Planung: Zeitplan, Ressourcen, Risiken\n3. Durchführung: Umsetzung\n4. Überwachung: Fortschritt kontrollieren\n5. Abschluss: Übergabe, Dokumentation',
      },
      {
        'heading': 'Magisches Dreieck',
        'text':
            'Zeit — Kosten — Qualität\nDiese drei Faktoren stehen im Konflikt. Verbessert man einen, leidet meist ein anderer.',
      },
      {
        'heading': 'Vorgehensmodelle',
        'text':
            'Wasserfallmodell: Sequenziell, jede Phase abgeschlossen bevor nächste beginnt\nScrum: Agil, Sprints (2-4 Wochen), Daily Standups\nKanban: Visuelles Board, kontinuierlicher Fluss',
      },
      {
        'heading': 'Wichtige Begriffe',
        'text':
            'Meilenstein: Wichtiges Ereignis im Projektverlauf\nGantt-Diagramm: Zeitlicher Ablaufplan\nKritischer Pfad: Längster Weg durch das Projekt\nRisikomanagement: Risiken identifizieren und bewerten',
      },
    ],
  },
};

class CoreTopicsScreen extends StatefulWidget {
  const CoreTopicsScreen({super.key});

  @override
  State<CoreTopicsScreen> createState() => _CoreTopicsScreenState();
}

class _CoreTopicsScreenState extends State<CoreTopicsScreen> {
  List<Map<String, dynamic>> _coreTopics = [];
  bool _loading = true;
  Map<int, Map<String, dynamic>> _progress = {};

  @override
  void initState() {
    super.initState();
    _loadCoreTopics();
    _checkInfoScreen();
  }

  Future<void> _loadCoreTopics() async {
    try {
      final cache = AppCacheService();
      if (cache.kernthemenLoaded) {
        setState(() {
          _coreTopics = List<Map<String, dynamic>>.from(cache.cachedKernthemen);
          _progress = cache.cachedKernthemenProgress;
          _loading = false;
        });
        return;
      }
      await cache.preloadKernthemen();
      if (!mounted) return;
      setState(() {
        _coreTopics = List<Map<String, dynamic>>.from(cache.cachedKernthemen);
        _progress = cache.cachedKernthemenProgress;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _refreshProgress() async {
    final cache = AppCacheService();
    await cache.refreshKernthemenProgress();
    if (!mounted) return;
    setState(() => _progress = cache.cachedKernthemenProgress);
  }

  Future<void> _checkInfoScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('kernthemen_info_shown') ?? false;
    if (!shown && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KernthemenInfoScreen()),
      );
    }
  }

  _TopicConfig _getConfig(int id) {
    switch (id) {
      case 18: return _TopicConfig(Icons.lan_rounded, const Color(0xFF2563EB));
      case 20: return _TopicConfig(Icons.storage_rounded, const Color(0xFF0D9488));
      case 21: return _TopicConfig(Icons.dns_rounded, const Color(0xFF7C3AED));
      case 22: return _TopicConfig(Icons.security_rounded, const Color(0xFFDC2626));
      case 23: return _TopicConfig(Icons.layers_rounded, const Color(0xFF4F46E5));
      case 24: return _TopicConfig(Icons.backup_rounded, const Color(0xFF0891B2));
      case 25: return _TopicConfig(Icons.calculate_rounded, const Color(0xFFEA580C));
      case 26: return _TopicConfig(Icons.table_chart_rounded, const Color(0xFF7C3AED));
      case 27: return _TopicConfig(Icons.account_tree_rounded, const Color(0xFF16A34A));
      default: return _TopicConfig(Icons.lightbulb_rounded, const Color(0xFFF59E0B));
    }
  }

  Future<void> _openTopic(Map<String, dynamic> topic) async {
    Widget? screen;
    switch (topic['id']) {
      case 18: screen = NetworkPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 20: screen = RaidPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 21: screen = DnsPortPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 22: screen = SecurityPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 23: screen = OsiPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 24: screen = BackupPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 25: screen = BinaryPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 26: screen = DatabasePracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      case 27: screen = ProjectManagementPracticeScreen(moduleId: topic['id'], moduleName: topic['name']); break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${topic['name']} — Coming Soon!')));
        return;
    }
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    _refreshProgress();
  }

  void _showSummary(Map<String, dynamic> topic) {
    final id = topic['id'] as int;
    final summary = _summaries[id];
    final config = _getConfig(id);

    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zusammenfassung folgt bald!')));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SummarySheet(
        topic: topic,
        summary: summary,
        config: config,
        onStart: () {
          Navigator.pop(context);
          _openTopic(topic);
        },
      ),
    );
  }

  double get _overallProgress {
    if (_progress.isEmpty) return 0;
    final total = _progress.values.fold(0, (a, b) => a + (b['total'] as int));
    final correct = _progress.values.fold(0, (a, b) => a + (b['correct'] as int));
    return total > 0 ? correct / total : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _indigo))
                : _coreTopics.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        color: _indigo,
                        onRefresh: _loadCoreTopics,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                          itemCount: _coreTopics.length,
                          itemBuilder: (ctx, i) => _buildCard(_coreTopics[i], i),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_indigoDark, _indigo, _indigoLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (Navigator.canPop(context)) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.star_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kernthemen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text('Kommen in JEDER IHK-Prüfung vor',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              if (!_loading && _coreTopics.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _overallProgress,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(_overallProgress * 100).toInt()}% gesamt',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: _indigo.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.inbox_outlined, size: 56, color: _indigo),
          ),
          const SizedBox(height: 16),
          const Text('Keine Kernthemen gefunden',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> topic, int index) {
    final config = _getConfig(topic['id'] as int);
    final progress = _progress[topic['id']];
    final percent = progress?['percent'] as double? ?? 0.0;
    final correct = progress?['correct'] as int? ?? 0;
    final total = progress?['total'] as int? ?? 0;
    final hasSummary = _summaries.containsKey(topic['id']);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 150 + index * 40),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (ctx, val, child) => Transform.translate(
        offset: Offset(20 * (1 - val), 0),
        child: Opacity(opacity: val, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: config.color.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: config.color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _openTopic(topic),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [config.color, config.color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: config.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(config.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),

                  // Text + Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic['name'] ?? '',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        if (progress != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('$correct/$total',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percent / 100,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor: AlwaysStoppedAnimation(
                                        percent >= 80
                                            ? Colors.green
                                            : config.color),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${percent.toInt()}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: config.color)),
                            ],
                          ),
                        ] else if (topic['beschreibung'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            topic['beschreibung'],
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Info Button
                  if (hasSummary)
                    GestureDetector(
                      onTap: () => _showSummary(topic),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: config.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: config.color.withOpacity(0.2)),
                        ),
                        child: Icon(Icons.info_outline_rounded,
                            color: config.color, size: 18),
                      ),
                    ),

                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade300, size: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Summary Bottom Sheet ─────────────────────────────────────────────────────
class _SummarySheet extends StatelessWidget {
  final Map<String, dynamic> topic;
  final Map<String, dynamic> summary;
  final _TopicConfig config;
  final VoidCallback onStart;

  const _SummarySheet({
    required this.topic,
    required this.summary,
    required this.config,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final sections = summary['sections'] as List;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [config.color, config.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        summary['emoji'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary['title'] as String,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Zusammenfassung',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade400),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            // Content
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: sections.length,
                itemBuilder: (_, i) {
                  final section = sections[i] as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: config.color.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: config.color.withOpacity(0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: config.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              section['heading'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: config.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          section['text'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Start Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 8, 24, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: const Text('Jetzt üben',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicConfig {
  final IconData icon;
  final Color color;
  const _TopicConfig(this.icon, this.color);
}