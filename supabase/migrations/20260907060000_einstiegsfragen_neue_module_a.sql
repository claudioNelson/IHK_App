-- 2026-09-07: 105 Einstiegsfragen (einfach) fuer Rechnungswesen (9001), WISO (9002),
-- Datenbanken (9003), Betriebssysteme & Linux (9005), IT-Grundlagen & Hardware (9006).
--
-- Befund: In diesen Modulen haben 21 von 25 Themen weniger als 5 einfache
-- Fragen, 7 Themen gar keine (z. B. IT-Recht & Datenschutz, Transaktionen &
-- Indexe, Dateien & Berechtigungen). Uebersprungen, weil schon voll: SQL Basics,
-- OS- & Shell-Grundlagen, Linux CLI & Tools Basics, Hardware-Basics.
-- Ziel: jedes Thema startet mit 5 reinen Faktfragen (docs/schwierigkeit_regel.md).
-- Fragetexte zum Gegenlesen: docs/neue_fragen_neue_module_a_2026-09-07.md
--
-- IDs 230104-230208 explizit (Bereich 230000+ fuer handgeschriebene Fragen).
-- Antworten ueber die Sequenz. Erklaerung nur bei der richtigen Antwort;
-- Trigger trg_didactic_expl_aiu erzeugt die "Nicht korrekt ..."-Texte.
-- Am Ende Themen-Badges neu berechnen.

begin;

-- Buchführung Grundlagen: Was ist ein Beleg in der Buchführung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230104, 9001, 9101, 'Was ist ein Beleg in der Buchführung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230104, 'Ein Nachweis für einen Geschäftsvorfall, z. B. eine Rechnung oder ein Kassenbon', true, 'Ohne Beleg keine Buchung: Jeder Geschäftsvorfall muss durch ein Dokument wie Rechnung, Quittung oder Kontoauszug belegt sein. Das ist ein Grundsatz ordnungsmäßiger Buchführung.'),
  (230104, 'Ein Konto bei der Bank', false, null),
  (230104, 'Der Jahresabschluss des Unternehmens', false, null),
  (230104, 'Eine Liste aller Mitarbeiter', false, null);

-- Buchführung Grundlagen: Wie heißen die beiden Seiten eines Kontos in der doppelten Buchführung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230105, 9001, 9101, 'Wie heißen die beiden Seiten eines Kontos in der doppelten Buchführung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230105, 'Soll und Haben', true, 'Jedes Konto hat eine linke Seite (Soll) und eine rechte Seite (Haben). Jede Buchung berührt mindestens zwei Konten – einmal im Soll, einmal im Haben.'),
  (230105, 'Plus und Minus', false, null),
  (230105, 'Einnahmen und Ausgaben', false, null),
  (230105, 'Aktiv und Passiv', false, null);

-- Buchführung Grundlagen: Was ist eine Inventur?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230106, 9001, 9101, 'Was ist eine Inventur?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230106, 'Die Bestandsaufnahme aller Vermögensgegenstände und Schulden zu einem Stichtag', true, 'Bei der Inventur wird gezählt, gemessen, gewogen und bewertet, was das Unternehmen besitzt und schuldet. Das Ergebnis ist das Inventar, die Grundlage für die Bilanz.'),
  (230106, 'Die Überweisung des Gehalts an die Mitarbeiter', false, null),
  (230106, 'Der Verkauf alter Geräte', false, null),
  (230106, 'Die Steuererklärung des Unternehmens', false, null);

-- Buchführung Grundlagen: Was ist ein Geschäftsvorfall?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230107, 9001, 9101, 'Was ist ein Geschäftsvorfall?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230107, 'Ein Ereignis, das das Vermögen oder die Schulden des Unternehmens verändert, z. B. ein Verkauf', true, 'Jeder Kauf, Verkauf, jede Zahlung oder Gehaltsüberweisung ist ein Geschäftsvorfall. Genau diese Ereignisse werden in der Buchführung erfasst.'),
  (230107, 'Ein Termin im Kalender des Chefs', false, null),
  (230107, 'Eine interne Besprechung ohne Kosten', false, null),
  (230107, 'Der Name eines Buchhaltungsprogramms', false, null);

-- Buchführung Grundlagen: Wozu dient die Buchführung in erster Linie?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230108, 9001, 9101, 'Wozu dient die Buchführung in erster Linie?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230108, 'Alle Geschäftsvorfälle lückenlos und nachvollziehbar aufzuzeichnen', true, 'Die Buchführung dokumentiert alle Geldflüsse und Vermögensänderungen. Daraus entstehen Bilanz, Gewinn-und-Verlust-Rechnung und die Grundlage für Steuern.'),
  (230108, 'Werbung für das Unternehmen zu machen', false, null),
  (230108, 'Den Arbeitsplan der Mitarbeiter zu erstellen', false, null),
  (230108, 'Software zu entwickeln', false, null);

-- Bilanz & GuV: Was zeigt eine Bilanz?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230109, 9001, 9102, 'Was zeigt eine Bilanz?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230109, 'Vermögen (Aktiva) und Kapital bzw. Schulden (Passiva) eines Unternehmens zu einem Stichtag', true, 'Die Bilanz ist eine Momentaufnahme: links steht, was das Unternehmen hat (Aktiva), rechts, woher das Geld dafür kommt (Passiva). Beide Seiten sind immer gleich groß.'),
  (230109, 'Die Gehälter aller Mitarbeiter', false, null),
  (230109, 'Die Kundenliste des Unternehmens', false, null),
  (230109, 'Den Umsatz eines einzelnen Tages', false, null);

-- Bilanz & GuV: Wofür steht die Abkürzung GuV?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230110, 9001, 9102, 'Wofür steht die Abkürzung GuV?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230110, 'Gewinn- und Verlustrechnung', true, 'Die GuV stellt Erträge und Aufwendungen eines Zeitraums gegenüber. Bleibt mehr Ertrag übrig, ist es ein Gewinn, sonst ein Verlust.'),
  (230110, 'Geld und Vermögen', false, null),
  (230110, 'Gesamt- und Vorsteuer', false, null),
  (230110, 'Guthaben und Verbindlichkeiten', false, null);

-- Bilanz & GuV: Auf welcher Seite der Bilanz steht das Vermögen, z. B. Maschinen und Bankguthabe
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230111, 9001, 9102, 'Auf welcher Seite der Bilanz steht das Vermögen, z. B. Maschinen und Bankguthaben?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230111, 'Auf der Aktivseite (links)', true, 'Aktiva zeigen die Mittelverwendung: Anlagevermögen wie Gebäude und Maschinen, Umlaufvermögen wie Vorräte und Bankguthaben. Die Passivseite zeigt, woher das Geld stammt.'),
  (230111, 'Auf der Passivseite (rechts)', false, null),
  (230111, 'In der GuV', false, null),
  (230111, 'Auf beiden Seiten gleichzeitig', false, null);

-- Bilanz & GuV: Was bedeutet Eigenkapital?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230112, 9001, 9102, 'Was bedeutet Eigenkapital?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230112, 'Das Kapital, das die Eigentümer selbst ins Unternehmen eingebracht haben oder das als Gewinn im Unternehmen geblieben ist', true, 'Eigenkapital gehört dem Unternehmen bzw. seinen Eigentümern und muss nicht zurückgezahlt werden. Das Gegenstück ist das Fremdkapital, z. B. Bankkredite.'),
  (230112, 'Ein Kredit von der Bank', false, null),
  (230112, 'Das Gehalt des Geschäftsführers', false, null),
  (230112, 'Der Wert aller Computer im Unternehmen', false, null);

-- Bilanz & GuV: Was ist Fremdkapital?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230113, 9001, 9102, 'Was ist Fremdkapital?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230113, 'Geld, das sich das Unternehmen von anderen geliehen hat und zurückzahlen muss, z. B. ein Bankkredit', true, 'Fremdkapital sind Schulden: Kredite, offene Lieferantenrechnungen, Darlehen. Es steht auf der Passivseite der Bilanz unter „Verbindlichkeiten“.'),
  (230113, 'Das Geld der Eigentümer', false, null),
  (230113, 'Der Gewinn des letzten Jahres', false, null),
  (230113, 'Der Wert der Lagerbestände', false, null);

-- Kostenrechnung: Was sind Fixkosten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230114, 9001, 9103, 'Was sind Fixkosten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230114, 'Kosten, die unabhängig von der produzierten Menge gleich bleiben, z. B. Miete', true, 'Fixkosten fallen auch an, wenn nichts produziert wird: Miete, Gehälter, Versicherungen. Variable Kosten dagegen steigen mit jeder produzierten Einheit.'),
  (230114, 'Kosten, die mit jeder produzierten Einheit steigen', false, null),
  (230114, 'Kosten, die nur einmal im Jahr anfallen', false, null),
  (230114, 'Kosten für Werbung', false, null);

