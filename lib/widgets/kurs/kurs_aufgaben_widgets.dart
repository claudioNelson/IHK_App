// lib/widgets/kurs/kurs_aufgaben_widgets.dart
//
// Die interaktiven Aufgabentypen für Python- und SQL-Kurs.
// Jedes Widget meldet über [onErgebnis], ob richtig gelöst wurde —
// den Fortschritt speichert die aufrufende Seite, nicht das Widget.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/kurs_aufgabe.dart';
import '../../services/sound_service.dart';

/// Einstiegspunkt: wählt anhand des Typs das passende Widget.
class KursAufgabeWidget extends StatelessWidget {
  final KursAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const KursAufgabeWidget({
    super.key,
    required this.aufgabe,
    required this.onErgebnis,
  });

  @override
  Widget build(BuildContext context) {
    return switch (aufgabe) {
      LueckenAufgabe a =>
        _LueckenWidget(aufgabe: a, onErgebnis: onErgebnis),
      ReihenfolgeAufgabe a =>
        _ReihenfolgeWidget(aufgabe: a, onErgebnis: onErgebnis),
      FehlerAufgabe a =>
        _FehlerWidget(aufgabe: a, onErgebnis: onErgebnis),
      AuswahlAufgabe a =>
        _AuswahlWidget(aufgabe: a, onErgebnis: onErgebnis),
      // SQL-Aufgaben brauchen die Datenbank und liegen deshalb in
      // einer eigenen Datei (sql_aufgabe_widget.dart).
      SqlAufgabe _ => const SizedBox.shrink(),
    };
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Gemeinsame Hülle: Rahmen, Prüfen-Knopf, Rückmeldung
// ───────────────────────────────────────────────────────────────────────────

enum _Stand { offen, richtig, falsch }

/// Spielt den Richtig-/Falsch-Sound der App (SoundService, respektiert
/// die Sound-Einstellung des Nutzers).
void _ergebnisSound(bool richtig) {
  SoundService().playSound(richtig ? SoundType.correct : SoundType.wrong);
}

class _AufgabenKarte extends StatelessWidget {
  final String frage;
  final String? erklaerung;
  final Widget inhalt;
  final _Stand stand;
  final VoidCallback? onPruefen;
  final VoidCallback? onNochmal;
  final String? tipp;

  const _AufgabenKarte({
    required this.frage,
    required this.inhalt,
    required this.stand,
    this.erklaerung,
    this.onPruefen,
    this.onNochmal,
    this.tipp,
  });

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;

    final randFarbe = switch (stand) {
      _Stand.richtig => const Color(0xFF5FD98A),
      _Stand.falsch => const Color(0xFFFF6B63),
      _Stand.offen => farben.outlineVariant,
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
              Icon(Icons.edit_note, size: 18, color: farben.primary),
              const SizedBox(width: 6),
              Text(
                'AUFGABE',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: farben.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(frage, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 14),
          inhalt,

          if (tipp != null && stand != _Stand.richtig) ...[
            const SizedBox(height: 8),
            Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              // Material dazwischen, weil das ExpansionTile sonst in der
              // dekorierten Karte haengt und Flutter vor unsichtbaren
              // Ink-Effekten warnt (Konsolen-Spam bei jedem Frame).
              child: Material(
                type: MaterialType.transparency,
                child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Text(
                  'Tipp anzeigen',
                  style: TextStyle(fontSize: 13, color: farben.primary),
                ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(tipp!,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          if (stand == _Stand.offen)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onPruefen,
                child: const Text('Prüfen'),
              ),
            )
          else
            _Rueckmeldung(
              stand: stand,
              erklaerung: erklaerung,
              onNochmal: onNochmal,
            ),
        ],
      ),
    );
  }
}

class _Rueckmeldung extends StatelessWidget {
  final _Stand stand;
  final String? erklaerung;
  final VoidCallback? onNochmal;

  const _Rueckmeldung({
    required this.stand,
    this.erklaerung,
    this.onNochmal,
  });

  @override
  Widget build(BuildContext context) {
    final richtig = stand == _Stand.richtig;
    final farbe =
        richtig ? const Color(0xFF5FD98A) : const Color(0xFFFF6B63);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(richtig ? Icons.check_circle : Icons.cancel,
                color: farbe, size: 20),
            const SizedBox(width: 8),
            Text(
              richtig ? 'Richtig' : 'Noch nicht ganz',
              style: TextStyle(color: farbe, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        // Die Erklärung enthält die Auflösung. Bei falscher Antwort würde
        // sie die Lösung verraten (dann könnte man einfach nochmal tippen),
        // deshalb erscheint sie erst nach der richtigen Antwort.
        if (erklaerung != null && richtig) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: farbe.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border(left: BorderSide(color: farbe, width: 3)),
            ),
            child: Text(erklaerung!,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
        if (!richtig) ...[
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onNochmal,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Nochmal versuchen'),
          ),
        ],
      ],
    );
  }
}

/// Einheitlicher Codeblock in Monospace.
class _CodeFlaeche extends StatelessWidget {
  final Widget child;
  const _CodeFlaeche({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

const _monoStil = TextStyle(
  fontFamily: 'monospace',
  fontSize: 13.5,
  height: 1.6,
  color: Color(0xFFE6EDF3),
);

// ───────────────────────────────────────────────────────────────────────────
// 1. Lückentext
// ───────────────────────────────────────────────────────────────────────────

class _LueckenWidget extends StatefulWidget {
  final LueckenAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const _LueckenWidget({required this.aufgabe, required this.onErgebnis});

  @override
  State<_LueckenWidget> createState() => _LueckenWidgetState();
}

class _LueckenWidgetState extends State<_LueckenWidget> {
  late List<TextEditingController> _felder;
  late List<String?> _gewaehlt; // bei Baustein-Modus
  _Stand _stand = _Stand.offen;

  bool get _bausteinModus => widget.aufgabe.bausteine.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final n = widget.aufgabe.anzahlLuecken;
    _felder = List.generate(n, (_) => TextEditingController());
    _gewaehlt = List.filled(n, null);
  }

  @override
  void dispose() {
    for (final c in _felder) {
      c.dispose();
    }
    super.dispose();
  }

  void _pruefen() {
    final a = widget.aufgabe;
    var allesRichtig = true;

    for (var i = 0; i < a.loesungen.length; i++) {
      final eingabe =
          (_bausteinModus ? _gewaehlt[i] ?? '' : _felder[i].text).trim();

      final passt = a.loesungen[i].any((richtig) {
        return a.beachteGrossschreibung
            ? richtig.trim() == eingabe
            : richtig.trim().toLowerCase() == eingabe.toLowerCase();
      });

      if (!passt) {
        allesRichtig = false;
        break;
      }
    }

    setState(() => _stand = allesRichtig ? _Stand.richtig : _Stand.falsch);
    _ergebnisSound(allesRichtig);
    widget.onErgebnis(allesRichtig);
  }

  void _zuruecksetzen() {
    setState(() {
      for (final c in _felder) {
        c.clear();
      }
      _gewaehlt = List.filled(_gewaehlt.length, null);
      _stand = _Stand.offen;
    });
  }

  /// Vorlage anzeigen, Lücken als ⟨1⟩ ⟨2⟩ nummeriert.
  Widget _vorlageAnzeigen() {
    final teile = widget.aufgabe.vorlage.split('___');
    final spans = <InlineSpan>[];

    for (var i = 0; i < teile.length; i++) {
      spans.add(TextSpan(text: teile[i]));
      if (i < teile.length - 1) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      }
    }

    return _CodeFlaeche(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RichText(
          text: TextSpan(style: _monoStil, children: spans),
        ),
      ),
    );
  }

