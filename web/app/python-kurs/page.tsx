import type { Metadata } from "next";
import Link from "next/link";
import PythonRunner from "./_components/PythonRunner";

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

const lektionen: { nr: number; titel: string; status: "live" | "bald" }[] = [
  { nr: 1, titel: "Start & erster Code", status: "live" },
  { nr: 2, titel: "Variablen & Datentypen", status: "live" },
  { nr: 3, titel: "Rechnen & Strings", status: "live" },
  { nr: 4, titel: "Entscheidungen (if/else)", status: "live" },
  { nr: 5, titel: "Schleifen", status: "live" },
  { nr: 6, titel: "🎮 Projekt: Zahlenraten", status: "bald" },
  { nr: 7, titel: "Listen & Dictionaries", status: "bald" },
  { nr: 8, titel: "Funktionen", status: "bald" },
  { nr: 9, titel: "Fehler & Debugging", status: "bald" },
  { nr: 10, titel: "Klassen-Basics (OOP)", status: "bald" },
  { nr: 11, titel: "🎮 Projekt: Snake", status: "bald" },
  { nr: 12, titel: "Abschluss & IHK-Pseudocode", status: "bald" },
];

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

      <style>{`
        .lp-wrap {
          --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
          --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.14);
          --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
          --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
          --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
          --input-bg: rgba(255,255,255,0.05); --input-border: rgba(255,255,255,0.15);
          --pre-bg: rgba(0,0,0,0.35);
          --ok: #5FD98A; --ok-bg: rgba(52,199,89,0.16); --ok-border: rgba(52,199,89,0.6); --ok-text: #B8F0C4;
          --err: #FF6B63; --err-bg: rgba(255,69,58,0.16); --err-border: rgba(255,69,58,0.6); --err-text: #FFC1BC;
          --warn-bg: rgba(255,159,10,0.14); --warn-border: rgba(255,159,10,0.55); --warn-text: #FFD79A;
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: var(--bg);
          color: var(--text);
          min-height: 100vh;
          line-height: 1.65;
        }
        html[data-theme="light"] .lp-wrap {
          --bg: #FAFAF9; --bg-muted: #F4F4F1; --surface: #FFFFFF; --surface-2: #FFFFFF;
          --border: rgba(10,10,15,0.10); --border-strong: rgba(10,10,15,0.18);
          --text: #0A0A0F; --text-body: #3A3A44; --text-dim: #6A6A74;
          --accent: #6A5AE8; --accent-soft: rgba(106,90,232,0.10); --accent-text: #5B4BE0;
          --chip-bg: rgba(10,10,15,0.04); --chip-border: rgba(10,10,15,0.12);
          --input-bg: #FFFFFF; --input-border: rgba(10,10,15,0.18);
          --pre-bg: rgba(10,10,15,0.05);
          --ok: #1E9E50; --ok-bg: rgba(30,158,80,0.10); --ok-border: rgba(30,158,80,0.45); --ok-text: #14713A;
          --err: #D93B33; --err-bg: rgba(217,59,51,0.08); --err-border: rgba(217,59,51,0.45); --err-text: #A32620;
          --warn-bg: rgba(180,120,0,0.10); --warn-border: rgba(180,120,0,0.45); --warn-text: #8A5A00;
        }
        .lp-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
        .lp-crumb { font-size: 14px; color: var(--accent); margin-bottom: 24px; }
        .lp-crumb a { color: var(--accent); text-decoration: none; }
        .lp-crumb a:hover { text-decoration: underline; }
        .lp-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .lp-lead { font-size: 19px; color: var(--text-dim); margin: 0 0 32px; }
        .lp-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 48px 0 16px; font-weight: 650; }
        .lp-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
        .lp-wrap p { color: var(--text-body); margin: 0 0 16px; }
        .lp-wrap strong { color: var(--text); }
        .lp-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .lp-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
        }
        .lp-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .lp-btn-primary:hover { transform: translateY(-2px); }
        .lp-btn-ghost { background: var(--chip-bg); color: var(--text); border: 1px solid var(--chip-border); }
        .lp-btn-ghost:hover { background: var(--accent-soft); }
        .lp-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .lp-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: var(--accent-soft); color: var(--accent-text);
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .lp-tip {
          background: var(--surface); border: 1px solid var(--border);
          border-left: 3px solid var(--accent);
          border-radius: 12px; padding: 16px 20px; margin: 26px 0;
        }
        .lp-tip p { margin: 0; color: var(--text-body); }
        .lp-tip strong { color: var(--text); }
        .lp-faq { margin: 8px 0; }
        .lp-faq details { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 2px 22px; margin: 10px 0; transition: border-color .15s ease; }
        .lp-faq details[open] { border-color: var(--border-strong); }
        .lp-faq summary { cursor: pointer; font-weight: 600; color: var(--text); padding: 16px 0; list-style: none; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
        .lp-faq summary::-webkit-details-marker { display: none; }
        .lp-faq summary::after { content: "+"; color: var(--accent); font-size: 22px; font-weight: 400; line-height: 1; }
        .lp-faq details[open] summary::after { content: "−"; }
        .lp-faq details p { padding: 0 0 16px; margin: 0; color: var(--text-body); }
        .lp-final {
          text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted));
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lp-final h2 { margin-top: 0; }

        /* Kurs-spezifisch */
        .pk-lessons { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 18px 0; }
        @media (max-width: 560px) { .pk-lessons { grid-template-columns: 1fr; } }
        .pk-lesson {
          display: flex; align-items: center; gap: 12px;
          background: var(--surface); border: 1px solid var(--border);
          border-radius: 12px; padding: 12px 16px; font-size: 15px; color: var(--text-body);
        }
        .pk-lesson .nr {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          color: var(--accent-text); font-weight: 600; font-size: 13px; min-width: 22px;
        }
        .pk-lesson.live { border-color: rgba(124,109,255,0.4); }
        .pk-badge {
          margin-left: auto; font-size: 11px; letter-spacing: 0.06em; text-transform: uppercase;
          padding: 3px 9px; border-radius: 99px; white-space: nowrap;
        }
        .pk-badge.live { background: var(--ok-bg); color: var(--ok); border: 1px solid var(--ok-border); }
        .pk-badge.bald { background: var(--chip-bg); color: var(--text-dim); border: 1px solid var(--chip-border); }
        .pk-aufgabe {
          background: var(--chip-bg); border: 1px solid var(--chip-border);
          border-radius: 12px; padding: 14px 20px; margin: 30px 0 6px;
        }
        .pk-aufgabe p { margin: 0; color: var(--text-body); }
        .pk-aufgabe strong { color: var(--text); }
        .lp-wrap h2 { margin-top: 64px; }
        .pk-divider { border: none; border-top: 1px solid var(--border); margin: 56px 0 0; }
        .pk-loesung { margin: 10px 0 18px; }
        .pk-loesung summary { cursor: pointer; color: var(--accent-text); font-size: 14.5px; font-weight: 600; list-style: none; }
        .pk-loesung summary::-webkit-details-marker { display: none; }
        .pk-loesung pre {
          background: var(--pre-bg); border: 1px solid var(--border); border-radius: 10px;
          padding: 12px 16px; margin: 10px 0 0; overflow-x: auto;
          font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 14px;
          color: var(--text-body); line-height: 1.6;
        }
      `}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Python-Kurs
        </nav>

        <h1>Python lernen: vom ersten Befehl zum eigenen Spiel</h1>
        <p className="lp-lead">
          Der kostenlose Programmierkurs für angehende Anwendungsentwickler.
          Du schreibst echten Code direkt hier im Browser, ohne irgendetwas zu
          installieren. Am Ende baust du dein eigenes Spiel.
        </p>

        <div className="lp-cta-row">
          <a href="#lektion-1" className="lp-btn lp-btn-primary">Sofort loslegen</a>
          <Link href="/lernen" className="lp-btn lp-btn-ghost">Alle Lernthemen</Link>
        </div>

        <h2>Der Kursplan</h2>
        <p>
          Zwölf Lektionen, jede baut auf der vorherigen auf. Zwei davon sind
          Spiele-Projekte, bei denen du alles Gelernte zusammensetzt. Wir
          veröffentlichen die Lektionen nach und nach:
        </p>
        <div className="pk-lessons">
          {lektionen.map((l) => (
            <div key={l.nr} className={`pk-lesson ${l.status}`}>
              <span className="nr">{String(l.nr).padStart(2, "0")}</span>
              {l.titel}
              <span className={`pk-badge ${l.status}`}>
                {l.status === "live" ? "Verfügbar" : "Bald"}
              </span>
            </div>
          ))}
        </div>

        {/* ─── LEKTION 1 ─────────────────────────────────── */}
        <hr className="pk-divider" />
        <h2 id="lektion-1">Lektion 1: Start &amp; erster Code</h2>
        <p>
          Programmieren heißt: dem Computer <strong>präzise Anweisungen</strong>{" "}
          geben. Nicht mehr, nicht weniger. Der Computer macht exakt das, was du
          schreibst, und zwar Zeile für Zeile von oben nach unten. Der wichtigste
          Befehl am Anfang ist <span className="lp-mono">print()</span>: Er gibt
          etwas auf dem Bildschirm aus.
        </p>
        <p>
          Hier ist dein erster Python-Code. Klick auf{" "}
          <strong>▶ Ausführen</strong> und schau, was passiert:
        </p>

        <PythonRunner
          rows={4}
          initialCode={`print("Hallo Welt!")
print("Ich lerne programmieren.")
print(3 + 4)`}
        />

        <p>
          Drei Dinge sind hier passiert: Text in Anführungszeichen (ein{" "}
          <strong>String</strong>) wird wörtlich ausgegeben. Jede{" "}
          <span className="lp-mono">print()</span>-Zeile erzeugt eine eigene
          Ausgabezeile. Und <span className="lp-mono">3 + 4</span> ohne
          Anführungszeichen wird <strong>berechnet</strong>, deshalb steht da 7
          und nicht &quot;3 + 4&quot;.
        </p>

        <div className="lp-tip">
          <p>
            <strong>Probier es kaputt!</strong> Ändere den Code oben: Lass mal
            die Anführungszeichen weg, schreib eine eigene Rechnung, tipp dich
            absichtlich. Fehlermeldungen sind keine Katastrophe, sondern dein
            wichtigstes Werkzeug. Jeder Profi liest täglich welche.
          </p>
        </div>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 1.1:</strong> Gib deinen Namen und dein Ausbildungsjahr
            in zwei getrennten Zeilen aus.
          </p>
        </div>
        <PythonRunner
          rows={3}
          initialCode={`# Schreib deinen Code unter diese Zeile:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`print("Max Mustermann")
print("1. Ausbildungsjahr")`}</pre>
        </details>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 1.2:</strong> Was gibt{" "}
            <span className="lp-mono">print(&quot;5&quot; )</span> aus und was{" "}
            <span className="lp-mono">print(5 + 5)</span>? Überleg zuerst, dann
            führ es aus und prüf dich selbst.
          </p>
        </div>
        <PythonRunner
          rows={3}
          initialCode={`print("5" )
print(5 + 5)`}
        />
        <details className="pk-loesung">
          <summary>Erklärung anzeigen</summary>
          <pre>{`"5" ist ein String (Text) und wird wörtlich ausgegeben: 5
5 + 5 sind Zahlen und werden berechnet: 10
Der Unterschied zwischen Text und Zahl wird in Lektion 2 wichtig!`}</pre>
        </details>

        {/* ─── LEKTION 2 ─────────────────────────────────── */}
        <hr className="pk-divider" />
        <h2 id="lektion-2">Lektion 2: Variablen &amp; Datentypen</h2>
        <p>
          Eine <strong>Variable</strong> ist ein beschrifteter Karton: Du legst
          einen Wert hinein und kannst ihn später über den Namen wiederfinden.
          In Python brauchst du dafür nur ein Gleichheitszeichen:
        </p>

        <PythonRunner
          rows={6}
          initialCode={`name = "Alex"
alter = 21
groesse = 1.78

print(name)
print(alter)
print(groesse)`}
        />

        <p>
          Damit hast du schon drei der wichtigsten <strong>Datentypen</strong>{" "}
          benutzt, und die sind übrigens auch AP1-Prüfungsstoff:
        </p>
        <p>
          <span className="lp-mono">str</span> (String) ist Text in
          Anführungszeichen. <span className="lp-mono">int</span> (Integer) ist
          eine ganze Zahl. <span className="lp-mono">float</span> ist eine
          Kommazahl, die im Code mit <strong>Punkt</strong> geschrieben wird
          (1.78, nicht 1,78). Und <span className="lp-mono">bool</span> kennt nur{" "}
          <span className="lp-mono">True</span> oder{" "}
          <span className="lp-mono">False</span>. Mit{" "}
          <span className="lp-mono">type()</span> fragst du Python, welcher Typ
          in einer Variable steckt:
        </p>

        <PythonRunner
          rows={5}
          initialCode={`bestanden = True

print(type("Hallo"))
print(type(42))
print(type(1.78))
print(type(bestanden))`}
        />

        <p>
          Richtig praktisch werden Variablen mit{" "}
          <span className="lp-mono">input()</span>: Damit fragst du den Nutzer
          etwas und speicherst die Antwort. Führ das mal aus, dein Browser
          fragt dich dann nach deinem Namen:
        </p>

        <PythonRunner
          rows={3}
          initialCode={`name = input("Wie heißt du? ")
print("Hallo " + name + "!")`}
        />

        <div className="lp-tip">
          <p>
            <strong>Merksatz für die Prüfung:</strong>{" "}
            <span className="lp-mono">input()</span> liefert <strong>immer</strong>{" "}
            einen String, auch wenn jemand &quot;21&quot; eintippt. Zum Rechnen
            musst du erst mit <span className="lp-mono">int(...)</span>{" "}
            umwandeln. Dieser Stolperstein ist ein Klassiker, auch im
            IHK-Pseudocode gibt es dafür Typumwandlungen.
          </p>
        </div>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 2.1:</strong> Frag den Nutzer nach seinem Geburtsjahr
            und gib aus, wie alt er dieses Jahr wird. Tipp: Du brauchst{" "}
            <span className="lp-mono">int(input(...))</span> und{" "}
            <span className="lp-mono">2026 - jahr</span>.
          </p>
        </div>
        <PythonRunner
          rows={4}
          initialCode={`# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`jahr = int(input("Dein Geburtsjahr? "))
alter = 2026 - jahr
print("Du wirst dieses Jahr", alter)`}</pre>
        </details>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 2.2:</strong> Im Code unten steckt ein Fehler. Führ ihn
            aus, lies die Fehlermeldung in Ruhe und repariere ihn.
          </p>
        </div>
        <PythonRunner
          rows={3}
          initialCode={`alter = input("Wie alt bist du? ")
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`alter = int(input("Wie alt bist du? "))
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)

# Der Fehler: input() liefert einen String, und
# "21" + 1 kann Python nicht rechnen (TypeError).
# int(...) macht aus dem Text eine Zahl.`}</pre>
        </details>

        {/* ─── LEKTION 3 ─────────────────────────────────── */}
        <hr className="pk-divider" />
        <h2 id="lektion-3">Lektion 3: Rechnen &amp; Strings</h2>
        <p>
          Python ist ein vollwertiger Taschenrechner. Neben{" "}
          <span className="lp-mono">+</span>, <span className="lp-mono">-</span>,{" "}
          <span className="lp-mono">*</span> und{" "}
          <span className="lp-mono">/</span> gibt es drei Operatoren, die du noch
          nicht aus der Schule kennst, die aber in der Praxis (und in
          Prüfungsaufgaben) dauernd vorkommen:
        </p>

        <PythonRunner
          rows={7}
          initialCode={`print(17 / 5)    # normale Division -> 3.4
print(17 // 5)   # Ganzzahl-Division -> 3 (Rest wird abgeschnitten)
print(17 % 5)    # Modulo -> 2 (nur der Rest!)
print(2 ** 10)   # Potenz -> 1024

# Klassiker: Ist eine Zahl gerade?
print(8 % 2)     # 0 bedeutet: glatt teilbar, also gerade`}
        />

        <p>
          Besonders <span className="lp-mono">%</span> (Modulo) solltest du dir
          merken: &quot;Rest bei der Division&quot;. Damit prüfst du, ob eine
          Zahl gerade ist, ob ein Jahr ein Schaltjahr ist oder wie viele Minuten
          in einer Sekundenzahl stecken. Das taucht in fast jeder
          Programmier-Prüfungsaufgabe irgendwo auf.
        </p>

        <h3>Schöne Ausgaben mit f-Strings</h3>
        <p>
          Bisher hast du Ausgaben mit <span className="lp-mono">+</span> oder
          Kommas zusammengebaut. Es geht eleganter: Ein{" "}
          <strong>f-String</strong> ist ein String mit einem{" "}
          <span className="lp-mono">f</span> davor, in den du Variablen direkt in
          geschweiften Klammern einsetzt:
        </p>

        <PythonRunner
          rows={6}
          initialCode={`name = "Alex"
punkte = 87

print(f"{name} hat {punkte} von 100 Punkten.")
print(f"Das sind {punkte / 100} Prozent als Dezimalzahl.")
print(f"In 3 Jahren: {punkte + 3} Punkte (Quatsch, aber es rechnet!)")`}
        />

        <p>
          Strings können noch mehr. Mit{" "}
          <span className="lp-mono">len()</span> misst du die Länge, mit{" "}
          <span className="lp-mono">.upper()</span> und{" "}
          <span className="lp-mono">.lower()</span> änderst du die
          Schreibweise:
        </p>

        <PythonRunner
          rows={5}
          initialCode={`wort = "Fachinformatiker"

print(len(wort))
print(wort.upper())
print(wort.lower())`}
        />

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 3.1:</strong> Ein Netto-Preis von 250 Euro soll mit 19
            Prozent Mehrwertsteuer ausgegeben werden. Berechne den Brutto-Preis
            und gib ihn mit einem f-String aus, z. B. &quot;Brutto: 297.5
            Euro&quot;.
          </p>
        </div>
        <PythonRunner
          rows={4}
          initialCode={`netto = 250
# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`netto = 250
brutto = netto * 1.19
print(f"Brutto: {brutto} Euro")`}</pre>
        </details>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 3.2:</strong> Wandle 347 Sekunden in Minuten und
            Sekunden um (Ergebnis: 5 Minuten, 47 Sekunden). Tipp: Ganzzahl-Division{" "}
            <span className="lp-mono">//</span> für die Minuten, Modulo{" "}
            <span className="lp-mono">%</span> für den Rest.
          </p>
        </div>
        <PythonRunner
          rows={5}
          initialCode={`sekunden = 347
# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`sekunden = 347
minuten = sekunden // 60
rest = sekunden % 60
print(f"{minuten} Minuten, {rest} Sekunden")`}</pre>
        </details>

        {/* ─── LEKTION 4 ─────────────────────────────────── */}
        <hr className="pk-divider" />
        <h2 id="lektion-4">Lektion 4: Entscheidungen (if/else)</h2>
        <p>
          Bis jetzt läuft dein Code stur von oben nach unten. Mit{" "}
          <span className="lp-mono">if</span> bekommt er Verzweigungen:
          &quot;WENN das gilt, DANN tu dies, SONST das.&quot; Genau so steht es
          später auch im IHK-Pseudocode.
        </p>

        <PythonRunner
          rows={7}
          initialCode={`alter = 17

if alter >= 18:
    print("Du bist volljährig.")
else:
    print("Du bist minderjährig.")

print("Diese Zeile kommt immer.")`}
        />

        <p>
          Zwei Dinge sind hier entscheidend. Erstens die{" "}
          <strong>Einrückung</strong>: Alles, was um vier Leerzeichen eingerückt
          ist, gehört zum if-Block. Python erzwingt das, andere Sprachen nutzen
          dafür geschweifte Klammern. Zweitens der{" "}
          <strong>Vergleichsoperator</strong>{" "}
          <span className="lp-mono">&gt;=</span>. Davon gibt es sechs:{" "}
          <span className="lp-mono">==</span> (gleich, mit ZWEI
          Gleichheitszeichen!), <span className="lp-mono">!=</span> (ungleich),{" "}
          <span className="lp-mono">&lt;</span>, <span className="lp-mono">&gt;</span>,{" "}
          <span className="lp-mono">&lt;=</span> und{" "}
          <span className="lp-mono">&gt;=</span>.
        </p>

        <div className="lp-tip">
          <p>
            <strong>Der häufigste Anfängerfehler:</strong>{" "}
            <span className="lp-mono">=</span> speichert einen Wert,{" "}
            <span className="lp-mono">==</span> vergleicht zwei Werte. Wenn du
            in einer Bedingung nur ein Gleichheitszeichen schreibst, meckert
            Python sofort.
          </p>
        </div>

        <p>
          Mit <span className="lp-mono">elif</span> (&quot;else if&quot;) prüfst
          du mehrere Fälle nacheinander. Perfektes Beispiel: der echte
          IHK-Notenschlüssel. Python geht die Bedingungen von oben nach unten
          durch und nimmt die <strong>erste</strong>, die zutrifft:
        </p>

        <PythonRunner
          rows={12}
          initialCode={`punkte = 74

if punkte >= 92:
    print("Note 1, sehr gut!")
elif punkte >= 81:
    print("Note 2, gut")
elif punkte >= 67:
    print("Note 3, befriedigend")
elif punkte >= 50:
    print("Note 4, bestanden")
else:
    print("Leider durchgefallen")`}
        />

        <p>
          Bedingungen lassen sich mit <span className="lp-mono">and</span> und{" "}
          <span className="lp-mono">or</span> kombinieren, und mit{" "}
          <span className="lp-mono">not</span> umdrehen:
        </p>

        <PythonRunner
          rows={6}
          initialCode={`alter = 22
azubi = True

if alter < 25 and azubi:
    print("Du bekommst den Azubi-Rabatt!")`}
        />

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 4.1:</strong> Frag den Nutzer nach einer Zahl und gib
            aus, ob sie gerade oder ungerade ist. Tipp: Lektion 3, Modulo.
          </p>
        </div>
        <PythonRunner
          rows={6}
          initialCode={`zahl = int(input("Eine Zahl: "))
# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`zahl = int(input("Eine Zahl: "))
if zahl % 2 == 0:
    print("gerade")
else:
    print("ungerade")`}</pre>
        </details>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 4.2:</strong> Ein Onlineshop berechnet Versandkosten:
            unter 20 Euro Bestellwert kosten sie 4,95 Euro, ab 20 Euro noch 1,95
            Euro, und ab 50 Euro ist der Versand gratis. Schreib das mit
            if/elif/else und teste verschiedene Werte.
          </p>
        </div>
        <PythonRunner
          rows={8}
          initialCode={`bestellwert = 35
# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`bestellwert = 35
if bestellwert >= 50:
    print("Versand gratis")
elif bestellwert >= 20:
    print("Versand: 1.95 Euro")
else:
    print("Versand: 4.95 Euro")

# Wichtig: von der GROESSTEN Grenze abwaerts pruefen,
# sonst schnappt sich "ab 20 Euro" auch die 50er-Faelle.`}</pre>
        </details>

        {/* ─── LEKTION 5 ─────────────────────────────────── */}
        <hr className="pk-divider" />
        <h2 id="lektion-5">Lektion 5: Schleifen</h2>
        <p>
          Computer sind gut in einer Sache: stumpf wiederholen, ohne sich zu
          beschweren. Eine <span className="lp-mono">for</span>-Schleife mit{" "}
          <span className="lp-mono">range()</span> wiederholt Code eine feste
          Anzahl von Malen:
        </p>

        <PythonRunner
          rows={4}
          initialCode={`for i in range(5):
    print(f"Durchlauf Nummer {i}")`}
        />

        <p>
          Wichtig: <span className="lp-mono">range(5)</span> zählt{" "}
          <strong>ab 0</strong> und hört <strong>vor 5</strong> auf (0, 1, 2, 3,
          4). Das verwirrt jeden am Anfang. Willst du von 1 bis 10 zählen,
          schreibst du <span className="lp-mono">range(1, 11)</span>. Damit
          lassen sich in drei Zeilen Dinge bauen, für die du früher zehn Minuten
          getippt hättest:
        </p>

        <PythonRunner
          rows={6}
          initialCode={`# Summe aller Zahlen von 1 bis 100 (der kleine Gauss)
summe = 0
for zahl in range(1, 101):
    summe = summe + zahl
print(summe)`}
        />

        <p>
          Die zweite Schleifenart ist <span className="lp-mono">while</span>:
          Sie läuft, <strong>solange</strong> eine Bedingung wahr ist. Du weißt
          vorher nicht, wie oft, und genau das ist ihr Einsatzgebiet:
        </p>

        <PythonRunner
          rows={7}
          initialCode={`countdown = 5
while countdown > 0:
    print(countdown)
    countdown = countdown - 1
print("Start!")`}
        />

        <div className="lp-tip">
          <p>
            <strong>Achtung, Endlosschleife:</strong> Wenn du das{" "}
            <span className="lp-mono">countdown = countdown - 1</span> vergisst,
            bleibt die Bedingung für immer wahr und die Schleife läuft endlos.
            Falls dir das hier im Browser passiert: Seite neu laden, Code
            korrigieren, weitermachen. Merke: Eine while-Schleife braucht immer
            etwas, das ihre Bedingung irgendwann kippt.
          </p>
        </div>

        <p>
          Mit <span className="lp-mono">break</span> brichst du eine Schleife
          sofort ab. Das brauchst du gleich in Lektion 6 fürs Spiel:
        </p>

        <PythonRunner
          rows={7}
          initialCode={`for zahl in range(1, 100):
    if zahl * zahl > 200:
        print(f"{zahl} ist die erste Zahl, deren Quadrat ueber 200 liegt.")
        break`}
        />

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 5.1:</strong> Gib das kleine Einmaleins der 7 aus, also
            &quot;1 x 7 = 7&quot; bis &quot;10 x 7 = 70&quot;. Eine
            for-Schleife, ein f-String, fertig.
          </p>
        </div>
        <PythonRunner
          rows={4}
          initialCode={`# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`for i in range(1, 11):
    print(f"{i} x 7 = {i * 7}")`}</pre>
        </details>

        <div className="pk-aufgabe">
          <p>
            <strong>Übung 5.2:</strong> Simuliere eine PIN-Abfrage: Die richtige
            PIN ist 4711. Frag mit einer while-Schleife so lange nach der PIN,
            bis sie stimmt, und begrüße den Nutzer dann.
          </p>
        </div>
        <PythonRunner
          rows={6}
          initialCode={`richtige_pin = 4711
# Dein Code:
`}
        />
        <details className="pk-loesung">
          <summary>Musterlösung anzeigen</summary>
          <pre>{`richtige_pin = 4711
eingabe = int(input("PIN eingeben: "))
while eingabe != richtige_pin:
    eingabe = int(input("Falsch! Nochmal: "))
print("Willkommen!")`}</pre>
        </details>

        {/* ─── AUSBLICK ──────────────────────────────────── */}
        <h2>Wie geht es weiter?</h2>
        <p>
          Du kannst jetzt rechnen, entscheiden und wiederholen. Das ist alles,
          was du für dein <strong>erstes Spiel</strong> brauchst: In{" "}
          <strong>Lektion 6</strong> baust du Zahlenraten, komplett hier im
          Browser. Danach kommen Listen, Funktionen und Objektorientierung. Die
          Lektionen erscheinen nach und nach.
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
