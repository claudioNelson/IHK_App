import Link from "next/link";

export const metadata = {
  title: "Datenschutzerklärung – Lernarena",
  description: "Datenschutzerklärung gemäß DSGVO für Lernarena",
};

const sections = [
  {
    id: "verantwortlicher",
    title: "1. Verantwortlicher",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>Verantwortlicher im Sinne der DSGVO ist:</p>
        <div className="bg-gray-50 rounded-lg p-4 border border-gray-200 space-y-1">
          {/* ⚠️ PLATZHALTER – nach Gewerbeanmeldung ausfüllen */}
          <p className="font-medium">[Vor- und Nachname]</p>
          <p>[Straße und Hausnummer]</p>
          <p>[PLZ] [Stadt]</p>
          <p>Deutschland</p>
          <p className="pt-1">
            E-Mail:{" "}
            <a href="mailto:[E-MAIL]" className="text-blue-700 hover:underline">
              [E-MAIL@DOMAIN.DE]
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
            DSGVO).
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            Bei der Nutzung der App
          </h3>
          <ul className="list-disc list-inside space-y-1 text-gray-600">
            <li>Lernfortschritte und Testergebnisse</li>
            <li>Erstellte Lernkarten (Flashcards)</li>
            <li>Elo-Bewertung aus Multiplayer-Matches</li>
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
            Deine Fragen an den KI-Tutor werden zur Verarbeitung an die
            Groq-API weitergeleitet. Es werden keine personenbezogenen Daten
            dauerhaft bei Groq gespeichert. Weitere Details siehe Abschnitt 6.
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
          (§ 25 Abs. 2 TTDSG).
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
    id: "groq",
    title: "6. Groq API (KI-Tutor Ada)",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Für die KI-Tutorfunktion „Ada" verwenden wir die Groq API. Anbieter
          ist Groq, Inc., 101 University Ave, Suite 334, Palo Alto, CA 94301,
          USA.
        </p>
        <p>
          Wenn du eine Frage an Ada stellst, wird der Inhalt deiner Anfrage zur
          Verarbeitung an Groq übertragen. Wir übermitteln dabei keine
          personenbezogenen Daten wie Namen oder E-Mail-Adresse. Groq
          verarbeitet die Anfragen und speichert sie gemäß ihrer eigenen
          Datenschutzrichtlinie nicht dauerhaft für Trainingszwecke.
        </p>
        <p>
          Die Übertragung in die USA erfolgt auf Grundlage von Art. 46 DSGVO
          (Standardvertragsklauseln). Rechtsgrundlage für die Nutzung ist Art.
          6 Abs. 1 lit. b DSGVO (Vertragserfüllung).
        </p>
        <p>
          Datenschutzerklärung von Groq:{" "}
          <a
            href="https://groq.com/privacy-policy/"
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-700 hover:underline"
          >
            groq.com/privacy-policy
          </a>
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
    id: "rechte",
    title: "8. Deine Rechte",
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
            Vergessenwerden"
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
          <a href="mailto:[E-MAIL]" className="text-blue-700 hover:underline">
            {/* ⚠️ PLATZHALTER */}
            [E-MAIL@DOMAIN.DE]
          </a>
        </p>
        <p>
          Du hast außerdem das Recht, dich bei einer Datenschutzbehörde zu
          beschweren. In Deutschland ist dies der Bundesbeauftragte für den
          Datenschutz und die Informationsfreiheit (BfDI) oder die zuständige
          Landesbehörde.
        </p>
      </div>
    ),
  },
  {
    id: "loeschung",
    title: "9. Datenlöschung und Account-Löschung",
    content: (
      <p className="text-gray-700 text-sm leading-relaxed">
        Du kannst deinen Account und alle damit verbundenen Daten jederzeit
        löschen lassen, indem du uns per E-Mail kontaktierst. Daten werden
        gelöscht, sobald sie für den Zweck der Verarbeitung nicht mehr
        erforderlich sind und keine gesetzlichen Aufbewahrungspflichten
        entgegenstehen (z. B. steuerliche Aufbewahrungspflichten von 10
        Jahren für Rechnungsdaten).
      </p>
    ),
  },
  {
    id: "aenderungen",
    title: "10. Änderungen dieser Datenschutzerklärung",
    content: (
      <p className="text-gray-700 text-sm leading-relaxed">
        Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf anzupassen,
        um sie an geänderte rechtliche Anforderungen oder Änderungen unserer
        Dienste anzupassen. Die jeweils aktuelle Version ist stets auf dieser
        Seite abrufbar. Stand: {new Date().toLocaleDateString("de-DE", { month: "long", year: "numeric" })}.
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
            ← Zurück zur Startseite
          </Link>
        </div>
      </header>

      <main className="container mx-auto px-6 py-16 max-w-3xl">
        <h1 className="text-4xl font-bold text-gray-900 mb-2">
          Datenschutzerklärung
        </h1>
        <p className="text-gray-500 mb-12">
          Gemäß Art. 13, 14 DSGVO – zuletzt aktualisiert:{" "}
          {new Date().toLocaleDateString("de-DE", {
            day: "numeric",
            month: "long",
            year: "numeric",
          })}
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