-- Kostenrechnung: Welche Kosten steigen, wenn ein Unternehmen mehr Stück produziert?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230115, 9001, 9103, 'Welche Kosten steigen, wenn ein Unternehmen mehr Stück produziert?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230115, 'Die variablen Kosten, z. B. für Material und Verpackung', true, 'Variable Kosten hängen von der Menge ab: Jedes zusätzliche Stück braucht Material und Versand. Miete und Gehälter bleiben dagegen als Fixkosten gleich.'),
  (230115, 'Die Fixkosten, z. B. die Miete', false, null),
  (230115, 'Die Kosten für die Steuerberatung', false, null),
  (230115, 'Keine, alle Kosten bleiben gleich', false, null);

-- Kostenrechnung: Was bedeutet der Begriff Selbstkosten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230116, 9001, 9103, 'Was bedeutet der Begriff Selbstkosten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230116, 'Alle Kosten, die für die Herstellung und den Vertrieb eines Produkts insgesamt anfallen', true, 'Die Selbstkosten sind die Summe aus Material-, Fertigungs-, Verwaltungs- und Vertriebskosten. Wer darunter verkauft, macht Verlust – auf die Selbstkosten kommt der Gewinnaufschlag.'),
  (230116, 'Nur die Kosten für das Material', false, null),
  (230116, 'Die Kosten, die der Chef selbst bezahlt', false, null),
  (230116, 'Der Verkaufspreis eines Produkts', false, null);

-- Kostenrechnung: Was ist der Gewinn?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230117, 9001, 9103, 'Was ist der Gewinn?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230117, 'Der Betrag, der übrig bleibt, wenn man von den Erlösen alle Kosten abzieht', true, 'Gewinn = Erlös minus Kosten. Sind die Kosten höher als der Erlös, entsteht ein Verlust.'),
  (230117, 'Der gesamte Umsatz eines Unternehmens', false, null),
  (230117, 'Der Betrag auf dem Firmenkonto', false, null),
  (230117, 'Die Summe aller Kosten', false, null);

-- Kostenrechnung: Was versteht man unter Umsatz (Erlös)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230118, 9001, 9103, 'Was versteht man unter Umsatz (Erlös)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230118, 'Die Summe aller Verkaufserlöse, also Menge mal Verkaufspreis', true, 'Der Umsatz ist das eingenommene Geld aus Verkäufen – vor Abzug der Kosten. Deshalb ist Umsatz nicht dasselbe wie Gewinn.'),
  (230118, 'Der Gewinn nach Abzug aller Kosten', false, null),
  (230118, 'Die Kosten für das Material', false, null),
  (230118, 'Das Eigenkapital des Unternehmens', false, null);

-- Steuern: Was ist der Unterschied zwischen Netto- und Bruttopreis?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230119, 9001, 9104, 'Was ist der Unterschied zwischen Netto- und Bruttopreis?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230119, 'Der Bruttopreis enthält die Umsatzsteuer, der Nettopreis nicht', true, 'Netto ist der Preis ohne Steuer, brutto der Endpreis mit Steuer. Privatkunden sehen meist Bruttopreise, Geschäftskunden rechnen netto.'),
  (230119, 'Der Nettopreis enthält die Umsatzsteuer, der Bruttopreis nicht', false, null),
  (230119, 'Netto ist der Preis mit Rabatt', false, null),
  (230119, 'Brutto ist der Einkaufspreis, netto der Verkaufspreis', false, null);

-- Steuern: Wie hoch ist der ermäßigte Umsatzsteuersatz in Deutschland, z. B. für Bücher und
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230120, 9001, 9104, 'Wie hoch ist der ermäßigte Umsatzsteuersatz in Deutschland, z. B. für Bücher und viele Lebensmittel?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230120, '7 %', true, 'Neben dem Normalsatz von 19 % gibt es den ermäßigten Satz von 7 %, z. B. für Grundnahrungsmittel, Bücher und Zeitungen.'),
  (230120, '19 %', false, null),
  (230120, '10 %', false, null),
  (230120, '3 %', false, null);

-- Steuern: Wer zahlt die Umsatzsteuer am Ende wirtschaftlich?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230121, 9001, 9104, 'Wer zahlt die Umsatzsteuer am Ende wirtschaftlich?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230121, 'Der Endverbraucher', true, 'Unternehmen reichen die Umsatzsteuer nur weiter und können gezahlte Vorsteuer abziehen. Belastet wird am Ende der private Endkunde, der die Steuer im Bruttopreis mitbezahlt.'),
  (230121, 'Der Hersteller', false, null),
  (230121, 'Das Finanzamt', false, null),
  (230121, 'Die Bank', false, null);

-- Steuern: Welche Steuer wird direkt vom Gehalt eines Arbeitnehmers einbehalten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230122, 9001, 9104, 'Welche Steuer wird direkt vom Gehalt eines Arbeitnehmers einbehalten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230122, 'Die Lohnsteuer', true, 'Die Lohnsteuer ist eine Form der Einkommensteuer, die der Arbeitgeber direkt vom Bruttogehalt abzieht und ans Finanzamt abführt.'),
  (230122, 'Die Umsatzsteuer', false, null),
  (230122, 'Die Gewerbesteuer', false, null),
  (230122, 'Die Grundsteuer', false, null);

-- Steuern: Was ist eine Rechnung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230123, 9001, 9104, 'Was ist eine Rechnung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230123, 'Ein Dokument, mit dem ein Verkäufer die Zahlung für eine Lieferung oder Leistung fordert', true, 'Die Rechnung listet Leistung, Nettobetrag, Umsatzsteuer und Bruttobetrag auf. Für den Vorsteuerabzug muss sie Pflichtangaben wie Steuernummer und Rechnungsnummer enthalten.'),
  (230123, 'Ein Vertrag über die Lieferung', false, null),
  (230123, 'Eine Quittung über Bargeld', false, null),
  (230123, 'Ein Angebot vor dem Kauf', false, null);

-- IT-Kalkulation & Investitionen: Was ist eine Investition?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230124, 9001, 9105, 'Was ist eine Investition?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230124, 'Die Ausgabe von Geld für etwas, das dem Unternehmen längerfristig nutzen soll, z. B. ein neuer Server', true, 'Investitionen sind langfristige Anschaffungen: Hardware, Software, Maschinen, Gebäude. Sie werden über mehrere Jahre genutzt und abgeschrieben.'),
  (230124, 'Die monatliche Gehaltszahlung', false, null),
  (230124, 'Der Kauf von Büromaterial', false, null),
  (230124, 'Die Zahlung der Miete', false, null);

-- IT-Kalkulation & Investitionen: Wofür steht die Abkürzung TCO?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230125, 9001, 9105, 'Wofür steht die Abkürzung TCO?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230125, 'Total Cost of Ownership – die Gesamtkosten über die gesamte Nutzungsdauer', true, 'TCO umfasst nicht nur den Kaufpreis, sondern auch Strom, Wartung, Support, Lizenzen und Schulung. Ein billiger Server kann über drei Jahre teurer sein als ein teurer.'),
  (230125, 'Technical Cost Overview', false, null),
  (230125, 'Total Company Output', false, null),
  (230125, 'Time Cost Optimization', false, null);

-- IT-Kalkulation & Investitionen: Was bedeutet Amortisation?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230126, 9001, 9105, 'Was bedeutet Amortisation?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230126, 'Der Zeitpunkt, an dem eine Investition ihre Kosten durch Einsparungen oder Erträge wieder eingespielt hat', true, 'Kostet ein Gerät 6.000 € und spart 2.000 € pro Jahr, ist es nach 3 Jahren amortisiert. Je kürzer die Amortisationszeit, desto besser.'),
  (230126, 'Die jährliche Wertminderung eines Geräts', false, null),
  (230126, 'Die Kündigung eines Wartungsvertrags', false, null),
  (230126, 'Der Rabatt beim Kauf', false, null);

-- IT-Kalkulation & Investitionen: Ein Server für 3.000 € wird 3 Jahre genutzt. Wie nennt man die 1.000 € Wertverlu
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230127, 9001, 9105, 'Ein Server für 3.000 € wird 3 Jahre genutzt. Wie nennt man die 1.000 € Wertverlust, die jedes Jahr als Kosten gebucht werden?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230127, 'Abschreibung', true, 'Die Anschaffungskosten werden auf die Nutzungsjahre verteilt: 3.000 € geteilt durch 3 Jahre ergibt 1.000 € Abschreibung pro Jahr. So erscheint der Wertverlust in jedem Jahr, nicht nur beim Kauf.'),
  (230127, 'Rabatt', false, null),
  (230127, 'Amortisation', false, null),
  (230127, 'Skonto', false, null);

