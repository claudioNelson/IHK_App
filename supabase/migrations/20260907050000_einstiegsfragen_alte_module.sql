-- 2026-09-07: 78 Einstiegsfragen (einfach) fuer die fuenf aelteren Module
-- Betriebswirtschaft (1), Recht (2), Projektmanagement (15),
-- Qualitaetsmanagement (16), Geschaeftsprozesse & Organisation (17).
--
-- Befund (Modul-Analyse 07.09.): Controlling hat nur 2 Fragen, in
-- Projekt-/Qualitaetsmanagement beginnen die meisten Themen ohne eine
-- einzige einfache Frage. Ziel: jedes Thema startet mit 5 reinen
-- Faktfragen (Regel: docs/schwierigkeit_regel.md, 1. Lehrjahr); Controlling
-- bekommt 8, weil dort fast nichts vorhanden ist.
-- Fragetexte zum Gegenlesen: docs/neue_fragen_alte_module_2026-09-07.md
--
-- IDs 230026-230103 explizit (Fortsetzung des Bereichs 230000+ aus der
-- Netzwerke-Migration). Antworten ueber die Sequenz. Erklaerung nur bei der
-- richtigen Antwort; Trigger trg_didactic_expl_aiu erzeugt die
-- "Nicht korrekt ..."-Texte der falschen Antworten automatisch.
-- Am Ende Themen-Badges neu berechnen.

begin;

-- Kostenrechnung: Was versteht man in der Betriebswirtschaft unter „Kosten“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230026, 1, 1, 'Was versteht man in der Betriebswirtschaft unter „Kosten“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230026, 'Der in Geld bewertete Verbrauch von Gütern und Leistungen zur Erstellung von Produkten oder Dienstleistungen', true, 'Kosten entstehen, wenn ein Unternehmen Material, Arbeitszeit, Maschinen oder Räume einsetzt, um etwas herzustellen oder anzubieten. Alles wird in Geld gemessen, damit man rechnen und vergleichen kann.'),
  (230026, 'Nur die Ausgaben für Werbung', false, null),
  (230026, 'Das Geld, das Kunden für ein Produkt bezahlen', false, null),
  (230026, 'Der Gewinn nach Steuern', false, null);

-- Kostenrechnung: Welche der folgenden Kosten sind typischerweise fixe Kosten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230027, 1, 1, 'Welche der folgenden Kosten sind typischerweise fixe Kosten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230027, 'Die monatliche Miete für das Bürogebäude', true, 'Fixe Kosten fallen unabhängig davon an, wie viel produziert wird. Die Miete bleibt gleich, ob 10 oder 1000 Stück gefertigt werden.'),
  (230027, 'Das Material für jedes produzierte Stück', false, null),
  (230027, 'Die Versandkosten pro Paket', false, null),
  (230027, 'Der Stromverbrauch der Maschinen pro Stück', false, null);

-- Kostenrechnung: Wie berechnet man den Gewinn eines Unternehmens ganz grundsätzlich?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230028, 1, 1, 'Wie berechnet man den Gewinn eines Unternehmens ganz grundsätzlich?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230028, 'Erlöse minus Kosten', true, 'Was übrig bleibt, wenn man von allen Einnahmen (Erlösen) alle Kosten abzieht, ist der Gewinn. Ist das Ergebnis negativ, spricht man von Verlust.'),
  (230028, 'Kosten minus Erlöse', false, null),
  (230028, 'Erlöse plus Kosten', false, null),
  (230028, 'Umsatz geteilt durch Mitarbeiterzahl', false, null);

-- Kostenrechnung: Was ist der Umsatz eines Unternehmens?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230029, 1, 1, 'Was ist der Umsatz eines Unternehmens?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230029, 'Die Summe aller Verkaufserlöse in einem Zeitraum', true, 'Der Umsatz ist alles, was durch Verkäufe eingenommen wird – noch bevor Kosten abgezogen werden. Ein hoher Umsatz bedeutet also nicht automatisch einen hohen Gewinn.'),
  (230029, 'Der Gewinn nach Abzug aller Kosten', false, null),
  (230029, 'Das Geld auf dem Firmenkonto', false, null),
  (230029, 'Die Anzahl verkaufter Produkte', false, null);

-- Kostenrechnung: Wie nennt man die Kosten, die einem einzelnen Produkt direkt zugeordnet werden k
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230030, 1, 1, 'Wie nennt man die Kosten, die einem einzelnen Produkt direkt zugeordnet werden können, z. B. das verbaute Material?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230030, 'Einzelkosten', true, 'Einzelkosten lassen sich genau einem Produkt zurechnen (z. B. das Gehäuse eines PCs). Gemeinkosten wie Miete oder Verwaltung betreffen dagegen alle Produkte gemeinsam.'),
  (230030, 'Gemeinkosten', false, null),
  (230030, 'Fixkosten', false, null),
  (230030, 'Opportunitätskosten', false, null);

-- Controlling: Was ist die Hauptaufgabe des Controllings in einem Unternehmen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230031, 1, 2, 'Was ist die Hauptaufgabe des Controllings in einem Unternehmen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230031, 'Zahlen sammeln, Ziele mit dem Ist-Zustand vergleichen und die Geschäftsleitung bei Entscheidungen unterstützen', true, 'Controlling heißt nicht „Kontrolle“ im Sinne von Überwachung, sondern „steuern“: Es liefert Kennzahlen und Soll-Ist-Vergleiche, damit das Unternehmen den Kurs halten oder anpassen kann.'),
  (230031, 'Mitarbeiter bei der Arbeit überwachen', false, null),
  (230031, 'Produkte verkaufen', false, null),
  (230031, 'Computer und Netzwerke warten', false, null);

-- Controlling: Was ist ein Soll-Ist-Vergleich?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230032, 1, 2, 'Was ist ein Soll-Ist-Vergleich?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230032, 'Die geplanten Werte werden mit den tatsächlich erreichten Werten verglichen', true, '„Soll“ ist der Plan (z. B. 100.000 € Umsatz), „Ist“ die Realität (z. B. 90.000 €). Die Abweichung zeigt, wo nachgesteuert werden muss.'),
  (230032, 'Der Vergleich zweier Konkurrenzunternehmen', false, null),
  (230032, 'Der Vergleich von Einkaufs- und Verkaufspreis', false, null),
  (230032, 'Der Vergleich von Gehältern verschiedener Abteilungen', false, null);

