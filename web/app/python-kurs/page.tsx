import type { Metadata } from "next";
import Link from "next/link";
import { kursCss } from "./_components/kursTheme";
import { lektionen } from "./_components/lektionen";

export const metadata: Metadata = {
  title: "Python lernen für Fachinformatiker – kostenloser Kurs im Browser",
  description:
    "Python von null lernen, direkt im Browser programmieren – ohne Installation. Kostenloser Kurs für angehende Fachinformatiker (Anwendungsentwicklung), von der ersten Zeile Code bis zum eigenen Spiel.",
  alternates: {
    canonical: "https://lernarena.app/python-kurs",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/python-kurs",
    siteName: "Lernarena",
    title: "Python lernen für Fachinformatiker – kostenloser Kurs im Browser",
    description:
      "Python von null lernen, direkt im Browser programmieren. Vom ersten print() bis zum eigenen Spiel.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    q: "Muss ich etwas installieren, um den Kurs zu machen?",
    a: "Nein. Der Code läuft direkt in deinem Browser (per WebAssembly). Erst beim großen Abschlussprojekt installierst du Python auf deinem eigenen Rechner, mit Schritt-für-Schritt-Anleitung.",
  },
  {
    q: "Ist der Kurs für komplette Anfänger geeignet?",
    a: "Ja. Der Kurs startet bei null, jede Lektion baut auf der vorherigen auf. Vorkenntnisse brauchst du keine, nur einen Browser.",
  },
  {
    q: "Warum Python und nicht Java oder Pseudocode?",
    a: "Python hat die einsteigerfreundlichste Syntax und du siehst am schnellsten Ergebnisse. Die Konzepte (Variablen, Schleifen, Funktionen, OOP) sind in jeder Sprache gleich und genau die werden in der IHK-Prüfung abgefragt. Die letzte Lektion schlägt die Brücke zum IHK-Pseudocode.",
  },
  {
    q: "Brauche ich den Kurs als Systemintegrator (FISI)?",
    a: "Schaden kann er nicht: Grundlegendes Programmierverständnis wird in der AP1 von allen verlangt, und Skripting hilft dir auch als Admin. Der Kurs richtet sich aber vor allem an angehende Anwendungsentwickler.",
  },
];

export default function PythonKursSeite() {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faq.map((f) => ({
      "@type": "Question",
      name: f.q,
      acceptedAnswer: { "@type": "Answer", text: f.a },
    })),
  };

  return (
    <main className="lp-wrap">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <style>{kursCss}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Python-Kurs
        </nav>

        <h1>Python lernen: vom ersten Befehl zum eigenen Spiel</h1>
        <p className="lp-lead">
          Der kostenlose Programmierkurs für angehende Anwendungsentwickler.
          Du schreibst echten Code direkt im Browser, ohne irgendetwas zu
          installieren. Am Ende baust du dein eigenes Spiel.
        </p>

        <div className="lp-cta-row">
          <Link href="/python-kurs/lektion-1" className="lp-btn lp-btn-primary">
            Mit Lektion 1 starten
          </Link>
          <Link href="/lernen" className="lp-btn lp-btn-ghost">Alle Lernthemen</Link>
        </div>

        <h2>Der Kursplan</h2>
        <p>
          Zwölf Lektionen, jede baut auf der vorherigen auf. Zwei davon sind
          Spiele-Projekte, bei denen du alles Gelernte zusammensetzt. Jede
          Lektion hat eine eigene Seite mit Erklärungen, ausführbarem Code und
          Übungen. Klick einfach auf eine verfügbare Lektion:
        </p>
        <div className="pk-lessons">
          {lektionen.map((l) =>
            l.status === "live" ? (
              <Link
                key={l.nr}
                href={`/python-kurs/${l.slug}`}
                className={`pk-lesson ${l.status}`}
              >
                <span className="nr">{String(l.nr).padStart(2, "0")}</span>
                {l.titel}
                <span className={`pk-badge ${l.status}`}>Verfügbar</span>
              </Link>
            ) : (
              <div key={l.nr} className={`pk-lesson ${l.status}`}>
                <span className="nr">{String(l.nr).padStart(2, "0")}</span>
                {l.titel}
                <span className={`pk-badge ${l.status}`}>Bald</span>
              </div>
            )
          )}
        </div>

        <h2>So funktioniert der Kurs</h2>
        <p>
          In jeder Lektion liest du kurze Erklärungen und führst den Code
          direkt darunter aus, in einem echten Python-Editor im Browser.
          Danach löst du kleine Übungen mit einklappbaren Musterlösungen. Die
          Konzepte sind genau die, die in der IHK-Abschlussprüfung (AP1) im
          Pseudocode abgefragt werden: Variablen, Bedingungen, Schleifen,
          Funktionen und Objektorientierung.
        </p>

        <h2>Häufige Fragen</h2>
        <div className="lp-faq">
          {faq.map((f) => (
            <details key={f.q}>
              <summary>{f.q}</summary>
              <p>{f.a}</p>
            </details>
          ))}
        </div>

        <div className="lp-final">
          <h2>Übe parallel für deine IHK-Prüfung</h2>
          <p>
            In der Lernarena-App warten Prüfungssimulationen mit KI-Korrektur,
            Karteikarten und Lernpfade für AP1 &amp; AP2 auf dich.
          </p>
          <div className="lp-cta-row" style={{ justifyContent: "center" }}>
            <Link href="/signup" className="lp-btn lp-btn-primary">
              Kostenlos starten
            </Link>
            <a
              href="https://play.google.com/store/apps/details?id=app.lernarena"
              target="_blank"
              rel="noopener noreferrer"
              className="lp-btn lp-btn-ghost"
            >
              Android-App laden
            </a>
          </div>
        </div>
      </div>
    </main>
  );
}
