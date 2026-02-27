import 'package:flutter/material.dart';

Future<bool?> showZertifikatInfoDialog(
  BuildContext context,
  Map<String, dynamic> cert,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header mit Gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cert['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cert['anbieter'],
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prüfungsdetails
                  _buildInfoBox(
                    Icons.info_outline,
                    'Prüfungsdetails',
                    Colors.blue,
                    [
                      '📝 ${cert['anzahl_fragen']} Fragen',
                      '⏱️ ${cert['pruefungsdauer']} Minuten',
                      '🎯 Mindestens ${cert['mindest_punktzahl']}% zum Bestehen',
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Wichtige Hinweise
                  _buildInfoBox(
                    Icons.lightbulb_outline,
                    'Wichtige Hinweise',
                    Colors.amber,
                    [
                      '• Multiple-Choice Fragen',
                      '• Timer läuft während der Prüfung',
                      '• Fortschritt wird automatisch gespeichert',
                      '• Du kannst Fragen zurück navigieren',
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tipps
                  _buildInfoBox(Icons.tips_and_updates, 'Tipps', Colors.green, [
                    '✓ Lies jede Frage sorgfältig',
                    '✓ Behalte die Zeit im Auge',
                    '✓ Bei Unsicherheit: Markiere & später prüfen',
                    '✓ Keine Hilfsmittel verwenden für echtes Training',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Prüfung starten'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoBox(
  IconData icon,
  String title,
  Color color,
  List<String> items,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ),
      ],
    ),
  );
}
