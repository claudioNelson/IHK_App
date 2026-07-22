import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Zahlensysteme umrechnen — binär, dezimal, hexadezimal (IHK)",
  description: "Binär, dezimal und hexadezimal sicher umrechnen: Divisionsverfahren, Stellenwert und Vierergruppen einfach erklärt — mit interaktiven Übungsaufgaben für die IHK-Prüfung (AP1).",
  alternates: {
    canonical: "https://lernarena.app/lernen/zahlensysteme",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/zahlensysteme",
    siteName: "Lernarena",
    title: "Zahlensysteme umrechnen — binär, dezimal, hexadezimal (IHK)",
    description: "Binär, dezimal, hexadezimal umrechnen — Schritt für Schritt mit Übungsaufgaben für AP1 und AP2.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Wie rechne ich eine Dezimalzahl in eine Binärzahl um?",
    "a": "Mit dem Divisionsverfahren: die Zahl fortlaufend durch 2 teilen und die Reste notieren. Die Reste von unten nach oben gelesen ergeben die Binärzahl. Beispiel: 172 ergibt 10101100."
  },
  {
    "q": "Wie rechne ich binär in hexadezimal um?",
    "a": "Die Binärzahl von rechts in Vierergruppen aufteilen und jede Gruppe einzeln übersetzen, denn ein Hex-Zeichen entspricht genau 4 Bit. 10101100 wird zu 1010|1100, also A und C — das Ergebnis ist AC."
  },
  {
    "q": "Warum wird in der IT hexadezimal verwendet?",
    "a": "Weil ein Hex-Zeichen exakt 4 Bit darstellt, lassen sich lange Bitfolgen kompakt schreiben. MAC-Adressen, IPv6-Adressen, Farbcodes und Speicheradressen werden deshalb hexadezimal notiert."
  },
  {
    "q": "Kommen Zahlensysteme in der IHK-Prüfung vor?",
    "a": "Ja, vor allem in der AP1: Umrechnungen zwischen dezimal, binär und hexadezimal gehören zu den Standardaufgaben und sind außerdem die Grundlage für Subnetting-Aufgaben."
  }
];

