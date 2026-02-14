import 'package:flutter/material.dart';

class ErToTablesWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final VoidCallback? onAnswered;

  const ErToTablesWidget({
    Key? key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<ErToTablesWidget> createState() => _ErToTablesWidgetState();
}

class _ErToTablesWidgetState extends State<ErToTablesWidget> {
  // Speichert Eingaben: tableName -> columnIndex -> value
  Map<String, List<TextEditingController>> _tableControllers = {};

  bool isChecked = false;
  Map<String, List<bool>> fieldResults = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final tables = widget.correctAnswers['tables'] as Map<String, dynamic>;

    for (var tableName in tables.keys) {
      final tableData = tables[tableName] as Map<String, dynamic>;
      final columns = List<String>.from(tableData['columns'] as List);

      // Controller für jede Spalte
      _tableControllers[tableName] = List.generate(
        columns.length,
        (_) => TextEditingController(),
      );

      // Ergebnis-Array initialisieren
      fieldResults[tableName] = List.filled(columns.length, false);
    }
  }

  @override
  void dispose() {
    for (var controllers in _tableControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fragetext
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                widget.questionText,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 24),

            // Info-Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.purple[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Trage die Spaltennamen ein. Achte auf Primär- (PK) und Fremdschlüssel (FK)!',
                      style: TextStyle(fontSize: 13, color: Colors.purple[900]),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabellen
            ..._buildTables(),

            const SizedBox(height: 24),

            // Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTables() {
    final tables = widget.correctAnswers['tables'] as Map<String, dynamic>;
    List<Widget> widgets = [];

    for (var tableName in tables.keys) {
      final tableData = tables[tableName] as Map<String, dynamic>;
      final columns = List<String>.from(tableData['columns'] as List);
      final pk = tableData['pk'] as String?;
      final fkList = tableData['fk'] as List?;

      widgets.add(_buildTableCard(tableName, columns, pk, fkList));
      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }

  Widget _buildTableCard(
    String tableName,
    List<String> columns,
    String? pk,
    List? fkList,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabellen-Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo[600],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.table_chart, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tabelle: $tableName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Spalten-Eingaben
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < columns.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildColumnField(
                      tableName,
                      i,
                      columns[i],
                      pk,
                      fkList,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnField(
    String tableName,
    int index,
    String correctValue,
    String? pk,
    List? fkList,
  ) {
    // Null-Safe Controller-Zugriff
    if (_tableControllers[tableName] == null ||
        _tableControllers[tableName]!.length <= index) {
      return const SizedBox.shrink();
    }

    final controller = _tableControllers[tableName]![index];
    final isPk = pk != null && pk.contains(correctValue);
    final isFk = (fkList != null && fkList.isNotEmpty)
        ? fkList.any((fk) => fk['column'] == correctValue)
        : false;

    String label = 'Spalte ${index + 1}';
    if (isPk && isFk) {
      label += ' (PK + FK)';
    } else if (isPk) {
      label += ' (PK)';
    } else if (isFk) {
      label += ' (FK)';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isPk
                ? Colors.amber[800]
                : (isFk ? Colors.green[800] : Colors.grey[700]),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText:
                'z.B. ${isPk ? "id" : (isFk ? "foreign_id" : "spaltenname")}',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isChecked
                ? ((fieldResults[tableName] != null &&
                          index < fieldResults[tableName]!.length &&
                          fieldResults[tableName]![index])
                      ? Colors.green[50]
                      : Colors.red[50])
                : Colors.white,
            prefixIcon: isPk
                ? Icon(Icons.key, color: Colors.amber[700], size: 20)
                : (isFk
                      ? Icon(Icons.link, color: Colors.green[700], size: 20)
                      : null),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _checkAnswers,
            icon: const Icon(Icons.check),
            label: const Text('Prüfen'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.indigo,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showSolution,
            icon: const Icon(Icons.lightbulb_outline),
            label: const Text('Lösung'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _checkAnswers() {
    final tables = widget.correctAnswers['tables'] as Map<String, dynamic>;
    bool allCorrect = true;

    for (var tableName in tables.keys) {
      final tableData = tables[tableName] as Map<String, dynamic>;
      final correctColumns = List<String>.from(tableData['columns'] as List);
      final userControllers = _tableControllers[tableName]!;

      for (int i = 0; i < correctColumns.length; i++) {
        final userInput = userControllers[i].text.trim().toLowerCase();
        final correct = correctColumns[i].toLowerCase();
        final isCorrect = userInput == correct;

        fieldResults[tableName]![i] = isCorrect;
        if (!isCorrect) allCorrect = false;
      }
    }

    setState(() {
      isChecked = true;
    });

    if (allCorrect) {
      _showFeedbackDialog(
        title: 'Perfekt! 🎉',
        message: 'Alle Tabellen-Strukturen sind korrekt!',
        isCorrect: true,
      );
    } else {
      _showFeedbackDialog(
        title: 'Nicht ganz richtig',
        message: 'Prüfe die rot markierten Felder nochmal.',
        isCorrect: false,
      );
    }
  }

  void _showSolution() {
    final tables = widget.correctAnswers['tables'] as Map<String, dynamic>;

    setState(() {
      for (var tableName in tables.keys) {
        final tableData = tables[tableName] as Map<String, dynamic>;
        final correctColumns = List<String>.from(tableData['columns'] as List);
        final controllers = _tableControllers[tableName]!;

        for (int i = 0; i < correctColumns.length; i++) {
          controllers[i].text = correctColumns[i];
          fieldResults[tableName]![i] = true;
        }
      }
      isChecked = true;
    });

    if (widget.explanation != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lösung & Erklärung'),
          content: SingleChildScrollView(child: Text(widget.explanation!)),
          actions: [
            if (widget.onAnswered != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onAnswered!();
                },
                child: const Text('Nächste Frage'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showFeedbackDialog({
    required String title,
    required String message,
    required bool isCorrect,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (widget.explanation != null && isCorrect) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Erklärung:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.explanation!),
            ],
          ],
        ),
        actions: [
          if (isCorrect && widget.onAnswered != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onAnswered!();
              },
              child: const Text('Weiter'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isCorrect ? 'OK' : 'Nochmal versuchen'),
          ),
        ],
      ),
    );
  }
}
