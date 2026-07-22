import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Fachinformatiker Prüfung: AP1 & AP2 — Ablauf, Themen & Vorbereitung",
  description:
    "Die Fachinformatiker-Prüfung verständlich erklärt: Ablauf der gestreckten Abschlussprüfung (AP1 & AP2), Gewichtung, Prüfungsbereiche für Anwendungsentwicklung und Systemintegration sowie alle wichtigen Themen zum Üben.",
  alternates: {
    canonical: "https://lernarena.app/fachinformatiker-pruefung",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/fachinformatiker-pruefung",
    siteName: "Lernarena",
    title: "Fachinformatiker Prüfung: AP1 & AP2 — Ablauf, Themen & Vorbereitung",
    description:
      "Gestreckte Abschlussprüfung erklärt: AP1 & AP2, Gewichtung, Prüfungsbereiche und alle Themen zum Üben.",
  },
};

const themen: { href: string; titel: string; gruppe: string }[] = [
  { href: "/lernen/zahlensysteme", titel: "Zahlensysteme", gruppe: "Grundlagen (AP1)" },
  { href: "/lernen/subnetting", titel: "Subnetting", gruppe: "Netzwerk" },
  { href: "/lernen/ip-adressen", titel: "IP-Adressen & IPv6", gruppe: "Netzwerk" },
  { href: "/lernen/osi-modell", titel: "OSI-Modell", gruppe: "Netzwerk" },
  { href: "/lernen/raid", titel: "RAID Level", gruppe: "Systemintegration" },
  { href: "/lernen/sql", titel: "SQL", gruppe: "Datenbanken" },
  { href: "/lernen/er-diagramm", titel: "ER-Diagramm", gruppe: "Datenbanken" },
  { href: "/lernen/normalisierung", titel: "Normalisierung", gruppe: "Datenbanken" },
  { href: "/lernen/sortieralgorithmen", titel: "Sortieralgorithmen", gruppe: "Anwendungsentwicklung" },
  { href: "/lernen/nutzwertanalyse", titel: "Nutzwertanalyse", gruppe: "WiSo / AP1" },
];

const faq: { q: string; a: string }[] = [
  {
    q: "Was ist die gestreckte Abschlussprüfung?",
    a: "Seit der Ausbildungsordnung von 2020 gibt es für Fachinformatiker keine separate Zwischenprüfung mehr. Stattdessen besteht die Abschlussprüfung aus zwei zeitlich getrennten Teilen: Teil 1 (AP1) etwa in der Mitte der Ausbildung und Teil 2 (AP2) am Ende. Beide zusammen ergeben die Gesamtnote.",
  },
  {
    q: "Wie viel zählt die AP1 zur Gesamtnote?",
    a: "Teil 1 (AP1) fließt mit 20 Prozent in die Gesamtnote ein. Teil 2 (AP2) macht die restlichen 80 Prozent aus. Das AP1-Ergebnis zählt endgültig und kann nicht separat wiederholt oder verbessert werden.",
  },
  {
    q: "Wann findet die AP1 statt?",
    a: "Die AP1 wird etwa in der Mitte der Ausbildung geschrieben, in der Regel gegen Ende des zweiten Ausbildungsjahres. Sie besteht aus dem Prüfungsbereich 'Einrichten eines IT-gestützten Arbeitsplatzes' und dauert 90 Minuten.",
  },
  {
    q: "Woraus besteht die AP2?",
    a: "Die AP2 besteht aus einem betrieblichen Projekt (Projektarbeit mit Dokumentation, Präsentation und Fachgespräch, 50 Prozent) sowie drei schriftlichen Prüfungsbereichen: zwei fachrichtungsspezifischen und der Wirtschafts- und Sozialkunde (WiSo). Die genauen Bereiche hängen von der Fachrichtung ab.",
  },
  {
    q: "Welche Themen kommen in der Fachinformatiker-Prüfung dran?",
    a: "Typische Themen sind Netzwerktechnik (Subnetting, OSI-Modell, IP-Adressierung), Datenbanken (SQL, ER-Modell, Normalisierung), Algorithmen und Zahlensysteme sowie Wirtschafts- und Sozialkunde mit Klassikern wie der Nutzwertanalyse. Alle diese Themen kannst du in der Lernarena kostenlos üben.",
  },
];