-- Controlling: Was ist eine Kennzahl?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230033, 1, 2, 'Was ist eine Kennzahl?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230033, 'Eine Zahl, die einen wichtigen Sachverhalt im Unternehmen knapp zusammenfasst, z. B. den Umsatz pro Mitarbeiter', true, 'Kennzahlen verdichten viele Daten auf einen Wert, den man schnell lesen und über die Zeit vergleichen kann. Beispiele: Umsatz, Gewinnmarge, Krankenstand, Kundenzufriedenheit.'),
  (230033, 'Die Telefonnummer der Zentrale', false, null),
  (230033, 'Die Nummer eines Kunden in der Datenbank', false, null),
  (230033, 'Ein Passwort für das Buchhaltungsprogramm', false, null);

-- Controlling: Was bedeutet „Rentabilität“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230034, 1, 2, 'Was bedeutet „Rentabilität“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230034, 'Das Verhältnis von Gewinn zum eingesetzten Kapital – wie viel Ertrag eine Investition bringt', true, 'Rentabilität sagt, wie gut sich eingesetztes Geld verzinst. 10.000 € Gewinn bei 100.000 € Einsatz sind 10 % Rentabilität.'),
  (230034, 'Die Anzahl der verkauften Produkte', false, null),
  (230034, 'Wie lange ein Unternehmen schon existiert', false, null),
  (230034, 'Die Höhe der Miete', false, null);

-- Controlling: Was ist ein Plan-Wert (Soll-Wert) im Controlling?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230035, 1, 2, 'Was ist ein Plan-Wert (Soll-Wert) im Controlling?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230035, 'Der Wert, der für einen Zeitraum vorher festgelegt wurde und erreicht werden soll', true, 'Der Soll-Wert ist die Vorgabe aus der Planung, z. B. „50.000 € Umsatz im März“. Am Ende des Zeitraums wird er mit dem Ist-Wert verglichen (Soll-Ist-Vergleich).'),
  (230035, 'Der tatsächlich erreichte Wert am Ende des Zeitraums', false, null),
  (230035, 'Der Preis eines Produkts', false, null),
  (230035, 'Der Betrag auf dem Firmenkonto', false, null);

-- Controlling: Was ist der Unterschied zwischen kurzfristiger und langfristiger Planung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230036, 1, 2, 'Was ist der Unterschied zwischen kurzfristiger und langfristiger Planung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230036, 'Kurzfristig bezieht sich meist auf bis zu ein Jahr, langfristig auf mehrere Jahre', true, 'Die operative (kurzfristige) Planung regelt das laufende Jahr, die strategische (langfristige) Planung legt die Richtung für die nächsten Jahre fest.'),
  (230036, 'Kurzfristig betrifft nur Mitarbeiter, langfristig nur Kunden', false, null),
  (230036, 'Es gibt keinen Unterschied', false, null),
  (230036, 'Kurzfristig ist immer teurer als langfristig', false, null);

-- Controlling: Was ist eine Abweichungsanalyse?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230037, 1, 2, 'Was ist eine Abweichungsanalyse?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230037, 'Die Untersuchung, warum Ist-Werte von den Planwerten abweichen', true, 'Wenn der Soll-Ist-Vergleich eine Abweichung zeigt, sucht die Abweichungsanalyse nach den Ursachen – etwa gestiegene Materialpreise oder weniger Aufträge.'),
  (230037, 'Die Suche nach Fehlern im Quellcode', false, null),
  (230037, 'Die Prüfung, ob Mitarbeiter pünktlich sind', false, null),
  (230037, 'Der Vergleich von zwei Angeboten', false, null);

-- Controlling: Was ist ein Ist-Wert im Controlling?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230038, 1, 2, 'Was ist ein Ist-Wert im Controlling?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230038, 'Der tatsächlich erreichte Wert, z. B. der wirklich erzielte Umsatz', true, 'Der Ist-Wert ist das, was am Ende wirklich gemessen wurde – im Gegensatz zum Soll-Wert aus der Planung. Die Differenz zwischen beiden heißt Abweichung.'),
  (230038, 'Der geplante Wert aus dem Budget', false, null),
  (230038, 'Der Wert, den die Konkurrenz erreicht hat', false, null),
  (230038, 'Eine Schätzung für das nächste Jahr', false, null);

-- Vertragsrecht: Was ist ein Vertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230039, 2, 3, 'Was ist ein Vertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230039, 'Eine Vereinbarung zwischen mindestens zwei Parteien, die für beide verbindlich ist', true, 'Ein Vertrag kommt zustande, wenn eine Seite ein Angebot macht und die andere es annimmt. Beide sind dann an das Vereinbarte gebunden – auch mündlich.'),
  (230039, 'Ein Schreiben vom Finanzamt', false, null),
  (230039, 'Eine Rechnung', false, null),
  (230039, 'Ein Gesetz des Bundestags', false, null);

-- Vertragsrecht: Wie kommt ein Vertrag zustande?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230040, 2, 3, 'Wie kommt ein Vertrag zustande?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230040, 'Durch Angebot und Annahme', true, 'Zwei übereinstimmende Willenserklärungen sind nötig: Der eine bietet etwas an (Antrag), der andere nimmt an. Erst dann besteht ein Vertrag.'),
  (230040, 'Durch eine Unterschrift des Notars', false, null),
  (230040, 'Durch Bezahlung', false, null),
  (230040, 'Nur durch ein schriftliches Dokument', false, null);

-- Vertragsrecht: Muss ein Kaufvertrag im Supermarkt schriftlich geschlossen werden?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230041, 2, 3, 'Muss ein Kaufvertrag im Supermarkt schriftlich geschlossen werden?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230041, 'Nein, Kaufverträge können auch mündlich oder durch schlüssiges Handeln geschlossen werden', true, 'Ware aufs Band legen und bezahlen ist bereits ein Kaufvertrag durch schlüssiges Handeln. Schriftform ist nur bei bestimmten Verträgen vorgeschrieben, z. B. beim Grundstückskauf.'),
  (230041, 'Ja, jeder Kaufvertrag braucht eine Unterschrift', false, null),
  (230041, 'Ja, sonst ist der Kauf ungültig', false, null),
  (230041, 'Nur bei Beträgen über 50 Euro', false, null);

-- Vertragsrecht: Wofür steht die Abkürzung BGB?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230042, 2, 3, 'Wofür steht die Abkürzung BGB?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230042, 'Bürgerliches Gesetzbuch', true, 'Das BGB regelt das Privatrecht in Deutschland – unter anderem Verträge, Kaufrecht, Mietrecht und Schadensersatz. Es ist die wichtigste Rechtsgrundlage für Verträge zwischen Privatpersonen und Unternehmen.'),
  (230042, 'Bundesgesetzbuch', false, null),
  (230042, 'Betriebliches Grundbuch', false, null),
  (230042, 'Bundesgerichtsbarkeit', false, null);

