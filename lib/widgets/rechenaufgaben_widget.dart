import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget für Rechenaufgaben in der Prüfungssimulation
/// 
/// Beispiel aus AP1 Prüfung:
/// "Berechnen Sie die Kosten je Monat mit Angabe des Rechenweges..."
/// 
/// Features:
/// - Zahleneingabe mit Währungsformatierung
/// - Optionales Rechenweg-Textfeld
/// - Validierung
/// - Automatisches Speichern
class RechenaufgabenWidget extends StatefulWidget {
  final String frage;
  final int punkte;
  final String? hinweis;
  final bool zeigeRechenweg;
  final Function(double? antwort, String? rechenweg) onAnswerChanged;
  final double? initialAntwort;
  final String? initialRechenweg;

  const RechenaufgabenWidget({
    super.key,
    required this.frage,
    required this.punkte,
    this.hinweis,
    this.zeigeRechenweg = true,
    required this.onAnswerChanged,
    this.initialAntwort,
    this.initialRechenweg,
  });

  @override
  State<RechenaufgabenWidget> createState() => _RechenaufgabenWidgetState();
}

class _RechenaufgabenWidgetState extends State<RechenaufgabenWidget> {
  late TextEditingController _antwortController;
  late TextEditingController _rechenwegController;
  
  @override
  void initState() {
    super.initState();
    _antwortController = TextEditingController(
      text: widget.initialAntwort?.toString() ?? '',
    );
    _rechenwegController = TextEditingController(
      text: widget.initialRechenweg ?? '',
    );
    
    // Listener für automatisches Speichern
    _antwortController.addListener(_onChanged);
    _rechenwegController.addListener(_onChanged);
  }

  void _onChanged() {
    final antwortText = _antwortController.text.replaceAll(',', '.');
    final antwort = double.tryParse(antwortText);
    final rechenweg = _rechenwegController.text.isEmpty 
        ? null 
        : _rechenwegController.text;
    
    widget.onAnswerChanged(antwort, rechenweg);
  }

  @override
  void dispose() {
    _antwortController.dispose();
    _rechenwegController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frage-Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.punkte} ${widget.punkte == 1 ? "Punkt" : "Punkte"}',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calculate, color: Colors.blue, size: 20),
                const SizedBox(width: 4),
                const Text(
                  'Rechenaufgabe',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Frage
            Text(
              widget.frage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            
            // Hinweis (optional)
            if (widget.hinweis != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.hinweis!,
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Rechenweg (optional)
            if (widget.zeigeRechenweg) ...[
              Text(
                'Rechenweg:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _rechenwegController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Gib hier deinen Rechenweg ein...\nz.B.: (2000 × 0,05 + 500 × 0,07) × 36 = ...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Courier', // Monospace für Berechnungen
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Ergebnis-Eingabe
            Text(
              'Ergebnis:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _antwortController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0,00',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        suffixText: 'EUR',
                        suffixStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Eingabe-Hinweis
            const SizedBox(height: 8),
            Text(
              'Runde das Ergebnis auf ganze EUR.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Beispiel-Verwendung:
/// 
/// ```dart
/// RechenaufgabenWidget(
///   frage: 'Berechnen Sie die Kosten je Monat mit Angabe des Rechenweges '
///          'unter der Voraussetzung, dass das Multifunktionsgerät '
///          'drei Jahre genutzt wird. Runden Sie das Ergebnis auf ganze EUR.',
///   punkte: 3,
///   hinweis: 'Kosten: Druck 0,05 EUR/Seite S/W, Farbe 0,07 EUR/Seite, '
///           'Nutzungsdauer: 36 Monate',
///   zeigeRechenweg: true,
///   onAnswerChanged: (antwort, rechenweg) {
///     print('Antwort: $antwort');
///     print('Rechenweg: $rechenweg');
///     // Speichere in Datenbank
///   },
/// )
/// ```