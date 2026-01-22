import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeEditorWidget extends StatefulWidget {
  final String questionId;
  final String? initialCode;
  final Function(String code) onCodeChanged;
  final String hintText;
  final bool isSql;

  const CodeEditorWidget({
    super.key,
    required this.questionId,
    required this.onCodeChanged,
    this.initialCode,
    this.hintText = 'Code eingeben...',
    this.isSql = false,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _controller;
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode ?? '');
    _updateLineCount();
    _controller.addListener(_updateLineCount);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateLineCount() {
    final lines = _controller.text.split('\n').length;
    if (lines != _lineCount) {
      setState(() => _lineCount = lines);
    }
  }

  void _insertTab() {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '  ', // 2 Leerzeichen
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + 2),
    );
    widget.onCodeChanged(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E), // VS Code Dark
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF2D2D30),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSql ? Icons.storage : Icons.code,
                  size: 16,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isSql ? 'SQL' : 'Code',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _insertTab,
                  icon: const Icon(Icons.keyboard_tab, size: 18),
                  color: Colors.white70,
                  tooltip: 'Tab einfügen',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onCodeChanged('');
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  color: Colors.white70,
                  tooltip: 'Löschen',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // Editor
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zeilennummern
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF252526),
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade800),
                  ),
                ),
                child: Column(
                  children: List.generate(
                    _lineCount,
                    (i) => Container(
                      height: 20,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Code Input
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  minLines: 12,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: widget.onCodeChanged,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ],
          ),
          // Footer mit Tipps
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF2D2D30),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 14,
                  color: Colors.amber.shade300,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.isSql
                        ? 'Tipp: Nutze SELECT, FROM, WHERE, JOIN, GROUP BY'
                        : 'Tipp: Nutze Tab für Einrückung',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
                ),
                Text(
                  '$_lineCount Zeilen',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
