import type { Metadata } from "next";
import Link from "next/link";
import RechtSeite from "../components/RechtSeite";
import { LsAbschnitt, LsHinweis } from "../lernen/_components/LsBausteine";

export const metadata: Metadata = {
  title: "AGB",
  description: "Allgemeine Geschäftsbedingungen von Lernarena",
  alternates: {
    canonical: "https://lernarena.app/agb",
  },
};

// Festes Datum der letzten inhaltlichen Änderung.
// Bei jeder echten Überarbeitung der AGB manuell anpassen.
const STAND = "23. September 2026";

const sections = [
  {
    id: "geltungsbereich",
    title: "1. Geltungsbereich",
    content: (
      <>
        <p>
          Diese Allgemeinen Geschäftsbedingungen (AGB) gelten für alle
          Verträge zwischen
        </p>
        <p>
          <strong>Claudio Medeiros Magalhaes</strong>
          <br />
          Westfalenweg 3, 49504 Lotte
          <br />
          E-Mail: <a href="mailto:info@lernarena.app">info@lernarena.app</a>
          <br />
          (nachfolgend „Anbieter“)
        </p>
        <p>
          und den Nutzern der mobilen App sowie der Web-App „Lernarena“
          (nachfolgend „Nutzer“). Abweichende Bedingungen des Nutzers werden
          nicht anerkannt, es sei denn, der Anbieter stimmt diesen ausdrücklich
          schriftlich zu.
        </p>
      </>
    ),
  },
  {
    id: "leistungen",
    title: "2. Leistungsbeschreibung",
    content: (
      <>
        <p>
          Lernarena ist eine digitale Lernplattform, die IT-Auszubildende
          (insbesondere Fachinformatiker) bei der Vorbereitung auf die IHK-Prüfung
          unterstützt. Die Plattform bietet:
        </p>
        <ul>
          <li>Modulbasiertes Lernen mit Prüfungsfragen</li>
          <li>Karteikarten mit Wiederholungssystem</li>
          <li>Arena-Duelle gegen andere Lernende</li>
          <li>KI-Tutorin „Ada“</li>
          <li>Prüfungssimulationen im IHK-Stil mit KI-Korrektur (Premium)</li>
          <li>Zertifizierungsvorbereitung (AWS, Azure, GCP, SAP)</li>
        </ul>
        <p>
          <em>
            Lernarena steht in keiner offiziellen Verbindung zur IHK oder anderen
            Prüfungsbehörden. Die Inhalte dienen ausschließlich der
            Prüfungsvorbereitung und erheben keinen Anspruch auf Vollständigkeit
            oder Aktualität im Sinne offizieller Prüfungsunterlagen.
          </em>
        </p>
      </>
    ),
  },
  {
    id: "registrierung",
    title: "3. Registrierung und Nutzerkonto",
    content: (
      <>
        <p>
          Lernarena kann zunächst als Gast ohne Registrierung ausprobiert
          werden. Für den vollen Funktionsumfang, die Synchronisation zwischen
          Geräten und den Abschluss eines Premium-Abonnements ist ein
          Nutzerkonto mit einer gültigen E-Mail-Adresse erforderlich. Der
          Nutzer ist verpflichtet, wahrheitsgemäße Angaben zu machen und seine
          Zugangsdaten geheim zu halten.
        </p>
        <p>
          Die Registrierung ist ab einem Alter von 16 Jahren gestattet. Jüngere
          Nutzer benötigen die Einwilligung eines Erziehungsberechtigten.
        </p>
        <p>
          Ein Anspruch auf Registrierung besteht nicht. Der Anbieter behält
          sich vor, Accounts bei Verstößen gegen diese AGB zu sperren oder zu
          löschen.
        </p>
      </>
    ),
  },
  {
    id: "free-premium",
    title: "4. Kostenloser Tarif und Premium",
    content: (
      <>
        <h3>4.1 Kostenloser Tarif</h3>
        <p>
          Der kostenlose Tarif beinhaltet einen eingeschränkten
          Zugang zu den Lernfunktionen. Der Anbieter behält sich vor, den
          Umfang des kostenlosen Angebots jederzeit anzupassen.
        </p>

        <h3>4.2 Premium</h3>
        <p>
          Premium bietet unbegrenzten Zugang zu allen Funktionen und ist in
          folgenden Varianten erhältlich:
        </p>
        <ul>
          <li>Monatlich: 11,99 € / Monat</li>
          <li>Halbjährlich: 47,99 € / 6 Monate (entspricht ca. 8,00 € / Monat)</li>
          <li>Jährlich: 84,99 € / Jahr (entspricht ca. 7,08 € / Monat)</li>
        </ul>
        <p>
          Alle Preise sind Endpreise. Die Umsatzsteuer-Behandlung hängt vom
          Kaufweg ab:
        </p>
        <ul>
          <li>
            <strong>Kauf über die Web-App (Zahlung via Stripe):</strong> Der
            Anbieter ist Kleinunternehmer im Sinne von § 19 UStG; es wird
            keine Umsatzsteuer ausgewiesen.
          </li>
          <li>
            <strong>Kauf über Google Play:</strong> Die Zahlung wird über
            Google Play abgewickelt. Eine etwaig anfallende Umsatzsteuer wird
            von Google im Rahmen seines Bezahlsystems behandelt; es gelten die
            im Google Play Store angezeigten Endpreise.
          </li>
          <li>
            <strong>Kauf über den Apple App Store:</strong> Die Zahlung wird
            über Apple abgewickelt. Eine etwaig anfallende Umsatzsteuer wird
            von Apple im Rahmen seines Bezahlsystems behandelt; es gelten die
            im App Store angezeigten Endpreise.
          </li>
        </ul>

        <h3>4.3 Laufzeit und Verlängerung</h3>
        <p>
          Alle Abonnements (monatlich, halbjährlich, jährlich) verlängern sich
          automatisch um die jeweilige Laufzeit, wenn sie nicht rechtzeitig vor
          Ablauf gekündigt werden (siehe Abschnitt 6).
        </p>
      </>
    ),
  },
  {
    id: "zahlung",
    title: "5. Zahlung",
    content: (
      <>
        <p>Der Kaufweg richtet sich nach der genutzten Plattform:</p>
        <ul>
          <li>
            In der <strong>Android-App</strong> erfolgt die Abrechnung über
            Google Play.
          </li>
          <li>
            In der <strong>iOS-App</strong> erfolgt die Abrechnung über den
            Apple App Store (In-App-Kauf).
          </li>
          <li>
            In der <strong>Web-App</strong> erfolgt die Abrechnung über den
            Zahlungsdienstleister Stripe (Stripe Payments Europe, Ltd., Dublin,
            Irland). Es gelten ergänzend die Hinweise in der Datenschutzerklärung.
          </li>
        </ul>
        <p>
          Es gelten jeweils die Zahlungsbedingungen des genutzten Anbieters.
          Die Zahlung ist im Voraus fällig. Bei fehlgeschlagener Zahlung behält
          sich der Anbieter vor, den Zugang zu Premium-Funktionen zu
          unterbrechen.
        </p>
      </>
    ),
  },
  {
    id: "kuendigung",
    title: "6. Kündigung und Widerrufsrecht",
    content: (
      <>
        <h3>6.1 Kündigung</h3>
        <p>
          Alle Abonnements können jederzeit zum Ende des laufenden
          Abrechnungszeitraums gekündigt werden. Der Kündigungsweg
          richtet sich nach dem Kaufkanal:
        </p>
        <ul>
          <li>
            Über Google Play gekaufte Abonnements werden über die
            Abo-Einstellungen des Google-Play-Kontos gekündigt.
          </li>
          <li>
            Über den Apple App Store gekaufte Abonnements werden in den
            Abo-Einstellungen der Apple-ID (Einstellungen, Apple-ID,
            Abonnements) gekündigt.
          </li>
          <li>
            Über die Web-App (Stripe) gekaufte Abonnements können jederzeit
            selbst über die Abo-Verwaltung im eigenen Konto („Abo verwalten“)
            gekündigt werden. Die Kündigung wird zum Ende des laufenden
            Abrechnungszeitraums wirksam; der Zugang bleibt bis dahin bestehen.
          </li>
        </ul>

        <h3>6.2 Widerrufsrecht für Verbraucher</h3>
        <p>
          Verbraucher haben das Recht, einen Vertrag innerhalb von{" "}
          <strong>14 Tagen</strong> ohne Angabe von Gründen zu widerrufen.
          Die Einzelheiten ergeben sich aus der nachstehenden
          Widerrufsbelehrung (6.3).
        </p>
        <ul>
          <li>
            Bei Kauf über die <strong>Web-App (Stripe)</strong> richtest du
            den Widerruf direkt an den Anbieter (siehe Widerrufsbelehrung).
          </li>
          <li>
            Bei Kauf über <strong>Google Play</strong> oder den{" "}
            <strong>Apple App Store</strong> erfolgt die Rückabwicklung über
            den Erstattungsprozess des jeweiligen Stores; dein gesetzliches
            Widerrufsrecht gegenüber dem Anbieter bleibt unberührt.
          </li>
        </ul>

        <h3>6.3 Widerrufsbelehrung</h3>
        <LsHinweis titel="Widerrufsbelehrung" icon="buch" label="Widerrufsbelehrung">
          <p>
            <strong>Widerrufsrecht</strong>
          </p>
          <p>
            Sie haben das Recht, binnen vierzehn Tagen ohne Angabe von Gründen
            diesen Vertrag zu widerrufen. Die Widerrufsfrist beträgt vierzehn
            Tage ab dem Tag des Vertragsabschlusses.
          </p>
          <p>
            Um Ihr Widerrufsrecht auszuüben, müssen Sie uns (Claudio Medeiros
            Magalhaes, Westfalenweg 3, 49504 Lotte, E-Mail:
            info@lernarena.app) mittels einer eindeutigen Erklärung (z. B. ein
            mit der Post versandter Brief oder eine E-Mail) über Ihren
            Entschluss, diesen Vertrag zu widerrufen, informieren. Sie können
            dafür das nachstehende Muster-Widerrufsformular verwenden, das
            jedoch nicht vorgeschrieben ist.
          </p>
          <p>
            Zur Wahrung der Widerrufsfrist reicht es aus, dass Sie die
            Mitteilung über die Ausübung des Widerrufsrechts vor Ablauf der
            Widerrufsfrist absenden.
          </p>
          <p>
            <strong>Folgen des Widerrufs</strong>
          </p>
          <p>
            Wenn Sie diesen Vertrag widerrufen, haben wir Ihnen alle
            Zahlungen, die wir von Ihnen erhalten haben, unverzüglich und
            spätestens binnen vierzehn Tagen ab dem Tag zurückzuzahlen, an dem
            die Mitteilung über Ihren Widerruf dieses Vertrags bei uns
            eingegangen ist. Für diese Rückzahlung verwenden wir dasselbe
            Zahlungsmittel, das Sie bei der ursprünglichen Transaktion
            eingesetzt haben, es sei denn, mit Ihnen wurde ausdrücklich etwas
            anderes vereinbart; in keinem Fall werden Ihnen wegen dieser
            Rückzahlung Entgelte berechnet.
          </p>
          <p>
            Haben Sie verlangt, dass die Dienstleistungen während der
            Widerrufsfrist beginnen sollen, so haben Sie uns einen
            angemessenen Betrag zu zahlen, der dem Anteil der bis zu dem
            Zeitpunkt, zu dem Sie uns von der Ausübung des Widerrufsrechts
            hinsichtlich dieses Vertrags unterrichten, bereits erbrachten
            Dienstleistungen im Vergleich zum Gesamtumfang der im Vertrag
            vorgesehenen Dienstleistungen entspricht.
          </p>
        </LsHinweis>

        <h3>6.4 Muster-Widerrufsformular</h3>
        <p>
          <em>
            (Wenn Sie den Vertrag widerrufen wollen, dann füllen Sie bitte
            dieses Formular aus und senden Sie es zurück.)
          </em>
        </p>
        <ul>
          <li>
            An Claudio Medeiros Magalhaes, Westfalenweg 3, 49504 Lotte,
            E-Mail: info@lernarena.app:
          </li>
          <li>
            Hiermit widerrufe(n) ich/wir (*) den von mir/uns (*)
            abgeschlossenen Vertrag über die Erbringung der folgenden
            Dienstleistung (*)
          </li>
          <li>Bestellt am (*)</li>
          <li>Name des/der Verbraucher(s)</li>
          <li>Anschrift des/der Verbraucher(s)</li>
          <li>
            Unterschrift des/der Verbraucher(s) (nur bei Mitteilung auf
            Papier)
          </li>
          <li>Datum</li>
        </ul>
        <p>(*) Unzutreffendes streichen.</p>

        <h3>6.5 Kontolöschung</h3>
        <p>
          Der Nutzer kann sein Konto jederzeit löschen lassen. Wie das geht,
          steht auf der Seite{" "}
          <Link href="/account-loeschung">Konto löschen</Link>
          . Mit der Löschung endet der Zugang zu allen gespeicherten Daten
          und Fortschritten.
        </p>
      </>
    ),
  },
  {
    id: "nutzungsregeln",
    title: "7. Nutzungsregeln und Pflichten",
    content: (
      <>
        <p>Der Nutzer verpflichtet sich, die Plattform nicht zu missbrauchen. Insbesondere ist es untersagt:</p>
        <ul>
          <li>Automatisierte Anfragen oder Scraping durchzuführen</li>
          <li>Zugangsdaten weiterzugeben oder zu verkaufen</li>
          <li>Die Plattform für rechtswidrige Zwecke zu nutzen</li>
          <li>
            Inhalte der Plattform ohne Genehmigung zu vervielfältigen oder zu
            verbreiten
          </li>
        </ul>
        <p>
          Bei Verstößen behält sich der Anbieter vor, den Account ohne
          Vorwarnung zu sperren.
        </p>
      </>
    ),
  },
  {
    id: "haftung",
    title: "8. Haftungsbeschränkung",
    content: (
      <>
        <p>
          Der Anbieter haftet unbeschränkt für Schäden aus der Verletzung des
          Lebens, des Körpers oder der Gesundheit sowie bei Vorsatz und grober
          Fahrlässigkeit.
        </p>
        <p>
          Im Übrigen ist die Haftung auf typische, vorhersehbare Schäden
          beschränkt. Insbesondere übernimmt der Anbieter keine Haftung dafür,
          dass die Nutzer die IHK-Prüfung bestehen. Die Inhalte der Plattform
          ersetzen keine offizielle Prüfungsvorbereitung durch Berufsschulen
          oder die IHK.
        </p>
        <p>
          Die Verfügbarkeit der Plattform wird mit angemessener Sorgfalt
          sichergestellt, jedoch nicht garantiert. Wartungsarbeiten können zu
          vorübergehenden Einschränkungen führen.
        </p>
      </>
    ),
  },
  {
    id: "aenderungen",
    title: "9. Änderungen der AGB",
    content: (
      <>
        <h3>9.1 Geringfügige Änderungen</h3>
        <p>
          Änderungen, die für den Nutzer lediglich vorteilhaft oder rechtlich
          bzw. technisch unwesentlich sind (z. B. Anpassungen an eine
          geänderte Gesetzeslage, redaktionelle Korrekturen oder die Ergänzung
          neuer Funktionen ohne Einfluss auf bestehende Hauptleistungen oder
          Preise), bietet der Anbieter dem Nutzer mindestens 6 Wochen vor dem
          geplanten Inkrafttreten in Textform (z. B. per E-Mail oder
          In-App-Benachrichtigung) an. Die Änderung gilt nur dann als
          angenommen, wenn der Nutzer ihr nicht bis zum Inkrafttreten
          widerspricht. Auf diese Bedeutung seines Schweigens sowie auf sein
          Widerspruchs- und Kündigungsrecht weist der Anbieter im
          Änderungsangebot gesondert hin. Widerspricht der Nutzer, kann jede
          Partei den Vertrag zum Zeitpunkt des geplanten Inkrafttretens
          kündigen.
        </p>

        <h3>9.2 Wesentliche Änderungen</h3>
        <p>
          Wesentliche Änderungen, insbesondere Änderungen der Preise, des
          Leistungsumfangs oder sonstiger vertraglicher Hauptpflichten,
          bedürfen der ausdrücklichen Zustimmung des Nutzers. Bloßes Schweigen
          gilt insoweit nicht als Zustimmung. Ohne ausdrückliche Zustimmung
          gilt der Vertrag zu den bisherigen Bedingungen fort; der Anbieter
          kann den Vertrag in diesem Fall zum nächsten zulässigen Zeitpunkt
          kündigen.
        </p>

        <h3>9.3 Bereits bezahlte Leistungen</h3>
        <p>
          Bereits abgeschlossene und vollständig bezahlte Leistungen bleiben
          von Preisänderungen unberührt.
        </p>
      </>
    ),
  },
  {
    id: "schlussbestimmungen",
    title: "10. Schlussbestimmungen",
    content: (
      <>
        <p>
          Es gilt das Recht der Bundesrepublik Deutschland unter Ausschluss des
          UN-Kaufrechts. Für Verbraucher innerhalb der EU bleiben zwingende
          Verbraucherschutzvorschriften des jeweiligen Wohnsitzlandes
          unberührt.
        </p>
        <p>
          Der Anbieter ist nicht bereit und nicht verpflichtet, an
          Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle
          teilzunehmen (§ 36 VSBG).
        </p>
        <p>
          Sollten einzelne Bestimmungen dieser AGB unwirksam sein, bleibt die
          Wirksamkeit der übrigen Bestimmungen davon unberührt.
        </p>
        <p>Stand: {STAND}</p>
      </>
    ),
  },
];

export default function AGBPage() {
  return (
    <RechtSeite
      titel="Allgemeine Geschäftsbedingungen"
      untertitel={<>Zuletzt aktualisiert: {STAND}</>}
      pfad="AGB"
      abschnitte={sections.map((s) => ({ id: s.id, titel: s.title }))}
    >
      {sections.map((s) => (
        <LsAbschnitt key={s.id} id={s.id} titel={s.title}>
          {s.content}
        </LsAbschnitt>
      ))}
    </RechtSeite>
  );
}