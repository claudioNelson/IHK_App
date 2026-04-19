import Link from "next/link";

export const metadata = {
  title: "Impressum – Lernarena",
  description: "Impressum und Anbieterkennzeichnung gemäß § 5 TMG",
};

export default function ImpressumPage() {
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

      {/* Content */}
      <main className="container mx-auto px-6 py-16 max-w-3xl">
        <h1 className="text-4xl font-bold text-gray-900 mb-2">Impressum</h1>
        <p className="text-gray-500 mb-12">
          Angaben gemäß § 5 TMG (Telemediengesetz)
        </p>

        {/* Anbieter */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Anbieter
          </h2>
          <div className="text-gray-700 space-y-1">
            {/* ⚠️ PLATZHALTER – bitte nach Gewerbeanmeldung ausfüllen */}
            <p className="font-medium">[Vor- und Nachname]</p>
            <p>[Straße und Hausnummer]</p>
            <p>[PLZ] [Stadt]</p>
            <p>Deutschland</p>
          </div>
        </section>

        {/* Kontakt */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Kontakt</h2>
          <div className="text-gray-700 space-y-2">
            {/* ⚠️ PLATZHALTER – E-Mail-Adresse eintragen */}
            <p>
              <span className="text-gray-500 w-32 inline-block">E-Mail:</span>
              <a
                href="mailto:[E-MAIL@DOMAIN.DE]"
                className="text-blue-700 hover:underline"
              >
                [E-MAIL@DOMAIN.DE]
              </a>
            </p>
          </div>
        </section>

        {/* Steuer */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Steuerliche Angaben
          </h2>
          <div className="text-gray-700 space-y-2">
            {/*
              ⚠️ PLATZHALTER – nach Anmeldung beim Finanzamt ausfüllen.
              Wenn du (noch) keine USt-ID hast, nur Steuernummer angeben.
              Format Steuernummer: z.B. 12/345/67890 (je nach Bundesland unterschiedlich)
            */}
            <p>
              <span className="text-gray-500 w-48 inline-block">
                Steuernummer:
              </span>
              [STEUERNUMMER]
            </p>
            {/*
              Sobald du eine Umsatzsteuer-ID hast (kommt per Post vom Bundeszentralamt),
              die Zeile unten einkommentieren und befüllen:
            */}
            {/* <p>
              <span className="text-gray-500 w-48 inline-block">Umsatzsteuer-ID:</span>
              DE[NUMMER]
            </p> */}
          </div>
        </section>

        {/* Berufsbezeichnung */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Angaben zur Tätigkeit
          </h2>
          <div className="text-gray-700 space-y-2">
            <p>
              <span className="text-gray-500 w-48 inline-block">
                Tätigkeitsbereich:
              </span>
              Softwareentwicklung und digitale Bildungsangebote
            </p>
            <p>
              <span className="text-gray-500 w-48 inline-block">
                Unternehmensform:
              </span>
              Einzelunternehmen
            </p>
          </div>
        </section>

        {/* Haftung */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Haftungsausschluss
          </h2>
          <div className="text-gray-700 space-y-4 text-sm leading-relaxed">
            <div>
              <h3 className="font-semibold text-gray-800 mb-1">
                Haftung für Inhalte
              </h3>
              <p>
                Als Diensteanbieter sind wir gemäß § 7 Abs. 1 TMG für eigene
                Inhalte auf diesen Seiten nach den allgemeinen Gesetzen
                verantwortlich. Nach §§ 8 bis 10 TMG sind wir als
                Diensteanbieter jedoch nicht verpflichtet, übermittelte oder
                gespeicherte fremde Informationen zu überwachen oder nach
                Umständen zu forschen, die auf eine rechtswidrige Tätigkeit
                hinweisen.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-800 mb-1">
                Keine offizielle IHK-Zugehörigkeit
              </h3>
              <p>
                Lernarena ist ein unabhängiges, privates Lernangebot und steht
                in keiner offiziellen Verbindung zur IHK (Industrie- und
                Handelskammer) oder anderen Prüfungsbehörden. Alle
                Prüfungsfragen und Lerninhalte dienen ausschließlich der
                Prüfungsvorbereitung und erheben keinen Anspruch auf
                Vollständigkeit oder offizielle Gültigkeit.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-800 mb-1">
                Haftung für Links
              </h3>
              <p>
                Unser Angebot enthält Links zu externen Websites Dritter, auf
                deren Inhalte wir keinen Einfluss haben. Deshalb können wir für
                diese fremden Inhalte auch keine Gewähr übernehmen. Für die
                Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter
                oder Betreiber der Seiten verantwortlich.
              </p>
            </div>
          </div>
        </section>

        {/* Urheberrecht */}
        <section className="bg-white rounded-2xl p-8 border border-gray-200 mb-12">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Urheberrecht
          </h2>
          <p className="text-gray-700 text-sm leading-relaxed">
            Die durch den Seitenbetreiber erstellten Inhalte und Werke auf
            diesen Seiten unterliegen dem deutschen Urheberrecht. Die
            Vervielfältigung, Bearbeitung, Verbreitung und jede Art der
            Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der
            schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.
          </p>
        </section>

        {/* Footer navigation */}
        <div className="flex gap-6 text-sm text-gray-500">
          <Link href="/datenschutz" className="hover:text-blue-700 transition">
            Datenschutzerklärung
          </Link>
          <Link href="/agb" className="hover:text-blue-700 transition">
            AGB
          </Link>
          <Link href="/" className="hover:text-blue-700 transition">
            Startseite
          </Link>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-200 py-8 mt-8">
        <div className="container mx-auto px-6 text-center text-sm text-gray-400">
          © {new Date().getFullYear()} Lernarena. Alle Rechte vorbehalten.
        </div>
      </footer>
    </div>
  );
}