// lib/screens/kurse/lektion_screen.dart
//
// Zeigt eine Lektion als SCHRITTE, nicht als eine lange Seite:
// jede Aufgabe bekommt einen eigenen Bildschirm, Erklärtexte werden an den
// Zwischenüberschriften aufgeteilt. Weiter geht es per Knopf oder Wischen.
//
// Der Screen kennt weder Python noch SQL — er rendert nur Blöcke.
// Deshalb funktioniert er für beide Kurse.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/kurs_aufgabe.dart';
import '../../theme/kurs_theme.dart';
import '../../theme/theme_provider.dart';
import '../../widgets/kurs/ada_kurs_sheet.dart';
import '../../widgets/kurs/kurs_aufgaben_widgets.dart';
import '../../widgets/kurs/sql_aufgabe_widget.dart';

class LektionScreen extends StatefulWidget {
  final Lektion lektion;

  /// Kurstitel für den Ada-Kontext, z. B. "SQL von Grund auf".
  final String kursTitel;

  /// IDs bereits gelöster Aufgaben.
  final Set<String> bereitsGeloest;

  /// Wird gerufen, sobald eine Aufgabe richtig gelöst wurde.
  final void Function(String aufgabenId)? onAufgabeGeloest;

  const LektionScreen({
    super.key,
    required this.lektion,
    this.kursTitel = '',
    this.bereitsGeloest = const {},
    this.onAufgabeGeloest,
  });

  @override
  State<LektionScreen> createState() => _LektionScreenState();
}

class _LektionScreenState extends State<LektionScreen> {
  final _seiten = PageController();

  late final List<List<LektionsBlock>> _schritte;
  late Set<String> _geloest;
  int _aktuell = 0;

  @override
  void initState() {
    super.initState();
    _geloest = {...widget.bereitsGeloest};
    _schritte = _aufteilen(widget.lektion);
  }

  @override
  void dispose() {
    _seiten.dispose();
    super.dispose();
  }

  /// Teilt die Lektion in Schritte auf:
  /// - jede Aufgabe wird ein eigener Schritt
  /// - Erklärtexte werden an jeder Zwischenüberschrift getrennt
  ///
  /// Dadurch entstehen kurze, verdauliche Einheiten, ohne dass beim
  /// Schreiben der Inhalte etwas Zusätzliches angegeben werden muss.
  static List<List<LektionsBlock>> _aufteilen(Lektion lektion) {
    final schritte = <List<LektionsBlock>>[];
    var aktuell = <LektionsBlock>[];

    void abschliessen() {
      if (aktuell.isNotEmpty) {
        schritte.add(aktuell);
        aktuell = <LektionsBlock>[];
      }
    }

    for (final block in lektion.bloecke) {
      if (block is AufgabenBlock) {
        abschliessen();
        schritte.add([block]);
      } else if (block is UeberschriftBlock) {
        abschliessen();
        aktuell.add(block);
      } else {
        aktuell.add(block);
      }
    }
    abschliessen();

    return schritte;
  }

  bool _istAufgabe(int index) =>
      _schritte[index].length == 1 && _schritte[index].first is AufgabenBlock;

  KursAufgabe? _aufgabeVon(int index) {
    if (!_istAufgabe(index)) return null;
    return (_schritte[index].first as AufgabenBlock).aufgabe;
  }

  void _melden(String id, bool richtig) {
    if (!richtig || _geloest.contains(id)) return;
    setState(() => _geloest.add(id));
    widget.onAufgabeGeloest?.call(id);
  }

