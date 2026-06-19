import Link from "next/link";

export const metadata = {
  title: "Account löschen – Lernarena",
  description:
    "Fordere die Löschung deines Lernarena-Accounts und aller zugehörigen Daten an.",
};

const CONTACT_EMAIL = "info@lernarena.app";

const mailtoHref =
  `mailto:${CONTACT_EMAIL}` +
  `?subject=${encodeURIComponent("Account-Löschung")}` +
  `&body=${encodeURIComponent(
    "Bitte löscht meinen Lernarena-Account und alle zugehörigen Daten.\n\n" +
      "Meine registrierte E-Mail-Adresse: \n\n" +
      "(Bitte sende diese Anfrage von der E-Mail-Adresse, mit der dein Account registriert ist.)"
  )}`;

export default function AccountLoeschungPage() {
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
        <h1 className="text-4xl font-bold text-gray-900 mb-2">Account löschen</h1>
        <p className="text-gray-500 mb-12">
          Account- und Datenlöschung für Lernarena
        </p>

        <div className="space-y-6">
          {/* Intro */}
          <section className="bg-white rounded-2xl p-8 border border-gray-200">
            <p className="text-gray-700 text-sm leading-relaxed">
              Du kannst die vollständige Löschung deines Lernarena-Accounts und
              aller damit verbundenen persönlichen Daten beantragen. Sende dazu
              einfach eine E-Mail an uns – die Anleitung findest du unten.
            </p>
          </section>

          {/* Anleitung */}
          <section className="bg-white rounded-2xl p-8 border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              So beantragst du die Löschung
            </h2>
            <ol className="list-decimal list-inside text-gray-700 text-sm leading-relaxed space-y-2">
              <li>
                Schreibe eine E-Mail an{" "}
                <a
                  href={`mailto:${CONTACT_EMAIL}`}
                  className="text-blue-700 hover:underline"
                >
                  {CONTACT_EMAIL}
                </a>{" "}
                mit dem Betreff <strong>„Account-Löschung"</strong>.
              </li>
              <li>
                Sende die E-Mail{" "}
                <strong>
                  von der Adresse, mit der dein Account registriert ist
                </strong>
                . Das dient deiner Sicherheit, damit niemand anderes die
                Löschung in deinem Namen beantragen kann.
              </li>
              <li>Wir bestätigen den Eingang und löschen deinen Account.</li>
            </ol>

            <div className="mt-6">
              <a
                href={mailtoHref}
                className="inline-block bg-blue-700 hover:bg-blue-800 text-white font-semibold px-6 py-3 rounded-xl transition"
              >
                Löschung per E-Mail anfragen
              </a>
            </div>
          </section>

          {/* Welche Daten */}
          <section className="bg-white rounded-2xl p-8 border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Welche Daten werden gelöscht?
            </h2>
            <p className="text-gray-700 text-sm leading-relaxed mb-2">
              Mit der Löschung deines Accounts entfernen wir dauerhaft:
            </p>
            <ul className="list-disc list-inside text-gray-600 text-sm leading-relaxed space-y-1">
              <li>dein Profil (Benutzername, E-Mail, Avatar)</li>
              <li>deinen Lernfortschritt und deine Statistiken</li>
              <li>erworbene Zertifikate und Abzeichen</li>
              <li>deine Karteikarten und Wiederholungs-Daten</li>
              <li>deine Duell-/Arena-Daten und Bestenlisten-Einträge</li>
              <li>deinen Anmelde-Account selbst</li>
            </ul>
            <p className="text-gray-500 text-sm leading-relaxed mt-3">
              Nicht betroffen sind allgemeine App-Inhalte wie Fragen, Module und
              Lernmaterialien – diese sind nicht personenbezogen.
            </p>
          </section>

          {/* Bearbeitungszeit */}
          <section className="bg-white rounded-2xl p-8 border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Bearbeitungszeit
            </h2>
            <p className="text-gray-700 text-sm leading-relaxed">
              Wir bearbeiten deine Anfrage so schnell wie möglich, spätestens
              jedoch innerhalb von <strong>30 Tagen</strong>. Die Löschung ist
              endgültig und kann nicht rückgängig gemacht werden.
            </p>
          </section>
        </div>

        {/* Footer nav */}
        <div className="flex gap-6 text-sm text-gray-500 mt-12">
          <Link href="/agb" className="hover:text-blue-700 transition">
            AGB
          </Link>
          <Link href="/impressum" className="hover:text-blue-700 transition">
            Impressum
          </Link>
          <Link href="/datenschutz" className="hover:text-blue-700 transition">
            Datenschutzerklärung
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