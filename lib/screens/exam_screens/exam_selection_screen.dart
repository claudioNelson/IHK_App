// screens/exam_screens/exam_selection_screen.dart

import 'package:flutter/material.dart';
import 'exam_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoDark = Color(0xFF3730A3);
const _indigoLight = Color(0xFF6366F1);

class ExamSelectionScreen extends StatefulWidget {
  const ExamSelectionScreen({super.key, required this.specialization});
  final String specialization;

  @override
  State<ExamSelectionScreen> createState() => _ExamSelectionScreenState();
}

class _ExamSelectionScreenState extends State<ExamSelectionScreen> {
  String? selectedSpecialization;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selectedSpecialization == null
                    ? const [_indigoDark, _indigo, _indigoLight]
                    : selectedSpecialization == 'ae'
                        ? [
                            const Color(0xFF1E3A8A),
                            const Color(0xFF1D4ED8),
                            const Color(0xFF3B82F6)
                          ]
                        : [
                            const Color(0xFF134E4A),
                            const Color(0xFF0F766E),
                            const Color(0xFF14B8A6)
                          ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Row(
                  children: [
                    if (selectedSpecialization != null)
                      GestureDetector(
                        onTap: () =>
                            setState(() => selectedSpecialization = null),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 18),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        selectedSpecialization == 'ae'
                            ? Icons.code_rounded
                            : selectedSpecialization == 'si'
                                ? Icons.dns_rounded
                                : Icons.school_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'IHK Abschlussprüfungen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedSpecialization == null
                                ? 'Wähle deine Fachrichtung'
                                : selectedSpecialization == 'ae'
                                    ? 'Anwendungsentwicklung · FIAE'
                                    : 'Systemintegration · FISI',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── CONTENT ─────────────────────────────────────
          Expanded(
            child: selectedSpecialization == null
                ? _buildSpecializationSelection()
                : _buildExamList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationSelection() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _indigo.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: _indigo.withOpacity(0.15), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.info_outline_rounded, color: _indigo, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Wähle deine Fachrichtung um die passenden Abschlussprüfungen zu sehen.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildSpecCard(
            title: 'Anwendungsentwicklung',
            subtitle: 'FIAE',
            description:
                'Software entwickeln, Datenbanken modellieren, Algorithmen implementieren',
            accentColor: const Color(0xFF1D4ED8),
            lightColor: const Color(0xFFEFF6FF),
            icon: Icons.code_rounded,
            examCount: 5,
            onTap: () =>
                setState(() => selectedSpecialization = 'ae'),
          ),

          const SizedBox(height: 16),

          _buildSpecCard(
            title: 'Systemintegration',
            subtitle: 'FISI',
            description:
                'Netzwerke planen, Server administrieren, IT-Systeme betreuen',
            accentColor: const Color(0xFF0F766E),
            lightColor: const Color(0xFFF0FDFA),
            icon: Icons.dns_rounded,
            examCount: 3,
            onTap: () =>
                setState(() => selectedSpecialization = 'si'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard({
    required String title,
    required String subtitle,
    required String description,
    required Color accentColor,
    required Color lightColor,
    required IconData icon,
    required int examCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: accentColor.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [accentColor, accentColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: accentColor)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: accentColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(description,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$examCount Prüfungen verfügbar',
                      style: TextStyle(
                          fontSize: 11,
                          color: accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: accentColor, size: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildExamList() {
    final isAE = selectedSpecialization == 'ae';
    final accentColor =
        isAE ? const Color(0xFF1D4ED8) : const Color(0xFF0F766E);

    final exams = isAE
        ? [
            {
              'id': 'ae_exam_1',
              'title': 'Winter 2016/17',
              'subtitle': 'CargoTech GmbH',
              'description': 'LKW-Logistik & Lieferverwaltung',
              'available': true,
            },
            {
              'id': 'ae_exam_2',
              'title': 'Sommer 2017',
              'subtitle': 'VisionSec GmbH',
              'description': 'Gesichtserkennung & Biometrie',
              'available': true,
            },
            {
              'id': 'ae_exam_3',
              'title': '2020–2021',
              'subtitle': 'OOP-Konzepte',
              'description': 'Objektorientierte Programmierung',
              'available': true,
            },
            {
              'id': 'ae_exam_4',
              'title': '2022–2023',
              'subtitle': 'Algorithmen',
              'description': 'Sortieralgorithmen & Komplexität',
              'available': true,
            },
            {
              'id': 'ae_exam_5',
              'title': '2024–2025',
              'subtitle': 'Vollständige Prüfung',
              'description': 'Fahrradverleih-System (komplett)',
              'available': true,
            },
            {
              'id': 'ae_exam_6',
              'title': 'Prüfung 6',
              'subtitle': 'Demnächst',
              'description': 'Wird bald hinzugefügt',
              'available': false,
            },
          ]
        : [
            {
              'id': 'si_exam_1',
              'title': '2020–2021',
              'subtitle': 'Netzwerktechnik',
              'description': 'OSI-Modell & TCP/IP',
              'available': true,
            },
            {
              'id': 'si_exam_2',
              'title': '2022–2023',
              'subtitle': 'Netzwerkplanung',
              'description': 'Subnetting & VLANs',
              'available': true,
            },
            {
              'id': 'si_exam_3',
              'title': '2024–2025',
              'subtitle': 'IT-Sicherheit',
              'description': 'Firewalls & VPN',
              'available': true,
            },
            {
              'id': 'si_exam_4',
              'title': 'Prüfung 4',
              'subtitle': 'Demnächst',
              'description': 'Wird bald hinzugefügt',
              'available': false,
            },
            {
              'id': 'si_exam_5',
              'title': 'Prüfung 5',
              'subtitle': 'Demnächst',
              'description': 'Wird bald hinzugefügt',
              'available': false,
            },
            {
              'id': 'si_exam_6',
              'title': 'Prüfung 6',
              'subtitle': 'Demnächst',
              'description': 'Wird bald hinzugefügt',
              'available': false,
            },
          ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      itemCount: exams.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Info Banner
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: accentColor.withOpacity(0.15), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: accentColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Wähle eine Prüfung und starte die Simulation (90 Min)',
                    style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }

        final exam = exams[index - 1];
        final number = index;
        final isAvailable = exam['available'] as bool;
        final examId = exam['id'] as String;

        return _buildExamCard(
          number: number,
          title: exam['title'] as String,
          subtitle: exam['subtitle'] as String,
          description: exam['description'] as String,
          accentColor: accentColor,
          examId: examId,
          isAvailable: isAvailable,
        );
      },
    );
  }

  Widget _buildExamCard({
    required int number,
    required String title,
    required String subtitle,
    required String description,
    required Color accentColor,
    required String examId,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExamScreen(examId: examId)),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isAvailable
                ? accentColor.withOpacity(0.2)
                : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isAvailable
                  ? accentColor.withOpacity(0.06)
                  : Colors.transparent,
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: isAvailable
                    ? LinearGradient(
                        colors: [accentColor, accentColor.withOpacity(0.7)])
                    : null,
                color: isAvailable ? null : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isAvailable
                    ? [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: isAvailable
                    ? Text(
                        '$number',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    : Icon(Icons.lock_rounded,
                        color: Colors.grey.shade400, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isAvailable
                            ? accentColor
                            : Colors.grey.shade500),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: isAvailable
                            ? accentColor.withOpacity(0.7)
                            : Colors.grey.shade400,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (isAvailable) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _badge(Icons.timer_rounded, '90 Min', accentColor),
                        const SizedBox(width: 6),
                        _badge(Icons.stars_rounded, '125 P', accentColor),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isAvailable
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.lock_rounded,
              color: isAvailable ? accentColor : Colors.grey.shade300,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(text,
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}