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