-- Vertragsrecht: Welche Pflicht hat der Käufer bei einem Kaufvertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230043, 2, 3, 'Welche Pflicht hat der Käufer bei einem Kaufvertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230043, 'Den Kaufpreis zu zahlen und die Ware abzunehmen', true, 'Der Käufer muss bezahlen und die Sache annehmen; der Verkäufer muss die Sache übergeben und das Eigentum verschaffen. Das sind die Hauptpflichten aus § 433 BGB.'),
  (230043, 'Die Ware zu liefern', false, null),
  (230043, 'Eine Garantie zu geben', false, null),
  (230043, 'Die Ware zu reparieren', false, null);

-- Scrum & Agile Methoden: Was ist ein Sprint in Scrum?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230044, 15, 101, 'Was ist ein Sprint in Scrum?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230044, 'Ein fester, kurzer Zeitabschnitt (meist 1–4 Wochen), in dem das Team ein fertiges Teilergebnis liefert', true, 'Scrum arbeitet in Sprints: Am Anfang wird geplant, was in diesem Zeitraum umgesetzt wird, am Ende gibt es ein funktionierendes Ergebnis und ein Review.'),
  (230044, 'Ein Wettlauf zwischen zwei Entwicklern', false, null),
  (230044, 'Die letzte Woche vor der Abgabe', false, null),
  (230044, 'Ein Meeting mit dem Kunden', false, null);

-- Scrum & Agile Methoden: Welche drei Rollen gibt es in Scrum?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230045, 15, 101, 'Welche drei Rollen gibt es in Scrum?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230045, 'Product Owner, Scrum Master und Entwicklungsteam', true, 'Der Product Owner vertritt die Anforderungen, der Scrum Master sorgt dafür, dass das Team gut arbeiten kann, und das Entwicklungsteam baut das Produkt.'),
  (230045, 'Chef, Projektleiter und Praktikant', false, null),
  (230045, 'Kunde, Verkäufer und Tester', false, null),
  (230045, 'Manager, Controller und Designer', false, null);

-- Scrum & Agile Methoden: Was ist das Product Backlog?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230046, 15, 101, 'Was ist das Product Backlog?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230046, 'Die geordnete Liste aller Anforderungen und Aufgaben, die für das Produkt noch offen sind', true, 'Das Product Backlog ist der Vorrat an Arbeit. Der Product Owner pflegt und priorisiert ihn; aus ihm zieht das Team die Aufgaben für den nächsten Sprint.'),
  (230046, 'Ein Fehlerbericht', false, null),
  (230046, 'Das fertige Produkt', false, null),
  (230046, 'Die Liste aller Mitarbeiter', false, null);

-- Scrum & Agile Methoden: Was ist das Daily Scrum?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230047, 15, 101, 'Was ist das Daily Scrum?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230047, 'Ein kurzes tägliches Treffen des Teams, um den Stand abzugleichen', true, 'Im Daily Scrum (max. 15 Minuten) sagt jeder kurz, was er gemacht hat, was er als Nächstes tut und ob etwas blockiert. So bleibt das Team synchron.'),
  (230047, 'Ein wöchentlicher Bericht an den Kunden', false, null),
  (230047, 'Die Abschlussfeier eines Projekts', false, null),
  (230047, 'Ein Training für neue Mitarbeiter', false, null);

-- Scrum & Agile Methoden: Was bedeutet „agil“ in der Softwareentwicklung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230048, 15, 101, 'Was bedeutet „agil“ in der Softwareentwicklung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230048, 'Flexibel in kurzen Schritten arbeiten und regelmäßig auf Rückmeldungen reagieren', true, 'Agile Methoden liefern früh und oft kleine, funktionierende Teile statt eines großen Ergebnisses am Ende. Änderungen werden erwartet und eingeplant.'),
  (230048, 'Möglichst schnell programmieren ohne Planung', false, null),
  (230048, 'Alles am Anfang genau festlegen und nicht mehr ändern', false, null),
  (230048, 'Nur mit einer Person am Projekt arbeiten', false, null);

-- Wasserfallmodell: Was kennzeichnet das Wasserfallmodell?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230049, 15, 102, 'Was kennzeichnet das Wasserfallmodell?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230049, 'Die Projektphasen laufen nacheinander ab, jede Phase wird abgeschlossen, bevor die nächste beginnt', true, 'Wie Wasser, das stufenweise nach unten fließt: Analyse → Entwurf → Umsetzung → Test → Betrieb. Ein Zurück ist nicht vorgesehen.'),
  (230049, 'Alle Phasen laufen gleichzeitig', false, null),
  (230049, 'Es gibt keine festen Phasen', false, null),
  (230049, 'Das Team arbeitet in Sprints', false, null);

-- Wasserfallmodell: Welche Phase steht im Wasserfallmodell ganz am Anfang?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230050, 15, 102, 'Welche Phase steht im Wasserfallmodell ganz am Anfang?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230050, 'Die Anforderungsanalyse', true, 'Zuerst wird geklärt, was das System können soll. Erst danach folgen Entwurf, Implementierung, Test und Wartung.'),
  (230050, 'Der Test', false, null),
  (230050, 'Die Wartung', false, null),
  (230050, 'Die Programmierung', false, null);

-- Wasserfallmodell: Was ist ein Lastenheft?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230051, 15, 102, 'Was ist ein Lastenheft?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230051, 'Ein Dokument, in dem der Auftraggeber beschreibt, was er vom Produkt erwartet', true, 'Das Lastenheft ist die Wunschliste des Kunden: Was soll das System leisten? Der Auftragnehmer antwortet darauf mit dem Pflichtenheft (Wie wird es umgesetzt?).'),
  (230051, 'Ein Dokument mit den Gehältern des Teams', false, null),
  (230051, 'Eine Liste aller gefundenen Fehler', false, null),
  (230051, 'Der Quellcode des Programms', false, null);

-- Wasserfallmodell: Wer schreibt normalerweise das Pflichtenheft?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230052, 15, 102, 'Wer schreibt normalerweise das Pflichtenheft?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230052, 'Der Auftragnehmer', true, 'Das Pflichtenheft beschreibt, WIE der Auftragnehmer die Anforderungen aus dem Lastenheft umsetzen will. Es ist seine Antwort auf das Lastenheft des Auftraggebers.'),
  (230052, 'Der Auftraggeber', false, null),
  (230052, 'Die IHK', false, null),
  (230052, 'Der Endnutzer', false, null);

-- Wasserfallmodell: In welcher Phase des Wasserfallmodells wird der Programmcode geschrieben?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230053, 15, 102, 'In welcher Phase des Wasserfallmodells wird der Programmcode geschrieben?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230053, 'In der Implementierung', true, 'Nach Analyse und Entwurf folgt die Implementierung – die eigentliche Programmierung. Danach wird getestet und das System in Betrieb genommen.'),
  (230053, 'In der Anforderungsanalyse', false, null),
  (230053, 'Im Test', false, null),
  (230053, 'In der Wartung', false, null);