-- IT-Kalkulation & Investitionen: Was ist ein Stundensatz?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230128, 9001, 9105, 'Was ist ein Stundensatz?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230128, 'Der Preis, der für eine Arbeitsstunde berechnet wird', true, 'IT-Dienstleister kalkulieren Projekte oft über den Stundensatz: 40 Stunden mal 85 € ergibt 3.400 €. Der Stundensatz muss Gehalt, Nebenkosten und Gewinn abdecken.'),
  (230128, 'Die Anzahl der Arbeitsstunden pro Woche', false, null),
  (230128, 'Der Zinssatz für einen Kredit', false, null),
  (230128, 'Die Wartezeit bei einem Support-Ticket', false, null);

-- Wirtschafts- & Rechtsgrundlagen: Was ist ein Vertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230129, 9002, 9201, 'Was ist ein Vertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230129, 'Eine Vereinbarung zwischen mindestens zwei Personen, die sich gegenseitig zu etwas verpflichten', true, 'Ein Vertrag entsteht durch zwei übereinstimmende Willenserklärungen: Angebot und Annahme. Er kann mündlich, schriftlich oder durch Handeln geschlossen werden.'),
  (230129, 'Ein Gesetz des Bundestags', false, null),
  (230129, 'Ein einseitiges Versprechen ohne Gegenleistung', false, null),
  (230129, 'Eine Rechnung über eine Lieferung', false, null);

-- Wirtschafts- & Rechtsgrundlagen: Wofür steht die Abkürzung BGB?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230130, 9002, 9201, 'Wofür steht die Abkürzung BGB?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230130, 'Bürgerliches Gesetzbuch', true, 'Das BGB regelt das Privatrecht zwischen Bürgern und Unternehmen: Verträge, Kauf, Miete, Schadensersatz, Familie und Erbe.'),
  (230130, 'Bundesgesetzbuch', false, null),
  (230130, 'Betriebsgesetz für Beschäftigte', false, null),
  (230130, 'Bürgerliche Grundordnung', false, null);

-- Wirtschafts- & Rechtsgrundlagen: Ab welchem Alter ist man in Deutschland volljährig und damit voll geschäftsfähig
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230131, 9002, 9201, 'Ab welchem Alter ist man in Deutschland volljährig und damit voll geschäftsfähig?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230131, '18 Jahre', true, 'Mit 18 Jahren ist man volljährig und darf alle Verträge selbst abschließen. Zwischen 7 und 17 Jahren ist man beschränkt geschäftsfähig.'),
  (230131, '16 Jahre', false, null),
  (230131, '21 Jahre', false, null),
  (230131, '14 Jahre', false, null);

-- Wirtschafts- & Rechtsgrundlagen: Wie nennt man die Äußerung „Ich nehme das Angebot an“ im Vertragsrecht?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230132, 9002, 9201, 'Wie nennt man die Äußerung „Ich nehme das Angebot an“ im Vertragsrecht?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230132, 'Eine Willenserklärung (Annahme)', true, 'Angebot und Annahme sind Willenserklärungen: Äußerungen, mit denen jemand eine rechtliche Folge herbeiführen will. Stimmen beide überein, ist der Vertrag geschlossen.'),
  (230132, 'Eine Mahnung', false, null),
  (230132, 'Eine Kündigung', false, null),
  (230132, 'Eine Rechnung', false, null);

-- Wirtschafts- & Rechtsgrundlagen: Was ist der Unterschied zwischen einer natürlichen und einer juristischen Person
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230133, 9002, 9201, 'Was ist der Unterschied zwischen einer natürlichen und einer juristischen Person?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230133, 'Eine natürliche Person ist ein Mensch, eine juristische Person ist z. B. eine GmbH oder ein Verein', true, 'Juristische Personen sind Organisationen, die das Recht wie eine Person behandelt: Sie können Verträge schließen, klagen und verklagt werden.'),
  (230133, 'Eine natürliche Person ist ein Kind, eine juristische ein Erwachsener', false, null),
  (230133, 'Eine juristische Person ist ein Anwalt', false, null),
  (230133, 'Es gibt keinen Unterschied', false, null);

-- Arbeits- & Tarifrecht: Wie lange dauert die gesetzliche Probezeit in einem Arbeitsverhältnis höchstens?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230134, 9002, 9202, 'Wie lange dauert die gesetzliche Probezeit in einem Arbeitsverhältnis höchstens?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230134, '6 Monate', true, 'In der Probezeit (maximal 6 Monate) gilt eine verkürzte Kündigungsfrist von 2 Wochen für beide Seiten. In der Ausbildung dauert die Probezeit 1 bis 4 Monate.'),
  (230134, '3 Monate', false, null),
  (230134, '12 Monate', false, null),
  (230134, '1 Monat', false, null);

-- Arbeits- & Tarifrecht: Was ist ein Tarifvertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230135, 9002, 9202, 'Was ist ein Tarifvertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230135, 'Eine Vereinbarung zwischen Gewerkschaft und Arbeitgeber(verband) über Löhne und Arbeitsbedingungen', true, 'Tarifverträge legen z. B. Gehalt, Arbeitszeit und Urlaub für eine ganze Branche fest. Sie gelten für Mitglieder der Gewerkschaft und des Arbeitgeberverbands.'),
  (230135, 'Ein Vertrag zwischen zwei Unternehmen', false, null),
  (230135, 'Der Arbeitsvertrag eines einzelnen Mitarbeiters', false, null),
  (230135, 'Ein Mietvertrag für Büroräume', false, null);

-- Arbeits- & Tarifrecht: Wie viele Tage Urlaub stehen einem Vollzeit-Arbeitnehmer bei einer 5-Tage-Woche 
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230136, 9002, 9202, 'Wie viele Tage Urlaub stehen einem Vollzeit-Arbeitnehmer bei einer 5-Tage-Woche gesetzlich mindestens zu?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230136, '20 Arbeitstage', true, 'Das Bundesurlaubsgesetz garantiert 24 Werktage bei einer 6-Tage-Woche, das entspricht 20 Arbeitstagen bei 5 Tagen pro Woche. Viele Tarif- und Arbeitsverträge geben mehr.'),
  (230136, '30 Arbeitstage', false, null),
  (230136, '10 Arbeitstage', false, null),
  (230136, '15 Arbeitstage', false, null);

-- Arbeits- & Tarifrecht: Was regelt der Arbeitsvertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230137, 9002, 9202, 'Was regelt der Arbeitsvertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230137, 'Die Rechte und Pflichten von Arbeitgeber und Arbeitnehmer, z. B. Tätigkeit, Gehalt und Arbeitszeit', true, 'Der Arbeitsvertrag hält fest, welche Arbeit geleistet wird, wie viel dafür gezahlt wird, wie lange gearbeitet wird und wie gekündigt werden kann.'),
  (230137, 'Die Preise der Produkte des Unternehmens', false, null),
  (230137, 'Die Regeln für Kunden im Laden', false, null),
  (230137, 'Den Ausbildungsplan der IHK', false, null);

-- Arbeits- & Tarifrecht: Was ist ein Betriebsrat?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230138, 9002, 9202, 'Was ist ein Betriebsrat?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230138, 'Die gewählte Vertretung der Arbeitnehmer in einem Betrieb', true, 'Der Betriebsrat vertritt die Interessen der Beschäftigten gegenüber dem Arbeitgeber und hat bei vielen Entscheidungen ein Mitbestimmungsrecht, z. B. bei Arbeitszeiten.'),
  (230138, 'Die Geschäftsleitung des Unternehmens', false, null),
  (230138, 'Eine Beratungsfirma für Betriebe', false, null),
  (230138, 'Das Amt, das Betriebe kontrolliert', false, null);

-- Sozialversicherung & Entgelt: Was ist der Unterschied zwischen Brutto- und Nettogehalt?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230139, 9002, 9203, 'Was ist der Unterschied zwischen Brutto- und Nettogehalt?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230139, 'Brutto ist das Gehalt vor Abzügen, netto der Betrag, der ausgezahlt wird', true, 'Vom Bruttogehalt gehen Lohnsteuer und Sozialversicherungsbeiträge ab. Was übrig bleibt, ist das Nettogehalt auf dem Konto.'),
  (230139, 'Netto ist das Gehalt vor Abzügen', false, null),
  (230139, 'Brutto ist das Gehalt inklusive Urlaubsgeld', false, null),
  (230139, 'Es gibt keinen Unterschied', false, null);

-- Sozialversicherung & Entgelt: Wer zahlt die Beiträge zur gesetzlichen Kranken-, Renten- und Arbeitslosenversic
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230140, 9002, 9203, 'Wer zahlt die Beiträge zur gesetzlichen Kranken-, Renten- und Arbeitslosenversicherung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230140, 'Arbeitnehmer und Arbeitgeber je etwa zur Hälfte', true, 'Die Sozialversicherungsbeiträge werden paritätisch geteilt: Der Arbeitnehmer zahlt seinen Anteil vom Brutto, der Arbeitgeber legt seinen Anteil obendrauf. Ausnahme: die Unfallversicherung zahlt der Arbeitgeber allein.'),
  (230140, 'Nur der Arbeitnehmer', false, null),
  (230140, 'Nur der Arbeitgeber', false, null),
  (230140, 'Der Staat', false, null);