export default function FachinformatikerPruefungPage() {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faq.map((f) => ({
      "@type": "Question",
      name: f.q,
      acceptedAnswer: { "@type": "Answer", text: f.a },
    })),
  };

  const gruppen = Array.from(new Set(themen.map((t) => t.gruppe)));

  return (
    <main className="pl-wrap">
      <script
        dangerouslySetInnerHTML={{
          __html: `(function(){try{if(localStorage.getItem("lernarena-theme")==="light"){document.documentElement.setAttribute("data-theme","light");}}catch(e){}})();`,
        }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <style>{`
        .pl-wrap {
          --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
          --border: rgba(255,255,255,0.08);
          --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
          --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
          --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
          font-family: var(--font-geist-sans), system-ui, sans-serif;
          background: var(--bg); color: var(--text); min-height: 100vh; line-height: 1.65;
        }
        html[data-theme="light"] .pl-wrap {
          --bg: #FAFAF9; --bg-muted: #F4F4F1; --surface: #FFFFFF; --surface-2: #FFFFFF;
          --border: rgba(10,10,15,0.10);
          --text: #0A0A0F; --text-body: #3A3A44; --text-dim: #6A6A74;
          --accent: #6A5AE8; --accent-soft: rgba(106,90,232,0.10); --accent-text: #5B4BE0;
          --chip-bg: rgba(10,10,15,0.04); --chip-border: rgba(10,10,15,0.12);
        }
        .pl-container { max-width: 800px; margin: 0 auto; padding: 72px 24px 96px; }
        .pl-crumb { font-size: 14px; color: var(--accent); margin-bottom: 24px; }
        .pl-crumb a { color: var(--accent); text-decoration: none; }
        .pl-crumb a:hover { text-decoration: underline; }
        .pl-wrap h1 { font-size: clamp(32px, 5vw, 48px); line-height: 1.1; letter-spacing: -0.02em; margin: 0 0 16px; font-weight: 700; }
        .pl-lead { font-size: 19px; color: var(--text-dim); margin: 0 0 32px; }
        .pl-wrap h2 { font-size: 27px; letter-spacing: -0.01em; margin: 52px 0 16px; font-weight: 650; }
        .pl-wrap h3 { font-size: 20px; margin: 28px 0 10px; font-weight: 600; }
        .pl-wrap p { color: var(--text-body); margin: 0 0 16px; }
        .pl-wrap strong { color: var(--text); }
        .pl-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
        .pl-btn { display: inline-block; padding: 13px 26px; border-radius: 12px; font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease; }
        .pl-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
        .pl-btn-primary:hover { transform: translateY(-2px); }
        .pl-btn-ghost { background: var(--chip-bg); color: var(--text); border: 1px solid var(--chip-border); }
        .pl-btn-ghost:hover { background: var(--accent-soft); }
        .pl-table { width: 100%; border-collapse: collapse; margin: 16px 0 8px; font-size: 15px; }
        .pl-table th, .pl-table td { text-align: left; padding: 11px 14px; border-bottom: 1px solid var(--border); vertical-align: top; }
        .pl-table th { color: var(--text-dim); font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.04em; }
        .pl-table td { color: var(--text-body); }
        .pl-table td:first-child { font-weight: 600; color: var(--accent-text); }
        .pl-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 22px 26px; margin: 20px 0; }
        .pl-topics { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 14px; margin-top: 8px; }
        .pl-topic-group h3 { margin: 0 0 8px; font-size: 14px; text-transform: uppercase; letter-spacing: 0.04em; color: var(--text-dim); }
        .pl-topic-group a { display: block; color: var(--accent-text); text-decoration: none; padding: 5px 0; font-size: 15.5px; }
        .pl-topic-group a:hover { text-decoration: underline; }
        .pl-final { text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted)); border: 1px solid rgba(124,109,255,0.25); border-radius: 20px; padding: 40px 28px; margin: 56px 0 0; }
        .pl-final h2 { margin: 0 0 12px; }
        .pl-final p { max-width: 520px; margin: 0 auto 20px; }
      `}</style>

      <div className="pl-container">
        <nav className="pl-crumb">
          <Link href="/">Lernarena</Link> · Fachinformatiker Prüfung
        </nav>

        <h1>Fachinformatiker Prüfung: AP1 &amp; AP2 verständlich erklärt</h1>
        <p className="pl-lead">
          Ablauf, Gewichtung und alle Themen der gestreckten Abschlussprüfung —
          für Fachinformatiker Anwendungsentwicklung und Systemintegration. Hier
          bekommst du den kompletten Überblick und die passenden Übungen dazu.
        </p>

        <div className="pl-cta-row">
          <Link href="/signup" className="pl-btn pl-btn-primary">Kostenlos üben</Link>
          <Link href="/pruefungen" className="pl-btn pl-btn-ghost">Alle Prüfungen ansehen</Link>
        </div>

        <h2>Die gestreckte Abschlussprüfung</h2>
        <p>
          Seit der Ausbildungsordnung von 2020 gibt es für Fachinformatiker keine
          klassische Zwischenprüfung mehr. Stattdessen ist die Abschlussprüfung
          <strong> „gestreckt"</strong>: Sie besteht aus zwei zeitlich getrennten
          Teilen. <strong>Teil 1 (AP1)</strong> wird etwa in der Mitte der Ausbildung
          geschrieben und zählt bereits zur Endnote. <strong>Teil 2 (AP2)</strong>{" "}
          folgt am Ende der Ausbildung. Beide Teile zusammen ergeben deine Gesamtnote —
          im Verhältnis <strong>20 zu 80 Prozent</strong>.
        </p>

        <h2>AP1 — Teil 1 der Prüfung</h2>
        <p>
          Die AP1 besteht aus dem Prüfungsbereich{" "}
          <strong>„Einrichten eines IT-gestützten Arbeitsplatzes"</strong>, dauert{" "}
          <strong>90 Minuten</strong> und wird in der Regel gegen Ende des zweiten
          Ausbildungsjahres geschrieben. Wichtig: Das Ergebnis zählt{" "}
          <strong>endgültig mit 20 Prozent</strong> zur Gesamtnote und kann nicht
          separat wiederholt oder verbessert werden. Ein guter AP1-Schnitt ist also
          bares Geld wert.
        </p>
        <p>
          Typische AP1-Themen sind Zahlensysteme, Netzwerkgrundlagen, einfache
          Berechnungen und kaufmännische Grundlagen — alles Themen, die du{" "}
          <Link href="/lernen">in der Lernarena üben</Link> kannst.
        </p>

        <h2>AP2 — Teil 2 der Prüfung</h2>
        <p>
          Die AP2 macht <strong>80 Prozent</strong> der Gesamtnote aus und findet am
          Ende der Ausbildung statt. Herzstück ist ein{" "}
          <strong>betriebliches Projekt</strong> (Projektarbeit mit Dokumentation,
          anschließender Präsentation und Fachgespräch). Dazu kommen drei schriftliche
          Prüfungsbereiche. Der genaue Zuschnitt hängt von deiner Fachrichtung ab:
        </p>

        <h3>Anwendungsentwicklung (FIAE)</h3>
        <table className="pl-table">
          <thead>
            <tr><th>Prüfungsbereich</th><th>Form</th><th>Anteil</th></tr>
          </thead>
          <tbody>
            <tr><td>Planen und Umsetzen eines Softwareprojektes</td><td>Projekt + Doku + Fachgespräch</td><td>50 %</td></tr>
            <tr><td>Planen eines Softwareproduktes</td><td>90 Min schriftlich</td><td>10 %</td></tr>
            <tr><td>Entwicklung und Umsetzung von Algorithmen</td><td>90 Min schriftlich</td><td>10 %</td></tr>
            <tr><td>Wirtschafts- und Sozialkunde</td><td>60 Min schriftlich</td><td>10 %</td></tr>
          </tbody>
        </table>

        <h3>Systemintegration (FISI)</h3>
        <table className="pl-table">
          <thead>
            <tr><th>Prüfungsbereich</th><th>Form</th><th>Anteil</th></tr>
          </thead>
          <tbody>
            <tr><td>Planen und Umsetzen eines Projektes der Systemintegration</td><td>Projekt + Doku + Fachgespräch</td><td>50 %</td></tr>
            <tr><td>Konzeption und Administration von IT-Systemen</td><td>90 Min schriftlich</td><td>10 %</td></tr>
            <tr><td>Analyse und Entwicklung von Netzwerken</td><td>90 Min schriftlich</td><td>10 %</td></tr>
            <tr><td>Wirtschafts- und Sozialkunde</td><td>60 Min schriftlich</td><td>10 %</td></tr>
          </tbody>
        </table>
        <p>
          Zusammen mit den 20 Prozent aus der AP1 ergibt sich daraus deine
          Gesamtnote. Man muss in beiden Teilen und in den Prüfungsbereichen jeweils
          ausreichende Leistungen erbringen, um zu bestehen.
        </p>

        <h2>Alle Themen zum Üben</h2>
        <p>
          Diese Themen kommen in AP1 und AP2 immer wieder vor. Jede Seite erklärt das
          Thema Schritt für Schritt und hat interaktive Übungsaufgaben:
        </p>
        <div className="pl-topics">
          {gruppen.map((g) => (
            <div key={g} className="pl-topic-group">
              <h3>{g}</h3>
              {themen
                .filter((t) => t.gruppe === g)
                .map((t) => (
                  <Link key={t.href} href={t.href}>
                    {t.titel} →
                  </Link>
                ))}
            </div>
          ))}
        </div>

        <h2>Wie bereite ich mich am besten vor?</h2>
        <div className="pl-card">
          <p>
            <strong>1. Früh mit der AP1 anfangen.</strong> Weil sie 20 Prozent zählt
            und nicht wiederholbar ist, lohnt sich jeder Punkt.
          </p>
          <p>
            <strong>2. Mit echten Prüfungen üben.</strong> Nichts bereitet besser vor
            als Aufgaben im Originalformat. In der Lernarena findest du{" "}
            <Link href="/pruefungen">echte IHK-Prüfungen</Link> zum Durcharbeiten.
          </p>
          <p>
            <strong>3. Schwächen gezielt schließen.</strong> Nutze die Themenseiten
            oben, um genau die Bereiche zu üben, in denen du unsicher bist — mit
            sofortigem Feedback und einem KI-Tutor, der jeden Schritt erklärt.
          </p>
        </div>

        <h2>Häufige Fragen</h2>
        {faq.map((f) => (
          <div key={f.q} className="pl-card">
            <h3 style={{ marginTop: 0 }}>{f.q}</h3>
            <p style={{ marginBottom: 0 }}>{f.a}</p>
          </div>
        ))}

        <section className="pl-final">
          <h2>Bereit für deine Prüfung?</h2>
          <p>
            Übe mit echten IHK-Prüfungen, interaktiven Aufgaben und einem KI-Tutor,
            der dir jeden Schritt erklärt — kostenlos starten und direkt loslegen.
          </p>
          <div className="pl-cta-row" style={{ justifyContent: "center" }}>
            <Link href="/signup" className="pl-btn pl-btn-primary">Jetzt kostenlos starten</Link>
            <Link href="/pruefungen" className="pl-btn pl-btn-ghost">Alle Prüfungen ansehen</Link>
          </div>
        </section>
      </div>
    </main>
  );
}
