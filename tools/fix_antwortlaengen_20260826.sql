-- Fix: "Laengste Antwort = richtig" Muster entfernen
-- 480 Fragen (Verhaeltnis >= 1.3), 1333 Antworttexte angepasst
-- Projekt: ybvwjmaicoffitngtmzl, Tabelle public.antworten
-- Erstellt: 2026-08-26

begin;

-- Frage 1: Was sind fixe Kosten?
update public.antworten set text = 'Kosten die mit der Menge steigen' where id = 2;
update public.antworten set text = 'Kosten die mit der Menge sinken' where id = 3;
update public.antworten set text = 'Kosten die nur einmalig anfallen' where id = 4;
-- Frage 110001: Welches Dokument bildet die Grundlage für jede Buchung im Rahmen der ordnungsgemäßen Buchf
update public.antworten set text = 'Ein Beleg, zum Beispiel eine Rechnung' where id = 210002;
update public.antworten set text = 'Ein Buchungssatz mit Soll und Haben' where id = 210001;
update public.antworten set text = 'Die monatliche Summen- und Saldenliste' where id = 210004;
-- Frage 110003: Was ist das Grundbuch (Journal) in der doppelten Buchführung?
update public.antworten set text = 'Die chronologische Erfassung aller Buchungen' where id = 210010;
-- Frage 110010: Wo werden Umsatzerlöse grundsätzlich ausgewiesen?
update public.antworten set text = 'Auf der Aktivseite der Bilanz unter Umlaufvermögen' where id = 210037;
update public.antworten set text = 'Im Eigenkapitalspiegel als Rücklage' where id = 210039;
update public.antworten set text = 'Nur im Anhang des Jahresabschlusses' where id = 210040;
-- Frage 110020: Wie wirkt ein steuerbarer, steuerpflichtiger und nicht steuerbefreiter Umsatz in der USt-V
update public.antworten set text = 'Er hat keine Auswirkung auf die Zahllast' where id = 210077;
update public.antworten set text = 'Führt immer zu einer Erstattung durch das Finanzamt' where id = 210079;
update public.antworten set text = 'Betrifft nur die GuV, nicht die USt-Voranmeldung' where id = 210080;
-- Frage 110102: Welche Bestandteile gehören typischerweise in die TCO-Betrachtung eines On-Premises-Server
update public.antworten set text = 'Kaufpreis, Wartung, Energie, Adminzeit und Lizenzen' where id = 210105;
update public.antworten set text = 'Nur der einmalige Kaufpreis der Serverhardware' where id = 210106;
update public.antworten set text = 'Nur die laufenden Stromkosten des Rechenzentrumsbetriebs' where id = 210107;
update public.antworten set text = 'Nur die Lizenzen der eingesetzten Software' where id = 210108;
-- Frage 110105: Wann spricht eher „Buy“ (Standardsoftware/SaaS) statt „Make“ (Eigenentwicklung)?
update public.antworten set text = 'Wenn Anforderungen standardisiert und interne Kapazitäten knapp sind' where id = 210117;
update public.antworten set text = 'Wenn tiefe Sonderintegration in Altsysteme zwingend nötig ist' where id = 210119;
-- Frage 120006: Was verlangt das Kündigungsschutzgesetz (KSchG) für eine ordentliche Kündigung in anwendba
update public.antworten set text = 'Soziale Rechtfertigung der Kündigung' where id = 220022;
update public.antworten set text = 'Nur die Zustimmung der Kollegen im Betrieb' where id = 220024;
-- Frage 120011: Welche Zweige gehören zur deutschen Sozialversicherung (klassische „vier plus eins“)?
update public.antworten set text = 'Kranken-, Renten- und private Berufsunfähigkeitsversicherung' where id = 220042;
update public.antworten set text = 'Haftpflicht-, Hausrat- und Rechtsschutzversicherung' where id = 220043;
update public.antworten set text = 'Arbeitslosen-, Unfall- und Lebensversicherung' where id = 220044;
-- Frage 120017: Was umfasst die Prokura im Handelsrecht?
update public.antworten set text = 'Alle Handelsgeschäfte, Grundstücksgeschäfte nur mit Sondervollmacht' where id = 220066;
update public.antworten set text = 'Nur alltägliche Kleingeschäfte des Tagesbetriebs' where id = 220065;
update public.antworten set text = 'Nur Personalentscheidungen wie Einstellungen, Versetzungen und Kündigungen' where id = 220067;
update public.antworten set text = 'Nur interne Anweisungen an die eigene Abteilung' where id = 220068;
-- Frage 120019: Wann kommt der Schuldner ohne Mahnung in Verzug?
update public.antworten set text = 'Immer erst nach zwei schriftlichen Mahnungen' where id = 220073;
update public.antworten set text = 'Erst nach einem rechtskräftigen gerichtlichen Urteil' where id = 220076;
-- Frage 120021: Eine App verarbeitet Kundendaten, um den vertraglich geschuldeten Service bereitzustellen.
update public.antworten set text = 'Erforderlichkeit zur Vertragserfüllung' where id = 220081;
update public.antworten set text = 'Wahrnehmung einer öffentlichen Aufgabe' where id = 220083;
update public.antworten set text = 'Schutz lebenswichtiger Interessen' where id = 220084;
-- Frage 120022: Wann liegt „Auftragsverarbeitung“ vor und was ist zwingend zu tun?
update public.antworten set text = 'Weisungsgebundene Verarbeitung durch Dienstleister, ein AV-Vertrag ist Pflicht' where id = 220085;
update public.antworten set text = 'Wenn zwei Unternehmen gemeinsam Zwecke und Mittel festlegen (Joint Control)' where id = 220086;
-- Frage 120023: Welche Maßnahme ist ein geeignetes Beispiel für technische und organisatorische Maßnahmen 
update public.antworten set text = 'Verschlüsselung der Daten plus Zugriffsbeschränkungen' where id = 220089;
update public.antworten set text = 'Backups im selben Ordner wie die Produktivdaten speichern' where id = 220090;
update public.antworten set text = 'Aushang der aktuellen Passwörter im Teamraum' where id = 220091;
-- Frage 120024: Welche Aussage zu Open-Source-Lizenzen ist korrekt?
update public.antworten set text = 'GPL verlangt Weitergabe abgeleiteter Werke unter derselben Lizenz' where id = 220093;
update public.antworten set text = 'Die MIT-Lizenz zwingt bei jeder Nutzung zur Offenlegung des Quellcodes' where id = 220094;
-- Frage 120025: Was sollte ein Service-Level-Agreement (SLA) mindestens regeln?
update public.antworten set text = 'Verfügbarkeit, Reaktionszeiten und Messverfahren' where id = 220097;
update public.antworten set text = 'Nur den Eigentumsvorbehalt bis zur vollständigen Zahlung' where id = 220099;
update public.antworten set text = 'Nur einen allgemeinen Hinweis auf die AGB des Anbieters' where id = 220100;
-- Frage 130002: Bei einer 1:n-Beziehung - auf welcher Seite liegt der Fremdschlüssel typischerweise?
update public.antworten set text = 'Auf der Seite mit der Kardinalität „n“' where id = 230005;
update public.antworten set text = 'Immer auf beiden Seiten der Beziehung' where id = 230006;
update public.antworten set text = 'Auf der Seite mit der Kardinalität „1“' where id = 230008;
-- Frage 130007: Womit sortierst du eine Ergebnismenge in SQL?
update public.antworten set text = 'GROUP BY' where id = 230027;
-- Frage 130008: Welche Anweisung fügt neue Zeilen in eine Tabelle ein?
update public.antworten set text = 'CREATE TABLE' where id = 230032;
-- Frage 130012: Wofür wird HAVING im Unterschied zu WHERE verwendet?
update public.antworten set text = 'WHERE filtert Gruppen, HAVING filtert einzelne Zeilen' where id = 230047;
update public.antworten set text = 'HAVING erzeugt neue Spalten im Ergebnis' where id = 230048;
-- Frage 130013: Welche Aussage zu Aggregatfunktionen ist korrekt?
update public.antworten set text = 'AVG liefert die Anzahl der Zeilen einer Ergebnismenge' where id = 230049;
update public.antworten set text = 'MIN berechnet den Durchschnitt aller Werte' where id = 230051;
update public.antworten set text = 'COUNT(spalte) zählt NULL-Werte immer mit' where id = 230052;
-- Frage 130014: Wofür eignet sich eine Subquery in der WHERE-Klausel (IN)?
update public.antworten set text = 'Um ausschließlich neue Tabellen im Schema zu erstellen' where id = 230054;
update public.antworten set text = 'Um die Datenbank vor dem Zugriff zu sichern' where id = 230055;
-- Frage 130015: Worin besteht ein typischer Unterschied zwischen DISTINCT und GROUP BY?
update public.antworten set text = 'DISTINCT erstellt automatisch einen Index auf allen Spalten' where id = 230059;
update public.antworten set text = 'GROUP BY sortiert das Ergebnis immer aufsteigend' where id = 230060;
-- Frage 130017: Wann ist eine Tabelle in der 2. Normalform (2NF)?
update public.antworten set text = 'Wenn jedes Nicht-Schlüsselattribut vom gesamten Schlüssel abhängt' where id = 230065;
update public.antworten set text = 'Wenn immer ein künstlicher Surrogatschlüssel als Primärschlüssel dient' where id = 230068;
-- Frage 130018: Was verlangt die 3. Normalform (3NF)?
update public.antworten set text = 'Alle Tabellen brauchen mindestens drei zusammengesetzte Indizes' where id = 230070;
update public.antworten set text = 'Die 3NF verbietet Fremdschlüssel zwischen Tabellen' where id = 230072;
-- Frage 130020: Welche Aussage zu Constraints ist korrekt?
update public.antworten set text = 'UNIQUE erlaubt grundsätzlich keine NULL-Werte' where id = 230078;
update public.antworten set text = 'NOT NULL erzwingt Eindeutigkeit aller Werte' where id = 230079;
update public.antworten set text = 'CHECK-Constraints werden vom DBMS nie geprüft' where id = 230080;
-- Frage 130022: Wann ist ein Index typischerweise besonders sinnvoll?
update public.antworten set text = 'Bei selektiven Spalten, die oft in WHERE oder JOIN stehen' where id = 230085;
update public.antworten set text = 'Bei winzigen Tabellen mit nur wenigen hundert Zeilen immer' where id = 230086;
update public.antworten set text = 'Pauschal auf jeder Spalte einer Tabelle' where id = 230087;
update public.antworten set text = 'Nur auf TEXT-Spalten mit langen Inhalten' where id = 230088;
-- Frage 14: Was bedeutet Liquidität für ein Unternehmen?
update public.antworten set text = 'Die Fähigkeit, fällige Zahlungen pünktlich zu leisten' where id = 1002276;
update public.antworten set text = 'Der Gewinn des Unternehmens nach Abzug aller Kosten' where id = 1002277;
update public.antworten set text = 'Die Anzahl der fest angestellten Mitarbeiter im Betrieb' where id = 1002278;
update public.antworten set text = 'Die Produktionskapazität der Fertigungsanlagen im Werk' where id = 1002279;
-- Frage 140002: Worin unterscheidet sich ein Hub von einem Switch?
update public.antworten set text = 'Hub leitet Pakete anhand von Routingtabellen auf Layer 3 weiter' where id = 240007;
update public.antworten set text = 'Switch ist nur ein schnellerer Hub ohne eigene Logik' where id = 240008;
-- Frage 140006: Welche Angabe ist ein privater IPv4-Adressbereich gemäß RFC 1918?
update public.antworten set text = '172.32.0.0/16' where id = 240022;
update public.antworten set text = '192.169.0.0/16' where id = 240024;
-- Frage 140008: Wozu dient das „Default Gateway“ in einem IPv4-Netz?
update public.antworten set text = 'Lokaler DNS-Cache für aufgelöste Hostnamen' where id = 240030;
update public.antworten set text = 'Switch-Port, der Frames in VLAN 1 weiterleitet' where id = 240031;
update public.antworten set text = 'MAC-Adresse der Netzwerkkarte des PCs' where id = 240032;
-- Frage 140010: Welche Aussage zu IPv6 ist korrekt?
update public.antworten set text = 'IPv6 nutzt wie IPv4 nur 32-Bit-Adressen' where id = 240038;
update public.antworten set text = 'IPv6 erlaubt keine automatische Adresskonfiguration (SLAAC)' where id = 240039;
update public.antworten set text = 'IPv6 ersetzt MAC-Adressen auf Layer 2 vollständig' where id = 240040;
-- Frage 140013: Wozu dient das Spanning Tree Protocol (STP)?
update public.antworten set text = 'Zur IP-Adressvergabe an neue Clients' where id = 240050;
update public.antworten set text = 'Zur Namensauflösung von Domains' where id = 240051;
update public.antworten set text = 'Zum Aufbau der Routingtabelle auf L3' where id = 240052;
-- Frage 140015: Wie kommunizieren Hosts in unterschiedlichen VLANs miteinander?
update public.antworten set text = 'Über einen Router oder Layer-3-Switch' where id = 240057;
update public.antworten set text = 'Gar nicht, VLANs bleiben immer vollständig isoliert' where id = 240059;
update public.antworten set text = 'Nur über einen zwischengeschalteten Hub' where id = 240060;
-- Frage 140018: Wozu wird Network Address Translation (NAT) hauptsächlich eingesetzt?
update public.antworten set text = 'Übersetzung privater in öffentliche IP-Adressen' where id = 240069;
update public.antworten set text = 'Automatische Vergabe von Hostnamen im lokalen Netz' where id = 240070;
update public.antworten set text = 'Schleifenvermeidung auf Layer 2 zwischen Switches' where id = 240071;
update public.antworten set text = 'Zwangsverschlüsselung aller Pakete auf dem Transportweg' where id = 240072;
-- Frage 140019: Welche Aufgabe hat DHCP in einem IP-Netz?
update public.antworten set text = 'Auflösung von Hostnamen zu IP-Adressen' where id = 240074;
update public.antworten set text = 'Routing zwischen VLANs auf Layer 3' where id = 240075;
update public.antworten set text = 'Verschlüsselung der Pakete auf dem Transportweg' where id = 240076;
-- Frage 140020: Wofür wird DNS in Netzwerken benötigt?
update public.antworten set text = 'Übersetzung privater in öffentliche IP-Adressen' where id = 240078;
update public.antworten set text = 'Zeit-Synchronisierung aller Geräte im Netz' where id = 240079;
-- Frage 140021: Was kennzeichnet eine zustandsbehaftete (stateful) Firewall?
update public.antworten set text = 'Sie filtert eingehende Pakete ausschließlich anhand der MAC-Adresse' where id = 240082;
update public.antworten set text = 'Sie ersetzt den DNS-Server im Netzwerk' where id = 240084;
-- Frage 140024: Welche Maßnahme hilft typischerweise gegen VLAN-Hopping-Angriffe?
update public.antworten set text = 'Access-Ports fest konfigurieren, ungenutzte Ports abschalten' where id = 240093;
update public.antworten set text = 'Alle Ports pauschal als Trunk mit DTP konfigurieren' where id = 240094;
update public.antworten set text = 'Nur STP auf allen Switches deaktivieren' where id = 240095;
update public.antworten set text = 'Alle Hosts ins gleiche VLAN legen und die Trennung aufheben' where id = 240096;
-- Frage 140025: Auf welchem Mechanismus basiert „traceroute“ typischerweise?
update public.antworten set text = 'DHCP-Lease-Erneuerung in kurzen Intervallen' where id = 240098;
update public.antworten set text = 'SSL-Handshake-Analyse auf Port 443' where id = 240099;
update public.antworten set text = 'ARP-Broadcasts im lokalen Subnetz' where id = 240100;
-- Frage 15: Was ist der Break-Even-Point?
update public.antworten set text = 'Der Punkt, an dem Erlöse gleich Kosten sind' where id = 1002280;
update public.antworten set text = 'Der Punkt des maximal erreichbaren Gewinns' where id = 1002281;
update public.antworten set text = 'Die Grenze der kurzfristigen Liquidität' where id = 1002282;
update public.antworten set text = 'Der Umsatz bei voller Auslastung der Kapazität' where id = 1002283;
-- Frage 150002: Was kennzeichnet einen absoluten Pfad in Linux?
update public.antworten set text = 'Er beginnt immer beim Wurzelverzeichnis „/“' where id = 250005;
update public.antworten set text = 'Er beginnt nie mit „/“, sondern immer mit einem Punkt' where id = 250006;
update public.antworten set text = 'Er ist nur unter Windows mit Laufwerksbuchstaben gültig' where id = 250007;
update public.antworten set text = 'Er zeigt immer ins Home-Verzeichnis des Benutzers' where id = 250008;
-- Frage 150005: Was zeigt „ls -l“ zusätzlich gegenüber „ls“?
update public.antworten set text = 'Berechtigungen, Besitzer, Größe und Zeitstempel' where id = 250017;
update public.antworten set text = 'Zusätzlich alle versteckten Dateien mit Punkt' where id = 250018;
update public.antworten set text = 'Den Inhalt jeder Datei im Verzeichnis' where id = 250019;
-- Frage 150006: Wozu dient der Pipe-Operator „|“ in der Shell?
update public.antworten set text = 'Zum rekursiven Löschen von Dateien und Verzeichnissen' where id = 250022;
update public.antworten set text = 'Zum Komprimieren von Dateien mit gzip' where id = 250024;
-- Frage 150007: Was bewirkt der Umleitungs-Operator „>“?
update public.antworten set text = 'Er hängt die Standardausgabe an eine bestehende Datei an' where id = 250026;
update public.antworten set text = 'Er kopiert Verzeichnisse rekursiv mit allen Dateien' where id = 250028;
-- Frage 150013: Wie ändert man den Besitzer eines Verzeichnisses samt aller Unterelemente?
update public.antworten set text = 'chgrp -R gruppe <pfad>' where id = 250051;
update public.antworten set text = 'usermod -aG gruppe benutzername' where id = 250052;
-- Frage 150015: Wofür steht die „umask“?
update public.antworten set text = 'Maske, die Default-Rechte neuer Dateien einschränkt' where id = 250057;
update public.antworten set text = 'Ein Kommando zum Mounten von Dateisystemen' where id = 250058;
update public.antworten set text = 'Ein Komprimierungsformat für Archivdateien' where id = 250059;
update public.antworten set text = 'Ein Netzwerkprotokoll für Datei-Freigaben im LAN' where id = 250060;
-- Frage 150020: Welcher Mechanismus plant wiederkehrende Tasks (z. B. täglich 03:00 Uhr)?
update public.antworten set text = 'cron' where id = 250077;
-- Frage 150021: Welche Praxis ist für Administrationsaufgaben am sichersten?
update public.antworten set text = 'Immer dauerhaft als root eingeloggt arbeiten' where id = 250082;
update public.antworten set text = 'Allen Nutzern per sudoers-Datei sudo ALL ohne Passwort geben' where id = 250083;
update public.antworten set text = 'Nur über grafische Tools mit Root-Rechten administrieren' where id = 250084;
-- Frage 150024: Welches Ziel verfolgen SELinux und AppArmor?
update public.antworten set text = 'Prozesse durch MAC-Richtlinien strikt einschränken' where id = 250093;
update public.antworten set text = 'Sie ersetzen sudo und die Unix-Dateirechte vollständig' where id = 250094;
update public.antworten set text = 'Sie filtern als Firewall Pakete an den Netzwerkschnittstellen' where id = 250095;
update public.antworten set text = 'Sie vergeben IP-Adressen per DHCP an Clients' where id = 250096;
-- Frage 150025: Wozu dient die Shebang-Zeile (z. B. „#!/bin/bash“) am Anfang eines Scripts?
update public.antworten set text = 'Sie dokumentiert nur den Namen des Skript-Autors' where id = 250098;
-- Frage 16: Was unterscheidet Eigenkapital von Fremdkapital?
update public.antworten set text = 'Eigenkapital gehört den Eigentümern, Fremdkapital ist rückzahlbar' where id = 1002284;
update public.antworten set text = 'Eigenkapital verursacht höhere Zinskosten als jedes Fremdkapital' where id = 1002285;
update public.antworten set text = 'Fremdkapital dürfen nur große Kapitalgesellschaften aufnehmen' where id = 1002286;
update public.antworten set text = 'Eigenkapital wird immer mit einem festen Zinssatz verzinst' where id = 1002287;
-- Frage 160001: Welche Hauptaufgabe hat die CPU in einem Computersystem?
update public.antworten set text = 'Daten dauerhaft auch ohne Stromversorgung speichern' where id = 260002;
update public.antworten set text = 'Nur 3D-Grafik für die Bildschirmausgabe berechnen' where id = 260003;
update public.antworten set text = 'Ausschließlich Netzwerkverbindungen zu anderen Rechnern aufbauen' where id = 260004;
-- Frage 160010: Worin unterscheidet sich NVMe typischerweise von SATA-SSDs?
update public.antworten set text = 'NVMe läuft immer über USB 2.0 mit maximal 480 Mbit/s' where id = 260038;
update public.antworten set text = 'SATA ist bei sequenziellen Zugriffen schneller als NVMe' where id = 260039;
update public.antworten set text = 'NVMe ist nur ein Dateisystem für Windows-Server' where id = 260040;
-- Frage 160011: Was bewirkt Dual-Channel-RAM-Betrieb?
update public.antworten set text = 'Halbiert die nutzbare Gesamtkapazität der Module' where id = 260042;
update public.antworten set text = 'Ersetzt den internen CPU-Cache vollständig' where id = 260043;
-- Frage 160012: Wofür steht die CAS-Latenz (CL) bei RAM?
update public.antworten set text = 'Zyklen von Spaltenadresse bis Datenbereitstellung' where id = 260045;
update public.antworten set text = 'Anzahl der bestückten RAM-Bänke im Gesamtsystem' where id = 260046;
update public.antworten set text = 'Maximale RAM-Kapazität pro Speichermodul' where id = 260047;
update public.antworten set text = 'Anzahl der CPU-Kerne pro Prozessorsockel' where id = 260048;
-- Frage 160016: Worin unterscheiden sich Typ-1- und Typ-2-Hypervisor?
update public.antworten set text = 'Beide sind Container-Engines wie Docker' where id = 260062;
update public.antworten set text = 'Typ-2 läuft immer direkt auf der Hardware ohne Host-OS' where id = 260063;
update public.antworten set text = 'Typ-1 benötigt zwingend eine grafische Oberfläche' where id = 260064;
-- Frage 160018: Was unterscheidet Container typischerweise von VMs?
update public.antworten set text = 'Container sind vollständige Hardware-Emulatoren wie QEMU' where id = 260070;
update public.antworten set text = 'VMs benötigen im Gegensatz zu Containern keinen Hypervisor' where id = 260071;
update public.antworten set text = 'Container ersetzen Backups und Snapshots' where id = 260072;
-- Frage 160020: Was beschreibt „horizontale Skalierung“ im Vergleich zu „vertikaler Skalierung“?
update public.antworten set text = 'Horizontal: mehr RAM und CPU in derselben VM' where id = 260078;
update public.antworten set text = 'Vertikal: dem Cluster weitere Server hinzufügen' where id = 260079;
update public.antworten set text = 'Beides bezeichnet nur die Umbenennung der Instanzen' where id = 260080;
-- Frage 160022: Wofür wird ein TPM (Trusted Platform Module) typischerweise genutzt?
update public.antworten set text = 'Erhöht die Reichweite des WLAN-Moduls' where id = 260086;
update public.antworten set text = 'Ersetzt Antivirus-Software vollständig' where id = 260087;
update public.antworten set text = 'Dient als internes Netzteil für das Mainboard' where id = 260088;
-- Frage 160023: SMART meldet viele „Reallocated Sectors“. Was ist die richtige Reaktion?
update public.antworten set text = 'Die Warnung ignorieren und das Laufwerk weiter nutzen' where id = 260090;
update public.antworten set text = 'Das Laufwerk defragmentieren, das behebt die Sektorfehler' where id = 260091;
update public.antworten set text = 'Das Dateisystem wechseln, um die Sektoren zu reparieren' where id = 260092;
-- Frage 160025: Welche Maßnahme schützt Daten auf einem verlorenen/gestohlenen Laptop am zuverlässigsten?
update public.antworten set text = 'Vollständige Festplattenverschlüsselung (FDE)' where id = 260097;
update public.antworten set text = 'Nur ein Benutzerpasswort ohne Verschlüsselung der Platte' where id = 260098;
-- Frage 17: Was zeigt die Bilanz eines Unternehmens?
update public.antworten set text = 'Vermögen und Kapital zu einem Stichtag' where id = 1002288;
update public.antworten set text = 'Nur den Gewinn nach Steuern' where id = 1002289;
update public.antworten set text = 'Die Liquidität am Monatsende' where id = 1002290;
update public.antworten set text = 'Die Umsätze des laufenden Geschäftsjahres' where id = 1002291;
-- Frage 170003: Wozu dienen Kommentare im Code?
update public.antworten set text = 'Um den Code zur Laufzeit schneller zu machen' where id = 270010;
update public.antworten set text = 'Um beim Kompilieren automatisch alle Unit-Tests zu generieren' where id = 270011;
-- Frage 170006: Wozu dient eine if/else-Struktur?
update public.antworten set text = 'Zum Kompilieren des Programms in Maschinencode' where id = 270022;
update public.antworten set text = 'Zum Speichern von Dateien auf der Festplatte' where id = 270023;
-- Frage 170010: Was ist der Unterschied zwischen break und continue in Schleifen?
update public.antworten set text = 'Beide beenden das gesamte Programm sofort mit Fehlercode' where id = 270038;
update public.antworten set text = 'continue beendet die Schleife, break überspringt nur die aktuelle Iteration' where id = 270039;
-- Frage 170011: Wofür steht „Kapselung“ (Encapsulation) in der OOP?
update public.antworten set text = 'Alle Attribute und Methoden öffentlich machen' where id = 270042;
update public.antworten set text = 'Ausschließlich globale Variablen im Programm verwenden' where id = 270043;
update public.antworten set text = 'Vererbung ohne eigene Methoden in der Subklasse' where id = 270044;
-- Frage 170012: Was beschreibt Polymorphie in der OOP am besten?
update public.antworten set text = 'Eine Klasse ganz ohne Methoden und Attribute' where id = 270046;
update public.antworten set text = 'Mehrere Hauptfunktionen gleichzeitig in einem Programm' where id = 270047;
-- Frage 170013: Wozu dient ein Konstruktor in Klassen?
update public.antworten set text = 'Zum Löschen nicht mehr benötigter Objekte' where id = 270050;
update public.antworten set text = 'Zum Rendern von HTML-Templates im Browser' where id = 270051;
update public.antworten set text = 'Zum Kompilieren des gesamten Projekts' where id = 270052;
-- Frage 170014: Welche Aussage zu Exceptions (Ausnahmen) ist korrekt?
update public.antworten set text = 'Exceptions sind reine Kommentare für den Compiler' where id = 270054;
update public.antworten set text = 'Exceptions beenden bei jedem Auftreten sofort das komplette Betriebssystem' where id = 270055;
-- Frage 170015: Was unterscheidet üblicherweise ein Interface von einer abstrakten Klasse?
update public.antworten set text = 'Interface: nur Vertrag; abstrakte Klasse: auch Implementierung' where id = 270057;
update public.antworten set text = 'Abstrakte Klassen dürfen niemals eigene Methoden enthalten' where id = 270060;
-- Frage 170016: Was ist der Unterschied zwischen git commit und git push?
update public.antworten set text = 'push erstellt automatisch Unit-Tests für alle Branches' where id = 270063;
update public.antworten set text = 'commit löscht das Remote-Repo auf dem Server' where id = 270064;
-- Frage 170017: Wozu dienen Branches in Git?
update public.antworten set text = 'Um Dateien vor dem Push automatisch zu verschlüsseln' where id = 270066;
update public.antworten set text = 'Um Commits ohne Spuren aus dem Verlauf zu löschen' where id = 270067;
-- Frage 170020: Wozu dient eine CI/CD-Pipeline?
update public.antworten set text = 'Zum manuellen Editieren des Git-Verlaufs auf dem Server' where id = 270079;
update public.antworten set text = 'Nur für statische Websites ohne Backend einsetzbar' where id = 270080;
-- Frage 170021: Welche Zeitkomplexität hat die binäre Suche in einer sortierten Liste?
update public.antworten set text = 'O(n log n)' where id = 270084;
-- Frage 170023: Welche Maßnahme schützt am zuverlässigsten gegen SQL-Injection?
update public.antworten set text = 'Ausschließlich clientseitige Eingabevalidierung' where id = 270090;
update public.antworten set text = 'Datenbank-Passwörter im Quellcode verstecken' where id = 270091;
update public.antworten set text = 'Ausführliches Logging aller Datenbankzugriffe' where id = 270092;
-- Frage 170024: Worin unterscheidet sich kryptografisches Hashing von Verschlüsselung?
update public.antworten set text = 'Beides ist mit dem passenden Schlüssel immer umkehrbar' where id = 270094;
update public.antworten set text = 'Verschlüsselung ist einweg und kommt ohne Schlüssel aus' where id = 270096;
-- Frage 170025: Was ist eine Race Condition und wie verhindert man sie typischerweise?
update public.antworten set text = 'Fehlende Synchronisation nebenläufiger Zugriffe; Lösung: Locks' where id = 270097;
update public.antworten set text = 'Immer ein Hardwaredefekt am RAM; Lösung: Mainboard tauschen' where id = 270099;
-- Frage 180001: Wofür steht die CIA-Triade in der Informationssicherheit?
update public.antworten set text = 'Kostenkontrolle, Innovation und Agilität' where id = 280002;
update public.antworten set text = 'Compliance, Insurance, Accountability' where id = 280003;
update public.antworten set text = 'Caching, Input/Output, API-Gateways' where id = 280004;
-- Frage 180003: Warum sind regelmäßige Sicherheitsupdates wichtig?
update public.antworten set text = 'Weil sie immer CPU und Arbeitsspeicher beschleunigen' where id = 280011;
update public.antworten set text = 'Weil dadurch regelmäßige Backups überflüssig werden' where id = 280012;
-- Frage 180005: Welche Aussage beschreibt ein starkes Passwort am besten?
update public.antworten set text = 'Lang und schwer zu erraten, z. B. eine Passphrase' where id = 280017;
update public.antworten set text = '„password“ mit einem angehängten „!“ ist völlig ausreichend' where id = 280019;
update public.antworten set text = 'Dasselbe Passwort überall verwenden, um es sich zu merken' where id = 280020;
-- Frage 180007: Wofür steht das „S“ in HTTPS und was bedeutet es technisch?
update public.antworten set text = 'TLS-gesicherte Transportverschlüsselung' where id = 280025;
-- Frage 180012: Worin unterscheidet sich kryptografisches Hashing von Verschlüsselung im Sicherheitskontex
update public.antworten set text = 'Beides ist mit dem passenden Schlüssel immer umkehrbar' where id = 280046;
update public.antworten set text = 'Hashing ersetzt Backups und Verschlüsselung vollständig' where id = 280047;
update public.antworten set text = 'Verschlüsselung benötigt grundsätzlich niemals einen Schlüssel' where id = 280048;
-- Frage 180013: Wozu dient ein Salt bei der Passwortspeicherung?
update public.antworten set text = 'Ersetzt den Hash-Algorithmus durch Verschlüsselung' where id = 280051;
update public.antworten set text = 'Verschlüsselt die gesamte Nutzerdatenbank mit einem AES-Schlüssel' where id = 280052;
-- Frage 180014: Was bestätigt ein digitales Zertifikat (X.509) grundsätzlich?
update public.antworten set text = 'Es bindet einen Public Key an eine geprüfte Identität' where id = 280053;
update public.antworten set text = 'Es enthält immer das Admin-Passwort des Servers' where id = 280054;
update public.antworten set text = 'Es ersetzt alle Firewalls und Virenscanner im Netz' where id = 280055;
update public.antworten set text = 'Es ist nur ein Gütesiegel-Logo für die Website' where id = 280056;
-- Frage 180015: Welche Ziele erreicht der TLS-Handschlag typischerweise vor dem Datentransfer?
update public.antworten set text = 'Authentisierung des Servers und Schlüsselaushandlung' where id = 280057;
update public.antworten set text = 'Formatierung der HTML- und CSS-Struktur der Webseite' where id = 280058;
update public.antworten set text = 'Verlustfreie Komprimierung aller Bilder der Webseite' where id = 280059;
update public.antworten set text = 'Abschalten aller Firewalls entlang des Netzwerkpfads' where id = 280060;
-- Frage 180017: Warum hilft Netzwerksegmentierung bei der Sicherheitsarchitektur?
update public.antworten set text = 'Erhöht ausschließlich die Bildschirmauflösung der Clients' where id = 280066;
update public.antworten set text = 'Macht Firewalls und Zugriffskontrollen überflüssig' where id = 280067;
update public.antworten set text = 'Deaktiviert TLS im internen Netzwerk' where id = 280068;
-- Frage 180019: Warum ist zentrales Logging/Monitoring (z. B. SIEM) sicherheitsrelevant?
update public.antworten set text = 'Erkennt Angriffe durch Korrelation und erleichtert Forensik' where id = 280073;
update public.antworten set text = 'Ersetzt das Einspielen aller Sicherheitspatches' where id = 280074;
update public.antworten set text = 'Löscht sensible Daten automatisch von allen angebundenen Systemen' where id = 280075;
update public.antworten set text = 'Erhöht nur die Lüfterdrehzahl der überwachten Server' where id = 280076;
-- Frage 180020: Welche Erstmaßnahme ist bei Malware-Verdacht auf einem Arbeitsplatz-PC typischerweise sinn
update public.antworten set text = 'Netzwerkverbindung trennen und den Incident-Prozess starten' where id = 280077;
update public.antworten set text = 'Sofort alle Logdateien und temporären Dateien löschen' where id = 280078;
update public.antworten set text = 'Unbekannte Removal-Tools aus dem Internet herunterladen und installieren' where id = 280080;
-- Frage 180021: Welche Maßnahme schützt am zuverlässigsten gegen SQL-Injection?
update public.antworten set text = 'Nur Validierung im Browser per JavaScript' where id = 280082;
update public.antworten set text = 'Zugangsdaten tief im Programmcode verstecken' where id = 280083;
update public.antworten set text = 'Lückenloses Logging aller SQL-Abfragen aktivieren' where id = 280084;
-- Frage 180022: Wie beugst du Cross-Site Scripting (XSS) typischerweise vor?
update public.antworten set text = 'Ausschließlich HTTPS für alle Verbindungen verwenden' where id = 280086;
update public.antworten set text = 'Passwörter im Klartext in der Datenbank speichern' where id = 280087;
-- Frage 180023: Welche Maßnahme schützt zuverlässig gegen CSRF?
update public.antworten set text = 'CSRF-Token in Kombination mit SameSite-Cookies' where id = 280089;
update public.antworten set text = 'Nur längere URLs mit zufälligen Pfadnamen' where id = 280090;
update public.antworten set text = 'Alle Formulare per GET statt POST übertragen' where id = 280091;
update public.antworten set text = 'Nur ein Captcha vor jedem Formular' where id = 280092;
-- Frage 180024: Wofür wird HSTS (Strict-Transport-Security) eingesetzt?
update public.antworten set text = 'Ersetzt Paketfilter-Firewalls auf Netzwerkebene' where id = 280094;
update public.antworten set text = 'Signiert Antworten von JSON-APIs kryptografisch mit RSA' where id = 280095;
update public.antworten set text = 'Eine CSS-Regel zum Laden externer Schriften' where id = 280096;
-- Frage 19: Was ist der Cashflow?
update public.antworten set text = 'Der tatsächliche Geldfluss einer Periode' where id = 1002296;
update public.antworten set text = 'Die Bilanzsumme am Ende des Geschäftsjahres' where id = 1002298;
update public.antworten set text = 'Der Umsatz aus dem laufenden Geschäft' where id = 1002299;
-- Frage 190001: Wozu dienen semantische HTML-Tags wie <header>, <main>, <nav>, <footer>?
update public.antworten set text = 'Sie strukturieren Inhalte semantisch und helfen Screenreadern' where id = 290001;
update public.antworten set text = 'Sie sind nur für das CSS-Styling zwingend erforderlich' where id = 290002;
update public.antworten set text = 'Sie ersetzen JavaScript bei interaktiven Seiten vollständig' where id = 290003;
update public.antworten set text = 'Sie verhalten sich in jeder Hinsicht identisch zu <div>-Elementen' where id = 290004;
-- Frage 190004: Welche Aussage zu GET vs. POST trifft zu?
update public.antworten set text = 'POST ist ausschließlich für Bild-Uploads vorgesehen' where id = 290014;
update public.antworten set text = 'GET verschlüsselt Parameter automatisch mit TLS' where id = 290015;
update public.antworten set text = 'GET-Requests haben grundsätzlich keinen Request-Header' where id = 290016;
-- Frage 190008: Was beschreibt „Event-Bubbling“ im DOM?
update public.antworten set text = 'Events können ausschließlich auf dem Window-Objekt ausgelöst werden' where id = 290030;
update public.antworten set text = 'Bubbling ist nur in CSS-Animationen definiert' where id = 290032;
-- Frage 190010: Welche Aussage zu fetch und Promises ist korrekt?
update public.antworten set text = 'Promises sind nur in TypeScript, nicht in JavaScript erlaubt' where id = 290039;
update public.antworten set text = 'response.json() liefert das Ergebnis synchron zurück' where id = 290040;
-- Frage 190011: Welches Prinzip gehört zu REST-Architekturen?
update public.antworten set text = 'Der Server muss immer den Session-Zustand aller Clients halten' where id = 290042;
update public.antworten set text = 'Nur SOAP-Schnittstellen sind REST-konform' where id = 290043;
-- Frage 190018: Wie sollten Konfiguration/Secrets für verschiedene Umgebungen verwaltet werden?
update public.antworten set text = 'API-Keys und Passwörter direkt im Git-Repository committen' where id = 290070;
update public.antworten set text = 'Secrets als Kommentar in den CSS-Dateien des Frontends ablegen' where id = 290071;
-- Frage 190019: Wozu dient ein Reverse Proxy (z. B. Nginx) vor einer Web-App?
update public.antworten set text = 'TLS-Terminierung, Weiterleitung und Lastverteilung' where id = 290073;
update public.antworten set text = 'Er ersetzt die Datenbank hinter der Anwendung' where id = 290074;
update public.antworten set text = 'Er dient nur für lokale Dateibackups des Webservers' where id = 290075;
update public.antworten set text = 'Er rendert die HTML-Vorlagen direkt im Browser des Clients' where id = 290076;
-- Frage 190020: Was beschreibt Blue-Green-Deployment?
update public.antworten set text = 'Parallele Prod-Umgebungen mit Umschaltung beim Release' where id = 290077;
update public.antworten set text = 'Deployment gesammelt nur einmal pro Jahr' where id = 290078;
update public.antworten set text = 'Deployments ohne Tests direkt in die Produktion' where id = 290079;
update public.antworten set text = 'Ein Verfahren, das nur für Mobile-Apps nutzbar ist' where id = 290080;
-- Frage 190021: Wofür ist CORS (Cross-Origin Resource Sharing) da?
update public.antworten set text = 'Komprimiert alle HTTP-Antworten des Servers automatisch mit gzip' where id = 290082;
update public.antworten set text = 'Ersetzt die Authentifizierung per Session-Cookie' where id = 290083;
update public.antworten set text = 'Ein Browser-Cache für statische Ressourcen' where id = 290084;
-- Frage 190022: Welche Kombination schützt zuverlässig gegen CSRF in Web-Apps?
update public.antworten set text = 'Nur längere URLs mit zufälligen Pfadnamen' where id = 290086;
update public.antworten set text = 'Nur ein Captcha bei jedem Login-Formular' where id = 290087;
update public.antworten set text = 'Alle Formulare grundsätzlich per GET statt POST übertragen' where id = 290088;
-- Frage 190023: Wofür setzt man Content-Security-Policy (CSP) ein?
update public.antworten set text = 'Optimierung der CPU-Auslastung beim Rendern von Webseiten' where id = 290090;
update public.antworten set text = 'Erzeugen von SSL-Zertifikaten für den Webserver' where id = 290091;
update public.antworten set text = 'Übersetzung von JSON-Daten in das XML-Format im Browser' where id = 290092;
-- Frage 20: Was ist eine Abschreibung?
update public.antworten set text = 'Die planmäßige Werterhöhung von Anlagevermögen' where id = 1002301;
update public.antworten set text = 'Eine einmalige Zahlung im Jahr der Anschaffung eines Anlageguts' where id = 1002302;
update public.antworten set text = 'Ein Kredit zur Finanzierung von Anlagegütern' where id = 1002303;
-- Frage 200002: Was beschreibt das Shared-Responsibility-Modell korrekt (IaaS)?
update public.antworten set text = 'Provider: Rechenzentrum und Hypervisor; Kunde: OS, Apps und Daten' where id = 300005;
update public.antworten set text = 'Der Provider ist für alle Kundendaten und deren Verschlüsselung verantwortlich' where id = 300006;
update public.antworten set text = 'Der Kunde sichert die physische Hardware im Rechenzentrum' where id = 300007;
-- Frage 200003: Was ist eine Availability Zone (AZ) typischerweise?
update public.antworten set text = 'Isolierter Standort innerhalb einer Region' where id = 300009;
update public.antworten set text = 'Ein einzelner Server innerhalb einer virtuellen Maschine' where id = 300010;
update public.antworten set text = 'Eine globale Multi-Region über alle Kontinente' where id = 300011;
update public.antworten set text = 'Nur ein Abrechnungsbegriff ohne technische Bedeutung' where id = 300012;
-- Frage 200004: Welche Aussage zur Cloud-Abrechnung passt?
update public.antworten set text = 'Abrechnung nach Nutzung; Reservierungen senken planbare Kosten' where id = 300013;
update public.antworten set text = 'Cloud ist in jedem Szenario günstiger als On-Premises-Betrieb' where id = 300014;
-- Frage 200008: Warum sind Einrückungen in YAML wichtig (z. B. für Pipeline-Definitionen)?
update public.antworten set text = 'Einrückungen definieren die Struktur des Dokuments' where id = 300029;
update public.antworten set text = 'Einrückungen sind reine Optik ohne Auswirkung aufs Parsing' where id = 300030;
-- Frage 200009: Was ist ein „Build-Artefakt“ in CI/CD?
update public.antworten set text = 'Nur die README.md aus dem Repository-Wurzelverzeichnis' where id = 300034;
update public.antworten set text = 'Ein zufälliger Logeintrag aus der Pipeline-Ausführung' where id = 300035;
update public.antworten set text = 'Nur ein Git-Branch mit dem aktuellen Entwicklungsstand' where id = 300036;
-- Frage 200010: Worin besteht die Grundidee von GitOps?
update public.antworten set text = 'Deployments erfolgen ausschließlich manuell per SSH auf dem Server' where id = 300038;
update public.antworten set text = 'Infrastruktur wird grundsätzlich nicht versioniert' where id = 300039;
-- Frage 200011: Was ist ein Pod in Kubernetes?
update public.antworten set text = 'Kleinste Deploymenteinheit mit einem oder mehreren Containern' where id = 300041;
update public.antworten set text = 'Ein kompletter Cluster mit allen Worker Nodes' where id = 300042;
update public.antworten set text = 'Ein Dockerfile mit den Bauanweisungen für ein Container-Image' where id = 300044;
-- Frage 200014: Wofür wird ein Ingress (Controller) verwendet?
update public.antworten set text = 'Zum Mounten von Volumes in einzelne Pods' where id = 300054;
update public.antworten set text = 'Zum Verwalten von RBAC-Rollen und Rechten' where id = 300055;
update public.antworten set text = 'Zum Erstellen neuer Nodes im Cluster' where id = 300056;
-- Frage 200016: Wozu dient „terraform plan“ im Vergleich zu „apply“?
update public.antworten set text = 'plan löscht immer alle bestehenden Ressourcen sofort' where id = 300062;
update public.antworten set text = 'apply erzeugt nur eine Dokumentation ohne Änderungen' where id = 300063;
update public.antworten set text = 'plan verändert die Cloud-Infrastruktur bereits direkt' where id = 300064;
-- Frage 200017: Warum ist der Terraform-State wichtig und oft remote gespeichert?
update public.antworten set text = 'Der State ist nur ein optionales Logfile für Debugging-Zwecke' where id = 300066;
update public.antworten set text = 'Ohne State kann Terraform alle Ressourcen genauso gut verfolgen' where id = 300068;
-- Frage 200019: Welche Zuordnung passt für SLI, SLO und SLA?
update public.antworten set text = 'SLI=vertragliche Zusage, SLO=Messgröße, SLA=Ziel' where id = 300074;
-- Frage 200020: Was ist der Unterschied zwischen Logs, Metrics und Traces (Observability)?
update public.antworten set text = 'Logs=Ereignisse, Metrics=Zeitreihen, Traces=Ablaufketten' where id = 300077;
update public.antworten set text = 'Logs, Metrics und Traces sind identische Textdateien' where id = 300078;
update public.antworten set text = 'Metrics sind qualitative Werte und nicht messbar' where id = 300079;
update public.antworten set text = 'Traces messen ausschließlich die CPU-Temperatur der Hosts' where id = 300080;
-- Frage 200021: Wie erreicht man Hochverfügbarkeit in der Cloud typischerweise am zuverlässigsten?
update public.antworten set text = 'Mehrere Instanzen in mehreren AZs mit Failover' where id = 300081;
update public.antworten set text = 'Eine einzige große VM in nur einer Availability Zone' where id = 300082;
update public.antworten set text = 'Ein einzelner Load-Balancer ohne zweite Instanz dahinter' where id = 300084;
-- Frage 200022: Worin unterscheidet sich horizontale von vertikaler Skalierung?
update public.antworten set text = 'Beide bedeuten lediglich ein neues Produkt-Branding' where id = 300086;
update public.antworten set text = 'Horizontal heißt, mehr RAM in dieselbe VM einzubauen' where id = 300087;
update public.antworten set text = 'Vertikal heißt, zusätzliche Server ins Cluster aufzunehmen' where id = 300088;
-- Frage 200023: Was unterscheidet Blue/Green-Deployment von Canary-Releases?
update public.antworten set text = 'Canary-Releases kommen ohne Telemetrie und Monitoring aus' where id = 300091;
update public.antworten set text = 'Blue/Green ist ausschließlich für native Mobile-Apps im App Store gedacht' where id = 300092;
-- Frage 200024: Welche Maßnahme reduziert Cloud-Kosten typischerweise effektiv?
update public.antworten set text = 'Für jede Last immer die maximale Instanzgröße wählen' where id = 300094;
update public.antworten set text = 'Auf Tags und Budgetalarme komplett verzichten' where id = 300095;
update public.antworten set text = 'Alte Snapshots und ungenutzte Volumes dauerhaft behalten' where id = 300096;
-- Frage 200025: Wozu dient ein „Error Budget“ im SRE-Ansatz?
update public.antworten set text = 'Steuert Tempo gegen Zuverlässigkeit über die zulässige Fehlerquote' where id = 300097;
update public.antworten set text = 'Zählt ausschließlich die Anzahl der Commits im Repository' where id = 300098;
update public.antworten set text = 'Ersetzt regelmäßige Backups der Produktionssysteme vollständig' where id = 300099;
update public.antworten set text = 'Ist ein reiner Marketingbegriff ohne messbare Grundlage' where id = 300100;
-- Frage 21: Was sind kalkulatorische Kosten?
update public.antworten set text = 'Kosten, die nur in der Kostenrechnung, nicht in der Finanzbuchhaltung stehen' where id = 1002304;
update public.antworten set text = 'Kosten, die vom Controlling am Jahresende grob geschätzt und gebucht werden' where id = 1002305;
update public.antworten set text = 'Variable Kosten, die mit der Produktionsmenge steigen' where id = 1002306;
-- Frage 210001: Worin besteht der Unterschied zwischen Datenstruktur und Algorithmus?
update public.antworten set text = 'Datenstrukturen organisieren Daten, Algorithmen beschreiben Verfahren' where id = 310001;
update public.antworten set text = 'Beides sind nur Kommentare im Quellcode' where id = 310002;
update public.antworten set text = 'Ein Algorithmus ist immer eine Hardware-Komponente' where id = 310003;
update public.antworten set text = 'Eine Datenstruktur ist bei der Ausführung immer langsamer als ein Algorithmus' where id = 310004;
-- Frage 210005: Was beschreibt die Big-O-Notation grob?
update public.antworten set text = 'Obere Schranke des Laufzeitwachstums' where id = 310017;
update public.antworten set text = 'Exakte Laufzeit des Programms in Millisekunden' where id = 310018;
update public.antworten set text = 'Nur den Speicherverbrauch, nie die Laufzeit' where id = 310019;
update public.antworten set text = 'Nur für kleine Eingabegrößen n gültig' where id = 310020;
-- Frage 210010: Wofür wird ein Ringpuffer (circular buffer) häufig genutzt?
update public.antworten set text = 'Zum Sortieren großer Datenmengen per Quicksort' where id = 310038;
update public.antworten set text = 'Als symmetrisches Kryptoverfahren wie AES' where id = 310039;
update public.antworten set text = 'Zur Ablage rekursiver Funktionsaufrufe auf dem Call-Stack' where id = 310040;
-- Frage 210011: Welche Eigenschaft hat ein binärer Suchbaum (BST)?
update public.antworten set text = 'Links < Knoten < Rechts' where id = 310041;
-- Frage 210014: Welche Ordnung hat die Höhe eines gut balancierten binären Baums mit n Knoten?
update public.antworten set text = 'O(n log n)' where id = 310056;
-- Frage 210015: Warum nutzen Datenbanken oft B-Bäume/B+-Bäume für Indexe?
update public.antworten set text = 'Geringe Höhe durch hohen Verzweigungsgrad, also wenig I/O' where id = 310057;
update public.antworten set text = 'Weil B-Bäume beim Einfügen zufällig alte Elemente löschen' where id = 310058;
update public.antworten set text = 'Weil sie ihre Schlüssel ohne Sortierung ablegen' where id = 310060;
-- Frage 210021: Welches Beispiel illustriert amortisierte O(1)-Kosten gut?
update public.antworten set text = 'Binäre Suche auf unsortierten, verketteten Listen' where id = 310082;
update public.antworten set text = 'Heapsort mit konstanter Laufzeit O(1)' where id = 310083;
update public.antworten set text = 'Merge zweier sortierter Listen in O(n^2)' where id = 310084;
-- Frage 210022: Was kennzeichnet Dynamic Programming (DP)?
update public.antworten set text = 'Optimale Teilstruktur und überlappende Teilprobleme' where id = 310085;
update public.antworten set text = 'Liefert immer schlechtere Laufzeiten als Greedy-Verfahren' where id = 310088;
-- Frage 210023: Worin unterscheidet sich Greedy typischerweise von DP?
update public.antworten set text = 'Greedy: lokal optimale Wahl; DP: Optimierung über Teilprobleme' where id = 310089;
update public.antworten set text = 'Beide Verfahren garantieren immer das globale Optimum' where id = 310090;
update public.antworten set text = 'DP wählt seine Teillösungen rein zufällig aus' where id = 310091;
update public.antworten set text = 'Greedy benötigt für jede Eingabe immer exponentielle Laufzeit' where id = 310092;
-- Frage 210025: Welches Beispiel beschreibt einen Space-Time-Tradeoff?
update public.antworten set text = 'Hashing ersetzt den Speicherbedarf eines Programms komplett' where id = 310099;
-- Frage 210240: Was ist Google Cloud Platform?
update public.antworten set text = 'Ein Betriebssystem von Google für Serverhardware' where id = 1003229;
update public.antworten set text = 'Eine Programmiersprache für serverseitige Anwendungen' where id = 1003230;
update public.antworten set text = 'Ein Web-Browser mit integriertem Cloud-Speicher' where id = 1003231;
-- Frage 210242: Was ist Google App Engine?
update public.antworten set text = 'Ein Datei-Speicherdienst für Backups und Archive' where id = 1003237;
update public.antworten set text = 'Ein Hardware-Produkt für Rechenzentren' where id = 1003238;
update public.antworten set text = 'Ein VPN-Dienst für sichere Verbindungen' where id = 1003239;
-- Frage 210243: Was ist Google Kubernetes Engine?
update public.antworten set text = 'Ein Framework für maschinelles Lernen auf Basis von TensorFlow' where id = 1003242;
-- Frage 210244: Was ist Cloud Functions?
update public.antworten set text = 'Ein Backup-Service für virtuelle Maschinen und Datenbanken' where id = 1003247;
-- Frage 210245: Was ist Cloud Run?
update public.antworten set text = 'Verwalteter Dienst zum Ausführen von Containern' where id = 1003248;
update public.antworten set text = 'Ein Dienst zum Bereitstellen virtueller Desktops' where id = 1003249;
update public.antworten set text = 'Ein E-Mail-Service für Marketing-Kampagnen' where id = 1003250;
update public.antworten set text = 'Ein Code-Repository für Git-Projekte' where id = 1003251;
-- Frage 210246: Was ist Google Cloud Storage?
update public.antworten set text = 'Ein Objektspeicher für unstrukturierte Daten' where id = 1003252;
update public.antworten set text = 'Ein relationales Datenbanksystem für SQL-Abfragen' where id = 1003253;
update public.antworten set text = 'Ein Compute-Dienst für virtuelle Maschinen' where id = 1003254;
update public.antworten set text = 'Ein Messaging-Service für asynchrone Nachrichten' where id = 1003255;
-- Frage 210247: Was sind Storage Classes?
update public.antworten set text = 'Speicherklassen mit unterschiedlichen Kosten' where id = 1003256;
update public.antworten set text = 'Programmierklassen in Java mit statischen Attributen' where id = 1003257;
update public.antworten set text = 'Verschiedene VM-Größen mit CPU- und RAM-Ausstattung' where id = 1003258;
update public.antworten set text = 'Netzwerk-Bandbreiten-Stufen für den Datentransfer' where id = 1003259;
-- Frage 210248: Was ist Cloud SQL?
update public.antworten set text = 'Ein verwalteter Dienst für relationale Datenbanken' where id = 1003260;
update public.antworten set text = 'Ein NoSQL-Datenbankdienst für Dokumente und Key-Value-Daten' where id = 1003261;
update public.antworten set text = 'Ein Caching-Service für Sitzungsdaten im Arbeitsspeicher' where id = 1003263;
-- Frage 210249: Was ist Cloud Spanner?
update public.antworten set text = 'Eine global verteilte relationale Datenbank' where id = 1003264;
update public.antworten set text = 'Ein lokaler Datei-Speicher für VM-Instanzen' where id = 1003265;
update public.antworten set text = 'Eine Container-Registry für Docker-Images' where id = 1003266;
update public.antworten set text = 'Ein Log-Analyse-Tool für Anwendungsfehler' where id = 1003267;
-- Frage 210250: Was ist BigQuery?
update public.antworten set text = 'Ein Container-Dienst für orchestrierte Docker-Workloads' where id = 1003269;
update public.antworten set text = 'Ein VPN-Service für sichere Standortvernetzung' where id = 1003270;
update public.antworten set text = 'Ein E-Mail-Dienst für Marketing-Kampagnen' where id = 1003271;
-- Frage 210251: Was ist Firestore?
update public.antworten set text = 'Eine flexible, skalierbare NoSQL-Datenbank' where id = 1003272;
update public.antworten set text = 'Ein Firewall-Service für Web-Anwendungen' where id = 1003273;
update public.antworten set text = 'Ein Backup-Tool für VM-Snapshots' where id = 1003274;
update public.antworten set text = 'Ein Load Balancer für globale HTTP-Anfragen' where id = 1003275;
-- Frage 210252: Was ist Cloud Bigtable?
update public.antworten set text = 'Eine NoSQL-Datenbank für sehr große Datenmengen' where id = 1003276;
update public.antworten set text = 'Ein Tabellenkalkulations-Tool ähnlich Google Sheets' where id = 1003277;
update public.antworten set text = 'Ein Web-Hosting-Service für statische Seiten' where id = 1003278;
update public.antworten set text = 'Ein DNS-Dienst für öffentliche Zonen' where id = 1003279;
-- Frage 210253: Was ist VPC (Virtual Private Cloud)?
update public.antworten set text = 'Ein Speicherdienst für unstrukturierte Objektdaten' where id = 1003281;
update public.antworten set text = 'Ein Authentifizierungs-Tool für Benutzerkonten und Rollen' where id = 1003282;
update public.antworten set text = 'Ein Machine-Learning-Service für Bild- und Texterkennung' where id = 1003283;
-- Frage 210254: Was ist Cloud Load Balancing?
update public.antworten set text = 'Ein Backup-Service für Datenbanken mit Zeitplansteuerung' where id = 1003285;
update public.antworten set text = 'Ein Code-Deployment-Tool für automatisierte Releases' where id = 1003286;
update public.antworten set text = 'Ein Logging-Service für zentrale Anwendungsprotokolle' where id = 1003287;
-- Frage 210255: Was ist Cloud CDN?
update public.antworten set text = 'Ein Content Delivery Network für schnelle Auslieferung' where id = 1003288;
update public.antworten set text = 'Eine Registry zur Verwaltung von Container-Images' where id = 1003289;
update public.antworten set text = 'Ein vollständig verwalteter Datenbank-Service für SQL' where id = 1003290;
update public.antworten set text = 'Ein IAM-Tool für Benutzerrechte und Rollen' where id = 1003291;
-- Frage 210256: Was ist Cloud Interconnect?
update public.antworten set text = 'Ein Software-Update-Service für virtuelle Maschinen in GCP' where id = 1003293;
update public.antworten set text = 'Ein Monitoring-Dashboard für Metriken aller GCP-Dienste' where id = 1003294;
update public.antworten set text = 'Ein API-Gateway zur Verwaltung von REST-Schnittstellen' where id = 1003295;
-- Frage 210257: Was ist Cloud VPN?
update public.antworten set text = 'Eine verschlüsselte Verbindung über das Internet zu GCP' where id = 1003296;
update public.antworten set text = 'Ein Service für globales Video-Streaming' where id = 1003297;
update public.antworten set text = 'Ein Tool für die Migration relationaler Datenbanken' where id = 1003298;
update public.antworten set text = 'Ein Tool zur Orchestrierung von Container-Clustern' where id = 1003299;
-- Frage 210258: Was ist IAM (Identity and Access Management)?
update public.antworten set text = 'Verwaltung von Identitäten und Zugriffsrechten' where id = 1003300;
update public.antworten set text = 'Ein Instant-Messaging-Service für interne Teams' where id = 1003301;
update public.antworten set text = 'Ein Backup-Tool für relationale Datenbanken' where id = 1003302;
update public.antworten set text = 'Ein Netzwerk-Scanner für offene Ports' where id = 1003303;
-- Frage 210259: Was sind Service Accounts?
update public.antworten set text = 'Kundenservice-Hotlines für technische Supportanfragen der Nutzer' where id = 1003305;
update public.antworten set text = 'Billing-Konten für die Abrechnung von Zahlungen' where id = 1003306;
update public.antworten set text = 'Social-Media-Accounts des Unternehmens' where id = 1003307;
-- Frage 210260: Was ist Cloud Identity?
update public.antworten set text = 'IDaaS zur Verwaltung von Benutzern und Gruppen' where id = 1003308;
update public.antworten set text = 'Ein Cloud-Speicherdienst für Objekte und Backups' where id = 1003309;
update public.antworten set text = 'Ein Service zum Betrieb von Container-Workloads' where id = 1003310;
update public.antworten set text = 'Ein Backup-Tool für virtuelle Maschinen' where id = 1003311;
-- Frage 210261: Was ist Cloud KMS?
update public.antworten set text = 'Ein Dienst zur Verwaltung kryptografischer Schlüssel' where id = 1003312;
update public.antworten set text = 'Ein Monitoring-Service für Kubernetes-Cluster' where id = 1003314;
update public.antworten set text = 'Ein Knowledge-Management-System für Dokumentationen' where id = 1003315;
-- Frage 210262: Was ist Security Command Center?
update public.antworten set text = 'Ein Chatbot-Service für automatisierte Support-Dialoge mit Kunden' where id = 1003317;
update public.antworten set text = 'Ein Datenbank-Admin-Tool für Backups und Wartung' where id = 1003318;
update public.antworten set text = 'Ein Code-Editor mit integrierter Versionsverwaltung' where id = 1003319;
-- Frage 210263: Was ist Cloud Armor?
update public.antworten set text = 'Ein Backup-Service für persistente Disks und Instanzen' where id = 1003321;
update public.antworten set text = 'Eine Container-Registry für Docker-Images' where id = 1003322;
update public.antworten set text = 'Ein Machine-Learning-Tool für Bilderkennung' where id = 1003323;
-- Frage 210264: Was ist Binary Authorization?
update public.antworten set text = 'Erlaubt nur das Deployment vertrauenswürdiger Container' where id = 1003324;
update public.antworten set text = 'Ein Tool zum Kompilieren von Quellcode in Binärdateien' where id = 1003325;
update public.antworten set text = 'Ein Konverter von Binärdaten in Base64-Text' where id = 1003327;
-- Frage 210265: Was ist Cloud Monitoring?
update public.antworten set text = 'Überwachung von Metriken, Uptime und Leistung' where id = 1003328;
update public.antworten set text = 'Videoüberwachung von Rechenzentren' where id = 1003329;
update public.antworten set text = 'Tracking von Social-Media-Reichweiten' where id = 1003330;
update public.antworten set text = 'Überwachung von Finanztransaktionen und Budgets' where id = 1003331;
-- Frage 210266: Was ist Cloud Logging?
update public.antworten set text = 'Ein Hosting-Dienst für Blogs und statische Webseiten' where id = 1003334;
update public.antworten set text = 'Ein zentrales Login-Portal für Mitarbeiter' where id = 1003335;
-- Frage 210267: Was ist Cloud Trace?
update public.antworten set text = 'Verteiltes Tracing zur Analyse von Latenzproblemen' where id = 1003336;
update public.antworten set text = 'Ein GPS-Tracking-Service für Firmenfahrzeuge' where id = 1003337;
update public.antworten set text = 'Ein Zeichenprogramm für Vektorgrafiken' where id = 1003338;
update public.antworten set text = 'Ein E-Mail-Tracking-Tool für Newsletter-Kampagnen' where id = 1003339;
-- Frage 210269: Was ist Cloud Profiler?
update public.antworten set text = 'Analyse von CPU- und Speichernutzung in Anwendungen' where id = 1003344;
update public.antworten set text = 'Verwaltung von Social-Media-Profilen im Unternehmen' where id = 1003345;
update public.antworten set text = 'Vermittlung von IT-Fachkräften an Unternehmen' where id = 1003347;
-- Frage 210271: Was sind Committed Use Discounts?
update public.antworten set text = 'Rabatte für Neukunden in den ersten 90 Tagen' where id = 1003353;
update public.antworten set text = 'Rabatte für Studenten mit Hochschulnachweis' where id = 1003354;
update public.antworten set text = 'Rabatte für gemeinnützige Organisationen und Bildungsträger' where id = 1003355;
-- Frage 210272: Was sind Sustained Use Discounts?
update public.antworten set text = 'Einmalige Willkommens-Rabatte für Neukunden bei der Registrierung' where id = 1003359;
-- Frage 210273: Was sind Preemptible VMs?
update public.antworten set text = 'Premium-VMs mit vertraglich garantierter Verfügbarkeit von 99,99 %' where id = 1003361;
update public.antworten set text = 'VMs mit priorisiertem Support und schnelleren Antwortzeiten' where id = 1003362;
-- Frage 210274: Was ist Cloud Billing?
update public.antworten set text = 'Ein Online-Banking-Service für Firmenkonten' where id = 1003365;
update public.antworten set text = 'Ein Tool, mit dem man Rechnungen für eigene Kunden erstellt' where id = 1003366;
-- Frage 210275: Was sind Cost Management Best Practices?
update public.antworten set text = 'Optimierung und Kontrolle von Cloud-Ausgaben' where id = 1003368;
update public.antworten set text = 'Regeln für die Festlegung von Mitarbeiter-Gehältern' where id = 1003369;
update public.antworten set text = 'Planung des jährlichen Marketing-Budgets' where id = 1003370;
update public.antworten set text = 'Tipps zur Steueroptimierung im Konzern' where id = 1003371;
-- Frage 210276: Was ist eine GCP Region?
update public.antworten set text = 'Ein geografischer Standort mit mehreren Zonen' where id = 1003372;
update public.antworten set text = 'Eine Verwaltungseinheit für Benutzerkonten und Rollen' where id = 1003373;
update public.antworten set text = 'Eine Programmiersprache für Cloud-Funktionen' where id = 1003374;
update public.antworten set text = 'Ein Netzwerkprotokoll für Cloud-Verbindungen' where id = 1003375;
-- Frage 210277: Was ist eine Zone?
update public.antworten set text = 'Eine Zeitzone für Logging und Zeitstempel' where id = 1003377;
update public.antworten set text = 'Ein abgeschotteter Sicherheitsbereich im Firmennetzwerk' where id = 1003378;
update public.antworten set text = 'Eine Preiskategorie für Cloud-Ressourcen' where id = 1003379;
-- Frage 210279: Was ist der Unterschied zwischen Region und Multi-Region?
update public.antworten set text = 'Multi-Region verteilt Daten über mehrere Standorte' where id = 1003384;
update public.antworten set text = 'Es gibt keinen Unterschied bei der Datenhaltung' where id = 1003385;
update public.antworten set text = 'Multi-Region ist günstiger als eine einzelne Region' where id = 1003386;
-- Frage 210280: Was ist Cloud Deployment Manager?
update public.antworten set text = 'Ein Infrastructure-as-Code-Tool für GCP-Ressourcen' where id = 1003388;
update public.antworten set text = 'Ein HR-Tool für das Onboarding neuer Mitarbeiter' where id = 1003389;
update public.antworten set text = 'Ein App-Store für mobile Android-Anwendungen' where id = 1003390;
update public.antworten set text = 'Ein Tool zur Verwaltung von Social-Media-Kanälen' where id = 1003391;
-- Frage 210281: Was ist Terraform mit GCP?
update public.antworten set text = 'Ein Infrastructure-as-Code-Tool mit GCP-Unterstützung' where id = 1003392;
update public.antworten set text = 'Ein Service für Landschaftsgestaltung im Gartenbau' where id = 1003393;
update public.antworten set text = 'Ein Aufbauspiel von Google zur Geländeformung' where id = 1003394;
-- Frage 210282: Was ist Anthos?
update public.antworten set text = 'Plattform für Kubernetes-Management in Hybrid- und Multi-Cloud' where id = 1003396;
update public.antworten set text = 'Ein Speicherdienst für Backups in der Google Cloud' where id = 1003397;
update public.antworten set text = 'Ein Antivirenprogramm für virtuelle Maschinen' where id = 1003398;
update public.antworten set text = 'Ein verwalteter Datenbankdienst für relationale Workloads' where id = 1003399;
-- Frage 210283: Was ist Hybrid Cloud?
update public.antworten set text = 'Ein Verleih von Hybrid-Fahrzeugen für Firmen' where id = 1003401;
update public.antworten set text = 'Eine Mischung aus zwei verschiedenen Programmiersprachen in einem Projekt' where id = 1003402;
update public.antworten set text = 'Ein Online-Dienst für Wettervorhersagen' where id = 1003403;
-- Frage 210284: Was ist Multi-Cloud?
update public.antworten set text = 'Mehrere redundante Backup-Kopien innerhalb einer einzigen Cloud' where id = 1003405;
update public.antworten set text = 'Mehrere Benutzerkonten beim selben Cloud-Anbieter' where id = 1003407;
-- Frage 210285: Was ist AI Platform?
update public.antworten set text = 'Eine Plattform zum Trainieren und Deployen von ML-Modellen' where id = 1003408;
update public.antworten set text = 'Ein Chatbot für den Kundenservice im Online-Handel' where id = 1003409;
update public.antworten set text = 'Ein Sprachassistent für smarte Lautsprecher wie Alexa' where id = 1003410;
update public.antworten set text = 'Ein Roboter-Baukasten für Automatisierungstechnik' where id = 1003411;
-- Frage 210286: Was ist AutoML?
update public.antworten set text = 'Ein Dienst, der automatisch ML-Modelle erstellt und trainiert' where id = 1003412;
update public.antworten set text = 'Ein selbstfahrendes Auto aus der Google-Forschung' where id = 1003413;
update public.antworten set text = 'Ein automatischer E-Mail-Responder für den Kundensupport' where id = 1003414;
update public.antworten set text = 'Ein Tool zur Berechnung von Kfz-Versicherungstarifen' where id = 1003415;
-- Frage 210287: Was ist Vertex AI?
update public.antworten set text = 'Einheitliche Plattform für Machine-Learning-Modelle' where id = 1003416;
update public.antworten set text = 'Ein 3D-Modellierungs-Tool für Polygonnetze' where id = 1003417;
update public.antworten set text = 'Eine Engine zur Entwicklung von Videospielen' where id = 1003418;
update public.antworten set text = 'Ein Rechner für mathematische Graphen und Knoten' where id = 1003419;
-- Frage 210288: Was ist Cloud Pub/Sub?
update public.antworten set text = 'Ein asynchroner Messaging-Dienst für Events' where id = 1003420;
update public.antworten set text = 'Ein Online-Verzeichnis britischer Pubs' where id = 1003421;
update public.antworten set text = 'Ein Hosting-Service für Podcasts und Audiodateien' where id = 1003422;
update public.antworten set text = 'Ein Untertitel-Service für Videoplattformen' where id = 1003423;
-- Frage 210289: Was ist Dataflow?
update public.antworten set text = 'Verwalteter Dienst für Batch- und Stream-Verarbeitung' where id = 1003424;
update public.antworten set text = 'Ein Backup-Service für Datenbanken und Objektspeicher' where id = 1003425;
update public.antworten set text = 'Ein Monitor für Netzwerk-Bandbreiten im LAN' where id = 1003426;
update public.antworten set text = 'Ein Tool zur Simulation von Wasserflüssen' where id = 1003427;
-- Frage 210291: Was ist der Hauptvorteil von AWS Lambda?
update public.antworten set text = 'Günstigere Speicherung großer Datenmengen' where id = 1001061;
update public.antworten set text = 'Unbegrenzter Speicherplatz ohne Zusatzkosten' where id = 1001063;
-- Frage 210293: Was beschreibt das AWS Shared Responsibility Model?
update public.antworten set text = 'AWS ist für alles inklusive Kundendaten verantwortlich' where id = 1001069;
update public.antworten set text = 'Der Kunde ist für alles inklusive Hardware verantwortlich' where id = 1001070;
-- Frage 210294: Welches Tool hilft bei der Kostenkontrolle in AWS?
update public.antworten set text = 'AWS CloudFormation' where id = 1001074;
update public.antworten set text = 'AWS Elastic Beanstalk' where id = 1001075;
-- Frage 210295: Was ist Amazon CloudFront?
update public.antworten set text = 'Ein verwalteter relationaler Datenbankdienst' where id = 1001077;
update public.antworten set text = 'Ein Dienst für virtuelle Server' where id = 1001079;
-- Frage 210297: Was ist der Unterschied zwischen S3 Standard und S3 Glacier?
update public.antworten set text = 'Es gibt keinen Unterschied zwischen den beiden Klassen' where id = 1001085;
update public.antworten set text = 'Glacier ist schneller beim Abruf als S3 Standard' where id = 1001086;
update public.antworten set text = 'Standard ist für Archivierung mit längeren Abrufzeiten' where id = 1001087;
-- Frage 210298: Welches AWS-Service bietet Überwachung und Logging?
update public.antworten set text = 'Amazon Route 53' where id = 1001089;
update public.antworten set text = 'AWS CloudFormation' where id = 1001090;
-- Frage 210299: Was ist eine Availability Zone?
update public.antworten set text = 'Ein Land oder Kontinent mit mehreren Regionen' where id = 1001093;
update public.antworten set text = 'Ein einzelner Server in einem Rack des Rechenzentrums' where id = 1001094;
update public.antworten set text = 'Eine Datenbank mit automatischer Replikation' where id = 1001095;
-- Frage 210300: Welches Service ermöglicht DNS-Verwaltung?
update public.antworten set text = 'Amazon S3 Glacier' where id = 1001097;
update public.antworten set text = 'AWS Lambda@Edge' where id = 1001098;
update public.antworten set text = 'Amazon EC2 Auto Scaling' where id = 1001099;
-- Frage 210301: Was ist Amazon RDS?
update public.antworten set text = 'Ein Object-Storage-Service für Dateien' where id = 1001101;
update public.antworten set text = 'Ein Service für virtuelle Server' where id = 1001102;
update public.antworten set text = 'Ein CDN für statische Inhalte' where id = 1001103;
-- Frage 210302: Welches Prinzip beschreibt "Pay-as-you-go"?
update public.antworten set text = 'Man zahlt monatlich einen festen Pauschalbetrag' where id = 1001105;
update public.antworten set text = 'Man zahlt jährlich im Voraus für alle Ressourcen' where id = 1001106;
update public.antworten set text = 'Alle Ressourcen sind dauerhaft kostenlos nutzbar' where id = 1001107;
-- Frage 210303: Was ist AWS IAM?
update public.antworten set text = 'Eine verwaltete NoSQL-Datenbank' where id = 1001109;
update public.antworten set text = 'Ein Storage-Service für Objekte' where id = 1001110;
update public.antworten set text = 'Ein Service für virtuelle Server' where id = 1001111;
-- Frage 210305: Was ist der Hauptvorteil von Cloud Computing?
update public.antworten set text = 'Langsamere Bereitstellung neuer Server' where id = 1001117;
update public.antworten set text = 'Grundsätzlich höhere Kosten im Betrieb' where id = 1001118;
update public.antworten set text = 'Weniger Flexibilität bei der Skalierung' where id = 1001119;
-- Frage 210306: Was bedeutet "Elasticity" in der Cloud?
update public.antworten set text = 'Feste Ressourcenzuteilung ohne spätere Anpassung' where id = 1001121;
update public.antworten set text = 'Manuelle Serverkonfiguration durch Administratoren' where id = 1001122;
-- Frage 210307: Welches AWS-Service bietet virtuelle Windows/Linux Desktops?
update public.antworten set text = 'Amazon ElastiCache' where id = 1001127;
-- Frage 210308: Was ist horizontale Skalierung?
update public.antworten set text = 'Größere Instanzen mit mehr CPU und RAM verwenden' where id = 1001129;
update public.antworten set text = 'Physische Hardware gegen neuere austauschen' where id = 1001131;
-- Frage 210309: Welche Region sollte man wählen?
update public.antworten set text = 'Die Region mit den höchsten Preisen' where id = 1001133;
update public.antworten set text = 'Die Region, die am längsten verfügbar ist' where id = 1001134;
update public.antworten set text = 'Grundsätzlich immer die Region us-east-1' where id = 1001135;
-- Frage 210310: Was ist eine AWS Region?
update public.antworten set text = 'Ein einzelnes Rechenzentrum an einem Standort' where id = 1001137;
update public.antworten set text = 'Ein einzelner physischer Server in einem AWS-Rechenzentrum' where id = 1001138;
update public.antworten set text = 'Eine verwaltete Datenbank für globale Replikation' where id = 1001139;
-- Frage 210311: Was beschreibt Private Cloud?
update public.antworten set text = 'Eine für alle Nutzer öffentlich verfügbare Infrastruktur' where id = 1001141;
update public.antworten set text = 'Eine Mischung aus Public- und Private-Cloud-Anteilen' where id = 1001142;
update public.antworten set text = 'Die parallele Nutzung mehrerer Cloud-Anbieter' where id = 1001143;
-- Frage 210312: Was bedeutet High Availability?
update public.antworten set text = 'Schnellste Performance bei allen Zugriffen' where id = 1001145;
update public.antworten set text = 'Niedrigste Kosten im Regelbetrieb' where id = 1001146;
update public.antworten set text = 'Größtmögliche Speicherkapazität im Cluster' where id = 1001147;
-- Frage 210313: Welcher Service ermöglicht Hybrid Cloud?
update public.antworten set text = 'AWS Direct Connect mit Standleitung' where id = 1001148;
update public.antworten set text = 'Amazon S3 für Objektspeicherung' where id = 1001149;
update public.antworten set text = 'AWS Lambda für Serverless-Funktionen' where id = 1001150;
update public.antworten set text = 'Amazon RDS für relationale Datenbanken' where id = 1001151;
-- Frage 210314: Was ist Fault Tolerance?
update public.antworten set text = 'Schnellere Performance durch zusätzliche Cache-Server' where id = 1001153;
update public.antworten set text = 'Günstigere Kosten durch geteilte Ressourcen' where id = 1001154;
update public.antworten set text = 'Einfachere Bedienung über eine zentrale Konsole' where id = 1001155;
-- Frage 210315: Welches Sicherheitsprinzip beschreibt "Least Privilege"?
update public.antworten set text = 'Allen Benutzern standardmäßig Admin-Rechte geben' where id = 1001157;
update public.antworten set text = 'Unbegrenzte Rechte für alle Benutzerkonten' where id = 1001159;
-- Frage 210316: Was ist AWS KMS?
update public.antworten set text = 'Eine Datenbank für Schlüssel-Wert-Paare' where id = 1001161;
update public.antworten set text = 'Ein Storage-Service für Snapshots' where id = 1001162;
update public.antworten set text = 'Ein Server-Service für virtuelle Maschinen' where id = 1001163;
-- Frage 210317: Welches Tool prüft automatisch Security Best Practices?
update public.antworten set text = 'AWS Lambda (Serverless Compute)' where id = 1001165;
update public.antworten set text = 'Amazon S3 (Object Storage)' where id = 1001166;
update public.antworten set text = 'Amazon EC2 (Virtuelle Server)' where id = 1001167;
-- Frage 210319: Was ist MFA (Multi-Factor Authentication)?
update public.antworten set text = 'Nur ein einziges starkes Passwort' where id = 1001173;
update public.antworten set text = 'Verzicht auf jede Form der Authentifizierung' where id = 1001174;
update public.antworten set text = 'Ausschließlich biometrische Daten als einziger Faktor' where id = 1001175;
-- Frage 210321: Was ist AWS Artifact?
update public.antworten set text = 'Ein Storage-Service für Build-Artefakte' where id = 1001181;
update public.antworten set text = 'Eine Datenbank für Audit-Protokolle' where id = 1001182;
update public.antworten set text = 'Ein Server-Service für gehostete Anwendungen' where id = 1001183;
-- Frage 210322: Was ist AWS Config?
update public.antworten set text = 'Ein Datenbank-Service für relationale Workloads' where id = 1001185;
update public.antworten set text = 'Ein Storage-Service für die langfristige Archivierung' where id = 1001186;
update public.antworten set text = 'Ein Compute-Service für Container-Anwendungen' where id = 1001187;
-- Frage 210324: Welches Service verwaltet SSL/TLS-Zertifikate?
update public.antworten set text = 'AWS Certificate Manager' where id = 1001192;
update public.antworten set text = 'AWS Key Management Service' where id = 1001193;
update public.antworten set text = 'AWS Identity and Access Management' where id = 1001194;
-- Frage 210325: Was ist AWS GuardDuty?
update public.antworten set text = 'Eine Firewall für eingehenden Netzwerkverkehr' where id = 1001197;
update public.antworten set text = 'Ein Storage-Service für Objektdaten' where id = 1001198;
update public.antworten set text = 'Eine verwaltete relationale Datenbank' where id = 1001199;
-- Frage 210327: Was ist eine Security Group in AWS?
update public.antworten set text = 'Eine Benutzergruppe im IAM mit gemeinsamen Rechten' where id = 1001205;
update public.antworten set text = 'Ein Storage-Service für Backups und Archive' where id = 1001206;
update public.antworten set text = 'Eine relationale Datenbank für Kundendaten' where id = 1001207;
-- Frage 210328: Was ist eine NACL (Network Access Control List)?
update public.antworten set text = 'Stateful Firewall auf Instanz-Ebene für EC2' where id = 1001209;
update public.antworten set text = 'Ein Storage-Service für Netzwerkdaten' where id = 1001210;
update public.antworten set text = 'Eine NoSQL-Datenbank von AWS' where id = 1001211;
-- Frage 210329: Welches Service bietet Container-Orchestrierung?
update public.antworten set text = 'Amazon ECS oder Amazon EKS' where id = 1001212;
update public.antworten set text = 'AWS Lambda (Serverless)' where id = 1001213;
update public.antworten set text = 'Amazon S3 (Object Storage)' where id = 1001214;
update public.antworten set text = 'Amazon RDS (Relationale DB)' where id = 1001215;
-- Frage 210330: Was ist AWS Elastic Beanstalk?
update public.antworten set text = 'Eine verwaltete relationale Datenbank für Web-Apps' where id = 1001217;
update public.antworten set text = 'Ein Storage-Service für Backups' where id = 1001218;
update public.antworten set text = 'Ein Netzwerk-Service für virtuelle private Netze' where id = 1001219;
-- Frage 210332: Was ist Amazon SNS?
update public.antworten set text = 'Ein Datenbank-Service für NoSQL-Tabellen' where id = 1001225;
update public.antworten set text = 'Ein Storage-Service für Objekte' where id = 1001226;
update public.antworten set text = 'Ein Queue-Service zur Zwischenspeicherung von Messages' where id = 1001227;
-- Frage 210333: Welcher Speicher ist am schnellsten für EC2?
update public.antworten set text = 'Instance Store' where id = 1001228;
-- Frage 210334: Was ist Amazon EBS?
update public.antworten set text = 'Block-Storage für EC2-Instanzen' where id = 1001232;
update public.antworten set text = 'Ein Object Storage wie Amazon S3' where id = 1001233;
update public.antworten set text = 'Eine relationale Datenbank' where id = 1001234;
update public.antworten set text = 'Ein Compute-Service für Container' where id = 1001235;
-- Frage 210336: Was ist AWS Step Functions?
update public.antworten set text = 'Eine relationale Datenbank in der Cloud' where id = 1001241;
update public.antworten set text = 'Ein Storage-Service für große Dateien' where id = 1001242;
update public.antworten set text = 'Eine Firewall für Webanwendungen mit Regelwerk' where id = 1001243;
-- Frage 210337: Welches Service ermöglicht API-Management?
update public.antworten set text = 'Amazon API Gateway für REST-APIs' where id = 1001244;
update public.antworten set text = 'AWS Lambda für Serverless-Code' where id = 1001245;
update public.antworten set text = 'Amazon S3 für Objektspeicher' where id = 1001246;
update public.antworten set text = 'Amazon EC2 für virtuelle Server' where id = 1001247;
-- Frage 210338: Was ist Amazon Cognito?
update public.antworten set text = 'Eine Datenbank für Benutzerprofile' where id = 1001249;
update public.antworten set text = 'Ein Storage-Service für mobile App-Daten' where id = 1001250;
update public.antworten set text = 'Ein Compute-Service für Serverless-Funktionen' where id = 1001251;
-- Frage 210339: Welches Service bietet Machine Learning ohne Code?
update public.antworten set text = 'AWS Lambda mit Python-Runtime' where id = 1001253;
update public.antworten set text = 'Amazon S3 Intelligent-Tiering' where id = 1001254;
update public.antworten set text = 'Amazon EC2 mit GPU-Instanzen' where id = 1001255;
-- Frage 210340: Was ist AWS Glue?
update public.antworten set text = 'Eine relationale Datenbank für Transaktionsdaten' where id = 1001257;
update public.antworten set text = 'Ein Storage-Service für Objekte und Archive' where id = 1001258;
update public.antworten set text = 'Ein Compute-Service für virtuelle Maschinen' where id = 1001259;
-- Frage 210343: Was ist AWS CloudFormation?
update public.antworten set text = 'Eine verwaltete NoSQL-Datenbank' where id = 1001269;
update public.antworten set text = 'Ein Objekt-Storage-Service für Dateien' where id = 1001270;
update public.antworten set text = 'Ein Monitoring-Service für Metriken und Logs' where id = 1001271;
-- Frage 210344: Was ermöglicht Infrastructure as Code?
update public.antworten set text = 'AWS Lambda mit Step Functions' where id = 1001273;
update public.antworten set text = 'Amazon S3 mit Versionierung' where id = 1001274;
update public.antworten set text = 'Amazon EC2 mit Auto Scaling' where id = 1001275;
-- Frage 210345: Was ist Amazon Lightsail?
update public.antworten set text = 'Ein Database-Service für NoSQL' where id = 1001277;
update public.antworten set text = 'Ein Storage-Service für Archive' where id = 1001278;
update public.antworten set text = 'Ein Netzwerk-Service für DNS' where id = 1001279;
-- Frage 210346: Was ist AWS Fargate?
update public.antworten set text = 'Eine relationale Datenbank' where id = 1001281;
update public.antworten set text = 'Ein Storage-Service für Objektdaten' where id = 1001282;
update public.antworten set text = 'Ein Service für virtuelle Netzwerke (VPC)' where id = 1001283;
-- Frage 210347: Welches Preismodell bietet die größten Rabatte?
update public.antworten set text = 'On-Demand ohne Vertragsbindung' where id = 1001285;
update public.antworten set text = 'Free Tier für Neukunden' where id = 1001286;
update public.antworten set text = 'Spot Instances mit variablen Preisen' where id = 1001287;
-- Frage 210349: Was ist der Unterschied zwischen On-Demand und Spot Instances?
update public.antworten set text = 'Kein Unterschied, nur die Abrechnung erfolgt anders' where id = 1001293;
update public.antworten set text = 'On-Demand ist günstiger als alle anderen Modelle' where id = 1001294;
update public.antworten set text = 'Spot ist stabiler und wird nie von AWS beendet' where id = 1001295;
-- Frage 210350: Welches Tool erstellt automatische Kostenalarme?
update public.antworten set text = 'AWS Cost Explorer mit historischen Auswertungen' where id = 1001297;
update public.antworten set text = 'AWS Trusted Advisor mit Best-Practice-Prüfungen' where id = 1001298;
update public.antworten set text = 'AWS CloudTrail mit API-Protokollierung' where id = 1001299;
-- Frage 210351: Wie lange gilt der AWS Free Tier für EC2 t2.micro?
update public.antworten set text = '1 Monat nach der ersten Nutzung' where id = 1001302;
update public.antworten set text = '24 Monate ab Account-Erstellung' where id = 1001303;
-- Frage 210352: Was ist AWS Budgets?
update public.antworten set text = 'Service zum Festlegen von Kosten- und Nutzungsgrenzen' where id = 1001304;
-- Frage 210353: Welcher Support-Plan bietet 24/7 Telefonsupport?
update public.antworten set text = 'Der kostenlose Basic-Support-Plan für alle Kunden' where id = 1001309;
update public.antworten set text = 'Der Developer-Plan für Testumgebungen' where id = 1001310;
update public.antworten set text = 'Alle Support-Pläne ohne Ausnahme' where id = 1001311;
-- Frage 210354: Was ist AWS Trusted Advisor?
update public.antworten set text = 'Ein Dienst, der die AWS-Umgebung analysiert und Optimierungsempfehlungen gibt.' where id = 1003224;
-- Frage 210356: Was ist SAP ERP?
update public.antworten set text = 'Ein relationales Datenbank-System' where id = 1001317;
update public.antworten set text = 'Ein reiner Cloud-Storage-Service' where id = 1001318;
update public.antworten set text = 'Ein Betriebssystem für Server' where id = 1001319;
-- Frage 210358: Was bedeutet R/3?
update public.antworten set text = 'Release 3 des Systems SAP ERP' where id = 1001325;
update public.antworten set text = 'Router Version 3 des Netzwerkherstellers' where id = 1001326;
update public.antworten set text = 'Revision 3 des Datenbankschemas' where id = 1001327;
-- Frage 210359: Was ist SAP S/4HANA?
update public.antworten set text = 'Eine Cloud-Plattform für Webhosting' where id = 1001329;
update public.antworten set text = 'Ein Reporting-Tool für Kennzahlen' where id = 1001330;
update public.antworten set text = 'Eine objektorientierte Programmiersprache' where id = 1001331;
-- Frage 210361: Was ist die Transaktion SE11?
update public.antworten set text = 'ABAP Dictionary für Datenbanktabellen' where id = 1001336;
update public.antworten set text = 'Benutzerverwaltung mit Rollenzuordnung' where id = 1001337;
update public.antworten set text = 'Materialstamm-Pflege für die Logistik' where id = 1001338;
update public.antworten set text = 'Finanz-Reporting mit Bilanz und GuV' where id = 1001339;
-- Frage 210363: Was ist ein Mandant in SAP?
update public.antworten set text = 'Die höchste Organisationsebene im SAP-System' where id = 1001344;
update public.antworten set text = 'Ein Benutzerkonto mit umfassenden Adminrechten' where id = 1001345;
update public.antworten set text = 'Ein Werk mit eigenem Lagerort' where id = 1001346;
update public.antworten set text = 'Eine Kostenstelle im Controlling' where id = 1001347;
-- Frage 210364: Was ist SAP HANA?
update public.antworten set text = 'In-Memory-Datenbank für schnelle Verarbeitung' where id = 1001348;
update public.antworten set text = 'Ein Reporting-Tool für Finanzkennzahlen' where id = 1001349;
update public.antworten set text = 'Ein grafisches Frontend für Endanwender im Browser' where id = 1001350;
update public.antworten set text = 'Ein Modul für die Personalverwaltung' where id = 1001351;
-- Frage 210365: Welche Programmiersprache nutzt SAP?
update public.antworten set text = 'ABAP' where id = 1001352;
-- Frage 210366: Was ist ein Buchungskreis?
update public.antworten set text = 'Ein Werk mit angeschlossenen Lagerorten' where id = 1001357;
update public.antworten set text = 'Eine Kostenstelle für die interne Verrechnung von Gemeinkosten' where id = 1001358;
update public.antworten set text = 'Ein Mandant als oberste Organisationsebene' where id = 1001359;
-- Frage 210368: Was ist eine Kostenstelle?
update public.antworten set text = 'Ort an dem Kosten anfallen' where id = 1001364;
update public.antworten set text = 'Ein Produkt aus dem Sortiment' where id = 1001365;
update public.antworten set text = 'Ein Werk mit Produktionslinien' where id = 1001366;
update public.antworten set text = 'Ein Buchungskreis mit eigener Bilanz' where id = 1001367;
-- Frage 210369: Was ist SAP Fiori?
update public.antworten set text = 'Moderne, responsive User Experience' where id = 1001368;
update public.antworten set text = 'Eine In-Memory-Datenbank' where id = 1001369;
update public.antworten set text = 'Ein Modul für die Logistik' where id = 1001370;
update public.antworten set text = 'Eine proprietäre Programmiersprache' where id = 1001371;
-- Frage 210371: Was ist ein Werk in SAP?
update public.antworten set text = 'Ein Buchungskreis mit eigener Bilanzierung' where id = 1001377;
update public.antworten set text = 'Ein Mandant mit eigenen Stammdaten' where id = 1001378;
update public.antworten set text = 'Eine Kostenstelle für Gemeinkosten im Controlling' where id = 1001379;
-- Frage 210373: Was ist eine Organisationseinheit?
update public.antworten set text = 'Ein Benutzer mit Administrationsrechten' where id = 1001385;
update public.antworten set text = 'Ein Beleg aus der Materialwirtschaft' where id = 1001386;
update public.antworten set text = 'Eine Transaktion zum Anlegen neuer Stammdaten im System' where id = 1001387;
-- Frage 210374: Was ist ein Beleg in SAP?
update public.antworten set text = 'Eine Tabelle im ABAP Dictionary der Datenbank' where id = 1001389;
update public.antworten set text = 'Ein Report zur Auswertung von Bewegungsdaten' where id = 1001390;
update public.antworten set text = 'Eine Transaktion zum Aufruf einer Anwendung' where id = 1001391;
-- Frage 210376: Was ist SAP GUI?
update public.antworten set text = 'Eine In-Memory-Datenbank von SAP' where id = 1001397;
update public.antworten set text = 'Ein Modul für die Finanzbuchhaltung' where id = 1001398;
update public.antworten set text = 'Eine Programmiersprache für Datenbankabfragen' where id = 1001399;
-- Frage 210377: Was ist ein Kontenplan?
update public.antworten set text = 'Ein Werk als Organisationseinheit der Logistik' where id = 1001401;
update public.antworten set text = 'Ein Beleg der Finanzbuchhaltung' where id = 1001402;
update public.antworten set text = 'Eine Kostenstelle im Controlling' where id = 1001403;
-- Frage 210380: Was ist ein Lieferant in SAP?
update public.antworten set text = 'Kreditor, von dem man Waren oder Dienstleistungen bezieht' where id = 1001412;
update public.antworten set text = 'Ein Kunde, der Waren oder Dienstleistungen bei uns bestellt' where id = 1001413;
update public.antworten set text = 'Ein Material, das im Lager geführt und bewertet wird' where id = 1001414;
update public.antworten set text = 'Ein Werk mit eigener Produktion und Lagerhaltung' where id = 1001415;
-- Frage 210382: Was ist ein Arbeitsplan?
update public.antworten set text = 'Eine Stückliste aller benötigten Materialien' where id = 1001421;
update public.antworten set text = 'Ein Schichtplan für den Personaleinsatz' where id = 1001422;
update public.antworten set text = 'Eine Kalkulation der Herstellkosten' where id = 1001423;
-- Frage 210383: Was ist eine Stückliste (BOM)?
update public.antworten set text = 'Eine Rechnung über gelieferte Produkte' where id = 1001425;
update public.antworten set text = 'Ein Arbeitsplan mit Fertigungsschritten' where id = 1001426;
update public.antworten set text = 'Eine Bestellung beim Lieferanten' where id = 1001427;
-- Frage 210385: Welches Modul behandelt Lagerverwaltung?
update public.antworten set text = 'WM (Warehouse Management)' where id = 1001432;
-- Frage 210386: Was ist ein Lagerort?
update public.antworten set text = 'Ein Buchungskreis, der die externe Rechnungslegung abbildet' where id = 1001437;
update public.antworten set text = 'Eine Kostenstelle für die interne Kostenverrechnung' where id = 1001438;
update public.antworten set text = 'Ein Mandant als oberste Ebene im SAP-System' where id = 1001439;
-- Frage 210387: Was ist Bestandsführung?
update public.antworten set text = 'Buchung von Belegen in der Finanzbuchhaltung' where id = 1001441;
update public.antworten set text = 'Verwaltung der Personalstammdaten' where id = 1001442;
update public.antworten set text = 'Verrechnung von Gemeinkosten' where id = 1001443;
-- Frage 210388: Was ist eine Warenbewegung?
update public.antworten set text = 'Eine Buchung auf einem Sachkonto im Modul FI' where id = 1001445;
update public.antworten set text = 'Ein Kundenauftrag mit Positionen und Wunschlieferdatum' where id = 1001446;
update public.antworten set text = 'Eine Rechnung an den Kunden aus der Fakturierung' where id = 1001447;
-- Frage 210391: Was ist Fakturierung?
update public.antworten set text = 'Prüfung und Buchung des Wareneingangs' where id = 1001457;
update public.antworten set text = 'Abrechnung der Löhne und Gehälter' where id = 1001459;
-- Frage 210392: Was ist ein Kreditor?
update public.antworten set text = 'Lieferant, von dem man Waren bezieht' where id = 1001460;
update public.antworten set text = 'Ein Kunde, der bei uns Waren bestellt' where id = 1001461;
update public.antworten set text = 'Ein Mitarbeiter der Buchhaltungsabteilung' where id = 1001463;
-- Frage 210393: Was ist ein Debitor?
update public.antworten set text = 'Ein Lieferant, von dem man Waren bezieht' where id = 1001465;
update public.antworten set text = 'Ein Material mit eigener Materialnummer' where id = 1001466;
update public.antworten set text = 'Eine Kostenstelle im internen Rechnungswesen' where id = 1001467;
-- Frage 210394: Was ist Kontenabstimmung?
update public.antworten set text = 'Planung des Materialbedarfs für die Fertigung' where id = 1001469;
update public.antworten set text = 'Planung des Personalbedarfs je Abteilung' where id = 1001470;
update public.antworten set text = 'Planung der Produktionsmengen für das Folgequartal' where id = 1001471;
-- Frage 210395: Was ist der Unterschied zwischen Kostenstelle und Kostenträger?
update public.antworten set text = 'Es gibt keinen Unterschied, die Begriffe sind synonym' where id = 1001473;
update public.antworten set text = 'Beides bezeichnet in SAP dieselbe Organisationseinheit' where id = 1001474;
-- Frage 210396: Was ist ein Kostenträger?
update public.antworten set text = 'Eine Abteilung mit eigenem Budgetverantwortlichen' where id = 1001477;
update public.antworten set text = 'Ein Buchungskreis mit eigener Bilanz' where id = 1001478;
update public.antworten set text = 'Ein Werk mit mehreren Lagerorten' where id = 1001479;
-- Frage 210397: Was ist Gemeinkostenzuschlag?
update public.antworten set text = 'Die Materialkosten eines einzelnen Auftrags' where id = 1001481;
update public.antworten set text = 'Die Lohnkosten der Fertigungsmitarbeiter' where id = 1001482;
update public.antworten set text = 'Der Verkaufspreis abzüglich aller Rabatte' where id = 1001483;
-- Frage 210399: Was ist ein Profitcenter?
update public.antworten set text = 'Eine Kostenstelle für allgemeine Gemeinkosten' where id = 1001489;
update public.antworten set text = 'Ein Werk mit mehreren Lagerorten' where id = 1001490;
update public.antworten set text = 'Ein Mandant mit eigener Konfiguration' where id = 1001491;
-- Frage 210400: Was ist interne Auftragsverwaltung?
update public.antworten set text = 'Abwicklung und Fakturierung von Aufträgen externer Kunden' where id = 1001493;
update public.antworten set text = 'Verwaltung von Bestellungen an externe Lieferanten' where id = 1001494;
update public.antworten set text = 'Steuerung und Terminierung von Aufträgen in der Fertigung' where id = 1001495;
-- Frage 210401: Was ist Ergebnisrechnung (CO-PA)?
update public.antworten set text = 'Analyse der Profitabilität nach Marktsegmenten' where id = 1001496;
update public.antworten set text = 'Kostenstellenrechnung für interne Gemeinkosten' where id = 1001497;
update public.antworten set text = 'Finanzbuchhaltung mit Hauptbuchkonten' where id = 1001498;
update public.antworten set text = 'Materialwirtschaft mit Bestandsführung' where id = 1001499;
-- Frage 210402: Was ist SAP BW (Business Warehouse)?
update public.antworten set text = 'Die relationale Datenbank unter einem SAP-ERP-System' where id = 1001502;
-- Frage 210403: Was ist SAP BI (Business Intelligence)?
update public.antworten set text = 'Ein Modul für die Finanzbuchhaltung' where id = 1001505;
update public.antworten set text = 'Eine Transaktion zur Belegerfassung' where id = 1001506;
update public.antworten set text = 'Eine relationale Datenbank für Stammdaten' where id = 1001507;
-- Frage 210404: Was ist ein Data Warehouse?
update public.antworten set text = 'Ein Lager für Waren mit Regalverwaltung' where id = 1001509;
update public.antworten set text = 'Ein ERP-System für operative Geschäftsprozesse' where id = 1001510;
update public.antworten set text = 'Eine Transaktion zur Datenerfassung' where id = 1001511;
-- Frage 210405: Was ist ein InfoCube?
update public.antworten set text = 'Eine Tabelle mit Stammdaten' where id = 1001513;
update public.antworten set text = 'Ein Report mit eigenem Selektionsbildschirm' where id = 1001514;
-- Frage 210406: Was ist ein Query in SAP?
update public.antworten set text = 'Abfrage von Daten aus einem InfoProvider' where id = 1001516;
update public.antworten set text = 'Eine Transaktion zum Buchen von Belegen' where id = 1001517;
update public.antworten set text = 'Eine Datenbank für Bewegungsdaten' where id = 1001519;
-- Frage 210407: Was ist SAP Solution Manager?
update public.antworten set text = 'Ein ERP-Modul für Vertrieb, Versand und Fakturierung' where id = 1001521;
update public.antworten set text = 'Die zentrale In-Memory-Datenbank hinter SAP-Systemen' where id = 1001522;
update public.antworten set text = 'Ein Entwicklungswerkzeug für ABAP-Programme und SAP-Reports' where id = 1001523;
-- Frage 210408: Was ist Change Management in SAP?
update public.antworten set text = 'Personalverwaltung mit Zeitwirtschaft und Abrechnung' where id = 1001525;
update public.antworten set text = 'Materialverwaltung mit Bestandsführung im Lager' where id = 1001526;
update public.antworten set text = 'Finanzmanagement mit Hauptbuch und Nebenbüchern' where id = 1001527;
-- Frage 210409: Was ist Transport Management?
update public.antworten set text = 'Der Warenversand an Kunden über eine Spedition' where id = 1001529;
update public.antworten set text = 'Die Materialplanung für die Produktion' where id = 1001530;
update public.antworten set text = 'Die Finanzplanung für das Geschäftsjahr' where id = 1001531;
-- Frage 210410: Was ist ein Customizing-Request?
update public.antworten set text = 'Eine Bestellung aus dem Einkauf' where id = 1001533;
update public.antworten set text = 'Ein Kundenauftrag aus dem Vertriebsmodul SD' where id = 1001534;
update public.antworten set text = 'Eine Rechnung aus der Kreditorenbuchhaltung' where id = 1001535;
-- Frage 210412: Was ist ein Hintergrund-Job?
update public.antworten set text = 'Ein Dialog-Programm mit Benutzereingaben' where id = 1001541;
update public.antworten set text = 'Eine Transaktion im Dialogbetrieb' where id = 1001542;
update public.antworten set text = 'Ein Modul für die Finanzbuchhaltung' where id = 1001543;
-- Frage 210413: Was ist Batch-Input?
update public.antworten set text = 'Manuelle Eingabe einzelner Belege' where id = 1001545;
update public.antworten set text = 'Ein Report zur Auswertung von Belegen' where id = 1001546;
-- Frage 210415: Was ist SAP NetWeaver?
update public.antworten set text = 'Ein ERP-Modul für die Logistik' where id = 1001553;
update public.antworten set text = 'Eine In-Memory-Datenbank für Echtzeitanalysen' where id = 1001554;
update public.antworten set text = 'Ein Frontend für den Browserzugriff' where id = 1001555;
-- Frage 210416: Was ist ein RFC (Remote Function Call)?
update public.antworten set text = 'Eine Transaktion zum Verbuchen von Wareneingängen' where id = 1001557;
update public.antworten set text = 'Ein Report zur Systemüberwachung' where id = 1001558;
update public.antworten set text = 'Eine Datenbank mit replizierten Daten' where id = 1001559;
-- Frage 210417: Was ist eine BAPI?
update public.antworten set text = 'Eine Transaktion für die Belegerfassung' where id = 1001561;
update public.antworten set text = 'Ein Report für betriebswirtschaftliche Auswertungen' where id = 1001562;
update public.antworten set text = 'Eine Datenbank für Bewegungsdaten' where id = 1001563;
-- Frage 210418: Was ist ein IDoc?
update public.antworten set text = 'Intermediate Document für Datenaustausch' where id = 1001564;
update public.antworten set text = 'Ein Beleg aus der Finanzbuchhaltung' where id = 1001565;
update public.antworten set text = 'Eine transparente Tabelle im ABAP Dictionary' where id = 1001566;
update public.antworten set text = 'Ein Report für Auswertungen im Modul FI' where id = 1001567;
-- Frage 210419: Was ist ALE (Application Link Enabling)?
update public.antworten set text = 'Ein Modul für das Personalwesen' where id = 1001569;
update public.antworten set text = 'Eine Datenbank für Archivdaten' where id = 1001570;
update public.antworten set text = 'Ein Frontend für die Anzeige auf mobilen Endgeräten' where id = 1001571;
-- Frage 210420: Was ist EDI (Electronic Data Interchange)?
update public.antworten set text = 'Interne Kommunikation zwischen Abteilungen eines Unternehmens' where id = 1001573;
update public.antworten set text = 'Eine zentrale Datenbank für Lieferantendaten' where id = 1001574;
update public.antworten set text = 'Ein Report über Bestellvorgänge im Einkauf' where id = 1001575;
-- Frage 210421: Was ist SAP PI/PO (Process Integration)?
update public.antworten set text = 'Eine In-Memory-Datenbank für Prozessdaten' where id = 1001578;
update public.antworten set text = 'Ein Frontend-Framework für mobile Endgeräte und Tablets' where id = 1001579;
-- Frage 210422: Was ist Master Data Management (MDM)?
update public.antworten set text = 'Verwaltung von Bewegungsdaten wie Bestellungen' where id = 1001581;
update public.antworten set text = 'Ein Report für das Management' where id = 1001582;
update public.antworten set text = 'Eine Transaktion im Warenwirtschaftssystem' where id = 1001583;
-- Frage 210423: Was ist Archivierung in SAP?
update public.antworten set text = 'Endgültiges Löschen von Daten ohne Sicherung' where id = 1001585;
update public.antworten set text = 'Backup der kompletten Datenbank' where id = 1001586;
update public.antworten set text = 'Reporting über historische Belege' where id = 1001587;
-- Frage 210424: Was ist Reorganisation?
update public.antworten set text = 'Archivierung alter Belegdaten' where id = 1001589;
update public.antworten set text = 'Tägliches Backup aller Systemdatenbanken' where id = 1001590;
update public.antworten set text = 'Reporting über aktuelle Systemkennzahlen' where id = 1001591;
-- Frage 210425: Was ist ein Berechtigungskonzept?
update public.antworten set text = 'Ein Modul für die Logistikabwicklung' where id = 1001593;
update public.antworten set text = 'Eine Transaktion zum Anlegen von Stammdaten' where id = 1001594;
update public.antworten set text = 'Ein Report über offene Posten im Finanzwesen' where id = 1001595;
-- Frage 210426: Was ist ein Berechtigungsobjekt?
update public.antworten set text = 'Eine Rolle mit zugeordneten Transaktionen' where id = 1001598;
update public.antworten set text = 'Ein Profil mit mehreren Einzelrollen' where id = 1001599;
-- Frage 210427: Was ist eine Rolle in SAP?
update public.antworten set text = 'Ein einzelner Benutzer mit eigenem Passwort' where id = 1001601;
update public.antworten set text = 'Eine Kostenstelle für die interne Verrechnung' where id = 1001602;
update public.antworten set text = 'Ein Werk mit angeschlossenem Lagerort' where id = 1001603;
-- Frage 210428: Was ist die Transaktion SU01?
update public.antworten set text = 'Benutzerverwaltung' where id = 1001604;
update public.antworten set text = 'Pflege des Materialstamms' where id = 1001605;
update public.antworten set text = 'Buchung von Finanzbelegen' where id = 1001606;
update public.antworten set text = 'Anlage von Kundenaufträgen' where id = 1001607;
-- Frage 210429: Was ist der Profil-Generator?
update public.antworten set text = 'Ein Report zur Auswertung von Anmeldungen' where id = 1001609;
update public.antworten set text = 'Eine Datenbank für Benutzerstammdaten' where id = 1001610;
update public.antworten set text = 'Ein Modul für die Personalverwaltung' where id = 1001611;
-- Frage 210430: Was ist SAP GRC (Governance, Risk, Compliance)?
update public.antworten set text = 'Suite für Risikomanagement und Compliance' where id = 1001612;
update public.antworten set text = 'Ein ERP-Modul für den operativen Einkauf' where id = 1001613;
-- Frage 210431: Was ist Segregation of Duties (SoD)?
update public.antworten set text = 'Aufteilung der Kosten auf Kostenstellen' where id = 1001617;
update public.antworten set text = 'Aufteilung von Material auf mehrere Werke' where id = 1001618;
update public.antworten set text = 'Aufteilung der Gehälter auf mehrere Konten' where id = 1001619;
-- Frage 210432: Was ist SAP Cloud Platform?
update public.antworten set text = 'PaaS zum Entwickeln und Erweitern von Anwendungen' where id = 1001620;
update public.antworten set text = 'Ein komplettes ERP-System, das nur aus der Cloud läuft' where id = 1001621;
-- Frage 210433: Was ist SAP Ariba?
update public.antworten set text = 'Ein ERP-Modul für die Finanzbuchhaltung' where id = 1001625;
update public.antworten set text = 'Eine In-Memory-Datenbank für Analysen' where id = 1001626;
-- Frage 210434: Was ist SAP SuccessFactors?
update public.antworten set text = 'Ein rein on-premise betriebenes HR-Modul' where id = 1001629;
update public.antworten set text = 'Eine In-Memory-Datenbank für Analysen' where id = 1001630;
update public.antworten set text = 'Ein Tool für die Finanzbuchhaltung' where id = 1001631;
-- Frage 210435: Was ist SAP C/4HANA?
update public.antworten set text = 'Ein ERP-System für die Warenwirtschaft' where id = 1001633;
update public.antworten set text = 'Eine In-Memory-Datenbank für Analysen' where id = 1001634;
update public.antworten set text = 'Ein HR-System für die Personalabrechnung' where id = 1001635;
-- Frage 210486: Was ist Microsoft Azure?
update public.antworten set text = 'Ein Server-Betriebssystem von Microsoft für Rechenzentren' where id = 1001837;
update public.antworten set text = 'Eine Programmiersprache von Microsoft für Web-Apps' where id = 1001839;
-- Frage 210487: Was ist eine Azure Subscription?
update public.antworten set text = 'Ein dedizierter physischer Server im Rechenzentrum' where id = 1001841;
update public.antworten set text = 'Ein virtuelles Netzwerk für Azure-Ressourcen' where id = 1001843;
-- Frage 210488: Was ist Azure Resource Manager (ARM)?
update public.antworten set text = 'Eine global verteilte NoSQL-Datenbank in Azure' where id = 1001845;
update public.antworten set text = 'Ein Dienst für Blob-Speicher und Dateifreigaben' where id = 1001846;
update public.antworten set text = 'Eine vorkonfigurierte virtuelle Maschine mit Windows Server' where id = 1001847;
-- Frage 210489: Was sind Azure Resource Groups?
update public.antworten set text = 'Eine besonders leistungsstarke Art von VM' where id = 1001849;
update public.antworten set text = 'Ein Netzwerk zur Verbindung mehrerer virtueller Maschinen' where id = 1001851;
-- Frage 210490: Was ist Azure Compute?
update public.antworten set text = 'Ausschließlich klassische virtuelle Maschinen' where id = 1001853;
update public.antworten set text = 'Storage-Service für Blobs und Disks' where id = 1001854;
update public.antworten set text = 'Netzwerk-Service für virtuelle Netze' where id = 1001855;
-- Frage 210491: Was sind Azure Virtual Machines?
update public.antworten set text = 'Physische Server, die Microsoft im Kundenrechenzentrum aufstellt' where id = 1001857;
update public.antworten set text = 'Verwaltete relationale Datenbanken mit automatischen Backups' where id = 1001858;
-- Frage 210492: Was ist Azure App Service?
update public.antworten set text = 'Eine verwaltete NoSQL-Datenbank' where id = 1001861;
update public.antworten set text = 'Ein Storage-Service für Blobs und Dateien' where id = 1001862;
update public.antworten set text = 'Eine VM mit vorinstalliertem Windows Server' where id = 1001863;
-- Frage 210493: Was ist Azure Functions?
update public.antworten set text = 'Eine virtuelle Maschine mit Windows Server' where id = 1001865;
update public.antworten set text = 'Eine relationale SQL-Datenbank' where id = 1001866;
update public.antworten set text = 'Ein Storage-Service für Blob-Objekte' where id = 1001867;
-- Frage 210494: Was ist Azure Kubernetes Service (AKS)?
update public.antworten set text = 'Eine VM mit vorinstalliertem Docker' where id = 1001869;
update public.antworten set text = 'Eine verwaltete Datenbank für relationale Daten' where id = 1001870;
update public.antworten set text = 'Ein Storage-Service für persistente Volumes' where id = 1001871;
-- Frage 210495: Was ist Azure Storage?
update public.antworten set text = 'Ein Dienst ausschließlich für Dateifreigaben per SMB' where id = 1001873;
update public.antworten set text = 'Eine relationale Datenbank für SQL-Abfragen' where id = 1001874;
update public.antworten set text = 'Eine virtuelle Maschine mit lokalen Datenträgern' where id = 1001875;
-- Frage 210497: Was ist Azure File Storage?
update public.antworten set text = 'Object Storage für Blobs' where id = 1001881;
update public.antworten set text = 'Relationale Datenbank als Managed Service' where id = 1001882;
update public.antworten set text = 'Queue Service für Messages' where id = 1001883;
-- Frage 210498: Was ist Azure Queue Storage?
update public.antworten set text = 'Datenbank für relationale Tabellen' where id = 1001885;
update public.antworten set text = 'File Storage für SMB-Dateifreigaben' where id = 1001886;
update public.antworten set text = 'Object Storage für große unstrukturierte Binärdateien' where id = 1001887;
-- Frage 210500: Was ist Azure SQL Database?
update public.antworten set text = 'NoSQL Datenbank für JSON-Dokumente' where id = 1001893;
update public.antworten set text = 'Object Storage für unstrukturierte Daten' where id = 1001894;
update public.antworten set text = 'File Storage für Netzwerkfreigaben' where id = 1001895;
-- Frage 210501: Was ist Azure Cosmos DB?
update public.antworten set text = 'Relationale Datenbank mit festem Schema' where id = 1001897;
update public.antworten set text = 'Object Storage für unstrukturierte Blobs' where id = 1001898;
update public.antworten set text = 'Message Queue für asynchrone Servicekommunikation' where id = 1001899;
-- Frage 210506: Was ist Azure Active Directory (Azure AD)?
update public.antworten set text = 'Das klassische On-Premises Active Directory im Rechenzentrum' where id = 1001917;
update public.antworten set text = 'Eine relationale Datenbank in der Cloud' where id = 1001918;
update public.antworten set text = 'Ein Storage-Service für Dateien' where id = 1001919;
-- Frage 210507: Was ist Azure AD B2C?
update public.antworten set text = 'Mitarbeiter-Identity für das interne Firmennetz' where id = 1001921;
update public.antworten set text = 'Eine relationale Datenbank für App-Daten' where id = 1001922;
update public.antworten set text = 'Storage Service für Benutzerdateien' where id = 1001923;
-- Frage 210508: Was ist Multi-Factor Authentication (MFA)?
update public.antworten set text = 'Ein Verfahren, das nur ein starkes Passwort verlangt' where id = 1001925;
update public.antworten set text = 'Eine Firewall zum Filtern des Netzwerkverkehrs' where id = 1001926;
update public.antworten set text = 'Verschlüsselung der Daten bei der Übertragung' where id = 1001927;
-- Frage 210509: Was ist Azure Key Vault?
update public.antworten set text = 'Eine Datenbank für verschlüsselte Kundendatensätze' where id = 1001929;
update public.antworten set text = 'File Storage für vertrauliche Dokumente' where id = 1001930;
update public.antworten set text = 'Eine VM mit vorinstallierten Sicherheitstools' where id = 1001931;
-- Frage 210511: Was ist Azure DDoS Protection?
update public.antworten set text = 'Eine Firewall für ein- und ausgehende Web-Anfragen' where id = 1001937;
update public.antworten set text = 'Verschlüsselung ruhender Daten im Storage' where id = 1001938;
update public.antworten set text = 'Identity Management für Benutzer und Gruppen' where id = 1001939;
-- Frage 210514: Was ist Azure Log Analytics?
update public.antworten set text = 'Eine relationale Datenbank für Geschäftsdaten' where id = 1001949;
update public.antworten set text = 'Ein Storage Service für Blobs und Dateien' where id = 1001950;
update public.antworten set text = 'Eine Firewall für eingehenden Netzwerkverkehr' where id = 1001951;
-- Frage 210516: Was ist Azure Advisor?
update public.antworten set text = 'Eine Datenbank für Telemetriedaten' where id = 1001957;
update public.antworten set text = 'Monitoring Service für Metriken und Logs' where id = 1001958;
update public.antworten set text = 'Storage Service für unstrukturierte Daten' where id = 1001959;
-- Frage 210517: Was ist Azure Service Health?
update public.antworten set text = 'Überwacht Performance-Metriken und Logs der eigenen Anwendungen' where id = 1001961;
update public.antworten set text = 'Bewertet die Sicherheitslage aller Ressourcen des Abonnements' where id = 1001963;
-- Frage 210518: Was ist Azure Cost Management?
update public.antworten set text = 'Monitoring Service für Metriken und Diagnosedaten' where id = 1001965;
update public.antworten set text = 'Security Tool zur Bedrohungserkennung' where id = 1001966;
update public.antworten set text = 'Storage Service für Blob-Container' where id = 1001967;
-- Frage 210519: Was ist der Azure Pricing Calculator?
update public.antworten set text = 'Monitoring Tool für Metriken, Logs und Alerts' where id = 1001969;
update public.antworten set text = 'Security Tool zur Bedrohungserkennung' where id = 1001970;
update public.antworten set text = 'Backup Service für Azure-Ressourcen' where id = 1001971;
-- Frage 210520: Was ist Total Cost of Ownership (TCO)?
update public.antworten set text = 'Nur die monatlichen Kosten der Cloud-Dienste' where id = 1001973;
update public.antworten set text = 'Nur die Anschaffungskosten der Hardware' where id = 1001974;
update public.antworten set text = 'Nur die jährlichen Lizenzkosten der eingesetzten Software' where id = 1001975;
-- Frage 210521: Was sind Azure Reservations?
update public.antworten set text = 'Pay-As-You-Go ohne Laufzeitbindung' where id = 1001977;
update public.antworten set text = 'Kostenlose Services im Free Tier' where id = 1001978;
update public.antworten set text = 'Spot Instances mit kurzfristiger Verfügbarkeit' where id = 1001979;
-- Frage 210523: Was ist das Pay-As-You-Go Modell?
update public.antworten set text = 'Monatliche Fixkosten unabhängig von der Nutzung' where id = 1001985;
update public.antworten set text = 'Jährliche Vorauszahlung für reservierte Kapazität' where id = 1001986;
update public.antworten set text = 'Kostenlose Nutzung aller Basisdienste' where id = 1001987;
-- Frage 210524: Was ist eine Azure Region?
update public.antworten set text = 'Ein einzelnes Rechenzentrum an einem festen Standort' where id = 1001989;
update public.antworten set text = 'Eine einzelne virtuelle Maschine in einem Rechenzentrum' where id = 1001990;
update public.antworten set text = 'Ein Storage Account für Blob- und Dateispeicher' where id = 1001991;
-- Frage 210525: Was ist eine Availability Zone?
update public.antworten set text = 'Eine geografische Region wie zum Beispiel West Europe' where id = 1001993;
update public.antworten set text = 'Ein Storage Tier für selten genutzte Daten' where id = 1001994;
update public.antworten set text = 'Eine VM-Größe mit besonders viel Arbeitsspeicher' where id = 1001995;
-- Frage 210527: Was ist Azure SLA (Service Level Agreement)?
update public.antworten set text = 'Die monatlichen Kosten eines Services' where id = 1002001;
update public.antworten set text = 'Garantie für die maximale Performance' where id = 1002002;
update public.antworten set text = 'Das Security-Level eines Rechenzentrums' where id = 1002003;
-- Frage 210528: Was bedeutet High Availability in Azure?
update public.antworten set text = 'Schnellstmögliche Performance aller VMs' where id = 1002005;
update public.antworten set text = 'Niedrigste Kosten durch Reserved Instances' where id = 1002006;
update public.antworten set text = 'Größtmöglicher Storage pro Konto' where id = 1002007;
-- Frage 210529: Was ist Azure Backup?
update public.antworten set text = 'Verwalteter Dienst zum Sichern und Wiederherstellen von Daten' where id = 1002008;
update public.antworten set text = 'Ein Dienst für automatisches Failover in eine andere Azure-Region' where id = 1002009;
-- Frage 210530: Was ist Azure Site Recovery?
update public.antworten set text = 'Repliziert Workloads und schwenkt im Notfall um' where id = 1002012;
-- Frage 210532: Was ist Azure Policy?
update public.antworten set text = 'Monitoring Service für Metriken, Logs und Alerts' where id = 1002021;
update public.antworten set text = 'Backup Service für virtuelle Maschinen' where id = 1002022;
update public.antworten set text = 'Identity Management für Benutzerkonten' where id = 1002023;
-- Frage 210533: Was ist Azure Blueprints?
update public.antworten set text = 'Monitoring Service für Metriken und Logs' where id = 1002025;
update public.antworten set text = 'Backup Service für virtuelle Maschinen und Datenbanken' where id = 1002026;
update public.antworten set text = 'Eine VM mit vorkonfiguriertem Betriebssystem' where id = 1002027;
-- Frage 210534: Was ist Azure RBAC (Role-Based Access Control)?
update public.antworten set text = 'Ein Monitoring-Service für Metriken und Logs' where id = 1002029;
update public.antworten set text = 'Ein Backup-Service für virtuelle Maschinen' where id = 1002030;
update public.antworten set text = 'Ein Storage-Service für Dateien und Blobs' where id = 1002031;
-- Frage 210706: Was macht ein Fremdschlüssel (Foreign Key)?
update public.antworten set text = 'Er verweist auf den Primärschlüssel einer anderen Tabelle' where id = 1003550;
update public.antworten set text = 'Er erlaubt externen Datenbanken den Zugriff auf die Tabelle' where id = 1003552;
update public.antworten set text = 'Er ersetzt den Primärschlüssel automatisch, wenn dieser NULL ist' where id = 1003553;
-- Frage 210708: Was bedeutet der Wert NULL in einer Datenbank?
update public.antworten set text = 'Die Abwesenheit eines Wertes' where id = 1003558;
update public.antworten set text = 'Ein einzelnes Leerzeichen im Feld' where id = 1003561;
-- Frage 210733: Was macht DEFAULT in einer Spalten-Definition?
update public.antworten set text = 'Definiert den maximal erlaubten Wert für die Spalte' where id = 1003606;
update public.antworten set text = 'Erstellt automatisch einen Index zur Beschleunigung von Abfragen' where id = 1003607;
-- Frage 210736: Welche Bedingung muss eine Tabelle erfüllen, um in der 1. Normalform (1NF) zu sein?
update public.antworten set text = 'Jeder Attributwert muss atomar sein, ohne Mehrfachwerte' where id = 1003608;
-- Frage 2108: Wofür wird ein DNS CNAME-Record verwendet?
update public.antworten set text = 'Mappt einen Domainnamen direkt auf eine IPv4-Adresse (A-Record)' where id = 1003457;
update public.antworten set text = 'Definiert den zuständigen Mailserver einer Domain (MX-Record)' where id = 1003458;
-- Frage 210802: Was ist die Hauptaufgabe eines Routers?
update public.antworten set text = 'Netzwerke verbinden und Pakete zwischen ihnen weiterleiten' where id = 1003794;
update public.antworten set text = 'IP-Adressen automatisch per DHCP an Geräte im Netz vergeben' where id = 1003797;
-- Frage 210803: Was ist das Default-Gateway?
update public.antworten set text = 'Die IP, an die Pakete für fremde Netze gesendet werden' where id = 1003798;
update public.antworten set text = 'Die erste verfügbare IP-Adresse im lokalen Subnetz' where id = 1003800;
update public.antworten set text = 'Die IP-Adresse des zuständigen DNS-Servers' where id = 1003801;
-- Frage 210809: In welcher Form werden IPv6-Adressen dargestellt?
update public.antworten set text = '8 Gruppen aus je 4 Hex-Zeichen mit Doppelpunkten' where id = 1003816;
update public.antworten set text = '6 Hex-Paare mit Bindestrichen wie bei MAC-Adressen' where id = 1003818;
-- Frage 210828: Was ist der Unterschied zwischen einem Virus und einem Wurm?
update public.antworten set text = 'Ein Wurm befällt nur Linux-Systeme, ein Virus ausschließlich Windows-Rechner' where id = 1003878;
update public.antworten set text = 'Es gibt keinen Unterschied, beide Begriffe bezeichnen genau dasselbe Schadprogramm' where id = 1003879;
-- Frage 210829: Was ist Phishing?
update public.antworten set text = 'Datendiebstahl über gefälschte E-Mails oder Webseiten' where id = 1003880;
-- Frage 210831: Was ist Social Engineering?
update public.antworten set text = 'Psychologische Manipulation zur Preisgabe vertraulicher Informationen' where id = 1003888;
update public.antworten set text = 'Das Ausnutzen rein technischer Schwachstellen in Softwaresystemen' where id = 1003890;
-- Frage 210836: Warum sollten Passwörter NIE im Klartext in einer Datenbank gespeichert werden?
update public.antworten set text = 'Klartext-Passwörter belegen deutlich mehr Speicherplatz in der Tabelle' where id = 1003903;
update public.antworten set text = 'Klartext-Passwörter verlangsamen die Prüfung beim Login deutlich' where id = 1003905;
-- Frage 210837: Was bewirkt ein „Salt" beim Passwort-Hashing?
update public.antworten set text = 'Gleiche Passwörter erzeugen unterschiedliche Hashes' where id = 1003906;
update public.antworten set text = 'Komprimiert den Hash, um Speicherplatz in der Datenbank zu sparen' where id = 1003909;
-- Frage 210848: Was macht 3DES (Triple-DES) anders als DES?
update public.antworten set text = 'Kombiniert DES mit zwei zusätzlichen kryptografischen Hash-Verfahren' where id = 1003943;
-- Frage 210850: Welche Anwendung nutzt AES heute typischerweise?
update public.antworten set text = 'Nur in militärischen Anwendungen und bei Behörden' where id = 1003949;
-- Frage 210855: Wozu dient ein digitales Zertifikat?
update public.antworten set text = 'Bescheinigt, zu wem ein Public Key gehört' where id = 1003964;
-- Frage 210869: Welcher Firewall-Typ kann auch Inhalte (z.B. SQL-Injection) erkennen?
update public.antworten set text = 'Web Application Firewall (WAF)' where id = 1004011;
update public.antworten set text = 'Paketfilter-Firewall auf OSI-Schicht 3' where id = 1004012;
update public.antworten set text = 'Stateful Inspection Firewall' where id = 1004013;
update public.antworten set text = 'NAT-Firewall mit Adressumsetzung' where id = 1004014;
-- Frage 210876: Was bewirkt ein CSRF-Token?
update public.antworten set text = 'Verhindert gefälschte Anfragen im Namen eingeloggter Nutzer' where id = 1004033;
update public.antworten set text = 'Verschlüsselt die Session-Cookies des Nutzers zusätzlich' where id = 1004034;
-- Frage 210880: Was ist der Kerngedanke des Zero-Trust-Modells?
update public.antworten set text = 'Niemand wird automatisch vertraut, jeder Zugriff wird neu geprüft' where id = 1004045;
update public.antworten set text = 'Mitarbeiter im Büro brauchen keine Passwörter und keine 2FA mehr' where id = 1004046;
-- Frage 210885: Eine Mitarbeiterin findet einen unbekannten USB-Stick auf dem Parkplatz und steckt ihn in 
update public.antworten set text = 'Brute-Force-Angriff auf Passwörter' where id = 1004060;
update public.antworten set text = 'Man-in-the-Middle-Angriff auf die Verbindung' where id = 1004061;
-- Frage 210944: Welche Aufgabe hat die Bitübertragungsschicht (Schicht 1) des OSI-Modells?
update public.antworten set text = 'Rohe Bits werden über das physische Medium übertragen' where id = 1004266;
-- Frage 210954: In welchem Szenario ist UDP gegenüber TCP klar im Vorteil?
update public.antworten set text = 'Bei Video- und Sprachanrufen in Echtzeit' where id = 1004302;
-- Frage 210982: Welche Datenheinheit (PDU) wird auf Schicht 4 (Transport) verwendet, wenn TCP zum Einsatz 
update public.antworten set text = 'Datagramm' where id = 1004373;
-- Frage 210989: Welches der folgenden Merkmale ist KEIN typisches Merkmal eines Projekts?
update public.antworten set text = 'Einmaligkeit des Vorhabens' where id = 1004393;
update public.antworten set text = 'Zeitliche Befristung des Vorhabens' where id = 1004394;
update public.antworten set text = 'Eine klar definierte Zielvorgabe' where id = 1004395;
-- Frage 210991: Welches der folgenden Vorhaben ist am ehesten ein Projekt?
update public.antworten set text = 'Tägliche inkrementelle Backups aller Server durchführen' where id = 1004401;
update public.antworten set text = 'Eingehende Helpdesk-Tickets im täglichen Regelbetrieb bearbeiten' where id = 1004402;
update public.antworten set text = 'Regelmäßige Routine-Wartung der Bürodrucker nach Wartungsplan' where id = 1004403;
-- Frage 210998: Was ist ein Meilenstein im Projektmanagement?
update public.antworten set text = 'Ein Ereignis ohne Dauer an einem wichtigen Kontrollpunkt' where id = 1004422;
update public.antworten set text = 'Ein Arbeitspaket mit besonders langer Dauer und hohen Kosten' where id = 1004423;
update public.antworten set text = 'Eine wöchentliche Besprechung zum Projektstatus' where id = 1004424;
-- Frage 211002: Was ist ein Stakeholder?
update public.antworten set text = 'Wer das Projekt beeinflussen kann oder davon betroffen ist' where id = 1004432;
update public.antworten set text = 'Nur Personen, die das Projekt finanziell unterstützen oder sponsern' where id = 1004433;
update public.antworten set text = 'Ausschließlich Personen, die das Projekt ablehnen' where id = 1004434;
-- Frage 211003: Welche Aufgabe hat der Lenkungsausschuss in einem Projekt?
update public.antworten set text = 'Die operative Umsetzung der Arbeitspakete im täglichen Projektgeschäft' where id = 1004437;
update public.antworten set text = 'Das Schreiben des Lastenhefts für den Auftraggeber' where id = 1004438;
-- Frage 211009: Welche Aussage zur SMART-Methode ist KORREKT?
update public.antworten set text = 'Spezifisch, Messbar, Akzeptiert, Realistisch, Terminiert' where id = 1004454;
update public.antworten set text = 'Nach SMART dürfen Ziele bewusst vage und offen formuliert werden' where id = 1004457;
-- Frage 211010: Ein Auftraggeber möchte das Projekt 2 Monate früher fertig haben. Welche unmittelbaren Kon
update public.antworten set text = 'Entweder steigen die Kosten oder die Qualität sinkt' where id = 1004458;
update public.antworten set text = 'Die Qualität steigt automatisch mit der Verkürzung' where id = 1004460;
-- Frage 211011: Was ist ein Nicht-Ziel im Projektmanagement?
update public.antworten set text = 'Eine Festlegung, was NICHT zum Projektumfang gehört' where id = 1004462;
update public.antworten set text = 'Ein Ziel, das im Lastenheft absichtlich vage formuliert wird' where id = 1004463;
update public.antworten set text = 'Ein Ziel, das vom Auftraggeber im Kick-off abgelehnt wurde' where id = 1004465;
-- Frage 211013: Was ist die kleinste planbare Einheit in einem Projektstrukturplan (PSP)?
update public.antworten set text = 'Das Arbeitspaket' where id = 1004466;
-- Frage 211019: Wie wird ein Vorgang in einem Gantt-Diagramm dargestellt?
update public.antworten set text = 'Als Pfeil zwischen zwei Knoten im Netzplan' where id = 1004486;
-- Frage 211032: Was ist die korrekte Definition des kritischen Pfads?
update public.antworten set text = 'Der Pfad mit der höchsten Anzahl an Arbeitspaketen im Projektplan' where id = 1004528;
update public.antworten set text = 'Der Pfad mit dem höchsten geplanten Budget' where id = 1004529;
-- Frage 211048: Ein IT-Unternehmen führt eine Cloud-Migration durch. Der Geschäftsführer ist Auftraggeber,
update public.antworten set text = 'Der Lenkungsausschuss' where id = 1004580;
update public.antworten set text = 'Der Auftraggeber' where id = 1004581;
update public.antworten set text = 'Der externe Projektleiter' where id = 1004582;
update public.antworten set text = 'Das interne Projektteam' where id = 1004583;
-- Frage 211049: Ein Risiko hat Eintrittswahrscheinlichkeit 25% und einen möglichen Schaden von 80.000 EUR.
update public.antworten set text = 'Ja, der Risikowert von 20.000 EUR übersteigt die Kosten deutlich' where id = 1004584;
update public.antworten set text = 'Nein, die Versicherung ist mit 5.000 EUR teurer als der Risikowert' where id = 1004585;
-- Frage 211053: Wie nennt man das Zurückholen von Daten aus einem Backup?
update public.antworten set text = 'Recovery' where id = 1004596;
update public.antworten set text = 'Rollback' where id = 1004597;
-- Frage 211060: Worauf bezieht sich ein inkrementelles Backup?
update public.antworten set text = 'Auf Änderungen seit dem letzten Backup beliebiger Art' where id = 1004618;
update public.antworten set text = 'Auf sämtliche Änderungen seit dem letzten Vollbackup' where id = 1004619;
update public.antworten set text = 'Auf den kompletten Datenbestand des Systems' where id = 1004620;
-- Frage 211068: Warum sollen die Backups auf 2 VERSCHIEDENEN Medien liegen?
update public.antworten set text = 'Verschiedene Medien sind im Einkauf immer günstiger als gleiche' where id = 1004641;
update public.antworten set text = 'Ein einzelner Medientyp kann technisch nur eine Backup-Kopie speichern' where id = 1004642;
update public.antworten set text = 'Die DSGVO schreibt zwei verschiedene Medien verbindlich vor' where id = 1004643;
-- Frage 211079: Was beschreibt der RTO (Recovery Time Objective)?
update public.antworten set text = 'Wie viel Datenverlust nach einem Ausfall maximal akzeptabel ist' where id = 1004673;
update public.antworten set text = 'Wie oft ein Backup auf Wiederherstellbarkeit getestet werden muss' where id = 1004674;
update public.antworten set text = 'Wie lange ein Backup nach der Erstellung aufbewahrt werden muss' where id = 1004675;
-- Frage 211085: Was ist ein Immutable Backup?
update public.antworten set text = 'Ein Backup, das nachträglich nicht mehr verändert werden kann' where id = 1004690;
update public.antworten set text = 'Ein Backup, das nur Administratoren mit Sonderrechten löschen dürfen' where id = 1004692;
-- Frage 211089: Wofür stehen die zusätzlichen „1" und „0" in der erweiterten 3-2-1-1-0-Regel?
update public.antworten set text = 'Eine Kopie offline/immutable, null Fehler beim Restore-Test' where id = 1004706;
update public.antworten set text = 'Ein zusätzlicher Backup-Admin und null laufende Kosten' where id = 1004707;
update public.antworten set text = 'Ein zusätzliches Backup pro Stunde und null Datenverlust' where id = 1004708;
update public.antworten set text = 'Eine zusätzliche Cloud-Kopie und null Verschlüsselung' where id = 1004709;
-- Frage 211095: Eine Firma hat RPO = 24 Stunden und macht nur ein tägliches Backup um 2 Uhr nachts. Um 23 
update public.antworten set text = 'Ja, 21 Stunden Datenverlust liegen innerhalb der 24 Stunden' where id = 1004726;
update public.antworten set text = 'Nein, der RPO wurde mit 21 Stunden deutlich überschritten' where id = 1004727;
update public.antworten set text = 'Ja, aber nur weil Datenverlust in der Nacht nicht zählt' where id = 1004728;
-- Frage 211096: Warum reicht es NICHT, eine Backup-Strategie einmal einzurichten und dann nie wieder zu pr
update public.antworten set text = 'Backups können unbemerkt fehlschlagen, das zeigt erst ein Recovery-Test' where id = 1004730;
update public.antworten set text = 'Weil das Gesetz monatliche Backup-Tests für alle Firmen vorschreibt' where id = 1004731;
update public.antworten set text = 'Damit die Backups schneller laufen und weniger Bandbreite belegen' where id = 1004732;
update public.antworten set text = 'Um regelmäßig Speicherplatz auf den Backup-Medien freizugeben' where id = 1004733;
-- Frage 211104: Welcher Server wird bei einer DNS-Abfrage ZUERST gefragt?
update public.antworten set text = 'Der Resolver, oft der DNS-Server des Providers' where id = 1004752;
update public.antworten set text = 'Der Root-Server der IANA-Rootzone' where id = 1004753;
update public.antworten set text = 'Der autoritative Server der angefragten Ziel-Domain' where id = 1004754;
update public.antworten set text = 'Der TLD-Server der jeweiligen Endung' where id = 1004755;
-- Frage 211106: Welcher Server kennt die tatsächliche IP-Adresse einer Domain?
update public.antworten set text = 'Der Root-Server der DNS-Hierarchie' where id = 1004761;
update public.antworten set text = 'Der Resolver des Providers' where id = 1004762;
update public.antworten set text = 'Der TLD-Nameserver der Domainendung' where id = 1004763;
-- Frage 211107: Was bewirkt DNS-Caching?
update public.antworten set text = 'Es speichert DNS-Antworten für wiederholte Abfragen zwischen' where id = 1004764;
update public.antworten set text = 'Es verschlüsselt die DNS-Kommunikation zum Resolver' where id = 1004765;
-- Frage 211113: Wofür wird ein DNS MX-Record verwendet?
update public.antworten set text = 'Verknüpft den Namen der Domain mit einer festen IPv4-Adresse' where id = 1004783;
-- Frage 211117: Wozu dienen Ports?
update public.antworten set text = 'Die Übertragungsgeschwindigkeit im Netzwerk erhöhen' where id = 1004795;
update public.antworten set text = 'Daten bei der Übertragung verschlüsseln' where id = 1004796;
update public.antworten set text = 'IP-Adressen im Netzwerk automatisch per DHCP vergeben' where id = 1004797;
-- Frage 211118: Mit welcher Analogie lässt sich das Verhältnis von IP-Adresse und Port gut beschreiben?
update public.antworten set text = 'IP = Schlüssel, Port = passendes Schloss' where id = 1004799;
update public.antworten set text = 'IP = Auto, Port = Tankstelle an der Autobahn' where id = 1004800;
update public.antworten set text = 'IP = einzelnes Buch, Port = ganze Bibliothek' where id = 1004801;
-- Frage 211130: Was ist der Hauptunterschied zwischen TCP und UDP?
update public.antworten set text = 'TCP ist verbindungsorientiert und zuverlässig, UDP verbindungslos' where id = 1004838;
update public.antworten set text = 'TCP ist deutlich schneller, UDP dafür deutlich zuverlässiger' where id = 1004839;
update public.antworten set text = 'TCP nutzt Portnummern, UDP arbeitet komplett ohne Ports' where id = 1004840;
update public.antworten set text = 'Es gibt keinen Unterschied außer dem Namen der Protokolle' where id = 1004841;
-- Frage 211131: Wie heißt der Verbindungsaufbau bei TCP?
update public.antworten set text = 'Port-Knocking mit vordefinierter Sequenz' where id = 1004844;
-- Frage 211134: Was ist ein Port-Scan?
update public.antworten set text = 'Das automatische Schließen ungenutzter Ports durch die Firewall' where id = 1004856;
update public.antworten set text = 'Das Zuweisen neuer Portnummern an laufende Netzwerkdienste' where id = 1004857;
-- Frage 211141: Warum nutzt DNS in der Regel UDP statt TCP?
update public.antworten set text = 'DNS-Abfragen sind klein, UDP spart den Verbindungsaufbau' where id = 1004878;
update public.antworten set text = 'UDP ist bei Paketverlust zuverlässiger als TCP' where id = 1004879;
update public.antworten set text = 'UDP verschlüsselt die Abfragen automatisch mit TLS 1.3' where id = 1004881;
-- Frage 211149: Welche Technik nutzt RAID 0?
update public.antworten set text = 'Mirroring (Daten auf zwei Platten spiegeln)' where id = 1004901;
update public.antworten set text = 'Parity (Paritätsblöcke auf allen Platten)' where id = 1004902;
-- Frage 211151: Welche Technik nutzt RAID 1?
update public.antworten set text = 'Striping (Daten blockweise auf Platten verteilen)' where id = 1004909;
update public.antworten set text = 'Parity (Berechnung von Paritätsblöcken)' where id = 1004910;
-- Frage 211156: Was ist „Parity" im RAID-Kontext?
update public.antworten set text = 'Eine Prüfinformation zur Rekonstruktion verlorener Daten' where id = 1004922;
update public.antworten set text = 'Eine zweite, vollständig gespiegelte Kopie aller Daten' where id = 1004923;
update public.antworten set text = 'Eine Verschlüsselung der Daten zum Schutz gegen Diebstahl' where id = 1004924;
-- Frage 211177: Was ist das Besondere an einem SAN (Storage Area Network)?
update public.antworten set text = 'Ein Cloud-Speicherdienst für Privatnutzer mit Web-Oberfläche' where id = 1004996;
update public.antworten set text = 'Eine spezielle Backup-Software für NAS-Geräte im Heimnetzwerk' where id = 1004997;
-- Frage 211178: Was ist der zentrale Unterschied zwischen NAS und SAN?
update public.antworten set text = 'NAS arbeitet auf Datei-Ebene, SAN auf Block-Ebene' where id = 1004998;
update public.antworten set text = 'NAS ist in der Anschaffung immer teurer als ein SAN' where id = 1004999;
-- Frage 211183: Ein Unternehmen nutzt RAID 5 mit 4 Platten à 1 TB. Eine Platte fällt aus. Was passiert?
update public.antworten set text = 'Alle Daten sind sofort verloren und müssen aus dem Backup geholt werden' where id = 1005015;
-- Frage 211186: Ein Kunde sagt: „Wir haben ein RAID, also brauchen wir kein Backup." Wie bewertest du dies
update public.antworten set text = 'Falsch, RAID schützt nicht vor Löschen, Ransomware oder Katastrophen' where id = 1005026;
update public.antworten set text = 'Richtig, ein gespiegeltes RAID macht zusätzliche Backups komplett überflüssig' where id = 1005027;
update public.antworten set text = 'Richtig, aber nur bei RAID 6 mit doppelter Parität' where id = 1005028;
update public.antworten set text = 'Falsch, denn RAID ersetzt sogar zwei getrennte Backups' where id = 1005029;
-- Frage 211199: Was ist der Unterschied zwischen = und == ?
update public.antworten set text = '= vergleicht zwei Werte, == weist einen Wert zu' where id = 1005067;
update public.antworten set text = '= ist nur für Zahlen erlaubt, == nur für Text' where id = 1005069;
-- Frage 211201: Wozu dient eine if/else-Struktur?
update public.antworten set text = 'Das Programm wiederholt einen Codeblock mehrfach in einer Schleife' where id = 1005071;
update public.antworten set text = 'Das Programm speichert einen Wert in einer Variablen' where id = 1005072;
-- Frage 211205: Wofür eignet sich switch/case besonders gut?
update public.antworten set text = 'Wenn ein Codeblock unendlich oft wiederholt werden soll' where id = 1005083;
update public.antworten set text = 'Wenn man mehrere Werte addieren möchte' where id = 1005084;
-- Frage 211212: Was ist eine Endlosschleife und wie entsteht sie häufig?
update public.antworten set text = 'Eine Schleife, deren Abbruchbedingung nie erreicht wird' where id = 1005102;
update public.antworten set text = 'Eine Schleife, die genau einmal komplett durchlaufen wird' where id = 1005103;
update public.antworten set text = 'Eine Schleife mit einem Syntaxfehler im Schleifenkopf' where id = 1005104;
update public.antworten set text = 'Eine Schleife, die den Zähler rückwärts herunterzählt' where id = 1005105;
-- Frage 211221: Wofür steht „Kapselung" (Encapsulation) in der OOP?
update public.antworten set text = 'Eine Klasse Attribute und Methoden einer anderen erben lassen' where id = 1005127;
update public.antworten set text = 'Mehrere Objekte einer Klasse gleichzeitig im Speicher erstellen' where id = 1005128;
-- Frage 211222: Wozu dient ein Konstruktor in einer Klasse?
update public.antworten set text = 'Er initialisiert die Attribute beim Erzeugen eines Objekts' where id = 1005130;
update public.antworten set text = 'Er entfernt ein Objekt endgültig aus dem Arbeitsspeicher' where id = 1005131;
update public.antworten set text = 'Er vergleicht zwei Objekte anhand ihrer Attributwerte' where id = 1005132;
-- Frage 211223: Was beschreibt Polymorphie in der OOP am besten?
update public.antworten set text = 'Ein Objekt kann mehrere Konstruktoren gleichzeitig besitzen' where id = 1005135;
update public.antworten set text = 'Eine Klasse kann außer Methoden keine eigenen Attribute besitzen' where id = 1005136;
update public.antworten set text = 'Daten eines Objekts werden durch Kapselung vor direktem Zugriff geschützt' where id = 1005137;
-- Frage 211224: Was unterscheidet üblicherweise ein Interface von einer abstrakten Klasse?
update public.antworten set text = 'Ein Interface enthält nur Methoden-Vorgaben, eine abstrakte Klasse auch fertigen Code' where id = 1005138;
update public.antworten set text = 'Ein Interface kann direkt instanziiert werden, eine abstrakte Klasse dagegen niemals' where id = 1005139;
update public.antworten set text = 'Es gibt keinen Unterschied, beide sind identisch nutzbar' where id = 1005140;
update public.antworten set text = 'Eine abstrakte Klasse darf grundsätzlich keine Methoden deklarieren' where id = 1005141;
-- Frage 211227: Ein Programmierer schreibt: if (x = 5). Was ist hier das Problem?
update public.antworten set text = 'Die Zahl 5 ist in einer if-Bedingung nicht erlaubt' where id = 1005151;
update public.antworten set text = 'if-Bedingungen brauchen in C-Sprachen immer ein else' where id = 1005152;
-- Frage 211229: Gegeben: zahlen = [10, 20, 30]. Was passiert bei zahlen[3]?
update public.antworten set text = 'Es wird der Wert 30 als letztes Element ausgegeben' where id = 1005159;
update public.antworten set text = 'Es wird der Standardwert 0 zurückgegeben' where id = 1005160;
-- Frage 211236: In welcher Stufe der Geschäftsfähigkeit ist ein 14-Jähriger?
update public.antworten set text = 'Bereits voll geschäftsfähig' where id = 1005179;
update public.antworten set text = 'Geschäftsunfähig nach § 104 BGB' where id = 1005180;
update public.antworten set text = 'Nicht rechtsfähig nach BGB' where id = 1005181;
-- Frage 211240: Was ist eine Willenserklärung?
update public.antworten set text = 'Ein gesetzlich vorgeschriebenes Formular für Verträge' where id = 1005191;
update public.antworten set text = 'Die schriftliche Quittung nach einem Barkauf' where id = 1005192;
update public.antworten set text = 'Eine mündliche Beschwerde beim Verkäufer über mangelhafte Ware' where id = 1005193;
-- Frage 211241: Welche Hauptpflicht hat der Verkäufer bei einem Kaufvertrag?
update public.antworten set text = 'Den vereinbarten Kaufpreis fristgerecht zahlen' where id = 1005195;
update public.antworten set text = 'Die Ware annehmen und auf Mängel untersuchen' where id = 1005196;
-- Frage 211242: Was ist der Unterschied zwischen Besitz und Eigentum?
update public.antworten set text = 'Besitz und Eigentum bezeichnen rechtlich exakt dasselbe' where id = 1005199;
update public.antworten set text = 'Eigentum bezeichnet nur das tatsächliche Halten und Nutzen der Sache' where id = 1005200;
update public.antworten set text = 'Besitz bedeutet immer, dass man die Sache selbst gekauft und bezahlt hat' where id = 1005201;
-- Frage 211244: Muss ein Kaufvertrag schriftlich geschlossen werden, um gültig zu sein?
update public.antworten set text = 'Nein, die meisten Kaufverträge sind formfrei' where id = 1005202;
update public.antworten set text = 'Ja, ohne Schriftform ist er in jedem Fall nichtig' where id = 1005204;
-- Frage 211255: Wann kommt ein Schuldner OHNE Mahnung in Verzug?
update public.antworten set text = 'Wenn ein fester Zahlungstermin kalendermäßig vereinbart war' where id = 1005212;
update public.antworten set text = 'Nur nach drei schriftlichen Mahnungen mit Fristsetzung' where id = 1005213;
update public.antworten set text = 'Niemals, eine vorherige Mahnung ist immer Pflicht' where id = 1005214;
-- Frage 211260: Wozu dient eine Abmahnung im Arbeitsrecht?
update public.antworten set text = 'Sie beendet das Arbeitsverhältnis fristlos ohne weitere Schritte' where id = 1005223;
update public.antworten set text = 'Sie verpflichtet den Arbeitgeber zu einer Gehaltserhöhung' where id = 1005224;
update public.antworten set text = 'Sie verlängert die Probezeit automatisch um sechs Monate' where id = 1005225;
-- Frage 211262: Ab wie vielen ständigen Arbeitnehmern kann ein Betriebsrat gewählt werden?
update public.antworten set text = 'Ab 2 ständigen Arbeitnehmern' where id = 1005227;
update public.antworten set text = 'Ab 10 ständigen Arbeitnehmern' where id = 1005228;
update public.antworten set text = 'Ab 50 ständigen Arbeitnehmern' where id = 1005229;
-- Frage 211273: Was regelt die DSGVO?
update public.antworten set text = 'Die Sicherheit kritischer Stromnetze in Europa' where id = 1005254;
update public.antworten set text = 'Die Vergabe von Domainnamen und IP-Adressen im Internet' where id = 1005255;
-- Frage 211275: Was ist eine Prokura?
update public.antworten set text = 'Ein Handelsregistereintrag über die Insolvenz einer Firma' where id = 1005260;
update public.antworten set text = 'Eine besondere Form der außerordentlichen Kündigung' where id = 1005261;
-- Frage 211283: Ein Unternehmen will sein Privatvermögen vor Geschäftsrisiken schützen. Welche Rechtsform 
update public.antworten set text = 'Eine GmbH (Kapitalgesellschaft)' where id = 1005280;
update public.antworten set text = 'Ein Einzelunternehmen (e. K.)' where id = 1005283;
-- Frage 220020: Was ist der Hauptunterschied zwischen Personengesellschaften und Kapitalgesellschaften?
update public.antworten set text = 'Gesellschafter von Personengesellschaften haften persönlich' where id = 1002352;
update public.antworten set text = 'Personengesellschaften brauchen ein hohes Mindestkapital' where id = 1002355;
-- Frage 220021: Wozu dient das Handelsregister?
update public.antworten set text = 'Privates Unternehmensnetzwerk für Geschäftskontakte' where id = 1002357;
update public.antworten set text = 'Steuerregister des Finanzamts für alle Betriebe' where id = 1002358;
update public.antworten set text = 'Mitarbeiterverzeichnis der örtlichen IHK' where id = 1002359;
-- Frage 220023: Was ist eine Prokura?
update public.antworten set text = 'Eine Vollmacht für ausnahmslos alle Rechtsgeschäfte' where id = 1002365;
update public.antworten set text = 'Ein befristeter Arbeitsvertrag mit Sondervergütung' where id = 1002366;
update public.antworten set text = 'Die Bestellung zum Geschäftsführer der GmbH' where id = 1002367;
-- Frage 220024: Wie lange beträgt die gesetzliche Gewährleistungsfrist bei Kaufverträgen?
update public.antworten set text = '6 Monate ab Übergabe der Ware' where id = 1002369;
update public.antworten set text = '1 Jahr bei allen Kaufverträgen' where id = 1002370;
update public.antworten set text = '5 Jahre ab Vertragsschluss' where id = 1002371;
-- Frage 220026: Was ist eine Willenserklärung?
update public.antworten set text = 'Jede Meinungsäußerung im geschäftlichen Umfeld' where id = 1002377;
update public.antworten set text = 'Nur schriftlich abgegebene Erklärungen mit Unterschrift' where id = 1002378;
update public.antworten set text = 'Eine unverbindliche Absichtserklärung ohne Bindungswillen' where id = 1002379;
-- Frage 220027: Wann kann ein Vertrag angefochten werden?
update public.antworten set text = 'Immer, wenn man den Vertrag bereut' where id = 1002381;
update public.antworten set text = 'Nur bei strafrechtlich nachgewiesenem Betrug' where id = 1002382;
update public.antworten set text = 'Nur innerhalb von 14 Tagen nach Vertragsschluss' where id = 1002383;
-- Frage 220029: Muss ein Arbeitsvertrag schriftlich geschlossen werden?
update public.antworten set text = 'Ja, ohne Schriftform ist der Vertrag immer nichtig' where id = 1002389;
update public.antworten set text = 'Nein, es gibt keinerlei Formvorschriften rund um den Arbeitsvertrag' where id = 1002390;
update public.antworten set text = 'Nur bei Führungskräften mit Prokura oder Handlungsvollmacht' where id = 1002391;
-- Frage 220031: Ab wie vielen Arbeitnehmern kann ein Betriebsrat gegründet werden?
update public.antworten set text = 'Ab 10 wahlberechtigten Arbeitnehmern' where id = 1002397;
update public.antworten set text = 'Ab 20 wahlberechtigten Arbeitnehmern' where id = 1002398;
update public.antworten set text = 'Ab 50 wahlberechtigten Arbeitnehmern' where id = 1002399;
-- Frage 220033: Wie viele Tage Mindesturlaub gibt es bei 5-Tage-Woche?
update public.antworten set text = '24 Arbeitstage pro Jahr' where id = 1002405;
update public.antworten set text = '15 Arbeitstage pro Jahr' where id = 1002406;
update public.antworten set text = '30 Arbeitstage pro Jahr' where id = 1002407;
-- Frage 220034: Was ist der Zweck einer Abmahnung?
update public.antworten set text = 'Die fristlose Kündigung sofort wirksam machen' where id = 1002409;
update public.antworten set text = 'Eine dauerhafte Gehaltskürzung rechtfertigen' where id = 1002410;
update public.antworten set text = 'Eine geplante Beförderung formal vorbereiten' where id = 1002411;
-- Frage 220035: Wie oft kann ein Arbeitsvertrag ohne Sachgrund befristet werden?
update public.antworten set text = 'Unbegrenzt oft bei gleichem Arbeitgeber' where id = 1002413;
update public.antworten set text = 'Nur 1 mal für höchstens 6 Monate' where id = 1002414;
update public.antworten set text = 'Maximal 5 mal innerhalb von 5 Jahren' where id = 1002415;
-- Frage 220037: Was ist eine Vertragsstrafe?
update public.antworten set text = 'Vertraglich vereinbarte Zahlung bei Pflichtverletzung' where id = 1002420;
update public.antworten set text = 'Eine staatliche Strafe, die ein Gericht verhängt' where id = 1002421;
update public.antworten set text = 'Eine Strafe, die nur bei Straftaten verhängt wird' where id = 1002422;
update public.antworten set text = 'Eine Zahlung, die automatisch in jedem Vertrag gilt' where id = 1002423;
-- Frage 220038: Was muss für einen Schadensersatzanspruch vorliegen?
update public.antworten set text = 'Nur ein nachweisbarer Schaden beim Geschädigten' where id = 1002425;
update public.antworten set text = 'Nur ein Verschulden des Vertragspartners' where id = 1002426;
update public.antworten set text = 'Nur ein wirksam geschlossener Vertrag zwischen den Parteien' where id = 1002427;
-- Frage 220039: Was sind Allgemeine Geschäftsbedingungen (AGB)?
update public.antworten set text = 'Individuell zwischen den Parteien ausgehandelte Vertragsklauseln' where id = 1002429;
update public.antworten set text = 'Vertragsregeln, die nur für Großunternehmen gelten' where id = 1002430;
update public.antworten set text = 'Gesetzliche Vorschriften aus dem BGB zum Kaufvertrag' where id = 1002431;
-- Frage 220040: Wer braucht ein Impressum auf seiner Website?
update public.antworten set text = 'Nur Online-Shops mit Warenverkauf' where id = 1002433;
update public.antworten set text = 'Nur Unternehmen ab 250 Mitarbeitern' where id = 1002434;
update public.antworten set text = 'Niemand, ein Impressum ist freiwillig' where id = 1002435;
-- Frage 220045: Ein Sprint läuft seit einer Woche. Der Kunde möchte dringend neue Features einbringen. Was
update public.antworten set text = 'Der Sprint läuft weiter, neue Features kommen ins Backlog' where id = 1002937;
update public.antworten set text = 'Der Sprint wird sofort für die neuen Features unterbrochen' where id = 1002936;
update public.antworten set text = 'Der Scrum Master unterbricht den Sprint für den Kunden' where id = 1002939;
-- Frage 220050: Was beschreibt das Pflichtenheft?
update public.antworten set text = 'Die vom Auftraggeber gewünschten Funktionalitäten der Software' where id = 1002956;
update public.antworten set text = 'Den detaillierten Projektzeitplan mit Meilensteinen' where id = 1002959;
-- Frage 220055: Wozu dient die Vorwärtsrechnung beim Netzplan?
update public.antworten set text = 'Um die geplanten Projektkosten je Vorgang zu berechnen' where id = 1002976;
update public.antworten set text = 'Um Personal und Ressourcen einzuplanen' where id = 1002978;
update public.antworten set text = 'Um Risiken im Projektverlauf zu identifizieren' where id = 1002979;
-- Frage 220056: Wozu dient die Rückwärtsrechnung beim Netzplan?
update public.antworten set text = 'Um die spätesten Anfangszeitpunkte der Vorgänge zu ermitteln' where id = 1002981;
update public.antworten set text = 'Um die Kosten der Vorgänge zu reduzieren' where id = 1002980;
update public.antworten set text = 'Um den frühesten Projektbeginn festzulegen' where id = 1002982;
update public.antworten set text = 'Um die Meilensteine für den Lenkungsausschuss zu definieren' where id = 1002983;
-- Frage 220057: Was gibt der Gesamtpuffer im Netzplan an?
update public.antworten set text = 'Die Gesamtdauer des Projekts vom Start bis zum Ende' where id = 1002984;
update public.antworten set text = 'Die maximale Anzahl parallel laufender Vorgänge im Netzplan' where id = 1002986;
update public.antworten set text = 'Die geplanten Gesamtkosten des Projekts' where id = 1002987;
-- Frage 220058: Was bedeutet der freie Puffer im Netzplan?
update public.antworten set text = 'Mögliche Verzögerung eines Vorgangs, ohne den Nachfolger zu verschieben' where id = 1002989;
update public.antworten set text = 'Die Reserve an Budget für unvorhergesehene Kosten im Projektverlauf' where id = 1002990;
update public.antworten set text = 'Nicht genutzte Arbeitskraft der eingeplanten Projektmitarbeiter' where id = 1002991;
-- Frage 220060: Was zeigt der kritische Pfad im Netzplan?
update public.antworten set text = 'Die günstigsten Vorgänge mit den niedrigsten Gesamtkosten' where id = 1002996;
update public.antworten set text = 'Die parallel laufenden Vorgänge mit freiem Puffer' where id = 1002998;
update public.antworten set text = 'Die optionalen Vorgänge ohne feste Termine' where id = 1002999;
-- Frage 220061: Was ist das Hauptziel einer Stakeholder-Analyse?
update public.antworten set text = 'Projektgegner und gegenläufige Ziele früh zu erkennen' where id = 1003001;
update public.antworten set text = 'Die geplanten Projektkosten dauerhaft zu senken' where id = 1003000;
update public.antworten set text = 'Den Projektzeitplan mit Meilensteinen zu erstellen' where id = 1003002;
update public.antworten set text = 'Die technische Machbarkeit des Projekts zu prüfen' where id = 1003003;
-- Frage 220062: Welche Aussage zur Risikoanalyse ist korrekt?
update public.antworten set text = 'Sie hilft, potenzielle Probleme im Projekt früh zu erkennen' where id = 1003005;
update public.antworten set text = 'Sie wird ausschließlich am Projektende einmalig durchgeführt' where id = 1003004;
update public.antworten set text = 'Sie ersetzt die Stakeholder-Analyse vollständig' where id = 1003006;
update public.antworten set text = 'Sie ist nur bei großen Projekten mit hohem Budget notwendig' where id = 1003007;
-- Frage 220063: Was wird in einer Machbarkeitsanalyse überprüft?
update public.antworten set text = 'Die Verfügbarkeit von Personal im geplanten Projektzeitraum' where id = 1003011;
-- Frage 220065: Was charakterisiert ein Projekt?
update public.antworten set text = 'Es ist ein einmaliges Vorhaben mit klarem Ziel und Endtermin' where id = 1003018;
update public.antworten set text = 'Es ist eine Routineaufgabe des Tagesgeschäfts' where id = 1003016;
update public.antworten set text = 'Es hat kein definiertes Ende und läuft dauerhaft weiter' where id = 1003017;
update public.antworten set text = 'Es hat keine Beschränkung bei Budget und Ressourcen' where id = 1003019;
-- Frage 220066: Was sind Meilensteine im Projektmanagement?
update public.antworten set text = 'Besonders teure Phasen im Projektbudget' where id = 1003020;
update public.antworten set text = 'Die ersten Arbeitsschritte zu Beginn eines Projekts' where id = 1003022;
update public.antworten set text = 'Eine Liste aller bekannten Projektrisiken' where id = 1003023;
-- Frage 220068: Was geschieht in der "Plan"-Phase des PDCA-Zyklus?
update public.antworten set text = 'Die geplanten Maßnahmen werden umgesetzt' where id = 1003028;
update public.antworten set text = 'Die Ergebnisse werden gegen die Ziele geprüft' where id = 1003030;
-- Frage 220071: Was geschieht in der "Act"-Phase des PDCA-Zyklus?
update public.antworten set text = 'Erste Planung mit Zielen und Maßnahmen erstellen' where id = 1003040;
update public.antworten set text = 'Tests durchführen und den Ablauf beobachten' where id = 1003041;
update public.antworten set text = 'Messwerte aufnehmen und Kennzahlen dokumentieren' where id = 1003042;
-- Frage 220072: Welche Reihenfolge ist beim Ablauf des Qualitätsmanagements korrekt?
update public.antworten set text = 'QM-Handbuch → Ist-Analyse → Schulung → Zertifizierung → Interne Audits' where id = 1003044;
update public.antworten set text = 'Zertifizierung → Schulung → Ist-Analyse → QM-Handbuch → Sollkonzept' where id = 1003046;
update public.antworten set text = 'Schulung → Zertifizierung → Sollkonzept → Ist-Analyse → QM-Handbuch → Interne Audits' where id = 1003047;
-- Frage 220073: Was beschreibt die Prozessqualität?
update public.antworten set text = 'Die Qualität des fertigen, ausgelieferten Endproduktes' where id = 1003048;
update public.antworten set text = 'Die Qualität der begleitenden Dokumentation' where id = 1003050;
-- Frage 220075: Was gehört zur Funktionalität als Qualitätsmerkmal von Software?
update public.antworten set text = 'Zeitverhalten, Ressourcenverbrauch und Effizienz' where id = 1003058;
-- Frage 220076: Was gehört zur Wartbarkeit von Software?
update public.antworten set text = 'Reife, Fehlertoleranz und Wiederherstellbarkeit' where id = 1003060;
update public.antworten set text = 'Zeitverhalten, Verbrauchsverhalten und Effizienz' where id = 1003062;
-- Frage 220077: Was beschreibt die Portabilität von Software?
update public.antworten set text = 'Übertragbarkeit auf verschiedene Plattformen' where id = 1003066;
update public.antworten set text = 'Wie schnell die Software auf Eingaben reagiert' where id = 1003064;
update public.antworten set text = 'Wie gut die Software Daten vor Zugriff schützt' where id = 1003065;
update public.antworten set text = 'Wie leicht sich Fehler in der Software beheben lassen' where id = 1003067;
-- Frage 220079: Was gehört zur Benutzbarkeit von Software?
update public.antworten set text = 'Zeitverhalten, Verbrauchsverhalten und Effizienz' where id = 1003075;
-- Frage 220082: Was wird beim Systemtest geprüft?
update public.antworten set text = 'Einzelne Module isoliert mit Testtreibern' where id = 1003084;
update public.antworten set text = 'Die Interaktion zweier Komponenten an ihren Schnittstellen' where id = 1003085;
update public.antworten set text = 'Nur die grafische Benutzeroberfläche' where id = 1003087;
-- Frage 220084: Was ist der Hauptunterschied zwischen White-Box- und Black-Box-Tests?
update public.antworten set text = 'Black-Box-Tests laufen schneller als White-Box-Tests' where id = 1003093;
update public.antworten set text = 'Black-Box testet den Quellcode Zeile für Zeile' where id = 1003095;
-- Frage 220086: Was macht ein Compiler?
update public.antworten set text = 'Führt Quellcode zeilenweise direkt aus' where id = 1003100;
update public.antworten set text = 'Testet den Code mit Unit-Tests automatisch' where id = 1003102;
update public.antworten set text = 'Erzeugt automatisch Dokumentation aus dem Code' where id = 1003103;
-- Frage 220087: Wofür steht die DIN EN ISO 9001?
update public.antworten set text = 'IT-Sicherheitsstandard für Rechenzentren' where id = 1003104;
update public.antworten set text = 'Datenschutzrichtlinie der EU' where id = 1003106;
update public.antworten set text = 'Programmierstandard für sicheren Code' where id = 1003107;
-- Frage 220088: Wofür steht BITV 2.0?
update public.antworten set text = 'Bundesamt für Informationstechnik-Verwaltung' where id = 1003108;
update public.antworten set text = 'Bundesweite Informationstechnik-Versorgung' where id = 1003111;
-- Frage 220091: Wie wird Qualität definiert?
update public.antworten set text = 'Der Preis eines Produkts im Vergleich zur Konkurrenz' where id = 1003120;
update public.antworten set text = 'Die Anzahl der Features, die ein Produkt seinen Nutzern insgesamt bietet' where id = 1003122;
update public.antworten set text = 'Das hochwertige Aussehen und die Verpackung eines Produkts' where id = 1003123;
-- Frage 220092: Was kennzeichnet ein Monopol?
update public.antworten set text = 'Viele Anbieter stehen vielen Nachfragern gegenüber' where id = 1003124;
update public.antworten set text = 'Wenige große Anbieter stehen vielen Nachfragern gegenüber' where id = 1003125;
update public.antworten set text = 'Viele Anbieter stehen einem einzigen Nachfrager gegenüber' where id = 1003127;
-- Frage 220097: Was sind A-Kunden in der ABC-Analyse?
update public.antworten set text = 'Kunden mit Potential für künftige Umsätze' where id = 1003144;
update public.antworten set text = 'Kunden ohne nennenswertes Entwicklungspotential' where id = 1003145;
update public.antworten set text = 'Neu gewonnene Kunden im ersten Jahr' where id = 1003147;
-- Frage 220099: Was ist ein Merkmal des Einliniensystems?
update public.antworten set text = 'Jede Stelle hat mehrere gleichberechtigte Vorgesetzte' where id = 1003152;
update public.antworten set text = 'Es gibt Stabstellen zur Entlastung der Leitung' where id = 1003154;
update public.antworten set text = 'Mehrdimensionale Matrixorganisation mit Projekt- und Linienachsen' where id = 1003155;
-- Frage 220100: Was ist ein typischer Nachteil des Einliniensystems?
update public.antworten set text = 'Kompetenzüberschneidungen zwischen den Vorgesetzten' where id = 1003156;
update public.antworten set text = 'Zu viele Vorgesetzte für jede einzelne Stelle' where id = 1003157;
update public.antworten set text = 'Fehlende klare Strukturen in der Berichtslinie' where id = 1003159;
-- Frage 220101: Welche Funktion haben Stabstellen im Stabliniensystem?
update public.antworten set text = 'Sie beraten und informieren ohne Anordnungsbefugnis' where id = 1003161;
update public.antworten set text = 'Sie führen das operative Tagesgeschäft der Abteilungen' where id = 1003162;
update public.antworten set text = 'Sie kontrollieren und überwachen alle Linieninstanzen' where id = 1003163;
-- Frage 220102: Was kennzeichnet das Mehrliniensystem?
update public.antworten set text = 'Eine Stelle erhält Anweisungen von mehreren Vorgesetzten' where id = 1003165;
update public.antworten set text = 'Jede Stelle hat genau einen weisungsbefugten Vorgesetzten' where id = 1003164;
update public.antworten set text = 'Stabstellen beraten die Leitung ohne Weisungsrecht' where id = 1003166;
update public.antworten set text = 'Keine Stelle besitzt eine formale Weisungsbefugnis' where id = 1003167;
-- Frage 220103: Was ist ein Hauptnachteil des Mehrliniensystems?
update public.antworten set text = 'Kompetenzkonflikte durch mehrere Vorgesetzte' where id = 1003170;
update public.antworten set text = 'Lange Dienstwege über viele Hierarchieebenen' where id = 1003169;
update public.antworten set text = 'Keine Spezialisierung der einzelnen Führungskräfte möglich' where id = 1003171;
-- Frage 220106: Was ist ein Vorteil von Leasing?
update public.antworten set text = 'Sofortiger Eigentumserwerb mit Vertragsunterzeichnung' where id = 1003180;
update public.antworten set text = 'In jedem Fall günstiger als der Kauf auf Kredit' where id = 1003182;
update public.antworten set text = 'Es fallen keinerlei monatliche Kosten für die Nutzung an' where id = 1003183;
-- Frage 220110: Was unterscheidet Prokura von einer einfachen Vollmacht?
update public.antworten set text = 'Prokura reicht weiter und wird ins Handelsregister eingetragen' where id = 1003197;
update public.antworten set text = 'Prokura ist weniger umfangreich als eine Handlungsvollmacht' where id = 1003196;
update public.antworten set text = 'Es gibt rechtlich keinen Unterschied zwischen beiden' where id = 1003198;
update public.antworten set text = 'Eine einfache Vollmacht ist immer umfangreicher als Prokura' where id = 1003199;
-- Frage 220111: Was sollte ein Service-Level-Agreement (SLA) enthalten?
update public.antworten set text = 'Ausschließlich den Preis der vereinbarten Leistung' where id = 1003200;
update public.antworten set text = 'Nur die Laufzeit des Vertrags und die Kündigungsfrist' where id = 1003202;
update public.antworten set text = 'Ausschließlich die Kontaktdaten der beiden Vertragspartner' where id = 1003203;
-- Frage 220113: Was kennzeichnet den kooperativen Führungsstil?
update public.antworten set text = 'Die Führungskraft entscheidet allein ohne Rücksprache' where id = 1003208;
update public.antworten set text = 'Es gibt keine festen Strukturen oder Regeln' where id = 1003210;
update public.antworten set text = 'Mitarbeiter tragen keine eigene Verantwortung für Ergebnisse' where id = 1003211;
-- Frage 220115: Was ist ein Kernprozess im Unternehmen?
update public.antworten set text = 'Beschaffung und Herstellung von Produkten' where id = 1003218;
update public.antworten set text = 'Die Buchhaltung mit Kreditoren und Debitoren' where id = 1003216;
update public.antworten set text = 'Das Personalwesen mit der Lohnabrechnung' where id = 1003217;
-- Frage 220116: Was sind wesentliche Bestandteile eines Vertrags?
update public.antworten set text = 'Zwei übereinstimmende Willenserklärungen' where id = 1003221;
update public.antworten set text = 'Nur die Unterschrift beider Parteien' where id = 1003220;
update public.antworten set text = 'Nur der Preis der vereinbarten Leistung' where id = 1003222;
update public.antworten set text = 'Nur die Leistungsbeschreibung im Anhang' where id = 1003223;
-- Frage 2202: Was ist der Hauptvorteil eines VPN?
update public.antworten set text = 'Verschlüsselter Zugriff auf private Netze über das Internet' where id = 1003472;
update public.antworten set text = 'Schnellere Internetverbindung durch zwischengeschaltete Proxy-Server' where id = 1003473;
update public.antworten set text = 'Zuverlässiger Schutz vor Viren und Malware auf dem Endgerät' where id = 1003474;
update public.antworten set text = 'Anonymisierung der MAC-Adresse gegenüber Webservern' where id = 1003475;
-- Frage 2203: Was ist die Hauptaufgabe einer Firewall?
update public.antworten set text = 'Verschlüsselung aller ein- und ausgehenden Datenpakete im Netzwerk' where id = 1003477;
update public.antworten set text = 'Erkennung und Entfernung von Viren auf den Endgeräten' where id = 1003478;
-- Frage 2206: Was sind typische Faktoren bei der Zwei-Faktor-Authentifizierung?
update public.antworten set text = 'Zwei verschiedene Passwörter nacheinander' where id = 1003489;
update public.antworten set text = 'Benutzername und hinterlegte E-Mail-Adresse' where id = 1003490;
update public.antworten set text = 'PIN (Geheimzahl) und persönliche Sicherheitsfrage' where id = 1003491;
-- Frage 23: Was ist Working Capital?
update public.antworten set text = 'Das gesamte Eigenkapital laut Bilanz zum Jahresende' where id = 1002313;
update public.antworten set text = 'Die Investitionen in das Anlagevermögen' where id = 1002314;
update public.antworten set text = 'Der Jahresgewinn nach Abzug aller Steuern' where id = 1002315;
-- Frage 24: Was ist ein Vorteil von Leasing gegenüber Kauf?
update public.antworten set text = 'Schonung der Liquidität durch monatliche Raten' where id = 1002316;
update public.antworten set text = 'Man wird mit der ersten Rate sofort Eigentümer' where id = 1002317;
update public.antworten set text = 'Es ist über die Laufzeit immer günstiger als Kauf' where id = 1002318;
update public.antworten set text = 'Es besteht keine feste Vertragsbindung' where id = 1002319;
-- Frage 25: Was sind Stakeholder?
update public.antworten set text = 'Alle Gruppen mit einem Interesse am Unternehmen' where id = 1002320;
update public.antworten set text = 'Nur die Aktionäre mit Stimmrecht auf der Hauptversammlung' where id = 1002321;
update public.antworten set text = 'Nur die Mitarbeiter in Führungspositionen' where id = 1002322;
update public.antworten set text = 'Nur die Kunden, die regelmäßig bestellen' where id = 1002323;
-- Frage 27: Was bedeutet Outsourcing?
update public.antworten set text = 'Auslagerung von Aufgaben an externe Dienstleister' where id = 1002328;
update public.antworten set text = 'Einstellung neuer Mitarbeiter für interne Aufgaben' where id = 1002329;
update public.antworten set text = 'Verkauf eigener Produkte über externe Händler' where id = 1002330;
update public.antworten set text = 'Expansion des Unternehmens in ausländische Märkte' where id = 1002331;
-- Frage 28: Was ist Benchmarking?
update public.antworten set text = 'Vergleich eigener Kennzahlen mit den Besten der Branche' where id = 1002332;
update public.antworten set text = 'Die Festlegung der Jahresbudgets für alle Abteilungen' where id = 1002333;
update public.antworten set text = 'Die jährliche Beurteilung einzelner Mitarbeiter' where id = 1002334;
update public.antworten set text = 'Die Entwicklung neuer Produkte im eigenen Haus' where id = 1002335;
-- Frage 30: Was ist Supply Chain Management?
update public.antworten set text = 'Steuerung der gesamten Lieferkette' where id = 1002340;
update public.antworten set text = 'Nur die Verwaltung der eigenen Lagerbestände' where id = 1002341;
update public.antworten set text = 'Nur die Auswahl und Bewertung von Lieferanten' where id = 1002343;
-- Frage 31: Was bedeutet Just-in-Time (JIT) Produktion?
update public.antworten set text = 'Material kommt genau dann, wenn es benötigt wird' where id = 1002344;
update public.antworten set text = 'Sofortige Lieferung aller Bestellungen an Kunden' where id = 1002345;
update public.antworten set text = 'Große Lagerbestände als Sicherheitspuffer' where id = 1002346;
update public.antworten set text = 'Produktion auf Vorrat für saisonale Nachfrage' where id = 1002347;
-- Frage 32: Was beschreibt die Kapitalstruktur eines Unternehmens?
update public.antworten set text = 'Die Aufteilung der Kosten auf die Kostenstellen' where id = 1002349;
update public.antworten set text = 'Die Mitarbeiterstruktur nach Abteilungen und Alter' where id = 1002350;
update public.antworten set text = 'Die Produktpalette des Unternehmens am Markt' where id = 1002351;
-- Frage 6: Was ist ein Kaufvertrag?
update public.antworten set text = 'Ein Mietvertrag über Gebrauchsüberlassung' where id = 22;
update public.antworten set text = 'Eine Schenkung ohne Gegenleistung' where id = 23;
update public.antworten set text = 'Ein Darlehen mit Zinszahlung' where id = 24;

commit;