-- Sozialversicherung & Entgelt: Wofür ist die gesetzliche Krankenversicherung zuständig?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230141, 9002, 9203, 'Wofür ist die gesetzliche Krankenversicherung zuständig?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230141, 'Für die Kosten von Arztbesuchen, Medikamenten und Krankenhausaufenthalten', true, 'Die Krankenversicherung übernimmt die medizinische Versorgung und zahlt nach sechs Wochen Krankheit das Krankengeld.'),
  (230141, 'Für die Rente im Alter', false, null),
  (230141, 'Für das Arbeitslosengeld', false, null),
  (230141, 'Für Unfälle auf dem Arbeitsweg', false, null);

-- Sozialversicherung & Entgelt: Was ist eine Gehaltsabrechnung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230142, 9002, 9203, 'Was ist eine Gehaltsabrechnung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230142, 'Ein Dokument, das zeigt, wie sich das Gehalt aus Brutto, Abzügen und Netto zusammensetzt', true, 'Die Gehaltsabrechnung listet Bruttogehalt, Lohnsteuer, Sozialversicherungsbeiträge und den Auszahlungsbetrag auf. Der Arbeitgeber muss sie jeden Monat aushändigen.'),
  (230142, 'Der Arbeitsvertrag', false, null),
  (230142, 'Die Steuererklärung des Arbeitnehmers', false, null),
  (230142, 'Der Kontoauszug der Bank', false, null);

-- Sozialversicherung & Entgelt: Welche Versicherung zahlt, wenn jemand nach Verlust der Arbeit vorübergehend kei
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230143, 9002, 9203, 'Welche Versicherung zahlt, wenn jemand nach Verlust der Arbeit vorübergehend kein Einkommen hat?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230143, 'Die Arbeitslosenversicherung', true, 'Wer mindestens 12 Monate versicherungspflichtig gearbeitet hat, bekommt bei Arbeitslosigkeit Arbeitslosengeld I von der Agentur für Arbeit.'),
  (230143, 'Die Krankenversicherung', false, null),
  (230143, 'Die Rentenversicherung', false, null),
  (230143, 'Die Haftpflichtversicherung', false, null);

-- Unternehmensformen & Verträge: Wofür steht die Abkürzung GmbH?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230144, 9002, 9204, 'Wofür steht die Abkürzung GmbH?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230144, 'Gesellschaft mit beschränkter Haftung', true, 'Bei der GmbH haftet nur das Gesellschaftsvermögen, nicht das Privatvermögen der Gesellschafter. Das Mindeststammkapital beträgt 25.000 €.'),
  (230144, 'Gemeinschaft mit beschränkter Handlung', false, null),
  (230144, 'Gesellschaft mit besonderer Haftung', false, null),
  (230144, 'Großes mittelständisches Betriebshaus', false, null);

-- Unternehmensformen & Verträge: Wofür steht die Abkürzung AG?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230145, 9002, 9204, 'Wofür steht die Abkürzung AG?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230145, 'Aktiengesellschaft', true, 'Das Kapital einer AG ist in Aktien aufgeteilt, die an der Börse gehandelt werden können. Das Mindestgrundkapital beträgt 50.000 €.'),
  (230145, 'Arbeitsgemeinschaft', false, null),
  (230145, 'Allgemeine Gesellschaft', false, null),
  (230145, 'Angestellten-Gruppe', false, null);

-- Unternehmensformen & Verträge: Wie haftet ein Einzelunternehmer für die Schulden seines Unternehmens?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230146, 9002, 9204, 'Wie haftet ein Einzelunternehmer für die Schulden seines Unternehmens?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230146, 'Unbeschränkt, auch mit seinem Privatvermögen', true, 'Der Einzelunternehmer und sein Unternehmen sind rechtlich eine Einheit. Geht das Geschäft pleite, kann auch das private Haus oder Auto herangezogen werden.'),
  (230146, 'Nur mit dem Geschäftsvermögen', false, null),
  (230146, 'Gar nicht, das Unternehmen haftet', false, null),
  (230146, 'Nur bis 25.000 €', false, null);

-- Unternehmensformen & Verträge: Welche zwei Pflichten hat der Käufer bei einem Kaufvertrag?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230147, 9002, 9204, 'Welche zwei Pflichten hat der Käufer bei einem Kaufvertrag?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230147, 'Den Kaufpreis zahlen und die Ware abnehmen', true, 'Der Käufer muss bezahlen und die Sache annehmen; der Verkäufer muss die Sache übergeben und das Eigentum übertragen. Das steht in § 433 BGB.'),
  (230147, 'Die Ware liefern und Garantie geben', false, null),
  (230147, 'Die Ware bewerben und versichern', false, null),
  (230147, 'Die Rechnung schreiben und versenden', false, null);

-- Unternehmensformen & Verträge: Was ist das Handelsregister?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230148, 9002, 9204, 'Was ist das Handelsregister?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230148, 'Ein öffentliches Verzeichnis, in dem Kaufleute und Unternehmen mit wichtigen Daten eingetragen sind', true, 'Im Handelsregister stehen Firma, Sitz, Geschäftsführer und Haftungsform. Jeder kann es online einsehen, um zu prüfen, mit wem er Geschäfte macht.'),
  (230148, 'Eine Liste aller Produkte eines Unternehmens', false, null),
  (230148, 'Das Kassenbuch eines Händlers', false, null),
  (230148, 'Ein Verzeichnis der Mitarbeiter', false, null);

-- IT-Recht & Datenschutz: Wofür steht die Abkürzung DSGVO?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230149, 9002, 9205, 'Wofür steht die Abkürzung DSGVO?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230149, 'Datenschutz-Grundverordnung', true, 'Die DSGVO ist das EU-weite Datenschutzgesetz. Sie regelt, wie personenbezogene Daten erhoben, gespeichert und verarbeitet werden dürfen.'),
  (230149, 'Datensicherheits-Grundverordnung', false, null),
  (230149, 'Deutsche Software-Gesetzesverordnung', false, null),
  (230149, 'Digitale Service-Grundversorgung', false, null);

-- IT-Recht & Datenschutz: Was sind personenbezogene Daten?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230150, 9002, 9205, 'Was sind personenbezogene Daten?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230150, 'Alle Informationen, die sich auf eine bestimmte oder bestimmbare Person beziehen, z. B. Name oder E-Mail-Adresse', true, 'Name, Adresse, Geburtsdatum, IP-Adresse, Kundennummer: alles, was einer Person zugeordnet werden kann, fällt unter den Datenschutz.'),
  (230150, 'Nur Passwörter', false, null),
  (230150, 'Daten über Unternehmen', false, null),
  (230150, 'Anonyme Statistiken', false, null);

-- IT-Recht & Datenschutz: Wer ist in einem Unternehmen Ansprechpartner für Datenschutzfragen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230151, 9002, 9205, 'Wer ist in einem Unternehmen Ansprechpartner für Datenschutzfragen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230151, 'Der Datenschutzbeauftragte', true, 'Der Datenschutzbeauftragte überwacht die Einhaltung der DSGVO, berät das Unternehmen und ist Ansprechpartner für Betroffene und Behörden. Pflicht ist er meist ab 20 Beschäftigten mit Datenverarbeitung.'),
  (230151, 'Der Betriebsrat', false, null),
  (230151, 'Der Steuerberater', false, null),
  (230151, 'Der Hausmeister', false, null);

-- IT-Recht & Datenschutz: Was regelt das Urheberrecht?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230152, 9002, 9205, 'Was regelt das Urheberrecht?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230152, 'Wem ein geistiges Werk gehört, z. B. Software, Texte, Musik oder Fotos', true, 'Der Urheber entscheidet, wer sein Werk nutzen, kopieren oder verändern darf. Software ist urheberrechtlich geschützt – deshalb braucht man Lizenzen.'),
  (230152, 'Den Schutz personenbezogener Daten', false, null),
  (230152, 'Die Haftung bei Unfällen', false, null),
  (230152, 'Die Preise für Software', false, null);

-- IT-Recht & Datenschutz: Was ist eine Software-Lizenz?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230153, 9002, 9205, 'Was ist eine Software-Lizenz?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230153, 'Die Erlaubnis des Rechteinhabers, eine Software unter bestimmten Bedingungen zu nutzen', true, 'Mit dem Kauf einer Software erwirbt man meist nicht die Software selbst, sondern nur das Nutzungsrecht. Die Lizenz legt fest, wie viele Geräte, Nutzer oder Jahre erlaubt sind.'),
  (230153, 'Der Quellcode der Software', false, null),
  (230153, 'Ein Zertifikat für den Programmierer', false, null),
  (230153, 'Die Garantie des Herstellers', false, null);

