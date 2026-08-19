// lib/widgets/kurs/sql_aufgabe_widget.dart
//
// Die Herzstück-Aufgabe des SQL-Kurses: der Nutzer schreibt eine echte
// Abfrage, sie läuft gegen SQLite auf dem Gerät, und geprüft wird das
// ERGEBNIS gegen die Musterlösung — nicht der Wortlaut.
//
// Dadurch zählt jede korrekte Lösung. Wer WHERE ort = 'Köln' schreibt und
// wer WHERE ort LIKE 'Köln' schreibt, bekommen beide ihren Haken.

import 'package:flutter/material.dart';

import '../../data/kurse/sql_datensaetze.dart';
import '../../models/kurs_aufgabe.dart';
import '../../services/sql_sandbox.dart';

class SqlAufgabeWidget extends StatefulWidget {
  final SqlAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const SqlAufgabeWidget({
    super.key,
    required this.aufgabe,
    required this.onErgebnis,
  });

  @override
  State<SqlAufgabeWidget> createState() => _SqlAufgabeWidgetState();
}

class _SqlAufgabeWidgetState extends State<SqlAufgabeWidget> {
  late final TextEditingController _editor;

  /// Angetippte Bausteine, in der Reihenfolge der Auswahl.
  final List<String> _gewaehlt = [];

  /// Hat der Nutzer auf Tastatur umgeschaltet?
  bool _tastatur = false;

  SqlErgebnis? _ergebnis;
  bool? _richtig;
  int _versuche = 0;

  bool get _bausteinModus => widget.aufgabe.bausteinModus && !_tastatur;

  @override
  void initState() {
    super.initState();
    _editor = TextEditingController(text: widget.aufgabe.startCode);
  }

  @override
  void dispose() {
    _editor.dispose();
    super.dispose();
  }

  /// Bausteine zu einer Abfrage zusammensetzen.
  /// Vor Satzzeichen kommt kein Leerzeichen — sonst liest sich das
  /// Ergebnis wie von einem Roboter geschrieben.
  String get _abfrage {
    if (!_bausteinModus) return _editor.text;

    final puffer = StringBuffer();
    for (final baustein in _gewaehlt) {
      final satzzeichen = baustein == ';' || baustein == ',' || baustein == ')';
      if (puffer.isNotEmpty && !satzzeichen) puffer.write(' ');
      puffer.write(baustein);
    }
    return puffer.toString();
  }

  void _ausfuehren() {
    final a = widget.aufgabe;
    final meins = SqlSandbox.ausfuehren(a.datensatz, _abfrage);

    // Läuft die Abfrage nicht, gibt es noch nichts zu vergleichen —
    // dann zeigen wir nur den Fehler und lassen es weiter versuchen.
    if (meins.istFehler) {
      setState(() {
        _ergebnis = meins;
        _richtig = null;
        _versuche++;
      });
      return;
    }

    final soll = SqlSandbox.ausfuehren(a.datensatz, a.musterloesung);
    final passt =
        meins.gleichWie(soll, reihenfolgeZaehlt: a.reihenfolgeZaehlt);

    setState(() {
      _ergebnis = meins;
      _richtig = passt;
      _versuche++;
    });

    if (passt) widget.onErgebnis(true);
  }