-- Netzplantechnik & Gantt: Was zeigt ein Gantt-Diagramm?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230054, 15, 103, 'Was zeigt ein Gantt-Diagramm?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230054, 'Die Aufgaben eines Projekts als Balken auf einer Zeitachse', true, 'Im Gantt-Diagramm steht jede Aufgabe in einer Zeile, der Balken zeigt Start, Dauer und Ende. So sieht man auf einen Blick, was wann parallel läuft.'),
  (230054, 'Die Kosten jeder Abteilung', false, null),
  (230054, 'Die Hierarchie der Mitarbeiter', false, null),
  (230054, 'Den Gewinn pro Monat', false, null);

-- Netzplantechnik & Gantt: Was ist ein Netzplan im Projektmanagement?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230055, 15, 103, 'Was ist ein Netzplan im Projektmanagement?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230055, 'Eine grafische Darstellung der Vorgänge eines Projekts und ihrer Abhängigkeiten', true, 'Der Netzplan zeigt, welcher Vorgang auf welchem aufbaut. Daraus lassen sich Dauer, früheste und späteste Termine und der kritische Pfad ableiten.'),
  (230055, 'Ein Plan des Computernetzwerks', false, null),
  (230055, 'Ein Organigramm des Unternehmens', false, null),
  (230055, 'Ein Plan für die Kabelverlegung', false, null);

-- Netzplantechnik & Gantt: Was ist ein Meilenstein?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230056, 15, 103, 'Was ist ein Meilenstein?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230056, 'Ein wichtiges Zwischenziel im Projekt, oft mit festem Termin', true, 'Meilensteine markieren Etappen wie „Entwurf abgenommen“ oder „Testphase abgeschlossen“. Sie haben keine Dauer, sondern sind ein Zeitpunkt.'),
  (230056, 'Ein Fehler im Projektplan', false, null),
  (230056, 'Die Gesamtdauer des Projekts', false, null),
  (230056, 'Ein Mitarbeiter mit besonderer Verantwortung', false, null);

-- Netzplantechnik & Gantt: Was bedeutet „Vorgang“ in der Netzplantechnik?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230057, 15, 103, 'Was bedeutet „Vorgang“ in der Netzplantechnik?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230057, 'Eine einzelne Aufgabe mit einer bestimmten Dauer', true, 'Ein Vorgang ist ein Arbeitspaket, z. B. „Datenbank aufsetzen, 3 Tage“. Vorgänge werden im Netzplan mit ihren Abhängigkeiten verbunden.'),
  (230057, 'Der Projektleiter', false, null),
  (230057, 'Das gesamte Projekt', false, null),
  (230057, 'Ein Meeting', false, null);

-- Netzplantechnik & Gantt: Was bedeutet es, wenn ein Vorgang auf dem kritischen Pfad liegt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230058, 15, 103, 'Was bedeutet es, wenn ein Vorgang auf dem kritischen Pfad liegt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230058, 'Verzögert er sich, verzögert sich das ganze Projekt', true, 'Der kritische Pfad ist die längste Kette von Vorgängen ohne Zeitreserve. Jede Verzögerung dort schlägt direkt auf den Endtermin durch.'),
  (230058, 'Er ist besonders teuer', false, null),
  (230058, 'Er ist besonders gefährlich für die Mitarbeiter', false, null),
  (230058, 'Er kann jederzeit verschoben werden', false, null);

-- Projektanalyse: Was ist ein Projekt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230059, 15, 104, 'Was ist ein Projekt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230059, 'Ein einmaliges Vorhaben mit klarem Ziel, festem Anfang und Ende und begrenzten Mitteln', true, 'Im Gegensatz zur Routinearbeit ist ein Projekt einzigartig: Es hat ein definiertes Ziel, einen Zeitrahmen und ein Budget – z. B. die Einführung einer neuen Software.'),
  (230059, 'Jede Aufgabe, die länger als eine Stunde dauert', false, null),
  (230059, 'Die tägliche Arbeit im Support', false, null),
  (230059, 'Eine Abteilung im Unternehmen', false, null);

-- Projektanalyse: Wer ist ein Stakeholder?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230060, 15, 104, 'Wer ist ein Stakeholder?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230060, 'Jede Person oder Gruppe, die ein Interesse am Projekt hat oder von ihm betroffen ist', true, 'Stakeholder sind z. B. Auftraggeber, Nutzer, Geschäftsleitung, Mitarbeiter oder Lieferanten. Ihre Erwartungen zu kennen, ist wichtig für den Projekterfolg.'),
  (230060, 'Nur der Projektleiter', false, null),
  (230060, 'Nur der Kunde, der bezahlt', false, null),
  (230060, 'Ein Aktionär der Firma', false, null);

-- Projektanalyse: Was ist ein Projektziel?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230061, 15, 104, 'Was ist ein Projektziel?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230061, 'Das Ergebnis, das am Ende des Projekts erreicht sein soll', true, 'Ein gutes Projektziel ist klar messbar, z. B. „Bis 30.06. läuft das neue Ticketsystem für alle 50 Mitarbeiter“. Ohne klares Ziel lässt sich Erfolg nicht prüfen.'),
  (230061, 'Die Liste aller Teammitglieder', false, null),
  (230061, 'Der Zeitplan', false, null),
  (230061, 'Das Budget', false, null);

-- Projektanalyse: Was ist ein Risiko im Projekt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230062, 15, 104, 'Was ist ein Risiko im Projekt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230062, 'Ein mögliches Ereignis, das das Projekt negativ beeinflussen könnte', true, 'Risiken sind Unsicherheiten: Ein Lieferant könnte ausfallen, ein Mitarbeiter krank werden, die Technik nicht funktionieren. Gute Planung erkennt Risiken früh.'),
  (230062, 'Ein bereits eingetretener Fehler', false, null),
  (230062, 'Ein Teammitglied', false, null),
  (230062, 'Die Kosten des Projekts', false, null);

-- Projektanalyse: Was ist der Projektabschluss?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230063, 15, 104, 'Was ist der Projektabschluss?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230063, 'Die letzte Phase, in der das Ergebnis übergeben und das Projekt ausgewertet wird', true, 'Am Ende wird das Ergebnis abgenommen, die Dokumentation fertiggestellt und in einer Nachbetrachtung festgehalten, was gut lief und was man beim nächsten Mal besser macht.'),
  (230063, 'Der erste Tag des Projekts', false, null),
  (230063, 'Die Planung des Budgets', false, null),
  (230063, 'Ein Meeting in der Mitte des Projekts', false, null);