-- Relationale Grundlagen: Wie nennt man das Programm, das eine Datenbank verwaltet, z. B. MySQL oder Postg
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230154, 9003, 9301, 'Wie nennt man das Programm, das eine Datenbank verwaltet, z. B. MySQL oder PostgreSQL?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230154, 'Datenbankmanagementsystem (DBMS)', true, 'Das DBMS speichert die Daten, prüft Zugriffsrechte, führt SQL-Befehle aus und sorgt dafür, dass mehrere Nutzer gleichzeitig arbeiten können.'),
  (230154, 'Betriebssystem', false, null),
  (230154, 'Webbrowser', false, null),
  (230154, 'Compiler', false, null);

-- Relationale Grundlagen: Woraus besteht eine Tabelle in einer relationalen Datenbank?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230155, 9003, 9301, 'Woraus besteht eine Tabelle in einer relationalen Datenbank?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230155, 'Aus Zeilen (Datensätzen) und Spalten (Attributen)', true, 'Jede Zeile ist ein Datensatz, z. B. ein Kunde. Jede Spalte ist eine Eigenschaft, z. B. Name oder E-Mail. Alle Zeilen einer Tabelle haben dieselben Spalten.'),
  (230155, 'Aus Dateien und Ordnern', false, null),
  (230155, 'Aus Bildern und Texten', false, null),
  (230155, 'Aus Servern und Clients', false, null);

-- Relationale Grundlagen: Wofür steht die Abkürzung SQL?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230156, 9003, 9301, 'Wofür steht die Abkürzung SQL?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230156, 'Structured Query Language – die Abfragesprache für relationale Datenbanken', true, 'Mit SQL werden Daten abgefragt (SELECT), eingefügt (INSERT), geändert (UPDATE) und gelöscht (DELETE). Fast alle relationalen Datenbanken verstehen SQL.'),
  (230156, 'Simple Question Language', false, null),
  (230156, 'System Query Log', false, null),
  (230156, 'Secure Quick Login', false, null);

-- Relationale Grundlagen: Was ist ein Fremdschlüssel?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230157, 9003, 9301, 'Was ist ein Fremdschlüssel?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230157, 'Eine Spalte, die auf den Primärschlüssel einer anderen Tabelle verweist', true, 'Der Fremdschlüssel verbindet Tabellen: In der Tabelle „Bestellung“ zeigt die Spalte kunden_id auf den Primärschlüssel der Tabelle „Kunde“.'),
  (230157, 'Das Passwort für die Datenbank', false, null),
  (230157, 'Ein Schlüssel, der von außen kommt', false, null),
  (230157, 'Die erste Spalte jeder Tabelle', false, null);

-- Relationale Grundlagen: Welche der folgenden Datenbanken ist ein bekanntes relationales Datenbanksystem?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230158, 9003, 9301, 'Welche der folgenden Datenbanken ist ein bekanntes relationales Datenbanksystem?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230158, 'MySQL', true, 'MySQL, PostgreSQL, Microsoft SQL Server und Oracle sind relationale Datenbanksysteme, die mit Tabellen und SQL arbeiten. Excel ist eine Tabellenkalkulation, keine Datenbank.'),
  (230158, 'Excel', false, null),
  (230158, 'Photoshop', false, null),
  (230158, 'Windows', false, null);

-- SQL Vertieft: Was macht ein JOIN in SQL?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230159, 9003, 9303, 'Was macht ein JOIN in SQL?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230159, 'Er verknüpft Zeilen aus zwei oder mehr Tabellen über eine gemeinsame Spalte', true, 'Mit JOIN holt man z. B. zu jeder Bestellung den Kundennamen aus der Kundentabelle, indem man beide über kunden_id verbindet.'),
  (230159, 'Er löscht doppelte Zeilen', false, null),
  (230159, 'Er sortiert das Ergebnis', false, null),
  (230159, 'Er erstellt eine neue Tabelle', false, null);

-- SQL Vertieft: Welche SQL-Funktion berechnet die Summe einer Spalte?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230160, 9003, 9303, 'Welche SQL-Funktion berechnet die Summe einer Spalte?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230160, 'SUM()', true, 'SUM(preis) addiert alle Werte der Spalte. Weitere Aggregatfunktionen sind COUNT, AVG, MIN und MAX.'),
  (230160, 'ADD()', false, null),
  (230160, 'TOTAL()', false, null),
  (230160, 'PLUS()', false, null);

-- SQL Vertieft: Welche SQL-Funktion berechnet den Durchschnitt einer Spalte?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230161, 9003, 9303, 'Welche SQL-Funktion berechnet den Durchschnitt einer Spalte?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230161, 'AVG()', true, 'AVG(gehalt) liefert den Mittelwert aller Werte. Kombiniert mit GROUP BY bekommt man z. B. den Durchschnitt je Abteilung.'),
  (230161, 'MEAN()', false, null),
  (230161, 'MID()', false, null),
  (230161, 'MEDIAN()', false, null);

-- SQL Vertieft: Welche SQL-Klausel fasst Zeilen mit gleichem Wert zu Gruppen zusammen, z. B. all
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230162, 9003, 9303, 'Welche SQL-Klausel fasst Zeilen mit gleichem Wert zu Gruppen zusammen, z. B. alle Bestellungen je Kunde?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230162, 'GROUP BY', true, 'GROUP BY kunde_id bildet je Kunde eine Gruppe, sodass COUNT oder SUM pro Kunde berechnet werden. ORDER BY sortiert nur, WHERE filtert einzelne Zeilen.'),
  (230162, 'ORDER BY', false, null),
  (230162, 'WHERE', false, null),
  (230162, 'JOIN', false, null);

-- SQL Vertieft: Was liefert die SQL-Funktion MAX(preis)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230163, 9003, 9303, 'Was liefert die SQL-Funktion MAX(preis)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230163, 'Den höchsten Wert in der Spalte preis', true, 'MAX gibt den größten, MIN den kleinsten Wert einer Spalte zurück – z. B. das teuerste Produkt.'),
  (230163, 'Die Anzahl der Zeilen', false, null),
  (230163, 'Die Summe aller Preise', false, null),
  (230163, 'Den zuletzt eingefügten Preis', false, null);

-- Design & Normalisierung: Was ist das Ziel eines Datenbankentwurfs?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230164, 9003, 9304, 'Was ist das Ziel eines Datenbankentwurfs?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230164, 'Die Daten so in Tabellen aufzuteilen, dass sie ohne Widersprüche und Doppelungen gespeichert werden', true, 'Ein guter Entwurf legt fest, welche Tabellen es gibt, welche Spalten sie haben und wie sie zusammenhängen. So wird jede Information nur einmal gespeichert.'),
  (230164, 'Möglichst alle Daten in eine Tabelle zu packen', false, null),
  (230164, 'Die Datenbank möglichst groß zu machen', false, null),
  (230164, 'Jede Spalte in einer eigenen Tabelle zu speichern', false, null);

-- Design & Normalisierung: Was bedeutet Redundanz in einer Datenbank?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230165, 9003, 9304, 'Was bedeutet Redundanz in einer Datenbank?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230165, 'Dieselbe Information ist mehrfach gespeichert', true, 'Steht die Kundenadresse in jeder Bestellzeile, ist sie redundant. Ändert sich die Adresse, muss man sie überall ändern – ein Fehlerrisiko. Normalisierung beseitigt Redundanz.'),
  (230165, 'Die Datenbank ist leer', false, null),
  (230165, 'Eine Tabelle hat keinen Primärschlüssel', false, null),
  (230165, 'Die Daten sind verschlüsselt', false, null);

-- Design & Normalisierung: Wofür steht die Abkürzung ERM bzw. ER-Modell?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230166, 9003, 9304, 'Wofür steht die Abkürzung ERM bzw. ER-Modell?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230166, 'Entity-Relationship-Modell – ein Diagramm, das Objekte und ihre Beziehungen zeigt', true, 'Im ER-Modell werden Entitäten (z. B. Kunde, Bestellung) als Rechtecke und ihre Beziehungen als Linien oder Rauten dargestellt. Es ist die Skizze vor dem Tabellenentwurf.'),
  (230166, 'Error-Report-Modell', false, null),
  (230166, 'Einfaches Relationales Modell', false, null),
  (230166, 'Extern-Remote-Modell', false, null);

-- Design & Normalisierung: Was ist eine Entität im Datenbankentwurf?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230167, 9003, 9304, 'Was ist eine Entität im Datenbankentwurf?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230167, 'Ein Objekt der realen Welt, über das Daten gespeichert werden, z. B. ein Kunde', true, 'Entitäten werden später zu Tabellen: Kunde, Produkt, Bestellung. Ihre Eigenschaften (Attribute) werden zu Spalten.'),
  (230167, 'Eine SQL-Abfrage', false, null),
  (230167, 'Der Name der Datenbank', false, null),
  (230167, 'Ein Passwort', false, null);

