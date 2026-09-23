import Link from "next/link";

export const metadata = {
  title: "Datenschutzerklärung",
  description: "Datenschutzerklärung gemäß DSGVO für Lernarena",
};

// Festes Datum der letzten inhaltlichen Änderung.
// Bei jeder echten Überarbeitung der Datenschutzerklärung manuell anpassen.
const STAND = "23. September 2026";

const sections = [
  {
    id: "verantwortlicher",
    title: "1. Verantwortlicher",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>Verantwortlicher im Sinne der DSGVO ist:</p>
        <div className="bg-gray-50 rounded-lg p-4 border border-gray-200 space-y-1">
          <p className="font-medium">Claudio Medeiros Magalhaes</p>
          <p>Westfalenweg 3</p>
          <p>49504 Lotte</p>
          <p>Deutschland</p>
          <p className="pt-1">
            E-Mail:{" "}
            <a
              href="mailto:info@lernarena.app"
              className="text-blue-700 hover:underline"
            >
              info@lernarena.app
            </a>
          </p>
        </div>
      </div>
    ),
  },
  {
    id: "grundsaetze",
    title: "2. Grundsätze der Datenverarbeitung",
    content: (
      <p className="text-gray-700 text-sm leading-relaxed">
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
      <div className="text-gray-700 text-sm leading-relaxed space-y-4">
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            Bei der Registrierung
          </h3>
          <p>
            E-Mail-Adresse und Passwort (verschlüsselt gespeichert). Diese
            Daten sind zur Vertragserfüllung erforderlich (Art. 6 Abs. 1 lit. b
            DSGVO). Zusätzlich speichern wir, über welche Plattform du
            Lernarena nutzt (Android, iOS oder Web), um zu sehen, auf welchen
            Geräten die App genutzt wird (Art. 6 Abs. 1 lit. f DSGVO).
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            Bei der Nutzung der App
          </h3>
          <ul className="list-disc list-inside space-y-1 text-gray-600">
            <li>Lernfortschritte und Testergebnisse</li>
            <li>Erstellte Karteikarten und Wiederholungsdaten</li>
            <li>Elo-Wertung aus Arena-Duellen</li>
            <li>Abzeichen und freigeschaltete Inhalte</li>
          </ul>
          <p className="mt-2">
            Diese Daten werden gespeichert, um dir den Lerndienst
            bereitzustellen (Art. 6 Abs. 1 lit. b DSGVO).
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            Bei der Nutzung der KI-Funktion (Ada)
          </h3>
          <p>
            Deine Fragen an die KI-Tutorin Ada und deine Antworten in
            Übungsprüfungen mit KI-Korrektur werden zur Verarbeitung an externe
            KI-Anbieter weitergeleitet. Der Inhalt deiner Anfrage kann
            personenbezogene Daten enthalten, sofern du solche eingibst.
            Stammdaten wie Name oder E-Mail-Adresse übermitteln wir dabei
            nicht. Welche Anbieter das sind und wie sie mit den Inhalten
            umgehen, steht in Abschnitt 6.
          </p>
        </div>
      </div>
    ),
  },
  {
    id: "cookies",
    title: "4. Cookies und lokale Speicherung",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Die Web-App verwendet technisch notwendige Cookies und lokalen
          Browser-Speicher (LocalStorage) ausschließlich für:
        </p>
        <ul className="list-disc list-inside text-gray-600 space-y-1">
          <li>Aufrechterhaltung der Anmeldesitzung</li>
          <li>Speicherung von Nutzereinstellungen</li>
        </ul>
        <p>
          Es werden keine Tracking- oder Werbe-Cookies eingesetzt. Eine
          Einwilligung ist für technisch notwendige Cookies nicht erforderlich
          (§ 25 Abs. 2 TDDDG).
        </p>
      </div>
    ),
  },
  {
    id: "supabase",
    title: "5. Supabase (Datenbank & Authentifizierung)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
            className="text-blue-700 hover:underline"
          >
            supabase.com/privacy
          </a>
        </p>
      </div>
    ),
  },
  {
    id: "ki-anbieter",
    title: "6. KI-Anbieter (KI-Tutorin Ada)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
          <strong className="font-medium text-gray-800">Anthropic PBC</strong>,
          548 Market St, PMB 90375, San Francisco, CA 94104, USA. Wir nutzen
          einen kostenpflichtigen API-Zugang. Anthropic verwendet über die API
          übermittelte Inhalte nicht zum Training seiner Modelle.
          Datenschutzerklärung:{" "}
          <a
            href="https://www.anthropic.com/legal/privacy"
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-700 hover:underline"
          >
            anthropic.com/legal/privacy
          </a>
        </p>
        <p>
          <strong className="font-medium text-gray-800">Groq, Inc.</strong>, 101
          University Ave, Suite 334, Palo Alto, CA 94301, USA. Groq verwendet
          über die API übermittelte Inhalte nicht zum Training eigener Modelle.
          Zur Sicherstellung des Betriebs und zur Missbrauchskontrolle können
          Inhalte für einen begrenzten Zeitraum gespeichert werden.
          Datenschutzerklärung:{" "}
          <a
            href="https://groq.com/privacy-policy/"
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-700 hover:underline"
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
      </div>
    ),
  },
  {
    id: "vercel",
    title: "7. Vercel (Web-Hosting)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
            className="text-blue-700 hover:underline"
          >
            vercel.com/legal/privacy-policy
          </a>
        </p>
      </div>
    ),
  },
  {
    id: "stripe",
    title: "8. Stripe (Zahlungsabwicklung)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
          
            <a href="https://stripe.com/de/privacy"
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-700 hover:underline"
          >
            stripe.com/de/privacy
          </a>
        </p>
      </div>
    ),
  },
  {
    id: "app-stores",
    title: "9. Google Play und Apple App Store (In-App-Käufe)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
            className="text-blue-700 hover:underline"
          >
            policies.google.com/privacy
          </a>{" "}
          und{" "}
          <a
            href="https://www.apple.com/legal/privacy/de-ww/"
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-700 hover:underline"
          >
            apple.com/legal/privacy
          </a>
        </p>
      </div>
    ),
  },
  {
    id: "benachrichtigungen",
    title: "10. Interne Benachrichtigungen (Telegram)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
            className="text-blue-700 hover:underline"
          >
            telegram.org/privacy
          </a>
        </p>
      </div>
    ),
  },
  {
    id: "rechte",
    title: "11. Deine Rechte",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>Du hast gemäß DSGVO folgende Rechte:</p>
        <ul className="list-disc list-inside text-gray-600 space-y-1">
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
        <p className="mt-2">
          Zur Ausübung deiner Rechte wende dich per E-Mail an:{" "}
          <a
            href="mailto:info@lernarena.app"
            className="text-blue-700 hover:underline"
          >
            info@lernarena.app
          </a>
        </p>
        <p>
          Du hast außerdem das Recht, dich bei einer Datenschutzaufsichtsbehörde
          zu beschweren. Für uns zuständig ist die Landesbeauftragte für
          Datenschutz und Informationsfreiheit Nordrhein-Westfalen (LDI NRW),
          Kavalleriestraße 2-4, 40213 Düsseldorf.
        </p>
      </div>
    ),
  },
  {
    id: "loeschung",
    title: "12. Datenlöschung und Kontolöschung",
    content: (
      <p className="text-gray-700 text-sm leading-relaxed">
        Du kannst dein Konto und alle damit verbundenen Daten jederzeit
        löschen lassen. Wie das geht, steht auf der Seite{" "}
        <Link href="/account-loeschung" className="text-blue-700 hover:underline">
          Konto löschen
        </Link>
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
      <p className="text-gray-700 text-sm leading-relaxed">
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
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-6 py-4 flex items-center justify-between">
          <Link href="/" className="text-2xl font-bold text-blue-900">
            Lernarena
          </Link>
          <Link
            href="/"
            className="text-sm text-gray-500 hover:text-blue-900 transition"
          >
            Zurück zur Startseite
          </Link>
        </div>
      </header>

      <main className="container mx-auto px-6 py-16 max-w-3xl">
        <h1 className="text-4xl font-bold text-gray-900 mb-2">
          Datenschutzerklärung
        </h1>
        <p className="text-gray-500 mb-12">
          Gemäß Art. 13, 14 DSGVO. Zuletzt aktualisiert: {STAND}
        </p>

        {/* Table of contents */}
        <nav className="bg-white rounded-2xl p-6 border border-gray-200 mb-8">
          <p className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3">
            Inhalt
          </p>
          <ol className="space-y-1">
            {sections.map((s) => (
              <li key={s.id}>
                <a
                  href={`#${s.id}`}
                  className="text-sm text-blue-700 hover:underline"
                >
                  {s.title}
                </a>
              </li>
            ))}
          </ol>
        </nav>

        {/* Sections */}
        <div className="space-y-6">
          {sections.map((s) => (
            <section
              key={s.id}
              id={s.id}
              className="bg-white rounded-2xl p-8 border border-gray-200 scroll-mt-8"
            >
              <h2 className="text-lg font-semibold text-gray-900 mb-4">
                {s.title}
              </h2>
              {s.content}
            </section>
          ))}
        </div>

        {/* Footer nav */}
        <div className="flex gap-6 text-sm text-gray-500 mt-12">
          <Link href="/impressum" className="hover:text-blue-700 transition">
            Impressum
          </Link>
          <Link href="/agb" className="hover:text-blue-700 transition">
            AGB
          </Link>
          <Link href="/" className="hover:text-blue-700 transition">
            Startseite
          </Link>
        </div>
      </main>

      <footer className="border-t border-gray-200 py-8 mt-8">
        <div className="container mx-auto px-6 text-center text-sm text-gray-400">
          © {new Date().getFullYear()} Lernarena. Alle Rechte vorbehalten.
        </div>
      </footer>
    </div>
  );
}