  void _weiter() {
    if (_aktuell < _schritte.length) {
      _seiten.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _zurueck() {
    if (_aktuell > 0) {
      _seiten.previousPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return Theme(
      data: kursTheme(isDark),
      child: Builder(builder: _aufbau),
    );
  }

  Widget _aufbau(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    // Ein Schritt mehr als Inhalte: der letzte ist die Abschlussseite.
    final gesamtSeiten = _schritte.length + 1;
    final istAbschluss = _aktuell >= _schritte.length;

    final aufgaben = widget.lektion.aufgaben.length;
    final fertig =
        widget.lektion.aufgaben.where((a) => _geloest.contains(a.id)).length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LEKTION ${widget.lektion.nr}',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.6,
                color: farben.onSurfaceVariant,
              ),
            ),
            Text(
              widget.lektion.titel,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          // Ada ist auf jeder Seite erreichbar. Steht der Nutzer gerade
          // auf einer Aufgabe, bekommt sie deren Text als Kontext mit,
          // darf aber laut Prompt die Loesung nicht verraten.
          IconButton(
            tooltip: 'Ada fragen',
            onPressed: () => zeigeAdaKursSheet(
              context,
              kursTitel: widget.kursTitel.isEmpty
                  ? 'Kurs'
                  : widget.kursTitel,
              lektionsTitel:
                  'Lektion ${widget.lektion.nr}: ${widget.lektion.titel}',
              aufgabenText: istAbschluss ? null : _aufgabeVon(_aktuell)?.frage,
            ),
            icon: Icon(Icons.school_outlined, color: farben.primary),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                istAbschluss
                    ? 'fertig'
                    : '${_aktuell + 1} / ${_schritte.length}',
                style: TextStyle(
                  fontSize: 13,
                  color: farben.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_aktuell + 1) / gesamtSeiten,
            minHeight: 4,
            backgroundColor: farben.surfaceContainerHighest,
          ),
        ),
      ),

      body: PageView.builder(
        controller: _seiten,
        itemCount: gesamtSeiten,
        onPageChanged: (i) => setState(() => _aktuell = i),
        itemBuilder: (context, index) {
          if (index >= _schritte.length) {
            return _AbschlussSeite(
              lektion: widget.lektion,
              geloest: fertig,
              gesamt: aufgaben,
              onZurueckZurUebersicht: () => Navigator.of(context).pop(true),
              onWiederholen: () {
                _seiten.jumpToPage(0);
                setState(() => _aktuell = 0);
              },
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final block in _schritte[index])
                  _BlockAnsicht(block: block, onErgebnis: _melden),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: istAbschluss
          ? null
          : _Fussleiste(
              kannZurueck: _aktuell > 0,
              istAufgabe: _istAufgabe(_aktuell),
              geloest: () {
                final a = _aufgabeVon(_aktuell);
                return a != null && _geloest.contains(a.id);
              }(),
              letzterSchritt: _aktuell == _schritte.length - 1,
              onZurueck: _zurueck,
              onWeiter: _weiter,
            ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────

class _Fussleiste extends StatelessWidget {
  final bool kannZurueck;
  final bool istAufgabe;
  final bool geloest;
  final bool letzterSchritt;
  final VoidCallback onZurueck;
  final VoidCallback onWeiter;

  const _Fussleiste({
    required this.kannZurueck,
    required this.istAufgabe,
    required this.geloest,
    required this.letzterSchritt,
    required this.onZurueck,
    required this.onWeiter,
  });

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    // Bei ungelösten Aufgaben heißt der Knopf "Überspringen" statt "Weiter" —
    // ehrlicher, und es hält niemanden fest, der gerade nicht weiterkommt.
    final beschriftung = letzterSchritt
        ? 'Abschließen'
        : (istAufgabe && !geloest ? 'Überspringen' : 'Weiter');

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: farben.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Row(
          children: [
            if (kannZurueck)
              IconButton(
                onPressed: onZurueck,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Zurück',
              )
            else
              const SizedBox(width: 48),
            const SizedBox(width: 8),
            Expanded(
              child: istAufgabe && !geloest
                  ? OutlinedButton(
                      onPressed: onWeiter,
                      child: Text(beschriftung),
                    )
                  : FilledButton(
                      onPressed: onWeiter,
                      child: Text(beschriftung),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbschlussSeite extends StatelessWidget {
  final Lektion lektion;
  final int geloest;
  final int gesamt;
  final VoidCallback onZurueckZurUebersicht;
  final VoidCallback onWiederholen;

  const _AbschlussSeite({
    required this.lektion,
    required this.geloest,
    required this.gesamt,
    required this.onZurueckZurUebersicht,
    required this.onWiederholen,
  });

  @override
  Widget build(BuildContext context) {
    final alles = gesamt > 0 && geloest >= gesamt;
    final farbe =
        alles ? const Color(0xFF5FD98A) : Theme.of(context).colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(alles ? Icons.emoji_events : Icons.flag_outlined,
                size: 56, color: farbe),
            const SizedBox(height: 18),
            Text(
              alles
                  ? 'Lektion ${lektion.nr} geschafft'
                  : 'Lektion ${lektion.nr} durchgearbeitet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$geloest von $gesamt Aufgaben gelöst',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (!alles) ...[
              const SizedBox(height: 14),
              Text(
                'Die offenen Aufgaben kannst du jederzeit nachholen, '
                'dein Fortschritt bleibt erhalten.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onZurueckZurUebersicht,
                child: const Text('Zurück zur Übersicht'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onWiederholen,
              child: const Text('Lektion nochmal durchgehen'),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Darstellung der einzelnen Blocktypen
// ───────────────────────────────────────────────────────────────────────────

class _BlockAnsicht extends StatelessWidget {
  final LektionsBlock block;
  final void Function(String id, bool richtig) onErgebnis;

  const _BlockAnsicht({required this.block, required this.onErgebnis});

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      UeberschriftBlock b => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            b.text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      TextBlock b => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _MiniMarkdown(text: b.text),
        ),
      CodeBlock b => _CodeAnsicht(block: b),
      HinweisBlock b => _HinweisAnsicht(text: b.text),
      AufgabenBlock b => switch (b.aufgabe) {
          SqlAufgabe a => SqlAufgabeWidget(
              aufgabe: a,
              onErgebnis: (richtig) => onErgebnis(a.id, richtig),
            ),
          final andere => KursAufgabeWidget(
              aufgabe: andere,
              onErgebnis: (richtig) => onErgebnis(andere.id, richtig),
            ),
        },
    };
  }
}

/// Sehr kleiner Markdown-Ersatz: **fett**, `code` und Listen mit "- ".
class _MiniMarkdown extends StatelessWidget {
  final String text;
  const _MiniMarkdown({required this.text});

  List<InlineSpan> _zerlegen(BuildContext context, String zeile) {
    final spans = <InlineSpan>[];
    final muster = RegExp(r'\*\*(.+?)\*\*|`(.+?)`');
    var position = 0;

    for (final treffer in muster.allMatches(zeile)) {
      if (treffer.start > position) {
        spans.add(TextSpan(text: zeile.substring(position, treffer.start)));
      }

      if (treffer.group(1) != null) {
        spans.add(TextSpan(
          text: treffer.group(1),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ));
      } else {
        spans.add(TextSpan(
          text: treffer.group(2),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            backgroundColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.7),
          ),
        ));
      }
      position = treffer.end;
    }

    if (position < zeile.length) {
      spans.add(TextSpan(text: zeile.substring(position)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final basis =
        Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.55);
    final zeilen = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final zeile in zeilen)
          if (zeile.trimLeft().startsWith('- '))
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: basis),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: basis,
                        children:
                            _zerlegen(context, zeile.trimLeft().substring(2)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (zeile.trim().isEmpty)
            const SizedBox(height: 10)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: RichText(
                text: TextSpan(
                  style: basis,
                  children: _zerlegen(context, zeile),
                ),
              ),
            ),
      ],
    );
  }
}

class _CodeAnsicht extends StatelessWidget {
  final CodeBlock block;
  const _CodeAnsicht({required this.block});

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.titel != null)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: farben.primary.withValues(alpha: 0.12),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Text(
                block.titel!,
                style: TextStyle(
                  fontSize: 11.5,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                  color: farben.primary,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                block.code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.6,
                  color: Color(0xFFE6EDF3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HinweisAnsicht extends StatelessWidget {
  final String text;
  const _HinweisAnsicht({required this.text});

  @override
  Widget build(BuildContext context) {
    const gelb = Color(0xFFFFC857);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: gelb.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: gelb, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, size: 18, color: gelb),
          const SizedBox(width: 10),
          Expanded(child: _MiniMarkdown(text: text)),
        ],
      ),
    );
  }
}
