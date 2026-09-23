import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "OSI-Modell einfach erklärt: die 7 Schichten (IHK)",
  description:
    "Das OSI-Modell einfach erklärt: alle 7 Schichten mit Protokollen, Geräten und Merksatz, plus interaktive Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/osi-modell",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/osi-modell",
    title: "OSI-Modell einfach erklärt: die 7 Schichten (IHK)",
    description:
      "Alle 7 Schichten des OSI-Modells mit Protokollen, Geräten und Merksatz für die Fachinformatiker-Prüfung.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "was-ist-osi", titel: "Was ist das OSI-Modell?" },
  { id: "schichten", titel: "Die 7 Schichten" },
  { id: "merksatz", titel: "Merksatz" },
  { id: "geraete", titel: "Gerät zuordnen" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 6 Minuten" },
  { icon: "rechner", text: "Schichtentabelle mit Protokollen und Geräten" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1 und AP2" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/ip-adressen", titel: "IP-Adressen und IPv6", untertitel: "Private Bereiche, APIPA, IPv6-Kürzung" },
  { href: "/lernen/subnetting", titel: "Subnetting üben", untertitel: "Maske, Blockgröße, Broadcast" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const schichten: { nr: string; name: string; beispiele: string; geraete: string }[] = [
  { nr: "7", name: "Anwendung (Application)", beispiele: "HTTP, SMTP, DNS, FTP", geraete: "Gateway, Proxy" },
  { nr: "6", name: "Darstellung (Presentation)", beispiele: "TLS/SSL, Zeichencodierung", geraete: "keine" },
  { nr: "5", name: "Sitzung (Session)", beispiele: "Sitzungsauf- und -abbau", geraete: "keine" },
  { nr: "4", name: "Transport", beispiele: "TCP, UDP (Ports)", geraete: "Firewall (L4)" },
  { nr: "3", name: "Vermittlung (Network)", beispiele: "IP, ICMP, Routing", geraete: "Router, Layer-3-Switch" },
  { nr: "2", name: "Sicherung (Data Link)", beispiele: "Ethernet, MAC-Adressen, VLAN", geraete: "Switch, Bridge" },
  { nr: "1", name: "Bitübertragung (Physical)", beispiele: "Kabel, Stecker, Funk, Bits", geraete: "Hub, Repeater" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist das OSI-Modell?",
    a: "Das OSI-Modell (Open Systems Interconnection) ist ein Referenzmodell, das die Netzwerkkommunikation in 7 Schichten aufteilt, von der Bitübertragung (Schicht 1) bis zur Anwendung (Schicht 7). Jede Schicht hat eine klar definierte Aufgabe.",
  },
  {
    q: "Wie merke ich mir die 7 Schichten?",
    a: "Ein bewährter deutscher Merksatz von Schicht 7 nach 1 ist: „Alle deutschen Studenten trinken verschiedene Sorten Bier“. Das steht für: Anwendung, Darstellung, Sitzung, Transport, Vermittlung, Sicherung, Bitübertragung.",
  },
  {
    q: "Auf welcher OSI-Schicht arbeitet ein Router?",
    a: "Ein Router arbeitet auf Schicht 3 (Vermittlungsschicht) und trifft Weiterleitungsentscheidungen anhand von IP-Adressen. Ein Switch arbeitet dagegen auf Schicht 2 mit MAC-Adressen, ein Hub auf Schicht 1.",
  },
  {
    q: "Was ist der Unterschied zwischen OSI- und TCP/IP-Modell?",
    a: "Das OSI-Modell hat 7 Schichten und ist ein theoretisches Referenzmodell. Das TCP/IP-Modell hat 4 Schichten (Netzzugang, Internet, Transport, Anwendung) und beschreibt die Praxis des Internets. Die Schichten lassen sich ineinander überführen.",
  },
];

export default function OsiModellPage() {
  return (
    <LernSeite
      titel="OSI-Modell einfach erklärt: die 7 Schichten"
      lead="Das OSI-Modell ist das Grundgerüst der Netzwerktechnik und ein Dauergast in der IHK-Prüfung. Hier lernst du alle 7 Schichten mit typischen Protokollen und Geräten sowie einen bewährten Merksatz. Danach testest du dich direkt selbst."
      pfad="OSI-Modell"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Schicht 3 vertiefen: Wie IP-Adressen aufgebaut sind, steht unter{" "}
          <Link href="/lernen/ip-adressen">IP-Adressen und IPv6</Link>.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "Netzwerktechnik interaktiv trainieren.",
        text: "In der Lernarena übst du OSI-Modell, Subnetting und mehr mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jede Zuordnung erklärt.",
      }}
    >
      <LsAbschnitt id="was-ist-osi" titel="Was ist das OSI-Modell?">
        <p>
          Das <strong>OSI-Modell</strong> (Open Systems Interconnection) teilt die
          Netzwerkkommunikation in <strong>7 Schichten</strong> auf. Jede Schicht hat eine
          klar abgegrenzte Aufgabe und kommuniziert nur mit der Schicht direkt über und unter
          ihr. So lassen sich Protokolle, Geräte und Fehlerquellen sauber einordnen. Genau das
          wird in der Prüfung abgefragt.
        </p>
        <LsHinweis titel="Merkhilfe: der Paketversand" icon="stapel" label="Merkhilfe">
          <p>
            Deine Nachricht (oben, Schicht 7) wird auf dem Weg nach unten Schicht für Schicht
            in einen weiteren Umschlag gepackt: Absender und Empfänger drauf, Portoetikett, ab
            in den Transporter. Beim Empfänger wird jeder Umschlag in umgekehrter Reihenfolge
            wieder ausgepackt, bis die eigentliche Nachricht oben ankommt. Dieses Ein- und
            Auspacken nennt man <strong>Kapselung</strong> (Encapsulation). Dabei fügt jede
            Schicht ihren eigenen „Umschlag“ (Header) hinzu.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="schichten" titel="Die 7 Schichten im Überblick">
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Die 7 OSI-Schichten, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col" className="num">Nr.</th>
                <th scope="col">Schicht</th>
                <th scope="col">Beispiele</th>
                <th scope="col">Geräte</th>
              </tr>
            </thead>
            <tbody>
              {schichten.map((s) => (
                <tr key={s.nr}>
                  <td className="num">{s.nr}</td>
                  <td className="txt">{s.name}</td>
                  <td className="txt">{s.beispiele}</td>
                  <td className="txt">{s.geraete}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="merksatz" titel="Merksatz für die Prüfung">
        <p>
          Von Schicht 7 nach 1:{" "}
          <strong>„Alle deutschen Studenten trinken verschiedene Sorten Bier“</strong>. Das
          steht für: Anwendung, Darstellung, Sitzung, Transport, Vermittlung, Sicherung,
          Bitübertragung.
        </p>
        <p>
          Die Dateneinheiten von unten nach oben: <code>Bits</code> (L1), <code>Frames</code>{" "}
          (L2), <code>Pakete</code> (L3), <code>Segmente</code> (L4), darüber spricht man von
          Daten.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="geraete" titel="Typische Prüfungsfrage: Gerät zuordnen">
        <p>
          Ein <strong>Hub</strong> arbeitet auf Schicht 1, er verstärkt nur Signale. Ein{" "}
          <strong>Switch</strong> arbeitet auf Schicht 2 und entscheidet anhand von{" "}
          <strong>MAC-Adressen</strong>. Ein <strong>Router</strong> arbeitet auf Schicht 3
          und entscheidet anhand von <strong>IP-Adressen</strong>. Diese Zuordnung wird in
          fast jeder Prüfung in irgendeiner Form abgefragt.
        </p>
        <LsHinweis titel="Prüfungstipp: Geräte auf einen Blick">
          <p>
            <code>Hub = 1</code> (nur Signale), <code>Switch = 2</code> (MAC-Adressen),{" "}
            <code>Router = 3</code> (IP-Adressen). Merke: Je „schlauer“ das Gerät, desto
            höher die Schicht. Und der Klassiker: <strong>TCP und UDP arbeiten mit Ports</strong>{" "}
            auf Schicht 4, <strong>IP</strong> mit Adressen auf Schicht 3.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Schicht 2 und 3 verwechseln: <strong>MAC</strong>-Adresse = Schicht 2,{" "}
              <strong>IP</strong>-Adresse = Schicht 3.
            </li>
            <li>
              Die Dateneinheiten durcheinanderbringen. Von unten: <code>Bits</code>,{" "}
              <code>Frames</code>, <code>Pakete</code>, <code>Segmente</code>.
            </li>
            <li>
              TLS/SSL auf Schicht 7 statt 6 einordnen. Verschlüsselung und Darstellung sind
              Schicht 6.
            </li>
            <li>
              Die Schichten falsch herum zählen. Schicht <strong>1 ist unten</strong> (Kabel),
              Schicht 7 oben (Anwendung).
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
          frage="Auf welcher OSI-Schicht arbeitet ein Router?"
          optionen={[
            { text: "Schicht 2 (Sicherung)", richtig: false },
            { text: "Schicht 3 (Vermittlung)", richtig: true },
            { text: "Schicht 4 (Transport)", richtig: false },
            { text: "Schicht 7 (Anwendung)", richtig: false },
          ]}
          erklaerung="Ein Router leitet Pakete anhand von IP-Adressen weiter. Das ist Schicht 3, die Vermittlungsschicht (Network Layer)."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Welche Dateneinheit gehört zu Schicht 2 (Sicherungsschicht)?"
          optionen={[
            { text: "Segmente", richtig: false },
            { text: "Pakete", richtig: false },
            { text: "Frames", richtig: true },
            { text: "Bits", richtig: false },
          ]}
          erklaerung="Schicht 2 arbeitet mit Frames. Von unten nach oben: Bits (L1), Frames (L2), Pakete (L3), Segmente (L4)."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Welche Protokolle gehören zur Transportschicht (Schicht 4)?"
          optionen={[
            { text: "IP und ICMP", richtig: false },
            { text: "TCP und UDP", richtig: true },
            { text: "HTTP und DNS", richtig: false },
            { text: "Ethernet und VLAN", richtig: false },
          ]}
          erklaerung="TCP und UDP sind die Transportprotokolle der Schicht 4 und adressieren über Ports. IP und ICMP gehören zu Schicht 3, HTTP und DNS zu Schicht 7."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Auf welcher Schicht arbeitet ein Switch?"
          optionen={[
            { text: "Schicht 1 (Bitübertragung)", richtig: false },
            { text: "Schicht 2 (Sicherung)", richtig: true },
            { text: "Schicht 3 (Vermittlung)", richtig: false },
            { text: "Schicht 4 (Transport)", richtig: false },
          ]}
          erklaerung="Ein Switch entscheidet anhand von MAC-Adressen und arbeitet damit auf Schicht 2 (Sicherungsschicht). Ein Hub wäre Schicht 1, ein Router Schicht 3."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Auf welcher Schicht ist die Verschlüsselung (TLS/SSL) angesiedelt?"
          optionen={[
            { text: "Schicht 4 (Transport)", richtig: false },
            { text: "Schicht 5 (Sitzung)", richtig: false },
            { text: "Schicht 6 (Darstellung)", richtig: true },
            { text: "Schicht 7 (Anwendung)", richtig: false },
          ]}
          erklaerung="Die Darstellungsschicht (Schicht 6) kümmert sich um Codierung und Verschlüsselung. Dort ist TLS/SSL klassisch eingeordnet."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
