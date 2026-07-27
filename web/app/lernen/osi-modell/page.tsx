import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "OSI-Modell einfach erklärt — die 7 Schichten (IHK)",
  description: "Das OSI-Modell einfach erklärt: alle 7 Schichten mit Protokollen, Geräten und Merksatz — plus interaktive Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/osi-modell",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/osi-modell",
    siteName: "Lernarena",
    title: "OSI-Modell einfach erklärt — die 7 Schichten (IHK)",
    description: "Alle 7 Schichten des OSI-Modells mit Protokollen, Geräten und Merksatz — für die Fachinformatiker-Prüfung.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Was ist das OSI-Modell?",
    "a": "Das OSI-Modell (Open Systems Interconnection) ist ein Referenzmodell, das die Netzwerkkommunikation in 7 Schichten aufteilt — von der Bitübertragung (Schicht 1) bis zur Anwendung (Schicht 7). Jede Schicht hat eine klar definierte Aufgabe."
  },
  {
    "q": "Wie merke ich mir die 7 Schichten?",
    "a": "Ein bewährter deutscher Merksatz von Schicht 7 nach 1 ist: 'Alle deutschen Studenten trinken verschiedene Sorten Bier' — Anwendung, Darstellung, Sitzung, Transport, Vermittlung, Sicherung, Bitübertragung."
  },
  {
    "q": "Auf welcher OSI-Schicht arbeitet ein Router?",
    "a": "Ein Router arbeitet auf Schicht 3 (Vermittlungsschicht) und trifft Weiterleitungsentscheidungen anhand von IP-Adressen. Ein Switch arbeitet dagegen auf Schicht 2 mit MAC-Adressen, ein Hub auf Schicht 1."
  },
  {
    "q": "Was ist der Unterschied zwischen OSI- und TCP/IP-Modell?",
    "a": "Das OSI-Modell hat 7 Schichten und ist ein theoretisches Referenzmodell. Das TCP/IP-Modell hat 4 Schichten (Netzzugang, Internet, Transport, Anwendung) und beschreibt die Praxis des Internets. Die Schichten lassen sich ineinander überführen."
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
          --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
          --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.14);
          --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
          --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
          --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
          --input-bg: rgba(255,255,255,0.05); --input-border: rgba(255,255,255,0.15);
          --pre-bg: rgba(0,0,0,0.35);
          --ok: #5FD98A; --ok-bg: rgba(52,199,89,0.16); --ok-border: rgba(52,199,89,0.6); --ok-text: #B8F0C4;
          --err: #FF6B63; --err-bg: rgba(255,69,58,0.16); --err-border: rgba(255,69,58,0.6); --err-text: #A32620;
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
        .lp-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .lp-table th, .lp-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid var(--border); }
        .lp-table th { color: var(--text-dim); font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .lp-table td { color: var(--text-body); }
        .lp-table td:first-child { font-weight: 600; color: var(--accent-text); white-space: nowrap; }
        .lp-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
        .lp-mono {
          font-family: var(--font-geist-mono), ui-monospace, monospace;
          background: var(--accent-soft); color: var(--accent-text);
          padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
        }
        .lp-related { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
        .lp-chip {
          display: inline-block; padding: 10px 16px; border-radius: 10px;
          background: var(--chip-bg); border: 1px solid var(--chip-border);
          color: var(--text-body); text-decoration: none; font-size: 15px;
        }
        .lp-chip:hover { background: var(--accent-soft); border-color: var(--accent); }
        .lp-final {
          text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted));
          border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
          padding: 40px 28px; margin: 56px 0 0;
        }
        .lp-final h2 { margin-top: 0; }
        .lp-tip { background: var(--accent-soft); border: 1px solid var(--accent); border-radius: 14px; padding: 18px 22px; margin: 22px 0; }
        .lp-tip p { margin: 0; }
        .lp-tip strong { color: var(--accent-text); }
        .lp-warn { background: var(--warn-bg); border: 1px solid var(--warn-border); border-radius: 14px; padding: 18px 22px; margin: 22px 0; }
        .lp-warn p { margin: 0 0 8px; }
        .lp-warn strong { color: var(--warn-text); }
        .lp-warn ul { margin: 8px 0 0; padding-left: 20px; }
        .lp-warn li { color: var(--text-body); margin: 6px 0; }
        .lp-faq { margin: 8px 0; }
        .lp-faq details { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 2px 22px; margin: 10px 0; transition: border-color .15s ease; }
        .lp-faq details[open] { border-color: var(--border-strong); }
        .lp-faq summary { cursor: pointer; font-weight: 600; color: var(--text); padding: 16px 0; list-style: none; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
        .lp-faq summary::-webkit-details-marker { display: none; }
        .lp-faq summary::after { content: "+"; color: var(--accent); font-size: 22px; font-weight: 400; line-height: 1; }
        .lp-faq details[open] summary::after { content: "−"; }
        .lp-faq details p { padding: 0 0 16px; margin: 0; color: var(--text-body); }
`}</style>

      <div className="lp-container">
        <nav className="lp-crumb">
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · OSI-Modell
        </nav>

        <h1>OSI-Modell einfach erklärt — die 7 Schichten</h1>
        <p className="lp-lead">
          Das OSI-Modell ist das Grundgerüst der Netzwerktechnik und ein Dauergast in
          der IHK-Prüfung. Hier lernst du alle 7 Schichten mit typischen Protokollen
          und Geräten, einen bewährten Merksatz — und testest dich direkt selbst.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>Was ist das OSI-Modell?</h2>
        <p>
          Das <strong>OSI-Modell</strong> (Open Systems Interconnection) teilt die
          Netzwerkkommunikation in <strong>7 Schichten</strong> auf. Jede Schicht hat
          eine klar abgegrenzte Aufgabe und kommuniziert nur mit der Schicht direkt
          über und unter ihr. So lassen sich Protokolle, Geräte und Fehlerquellen
          sauber einordnen — genau das wird in der Prüfung abgefragt.
        </p>

        <div className="lp-tip">
          <p>
            <strong>📦 Stell es dir wie einen Paketversand vor:</strong> Deine Nachricht
            (oben, Schicht 7) wird auf dem Weg nach unten Schicht für Schicht in einen
            weiteren Umschlag gepackt — Absender/Empfänger drauf, Portoetikett, ab in den
            Transporter. Beim Empfänger wird jeder Umschlag in umgekehrter Reihenfolge
            wieder ausgepackt, bis die eigentliche Nachricht oben ankommt. Dieses
            Ein- und Auspacken nennt man <strong>Kapselung</strong> (Encapsulation) — jede
            Schicht fügt ihren eigenen „Umschlag" (Header) hinzu.
          </p>
        </div>

        <h2>Die 7 Schichten im Überblick</h2>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Nr.</th>
              <th>Schicht</th>
              <th>Beispiele</th>
              <th>Geräte</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>7</td><td>Anwendung (Application)</td><td>HTTP, SMTP, DNS, FTP</td><td>Gateway, Proxy</td></tr>
            <tr><td>6</td><td>Darstellung (Presentation)</td><td>TLS/SSL, Zeichencodierung</td><td>—</td></tr>
            <tr><td>5</td><td>Sitzung (Session)</td><td>Sitzungsauf- und -abbau</td><td>—</td></tr>
            <tr><td>4</td><td>Transport</td><td>TCP, UDP (Ports)</td><td>Firewall (L4)</td></tr>
            <tr><td>3</td><td>Vermittlung (Network)</td><td>IP, ICMP, Routing</td><td>Router, Layer-3-Switch</td></tr>
            <tr><td>2</td><td>Sicherung (Data Link)</td><td>Ethernet, MAC-Adressen, VLAN</td><td>Switch, Bridge</td></tr>
            <tr><td>1</td><td>Bitübertragung (Physical)</td><td>Kabel, Stecker, Funk, Bits</td><td>Hub, Repeater</td></tr>
          </tbody>
        </table>

        <h2>Merksatz für die Prüfung</h2>
        <div className="lp-card">
          <p>
            Von Schicht 7 nach 1: <strong>„Alle deutschen Studenten trinken
            verschiedene Sorten Bier"</strong> — Anwendung, Darstellung, Sitzung,
            Transport, Vermittlung, Sicherung, Bitübertragung.
          </p>
          <p>
            Die Dateneinheiten von unten nach oben: <span className="lp-mono">Bits</span> (L1),{" "}
            <span className="lp-mono">Frames</span> (L2), <span className="lp-mono">Pakete</span> (L3),{" "}
            <span className="lp-mono">Segmente</span> (L4), darüber spricht man von Daten.
          </p>
        </div>

        <h2>Typische Prüfungsfrage: Gerät zuordnen</h2>
        <p>
          Ein <strong>Hub</strong> arbeitet auf Schicht 1 — er verstärkt nur Signale.
          Ein <strong>Switch</strong> arbeitet auf Schicht 2 und entscheidet anhand von{" "}
          <strong>MAC-Adressen</strong>. Ein <strong>Router</strong> arbeitet auf
          Schicht 3 und entscheidet anhand von <strong>IP-Adressen</strong>. Diese
          Zuordnung wird in fast jeder Prüfung in irgendeiner Form abgefragt.
        </p>

        <div className="lp-tip">
          <p>
            <strong>💡 Prüfungstipp — Geräte auf einen Blick:</strong>{" "}
            <span className="lp-mono">Hub = 1</span> (nur Signale),{" "}
            <span className="lp-mono">Switch = 2</span> (MAC-Adressen),{" "}
            <span className="lp-mono">Router = 3</span> (IP-Adressen). Merke: Je „schlauer"
            das Gerät, desto höher die Schicht. Und der Klassiker: <strong>TCP/UDP arbeiten
            mit Ports</strong> auf Schicht 4, <strong>IP</strong> mit Adressen auf Schicht 3.
          </p>
        </div>

        <div className="lp-warn">
          <p><strong>⚠️ Häufige Fehler in der Prüfung:</strong></p>
          <ul>
            <li>
              Schicht 2 und 3 verwechseln: <strong>MAC</strong>-Adresse = Schicht 2,{" "}
              <strong>IP</strong>-Adresse = Schicht 3.
            </li>
            <li>
              Die Dateneinheiten durcheinanderbringen. Von unten:{" "}
              <span className="lp-mono">Bits → Frames → Pakete → Segmente</span>.
            </li>
            <li>
              TLS/SSL auf Schicht 7 statt 6 einordnen — Verschlüsselung/Darstellung ist
              Schicht 6.
            </li>
            <li>
              Die Schichten falsch herum zählen. Schicht <strong>1 ist unten</strong>{" "}
              (Kabel), Schicht 7 oben (Anwendung).
            </li>
          </ul>
        </div>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Auf welcher OSI-Schicht arbeitet ein Router?"}
          optionen={[
            { text: "Schicht 2 — Sicherung", richtig: false },
            { text: "Schicht 3 — Vermittlung", richtig: true },
            { text: "Schicht 4 — Transport", richtig: false },
            { text: "Schicht 7 — Anwendung", richtig: false },
          ]}
          erklaerung={"Ein Router leitet Pakete anhand von IP-Adressen weiter — das ist Schicht 3, die Vermittlungsschicht (Network Layer)."}
        />

        <QuizFrage
          frage={"Welche Dateneinheit gehört zu Schicht 2 (Sicherungsschicht)?"}
          optionen={[
            { text: "Segmente", richtig: false },
            { text: "Pakete", richtig: false },
            { text: "Frames", richtig: true },
            { text: "Bits", richtig: false },
          ]}
          erklaerung={"Schicht 2 arbeitet mit Frames. Von unten nach oben: Bits (L1), Frames (L2), Pakete (L3), Segmente (L4)."}
        />

        <QuizFrage
          frage={"Welche Protokolle gehören zur Transportschicht (Schicht 4)?"}
          optionen={[
            { text: "IP und ICMP", richtig: false },
            { text: "TCP und UDP", richtig: true },
            { text: "HTTP und DNS", richtig: false },
            { text: "Ethernet und VLAN", richtig: false },
          ]}
          erklaerung={"TCP und UDP sind die Transportprotokolle der Schicht 4 und adressieren über Ports. IP/ICMP gehören zu Schicht 3, HTTP/DNS zu Schicht 7."}
        />

        <QuizFrage
          frage={"Auf welcher Schicht arbeitet ein Switch?"}
          optionen={[
            { text: "Schicht 1 — Bitübertragung", richtig: false },
            { text: "Schicht 2 — Sicherung", richtig: true },
            { text: "Schicht 3 — Vermittlung", richtig: false },
            { text: "Schicht 4 — Transport", richtig: false },
          ]}
          erklaerung={"Ein Switch entscheidet anhand von MAC-Adressen und arbeitet damit auf Schicht 2 (Sicherungsschicht). Ein Hub wäre Schicht 1, ein Router Schicht 3."}
        />

        <QuizFrage
          frage={"Auf welcher Schicht ist die Verschlüsselung (TLS/SSL) angesiedelt?"}
          optionen={[
            { text: "Schicht 4 — Transport", richtig: false },
            { text: "Schicht 5 — Sitzung", richtig: false },
            { text: "Schicht 6 — Darstellung", richtig: true },
            { text: "Schicht 7 — Anwendung", richtig: false },
          ]}
          erklaerung={"Die Darstellungsschicht (Schicht 6) kümmert sich um Codierung und Verschlüsselung — dort ist TLS/SSL klassisch eingeordnet."}
        />

        <h2>Häufige Fragen</h2>
        <div className="lp-faq">
          {faq.map((f) => (
            <details key={f.q}>
              <summary>{f.q}</summary>
              <p>{f.a}</p>
            </details>
          ))}
        </div>

        <h2>Verwandte Themen</h2>
        <div className="lp-related">
          <Link href="/lernen/subnetting" className="lp-chip">Subnetting üben →</Link>
          <Link href="/lernen/ip-adressen" className="lp-chip">IP-Adressen & IPv6 →</Link>
          <Link href="/lernen/raid" className="lp-chip">RAID Level →</Link>
          <Link href="/lernen" className="lp-chip">Alle Lernthemen →</Link>
        </div>

        <section className="lp-final">
          <h2>Netzwerktechnik interaktiv trainieren</h2>
          <p>
            In der Lernarena übst du OSI-Modell, Subnetting und Co. mit sofortigem
            Feedback, echten IHK-Prüfungsfragen und einem KI-Tutor, der dir jede
            Zuordnung erklärt. Kostenlos starten, direkt üben.
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
