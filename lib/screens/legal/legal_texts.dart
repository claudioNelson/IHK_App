// Eingebettete Rechtstexte für die App (offline verfügbar, DDG-konform).
// Inhaltlich identisch mit der Website (lernarena.app).
// Bei Änderungen: Website UND diese Datei aktualisieren und das "Stand"-Datum anpassen.

const String kImpressumMarkdown = r'''
# Impressum

Angaben gemäß § 5 DDG (Digitale-Dienste-Gesetz)

## Anbieter

Claudio Medeiros Magalhaes
Westfalenweg 3
49504 Lotte
Deutschland

## Kontakt

E-Mail: info@lernarena.app

## Angaben zur Tätigkeit

Tätigkeitsbereich: Softwareentwicklung und digitale Bildungsangebote
Unternehmensform: Einzelunternehmen

## Haftungsausschluss

### Haftung für Inhalte

Als Diensteanbieter sind wir gemäß § 7 Abs. 1 DDG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 DDG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen.

### Keine offizielle IHK-Zugehörigkeit

Lernarena ist ein unabhängiges, privates Lernangebot und steht in keiner offiziellen Verbindung zur IHK (Industrie- und Handelskammer) oder anderen Prüfungsbehörden. Alle Prüfungsfragen und Lerninhalte dienen ausschließlich der Prüfungsvorbereitung und erheben keinen Anspruch auf Vollständigkeit oder offizielle Gültigkeit.

### Haftung für Links

Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich.

## Urheberrecht

Die durch den Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.
''';

