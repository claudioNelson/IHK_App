import Link from "next/link";

export const metadata = {
  title: "AGB – Lernarena",
  description: "Allgemeine Geschäftsbedingungen von Lernarena",
};

const sections = [
  {
    id: "geltungsbereich",
    title: "1. Geltungsbereich",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Diese Allgemeinen Geschäftsbedingungen (AGB) gelten für alle
          Verträge zwischen
        </p>
        <div className="bg-gray-50 rounded-lg p-4 border border-gray-200 space-y-1">
          {/* ⚠️ PLATZHALTER – nach Gewerbeanmeldung ausfüllen */}
          <p className="font-medium">[Vor- und Nachname]</p>
          <p>[Straße und Hausnummer], [PLZ] [Stadt]</p>
          <p>
            E-Mail:{" "}
            <a href="mailto:[E-MAIL]" className="text-blue-700 hover:underline">
              [E-MAIL@DOMAIN.DE]
            </a>
          </p>
          <p className="text-gray-500 text-xs pt-1">(nachfolgend „Anbieter")</p>
        </div>
        <p>
          und den Nutzern der mobilen App sowie der Web-App „Lernarena"
          (nachfolgend „Nutzer"). Abweichende Bedingungen des Nutzers werden
          nicht anerkannt, es sei denn, der Anbieter stimmt diesen ausdrücklich
          schriftlich zu.
        </p>
      </div>
    ),
  },
  {
    id: "leistungen",
    title: "2. Leistungsbeschreibung",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Lernarena ist eine digitale Lernplattform, die IT-Auszubildende
          (insbesondere Fachinformatiker) bei der Vorbereitung auf die IHK-Prüfung
          unterstützt. Die Plattform bietet:
        </p>
        <ul className="list-disc list-inside text-gray-600 space-y-1">
          <li>Modulbasiertes Lernen mit Prüfungsfragen</li>
          <li>Lernkarten (Flashcards) und Wiederholungssystem</li>
          <li>Asynchrone Multiplayer-Quiz-Matches (AsyncMatch)</li>
          <li>KI-gestützter Tutor „Ada"</li>
          <li>Prüfungssimulation (Premium)</li>
          <li>Zertifizierungsvorbereitung (AWS, Azure, GCP, SAP)</li>
        </ul>
        <p className="mt-2 text-gray-500 italic">
          Lernarena steht in keiner offiziellen Verbindung zur IHK oder anderen
          Prüfungsbehörden. Die Inhalte dienen ausschließlich der
          Prüfungsvorbereitung und erheben keinen Anspruch auf Vollständigkeit
          oder Aktualität im Sinne offizieller Prüfungsunterlagen.
        </p>
      </div>
    ),
  },
  {
    id: "registrierung",
    title: "3. Registrierung und Nutzerkonto",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Die Nutzung von Lernarena erfordert die Erstellung eines Nutzerkontos
          mit einer gültigen E-Mail-Adresse. Der Nutzer ist verpflichtet,
          wahrheitsgemäße Angaben zu machen und seine Zugangsdaten geheim zu
          halten.
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
      </div>
    ),
  },
  {
    id: "free-premium",
    title: "4. Free-Tarif und Premium-Abonnement",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-4">
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">4.1 Free-Tarif</h3>
          <p>
            Der Free-Tarif ist kostenlos und beinhaltet einen eingeschränkten
            Zugang zu den Lernfunktionen. Der Anbieter behält sich vor, den
            Umfang des kostenlosen Angebots jederzeit anzupassen.
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            4.2 Premium-Abonnement
          </h3>
          <p>
            Das Premium-Abonnement bietet unbegrenzten Zugang zu allen
            Funktionen. Es wird als Monats- oder Jahresabonnement angeboten:
          </p>
          <ul className="list-disc list-inside text-gray-600 space-y-1 mt-2">
            <li>Monatlich: 9,99 € / Monat</li>
            <li>Jährlich: 89,00 € / Jahr (entspricht ca. 7,42 € / Monat)</li>
          </ul>
          <p className="mt-2">
            Alle Preise sind Endpreise. Als Kleinunternehmer im Sinne von § 19
            UStG wird keine Umsatzsteuer berechnet.{" "}
            {/* ⚠️ HINWEIS: Sobald du umsatzsteuerpflichtig wirst (Umsatz > 22.000 €/Jahr),
                muss dieser Satz angepasst und USt. ausgewiesen werden. */}
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            4.3 Abonnementlaufzeit und Verlängerung
          </h3>
          <p>
            Das Abonnement verlängert sich automatisch um die jeweilige
            Laufzeit, wenn es nicht rechtzeitig vor Ablauf gekündigt wird (siehe
            Abschnitt 6).
          </p>
        </div>
      </div>
    ),
  },
  {
    id: "zahlung",
    title: "5. Zahlung",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Die Abrechnung des Premium-Abonnements erfolgt über den jeweiligen
          App Store (Apple App Store oder Google Play Store) bzw. über den auf
          der Web-App angebotenen Zahlungsdienstleister. Es gelten die
          Zahlungsbedingungen des jeweiligen Anbieters.
        </p>
        <p>
          Die Zahlung ist im Voraus fällig. Bei fehlgeschlagener Zahlung behält
          sich der Anbieter vor, den Zugang zu Premium-Funktionen zu
          unterbrechen.
        </p>
      </div>
    ),
  },
  {
    id: "kuendigung",
    title: "6. Kündigung und Widerrufsrecht",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-4">
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">6.1 Kündigung</h3>
          <p>
            Das Premium-Abonnement kann jederzeit zum Ende des laufenden
            Abrechnungszeitraums gekündigt werden. Die Kündigung erfolgt über
            die Einstellungen des jeweiligen App Stores oder per E-Mail an den
            Anbieter.
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.2 Widerrufsrecht für Verbraucher
          </h3>
          <p>
            Verbraucher haben das Recht, einen Vertrag innerhalb von{" "}
            <strong>14 Tagen</strong> ohne Angabe von Gründen zu widerrufen.
            Die Widerrufsfrist beginnt mit dem Tag des Vertragsabschlusses.
          </p>
          <p className="mt-2">
            Widerruf per E-Mail an:{" "}
            <a href="mailto:[E-MAIL]" className="text-blue-700 hover:underline">
              {/* ⚠️ PLATZHALTER */}
              [E-MAIL@DOMAIN.DE]
            </a>
          </p>
          <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 mt-3">
            <p className="text-amber-800 font-semibold text-xs mb-1">
              Hinweis zum Erlöschen des Widerrufsrechts
            </p>
            <p className="text-amber-700 text-xs">
              Das Widerrufsrecht erlischt vorzeitig, wenn der Nutzer
              ausdrücklich zugestimmt hat, dass mit der Ausführung des Vertrags
              vor Ablauf der Widerrufsfrist begonnen wird, und bestätigt hat,
              dass er von seinem Widerrufsrecht Kenntnis genommen hat (§ 356
              Abs. 5 BGB).
            </p>
          </div>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.3 Kontolöschung
          </h3>
          <p>
            Der Nutzer kann sein Konto jederzeit durch eine E-Mail an den
            Anbieter löschen lassen. Mit der Löschung endet der Zugang zu allen
            gespeicherten Daten und Fortschritten.
          </p>
        </div>
      </div>
    ),
  },
  {
    id: "nutzungsregeln",
    title: "7. Nutzungsregeln und Pflichten",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>Der Nutzer verpflichtet sich, die Plattform nicht zu missbrauchen. Insbesondere ist es untersagt:</p>
        <ul className="list-disc list-inside text-gray-600 space-y-1">
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
      </div>
    ),
  },
  {
    id: "haftung",
    title: "8. Haftungsbeschränkung",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
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
      </div>
    ),
  },
  {
    id: "aenderungen",
    title: "9. Änderungen der AGB",
    content: (
      <p className="text-gray-700 text-sm leading-relaxed">
        Der Anbieter behält sich vor, diese AGB mit einer Ankündigungsfrist von
        mindestens 4 Wochen zu ändern. Nutzer werden per E-Mail oder
        In-App-Benachrichtigung informiert. Widerspricht der Nutzer nicht
        innerhalb der Frist, gelten die neuen AGB als akzeptiert. Im
        Widerspruchsfall hat der Nutzer das Recht, das Abonnement fristlos zu
        kündigen.
      </p>
    ),
  },
  {
    id: "schlussbestimmungen",
    title: "10. Schlussbestimmungen",
    content: (
      <div className="text-gray-700 text-sm leading-relaxed space-y-2">
        <p>
          Es gilt das Recht der Bundesrepublik Deutschland unter Ausschluss des
          UN-Kaufrechts. Für Verbraucher innerhalb der EU bleiben zwingende
          Verbraucherschutzvorschriften des jeweiligen Wohnsitzlandes
          unberührt.
        </p>
        <p>
          Sollten einzelne Bestimmungen dieser AGB unwirksam sein, bleibt die
          Wirksamkeit der übrigen Bestimmungen davon unberührt.
        </p>
        <p>
          Stand:{" "}
          {new Date().toLocaleDateString("de-DE", {
            day: "numeric",
            month: "long",
            year: "numeric",
          })}
        </p>
      </div>
    ),
  },
];

export default function AGBPage() {
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
          Allgemeine Geschäftsbedingungen
        </h1>
        <p className="text-gray-500 mb-12">
          Zuletzt aktualisiert:{" "}
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