  Widget _eingabeFuer(int i) {
    final gesperrt = _stand != _Stand.offen;

    if (_bausteinModus) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.aufgabe.bausteine.map((baustein) {
          final aktiv = _gewaehlt[i] == baustein;
          return ChoiceChip(
            label: Text(baustein,
                style: const TextStyle(fontFamily: 'monospace')),
            selected: aktiv,
            onSelected: gesperrt
                ? null
                : (_) => setState(
                    () => _gewaehlt[i] = aktiv ? null : baustein),
          );
        }).toList(),
      );
    }

    return TextField(
      controller: _felder[i],
      enabled: !gesperrt,
      style: const TextStyle(fontFamily: 'monospace'),
      textInputAction: TextInputAction.next,
      inputFormatters: [LengthLimitingTextInputFormatter(60)],
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Lücke ${i + 1}',
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AufgabenKarte(
      frage: widget.aufgabe.frage,
      erklaerung: _stand == _Stand.offen ? null : widget.aufgabe.erklaerung,
      stand: _stand,
      onPruefen: _pruefen,
      onNochmal: _zuruecksetzen,
      inhalt: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _vorlageAnzeigen(),
          const SizedBox(height: 14),
          for (var i = 0; i < widget.aufgabe.anzahlLuecken; i++) ...[
            if (_bausteinModus)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('Lücke ${i + 1}',
                    style: Theme.of(context).textTheme.labelMedium),
              ),
            _eingabeFuer(i),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// 2. Reihenfolge (Drag & Drop)
// ───────────────────────────────────────────────────────────────────────────

class _ReihenfolgeWidget extends StatefulWidget {
  final ReihenfolgeAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const _ReihenfolgeWidget({
    required this.aufgabe,
    required this.onErgebnis,
  });

  @override
  State<_ReihenfolgeWidget> createState() => _ReihenfolgeWidgetState();
}

class _ReihenfolgeWidgetState extends State<_ReihenfolgeWidget> {
  /// Aktuelle Anordnung als Indizes in aufgabe.zeilen.
  late List<int> _anordnung;
  _Stand _stand = _Stand.offen;

  @override
  void initState() {
    super.initState();
    _mischen();
  }

  void _mischen() {
    final n = widget.aufgabe.zeilen.length;
    final zufall = Random();
    List<int> kandidat;

    // Neu mischen, falls die Zufallsreihenfolge zufällig die Lösung ist.
    var versuche = 0;
    do {
      kandidat = List.generate(n, (i) => i)..shuffle(zufall);
      versuche++;
    } while (versuche < 10 &&
        n > 1 &&
        List.generate(n, (i) => i).toString() == kandidat.toString());

    _anordnung = kandidat;
  }

  void _pruefen() {
    final richtig = _anordnung
        .asMap()
        .entries
        .every((e) => e.key == e.value);

    setState(() => _stand = richtig ? _Stand.richtig : _Stand.falsch);
    _ergebnisSound(richtig);
    widget.onErgebnis(richtig);
  }

  void _zuruecksetzen() {
    setState(() {
      _mischen();
      _stand = _Stand.offen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;
    final gesperrt = _stand != _Stand.offen;

    return _AufgabenKarte(
      frage: widget.aufgabe.frage,
      erklaerung: _stand == _Stand.offen ? null : widget.aufgabe.erklaerung,
      stand: _stand,
      onPruefen: _pruefen,
      onNochmal: _zuruecksetzen,
      inhalt: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zeilen in die richtige Reihenfolge ziehen',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: farben.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: _anordnung.length,
              onReorder: gesperrt
                  ? (_, __) {}
                  : (alt, neu) {
                      setState(() {
                        if (neu > alt) neu -= 1;
                        final wert = _anordnung.removeAt(alt);
                        _anordnung.insert(neu, wert);
                      });
                    },
              itemBuilder: (context, position) {
                final zeilenIndex = _anordnung[position];
                final tiefe = widget.aufgabe.tiefe(zeilenIndex);

                return ReorderableDragStartListener(
                  key: ValueKey(zeilenIndex),
                  index: position,
                  enabled: !gesperrt,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    padding: EdgeInsets.only(
                      left: 10 + tiefe * 22.0,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: farben.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.drag_indicator,
                            size: 18,
                            color: farben.onSurfaceVariant
                                .withValues(alpha: 0.6)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.aufgabe.zeilen[zeilenIndex],
                            style: _monoStil,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// 3. Fehler finden und korrigieren
// ───────────────────────────────────────────────────────────────────────────

class _FehlerWidget extends StatefulWidget {
  final FehlerAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const _FehlerWidget({required this.aufgabe, required this.onErgebnis});

  @override
  State<_FehlerWidget> createState() => _FehlerWidgetState();
}

class _FehlerWidgetState extends State<_FehlerWidget> {
  int? _markiert;
  final _korrektur = TextEditingController();
  _Stand _stand = _Stand.offen;

  @override
  void dispose() {
    _korrektur.dispose();
    super.dispose();
  }

  void _pruefen() {
    final zeileStimmt = _markiert == widget.aufgabe.fehlerZeile;

    // Vergleich ohne Rücksicht auf Leerzeichen — Einrückung wird hier
    // nicht bewertet, sonst scheitern Lösungen an einem Leerzeichen.
    String normiert(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
    final eingabe = normiert(_korrektur.text);

    final textStimmt = widget.aufgabe.korrekturen
        .any((k) => normiert(k) == eingabe);

    final richtig = zeileStimmt && textStimmt;
    setState(() => _stand = richtig ? _Stand.richtig : _Stand.falsch);
    _ergebnisSound(richtig);
    widget.onErgebnis(richtig);
  }

  void _zuruecksetzen() {
    setState(() {
      _markiert = null;
      _korrektur.clear();
      _stand = _Stand.offen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;
    final gesperrt = _stand != _Stand.offen;

    return _AufgabenKarte(
      frage: widget.aufgabe.frage,
      erklaerung: _stand == _Stand.offen ? null : widget.aufgabe.erklaerung,
      stand: _stand,
      tipp: widget.aufgabe.tipp,
      onPruefen: (_markiert == null || _korrektur.text.trim().isEmpty)
          ? null
          : _pruefen,
      onNochmal: _zuruecksetzen,
      inhalt: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tippe die fehlerhafte Zeile an',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: farben.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          _CodeFlaeche(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < widget.aufgabe.zeilen.length; i++)
                  InkWell(
                    onTap: gesperrt
                        ? null
                        : () => setState(() {
                              _markiert = i;
                              // Zeile vorausfuellen: korrigieren statt
                              // komplett neu tippen. Auf dem Handy macht
                              // das den Unterschied.
                              _korrektur.value = TextEditingValue(
                                text: widget.aufgabe.zeilen[i],
                                selection: TextSelection.collapsed(
                                  offset: widget.aufgabe.zeilen[i].length,
                                ),
                              );
                            }),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 6),
                      decoration: BoxDecoration(
                        color: _markiert == i
                            ? farben.primary.withValues(alpha: 0.22)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                        border: Border(
                          left: BorderSide(
                            color: _markiert == i
                                ? farben.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 26,
                            child: Text(
                              '${i + 1}',
                              style: _monoStil.copyWith(
                                color: const Color(0xFF6E7681),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(widget.aufgabe.zeilen[i],
                                style: _monoStil),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_markiert != null) ...[
            const SizedBox(height: 14),
            Text('Korrigiere Zeile ${_markiert! + 1} direkt im Feld:',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            TextField(
              controller: _korrektur,
              enabled: !gesperrt,
              style: const TextStyle(fontFamily: 'monospace'),
              maxLines: null,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                hintText: 'korrigierte Zeile',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// 4. Auswahlfrage
// ───────────────────────────────────────────────────────────────────────────

class _AuswahlWidget extends StatefulWidget {
  final AuswahlAufgabe aufgabe;
  final ValueChanged<bool> onErgebnis;

  const _AuswahlWidget({required this.aufgabe, required this.onErgebnis});

  @override
  State<_AuswahlWidget> createState() => _AuswahlWidgetState();
}

class _AuswahlWidgetState extends State<_AuswahlWidget> {
  int? _gewaehlt;
  _Stand _stand = _Stand.offen;

  void _pruefen() {
    final richtig = _gewaehlt == widget.aufgabe.richtig;
    setState(() => _stand = richtig ? _Stand.richtig : _Stand.falsch);
    _ergebnisSound(richtig);
    widget.onErgebnis(richtig);
  }

  @override
  Widget build(BuildContext context) {
    final farben = Theme.of(context).colorScheme;
    final gesperrt = _stand != _Stand.offen;

    return _AufgabenKarte(
      frage: widget.aufgabe.frage,
      erklaerung: _stand == _Stand.offen ? null : widget.aufgabe.erklaerung,
      stand: _stand,
      onPruefen: _gewaehlt == null ? null : _pruefen,
      onNochmal: () => setState(() {
        _gewaehlt = null;
        _stand = _Stand.offen;
      }),
      inhalt: Column(
        children: [
          for (var i = 0; i < widget.aufgabe.optionen.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: gesperrt ? null : () => setState(() => _gewaehlt = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _gewaehlt == i
                        ? farben.primary.withValues(alpha: 0.14)
                        : farben.surfaceContainerHighest
                            .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _gewaehlt == i
                          ? farben.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: farben.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          String.fromCharCode(65 + i), // A, B, C …
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(widget.aufgabe.optionen[i])),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