-- Design & Normalisierung: Was beschreibt eine 1:n-Beziehung?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230168, 9003, 9304, 'Was beschreibt eine 1:n-Beziehung?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230168, 'Ein Datensatz der einen Tabelle gehört zu vielen Datensätzen der anderen, z. B. ein Kunde hat viele Bestellungen', true, '1:n ist die häufigste Beziehung: Ein Kunde kann viele Bestellungen haben, aber jede Bestellung gehört zu genau einem Kunden.'),
  (230168, 'Jeder Datensatz gehört zu genau einem anderen', false, null),
  (230168, 'Viele Datensätze gehören zu vielen anderen', false, null),
  (230168, 'Eine Tabelle hat nur eine Spalte', false, null);

-- Transaktionen & Indexe: Was ist eine Transaktion in einer Datenbank?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230169, 9003, 9305, 'Was ist eine Transaktion in einer Datenbank?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230169, 'Eine Folge von Datenbankoperationen, die entweder ganz oder gar nicht ausgeführt wird', true, 'Beispiel Überweisung: Geld abbuchen und gutschreiben müssen zusammen gelingen. Schlägt ein Schritt fehl, wird alles zurückgerollt (ROLLBACK).'),
  (230169, 'Eine einzelne SELECT-Abfrage', false, null),
  (230169, 'Die Sicherung der Datenbank', false, null),
  (230169, 'Der Wechsel zu einer anderen Datenbank', false, null);

-- Transaktionen & Indexe: Mit welchem SQL-Befehl wird eine Transaktion erfolgreich abgeschlossen?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230170, 9003, 9305, 'Mit welchem SQL-Befehl wird eine Transaktion erfolgreich abgeschlossen?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230170, 'COMMIT', true, 'COMMIT macht alle Änderungen der Transaktion dauerhaft. ROLLBACK verwirft sie stattdessen.'),
  (230170, 'ROLLBACK', false, null),
  (230170, 'SAVE', false, null),
  (230170, 'FINISH', false, null);

-- Transaktionen & Indexe: Mit welchem SQL-Befehl macht man die Änderungen einer Transaktion rückgängig?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230171, 9003, 9305, 'Mit welchem SQL-Befehl macht man die Änderungen einer Transaktion rückgängig?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230171, 'ROLLBACK', true, 'ROLLBACK setzt die Datenbank auf den Stand vor Beginn der Transaktion zurück. Das schützt vor halbfertigen Änderungen bei Fehlern.'),
  (230171, 'COMMIT', false, null),
  (230171, 'UNDO', false, null),
  (230171, 'DELETE', false, null);

-- Transaktionen & Indexe: Wofür ist ein Index in einer Datenbank gut?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230172, 9003, 9305, 'Wofür ist ein Index in einer Datenbank gut?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230172, 'Er beschleunigt die Suche nach Werten in einer Spalte', true, 'Ein Index funktioniert wie das Stichwortverzeichnis eines Buchs: Statt alle Zeilen zu lesen, springt die Datenbank direkt zum passenden Eintrag.'),
  (230172, 'Er verschlüsselt die Daten', false, null),
  (230172, 'Er löscht doppelte Zeilen', false, null),
  (230172, 'Er sichert die Datenbank', false, null);

-- Transaktionen & Indexe: Wofür steht die Abkürzung ACID bei Datenbanken?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230173, 9003, 9305, 'Wofür steht die Abkürzung ACID bei Datenbanken?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230173, 'Atomicity, Consistency, Isolation, Durability – die vier Eigenschaften zuverlässiger Transaktionen', true, 'ACID garantiert: alles oder nichts (Atomarität), gültiger Zustand (Konsistenz), Transaktionen stören sich nicht (Isolation), Ergebnisse bleiben erhalten (Dauerhaftigkeit).'),
  (230173, 'Access, Control, Insert, Delete', false, null),
  (230173, 'Automatic Cache Index Data', false, null),
  (230173, 'Advanced Column Integrity Design', false, null);

-- Dateien & Berechtigungen: Welche drei Grundrechte gibt es für Dateien unter Linux?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230174, 9005, 9503, 'Welche drei Grundrechte gibt es für Dateien unter Linux?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230174, 'Lesen (r), Schreiben (w) und Ausführen (x)', true, 'Jede Datei hat Rechte für Besitzer, Gruppe und alle anderen, jeweils aus r (read), w (write) und x (execute). In „ls -l“ sieht das z. B. so aus: rwxr-xr--.'),
  (230174, 'Öffnen, Speichern, Drucken', false, null),
  (230174, 'Kopieren, Verschieben, Löschen', false, null),
  (230174, 'Anzeigen, Bearbeiten, Teilen', false, null);

-- Dateien & Berechtigungen: Mit welchem Befehl ändert man unter Linux die Zugriffsrechte einer Datei?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230175, 9005, 9503, 'Mit welchem Befehl ändert man unter Linux die Zugriffsrechte einer Datei?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230175, 'chmod', true, 'chmod (change mode) setzt die Rechte, z. B. „chmod 755 script.sh“. Den Besitzer ändert man mit chown.'),
  (230175, 'chown', false, null),
  (230175, 'rights', false, null),
  (230175, 'perm', false, null);

-- Dateien & Berechtigungen: Mit welchem Befehl kopiert man unter Linux eine Datei?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230176, 9005, 9503, 'Mit welchem Befehl kopiert man unter Linux eine Datei?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230176, 'cp', true, '„cp quelle.txt ziel.txt“ kopiert die Datei. Zum Verschieben oder Umbenennen dient mv, zum Löschen rm.'),
  (230176, 'mv', false, null),
  (230176, 'copy', false, null),
  (230176, 'cat', false, null);

-- Dateien & Berechtigungen: Was ist unter Linux das Root-Verzeichnis?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230177, 9005, 9503, 'Was ist unter Linux das Root-Verzeichnis?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230177, 'Das oberste Verzeichnis des Dateisystems, geschrieben als „/“', true, 'Alle Verzeichnisse hängen unter „/“: /home, /etc, /var, /usr. Nicht zu verwechseln mit dem Benutzer root, dessen Home-Verzeichnis /root ist.'),
  (230177, 'Das Home-Verzeichnis des angemeldeten Nutzers', false, null),
  (230177, 'Der Papierkorb', false, null),
  (230177, 'Das Verzeichnis für Programme', false, null);

-- Dateien & Berechtigungen: Mit welchem Befehl erstellt man unter Linux ein neues Verzeichnis?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230178, 9005, 9503, 'Mit welchem Befehl erstellt man unter Linux ein neues Verzeichnis?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230178, 'mkdir', true, '„mkdir projekte“ legt den Ordner „projekte“ an. Mit „mkdir -p a/b/c“ werden alle Zwischenverzeichnisse gleich mit angelegt.'),
  (230178, 'newdir', false, null),
  (230178, 'touch', false, null),
  (230178, 'md', false, null);

-- Prozesse & Systemdienste: Was ist ein Prozess?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230179, 9005, 9504, 'Was ist ein Prozess?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230179, 'Ein Programm, das gerade ausgeführt wird', true, 'Sobald ein Programm gestartet wird, entsteht ein Prozess mit eigener Prozess-ID (PID), Speicher und Zustand. Ein Programm kann mehrfach als Prozess laufen.'),
  (230179, 'Eine Datei auf der Festplatte', false, null),
  (230179, 'Ein Benutzerkonto', false, null),
  (230179, 'Ein Netzwerkkabel', false, null);

-- Prozesse & Systemdienste: Wofür steht die Abkürzung PID?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230180, 9005, 9504, 'Wofür steht die Abkürzung PID?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230180, 'Process ID – die eindeutige Nummer eines laufenden Prozesses', true, 'Jeder Prozess bekommt vom Kernel eine PID. Mit ihr kann man den Prozess z. B. per „kill PID“ beenden.'),
  (230180, 'Program Install Directory', false, null),
  (230180, 'Personal Identification Data', false, null),
  (230180, 'Primary Interface Device', false, null);

-- Prozesse & Systemdienste: Mit welchem Befehl beendet man unter Linux einen Prozess über seine PID?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230181, 9005, 9504, 'Mit welchem Befehl beendet man unter Linux einen Prozess über seine PID?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230181, 'kill', true, '„kill 1234“ sendet dem Prozess mit der PID 1234 ein Beenden-Signal. Mit „kill -9“ wird er notfalls hart abgebrochen.'),
  (230181, 'stop', false, null),
  (230181, 'end', false, null),
  (230181, 'exit', false, null);

