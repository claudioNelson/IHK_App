import type { Metadata } from "next";
import Link from "next/link";
import RechtSeite from "../components/RechtSeite";
import { LsAbschnitt } from "../lernen/_components/LsBausteine";

export const metadata: Metadata = {
  title: "Datenschutzerklärung",
  description: "Datenschutzerklärung gemäß DSGVO für Lernarena",
  alternates: {
    canonical: "https://lernarena.app/datenschutz",
  },
};

// Festes Datum der letzten inhaltlichen Änderung.
// Bei jeder echten Überarbeitung der Datenschutzerklärung manuell anpassen.
const STAND = "23. September 2026";

const sections = [
  {
    id: "verantwortlicher",
    title: "1. Verantwortlicher",
    content: (
      <>
        <p>Verantwortlicher im Sinne der DSGVO ist:</p>
        <p>
          <strong>Claudio Medeiros Magalhaes</strong>
          <br />
          Westfalenweg 3
          <br />
          49504 Lotte
          <br />
          Deutschland
        </p>
        <p>
          E-Mail: <a href="mailto:info@lernarena.app">info@lernarena.app</a>
        </p>
      </>
    ),
  },
  {
    id: "grundsaetze",
    title: "2. Grundsätze der Datenverarbeitung",
    content: (
      <p>
        Wir verarbeiten personenbezogene Daten nur, soweit dies zur
        Bereitstellung einer funktionsfähigen App sowie unserer Inhalte und
        Leistungen erforderlich ist. Die Verarbeitung erfolgt nur nach
        Einwilligung der Nutzer, soweit keine andere Rechtsgrundlage besteht
        (Art. 6 DSGVO). Wir geben deine Daten nicht ohne deine ausdrückliche
        Einwilligung an Dritte weiter, außer dies ist zur Vertragserfüllung
        notwendig.
      </p>
    ),
  },
  {
    id: "erhobene-daten",
    title: "3. Welche Daten wir erheben",
    content: (
      <>
        <h3>Bei der Registrierung</h3>
        <p>
          E-Mail-Adresse und Passwort (verschlüsselt gespeichert). Diese
          Daten sind zur Vertragserfüllung erforderlich (Art. 6 Abs. 1 lit. b
          DSGVO). Zusätzlich speichern wir, über welche Plattform du
          Lernarena nutzt (Android, iOS oder Web), um zu sehen, auf welchen
          Geräten die App genutzt wird (Art. 6 Abs. 1 lit. f DSGVO).
        </p>

        <h3>Bei der Nutzung der App</h3>
        <ul>
          <li>Lernfortschritte und Testergebnisse</li>
          <li>Erstellte Karteikarten und Wiederholungsdaten</li>
          <li>Elo-Wertung aus Arena-Duellen</li>
          <li>Abzeichen und freigeschaltete Inhalte</li>
        </ul>
        <p>
          Diese Daten werden gespeichert, um dir den Lerndienst
          bereitzustellen (Art. 6 Abs. 1 lit. b DSGVO).
        </p>

        <h3>Bei der Nutzung der KI-Funktion (Ada)</h3>
        <p>
          Deine Fragen an die KI-Tutorin Ada und deine Antworten in
          Übungsprüfungen mit KI-Korrektur werden zur Verarbeitung an externe
          KI-Anbieter weitergeleitet. Der Inhalt deiner Anfrage kann
          personenbezogene Daten enthalten, sofern du solche eingibst.
          Stammdaten wie Name oder E-Mail-Adresse übermitteln wir dabei
          nicht. Welche Anbieter das sind und wie sie mit den Inhalten
          umgehen, steht in Abschnitt 6.
        </p>
      </>
    ),
  },
  {
    id: "cookies",
    title: "4. Cookies und lokale Speicherung",
    content: (
      <>
        <p>
          Die Web-App verwendet technisch notwendige Cookies und lokalen
          Browser-Speicher (LocalStorage) ausschließlich für:
        </p>
        <ul>
          <li>Aufrechterhaltung der Anmeldesitzung</li>
          <li>Speicherung von Nutzereinstellungen</li>
        </ul>
        <p>
          Es werden keine Tracking- oder Werbe-Cookies eingesetzt. Eine
          Einwilligung ist für technisch notwendige Cookies nicht erforderlich
          (§ 25 Abs. 2 TDDDG).
        </p>
      </>
    ),
  },
  {
    id: "supabase",
    title: "5. Supabase (Datenbank & Authentifizierung)",
    content: (
      <>
        <p>
          Wir nutzen Supabase als Backend-Dienst für Datenspeicherung und
          Nutzerauthentifizierung. Anbieter ist die Supabase Inc., 970 Toa
          Payoh North, #07-04, Singapur 318992.
        </p>
        <p>
          Die Daten werden auf Servern in der EU (Frankfurt, AWS eu-central-1)
          gespeichert. Supabase ist nach dem EU-US Data Privacy Framework
          zertifiziert. Rechtsgrundlage ist Art. 6 Abs. 1 lit. b DSGVO
          (Vertragserfüllung) sowie Art. 28 DSGVO (Auftragsverarbeitung).
        </p>
        <p>
          Datenschutzerklärung von Supabase:{" "}
          <a
            href="https://supabase.com/privacy"
            target="_blank"
            rel="noopener noreferrer"
          >
            supabase.com/privacy
          </a>
        </p>
      </>
    ),
  },
  {
    id: "ki-anbieter",
    title: "6. KI-Anbieter (KI-Tutorin Ada)",
    content: (
      <>
        <p>
          Für die KI-Tutorin „Ada“ und die KI-Korrektur von Übungsprüfungen
          arbeiten wir mit zwei Anbietern. Deine
          Anfrage geht nie direkt von deinem Gerät an sie, sondern zunächst an
          unseren eigenen Server; dieser leitet sie weiter. Angefragt wird
          zuerst Anthropic. Nur wenn dieser Dienst nicht erreichbar ist, wird
          Groq als Rückfallebene verwendet.
        </p>
        <p>
          Übertragen wird ausschließlich der Inhalt deiner Anfrage samt dem
          bisherigen Gesprächsverlauf, bei der Prüfungskorrektur die
          Aufgabenstellung und deine Antworten. Dieser kann personenbezogene Daten
          enthalten, sofern du solche eingibst. Stammdaten wie Name,
          Nutzername oder E-Mail-Adresse übermitteln wir nicht.
        </p>
        <p>
          <strong>Anthropic PBC</strong>,
          548 Market St, PMB 90375, San Francisco, CA 94104, USA. Wir nutzen
          einen kostenpflichtigen API-Zugang. Anthropic verwendet über die API
          übermittelte Inhalte nicht zum Training seiner Modelle.
          Datenschutzerklärung:{" "}
          <a
            href="https://www.anthropic.com/legal/privacy"
            target="_blank"
            rel="noopener noreferrer"
          >
            anthropic.com/legal/privacy
          </a>
        </p>
        <p>
          <strong>Groq, Inc.</strong>, 101
          University Ave, Suite 334, Palo Alto, CA 94301, USA. Groq verwendet
          über die API übermittelte Inhalte nicht zum Training eigener Modelle.
          Zur Sicherstellung des Betriebs und zur Missbrauchskontrolle können
          Inhalte für einen begrenzten Zeitraum gespeichert werden.
          Datenschutzerklärung:{" "}
          <a
            href="https://groq.com/privacy-policy/"
            target="_blank"
            rel="noopener noreferrer"
          >
            groq.com/privacy-policy
          </a>
        </p>
        <p>
          Die Verarbeitung erfolgt jeweils im Auftrag auf Grundlage eines
          Auftragsverarbeitungsvertrags (Art. 28 DSGVO). Die Übertragung in die USA erfolgt auf Grundlage der
          Standardvertragsklauseln (Art. 46 DSGVO). Rechtsgrundlage für die
          Nutzung ist Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung).
        </p>
      </>
    ),
  },
  {
    id: "vercel",
    title: "7. Vercel (Web-Hosting)",
    content: (
      <>
        <p>
          Die Web-App wird über Vercel gehostet. Anbieter ist Vercel Inc., 340
          S Lemon Ave #4133, Walnut, CA 91789, USA.
        </p>
        <p>
          Beim Aufruf der Website werden automatisch technische Daten (z. B.
          IP-Adresse, Browsertyp, Uhrzeit) in Server-Logs gespeichert. Diese
          Daten werden von Vercel zur Sicherstellung des Betriebs verwendet und
          nicht mit anderen Daten zusammengeführt. Rechtsgrundlage ist Art. 6
          Abs. 1 lit. f DSGVO (berechtigtes Interesse an einem sicheren
          Betrieb).
        </p>
        <p>
          Datenschutzerklärung von Vercel:{" "}
          <a
            href="https://vercel.com/legal/privacy-policy"
            target="_blank"
            rel="noopener noreferrer"
          >
            vercel.com/legal/privacy-policy
          </a>
        </p>
      </>
    ),
  },
  {
    id: "stripe",
    title: "8. Stripe (Zahlungsabwicklung)",
    content: (
      <>
        <p>
          Für die Zahlungsabwicklung von Premium-Abonnements über die Web-App
          nutzen wir den Zahlungsdienstleister Stripe. Anbieter ist die Stripe
          Payments Europe, Ltd., The One Building, 1 Grand Canal Street Lower,
          Dublin 2, Irland.
        </p>
        <p>
          Wenn du ein Abonnement abschließt oder verwaltest, werden die im
          Bezahlvorgang eingegebenen Daten (z. B. Name, E-Mail-Adresse,
          Zahlungs- und Rechnungsdaten sowie technische Daten wie IP-Adresse)
          direkt von Stripe verarbeitet. Die vollständigen Kartendaten werden
          ausschließlich von Stripe verarbeitet und nicht an uns übertragen; wir
          erhalten lediglich eine Kundenkennung sowie Status- und
          Abrechnungsinformationen zur Verwaltung deines Abonnements.
        </p>
        <p>
          Rechtsgrundlage ist Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung).
          Die Verarbeitung erfolgt auf Grundlage eines
          Auftragsverarbeitungsvertrags (Art. 28 DSGVO); soweit Daten in
          Drittländer übermittelt werden, erfolgt dies auf Grundlage der
          EU-Standardvertragsklauseln (Art. 46 DSGVO).
        </p>
        <p>
          Datenschutzerklärung von Stripe:{" "}
          <a
            href="https://stripe.com/de/privacy"
            target="_blank"
            rel="noopener noreferrer"
          >
            stripe.com/de/privacy
          </a>
        </p>
      </>
    ),
  },
  {
    id: "app-stores",
    title: "9. Google Play und Apple App Store (In-App-Käufe)",
    content: (
      <>
        <p>
          In der Android-App wird Premium über Google Play abgerechnet, in der
          iOS-App über den Apple App Store. Anbieter sind Google Ireland
          Limited, Gordon House, Barrow Street, Dublin 4, Irland, und Apple
          Distribution International Ltd., Hollyhill Industrial Estate, Cork,
          Irland.
        </p>
        <p>
          Die Zahlung läuft vollständig über den jeweiligen Store; Zahlungsdaten
          erhalten wir nicht. Um dein Abonnement freizuschalten und zu
          verwalten, prüfen wir die Kaufbestätigung des Stores auf unserem
          Server und speichern dazu die Transaktionskennung, das gekaufte
          Produkt, den Preis und die Laufzeit. Rechtsgrundlage ist Art. 6 Abs. 1
          lit. b DSGVO (Vertragserfüllung).
        </p>
        <p>
          Datenschutzerklärungen:{" "}
          <a
            href="https://policies.google.com/privacy"
            target="_blank"
            rel="noopener noreferrer"
          >
            policies.google.com/privacy
          </a>{" "}
          und{" "}
          <a
            href="https://www.apple.com/legal/privacy/de-ww/"
            target="_blank"
            rel="noopener noreferrer"
          >
            apple.com/legal/privacy
          </a>
        </p>
      </>
    ),
  },
  {
    id: "benachrichtigungen",
    title: "10. Interne Benachrichtigungen (Telegram)",
    content: (
      <>
        <p>
          Bei einer Registrierung und bei einem Premium-Kauf schicken wir uns
          selbst eine kurze Benachrichtigung über den Messenger Telegram
          (Telegram FZ-LLC, Dubai, Vereinigte Arabische Emirate). Sie enthält
          die E-Mail-Adresse des Kontos, die genutzte Plattform und beim Kauf
          das Produkt und den Preis.
        </p>
        <p>
          Zweck ist die Überwachung des laufenden Betriebs und die Erkennung
          von Missbrauch. Rechtsgrundlage ist Art. 6 Abs. 1 lit. f DSGVO
          (berechtigtes Interesse). Die Nachrichten werden nur von uns gelesen
          und nach spätestens 90 Tagen gelöscht. Datenschutzerklärung von
          Telegram:{" "}
          <a
            href="https://telegram.org/privacy"
            target="_blank"
            rel="noopener noreferrer"
          >
            telegram.org/privacy
          </a>
        </p>
      </>
    ),
  },
  {
    id: "rechte",
    title: "11. Deine Rechte",
    content: (
      <>
        <p>Du hast gemäß DSGVO folgende Rechte:</p>
        <ul>
          <li>
            <strong>Auskunft</strong> (Art. 15 DSGVO): Welche Daten wir über
            dich gespeichert haben
          </li>
          <li>
            <strong>Berichtigung</strong> (Art. 16 DSGVO): Korrektur falscher
            Daten
          </li>
          <li>
            <strong>Löschung</strong> (Art. 17 DSGVO): „Recht auf
            Vergessenwerden“
          </li>
          <li>
            <strong>Einschränkung</strong> (Art. 18 DSGVO): Eingeschränkte
            Verarbeitung deiner Daten
          </li>
          <li>
            <strong>Datenübertragbarkeit</strong> (Art. 20 DSGVO): Deine Daten
            in maschinenlesbarem Format
          </li>
          <li>
            <strong>Widerspruch</strong> (Art. 21 DSGVO): Gegen bestimmte
            Verarbeitungen
          </li>
        </ul>
        <p>
          Zur Ausübung deiner Rechte wende dich per E-Mail an:{" "}
          <a href="mailto:info@lernarena.app">info@lernarena.app</a>
        </p>
        <p>
          Du hast außerdem das Recht, dich bei einer Datenschutzaufsichtsbehörde
          zu beschweren. Für uns zuständig ist die Landesbeauftragte für
          Datenschutz und Informationsfreiheit Nordrhein-Westfalen (LDI NRW),
          Kavalleriestraße 2-4, 40213 Düsseldorf.
        </p>
      </>
    ),
  },
  {
    id: "loeschung",
    title: "12. Datenlöschung und Kontolöschung",
    content: (
      <p>
        Du kannst dein Konto und alle damit verbundenen Daten jederzeit
        löschen lassen. Wie das geht, steht auf der Seite{" "}
        <Link href="/account-loeschung">Konto löschen</Link>
        . Daten werden
        gelöscht, sobald sie für den Zweck der Verarbeitung nicht mehr
        erforderlich sind und keine gesetzlichen Aufbewahrungspflichten
        entgegenstehen (z. B. steuerliche Aufbewahrungspflichten von 10
        Jahren für Rechnungsdaten).
      </p>
    ),
  },
  {
    id: "aenderungen",
    title: "13. Änderungen dieser Datenschutzerklärung",
    content: (
      <p>
        Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf anzupassen,
        um sie an geänderte rechtliche Anforderungen oder Änderungen unserer
        Dienste anzupassen. Die jeweils aktuelle Version ist stets auf dieser
        Seite abrufbar. Stand: {STAND}.
      </p>
    ),
  },
];

export default function DatenschutzPage() {
  return (
    <RechtSeite
      titel="Datenschutzerklärung"
      untertitel={<>Gemäß Art. 13, 14 DSGVO. Zuletzt aktualisiert: {STAND}</>}
      pfad="Datenschutz"
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