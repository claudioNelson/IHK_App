import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag } from "../lernen/_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../lernen/_components/LsBausteine";
import { PfeilIcon } from "../lernen/_components/LsIcons";

export const metadata: Metadata = {
  title: "Fachinformatiker Prüfung AP1 und AP2: Ablauf, Themen und Vorbereitung",
  description:
    "Die Fachinformatiker-Prüfung verständlich erklärt: Ablauf der gestreckten Abschlussprüfung (AP1 und AP2), Gewichtung, Prüfungsbereiche für Anwendungsentwicklung und Systemintegration sowie alle wichtigen Themen zum Üben.",
  alternates: {
    canonical: "https://lernarena.app/fachinformatiker-pruefung",
  },
  openGraph: {
    type: "article",
    locale: "de_DE",
    url: "https://lernarena.app/fachinformatiker-pruefung",
    siteName: "Lernarena",
    title: "Fachinformatiker Prüfung AP1 und AP2: Ablauf, Themen und Vorbereitung",
    description:
      "Gestreckte Abschlussprüfung erklärt: AP1 und AP2, Gewichtung, Prüfungsbereiche und alle Themen zum Üben.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "gestreckt", titel: "Gestreckte Prüfung" },
  { id: "ap1", titel: "AP1: Teil 1" },
  { id: "ap2", titel: "AP2: Teil 2" },
  { id: "themen", titel: "Alle Themen zum Üben" },
  { id: "vorbereitung", titel: "Vorbereitung" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 6 Minuten" },
  { icon: "pruefung", text: "AP1 und AP2" },
  { icon: "themen", text: "FIAE und FISI" },
];

const gewichtung: { teil: string; anteil: string }[] = [
  { teil: "AP1, Mitte der Ausbildung", anteil: "20 %" },
  { teil: "AP2, betriebliches Projekt", anteil: "50 %" },
  { teil: "AP2, drei schriftliche Bereiche", anteil: "30 %" },
];

type Bereich = { bereich: string; form: string; anteil: string };

const fiae: Bereich[] = [
  { bereich: "Planen und Umsetzen eines Softwareprojektes", form: "Projekt, Doku und Fachgespräch", anteil: "50 %" },
  { bereich: "Planen eines Softwareproduktes", form: "90 Minuten, schriftlich", anteil: "10 %" },
  { bereich: "Entwicklung und Umsetzung von Algorithmen", form: "90 Minuten, schriftlich", anteil: "10 %" },
  { bereich: "Wirtschafts- und Sozialkunde", form: "60 Minuten, schriftlich", anteil: "10 %" },
];

const fisi: Bereich[] = [
  { bereich: "Planen und Umsetzen eines Projektes der Systemintegration", form: "Projekt, Doku und Fachgespräch", anteil: "50 %" },
  { bereich: "Konzeption und Administration von IT-Systemen", form: "90 Minuten, schriftlich", anteil: "10 %" },
  { bereich: "Analyse und Entwicklung von Netzwerken", form: "90 Minuten, schriftlich", anteil: "10 %" },
  { bereich: "Wirtschafts- und Sozialkunde", form: "60 Minuten, schriftlich", anteil: "10 %" },
];

const themen: { href: string; titel: string; gruppe: string }[] = [
  { href: "/lernen/subnetting", titel: "Subnetting", gruppe: "Netzwerk" },
  { href: "/lernen/ip-adressen", titel: "IP-Adressen und IPv6", gruppe: "Netzwerk" },
  { href: "/lernen/osi-modell", titel: "OSI-Modell", gruppe: "Netzwerk" },
  { href: "/lernen/sql", titel: "SQL", gruppe: "Datenbanken" },
  { href: "/lernen/er-diagramm", titel: "ER-Diagramm", gruppe: "Datenbanken" },
  { href: "/lernen/normalisierung", titel: "Normalisierung", gruppe: "Datenbanken" },
  { href: "/lernen/zahlensysteme", titel: "Zahlensysteme", gruppe: "Grundlagen (AP1)" },
  { href: "/lernen/sortieralgorithmen", titel: "Sortieralgorithmen", gruppe: "Anwendungsentwicklung" },
  { href: "/lernen/raid", titel: "RAID-Level", gruppe: "Systemintegration" },
  { href: "/lernen/nutzwertanalyse", titel: "Nutzwertanalyse", gruppe: "WiSo und AP1" },
];

const faq: FaqEintrag[] = [
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
    a: "Die AP1 wird etwa in der Mitte der Ausbildung geschrieben, in der Regel gegen Ende des zweiten Ausbildungsjahres. Sie besteht aus dem Prüfungsbereich „Einrichten eines IT-gestützten Arbeitsplatzes“ und dauert 90 Minuten.",
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

function BereichTabelle({ label, zeilen }: { label: string; zeilen: Bereich[] }) {
  return (
    <div className="ls-table-wrap" role="region" aria-label={label} tabIndex={0}>
      <table className="ls-table">
        <thead>
          <tr>
            <th scope="col">Prüfungsbereich</th>
            <th scope="col">Form</th>
            <th scope="col" className="num">
              Anteil
            </th>
          </tr>
        </thead>
        <tbody>
          {zeilen.map((z) => (
            <tr key={z.bereich}>
              <td className="txt">{z.bereich}</td>
              <td className="txt">{z.form}</td>
              <td className="num">{z.anteil}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function FachinformatikerPruefungPage() {
  return (
    <LernSeite
      titel="Fachinformatiker Prüfung: AP1 und AP2 verständlich erklärt"
      lead="Ablauf, Gewichtung und alle Themen der gestreckten Abschlussprüfung für Fachinformatiker Anwendungsentwicklung und Systemintegration. Hier bekommst du den kompletten Überblick und die passenden Übungen dazu."
      pfad="Prüfungs-Guide"
      eltern={null}
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Direkt üben? Die <Link href="/pruefungen">Übungsprüfungen</Link> laufen mit Zeitlimit
          und Korrektur durch Ada.
        </>
      }
      cta={{
        titel: "Bereit für deine Prüfung?",
        text: "Übe mit Prüfungssimulationen im IHK-Stil, interaktiven Aufgaben und der KI-Tutorin Ada, die dir jeden Schritt erklärt. Kostenlos starten und direkt loslegen.",
      }}
    >
      <LsAbschnitt id="gestreckt" titel="Die gestreckte Abschlussprüfung">
        <p>
          Seit der Ausbildungsordnung von 2020 gibt es für Fachinformatiker keine klassische
          Zwischenprüfung mehr. Stattdessen ist die Abschlussprüfung <strong>„gestreckt“</strong>:
          Sie besteht aus zwei zeitlich getrennten Teilen. <strong>Teil 1 (AP1)</strong> wird etwa
          in der Mitte der Ausbildung geschrieben und zählt bereits zur Endnote.{" "}
          <strong>Teil 2 (AP2)</strong> folgt am Ende der Ausbildung. Beide Teile zusammen ergeben
          deine Gesamtnote, und zwar im Verhältnis <strong>20 zu 80 Prozent</strong>.
        </p>
        <dl className="ls-result" aria-label="Gewichtung der Gesamtnote">
          {gewichtung.map((g) => (
            <div key={g.teil}>
              <dt>{g.teil}</dt>
              <dd>{g.anteil}</dd>
            </div>
          ))}
        </dl>
      </LsAbschnitt>

      <LsAbschnitt id="ap1" titel="AP1: Teil 1 der Prüfung">
        <p>
          Die AP1 besteht aus dem Prüfungsbereich{" "}
          <strong>„Einrichten eines IT-gestützten Arbeitsplatzes“</strong>, dauert{" "}
          <strong>90 Minuten</strong> und wird in der Regel gegen Ende des zweiten
          Ausbildungsjahres geschrieben.
        </p>
        <LsHinweis art="warnung" titel="Die AP1 zählt endgültig" label="Wichtig">
          <p>
            Das Ergebnis zählt mit <strong>20 Prozent</strong> zur Gesamtnote und kann nicht
            separat wiederholt oder verbessert werden. Ein guter AP1-Schnitt ist also bares Geld
            wert.
          </p>
        </LsHinweis>
        <p>
          Typische AP1-Themen sind Zahlensysteme, Netzwerkgrundlagen, einfache Berechnungen und
          kaufmännische Grundlagen: alles Themen, die du{" "}
          <Link href="/lernen">in der Lernarena üben</Link> kannst.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="ap2" titel="AP2: Teil 2 der Prüfung">
        <p>
          Die AP2 macht <strong>80 Prozent</strong> der Gesamtnote aus und findet am Ende der
          Ausbildung statt. Herzstück ist ein <strong>betriebliches Projekt</strong>{" "}
          (Projektarbeit mit Dokumentation, anschließender Präsentation und Fachgespräch). Dazu
          kommen drei schriftliche Prüfungsbereiche. Der genaue Zuschnitt hängt von deiner
          Fachrichtung ab:
        </p>
        <h3>Anwendungsentwicklung (FIAE)</h3>
        <BereichTabelle label="Prüfungsbereiche Anwendungsentwicklung" zeilen={fiae} />
        <h3>Systemintegration (FISI)</h3>
        <BereichTabelle label="Prüfungsbereiche Systemintegration" zeilen={fisi} />
        <p className="ls-nach-tabelle">
          Zusammen mit den 20 Prozent aus der AP1 ergibt sich daraus deine Gesamtnote. Man muss in
          beiden Teilen und in den Prüfungsbereichen jeweils ausreichende Leistungen erbringen, um
          zu bestehen.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="themen" titel="Alle Themen zum Üben">
        <p>
          Diese Themen kommen in AP1 und AP2 immer wieder vor. Jede Seite erklärt das Thema
          Schritt für Schritt und hat interaktive Übungsaufgaben:
        </p>
        <ul className="ls-related">
          {themen.map((t) => (
            <li key={t.href}>
              <Link href={t.href}>
                <span>
                  {t.titel}
                  <small>{t.gruppe}</small>
                </span>
                <PfeilIcon />
              </Link>
            </li>
          ))}
        </ul>
      </LsAbschnitt>

      <LsAbschnitt id="vorbereitung" titel="Wie bereite ich mich am besten vor?">
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Früh mit der AP1 anfangen</h3>
              <p>Weil sie 20 Prozent zählt und nicht wiederholbar ist, lohnt sich jeder Punkt.</p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Mit Prüfungssimulationen üben</h3>
              <p>
                Nichts bereitet besser vor als Aufgaben im Format und Umfang der IHK. In der
                Lernarena findest du <Link href="/pruefungen">Übungsprüfungen im IHK-Stil</Link>{" "}
                mit KI-Korrektur.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Schwächen gezielt schließen</h3>
              <p>
                Nutze die Themenseiten oben, um genau die Bereiche zu üben, in denen du unsicher
                bist, mit sofortigem Feedback und der KI-Tutorin Ada, die jeden Schritt erklärt.
              </p>
            </div>
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