-- Total Quality Management: Was bedeutet Qualität im Qualitätsmanagement?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230064, 16, 105, 'Was bedeutet Qualität im Qualitätsmanagement?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230064, 'Der Grad, in dem ein Produkt oder eine Dienstleistung die Anforderungen erfüllt', true, 'Qualität heißt nicht „teuer“ oder „luxuriös“, sondern: Das Ergebnis tut das, was vereinbart und erwartet wurde – zuverlässig und wiederholbar.'),
  (230064, 'Ein möglichst hoher Preis', false, null),
  (230064, 'Ein schönes Design', false, null),
  (230064, 'Die Anzahl der Funktionen', false, null);

-- Total Quality Management: Wofür steht die Abkürzung QM?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230065, 16, 105, 'Wofür steht die Abkürzung QM?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230065, 'Qualitätsmanagement', true, 'QM umfasst alle Maßnahmen, mit denen ein Unternehmen die Qualität seiner Produkte und Prozesse plant, sichert und verbessert.'),
  (230065, 'Quartalsmeeting', false, null),
  (230065, 'Quellcode-Management', false, null),
  (230065, 'Qualifizierte Mitarbeiter', false, null);

-- Total Quality Management: Wofür stehen die vier Buchstaben im PDCA-Zyklus?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230066, 16, 105, 'Wofür stehen die vier Buchstaben im PDCA-Zyklus?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230066, 'Plan, Do, Check, Act', true, 'Der PDCA-Zyklus (auch Deming-Kreis) ist der Grundtakt der Verbesserung: planen, umsetzen, prüfen, anpassen – und dann wieder von vorn.'),
  (230066, 'Product, Design, Code, Analyse', false, null),
  (230066, 'Prüfen, Dokumentieren, Controlling, Abnahme', false, null),
  (230066, 'Projekt, Daten, Chef, Abteilung', false, null);

-- Total Quality Management: Was ist das Ziel der kontinuierlichen Verbesserung (KVP)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230067, 16, 105, 'Was ist das Ziel der kontinuierlichen Verbesserung (KVP)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230067, 'Prozesse und Produkte in vielen kleinen Schritten immer weiter zu verbessern', true, 'KVP (kontinuierlicher Verbesserungsprozess, japanisch Kaizen) setzt auf ständige kleine Verbesserungen durch alle Mitarbeiter statt auf seltene große Umbrüche.'),
  (230067, 'Einmal im Jahr alles neu zu machen', false, null),
  (230067, 'Nur die Kosten zu senken', false, null),
  (230067, 'Mitarbeiter zu kontrollieren', false, null);

-- Total Quality Management: Was bedeutet Kundenorientierung im Qualitätsmanagement?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230068, 16, 105, 'Was bedeutet Kundenorientierung im Qualitätsmanagement?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230068, 'Die Bedürfnisse und Erwartungen der Kunden stehen im Mittelpunkt aller Entscheidungen', true, 'Am Ende entscheidet der Kunde, ob Qualität stimmt. Kundenorientierung heißt, seine Anforderungen zu kennen und Prozesse danach auszurichten.'),
  (230068, 'Der Kunde wird über alle internen Abläufe informiert', false, null),
  (230068, 'Der Kunde darf die Mitarbeiter auswählen', false, null),
  (230068, 'Kunden werden nur nach dem Preis bedient', false, null);

-- Softwarequalität: Was bedeutet es, wenn eine Software „zuverlässig“ ist?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230069, 16, 106, 'Was bedeutet es, wenn eine Software „zuverlässig“ ist?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230069, 'Sie funktioniert über längere Zeit stabil und stürzt nicht ab', true, 'Zuverlässigkeit ist ein Qualitätsmerkmal nach ISO 25010: Die Software liefert unter normalen Bedingungen dauerhaft korrekte Ergebnisse ohne Ausfälle.'),
  (230069, 'Sie hat viele Funktionen', false, null),
  (230069, 'Sie ist kostenlos', false, null),
  (230069, 'Sie sieht modern aus', false, null);

-- Softwarequalität: Was versteht man unter der Benutzbarkeit (Usability) einer Software?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230070, 16, 106, 'Was versteht man unter der Benutzbarkeit (Usability) einer Software?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230070, 'Wie leicht Nutzer die Software verstehen, erlernen und bedienen können', true, 'Gute Usability bedeutet: Man findet sich schnell zurecht, macht wenig Fehler und braucht keine lange Schulung. Sie ist eines der Qualitätsmerkmale von Software.'),
  (230070, 'Wie schnell die Software startet', false, null),
  (230070, 'Wie viel Speicherplatz sie braucht', false, null),
  (230070, 'Wie teuer die Lizenz ist', false, null);

-- Softwarequalität: Was bedeutet „Wartbarkeit“ bei Software?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230071, 16, 106, 'Was bedeutet „Wartbarkeit“ bei Software?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230071, 'Wie leicht sich die Software später ändern, erweitern und Fehler beheben lassen', true, 'Wartbare Software hat sauberen, dokumentierten Code, sodass auch andere Entwickler Änderungen schnell und sicher vornehmen können.'),
  (230071, 'Wie oft die Software neu gestartet werden muss', false, null),
  (230071, 'Wie lange die Garantie gilt', false, null),
  (230071, 'Ob es eine Hotline gibt', false, null);

-- Softwarequalität: Was bedeutet „Funktionalität“ als Qualitätsmerkmal?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230072, 16, 106, 'Was bedeutet „Funktionalität“ als Qualitätsmerkmal?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230072, 'Die Software bietet alle Funktionen, die gefordert sind, und diese arbeiten korrekt', true, 'Funktionalität prüft: Tut die Software das, was im Lastenheft steht? Fehlt eine geforderte Funktion oder rechnet sie falsch, ist die Funktionalität nicht erfüllt.'),
  (230072, 'Die Software läuft auf vielen Geräten', false, null),
  (230072, 'Die Software ist schnell', false, null),
  (230072, 'Die Software ist hübsch gestaltet', false, null);

-- Softwarequalität: Was bedeutet „Effizienz“ bei Software?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230073, 16, 106, 'Was bedeutet „Effizienz“ bei Software?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230073, 'Die Software erledigt ihre Aufgaben mit möglichst wenig Zeit und Ressourcen wie Speicher und Rechenleistung', true, 'Effiziente Software reagiert schnell und verbraucht wenig Arbeitsspeicher, CPU und Strom. Das ist auf Smartphones und Servern gleichermaßen wichtig.'),
  (230073, 'Die Software hat wenige Fehler', false, null),
  (230073, 'Die Software ist leicht zu bedienen', false, null),
  (230073, 'Die Software wird oft aktualisiert', false, null);