-- Prozesse & Systemdienste: Was ist ein Dienst (Service oder Daemon) unter Linux?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230182, 9005, 9504, 'Was ist ein Dienst (Service oder Daemon) unter Linux?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230182, 'Ein Programm, das dauerhaft im Hintergrund läuft, z. B. ein Webserver', true, 'Dienste starten meist beim Hochfahren und warten auf Anfragen: sshd für SSH, nginx für Webseiten, cron für Zeitpläne. Unter Linux heißen sie oft Daemon (Endung „d“).'),
  (230182, 'Ein Programm mit grafischer Oberfläche', false, null),
  (230182, 'Ein Benutzer mit besonderen Rechten', false, null),
  (230182, 'Eine Konfigurationsdatei', false, null);

-- Prozesse & Systemdienste: Mit welchem Befehl zeigt man unter Linux eine Liste der laufenden Prozesse an?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230183, 9005, 9504, 'Mit welchem Befehl zeigt man unter Linux eine Liste der laufenden Prozesse an?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230183, 'ps', true, '„ps aux“ listet alle Prozesse mit PID, Nutzer und Befehl auf. Für eine laufend aktualisierte Ansicht nutzt man top oder htop.'),
  (230183, 'ls', false, null),
  (230183, 'dir', false, null),
  (230183, 'proc', false, null);

-- Security & Scripting (Adv.): Wie heißt der Benutzer mit uneingeschränkten Rechten unter Linux?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230184, 9005, 9505, 'Wie heißt der Benutzer mit uneingeschränkten Rechten unter Linux?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230184, 'root', true, 'root darf alles: Dateien anderer Nutzer lesen, Software installieren, das System herunterfahren. Deshalb arbeitet man im Alltag nicht als root, sondern nutzt sudo.'),
  (230184, 'admin', false, null),
  (230184, 'superuser', false, null),
  (230184, 'master', false, null);

-- Security & Scripting (Adv.): Wozu dient der Befehl sudo?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230185, 9005, 9505, 'Wozu dient der Befehl sudo?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230185, 'Er führt einen einzelnen Befehl mit Administratorrechten aus', true, '„sudo apt update“ führt den Befehl als root aus, ohne dass man sich dauerhaft als root anmeldet. Das ist sicherer, weil normale Befehle ohne Rechte laufen.'),
  (230185, 'Er wechselt das Verzeichnis', false, null),
  (230185, 'Er zeigt die Systemzeit an', false, null),
  (230185, 'Er startet das System neu', false, null);

-- Security & Scripting (Adv.): Wofür wird SSH verwendet?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230186, 9005, 9505, 'Wofür wird SSH verwendet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230186, 'Für den verschlüsselten Fernzugriff auf die Kommandozeile eines anderen Rechners', true, 'Mit „ssh nutzer@server“ verbindet man sich sicher mit einem entfernten Linux-Server und arbeitet dort, als säße man davor. Der Standardport ist 22.'),
  (230186, 'Für die Anzeige von Webseiten', false, null),
  (230186, 'Für den Versand von E-Mails', false, null),
  (230186, 'Für das Drucken im Netzwerk', false, null);

-- Security & Scripting (Adv.): Was ist ein Shell-Skript?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230187, 9005, 9505, 'Was ist ein Shell-Skript?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230187, 'Eine Textdatei mit einer Folge von Befehlen, die die Shell nacheinander ausführt', true, 'Statt zehn Befehle jeden Tag von Hand zu tippen, schreibt man sie in ein Skript wie backup.sh und startet es mit einem Aufruf. Meist beginnt es mit #!/bin/bash.'),
  (230187, 'Ein Programm mit grafischer Oberfläche', false, null),
  (230187, 'Eine Konfigurationsdatei des Kernels', false, null),
  (230187, 'Ein Passwort-Manager', false, null);

-- Security & Scripting (Adv.): Mit welchem Befehl ändert man unter Linux das eigene Passwort?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230188, 9005, 9505, 'Mit welchem Befehl ändert man unter Linux das eigene Passwort?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230188, 'passwd', true, '„passwd“ fragt das alte und zweimal das neue Passwort ab. Als root kann man mit „passwd nutzername“ das Passwort anderer Nutzer setzen.'),
  (230188, 'password', false, null),
  (230188, 'chpass', false, null),
  (230188, 'setpw', false, null);

-- Storage & Dateisysteme: Wofür steht die Abkürzung SSD?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230189, 9006, 9602, 'Wofür steht die Abkürzung SSD?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230189, 'Solid State Drive – ein Speicherlaufwerk ohne bewegliche Teile', true, 'SSDs speichern Daten in Flash-Chips. Sie sind viel schneller, leiser und stoßfester als klassische Festplatten (HDD) mit rotierenden Scheiben.'),
  (230189, 'Super Speed Disk', false, null),
  (230189, 'Secure Storage Device', false, null),
  (230189, 'System Software Drive', false, null);

-- Storage & Dateisysteme: Wofür steht die Abkürzung HDD?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230190, 9006, 9602, 'Wofür steht die Abkürzung HDD?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230190, 'Hard Disk Drive – eine klassische Festplatte mit rotierenden Magnetscheiben', true, 'HDDs speichern Daten magnetisch auf drehenden Scheiben, die ein Schreib-Lese-Kopf abtastet. Sie bieten viel Speicher zum günstigen Preis, sind aber langsamer als SSDs.'),
  (230190, 'High Density Data', false, null),
  (230190, 'Hardware Disk Device', false, null),
  (230190, 'Home Data Drive', false, null);

-- Storage & Dateisysteme: Was bedeutet es, einen Datenträger zu formatieren?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230191, 9006, 9602, 'Was bedeutet es, einen Datenträger zu formatieren?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230191, 'Ihn mit einem Dateisystem vorzubereiten, damit Daten gespeichert werden können', true, 'Beim Formatieren wird ein Dateisystem wie NTFS, ext4 oder FAT32 angelegt. Vorhandene Daten gehen dabei in der Regel verloren.'),
  (230191, 'Ihn physisch zu reinigen', false, null),
  (230191, 'Seine Größe zu verdoppeln', false, null),
  (230191, 'Ihn mit einem Passwort zu schützen', false, null);

-- Storage & Dateisysteme: Welches Dateisystem verwendet Windows standardmäßig für die Systemfestplatte?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230192, 9006, 9602, 'Welches Dateisystem verwendet Windows standardmäßig für die Systemfestplatte?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230192, 'NTFS', true, 'NTFS unterstützt große Dateien, Zugriffsrechte und Journaling. FAT32 wird noch für USB-Sticks genutzt, ext4 ist das Standard-Dateisystem unter Linux.'),
  (230192, 'ext4', false, null),
  (230192, 'FAT16', false, null),
  (230192, 'HFS+', false, null);

-- Storage & Dateisysteme: Welcher RAID-Level verteilt Daten nur auf mehrere Platten für mehr Geschwindigke
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230193, 9006, 9602, 'Welcher RAID-Level verteilt Daten nur auf mehrere Platten für mehr Geschwindigkeit, ohne Schutz vor Ausfall?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230193, 'RAID 0', true, 'RAID 0 (Striping) schreibt abwechselnd auf alle Platten, ist schnell, aber fällt eine Platte aus, sind alle Daten weg. RAID 1 spiegelt, RAID 5 nutzt Parität.'),
  (230193, 'RAID 1', false, null),
  (230193, 'RAID 5', false, null),
  (230193, 'RAID 10', false, null);

-- RAM & Performance: Wofür steht die Abkürzung RAM?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230194, 9006, 9603, 'Wofür steht die Abkürzung RAM?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230194, 'Random Access Memory – der Arbeitsspeicher des Computers', true, 'Im RAM liegen die Daten, mit denen der Prozessor gerade arbeitet. Er ist sehr schnell, verliert seinen Inhalt aber beim Ausschalten.'),
  (230194, 'Read And Modify', false, null),
  (230194, 'Rapid Application Module', false, null),
  (230194, 'Remote Access Memory', false, null);

-- RAM & Performance: Was passiert mit den Daten im Arbeitsspeicher, wenn der Computer ausgeschaltet w
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230195, 9006, 9603, 'Was passiert mit den Daten im Arbeitsspeicher, wenn der Computer ausgeschaltet wird?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230195, 'Sie gehen verloren, weil RAM flüchtig ist', true, 'RAM braucht Strom, um Daten zu halten. Deshalb muss alles Wichtige vor dem Ausschalten auf SSD oder Festplatte gespeichert werden.'),
  (230195, 'Sie bleiben dauerhaft erhalten', false, null),
  (230195, 'Sie werden automatisch auf die Festplatte kopiert', false, null),
  (230195, 'Sie werden verschlüsselt', false, null);

-- RAM & Performance: Welche Einheit ist größer: 1 Gigabyte oder 1 Megabyte?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230196, 9006, 9603, 'Welche Einheit ist größer: 1 Gigabyte oder 1 Megabyte?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230196, '1 Gigabyte (1 GB = 1.000 MB bzw. 1.024 MB)', true, 'Die Reihenfolge lautet Byte, Kilobyte, Megabyte, Gigabyte, Terabyte – jede Stufe ist rund tausendmal größer. 8 GB RAM sind also 8.000 MB.'),
  (230196, '1 Megabyte', false, null),
  (230196, 'Beide sind gleich groß', false, null),
  (230196, 'Das hängt vom Computer ab', false, null);

