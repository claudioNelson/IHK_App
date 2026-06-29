import Link from "next/link";

export const metadata = {
  title: "AGB – Lernarena",
  description: "Allgemeine Geschäftsbedingungen von Lernarena",
};

// Festes Datum der letzten inhaltlichen Änderung.
// Bei jeder echten Überarbeitung der AGB manuell anpassen.
const STAND = "28. Juni 2026";

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
          <p className="font-medium">Claudio Medeiros Magalhaes</p>
          <p>Westfalenweg 3, 49504 Lotte</p>
          <p>
            E-Mail:{" "}
            <a
              href="mailto:info@lernarena.app"
              className="text-blue-700 hover:underline"
            >
              info@lernarena.app
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
    title: "4. Free-Tarif und Premium",
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
          <h3 className="font-semibold text-gray-800 mb-1">4.2 Premium</h3>
          <p>
            Premium bietet unbegrenzten Zugang zu allen Funktionen und ist in
            folgenden Varianten erhältlich:
          </p>
          <ul className="list-disc list-inside text-gray-600 space-y-1 mt-2">
            <li>Monatlich: 9,99 € / Monat</li>
            <li>Halbjährlich: 39,99 € / 6 Monate (entspricht ca. 6,67 € / Monat)</li>
            <li>Jährlich: 69,99 € / Jahr (entspricht ca. 5,83 € / Monat)</li>
          </ul>
          <p className="mt-2">
            Alle Preise sind Endpreise. Die Umsatzsteuer-Behandlung hängt vom
            Kaufweg ab:
          </p>
          <ul className="list-disc list-inside text-gray-600 space-y-1 mt-1">
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
          </ul>
          {/* ⚠️ HINWEIS: Sobald du die Kleinunternehmer-Grenze (§ 19 UStG)
              überschreitest, muss der Stripe-/Web-Teil angepasst und USt.
              ausgewiesen werden. */}
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            4.3 Laufzeit und Verlängerung
          </h3>
          <p>
            Alle Abonnements (monatlich, halbjährlich, jährlich) verlängern sich
            automatisch um die jeweilige Laufzeit, wenn sie nicht rechtzeitig vor
            Ablauf gekündigt werden (siehe Abschnitt 6).
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
        <p>Der Kaufweg richtet sich nach der genutzten Plattform:</p>
        <ul className="list-disc list-inside text-gray-600 space-y-1">
          <li>
            In der <strong>Android-App</strong> erfolgt die Abrechnung über
            Google Play Billing.
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
            Alle Abonnements können jederzeit zum Ende des laufenden
            Abrechnungszeitraums gekündigt werden. Der Kündigungsweg
            richtet sich nach dem Kaufkanal:
          </p>
          <ul className="list-disc list-inside text-gray-600 space-y-1 mt-1">
            <li>
              Über Google Play gekaufte Abonnements werden über die
              Abo-Einstellungen des Google-Play-Kontos gekündigt.
            </li>
            <li>
              Über die Web-App (Stripe) gekaufte Abonnements können jederzeit
              selbst über die Abo-Verwaltung im eigenen Konto („Abo verwalten")
              gekündigt werden. Die Kündigung wird zum Ende des laufenden
              Abrechnungszeitraums wirksam; der Zugang bleibt bis dahin bestehen.
            </li>
          </ul>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.2 Widerrufsrecht für Verbraucher
          </h3>
          <p>
            Verbraucher haben das Recht, einen Vertrag innerhalb von{" "}
            <strong>14 Tagen</strong> ohne Angabe von Gründen zu widerrufen.
            Die Einzelheiten ergeben sich aus der nachstehenden
            Widerrufsbelehrung (6.3).
          </p>
          <ul className="list-disc list-inside text-gray-600 space-y-1 mt-1">
            <li>
              Bei Kauf über die <strong>Web-App (Stripe)</strong> richtest du
              den Widerruf direkt an den Anbieter (siehe Widerrufsbelehrung).
            </li>
            <li>
              Bei Kauf über <strong>Google Play</strong> erfolgt die
              Rückabwicklung über den Erstattungsprozess von Google Play; dein
              gesetzliches Widerrufsrecht gegenüber dem Anbieter bleibt
              unberührt.
            </li>
          </ul>
          <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 mt-3">
            <p className="text-amber-800 font-semibold text-xs mb-1">
              Hinweis zum vorzeitigen Erlöschen des Widerrufsrechts
            </p>
            <p className="text-amber-700 text-xs">
              Bei digitalen Inhalten und sofort bereitgestellten digitalen
              Leistungen erlischt das Widerrufsrecht, wenn der Nutzer
              ausdrücklich zugestimmt hat, dass mit der Ausführung des Vertrags
              vor Ablauf der Widerrufsfrist begonnen wird, und bestätigt hat,
              dass er mit Beginn der Ausführung sein Widerrufsrecht verliert
              (§ 356 Abs. 5 BGB).
            </p>
          </div>
          {/* ⚠️ TECHNISCHE PFLICHT (Dev-Task, nicht nur Text):
              Das Erlöschen greift nur, wenn du beim Checkout die ausdrückliche
              Zustimmung + Kenntnisnahme aktiv abfragst (Checkbox) UND dem Nutzer
              danach eine Bestätigung auf dauerhaftem Datenträger (z. B. E-Mail)
              schickst (§ 312f BGB). Ohne diese Umsetzung erlischt das
              Widerrufsrecht NICHT.
              ⚠️ Außerdem: Die Belehrungsvariante (digitale Inhalte vs.
              Dienstleistung) sollte ein Anwalt für deinen konkreten Fall
              bestätigen – Lernarena ist ein laufender digitaler Dienst. */}
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.3 Widerrufsbelehrung
          </h3>
          <div className="border border-gray-200 rounded-lg p-4 space-y-3 text-gray-700">
            <p className="font-semibold">Widerrufsrecht</p>
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
            <p className="font-semibold">Folgen des Widerrufs</p>
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
          </div>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.4 Muster-Widerrufsformular
          </h3>
          <div className="border border-gray-200 rounded-lg p-4 space-y-2 text-gray-700">
            <p className="italic text-gray-500">
              (Wenn Sie den Vertrag widerrufen wollen, dann füllen Sie bitte
              dieses Formular aus und senden Sie es zurück.)
            </p>
            <ul className="space-y-1">
              <li>
                – An Claudio Medeiros Magalhaes, Westfalenweg 3, 49504 Lotte,
                E-Mail: info@lernarena.app:
              </li>
              <li>
                – Hiermit widerrufe(n) ich/wir (*) den von mir/uns (*)
                abgeschlossenen Vertrag über die Erbringung der folgenden
                Dienstleistung (*)
              </li>
              <li>– Bestellt am (*)</li>
              <li>– Name des/der Verbraucher(s)</li>
              <li>– Anschrift des/der Verbraucher(s)</li>
              <li>
                – Unterschrift des/der Verbraucher(s) (nur bei Mitteilung auf
                Papier)
              </li>
              <li>– Datum</li>
            </ul>
            <p className="text-gray-500 text-xs">
              (*) Unzutreffendes streichen.
            </p>
          </div>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            6.5 Kontolöschung
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
      <div className="text-gray-700 text-sm leading-relaxed space-y-4">
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            9.1 Geringfügige Änderungen
          </h3>
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
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            9.2 Wesentliche Änderungen
          </h3>
          <p>
            Wesentliche Änderungen – insbesondere Änderungen der Preise, des
            Leistungsumfangs oder sonstiger vertraglicher Hauptpflichten –
            bedürfen der ausdrücklichen Zustimmung des Nutzers. Bloßes Schweigen
            gilt insoweit nicht als Zustimmung. Ohne ausdrückliche Zustimmung
            gilt der Vertrag zu den bisherigen Bedingungen fort; der Anbieter
            kann den Vertrag in diesem Fall zum nächsten zulässigen Zeitpunkt
            kündigen.
          </p>
        </div>
        <div>
          <h3 className="font-semibold text-gray-800 mb-1">
            9.3 Bereits bezahlte Leistungen
          </h3>
          <p>
            Bereits abgeschlossene und vollständig bezahlte Leistungen bleiben
            von Preisänderungen unberührt.
          </p>
        </div>
      </div>
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
        <p>Stand: {STAND}</p>
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
        <p className="text-gray-500 mb-12">Zuletzt aktualisiert: {STAND}</p>

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