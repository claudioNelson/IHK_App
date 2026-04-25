import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

class ErToTablesWidget extends StatefulWidget {
  final String questionText;
  final Map<String, dynamic> correctAnswers;
  final String? explanation;
  final void Function(bool)? onAnswered;

  const ErToTablesWidget({
    super.key,
    required this.questionText,
    required this.correctAnswers,
    this.explanation,
    this.onAnswered,
  });

  @override
  State<ErToTablesWidget> createState() => _ErToTablesWidgetState();
}

class _ErToTablesWidgetState extends State<ErToTablesWidget> {
  final Map<String, List<TextEditingController>> _tableControllers = {};

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
      _tableControllers[tableName] = List.generate(
        columns.length,
        (_) => TextEditingController(),
      );
      fieldResults[tableName] = List.filled(columns.length, false);
    }
  }

  @override
  void dispose() {
    for (var controllers in _tableControllers.values) {
      for (var c in controllers) c.dispose();
    }
    super.dispose();
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

    setState(() => isChecked = true);
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Container(width: 16, height: 1, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                'ER → TABELLEN',
                style: AppTextStyles.monoLabel(AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Frage
          Text(
            widget.questionText,
            style: AppTextStyles.instrumentSerif(
              size: 22,
              color: text,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 16),

          // Hint Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Achte auf Primär- (PK) und Fremdschlüssel (FK)',
                    style: AppTextStyles.bodySmall(AppColors.accent),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tables
          ..._buildTables(surface, border, text, textMid, textDim),

          const SizedBox(height: 20),

          // Buttons
          if (!isChecked) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _checkAnswers,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Prüfen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: text,
                  foregroundColor: bg,
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge(bg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _showSolution,
                icon: Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 14,
                  color: textMid,
                ),
                label: Text(
                  'Lösung zeigen',
                  style: AppTextStyles.mono(
                    size: 11,
                    color: textMid,
                    weight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],

          // Feedback
          if (isChecked) ...[_buildFeedback(surface, text, textMid, bg)],
        ],
      ),
    );
  }

  List<Widget> _buildTables(
    Color surface,
    Color border,
    Color text,
    Color textMid,
    Color textDim,
  ) {
    final tables = widget.correctAnswers['tables'] as Map<String, dynamic>;
    List<Widget> widgets = [];

    for (var tableName in tables.keys) {
      final tableData = tables[tableName] as Map<String, dynamic>;
      final columns = List<String>.from(tableData['columns'] as List);
      final pk = tableData['pk'] as String?;
      final fkList = tableData['fk'] as List?;
      widgets.add(
        _buildTableCard(
          tableName,
          columns,
          pk,
          fkList,
          surface,
          border,
          text,
          textMid,
        ),
      );
      widgets.add(const SizedBox(height: 14));
    }
    return widgets;
  }

  Widget _buildTableCard(
    String tableName,
    List<String> columns,
    String? pk,
    List? fkList,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.accent.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart_rounded,
                  color: AppColors.accent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'TABELLE',
                  style: AppTextStyles.monoLabel(AppColors.accent),
                ),
                const SizedBox(width: 8),
                Text(
                  tableName,
                  style: AppTextStyles.mono(
                    size: 14,
                    color: AppColors.accent,
                    weight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Columns
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < columns.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildColumnField(
                      tableName,
                      i,
                      columns[i],
                      pk,
                      fkList,
                      surface,
                      border,
                      text,
                      textMid,
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
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    if (_tableControllers[tableName] == null ||
        _tableControllers[tableName]!.length <= index) {
      return const SizedBox.shrink();
    }

    final controller = _tableControllers[tableName]![index];
    final isPk = pk != null && pk.contains(correctValue);
    final isFk = (fkList != null && fkList.isNotEmpty)
        ? fkList.any((fk) => fk['column'] == correctValue)
        : false;

    String label = 'SPALTE ${index + 1}';
    Color labelColor = textMid;
    if (isPk && isFk) {
      label += ' · PK + FK';
      labelColor = AppColors.warning;
    } else if (isPk) {
      label += ' · PK';
      labelColor = AppColors.warning;
    } else if (isFk) {
      label += ' · FK';
      labelColor = AppColors.success;
    }

    Color fieldColor = surface;
    Color fieldBorder = border;
    if (isChecked) {
      final ok =
          fieldResults[tableName] != null &&
          index < fieldResults[tableName]!.length &&
          fieldResults[tableName]![index];
      fieldColor = ok
          ? AppColors.success.withOpacity(0.08)
          : AppColors.error.withOpacity(0.08);
      fieldBorder = ok
          ? AppColors.success.withOpacity(0.5)
          : AppColors.error.withOpacity(0.5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.monoSmall(labelColor)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: AppTextStyles.mono(
            size: 14,
            color: text,
            weight: FontWeight.w600,
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            hintText: isPk ? 'id' : (isFk ? 'foreign_id' : 'spaltenname'),
            hintStyle: AppTextStyles.mono(
              size: 13,
              color: textMid.withOpacity(0.5),
              weight: FontWeight.w400,
              letterSpacing: 0,
            ),
            prefixIcon: isPk
                ? Icon(Icons.key_rounded, color: AppColors.warning, size: 16)
                : (isFk
                      ? Icon(
                          Icons.link_rounded,
                          color: AppColors.success,
                          size: 16,
                        )
                      : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(Color surface, Color text, Color textMid, Color bg) {
    final allCorrect = fieldResults.values.every(
      (list) => list.every((v) => v == true),
    );
    final accentColor = allCorrect ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.015, 0.015, 1.0],
          colors: [accentColor, accentColor, surface, surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                allCorrect
                    ? Icons.check_circle_outline_rounded
                    : Icons.lightbulb_outline_rounded,
                color: accentColor,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                allCorrect ? 'ALLES RICHTIG' : 'ERKLÄRUNG',
                style: AppTextStyles.monoLabel(accentColor),
              ),
            ],
          ),
          if (widget.explanation != null) ...[
            const SizedBox(height: 10),
            Text(widget.explanation!, style: AppTextStyles.bodyMedium(textMid)),
          ],
          if (widget.onAnswered != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => widget.onAnswered!(allCorrect),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Weiter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: text,
                  foregroundColor: bg,
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge(bg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
