# Einstufungsregel Lernarena (Fachinformatiker AP1/AP2, Zielgruppe: Azubis/Umschüler ab 1. Lehrjahr)

Stufe pro Frage NUR nach dem, was die Frage vom Lernenden verlangt – nicht nach Thema, Modul, Level oder bisherigem Label.

**einfach** – EIN Fakt, eine Definition, eine Abkürzung, ein Name, eine Zuordnung 1:1 ("Wofür steht LAN?", "Welches Gerät verbindet zwei Netze?", "Welche Schicht ist Schicht 3?", "Port 443 gehört zu …?"). Antwort ist reines Erinnern; falsche Optionen sind klar unterscheidbar. Kein Rechnen, kein Vergleichen mehrerer Konzepte, keine Situationsbeschreibung. Auch Wahr/Falsch-Fragen zu einem einzelnen Fakt.

**mittel** – Verstehen oder Anwenden: Unterschiede/Vergleiche ("Hub vs. Switch"), Warum-Fragen, Beziehung zweier Konzepte, einfache Rechnung mit einem Schritt (Übertragungszeit, Subnetz-Hosts, Prozent), Lückentext mit 2+ Lücken, Reihenfolgen (sequence), kurze Situationsaufgaben ("Ein Kunde möchte … welche Lösung?"), Zuordnung mehrerer Elemente (dns_port_match mit mehreren Paaren), Standard-SQL-Abfragen schreiben.

**schwer** – Mehrschrittig, Sonderfälle, Werkzeug-/Konfigurationsdetails, Analyse einer Situation mit mehreren Bedingungen, Rechnungen mit 2+ Schritten (Kritischer Pfad, RAID-Nettokapazität mit Ausfall, Zweierkomplement), Sicherheits-/Angriffsmechanismen im Detail (VLAN-Hopping, stateful vs. stateless), Normalisierung 3NF anwenden, Wireshark-/CLI-Filter, JOIN-Abfragen über 3 Tabellen, Kosten-/Investitionsrechnung, Rechtsfragen mit Ausnahmen.

Faustregeln:
- question_type calculation / network_calculation / raid_calculation: mindestens mittel; schwer nur bei 2+ Rechenschritten.
- sequence, fill_blank, lueckentext: mindestens mittel.
- dns_port_match: einfach, wenn nur EIN Paar; sonst mittel.
- sql_tippen: mittel (einfaches SELECT/INSERT) bis schwer (JOIN/GROUP BY/Subquery).
- freitext_ada / wahr_falsch: nach Inhalt.
- Im Zweifel zwischen zwei Stufen: die niedrigere.
- Ziel-Verteilung grob: 30–40 % einfach, 40–50 % mittel, 15–25 % schwer. Wenn deine Verteilung stark abweicht, prüfe, ob du zu streng/mild bist.
# Zweiter Durchgang: Vorwissen-Check für "einfach"

Alle Fragen in der Datei sind formal einfach (ein Fakt / eine Definition). Entscheide jetzt NUR, ob das abgefragte Konzept **Grundlagenwissen** ist, das ein Fachinformatiker-Azubi oder Umschüler in den ersten 6 Monaten der Ausbildung realistisch kennt (Berufsschule 1. Lehrjahr, IT-Grundbegriffe, Alltagswissen: LAN, IP-Adresse, Switch, Router, Backup, Passwort, SELECT, Variable, Schleife, Kaufvertrag, Kosten, Bilanz-Grundbegriffe, Projektphasen, OSI-Schichten benennen, Ports 80/443, RAID 0/1 …).

Antwort "mittel", wenn der Begriff selbst Fach- oder Spezialwissen aus dem 2./3. Lehrjahr oder aus der Praxis ist, auch wenn die Frage nur die Definition will. Beispiele für mittel: SIEM, TPM, Secure Boot, OAuth, LDAP, Zero-Day, Honeypot, Isolationsstufen (READ COMMITTED), Immutable Backup, Air-Gap, GFS-Schema, RPO/RTO, Netzplan-Puffer/Vorwärtsrechnung, Velocity, TOMs, AVV, Subquery, RSA-Mathematik, Zeitkomplexität, Prepared Statements, Kubernetes-Objekte, IaC-Tools, Normalformen ab 3NF, Isolationsstufen, Tarifrecht-Details, Sozialversicherungs-Beitragssätze.

Faustregel: Würde man den Begriff in einem "IT-Grundlagen"-Schulbuch für das 1. Lehrjahr finden? Ja → einfach. Nein → mittel. Im Zweifel: mittel (denn das Ziel ist, dass "einfach" wirklich ein sanfter Einstieg ist).

# Pflichtregeln für NEUE Fragen (seit 09.09.2026)

Gelernt aus den 338 Einstiegsfragen vom 07./08.09.: Dort war bei 278 Fragen die richtige Antwort die längste (im Schnitt doppelt so lang wie die längste falsche) – erratbar, genau das Muster, das am 26.08. datenbankweit bereinigt wurde. Nachträglich mit 851 UPDATEs korrigiert (Migration 20260909020000). Damit das nicht wieder passiert, gilt für jede neue Multiple-Choice-Frage VOR dem Erzeugen der Migration:

1. **Antwortlängen:** Jede falsche Antwort liegt zwischen 0,7× und 1,3× der Länge der richtigen. Bei ungefähr einem Viertel der Fragen ist bewusst eine falsche Antwort die längste. Falsche Antworten haben dieselbe Satzform und Tiefe wie die richtige („… – z. B. …“), keine Unsinns-Antworten wie „Der Drucker“. Automatisch prüfen, nicht nach Gefühl.
2. **Dubletten:** Fragetext gegen den gesamten Bestand (alle Module inkl. Kernthemen und Lehrkarten) normalisiert vergleichen; gleiche Frage in anderem Modul zählt als Dublette.
3. **Keine Gedankenstriche** (—) in Frage, Antworten, Erklärung. Halbgeviertstrich (–) ist erlaubt.
4. **Code:** Mehrzeiliger Code im Fragetext in ```-Fences, Inline-Code (Befehle, SQL, Ausdrücke) in `Backticks` – auch in Antworten. Die App rendert das ab 1.6.1 als Codeblock (lib/widgets/frage_text.dart).
5. **Trigger beachten:** `trg_didactic_expl_aiu` auf `antworten` schreibt bei Änderung der richtigen Antwort die Erklärungen der Geschwister. In Migrationen deshalb nie mehrere Antworten derselben Frage in EINEM UPDATE ändern (Fehler „tuple already modified“); ein UPDATE je Antwort-ID ist unproblematisch, Trigger nicht abschalten.
6. **Erklärung** nur bei der richtigen Antwort setzen; die falschen bekommen ihren Text vom Trigger.
7. **IDs:** handgeschriebene Fragen ab 230000 fortlaufend (Stand 09.09.: bis 230338 belegt), Antworten über die Sequenz.