const String kDatenschutzMarkdown = r'''
# Datenschutzerklärung

Gemäß Art. 13, 14 DSGVO – Stand: 28. Juni 2026

## 1. Verantwortlicher

Verantwortlicher im Sinne der DSGVO ist:

Claudio Medeiros Magalhaes
Westfalenweg 3
49504 Lotte
Deutschland

E-Mail: info@lernarena.app

## 2. Grundsätze der Datenverarbeitung

Wir verarbeiten personenbezogene Daten nur, soweit dies zur Bereitstellung einer funktionsfähigen App sowie unserer Inhalte und Leistungen erforderlich ist. Die Verarbeitung erfolgt nur nach Einwilligung der Nutzer, soweit keine andere Rechtsgrundlage besteht (Art. 6 DSGVO). Wir geben deine Daten nicht ohne deine ausdrückliche Einwilligung an Dritte weiter, außer dies ist zur Vertragserfüllung notwendig.

## 3. Welche Daten wir erheben

### Bei der Registrierung

E-Mail-Adresse und Passwort (verschlüsselt gespeichert). Diese Daten sind zur Vertragserfüllung erforderlich (Art. 6 Abs. 1 lit. b DSGVO).

### Bei der Nutzung der App

- Lernfortschritte und Testergebnisse
- Erstellte Lernkarten (Flashcards)
- Elo-Bewertung aus Multiplayer-Matches
- Abzeichen und freigeschaltete Inhalte

Diese Daten werden gespeichert, um dir den Lerndienst bereitzustellen (Art. 6 Abs. 1 lit. b DSGVO).

### Bei der Nutzung der KI-Funktion (Ada)

Deine Fragen an den KI-Tutor werden zur Verarbeitung an die Groq-API weitergeleitet. Der Inhalt deiner Anfrage kann personenbezogene Daten enthalten, sofern du solche eingibst. Wir haben bei Groq die Zero-Data-Retention-Einstellung aktiviert, sodass Inhalte nicht gespeichert werden. Weitere Details siehe Abschnitt 6.

## 4. Cookies und lokale Speicherung

Die Web-App verwendet technisch notwendige Cookies und lokalen Browser-Speicher (LocalStorage) ausschließlich für:

- Aufrechterhaltung der Anmeldesitzung
- Speicherung von Nutzereinstellungen

Es werden keine Tracking- oder Werbe-Cookies eingesetzt. Eine Einwilligung ist für technisch notwendige Cookies nicht erforderlich (§ 25 Abs. 2 TDDDG).

## 5. Supabase (Datenbank & Authentifizierung)

Wir nutzen Supabase als Backend-Dienst für Datenspeicherung und Nutzerauthentifizierung. Anbieter ist die Supabase Inc., 970 Toa Payoh North, #07-04, Singapur 318992.

Die Daten werden auf Servern in der EU (Frankfurt, AWS eu-central-1) gespeichert. Supabase ist nach dem EU-US Data Privacy Framework zertifiziert. Rechtsgrundlage ist Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung) sowie Art. 28 DSGVO (Auftragsverarbeitung).

Datenschutzerklärung von Supabase: [supabase.com/privacy](https://supabase.com/privacy)

## 6. Groq API (KI-Tutor Ada)

Für die KI-Tutorfunktion „Ada" verwenden wir die Groq API. Anbieter ist Groq, Inc., 101 University Ave, Suite 334, Palo Alto, CA 94301, USA.

Wenn du eine Frage an Ada stellst, wird der Inhalt deiner Anfrage zur Verarbeitung an Groq übertragen. Der Anfrageinhalt kann personenbezogene Daten enthalten, sofern du diese eingibst; darüber hinaus übermitteln wir keine Stammdaten wie Name oder E-Mail-Adresse. Groq speichert Inputs und Outputs standardmäßig bis zu 30 Tage zur Sicherstellung des Betriebs und zur Missbrauchskontrolle; wir haben die Zero-Data-Retention-Einstellung aktiviert, sodass keine Speicherung erfolgt. Groq nutzt die Daten nicht zum Training eigener Modelle.

Die Verarbeitung erfolgt im Auftrag auf Grundlage eines Auftragsverarbeitungsvertrags (Data Processing Addendum, Art. 28 DSGVO). Die Übertragung in die USA erfolgt auf Grundlage der Standardvertragsklauseln (Art. 46 DSGVO). Rechtsgrundlage für die Nutzung ist Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung).

Datenschutzerklärung von Groq: [groq.com/privacy-policy](https://groq.com/privacy-policy/)

## 7. Vercel (Web-Hosting)

Die Web-App wird über Vercel gehostet. Anbieter ist Vercel Inc., 340 S Lemon Ave #4133, Walnut, CA 91789, USA.

Beim Aufruf der Website werden automatisch technische Daten (z. B. IP-Adresse, Browsertyp, Uhrzeit) in Server-Logs gespeichert. Diese Daten werden von Vercel zur Sicherstellung des Betriebs verwendet und nicht mit anderen Daten zusammengeführt. Rechtsgrundlage ist Art. 6 Abs. 1 lit. f DSGVO (berechtigtes Interesse an einem sicheren Betrieb).

Datenschutzerklärung von Vercel: [vercel.com/legal/privacy-policy](https://vercel.com/legal/privacy-policy)

## 8. Stripe (Zahlungsabwicklung)

Für die Zahlungsabwicklung von Premium-Abonnements über die Web-App nutzen wir den Zahlungsdienstleister Stripe. Anbieter ist die Stripe Payments Europe, Ltd., The One Building, 1 Grand Canal Street Lower, Dublin 2, Irland.

Wenn du ein Abonnement abschließt oder verwaltest, werden die im Bezahlvorgang eingegebenen Daten (z. B. Name, E-Mail-Adresse, Zahlungs- und Rechnungsdaten sowie technische Daten wie IP-Adresse) direkt von Stripe verarbeitet. Die vollständigen Kartendaten werden ausschließlich von Stripe verarbeitet und nicht an uns übertragen; wir erhalten lediglich eine Kundenkennung sowie Status- und Abrechnungsinformationen zur Verwaltung deines Abonnements.

Rechtsgrundlage ist Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung). Die Verarbeitung erfolgt auf Grundlage eines Auftragsverarbeitungsvertrags (Art. 28 DSGVO); soweit Daten in Drittländer übermittelt werden, erfolgt dies auf Grundlage der EU-Standardvertragsklauseln (Art. 46 DSGVO).

Datenschutzerklärung von Stripe: [stripe.com/de/privacy](https://stripe.com/de/privacy)

## 9. Deine Rechte

Du hast gemäß DSGVO folgende Rechte:

- **Auskunft** (Art. 15 DSGVO): Welche Daten wir über dich gespeichert haben
- **Berichtigung** (Art. 16 DSGVO): Korrektur falscher Daten
- **Löschung** (Art. 17 DSGVO): „Recht auf Vergessenwerden"
- **Einschränkung** (Art. 18 DSGVO): Eingeschränkte Verarbeitung deiner Daten
- **Datenübertragbarkeit** (Art. 20 DSGVO): Deine Daten in maschinenlesbarem Format
- **Widerspruch** (Art. 21 DSGVO): Gegen bestimmte Verarbeitungen

Zur Ausübung deiner Rechte wende dich per E-Mail an: info@lernarena.app

Du hast außerdem das Recht, dich bei einer Datenschutzbehörde zu beschweren. In Deutschland ist dies der Bundesbeauftragte für den Datenschutz und die Informationsfreiheit (BfDI) oder die zuständige Landesbehörde.

## 10. Datenlöschung und Account-Löschung

Du kannst deinen Account und alle damit verbundenen Daten jederzeit löschen lassen, indem du uns per E-Mail kontaktierst. Daten werden gelöscht, sobald sie für den Zweck der Verarbeitung nicht mehr erforderlich sind und keine gesetzlichen Aufbewahrungspflichten entgegenstehen (z. B. steuerliche Aufbewahrungspflichten von 10 Jahren für Rechnungsdaten).

## 11. Änderungen dieser Datenschutzerklärung

Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf anzupassen, um sie an geänderte rechtliche Anforderungen oder Änderungen unserer Dienste anzupassen. Die jeweils aktuelle Version ist stets in der App und auf unserer Website abrufbar. Stand: 28. Juni 2026.
''';

