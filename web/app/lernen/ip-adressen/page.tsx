import type { Metadata } from "next";
import Link from "next/link";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "IP-Adressen & IPv6 einfach erklärt — private Bereiche & Kürzung (IHK)",
  description: "IPv4 und IPv6 einfach erklärt: private Adressbereiche, APIPA, Loopback und die IPv6-Kürzungsregeln — mit interaktiven Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/ip-adressen",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/lernen/ip-adressen",
    siteName: "Lernarena",
    title: "IP-Adressen & IPv6 einfach erklärt — private Bereiche & Kürzung (IHK)",
    description: "IPv4 und IPv6 für die IHK-Prüfung: private Bereiche, APIPA und IPv6-Kürzung — mit Übungsaufgaben.",
  },
};

const faq: { q: string; a: string }[] = [
  {
    "q": "Welche IPv4-Adressbereiche sind privat?",
    "a": "Die drei privaten Bereiche sind 10.0.0.0/8, 172.16.0.0/12 (also 172.16.0.0 bis 172.31.255.255) und 192.168.0.0/16. Diese Adressen werden im Internet nicht geroutet und dürfen in lokalen Netzen frei verwendet werden."
  },
  {
    "q": "Was bedeutet eine 169.254.x.x-Adresse?",
    "a": "Das ist eine APIPA-Adresse (Automatic Private IP Addressing). Der Rechner hat keinen DHCP-Server erreicht und sich selbst eine link-lokale Adresse zugewiesen. In der Praxis ein Hinweis auf ein DHCP- oder Verbindungsproblem."
  },
  {
    "q": "Wie lang ist eine IPv6-Adresse?",
    "a": "Eine IPv6-Adresse ist 128 Bit lang und wird hexadezimal in acht Blöcken zu je 16 Bit geschrieben, getrennt durch Doppelpunkte. Zum Vergleich: IPv4 hat nur 32 Bit."
  },
  {
    "q": "Wie kürzt man eine IPv6-Adresse richtig?",
    "a": "Zwei Regeln: Führende Nullen in jedem Block dürfen entfallen, und genau eine zusammenhängende Folge von Null-Blöcken darf durch :: ersetzt werden. Aus 2001:0db8:0000:0000:0000:0000:0000:0001 wird so 2001:db8::1."
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
          <Link href="/">Lernarena</Link> · <Link href="/lernen">Lernen</Link> · IP-Adressen & IPv6
        </nav>

        <h1>IP-Adressen und IPv6 — private Bereiche, APIPA und Kürzungsregeln</h1>
        <p className="lp-lead">
          Private Adressbereiche erkennen, IPv6-Adressen kürzen, APIPA einordnen —
          das sind Standardaufgaben in der IHK-Prüfung. Hier bekommst du alle
          Tabellen und Regeln kompakt, mit interaktiven Übungen.
        </p>

        <div className="lp-cta-row">
          <Link href="/signup" className="lp-btn lp-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="lp-btn lp-btn-ghost">Zu den Prüfungen</Link>
        </div>

        <h2>IPv4 in 60 Sekunden</h2>
        <p>
          Eine <strong>IPv4-Adresse</strong> ist 32 Bit lang und wird in vier Oktetten
          geschrieben, z. B. <span className="lp-mono">192.168.10.25</span>. Zusammen mit
          der Subnetzmaske zerfällt sie in Netz- und Host-Teil. Öffentliche Adressen
          sind weltweit eindeutig — <strong>private Adressen</strong> dürfen nur in
          lokalen Netzen verwendet werden und werden im Internet nicht geroutet.
        </p>

        <div className="lp-tip">
          <p>
            <strong>☎️ Stell es dir wie Telefonnummern in einer Firma vor:</strong> Die{" "}
            <strong>öffentliche IP</strong> ist die Hauptnummer, die die ganze Welt
            anrufen kann. Die <strong>privaten IPs</strong> sind die internen Durchwahlen
            (z. B. „Apparat 101") — sie gelten nur im Haus, und jede Firma darf dieselbe
            Durchwahl 101 haben, ohne dass es Chaos gibt. Damit ein internes Gerät ins
            Internet kommt, „übersetzt" der Router per <strong>NAT</strong> die private
            Adresse auf die öffentliche — wie eine Telefonzentrale, die nach außen
            vermittelt.
          </p>
        </div>

        <h2>Diese Bereiche musst du erkennen</h2>
        <table className="lp-table">
          <thead>
            <tr>
              <th>Bereich</th>
              <th>CIDR</th>
              <th>Bedeutung</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>10.0.0.0 – 10.255.255.255</td><td>10.0.0.0/8</td><td>privat (Klasse A)</td></tr>
            <tr><td>172.16.0.0 – 172.31.255.255</td><td>172.16.0.0/12</td><td>privat (Klasse B)</td></tr>
            <tr><td>192.168.0.0 – 192.168.255.255</td><td>192.168.0.0/16</td><td>privat (Klasse C)</td></tr>
            <tr><td>127.0.0.0 – 127.255.255.255</td><td>127.0.0.0/8</td><td>Loopback (localhost)</td></tr>
            <tr><td>169.254.0.0 – 169.254.255.255</td><td>169.254.0.0/16</td><td>APIPA / link-local</td></tr>
          </tbody>
        </table>
        <p>
          <strong>APIPA-Merksatz:</strong> Hat ein Rechner eine{" "}
          <span className="lp-mono">169.254.x.x</span>-Adresse, hat er{" "}
          <strong>keinen DHCP-Server erreicht</strong> und sich selbst eine Adresse
          gegeben — ein klassisches Troubleshooting-Indiz in der Prüfung.
        </p>

        <h2>IPv6 — das Wichtigste</h2>
        <p>
          Eine <strong>IPv6-Adresse</strong> ist 128 Bit lang und wird hexadezimal in
          acht Blöcken geschrieben. Wichtige Typen:{" "}
          <span className="lp-mono">2000::/3</span> (Global Unicast, öffentlich),{" "}
          <span className="lp-mono">fe80::/10</span> (Link-local, automatisch auf jedem
          Interface) und <span className="lp-mono">fc00::/7</span> (Unique Local, das
          Gegenstück zu privaten IPv4-Adressen).
        </p>

        <h2>IPv6 kürzen — die zwei Regeln</h2>
        <div className="lp-card">
          <p>
            <strong>Regel 1:</strong> Führende Nullen in jedem Block dürfen weg:{" "}
            <span className="lp-mono">0db8</span> wird zu <span className="lp-mono">db8</span>.
          </p>
          <p>
            <strong>Regel 2:</strong> <strong>Genau eine</strong> Folge aus
            Null-Blöcken darf durch <span className="lp-mono">::</span> ersetzt werden.
          </p>
          <p>
            Beispiel:{" "}
            <span className="lp-mono">2001:0db8:0000:0000:0000:0000:0000:0001</span>{" "}
            wird zu <span className="lp-mono">2001:db8::1</span>.
          </p>
        </div>

        <div className="lp-tip">
          <p>
            <strong>💡 Prüfungstipp — die 172er-Falle:</strong> Der private Bereich der
            „Klasse B" geht nur von <span className="lp-mono">172.16</span> bis{" "}
            <span className="lp-mono">172.31</span>. Genau hier baut die IHK gern Fallen:
            <span className="lp-mono">172.32.x.x</span> ist schon{" "}
            <strong>öffentlich</strong>, ebenso <span className="lp-mono">172.15.x.x</span>.
            Merke dir die Grenzen 16 und 31 auswendig.
          </p>
        </div>

        <div className="lp-warn">
          <p><strong>⚠️ Häufige Fehler in der Prüfung:</strong></p>
          <ul>
            <li>
              <span className="lp-mono">192.169.x.x</span> für privat halten — privat ist
              nur <span className="lp-mono">192.168.x.x</span> (eine 8, keine 9).
            </li>
            <li>
              Das <span className="lp-mono">::</span> in IPv6 <strong>zweimal</strong>{" "}
              verwenden. Es ist nur <em>einmal</em> pro Adresse erlaubt.
            </li>
            <li>
              APIPA (<span className="lp-mono">169.254.x.x</span>) mit einer normalen
              Adresse verwechseln — sie bedeutet immer „DHCP nicht erreicht".
            </li>
            <li>
              Loopback ist <span className="lp-mono">127.0.0.1</span>, nicht{" "}
              <span className="lp-mono">10.0.0.1</span> — ein beliebter Verwechsler.
            </li>
          </ul>
        </div>

        <h2>Jetzt selbst testen</h2>
        <p>Beantworte die Fragen und bekomme sofort Feedback — so viele Versuche du willst.</p>

        <QuizFrage
          frage={"Welche dieser Adressen ist eine private IPv4-Adresse?"}
          optionen={[
            { text: "172.32.10.1", richtig: false },
            { text: "172.20.10.1", richtig: true },
            { text: "11.0.0.5", richtig: false },
            { text: "192.169.1.1", richtig: false },
          ]}
          erklaerung={"Der private Bereich lautet 172.16.0.0 bis 172.31.255.255 — 172.20.10.1 liegt darin. 172.32.x.x liegt schon außerhalb, ebenso 11.x und 192.169.x."}
        />

        <QuizFrage
          frage={"Ein PC hat die Adresse 169.254.33.7. Was ist die wahrscheinlichste Ursache?"}
          optionen={[
            { text: "Der DHCP-Server wurde nicht erreicht", richtig: true },
            { text: "Der DNS-Server ist falsch konfiguriert", richtig: false },
            { text: "Die Adresse wurde vom Router vergeben", richtig: false },
            { text: "Es handelt sich um eine öffentliche Adresse", richtig: false },
          ]}
          erklaerung={"169.254.x.x ist der APIPA-Bereich: Der Rechner hat keinen DHCP-Server erreicht und sich selbst eine link-lokale Adresse gegeben."}
        />

        <QuizFrage
          frage={"Wie lautet die korrekte Kürzung von 2001:0db8:0000:0000:00ff:0000:0000:0001?"}
          optionen={[
            { text: "2001:db8::ff::1", richtig: false },
            { text: "2001:db8::ff:0:0:1", richtig: true },
            { text: "2001:db8:0:0:ff::1 und 2001:db8::ff:0:0:1 sind beide erlaubt", richtig: false },
            { text: "2001:0db8::00ff::0001", richtig: false },
          ]}
          erklaerung={"Das :: darf nur einmal vorkommen — 2001:db8::ff::1 ist deshalb ungültig. Korrekt gekürzt: 2001:db8::ff:0:0:1 (die längere Nullfolge wird ersetzt). Achtung: 2001:db8:0:0:ff::1 ersetzt nicht die längste Folge und ist nach RFC 5952 nicht die empfohlene Form."}
        />

        <QuizFrage
          frage={"Wofür steht die Adresse 127.0.0.1?"}
          optionen={[
            { text: "Für den Standard-Gateway", richtig: false },
            { text: "Für den eigenen Rechner (Loopback/localhost)", richtig: true },
            { text: "Für eine private Klasse-A-Adresse", richtig: false },
            { text: "Für eine APIPA-Adresse", richtig: false },
          ]}
          erklaerung={"127.0.0.1 ist die Loopback-Adresse — der Rechner spricht damit mit sich selbst (localhost). Der gesamte Bereich 127.0.0.0/8 ist dafür reserviert."}
        />

        <QuizFrage
          frage={"Wie viele Bit hat eine IPv6-Adresse?"}
          optionen={[
            { text: "32 Bit", richtig: false },
            { text: "64 Bit", richtig: false },
            { text: "128 Bit", richtig: true },
            { text: "256 Bit", richtig: false },
          ]}
          erklaerung={"IPv6 nutzt 128 Bit (acht Blöcke à 16 Bit, hexadezimal). IPv4 hat dagegen nur 32 Bit — deshalb war ein größerer Adressraum überhaupt nötig."}
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
          <Link href="/lernen/osi-modell" className="lp-chip">OSI-Modell →</Link>
          <Link href="/lernen/zahlensysteme" className="lp-chip">Zahlensysteme →</Link>
          <Link href="/lernen" className="lp-chip">Alle Lernthemen →</Link>
        </div>

        <section className="lp-final">
          <h2>IP-Adressierung interaktiv trainieren</h2>
          <p>
            In der Lernarena übst du IPv4, IPv6 und Subnetting mit sofortigem Feedback,
            echten IHK-Prüfungsfragen und einem KI-Tutor. Kostenlos starten, direkt üben.
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