export default function LernSeite() {
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
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: #08080C;
          color: #F5F5F7;
          min-height: 100vh;
          line-height: 1.65;
        }
        .lp-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
        .lp-crumb { font-size: 14px; color: #7C6DFF; margin-bottom: 24px; }
        .lp-crumb a { color: #7C6DFF; text-decoration: none; }
        .lp-crumb a:hover { text-decoration: underline; }
        .lp-wrap h1 {
          font-size: clamp(32px, 5vw, 46px);
          line-height: 1.1; letter-spacing: -0.02em;
          margin: 0 0 16px; font-weight: 700;
        }
        .lp-lead { font-size: 19px; color: #A0A0B0; margin: 0 0 32px; }
        .lp-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 48px 0 16px; font-weight: 650; }
        .lp-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
        .lp-wrap p { color: #C8C8D2; margin: 0 0 16px; }
        .lp-wrap strong { color: #F5F5F7; }
        .lp-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .lp-btn {
          display: inline-block; padding: 13px 26px; border-radius: 12px;
          font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
        }
        .lp-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .lp-btn-primary:hover { transform: translateY(-2px); }
        .lp-btn-ghost { background: rgba(255,255,255,0.06); color: #F5F5F7; border: 1px solid rgba(255,255,255,0.12); }
        .lp-btn-ghost:hover { background: rgba(255,255,255,0.1); }
        .lp-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .lp-table th, .lp-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .lp-table th { color: #A0A0B0; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .lp-table td { color: #E0E0E8; }
        .lp-table td:first-child { font-weight: 600; color: #C4BBFF; white-space: nowrap; }
        .lp-card { background: #12121C; border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .lp-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: rgba(124,109,255,0.14); color: #C4BBFF;
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .lp-related { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .lp-chip {
          display: inline-block; padding: 10px 16px; border-radius: 10px;
          background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
          color: #E0E0E8; text-decoration: none; font-size: 15px;
        }
        .lp-chip:hover { background: rgba(124,109,255,0.14); border-color: rgba(124,109,255,0.4); }
        .lp-final {
          text-align: center; background: linear-gradient(180deg, #12121C, #0E0E14);
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lp-final h2 { margin-top: 0; }
`}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · Zahlensysteme
        </nav>

        <h1>Zahlensysteme umrechnen — binär, dezimal und hexadezimal</h1>
        <p className="lp-lead">
          Zahlensysteme sind Pflichtstoff in der AP1 und tauchen auch in der AP2 immer
          wieder auf — von IP-Adressen bis Speicheradressen. Hier lernst du die
          Umrechnungswege Schritt für Schritt und übst direkt interaktiv.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Die drei Systeme im Vergleich</h2>
        <p>
          <strong>Dezimal</strong> (Basis 10) nutzt die Ziffern 0–9,{" "}
          <strong>Binär</strong> (Basis 2) nur 0 und 1, und{" "}
          <strong>Hexadezimal</strong> (Basis 16) die Zeichen 0–9 und A–F. Ein
          Hex-Zeichen entspricht genau <strong>4 Bit</strong> — deshalb ist Hex die
          Kurzschreibweise der IT (MAC-Adressen, IPv6, Farbcodes).
        </p>
        <table className="lp-table">
          <thead>
            <tr><th>Dezimal</th><th>Binär</th><th>Hex</th></tr>
          </thead>
          <tbody>
            <tr><td>0</td><td>0000</td><td>0</td></tr>
            <tr><td>1</td><td>0001</td><td>1</td></tr>
            <tr><td>2</td><td>0010</td><td>2</td></tr>
            <tr><td>3</td><td>0011</td><td>3</td></tr>
            <tr><td>4</td><td>0100</td><td>4</td></tr>
            <tr><td>5</td><td>0101</td><td>5</td></tr>
            <tr><td>6</td><td>0110</td><td>6</td></tr>
            <tr><td>7</td><td>0111</td><td>7</td></tr>
            <tr><td>8</td><td>1000</td><td>8</td></tr>
            <tr><td>9</td><td>1001</td><td>9</td></tr>
            <tr><td>10</td><td>1010</td><td>A</td></tr>
            <tr><td>11</td><td>1011</td><td>B</td></tr>
            <tr><td>12</td><td>1100</td><td>C</td></tr>
            <tr><td>13</td><td>1101</td><td>D</td></tr>
            <tr><td>14</td><td>1110</td><td>E</td></tr>
            <tr><td>15</td><td>1111</td><td>F</td></tr>
          </tbody>
        </table>

        <h2>Dezimal → Binär: das Divisionsverfahren</h2>
        <div className="lp-card">
          <p>
            <strong>Beispiel: 172 in Binär.</strong> Teile fortlaufend durch 2 und
            notiere die Reste: 172 → 86 R0, 86 → 43 R0, 43 → 21 R1, 21 → 10 R1,
            10 → 5 R0, 5 → 2 R1, 2 → 1 R0, 1 → 0 R1.
          </p>
          <p>
            Die Reste <strong>von unten nach oben</strong> gelesen:{" "}
            <span className="lp-mono">10101100</span>. Gegenprobe über die
            Stellenwerte: 128 + 32 + 8 + 4 = 172. ✓
          </p>
        </div>

        <h2>Binär → Hex: Vierergruppen</h2>
        <p>
          Teile die Binärzahl von rechts in Vierergruppen und übersetze jede Gruppe
          einzeln: <span className="lp-mono">10101100</span> wird zu{" "}
          <span className="lp-mono">1010</span> | <span className="lp-mono">1100</span>{" "}
          = <span className="lp-mono">A</span> und <span className="lp-mono">C</span> →{" "}
          <span className="lp-mono">AC</span>. Rückwärts genauso: jedes Hex-Zeichen in
          4 Bit auflösen.
        </p>

        <h2>Die Stellenwerte, die du auswendig können solltest</h2>
        <p>
          <span className="lp-mono">128 · 64 · 32 · 16 · 8 · 4 · 2 · 1</span> — die
          Wertigkeiten eines Bytes. Wer diese Reihe sicher beherrscht, rechnet auch
          Subnetzmasken ohne Taschenrechner um.
        </p>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Was ist 11001000 in Dezimal?"}
          optionen={[
            { text: "196", richtig: false },
            { text: "200", richtig: true },
            { text: "204", richtig: false },
            { text: "212", richtig: false },
          ]}
          erklaerung={"Stellenwerte addieren: 128 + 64 + 8 = 200. Die gesetzten Bits stehen an den Positionen 128, 64 und 8."}
        />

        <QuizFrage
          frage={"Welcher Hex-Wert entspricht der Dezimalzahl 255?"}
          optionen={[
            { text: "EE", richtig: false },
            { text: "FF", richtig: true },
            { text: "F0", richtig: false },
            { text: "100", richtig: false },
          ]}
          erklaerung={"255 = 11111111 in Binär = zwei Vierergruppen 1111|1111 = F und F, also FF. Der Klassiker aus jeder Subnetzmaske."}
        />

        <QuizFrage
          frage={"Was ist Hex B3 in Dezimal?"}
          optionen={[
            { text: "163", richtig: false },
            { text: "173", richtig: false },
            { text: "179", richtig: true },
            { text: "183", richtig: false },
          ]}
          erklaerung={"B = 11. Also 11 × 16 + 3 = 176 + 3 = 179. Hex rechnet man über die Stellenwerte 16, 256, 4096 usw. um."}
        />

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/lernen/ip-adressen" className="lp-chip">IP-Adressen & IPv6 →</Link>
          <Link href="/pruefungen" className="lp-chip">Alle IHK-Prüfungen →</Link>
        </div>

        <section className="lp-final">
          <h2>Zahlensysteme interaktiv trainieren</h2>
          <p>
            In der Lernarena übst du Umrechnungen mit sofortigem Feedback, echten
            IHK-Prüfungsfragen und einem KI-Tutor, der dir jeden Rechenweg erklärt.
            Kostenlos starten, direkt üben.
          </p>
          <div className="lp-cta-row" style={{ justifyContent: "center" }}>
            <Link href="/signup" className="lp-btn lp-btn-primary">Jetzt kostenlos starten</Link>
            <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Alle Prüfungen ansehen</Link>
          </div>
        </section>
      </div>
    </main>
  );
}