-- Testverfahren: Warum wird Software getestet?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230074, 16, 107, 'Warum wird Software getestet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230074, 'Um Fehler zu finden, bevor die Software beim Kunden im Einsatz ist', true, 'Jeder Fehler, der erst beim Kunden auffällt, ist teuer und schadet dem Ruf. Tests sollen Fehler so früh wie möglich aufdecken.'),
  (230074, 'Um den Quellcode zu verschlüsseln', false, null),
  (230074, 'Um die Software schneller zu machen', false, null),
  (230074, 'Weil es gesetzlich vorgeschrieben ist', false, null);

-- Testverfahren: Was ist ein Testfall?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230075, 16, 107, 'Was ist ein Testfall?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230075, 'Eine konkrete Beschreibung: Eingabe, erwartetes Ergebnis und Ablauf eines einzelnen Tests', true, 'Beispiel: „Eingabe: Passwort mit 3 Zeichen. Erwartet: Fehlermeldung ‚mindestens 8 Zeichen‘.“ Testfälle machen Tests wiederholbar und nachvollziehbar.'),
  (230075, 'Ein Fehler im Programm', false, null),
  (230075, 'Ein Ordner mit Testdaten', false, null),
  (230075, 'Der Name des Testers', false, null);

-- Testverfahren: Was ist ein Modultest (Unit-Test)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230076, 16, 107, 'Was ist ein Modultest (Unit-Test)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230076, 'Ein Test, der einen einzelnen kleinen Baustein der Software isoliert prüft, z. B. eine Funktion', true, 'Unit-Tests sind die kleinste Teststufe. Sie werden meist von den Entwicklern selbst geschrieben und laufen automatisch bei jeder Änderung.'),
  (230076, 'Ein Test des gesamten Systems durch den Kunden', false, null),
  (230076, 'Ein Test der Netzwerkgeschwindigkeit', false, null),
  (230076, 'Eine Umfrage bei den Nutzern', false, null);

-- Testverfahren: Was ist der Abnahmetest?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230077, 16, 107, 'Was ist der Abnahmetest?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230077, 'Der Test, bei dem der Auftraggeber prüft, ob die Software seinen Anforderungen entspricht', true, 'Beim Abnahmetest entscheidet der Kunde: Ist das, was geliefert wurde, das, was bestellt war? Danach gilt das Projekt als abgenommen.'),
  (230077, 'Der erste Test eines neuen Entwicklers', false, null),
  (230077, 'Ein automatischer Test beim Programmstart', false, null),
  (230077, 'Ein Test der Hardware', false, null);

-- Testverfahren: Was bedeutet „Black-Box-Test“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230078, 16, 107, 'Was bedeutet „Black-Box-Test“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230078, 'Die Software wird nur von außen über Eingaben und Ausgaben getestet, ohne den Code zu kennen', true, 'Der Tester behandelt das Programm wie eine schwarze Kiste: Er gibt etwas ein und prüft, ob das Richtige herauskommt. Beim White-Box-Test schaut er dagegen in den Code.'),
  (230078, 'Ein Test in einem abgedunkelten Raum', false, null),
  (230078, 'Ein Test des Quellcodes Zeile für Zeile', false, null),
  (230078, 'Ein Test, der nachts automatisch läuft', false, null);

-- Standards & Barrierefreiheit: Was ist eine Norm (z. B. eine DIN-Norm)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230079, 16, 108, 'Was ist eine Norm (z. B. eine DIN-Norm)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230079, 'Eine anerkannte Regel, die festlegt, wie etwas beschaffen sein oder ablaufen soll', true, 'Normen sorgen dafür, dass Dinge zusammenpassen und vergleichbar sind – vom Papierformat DIN A4 bis zu Qualitätsmanagement nach ISO 9001.'),
  (230079, 'Ein Gesetz des Bundestags', false, null),
  (230079, 'Eine Anweisung des Chefs', false, null),
  (230079, 'Ein Passwort-Standard', false, null);

-- Standards & Barrierefreiheit: Wofür steht die Abkürzung ISO?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230080, 16, 108, 'Wofür steht die Abkürzung ISO?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230080, 'Internationale Organisation für Normung', true, 'Die ISO erarbeitet weltweit gültige Normen. Bekannte Beispiele: ISO 9001 (Qualitätsmanagement), ISO 27001 (Informationssicherheit).'),
  (230080, 'Internet Service Organisation', false, null),
  (230080, 'Institut für Software-Optimierung', false, null),
  (230080, 'Internationale Sicherheits-Ordnung', false, null);

-- Standards & Barrierefreiheit: Was bedeutet Barrierefreiheit bei Software und Webseiten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230081, 16, 108, 'Was bedeutet Barrierefreiheit bei Software und Webseiten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230081, 'Auch Menschen mit Einschränkungen, z. B. Sehbehinderung, können sie ohne Hilfe nutzen', true, 'Barrierefreie Software ist z. B. per Tastatur bedienbar, hat Alternativtexte für Bilder und ausreichende Kontraste, damit Screenreader und Nutzer mit Einschränkungen zurechtkommen.'),
  (230081, 'Die Software ist kostenlos', false, null),
  (230081, 'Die Software läuft ohne Internet', false, null),
  (230081, 'Die Software hat keine Werbung', false, null);

-- Standards & Barrierefreiheit: Was ist ein Alternativtext (Alt-Text) bei einem Bild auf einer Webseite?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230082, 16, 108, 'Was ist ein Alternativtext (Alt-Text) bei einem Bild auf einer Webseite?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230082, 'Eine Textbeschreibung des Bildes, die vorgelesen wird, wenn das Bild nicht gesehen werden kann', true, 'Screenreader lesen den Alt-Text blinden Nutzern vor. Auch wenn ein Bild nicht lädt, erscheint der Text. Er ist ein Grundbaustein der Barrierefreiheit.'),
  (230082, 'Der Dateiname des Bildes', false, null),
  (230082, 'Ein Wasserzeichen', false, null),
  (230082, 'Die Bildgröße in Pixeln', false, null);

-- Standards & Barrierefreiheit: Warum sind Standards in der IT wichtig?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230083, 16, 108, 'Warum sind Standards in der IT wichtig?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230083, 'Damit Produkte verschiedener Hersteller zusammenarbeiten und vergleichbar sind', true, 'Ohne Standards wie USB, HTML oder TCP/IP würde jedes Gerät seine eigene Sprache sprechen. Standards sichern Kompatibilität und Qualität.'),
  (230083, 'Damit alle Produkte gleich aussehen', false, null),
  (230083, 'Damit Software teurer verkauft werden kann', false, null),
  (230083, 'Damit nur ein Hersteller den Markt beherrscht', false, null);

