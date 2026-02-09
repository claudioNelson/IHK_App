import 'package:flutter/material.dart';

class ZertifikatInfoScreen extends StatelessWidget {
  const ZertifikatInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Über Zertifikate'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cloud-Zertifizierungen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Bereite dich auf echte Zertifikatsprüfungen vor:\n\n'
                '• AWS Cloud Practitioner\n'
                '• Microsoft Azure Fundamentals (AZ-900)\n'
                '• Google Cloud Digital Leader\n'
                '• SAP Certified Associate\n\n'
                'Zwei Modi verfügbar:\n\n'
                '1️⃣ Prüfungssimulation\n'
                '   - Echte Prüfungsbedingungen\n'
                '   - Timer\n'
                '   - Keine Erklärungen während der Prüfung\n\n'
                '2️⃣ Übungsmodus (NEU im Learning Hub)\n'
                '   - Mit Erklärungen zu jeder Antwort\n'
                '   - Ohne Zeitdruck\n'
                '   - Ideal zum Lernen',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
