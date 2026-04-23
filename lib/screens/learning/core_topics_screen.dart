// lib/screens/learning/core_topics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network_practice_screen.dart';
import 'raid_practice_screen.dart';
import 'dns_port_practice_screen.dart';
import '../../services/app_cache_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import 'security_practice_screen.dart';
import 'osi_practice_screen.dart';
import 'backup_practice_screen.dart';
import 'binary_practice_screen.dart';
import 'kernthemen_info_screen.dart';
import 'database_practice_screen.dart';
import 'project_management_practice_screen.dart';

// ── Zusammenfassungen pro Thema ──────────────────────────────────────────────
const Map<int, Map<String, dynamic>> _summaries = {
  18: {
    'title': 'Netzwerk & Subnetting',
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

// Mono-Kürzel statt Icons
String _getTopicTag(int id) {
  switch (id) {
    case 18:
      return '/24'; // Subnetting
    case 20:
      return 'R6'; // RAID
    case 21:
      return 'DNS'; // DNS & Ports
    case 22:
      return 'SEC'; // Security
    case 23:
      return 'L7'; // OSI
    case 24:
      return '3-2-1'; // Backup
    case 25:
      return '0b'; // Binary
    case 26:
      return 'SQL'; // Database
    case 27:
      return 'PM'; // Project Management
    default:
      return '—';
  }
}

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
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

  Future<void> _openTopic(Map<String, dynamic> topic) async {
    Widget? screen;
    switch (topic['id']) {
      case 18:
        screen = NetworkPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 20:
        screen = RaidPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 21:
        screen = DnsPortPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 22:
        screen = SecurityPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 23:
        screen = OsiPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 24:
        screen = BackupPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 25:
        screen = BinaryPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 26:
        screen = DatabasePracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      case 27:
        screen = ProjectManagementPracticeScreen(
          moduleId: topic['id'],
          moduleName: topic['name'],
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${topic['name']} — Coming Soon!')),
        );
        return;
    }
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    _refreshProgress();
  }

  void _showSummary(Map<String, dynamic> topic) {
    final id = topic['id'] as int;
    final summary = _summaries[id];

    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Zusammenfassung folgt bald'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isDark = context.read<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    final sections = summary['sections'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: border)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: textDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Row(
                  children: [
                    Container(width: 16, height: 1, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Text(
                      'ZUSAMMENFASSUNG',
                      style: AppTextStyles.monoLabel(AppColors.accent),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: textMid, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getTopicTag(id),
                        style: AppTextStyles.mono(
                          size: 11,
                          color: AppColors.accent,
                          weight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        summary['title'] as String,
                        style: AppTextStyles.instrumentSerif(
                          size: 26,
                          color: text,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: border, height: 24),

              // Content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: sections.length,
                  itemBuilder: (_, i) {
                    final section = sections[i] as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                (i + 1).toString().padLeft(2, '0'),
                                style: AppTextStyles.mono(
                                  size: 11,
                                  color: AppColors.accent,
                                  weight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(width: 24, height: 1, color: border),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  section['heading'] as String,
                                  style: AppTextStyles.h3(text),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 44),
                            child: Text(
                              section['text'] as String,
                              style: AppTextStyles.bodyMedium(textMid),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Start Button
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  border: Border(top: BorderSide(color: border)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openTopic(topic);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Jetzt üben'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: text,
                      foregroundColor: bg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: AppTextStyles.labelLarge(bg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _overallProgress {
    if (_progress.isEmpty) return 0;
    final total = _progress.values.fold(0, (a, b) => a + (b['total'] as int));
    final correct = _progress.values.fold(
      0,
      (a, b) => a + (b['correct'] as int),
    );
    return total > 0 ? correct / total : 0;
  }

  int get _masteredCount {
    return _progress.values
        .where((p) => (p['percent'] as double? ?? 0) >= 80)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // ─── APPBAR ────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: text, size: 22),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Kernthemen',
                    style: AppTextStyles.instrumentSerif(
                      size: 24,
                      color: text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KernthemenInfoScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: textMid,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CONTENT ───────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _coreTopics.isEmpty
                ? _buildEmpty(textMid, textDim)
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: _loadCoreTopics,
                    child: _buildList(surface, border, text, textMid, textDim),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Intro Card
        _buildIntroCard(surface, border, text, textMid, textDim),

        const SizedBox(height: 24),

        // Status Banner
        _buildStatusBanner(surface, border, text, textMid, textDim),

        const SizedBox(height: 28),

        // Section-Header
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'ESSENTIALS · ${_coreTopics.length}',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Topics
        ..._coreTopics.map(
          (t) => _buildTopicCard(t, surface, border, text, textMid, textDim),
        ),
      ],
    );
  }

  // ─── INTRO ──────────────────────────────
  Widget _buildIntroCard(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 1, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              'PRÜFUNGSRELEVANT',
              style: AppTextStyles.monoLabel(AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Die Basics.',
          style: AppTextStyles.instrumentSerif(
            size: 34,
            color: text,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Diese Themen kommen in JEDER IHK-Prüfung vor.',
          style: AppTextStyles.bodyMedium(textMid),
        ),
      ],
    );
  }

  // ─── STATUS BANNER ──────────────────────
  Widget _buildStatusBanner(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [AppColors.accent, AppColors.accent, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'DEIN STAND',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_masteredCount',
                style: AppTextStyles.instrumentSerif(
                  size: 42,
                  color: text,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${_coreTopics.length} gemeistert',
                  style: AppTextStyles.bodyMedium(textMid),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(_overallProgress * 100).toInt()}%',
                    style: AppTextStyles.instrumentSerif(
                      size: 28,
                      color: AppColors.accent,
                      letterSpacing: -1,
                    ),
                  ),
                  Text('DURCHSCHNITT', style: AppTextStyles.monoSmall(textDim)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _overallProgress,
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── TOPIC CARD ─────────────────────────
  Widget _buildTopicCard(
    Map<String, dynamic> topic,
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final id = topic['id'] as int;
    final tag = _getTopicTag(id);
    final progress = _progress[id];
    final percent = progress?['percent'] as double? ?? 0.0;
    final correct = progress?['correct'] as int? ?? 0;
    final total = progress?['total'] as int? ?? 0;
    final hasSummary = _summaries.containsKey(id);
    final isMastered = percent >= 80;
    final isStarted = correct > 0;

    final accentColor = isMastered ? AppColors.success : AppColors.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openTopic(topic),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMastered ? AppColors.success.withOpacity(0.4) : border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag-Badge (Mono-Kürzel)
                  Container(
                    constraints: const BoxConstraints(minWidth: 52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        tag,
                        style: AppTextStyles.mono(
                          size: 11,
                          color: accentColor,
                          weight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name + Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                topic['name'] ?? '',
                                style: AppTextStyles.labelLarge(text),
                              ),
                            ),
                            if (isMastered)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                        if (!isStarted && topic['beschreibung'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            topic['beschreibung'],
                            style: AppTextStyles.bodySmall(textMid),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Status / Arrow
                  if (isStarted)
                    Text(
                      '${percent.toInt()}%',
                      style: AppTextStyles.interTight(
                        size: 14,
                        weight: FontWeight.w700,
                        color: accentColor,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textDim,
                      size: 12,
                    ),
                ],
              ),

              // Progress Row (nur wenn gestartet)
              if (isStarted) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '$correct / $total',
                      style: AppTextStyles.monoSmall(textDim),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: percent / 100,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(accentColor),
                          minHeight: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Summary-Link
              if (hasSummary) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showSummary(topic),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined, color: textMid, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Zusammenfassung lesen',
                        style: AppTextStyles.mono(
                          size: 11,
                          color: textMid,
                          weight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: textMid,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(Color textMid, Color textDim) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: textDim),
          const SizedBox(height: 16),
          Text('Keine Kernthemen gefunden', style: AppTextStyles.h3(textMid)),
        ],
      ),
    );
  }
}