-- Marktformen: Was ist ein Markt in der Wirtschaft?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230084, 17, 109, 'Was ist ein Markt in der Wirtschaft?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230084, 'Der Ort oder Zusammenhang, an dem Angebot und Nachfrage aufeinandertreffen', true, 'Ein Markt muss kein Platz sein – auch ein Online-Shop ist ein Markt. Entscheidend ist: Anbieter und Nachfrager kommen zusammen und es bildet sich ein Preis.'),
  (230084, 'Nur ein Wochenmarkt mit Ständen', false, null),
  (230084, 'Eine Abteilung im Unternehmen', false, null),
  (230084, 'Ein Lager für Waren', false, null);

-- Marktformen: Was bedeutet „Nachfrage“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230085, 17, 109, 'Was bedeutet „Nachfrage“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230085, 'Die Menge an Waren oder Leistungen, die Käufer zu einem bestimmten Preis kaufen wollen', true, 'Nachfrage ist die Käuferseite des Marktes. Steigt der Preis, sinkt in der Regel die Nachfrage – und umgekehrt.'),
  (230085, 'Die Menge, die Hersteller produzieren', false, null),
  (230085, 'Eine Frage an den Kundenservice', false, null),
  (230085, 'Die Lagerbestände eines Unternehmens', false, null);

-- Marktformen: Was bedeutet „Angebot“ in der Wirtschaft?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230086, 17, 109, 'Was bedeutet „Angebot“ in der Wirtschaft?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230086, 'Die Menge an Waren oder Leistungen, die Anbieter zu einem bestimmten Preis verkaufen wollen', true, 'Angebot ist die Verkäuferseite des Marktes. Je höher der Preis, desto mehr Anbieter sind bereit zu verkaufen.'),
  (230086, 'Ein Rabatt im Supermarkt', false, null),
  (230086, 'Die Anzahl der Kunden', false, null),
  (230086, 'Eine Werbeanzeige', false, null);

-- Marktformen: Was ist ein Monopol?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230087, 17, 109, 'Was ist ein Monopol?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230087, 'Eine Marktform, bei der es nur einen einzigen Anbieter gibt', true, 'Im Monopol gibt es keinen Wettbewerb; der einzige Anbieter kann den Preis weitgehend bestimmen. Beispiel: früher die Post beim Briefverkehr.'),
  (230087, 'Ein Markt mit vielen kleinen Anbietern', false, null),
  (230087, 'Ein Brettspiel', false, null),
  (230087, 'Ein Markt mit genau zwei Anbietern', false, null);

-- Marktformen: Was ist Wettbewerb (Konkurrenz)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230088, 17, 109, 'Was ist Wettbewerb (Konkurrenz)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230088, 'Mehrere Anbieter konkurrieren um dieselben Kunden, etwa über Preis, Qualität oder Service', true, 'Wettbewerb sorgt dafür, dass Anbieter sich anstrengen: bessere Produkte, günstigere Preise, mehr Service. Er ist das Gegenteil von Monopol.'),
  (230088, 'Ein Vertrag zwischen zwei Firmen', false, null),
  (230088, 'Die Zusammenarbeit von Unternehmen', false, null),
  (230088, 'Eine Sportveranstaltung der Firma', false, null);

-- Leitungssysteme & Führung: Was zeigt ein Organigramm?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230089, 17, 110, 'Was zeigt ein Organigramm?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230089, 'Den Aufbau eines Unternehmens: Abteilungen, Stellen und wer wem unterstellt ist', true, 'Das Organigramm ist die Landkarte der Organisation. Man sieht auf einen Blick, welche Abteilungen es gibt und wie die Leitungswege verlaufen.'),
  (230089, 'Den Lageplan des Gebäudes', false, null),
  (230089, 'Die Umsätze pro Monat', false, null),
  (230089, 'Die Urlaubstage der Mitarbeiter', false, null);

-- Leitungssysteme & Führung: Was ist eine Stelle in der Organisation?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230090, 17, 110, 'Was ist eine Stelle in der Organisation?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230090, 'Die kleinste organisatorische Einheit – ein Aufgabenbereich für eine Person', true, 'Eine Stelle bündelt Aufgaben, Kompetenzen und Verantwortung für einen Mitarbeiter, z. B. „Systemadministrator“. Mehrere Stellen bilden eine Abteilung.'),
  (230090, 'Ein Schreibtisch', false, null),
  (230090, 'Eine Abteilung', false, null),
  (230090, 'Ein Standort des Unternehmens', false, null);

-- Leitungssysteme & Führung: Was ist eine Abteilung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230091, 17, 110, 'Was ist eine Abteilung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230091, 'Eine Gruppe von Stellen, die unter einer gemeinsamen Leitung ähnliche Aufgaben erledigt', true, 'Beispiele: IT-Abteilung, Vertrieb, Buchhaltung. Jede Abteilung hat einen Leiter und ein abgegrenztes Aufgabengebiet.'),
  (230091, 'Ein einzelner Arbeitsplatz', false, null),
  (230091, 'Der Vorstand', false, null),
  (230091, 'Ein Kunde des Unternehmens', false, null);

-- Leitungssysteme & Führung: Was bedeutet „Weisungsbefugnis“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230092, 17, 110, 'Was bedeutet „Weisungsbefugnis“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230092, 'Das Recht, anderen Mitarbeitern Anweisungen zu geben', true, 'Wer weisungsbefugt ist, darf Aufgaben zuteilen und Anordnungen treffen – typischerweise Vorgesetzte gegenüber ihren Mitarbeitern.'),
  (230092, 'Das Recht, Urlaub zu nehmen', false, null),
  (230092, 'Die Pflicht, Berichte zu schreiben', false, null),
  (230092, 'Die Erlaubnis, das Firmenauto zu nutzen', false, null);

-- Leitungssysteme & Führung: Was versteht man unter „Führungsstil“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230093, 17, 110, 'Was versteht man unter „Führungsstil“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230093, 'Die Art und Weise, wie ein Vorgesetzter seine Mitarbeiter führt und Entscheidungen trifft', true, 'Führungsstile reichen von autoritär (der Chef entscheidet allein) über kooperativ (Mitarbeiter werden einbezogen) bis laissez-faire (die Mitarbeiter entscheiden weitgehend selbst).'),
  (230093, 'Die Kleidung des Chefs', false, null),
  (230093, 'Die Größe des Büros', false, null),
  (230093, 'Die Anzahl der Mitarbeiter', false, null);

-- Wirtschaftlichkeit: Was bedeutet Wirtschaftlichkeit?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230094, 17, 111, 'Was bedeutet Wirtschaftlichkeit?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230094, 'Das Verhältnis von Ertrag (Ausbringung) zu Aufwand (Einsatz) – möglichst viel Nutzen für möglichst wenig Kosten', true, 'Wirtschaftlich handeln heißt, ein Ziel mit möglichst geringem Aufwand zu erreichen oder mit gegebenem Aufwand möglichst viel zu erreichen. Formel: Ertrag ÷ Aufwand.'),
  (230094, 'Möglichst viel Geld auszugeben', false, null),
  (230094, 'Möglichst viele Mitarbeiter zu beschäftigen', false, null),
  (230094, 'Immer das teuerste Produkt zu kaufen', false, null);

