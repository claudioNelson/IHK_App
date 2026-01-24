// screens/exam_screens/exam_selection_screen.dart
// AKTUALISIERTE VERSION - 6 Prüfungen pro Fachrichtung

import 'package:flutter/material.dart';
import 'exam_screen.dart';

class ExamSelectionScreen extends StatefulWidget {
  const ExamSelectionScreen({super.key, required this.specialization});
  final String specialization;

  @override
  State<ExamSelectionScreen> createState() => _ExamSelectionScreenState();
}


class _ExamSelectionScreenState extends State<ExamSelectionScreen> {
  String? selectedSpecialization; // null = keine Auswahl, 'ae' oder 'si'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text(
          'IHK Abschlussprüfungen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: selectedSpecialization != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedSpecialization = null;
                  });
                },
              )
            : null,
      ),
      body: selectedSpecialization == null
          ? _buildSpecializationSelection()
          : _buildExamList(),
    );
  }

  // ========================================
  // SCHRITT 1: Fachrichtung wählen
  // ========================================
  Widget _buildSpecializationSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Fachinformatiker',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Wähle deine Fachrichtung',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Info-Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Wähle deine Fachrichtung und starte die Prüfungssimulation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Anwendungsentwicklung
          _buildSpecializationCard(
            title: 'Anwendungsentwicklung',
            subtitle: 'FIAE',
            description: 'Software entwickeln, Datenbanken modellieren, Algorithmen implementieren',
            color: Colors.blue,
            icon: Icons.code,
            onTap: () {
              setState(() {
                selectedSpecialization = 'ae';
              });
            },
          ),

          const SizedBox(height: 20),

          // Systemintegration
          _buildSpecializationCard(
            title: 'Systemintegration',
            subtitle: 'FISI',
            description: 'Netzwerke planen, Server administrieren, IT-Systeme betreuen',
            color: Colors.teal,
            icon: Icons.dns,
            onTap: () {
              setState(() {
                selectedSpecialization = 'si';
              });
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSpecializationCard({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: color.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // SCHRITT 2: Prüfungen anzeigen (6 Stück!)
  // ========================================
  Widget _buildExamList() {
    final isAE = selectedSpecialization == 'ae';
    final color = isAE ? Colors.blue : Colors.teal;
    final title = isAE ? 'Anwendungsentwicklung' : 'Systemintegration';
    final subtitle = isAE ? 'FIAE' : 'FISI';

    // 6 Prüfungen pro Fachrichtung!
    final exams = isAE
        ? [
            {
              'id': 'ae_exam_1',
              'title': 'Winter 2016/17',
              'subtitle': 'CargoTech GmbH',
              'description': 'LKW-Logistik & Lieferverwaltung',
              'status': 'Verfügbar',
            },
            {
              'id': 'ae_exam_2',
              'title': 'Sommer 2017',
              'subtitle': 'VisionSec GmbH',
              'description': 'Gesichtserkennung & Biometrie',
              'status': 'Verfügbar',
            },
            {
              'id': 'ae_exam_3',
              'title': '2020-2021',
              'subtitle': 'OOP-Konzepte',
              'description': 'Objektorientierte Programmierung',
              'status': 'Verfügbar',
            },
            {
              'id': 'ae_exam_4',
              'title': '2022-2023',
              'subtitle': 'Algorithmen',
              'description': 'Sortieralgorithmen & Komplexität',
              'status': 'Verfügbar',
            },
            {
              'id': 'ae_exam_5',
              'title': '2024-2025',
              'subtitle': 'Vollständige Prüfung',
              'description': 'Fahrradverleih-System (komplett)',
              'status': 'Verfügbar',
            },
            {
              'id': 'ae_exam_6',
              'title': 'Prüfung 6',
              'subtitle': 'Noch nicht verfügbar',
              'description': 'Wird bald hinzugefügt',
              'status': 'Placeholder',
            },
          ]
        : [
            {
              'id': 'si_exam_1',
              'title': '2020-2021',
              'subtitle': 'Netzwerktechnik',
              'description': 'OSI-Modell & TCP/IP',
              'status': 'Verfügbar',
            },
            {
              'id': 'si_exam_2',
              'title': '2022-2023',
              'subtitle': 'Netzwerkplanung',
              'description': 'Subnetting & VLANs',
              'status': 'Verfügbar',
            },
            {
              'id': 'si_exam_3',
              'title': '2024-2025',
              'subtitle': 'IT-Sicherheit',
              'description': 'Firewalls & VPN',
              'status': 'Verfügbar',
            },
            {
              'id': 'si_exam_4',
              'title': 'Prüfung 4',
              'subtitle': 'Noch nicht verfügbar',
              'description': 'Wird bald hinzugefügt',
              'status': 'Placeholder',
            },
            {
              'id': 'si_exam_5',
              'title': 'Prüfung 5',
              'subtitle': 'Noch nicht verfügbar',
              'description': 'Wird bald hinzugefügt',
              'status': 'Placeholder',
            },
            {
              'id': 'si_exam_6',
              'title': 'Prüfung 6',
              'subtitle': 'Noch nicht verfügbar',
              'description': 'Wird bald hinzugefügt',
              'status': 'Placeholder',
            },
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.shade700, color.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAE ? Icons.code : Icons.dns,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Info-Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: color.shade700, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Wähle eine Abschlussprüfung und starte die Simulation',
                    style: TextStyle(
                      fontSize: 14,
                      color: color.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Prüfungen
          ...exams.asMap().entries.map((entry) {
            final index = entry.key;
            final exam = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildExamCard(
                number: index + 1,
                title: exam['title']!,
                subtitle: exam['subtitle']!,
                description: exam['description']!,
                color: color,
                examId: exam['id']!,
                isAvailable: exam['status'] == 'Verfügbar',
              ),
            );
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildExamCard({
    required int number,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required String examId,
    required bool isAvailable,
  }) {
    return InkWell(
      onTap: isAvailable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamScreen(examId: examId),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAvailable ? color.withOpacity(0.3) : Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Nummer
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isAvailable ? color.withOpacity(0.1) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? color : Colors.grey[400],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? color : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isAvailable ? color.withOpacity(0.7) : Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (isAvailable) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildInfoBadge(Icons.timer, '90 Min', color),
                        const SizedBox(width: 8),
                        _buildInfoBadge(Icons.stars, '125 P', color),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Arrow / Lock
            Icon(
              isAvailable ? Icons.arrow_forward_ios : Icons.lock,
              color: isAvailable ? color : Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}