const String kAgbMarkdown = r'''
# Allgemeine Geschäftsbedingungen

Zuletzt aktualisiert: 28. Juni 2026

## 1. Geltungsbereich

Diese Allgemeinen Geschäftsbedingungen (AGB) gelten für alle Verträge zwischen

Claudio Medeiros Magalhaes
Westfalenweg 3, 49504 Lotte
E-Mail: info@lernarena.app

(nachfolgend „Anbieter")

und den Nutzern der mobilen App sowie der Web-App „Lernarena" (nachfolgend „Nutzer"). Abweichende Bedingungen des Nutzers werden nicht anerkannt, es sei denn, der Anbieter stimmt diesen ausdrücklich schriftlich zu.

## 2. Leistungsbeschreibung

Lernarena ist eine digitale Lernplattform, die IT-Auszubildende (insbesondere Fachinformatiker) bei der Vorbereitung auf die IHK-Prüfung unterstützt. Die Plattform bietet:

- Modulbasiertes Lernen mit Prüfungsfragen
- Lernkarten (Flashcards) und Wiederholungssystem
- Asynchrone Multiplayer-Quiz-Matches (AsyncMatch)
- KI-gestützter Tutor „Ada"
- Prüfungssimulation (Premium)
- Zertifizierungsvorbereitung (AWS, Azure, GCP, SAP)

Lernarena steht in keiner offiziellen Verbindung zur IHK oder anderen Prüfungsbehörden. Die Inhalte dienen ausschließlich der Prüfungsvorbereitung und erheben keinen Anspruch auf Vollständigkeit oder Aktualität im Sinne offizieller Prüfungsunterlagen.

## 3. Registrierung und Nutzerkonto

Die Nutzung von Lernarena erfordert die Erstellung eines Nutzerkontos mit einer gültigen E-Mail-Adresse. Der Nutzer ist verpflichtet, wahrheitsgemäße Angaben zu machen und seine Zugangsdaten geheim zu halten.

Die Registrierung ist ab einem Alter von 16 Jahren gestattet. Jüngere Nutzer benötigen die Einwilligung eines Erziehungsberechtigten.

Ein Anspruch auf Registrierung besteht nicht. Der Anbieter behält sich vor, Accounts bei Verstößen gegen diese AGB zu sperren oder zu löschen.

## 4. Free-Tarif und Premium

### 4.1 Free-Tarif

Der Free-Tarif ist kostenlos und beinhaltet einen eingeschränkten Zugang zu den Lernfunktionen. Der Anbieter behält sich vor, den Umfang des kostenlosen Angebots jederzeit anzupassen.

### 4.2 Premium

Premium bietet unbegrenzten Zugang zu allen Funktionen und ist in folgenden Varianten erhältlich:

- Monatlich: 9,99 € / Monat
- Halbjährlich: 39,99 € / 6 Monate (entspricht ca. 6,67 € / Monat)
- Jährlich: 69,99 € / Jahr (entspricht ca. 5,83 € / Monat)

Alle Preise sind Endpreise. Die Umsatzsteuer-Behandlung hängt vom Kaufweg ab:

- **Kauf über die Web-App (Zahlung via Stripe):** Der Anbieter ist Kleinunternehmer im Sinne von § 19 UStG; es wird keine Umsatzsteuer ausgewiesen.
- **Kauf über Google Play:** Die Zahlung wird über Google Play abgewickelt. Eine etwaig anfallende Umsatzsteuer wird von Google im Rahmen seines Bezahlsystems behandelt; es gelten die im Google Play Store angezeigten Endpreise.

### 4.3 Laufzeit und Verlängerung

Alle Abonnements (monatlich, halbjährlich, jährlich) verlängern sich automatisch um die jeweilige Laufzeit, wenn sie nicht rechtzeitig vor Ablauf gekündigt werden (siehe Abschnitt 6).

## 5. Zahlung

Der Kaufweg richtet sich nach der genutzten Plattform:

- In der **Android-App** erfolgt die Abrechnung über Google Play Billing.
- In der **Web-App** erfolgt die Abrechnung über den Zahlungsdienstleister Stripe (Stripe Payments Europe, Ltd., Dublin, Irland). Es gelten ergänzend die Hinweise in der Datenschutzerklärung.

Es gelten jeweils die Zahlungsbedingungen des genutzten Anbieters. Die Zahlung ist im Voraus fällig. Bei fehlgeschlagener Zahlung behält sich der Anbieter vor, den Zugang zu Premium-Funktionen zu unterbrechen.

## 6. Kündigung und Widerrufsrecht

### 6.1 Kündigung

Alle Abonnements können jederzeit zum Ende des laufenden Abrechnungszeitraums gekündigt werden. Der Kündigungsweg richtet sich nach dem Kaufkanal:

- Über Google Play gekaufte Abonnements werden über die Abo-Einstellungen des Google-Play-Kontos gekündigt.
- Über die Web-App (Stripe) gekaufte Abonnements können jederzeit selbst über die Abo-Verwaltung im eigenen Konto („Abo verwalten") gekündigt werden. Die Kündigung wird zum Ende des laufenden Abrechnungszeitraums wirksam.

### 6.2 Widerrufsrecht für Verbraucher

Verbraucher haben das Recht, einen Vertrag innerhalb von 14 Tagen ohne Angabe von Gründen zu widerrufen. Die Einzelheiten ergeben sich aus der nachstehenden Widerrufsbelehrung (6.3).

- Bei Kauf über die **Web-App (Stripe)** richtest du den Widerruf direkt an den Anbieter (siehe Widerrufsbelehrung).
- Bei Kauf über **Google Play** erfolgt die Rückabwicklung über den Erstattungsprozess von Google Play; dein gesetzliches Widerrufsrecht gegenüber dem Anbieter bleibt unberührt.

**Hinweis zum vorzeitigen Erlöschen des Widerrufsrechts:** Bei digitalen Inhalten und sofort bereitgestellten digitalen Leistungen erlischt das Widerrufsrecht, wenn der Nutzer ausdrücklich zugestimmt hat, dass mit der Ausführung des Vertrags vor Ablauf der Widerrufsfrist begonnen wird, und bestätigt hat, dass er mit Beginn der Ausführung sein Widerrufsrecht verliert (§ 356 Abs. 5 BGB).

### 6.3 Widerrufsbelehrung

**Widerrufsrecht**

Sie haben das Recht, binnen vierzehn Tagen ohne Angabe von Gründen diesen Vertrag zu widerrufen. Die Widerrufsfrist beträgt vierzehn Tage ab dem Tag des Vertragsabschlusses.

Um Ihr Widerrufsrecht auszuüben, müssen Sie uns (Claudio Medeiros Magalhaes, Westfalenweg 3, 49504 Lotte, E-Mail: info@lernarena.app) mittels einer eindeutigen Erklärung (z. B. ein mit der Post versandter Brief oder eine E-Mail) über Ihren Entschluss, diesen Vertrag zu widerrufen, informieren. Sie können dafür das nachstehende Muster-Widerrufsformular verwenden, das jedoch nicht vorgeschrieben ist.

Zur Wahrung der Widerrufsfrist reicht es aus, dass Sie die Mitteilung über die Ausübung des Widerrufsrechts vor Ablauf der Widerrufsfrist absenden.

**Folgen des Widerrufs**

Wenn Sie diesen Vertrag widerrufen, haben wir Ihnen alle Zahlungen, die wir von Ihnen erhalten haben, unverzüglich und spätestens binnen vierzehn Tagen ab dem Tag zurückzuzahlen, an dem die Mitteilung über Ihren Widerruf dieses Vertrags bei uns eingegangen ist. Für diese Rückzahlung verwenden wir dasselbe Zahlungsmittel, das Sie bei der ursprünglichen Transaktion eingesetzt haben, es sei denn, mit Ihnen wurde ausdrücklich etwas anderes vereinbart; in keinem Fall werden Ihnen wegen dieser Rückzahlung Entgelte berechnet.

Haben Sie verlangt, dass die Dienstleistungen während der Widerrufsfrist beginnen sollen, so haben Sie uns einen angemessenen Betrag zu zahlen, der dem Anteil der bis zu dem Zeitpunkt, zu dem Sie uns von der Ausübung des Widerrufsrechts hinsichtlich dieses Vertrags unterrichten, bereits erbrachten Dienstleistungen im Vergleich zum Gesamtumfang der im Vertrag vorgesehenen Dienstleistungen entspricht.

### 6.4 Muster-Widerrufsformular

(Wenn Sie den Vertrag widerrufen wollen, dann füllen Sie bitte dieses Formular aus und senden Sie es zurück.)

- An Claudio Medeiros Magalhaes, Westfalenweg 3, 49504 Lotte, E-Mail: info@lernarena.app:
- Hiermit widerrufe(n) ich/wir (*) den von mir/uns (*) abgeschlossenen Vertrag über die Erbringung der folgenden Dienstleistung (*)
- Bestellt am (*)
- Name des/der Verbraucher(s)
- Anschrift des/der Verbraucher(s)
- Unterschrift des/der Verbraucher(s) (nur bei Mitteilung auf Papier)
- Datum

(*) Unzutreffendes streichen.

### 6.5 Kontolöschung

Der Nutzer kann sein Konto jederzeit durch eine E-Mail an den Anbieter löschen lassen. Mit der Löschung endet der Zugang zu allen gespeicherten Daten und Fortschritten.

## 7. Nutzungsregeln und Pflichten

Der Nutzer verpflichtet sich, die Plattform nicht zu missbrauchen. Insbesondere ist es untersagt:

- Automatisierte Anfragen oder Scraping durchzuführen
- Zugangsdaten weiterzugeben oder zu verkaufen
- Die Plattform für rechtswidrige Zwecke zu nutzen
- Inhalte der Plattform ohne Genehmigung zu vervielfältigen oder zu verbreiten

Bei Verstößen behält sich der Anbieter vor, den Account ohne Vorwarnung zu sperren.

## 8. Haftungsbeschränkung

Der Anbieter haftet unbeschränkt für Schäden aus der Verletzung des Lebens, des Körpers oder der Gesundheit sowie bei Vorsatz und grober Fahrlässigkeit.

Im Übrigen ist die Haftung auf typische, vorhersehbare Schäden beschränkt. Insbesondere übernimmt der Anbieter keine Haftung dafür, dass die Nutzer die IHK-Prüfung bestehen. Die Inhalte der Plattform ersetzen keine offizielle Prüfungsvorbereitung durch Berufsschulen oder die IHK.

Die Verfügbarkeit der Plattform wird mit angemessener Sorgfalt sichergestellt, jedoch nicht garantiert. Wartungsarbeiten können zu vorübergehenden Einschränkungen führen.

## 9. Änderungen der AGB

### 9.1 Geringfügige Änderungen

Änderungen, die für den Nutzer lediglich vorteilhaft oder rechtlich bzw. technisch unwesentlich sind (z. B. Anpassungen an eine geänderte Gesetzeslage, redaktionelle Korrekturen oder die Ergänzung neuer Funktionen ohne Einfluss auf bestehende Hauptleistungen oder Preise), bietet der Anbieter dem Nutzer mindestens 6 Wochen vor dem geplanten Inkrafttreten in Textform (z. B. per E-Mail oder In-App-Benachrichtigung) an. Die Änderung gilt nur dann als angenommen, wenn der Nutzer ihr nicht bis zum Inkrafttreten widerspricht. Auf diese Bedeutung seines Schweigens sowie auf sein Widerspruchs- und Kündigungsrecht weist der Anbieter im Änderungsangebot gesondert hin. Widerspricht der Nutzer, kann jede Partei den Vertrag zum Zeitpunkt des geplanten Inkrafttretens kündigen.

### 9.2 Wesentliche Änderungen

Wesentliche Änderungen – insbesondere Änderungen der Preise, des Leistungsumfangs oder sonstiger vertraglicher Hauptpflichten – bedürfen der ausdrücklichen Zustimmung des Nutzers. Bloßes Schweigen gilt insoweit nicht als Zustimmung. Ohne ausdrückliche Zustimmung gilt der Vertrag zu den bisherigen Bedingungen fort; der Anbieter kann den Vertrag in diesem Fall zum nächsten zulässigen Zeitpunkt kündigen.

### 9.3 Bereits bezahlte Leistungen

Bereits abgeschlossene und vollständig bezahlte Leistungen bleiben von Preisänderungen unberührt.

## 10. Schlussbestimmungen

Es gilt das Recht der Bundesrepublik Deutschland unter Ausschluss des UN-Kaufrechts. Für Verbraucher innerhalb der EU bleiben zwingende Verbraucherschutzvorschriften des jeweiligen Wohnsitzlandes unberührt.

Sollten einzelne Bestimmungen dieser AGB unwirksam sein, bleibt die Wirksamkeit der übrigen Bestimmungen davon unberührt.

Stand: 28. Juni 2026
''';