-- Wirtschaftlichkeit: Was ist eine Investition?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230095, 17, 111, 'Was ist eine Investition?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230095, 'Die Verwendung von Geld für Dinge, die dem Unternehmen längerfristig nutzen, z. B. neue Server', true, 'Investitionen sind langfristige Ausgaben: Maschinen, Gebäude, IT-Ausstattung, Software. Sie sollen über Jahre Nutzen bringen – anders als laufende Kosten wie Strom.'),
  (230095, 'Die Zahlung der Monatsgehälter', false, null),
  (230095, 'Der Kauf von Büromaterial', false, null),
  (230095, 'Die Stromrechnung', false, null);

-- Wirtschaftlichkeit: Was bedeutet „Leasing“?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230096, 17, 111, 'Was bedeutet „Leasing“?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230096, 'Ein Gegenstand wird gegen monatliche Raten genutzt, bleibt aber Eigentum des Leasinggebers', true, 'Beim Leasing mietet das Unternehmen z. B. Laptops oder Fahrzeuge langfristig, statt sie zu kaufen. Vorteil: kein großer Kaufbetrag auf einmal; Nachteil: am Ende gehört einem nichts.'),
  (230096, 'Der Kauf auf Raten mit Eigentumsübergang', false, null),
  (230096, 'Ein Kredit von der Bank', false, null),
  (230096, 'Der Verkauf gebrauchter Geräte', false, null);

-- Wirtschaftlichkeit: Was ist ein Angebotsvergleich?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230097, 17, 111, 'Was ist ein Angebotsvergleich?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230097, 'Mehrere Angebote verschiedener Anbieter werden nach Preis und Bedingungen verglichen', true, 'Bevor ein Unternehmen z. B. 20 neue PCs kauft, holt es Angebote ein und vergleicht Preis, Lieferzeit, Garantie und Service. So findet es das wirtschaftlichste Angebot.'),
  (230097, 'Der Vergleich zweier Mitarbeiter', false, null),
  (230097, 'Die Prüfung der eigenen Preise', false, null),
  (230097, 'Ein Test der Produktqualität', false, null);

-- Wirtschaftlichkeit: Was ist der Unterschied zwischen Kauf und Miete?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230098, 17, 111, 'Was ist der Unterschied zwischen Kauf und Miete?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230098, 'Beim Kauf wird man Eigentümer, bei der Miete nutzt man den Gegenstand nur gegen Entgelt', true, 'Kauf: einmalige Zahlung, der Gegenstand gehört dir. Miete: laufende Zahlung, der Gegenstand bleibt dem Vermieter. Bei IT wird oft gemietet, um flexibel zu bleiben.'),
  (230098, 'Miete ist immer günstiger als Kauf', false, null),
  (230098, 'Es gibt keinen Unterschied', false, null),
  (230098, 'Beim Kauf zahlt man monatlich, bei der Miete einmalig', false, null);

-- Beschaffung & Kommunikation: Was ist Beschaffung im Unternehmen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230099, 17, 112, 'Was ist Beschaffung im Unternehmen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230099, 'Die Versorgung des Unternehmens mit allen benötigten Waren und Leistungen, z. B. Hardware oder Software', true, 'Die Beschaffung (Einkauf) sorgt dafür, dass alles rechtzeitig, in der richtigen Menge und Qualität und zu einem guten Preis vorhanden ist.'),
  (230099, 'Der Verkauf der eigenen Produkte', false, null),
  (230099, 'Die Ausbildung neuer Mitarbeiter', false, null),
  (230099, 'Die Buchhaltung', false, null);

-- Beschaffung & Kommunikation: Was ist ein Lieferant?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230100, 17, 112, 'Was ist ein Lieferant?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230100, 'Ein Unternehmen, das Waren oder Leistungen an ein anderes Unternehmen liefert', true, 'Lieferanten sind die Partner auf der Einkaufsseite: der Hardware-Händler, der Softwareanbieter, der Internetprovider.'),
  (230100, 'Ein Kunde', false, null),
  (230100, 'Ein Mitarbeiter der Poststelle', false, null),
  (230100, 'Der Geschäftsführer', false, null);

-- Beschaffung & Kommunikation: Was ist ein Angebot im Geschäftsverkehr?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230101, 17, 112, 'Was ist ein Angebot im Geschäftsverkehr?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230101, 'Die verbindliche Erklärung eines Anbieters, zu welchen Bedingungen er etwas liefern will', true, 'Ein Angebot enthält Preis, Menge, Lieferzeit und Zahlungsbedingungen. Nimmt der Kunde es an, kommt ein Vertrag zustande.'),
  (230101, 'Eine unverbindliche Werbebroschüre', false, null),
  (230101, 'Eine Mahnung', false, null),
  (230101, 'Der Lieferschein', false, null);

-- Beschaffung & Kommunikation: Was ist eine Bestellung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230102, 17, 112, 'Was ist eine Bestellung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230102, 'Die Aufforderung eines Kunden an einen Lieferanten, eine Ware oder Leistung zu den vereinbarten Bedingungen zu liefern', true, 'Mit der Bestellung nimmt der Kunde das Angebot an oder fordert eine Lieferung an. Zusammen mit der Annahme durch den Lieferanten entsteht daraus ein Kaufvertrag.'),
  (230102, 'Die Rechnung, die nach der Lieferung geschickt wird', false, null),
  (230102, 'Ein unverbindlicher Preisvergleich im Internet', false, null),
  (230102, 'Die Mahnung bei verspäteter Zahlung', false, null);

-- Beschaffung & Kommunikation: Was bedeutet Kommunikation im beruflichen Zusammenhang?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230103, 17, 112, 'Was bedeutet Kommunikation im beruflichen Zusammenhang?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230103, 'Der Austausch von Informationen zwischen Personen, z. B. per Gespräch, E-Mail oder Ticket', true, 'Gute Kommunikation heißt: klar, vollständig und an die richtige Person. Im IT-Alltag läuft sie über Tickets, E-Mails, Meetings und Dokumentation.'),
  (230103, 'Nur das Telefonieren mit Kunden', false, null),
  (230103, 'Das Verschicken von Werbung', false, null),
  (230103, 'Das Schreiben von Programmcode', false, null);

select public.refresh_themen_schwierigkeit() as themen_aktualisiert;
commit;

-- Kontrolle: select thema_id, count(*) from fragen where id between 230026 and 230103 group by 1 order by 1;  -- 15 Themen, Controlling 8, sonst 5