  void _tabellenZeigen() {
    final datensatz = sqlDatensaetze[widget.aufgabe.datensatz];
    if (datensatz == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            Text(datensatz.titel,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(datensatz.beschreibung,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            for (final eintrag in datensatz.tabellen.entries) ...[
              Text(
                eintrag.key,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: eintrag.value
                    .map((spalte) => Chip(
                          label: Text(spalte,
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    final randFarbe = switch (_richtig) {
      true => const Color(0xFF5FD98A),
      false => const Color(0xFFFF6B63),
      null => farben.outlineVariant,
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: farben.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: randFarbe, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storage, size: 18, color: farben.primary),
              const SizedBox(width: 6),
              Text(
                'SQL-AUFGABE',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: farben.primary,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _tabellenZeigen,
                icon: const Icon(Icons.table_chart_outlined, size: 16),
                label: const Text('Tabellen'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.aufgabe.frage,
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 14),

          // ─── Eingabe: Bausteine oder Tastatur ─────────────────────
          if (_bausteinModus)
            _BausteinEingabe(
              gewaehlt: _gewaehlt,
              vorrat: widget.aufgabe.bausteine,
              abfrage: _abfrage,
              onHinzufuegen: (b) => setState(() => _gewaehlt.add(b)),
              onEntfernen: (i) => setState(() => _gewaehlt.removeAt(i)),
              onZuruecksetzen: () => setState(_gewaehlt.clear),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: farben.outlineVariant.withValues(alpha: 0.4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _editor,
                maxLines: null,
                minLines: 3,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13.5,
                  height: 1.5,
                  color: Color(0xFFE6EDF3),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'SELECT ...',
                  hintStyle: TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF6E7681),
                  ),
                ),
              ),
            ),

          // Umschalter — nur wenn es überhaupt Bausteine gibt.
          if (widget.aufgabe.bausteinModus && widget.aufgabe.tastaturErlaubt)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  _tastatur = !_tastatur;
                  if (_tastatur && _editor.text.trim().isEmpty) {
                    // Bereits Angetipptes übernehmen, damit nichts verloren geht.
                    _editor.text = _abfrage;
                  }
                }),
                icon: Icon(
                  _tastatur ? Icons.widgets_outlined : Icons.keyboard_alt_outlined,
                  size: 16,
                ),
                label: Text(_tastatur ? 'Bausteine' : 'Selbst tippen'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12.5),
                ),
              ),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _ausfuehren,
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text('Ausführen'),
                ),
              ),
              if (widget.aufgabe.tipp != null && _versuche >= 2) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Tipp',
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Tipp'),
                      content: Text(widget.aufgabe.tipp!),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Verstanden'),
                        ),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.lightbulb_outline),
                ),
              ],
            ],
          ),

          if (_ergebnis != null) ...[
            const SizedBox(height: 16),
            _ErgebnisBereich(
              ergebnis: _ergebnis!,
              richtig: _richtig,
              erklaerung: widget.aufgabe.erklaerung,
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Bausteine antippen statt tippen
// ───────────────────────────────────────────────────────────────────────────

class _BausteinEingabe extends StatelessWidget {
  final List<String> gewaehlt;
  final List<String> vorrat;
  final String abfrage;
  final ValueChanged<String> onHinzufuegen;
  final ValueChanged<int> onEntfernen;
  final VoidCallback onZuruecksetzen;

  const _BausteinEingabe({
    required this.gewaehlt,
    required this.vorrat,
    required this.abfrage,
    required this.onHinzufuegen,
    required this.onEntfernen,
    required this.onZuruecksetzen,
  });

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Zusammengebaute Abfrage ───────────────────────────────
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: farben.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: gewaehlt.isEmpty
              ? const Text(
                  'Tipp unten die Bausteine an',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: Color(0xFF6E7681),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var i = 0; i < gewaehlt.length; i++)
                      // Antippen entfernt den Baustein wieder — kein
                      // separater Löschmodus nötig.
                      InkWell(
                        onTap: () => onEntfernen(i),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: farben.primary.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: farben.primary.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Text(
                            gewaehlt[i],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              color: Color(0xFFE6EDF3),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),

        // ─── Vorschau + Zurücksetzen ───────────────────────────────
        if (gewaehlt.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    abfrage,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11.5,
                      color: farben.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: onZuruecksetzen,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Leeren'),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // ─── Vorrat ────────────────────────────────────────────────
        Text(
          'BAUSTEINE',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            color: farben.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: vorrat
              .map((baustein) => InkWell(
                    onTap: () => onHinzufuegen(baustein),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 9),
                      decoration: BoxDecoration(
                        color: farben.surfaceContainerHighest
                            .withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              farben.outlineVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        baustein,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────

class _ErgebnisBereich extends StatelessWidget {
  final SqlErgebnis ergebnis;
  final bool? richtig;
  final String? erklaerung;

  const _ErgebnisBereich({
    required this.ergebnis,
    required this.richtig,
    this.erklaerung,
  });

  @override
  Widget build(BuildContext context) {
    if (ergebnis.istFehler) {
      return _Meldung(
        farbe: const Color(0xFFFF6B63),
        symbol: Icons.error_outline,
        titel: 'Die Abfrage läuft noch nicht',
        text: ergebnis.fehler!,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (richtig != null)
          _Meldung(
            farbe: richtig!
                ? const Color(0xFF5FD98A)
                : const Color(0xFFFFA657),
            symbol: richtig! ? Icons.check_circle : Icons.info_outline,
            titel: richtig!
                ? 'Richtig'
                : 'Läuft, aber das ist nicht das gesuchte Ergebnis',
            text: richtig!
                ? (erklaerung ?? '')
                : 'Die Abfrage funktioniert, liefert aber andere Zeilen '
                    'als gesucht. Vergleich die Ausgabe unten mit der '
                    'Aufgabenstellung.',
          ),
        const SizedBox(height: 12),
        Text(
          ergebnis.istLeer
              ? 'Ergebnis: keine Zeilen'
              : 'Ergebnis: ${ergebnis.zeilen.length} '
                  '${ergebnis.zeilen.length == 1 ? "Zeile" : "Zeilen"}'
                  '${ergebnis.gekuerzt ? " (gekürzt)" : ""}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        if (!ergebnis.istLeer) _Ergebnistabelle(ergebnis: ergebnis),
      ],
    );
  }
}

class _Ergebnistabelle extends StatelessWidget {
  final SqlErgebnis ergebnis;
  const _Ergebnistabelle({required this.ergebnis});

  String _zelle(Object? wert) {
    if (wert == null) return 'NULL';
    if (wert is double && wert == wert.roundToDouble()) {
      return wert.toInt().toString();
    }
    return wert.toString();
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(maxHeight: 320),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowHeight: 38,
            dataRowMinHeight: 34,
            dataRowMaxHeight: 44,
            horizontalMargin: 12,
            columnSpacing: 22,
            headingRowColor: WidgetStatePropertyAll(
              farben.primary.withValues(alpha: 0.12),
            ),
            columns: ergebnis.spalten
                .map((s) => DataColumn(
                      label: Text(
                        s,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: farben.primary,
                        ),
                      ),
                    ))
                .toList(),
            rows: ergebnis.zeilen
                .map((zeile) => DataRow(
                      cells: zeile
                          .map((wert) => DataCell(
                                Text(
                                  _zelle(wert),
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12.5,
                                    color: wert == null
                                        ? const Color(0xFF6E7681)
                                        : const Color(0xFFE6EDF3),
                                    fontStyle: wert == null
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Meldung extends StatelessWidget {
  final Color farbe;
  final IconData symbol;
  final String titel;
  final String text;

  const _Meldung({
    required this.farbe,
    required this.symbol,
    required this.titel,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: farbe.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: farbe, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(symbol, size: 18, color: farbe),
              const SizedBox(width: 8),
              Expanded(
                child: Text(titel,
                    style: TextStyle(
                        color: farbe, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
