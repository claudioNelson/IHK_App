import '../../models/ihk_exam_model.dart';

final si2Exam = IHKExam(
  id: 'si-2',
  title: 'SI Übungsprüfung 2',
  year: 2016,
  season: 'Winter',
  duration: 90,
  totalPoints: 100,
  company: 'DataCenter Solutions AG',
  scenario:
      '''Sie sind Mitarbeiter/-in in der IT-Abteilung der DataCenter Solutions AG, einem mittelständischen Rechenzentrumsdienstleister.

Im Rahmen der Weiterentwicklung der IT-Infrastruktur sind Sie an verschiedenen Maßnahmen beteiligt.

Sie sollen die folgenden vier Handlungsschritte bearbeiten:
1. Einrichtung eines E-Mail-Servers und des DHCP-Dienstes
2. Einrichtung und Dokumentation einer Firewall
3. Rechtevergabe an Benutzer
4. Einführung von IPv6''',
  sections: [
    ExamSection(
      id: 'hs2',
      title: 'Handlungsschritt 1: E-Mail & DHCP (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs2-a',
          title: 'Aufgabe a) E-Mail-Protokolle (8 Punkte)',
          description: '''Erklären Sie die Unterschiede zwischen:

a) SMTP
b) POP3
c) IMAP

Welche Ports werden standardmäßig verwendet?''',
          type: QuestionType.freeText,
          points: 8,
          hint: 'SMTP:25, POP3:110, IMAP:143',
        ),
        ExamQuestion(
          id: 'hs2-b',
          title: 'Aufgabe b) SPF, DKIM, DMARC (9 Punkte)',
          description:
              '''Zur Spam-Abwehr sollen SPF, DKIM und DMARC konfiguriert werden.

a) Erklären Sie jeden Mechanismus kurz
b) Welche DNS-Records werden benötigt?
c) Wie arbeiten sie zusammen?''',
          type: QuestionType.freeText,
          points: 9,
          hint: 'SPF: Sender Policy Framework, DKIM: DomainKeys, DMARC: Policy',
        ),
        ExamQuestion(
          id: 'hs2-c',
          title: 'Aufgabe c) DHCP-Konfiguration (8 Punkte)',
          description: '''Konfigurieren Sie DHCP für folgendes Netzwerk:

Netzwerk: 192.168.10.0/24
Gateway: 192.168.10.1
DNS: 8.8.8.8, 8.8.4.4
IP-Pool: 192.168.10.100 - 192.168.10.200
Lease-Zeit: 24 Stunden

a) Erstellen Sie die DHCP-Konfiguration (dhcpd.conf Format)
b) Welche Informationen erhält ein Client?
c) Was passiert nach Ablauf der Lease-Zeit?''',
          type: QuestionType.code,
          points: 8,
          hint: 'subnet, range, option routers, option domain-name-servers',
        ),
      ],
    ),
    ExamSection(
      id: 'hs3',
      title: 'Handlungsschritt 2: Firewall (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs3-a',
          title: 'Aufgabe a) Firewall-Zonen (10 Punkte)',
          description: '''Eine Firewall soll drei Zonen haben:

INTERNAL: 10.0.1.0/24 (Büro-Netzwerk)
DMZ: 10.0.2.0/24 (Webserver, Mailserver)
EXTERNAL: Internet

a) Zeichnen Sie ein Netzwerkdiagramm mit den Zonen
b) Welche Verbindungen sollten erlaubt sein?
c) Welche Verbindungen müssen blockiert werden?
d) Warum ist eine DMZ sinnvoll?''',
          type: QuestionType.diagram,
          points: 10,
          hint: 'DMZ isoliert öffentliche Server vom internen Netz',
        ),
        ExamQuestion(
          id: 'hs3-b',
          title: 'Aufgabe b) iptables-Regeln (10 Punkte)',
          description: '''Schreiben Sie iptables-Regeln für:

1. Erlaube SSH (Port 22) aus INTERNAL zur DMZ
2. Erlaube HTTP/HTTPS aus EXTERNAL zur DMZ
3. Blockiere ALLE anderen Verbindungen aus EXTERNAL
4. Erlaube DNS-Abfragen (Port 53) von INTERNAL nach EXTERNAL
5. Erlaube etablierte Verbindungen zurück

Nutzen Sie die INPUT, OUTPUT und FORWARD Chains.''',
          type: QuestionType.code,
          points: 10,
          hint:
              'iptables -A FORWARD -s <src> -d <dst> -p <proto> --dport <port> -j ACCEPT',
        ),
        ExamQuestion(
          id: 'hs3-c',
          title: 'Aufgabe c) Stateful vs. Stateless (5 Punkte)',
          description:
              '''a) Erklären Sie den Unterschied zwischen Stateful und Stateless Firewalls
b) Welche Vorteile hat eine Stateful Firewall?
c) Geben Sie ein Beispiel''',
          type: QuestionType.freeText,
          points: 5,
          hint:
              'Stateful merkt sich Verbindungen, Stateless prüft jedes Paket einzeln',
        ),
      ],
    ),
    ExamSection(
      id: 'hs4',
      title: 'Handlungsschritt 3: Rechtevergabe (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs4-a',
          title: 'Aufgabe a) Linux-Dateiberechtigungen (10 Punkte)',
          description: '''Erklären Sie das Linux-Rechtesystem:

Beispiel: -rwxr-x---

a) Was bedeuten die einzelnen Zeichen?
b) Wer hat welche Rechte?
c) Wie würden Sie diese Rechte mit chmod setzen (oktal)?
d) Was ist der Unterschied zwischen chmod 755 und 775?''',
          type: QuestionType.freeText,
          points: 10,
          hint: 'rwx = 7, r-x = 5, --- = 0',
        ),
        ExamQuestion(
          id: 'hs4-b',
          title: 'Aufgabe b) NTFS-ACLs (10 Punkte)',
          description: '''Ein Windows-Fileserver soll folgende Struktur haben:

/Shares
  /IT (Zugriff nur IT-Abteilung)
  /HR (Zugriff nur HR-Abteilung)
  /Public (Alle lesen, nur Admins schreiben)

a) Wie richten Sie die ACLs ein?
b) Was ist Vererbung?
c) Was passiert bei Vererbungs-Konflikten?
d) Wie deaktivieren Sie Vererbung für einen Ordner?''',
          type: QuestionType.freeText,
          points: 10,
          hint: 'Explizite Berechtigungen überschreiben geerbte',
        ),
        ExamQuestion(
          id: 'hs4-c',
          title: 'Aufgabe c) Prinzip der minimalen Rechte (5 Punkte)',
          description: '''a) Erklären Sie das "Principle of Least Privilege"
b) Warum ist es wichtig?
c) Geben Sie zwei praktische Beispiele''',
          type: QuestionType.freeText,
          points: 5,
          hint: 'Nutzer bekommen nur die Rechte, die sie wirklich brauchen',
        ),
      ],
    ),
    ExamSection(
      id: 'hs5',
      title: 'Handlungsschritt 4: IPv6 (25 Punkte)',
      totalPoints: 25,
      questions: [
        ExamQuestion(
          id: 'hs5-a',
          title: 'Aufgabe a) IPv6-Adressierung (8 Punkte)',
          description: '''a) Wie viele Bits hat eine IPv6-Adresse?
b) Schreiben Sie folgende IPv6-Adresse in Kurzform:
   2001:0db8:0000:0000:0000:ff00:0042:8329
c) Was ist die Loopback-Adresse in IPv6?
d) Was ist die Link-Local-Adresse?''',
          type: QuestionType.freeText,
          points: 8,
          hint: '128 Bit, Kurzform: führende Nullen weg, :: für Nullblöcke',
        ),
        ExamQuestion(
          id: 'hs5-b',
          title: 'Aufgabe b) IPv6-Subnetze (9 Punkte)',
          description: '''Gegeben: 2001:db8:abcd::/48

Teilen Sie dieses Netz in 16 Subnetze auf.

a) Welche Prefix-Länge haben die Subnetze?
b) Geben Sie die ersten drei Subnetz-Adressen an
c) Wie viele Hosts passen in ein /64-Netz?''',
          type: QuestionType.freeText,
          points: 9,
          hint: '/48 + 4 Bit = /52, dann /64 für Hosts',
        ),
        ExamQuestion(
          id: 'hs5-c',
          title: 'Aufgabe c) Dual Stack vs. Tunneling (8 Punkte)',
          description:
              '''Für die IPv6-Migration stehen mehrere Strategien zur Verfügung:

a) Erklären Sie Dual Stack
b) Erklären Sie IPv6-Tunneling (z.B. 6to4)
c) Vor- und Nachteile beider Ansätze
d) Welchen Ansatz empfehlen Sie?''',
          type: QuestionType.freeText,
          points: 8,
          hint:
              'Dual Stack: beide Protokolle parallel, Tunneling: IPv6 über IPv4',
        ),
      ],
    ),
  ],
);