-- RAM & Performance: Was ist der Cache eines Prozessors?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230197, 9006, 9603, 'Was ist der Cache eines Prozessors?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230197, 'Ein sehr schneller, kleiner Zwischenspeicher direkt im Prozessor', true, 'Der CPU-Cache (L1, L2, L3) hält häufig gebrauchte Daten bereit, damit der Prozessor nicht auf den langsameren RAM warten muss.'),
  (230197, 'Der Lüfter des Prozessors', false, null),
  (230197, 'Der Speicher auf der Festplatte', false, null),
  (230197, 'Ein Programm zum Reinigen des Systems', false, null);

-- RAM & Performance: Was bedeutet es, wenn ein Prozessor 4 Kerne hat?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230198, 9006, 9603, 'Was bedeutet es, wenn ein Prozessor 4 Kerne hat?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230198, 'Er kann vier Aufgaben gleichzeitig bearbeiten', true, 'Jeder Kern ist eine eigene Recheneinheit. Mehr Kerne helfen, wenn viele Programme parallel laufen oder ein Programm Arbeit auf mehrere Threads verteilt.'),
  (230198, 'Er hat vier Lüfter', false, null),
  (230198, 'Er ist viermal so alt', false, null),
  (230198, 'Er braucht vier Netzteile', false, null);

-- Virtualisierung & Cloud: Was ist eine virtuelle Maschine (VM)?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230199, 9006, 9604, 'Was ist eine virtuelle Maschine (VM)?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230199, 'Ein per Software nachgebildeter Computer, der auf einem echten Computer läuft', true, 'Eine VM hat eigenes Betriebssystem, eigenen Speicher und eigene Festplatte, teilt sich aber die Hardware mit dem Host. So laufen z. B. Linux und Windows gleichzeitig auf einem PC.'),
  (230199, 'Ein Computer ohne Festplatte', false, null),
  (230199, 'Ein Computer, der über das Internet gesteuert wird', false, null),
  (230199, 'Ein besonders schneller Server', false, null);

-- Virtualisierung & Cloud: Wie heißt die Software, die virtuelle Maschinen erstellt und verwaltet?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230200, 9006, 9604, 'Wie heißt die Software, die virtuelle Maschinen erstellt und verwaltet?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230200, 'Hypervisor', true, 'Der Hypervisor verteilt CPU, RAM und Speicher des Hosts auf die VMs. Bekannte Beispiele sind VMware, Hyper-V, VirtualBox und KVM.'),
  (230200, 'Compiler', false, null),
  (230200, 'Firewall', false, null),
  (230200, 'Browser', false, null);

-- Virtualisierung & Cloud: Was bedeutet Cloud Computing?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230201, 9006, 9604, 'Was bedeutet Cloud Computing?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230201, 'Die Nutzung von Rechenleistung, Speicher oder Software über das Internet statt auf eigenen Geräten', true, 'Statt einen eigenen Server zu kaufen, mietet man ihn bei einem Anbieter wie AWS, Azure oder Google Cloud und bezahlt nach Verbrauch.'),
  (230201, 'Das Speichern von Daten auf einem USB-Stick', false, null),
  (230201, 'Die Berechnung des Wetters', false, null),
  (230201, 'Ein Netzwerk ohne Kabel', false, null);

-- Virtualisierung & Cloud: Wofür steht die Abkürzung SaaS?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230202, 9006, 9604, 'Wofür steht die Abkürzung SaaS?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230202, 'Software as a Service – Software, die über das Internet genutzt wird, z. B. Microsoft 365', true, 'Bei SaaS installiert man nichts, sondern nutzt die Anwendung im Browser. Der Anbieter kümmert sich um Server, Updates und Backups.'),
  (230202, 'Storage as a Service', false, null),
  (230202, 'System and Application Security', false, null),
  (230202, 'Server as a Standard', false, null);

-- Virtualisierung & Cloud: Was ist ein Container, z. B. bei Docker?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230203, 9006, 9604, 'Was ist ein Container, z. B. bei Docker?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230203, 'Eine leichtgewichtige Verpackung einer Anwendung mit allem, was sie zum Laufen braucht', true, 'Ein Container enthält Programm, Bibliotheken und Einstellungen, nutzt aber den Kernel des Hosts mit. Deshalb startet er in Sekunden und ist viel kleiner als eine VM.'),
  (230203, 'Ein Gehäuse für Server im Rechenzentrum', false, null),
  (230203, 'Ein Ordner für Backups', false, null),
  (230203, 'Ein Netzwerkgerät', false, null);

-- Security & Troubleshooting: Wo sollte ein Backup aufbewahrt werden?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230204, 9006, 9605, 'Wo sollte ein Backup aufbewahrt werden?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230204, 'Getrennt vom Original, z. B. auf einer externen Festplatte oder in der Cloud', true, 'Ein Backup auf derselben Festplatte hilft nicht, wenn die Platte ausfällt oder Ransomware alles verschlüsselt. Deshalb: räumlich getrennt, idealerweise ein Exemplar außer Haus.'),
  (230204, 'Auf derselben Festplatte wie die Originaldaten', false, null),
  (230204, 'Im Papierkorb des Computers', false, null),
  (230204, 'Im Arbeitsspeicher', false, null);

-- Security & Troubleshooting: Wofür steht die Abkürzung BIOS bzw. UEFI?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230205, 9006, 9605, 'Wofür steht die Abkürzung BIOS bzw. UEFI?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230205, 'Die Firmware, die beim Einschalten die Hardware prüft und das Betriebssystem startet', true, 'BIOS (älter) und UEFI (Nachfolger) laufen noch vor dem Betriebssystem. Dort stellt man z. B. die Boot-Reihenfolge ein. Aufruf meist per F2 oder Entf beim Start.'),
  (230205, 'Ein Programm zum Bearbeiten von Bildern', false, null),
  (230205, 'Der Virenscanner des Betriebssystems', false, null),
  (230205, 'Ein Netzwerkprotokoll', false, null);

-- Security & Troubleshooting: Was macht ein Virenscanner?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230206, 9006, 9605, 'Was macht ein Virenscanner?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230206, 'Er sucht nach Schadsoftware auf dem Computer und blockiert sie', true, 'Ein Virenscanner prüft Dateien und Programme anhand bekannter Muster und verdächtigen Verhaltens. Er muss regelmäßig aktualisiert werden, um neue Schädlinge zu erkennen.'),
  (230206, 'Er beschleunigt den Internetzugang', false, null),
  (230206, 'Er sichert Daten auf externe Festplatten', false, null),
  (230206, 'Er kühlt den Prozessor', false, null);

-- Security & Troubleshooting: Warum sollte man Software-Updates zeitnah installieren?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230207, 9006, 9605, 'Warum sollte man Software-Updates zeitnah installieren?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230207, 'Weil sie oft Sicherheitslücken schließen, die Angreifer sonst ausnutzen könnten', true, 'Updates bringen nicht nur neue Funktionen, sondern schließen bekannte Schwachstellen. Ungepatchte Systeme sind das häufigste Einfallstor für Schadsoftware.'),
  (230207, 'Weil der Computer sonst nicht mehr startet', false, null),
  (230207, 'Weil Updates die Festplatte vergrößern', false, null),
  (230207, 'Weil man sonst die Garantie verliert', false, null);

-- Security & Troubleshooting: Was ist der erste sinnvolle Schritt, wenn ein Computer gar nicht mehr angeht?
insert into public.fragen (id, modul_id, thema_id, frage, schwierigkeitsgrad, question_type, frage_typ)
values (230208, 9006, 9605, 'Was ist der erste sinnvolle Schritt, wenn ein Computer gar nicht mehr angeht?', 'einfach', 'multiple_choice', 'multiple_choice');
insert into public.antworten (frage_id, text, ist_richtig, erklaerung) values
  (230208, 'Prüfen, ob Stromkabel und Netzteil richtig angeschlossen und eingeschaltet sind', true, 'Bei der Fehlersuche geht man vom Einfachen zum Komplizierten: Strom, Kabel, Schalter am Netzteil, Steckdose. Erst danach kommen Hardwaretausch oder Reparatur.'),
  (230208, 'Das Betriebssystem neu installieren', false, null),
  (230208, 'Die Festplatte austauschen', false, null),
  (230208, 'Den Arbeitsspeicher verdoppeln', false, null);

select public.refresh_themen_schwierigkeit() as themen_aktualisiert;
commit;

-- Kontrolle: select thema_id, count(*) from fragen where id between 230104 and 230208 group by 1 order by 1;  -- 21 Themen x 5