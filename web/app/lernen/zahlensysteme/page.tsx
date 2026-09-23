import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Zahlensysteme: binär, dezimal, hexadezimal (IHK)",
  description:
    "Binär, dezimal und hexadezimal sicher umrechnen: Divisionsverfahren, Stellenwert und Vierergruppen einfach erklärt, mit interaktiven Übungsaufgaben für die IHK-Prüfung (AP1).",
  alternates: {
    canonical: "https://lernarena.app/lernen/zahlensysteme",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/zahlensysteme",
    title: "Zahlensysteme: binär, dezimal, hexadezimal (IHK)",
    description:
      "Binär, dezimal, hexadezimal umrechnen: Schritt für Schritt mit Übungsaufgaben für AP1 und AP2.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "vergleich", titel: "Die drei Systeme" },
  { id: "dezimal-binaer", titel: "Dezimal in Binär" },
  { id: "binaer-dezimal", titel: "Binär in Dezimal" },
  { id: "binaer-hex", titel: "Binär in Hex" },
  { id: "hex-dezimal", titel: "Hex in Dezimal" },
  { id: "stellenwerte", titel: "Stellenwerte" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 9 Minuten" },
  { icon: "rechner", text: "4 Umrechnungswege mit Beispielen" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1, Grundlage für Subnetting" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/subnetting", titel: "Subnetting üben", untertitel: "Maske, Blockgröße, Broadcast" },
  { href: "/lernen/ip-adressen", titel: "IP-Adressen und IPv6", untertitel: "Private Bereiche, APIPA, IPv6-Kürzung" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const HEX = "0123456789ABCDEF";
const tabelle = Array.from({ length: 16 }, (_, i) => ({
  dez: String(i),
  bin: i.toString(2).padStart(4, "0"),
  hex: HEX[i],
}));

const faq: FaqEintrag[] = [
  {
    q: "Wie rechne ich eine Dezimalzahl in eine Binärzahl um?",
    a: "Mit dem Divisionsverfahren: die Zahl fortlaufend durch 2 teilen und die Reste notieren. Die Reste von unten nach oben gelesen ergeben die Binärzahl. Beispiel: 172 ergibt 10101100.",
  },
  {
    q: "Wie rechne ich binär in hexadezimal um?",
    a: "Die Binärzahl von rechts in Vierergruppen aufteilen und jede Gruppe einzeln übersetzen, denn ein Hex-Zeichen entspricht genau 4 Bit. 10101100 wird zu 1010|1100, also A und C. Das Ergebnis ist AC.",
  },
  {
    q: "Wie rechne ich hexadezimal in dezimal um?",
    a: "Jede Hex-Stelle mit ihrem Stellenwert (…, 256, 16, 1) multiplizieren und addieren. A entspricht 10, B=11, C=12, D=13, E=14, F=15. Beispiel: 2F = 2×16 + 15 = 47.",
  },
  {
    q: "Was ist der Unterschied zwischen Bit und Byte?",
    a: "Ein Bit ist die kleinste Einheit und kann nur 0 oder 1 sein. Ein Byte besteht aus 8 Bit und kann 2^8 = 256 verschiedene Werte darstellen (0 bis 255). Ein Oktett einer IPv4-Adresse ist genau ein Byte.",
  },
  {
    q: "Warum wird in der IT hexadezimal verwendet?",
    a: "Weil ein Hex-Zeichen exakt 4 Bit darstellt, lassen sich lange Bitfolgen kompakt schreiben. MAC-Adressen, IPv6-Adressen, Farbcodes und Speicheradressen werden deshalb hexadezimal notiert.",
  },
  {
    q: "Kommen Zahlensysteme in der IHK-Prüfung vor?",
    a: "Ja, vor allem in der AP1: Umrechnungen zwischen dezimal, binär und hexadezimal gehören zu den Standardaufgaben und sind außerdem die Grundlage für Subnetting-Aufgaben.",
  },
];

export default function ZahlensystemePage() {
  return (
    <LernSeite
      titel="Zahlensysteme umrechnen: binär, dezimal und hexadezimal"
      lead="Zahlensysteme sind Pflichtstoff in der AP1 und tauchen auch in der AP2 immer wieder auf, von IP-Adressen bis Speicheradressen. Hier lernst du die Umrechnungswege Schritt für Schritt und übst direkt interaktiv."
      pfad="Zahlensysteme"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Die Stellenwerte eines Bytes brauchst du gleich wieder beim{" "}
          <Link href="/lernen/subnetting">Subnetting</Link>.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "Zahlensysteme interaktiv trainieren.",
        text: "In der Lernarena übst du Umrechnungen mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jeden Rechenweg erklärt.",
      }}
    >
      <LsAbschnitt id="vergleich" titel="Die drei Systeme im Vergleich">
        <p>
          <strong>Dezimal</strong> (Basis 10) nutzt die Ziffern 0 bis 9,{" "}
          <strong>Binär</strong> (Basis 2) nur 0 und 1, und <strong>Hexadezimal</strong>{" "}
          (Basis 16) die Zeichen 0 bis 9 und A bis F. Ein Hex-Zeichen entspricht genau{" "}
          <strong>4 Bit</strong>, deshalb ist Hex die Kurzschreibweise der IT
          (MAC-Adressen, IPv6, Farbcodes).
        </p>
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Werte 0 bis 15 in dezimal, binär und hexadezimal, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col" className="num">Dezimal</th>
                <th scope="col" className="num">Binär</th>
                <th scope="col" className="num">Hex</th>
              </tr>
            </thead>
            <tbody>
              {tabelle.map((z) => (
                <tr key={z.dez}>
                  <td className="num">{z.dez}</td>
                  <td className="num">{z.bin}</td>
                  <td className="num">{z.hex}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="dezimal-binaer" titel="Dezimal in Binär: das Divisionsverfahren">
        <p className="ls-task">
          <strong>Beispiel:</strong> <code>172</code> in Binär. Teile fortlaufend durch 2 und
          notiere die Reste.
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`172 : 2 = 86   Rest 0
 86 : 2 = 43   Rest 0
 43 : 2 = 21   Rest 1
 21 : 2 = 10   Rest 1
 10 : 2 =  5   Rest 0
  5 : 2 =  2   Rest 1
  2 : 2 =  1   Rest 0
  1 : 2 =  0   Rest 1`}</code>
        </pre>
        <p>
          Die Reste <strong>von unten nach oben</strong> gelesen: <code>10101100</code>.
          Gegenprobe über die Stellenwerte: 128 + 32 + 8 + 4 = 172, stimmt.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="binaer-dezimal" titel="Binär in Dezimal: Stellenwerte addieren">
        <p>
          Das ist der schnellste Weg und für ein Byte im Kopf machbar. Schreibe über jedes
          Bit seinen Stellenwert und addiere überall dort, wo eine <code>1</code> steht.
        </p>
        <p className="ls-task">
          <strong>Beispiel:</strong> <code>10101100</code>
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`128  64  32  16   8   4   2   1
  1   0   1   0   1   1   0   0`}</code>
        </pre>
        <p>
          Gesetzte Bits: 128 + 32 + 8 + 4 = <strong>172</strong>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="binaer-hex" titel="Binär in Hex: Vierergruppen">
        <p>
          Teile die Binärzahl von rechts in Vierergruppen und übersetze jede Gruppe einzeln:{" "}
          <code>10101100</code> wird zu <code>1010</code> | <code>1100</code>, also{" "}
          <code>A</code> und <code>C</code>, zusammen <code>AC</code>. Rückwärts genauso:
          jedes Hex-Zeichen in 4 Bit auflösen.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="hex-dezimal" titel="Hex in Dezimal: Schritt für Schritt">
        <p>
          Jede Hex-Stelle hat einen Stellenwert: von rechts nach links{" "}
          <code>1, 16, 256, 4096 …</code> (also 16 hoch 0, 1, 2, 3). Multipliziere jede
          Stelle mit ihrem Wert und addiere. Die Buchstaben stehen für <code>A=10</code> bis{" "}
          <code>F=15</code>.
        </p>
        <p className="ls-task">
          <strong>Beispiel:</strong> <code>2F</code> in Dezimal.
        </p>
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Einerstelle</h3>
              <p>
                <code>F</code> = 15 steht an der 1er-Stelle, also 15 × 1 = 15.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Sechzehnerstelle</h3>
              <p>
                <code>2</code> steht an der 16er-Stelle, also 2 × 16 = 32.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Addieren und prüfen</h3>
              <p>
                Summe: 32 + 15 = <strong>47</strong>. Gegenprobe binär: <code>2F</code> ={" "}
                <code>0010 1111</code> = 32 + 8 + 4 + 2 + 1 = 47, stimmt.
              </p>
            </div>
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="stellenwerte" titel="Die Stellenwerte, die du auswendig können solltest">
        <p>
          <code>128 · 64 · 32 · 16 · 8 · 4 · 2 · 1</code>: die Wertigkeiten eines Bytes. Wer
          diese Reihe sicher beherrscht, rechnet auch Subnetzmasken ohne Taschenrechner um.
        </p>
        <LsHinweis titel="Prüfungstipp: die 8er-Reihe und zwei Anker">
          <p>
            Präge dir die 8er-Reihe <code>128 64 32 16 8 4 2 1</code> fest ein. Damit rechnest
            du in der Prüfung jedes Oktett (ob bei Zahlensystemen oder Subnetting)
            sekundenschnell und ohne Hilfsmittel um. Und merke dir zwei Anker:{" "}
            <code>FF</code> = 255 und <code>80</code> (hex) = 128.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Beim Divisionsverfahren die Reste <strong>falsch herum</strong> lesen. Sie
              müssen von <em>unten nach oben</em> gelesen werden.
            </li>
            <li>
              Vierergruppen von <strong>links</strong> statt von <strong>rechts</strong>{" "}
              bilden. Bei ungerader Bitzahl links mit Nullen auffüllen.
            </li>
            <li>
              Die Hex-Buchstaben verwechseln: <code>A=10</code>, nicht 1, und{" "}
              <code>F=15</code>, nicht 16.
            </li>
            <li>
              Vergessen, die <strong>Gegenprobe</strong> zu machen. Ein schneller Check über
              die Stellenwerte deckt Rechenfehler sofort auf.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback, so viele Versuche du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Was ist 11001000 in Dezimal?"
          optionen={[
            { text: "196", richtig: false },
            { text: "200", richtig: true },
            { text: "204", richtig: false },
            { text: "212", richtig: false },
          ]}
          erklaerung="Stellenwerte addieren: 128 + 64 + 8 = 200. Die gesetzten Bits stehen an den Positionen 128, 64 und 8."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Welcher Hex-Wert entspricht der Dezimalzahl 255?"
          optionen={[
            { text: "EE", richtig: false },
            { text: "FF", richtig: true },
            { text: "F0", richtig: false },
            { text: "100", richtig: false },
          ]}
          erklaerung="255 = 11111111 in Binär = zwei Vierergruppen 1111|1111 = F und F, also FF. Der Klassiker aus jeder Subnetzmaske."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Was ist Hex B3 in Dezimal?"
          optionen={[
            { text: "163", richtig: false },
            { text: "173", richtig: false },
            { text: "179", richtig: true },
            { text: "183", richtig: false },
          ]}
          erklaerung="B = 11. Also 11 × 16 + 3 = 176 + 3 = 179. Hex rechnet man über die Stellenwerte 16, 256, 4096 usw. um."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wie lautet die Dezimalzahl 45 in Binär?"
          optionen={[
            { text: "101101", richtig: true },
            { text: "101011", richtig: false },
            { text: "110101", richtig: false },
            { text: "100101", richtig: false },
          ]}
          erklaerung="45 = 32 + 8 + 4 + 1, also sind die Bits an den Stellen 32, 8, 4 und 1 gesetzt: 101101. Gegenprobe: 32 + 8 + 4 + 1 = 45, stimmt."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Wie viele verschiedene Werte kann ein Byte (8 Bit) darstellen?"
          optionen={[
            { text: "128", richtig: false },
            { text: "255", richtig: false },
            { text: "256", richtig: true },
            { text: "512", richtig: false },
          ]}
          erklaerung="2^8 = 256 verschiedene Werte, nämlich 0 bis 255. Achtung: 256 Werte, aber der höchste Wert ist 255, ein klassischer Stolperstein."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
