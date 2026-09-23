import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";
import SubnetzRechner from "../_components/SubnetzRechner";

export const metadata: Metadata = {
  title: "Subnetting üben: Rechner, Aufgaben und Lösungen (IHK)",
  description:
    "Subnetting einfach erklärt: mit kostenlosem Subnetz-Rechner inklusive Binär-Rechenweg, Schritt-für-Schritt-Beispiel und interaktiven Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/subnetting",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/subnetting",
    title: "Subnetting üben: Rechner, Aufgaben und Lösungen (IHK)",
    description:
      "Subnetting Schritt für Schritt: Subnetzmaske, CIDR, Netz- und Broadcast-Adresse. Mit interaktiven Übungsaufgaben für die Fachinformatiker-Prüfung.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "was-ist-subnetting", titel: "Was ist Subnetting?" },
  { id: "tabelle", titel: "Werte auf einen Blick" },
  { id: "beispiel", titel: "Beispiel Schritt für Schritt" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "rechner", titel: "Subnetz-Rechner" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 10 Minuten" },
  { icon: "rechner", text: "Rechner mit Binär-Rechenweg" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1 und AP2 Systemintegration" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/ip-adressen", titel: "IP-Adressen und IPv6", untertitel: "Private Bereiche, APIPA, IPv6-Kürzung" },
  { href: "/lernen/zahlensysteme", titel: "Zahlensysteme umrechnen", untertitel: "Binär, dezimal, hexadezimal" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const cidrTable: { cidr: string; mask: string; addr: string; hosts: string }[] = [
  { cidr: "/24", mask: "255.255.255.0", addr: "256", hosts: "254" },
  { cidr: "/25", mask: "255.255.255.128", addr: "128", hosts: "126" },
  { cidr: "/26", mask: "255.255.255.192", addr: "64", hosts: "62" },
  { cidr: "/27", mask: "255.255.255.224", addr: "32", hosts: "30" },
  { cidr: "/28", mask: "255.255.255.240", addr: "16", hosts: "14" },
  { cidr: "/29", mask: "255.255.255.248", addr: "8", hosts: "6" },
  { cidr: "/30", mask: "255.255.255.252", addr: "4", hosts: "2" },
];

const faq: FaqEintrag[] = [
  {
    q: "Was ist Subnetting?",
    a: "Subnetting ist das Aufteilen eines IP-Netzes in mehrere kleinere Teilnetze (Subnetze). Dazu werden Bits aus dem Host-Teil der IP-Adresse für den Netz-Teil verwendet. So lassen sich IP-Adressen effizient nutzen und Netze logisch trennen.",
  },
  {
    q: "Wie berechne ich die Anzahl der nutzbaren Hosts?",
    a: "Die Anzahl nutzbarer Hosts ergibt sich aus 2 hoch (32 minus Präfixlänge) minus 2. Die zwei abgezogenen Adressen sind die Netzadresse und die Broadcast-Adresse. Beispiel: /26 ergibt 2^6 − 2 = 62 nutzbare Hosts.",
  },
  {
    q: "Was bedeutet die CIDR-Schreibweise, z. B. /26?",
    a: "Die Zahl nach dem Schrägstrich (das Präfix) gibt an, wie viele Bits der IP-Adresse zum Netz-Teil gehören. /26 bedeutet, dass die ersten 26 Bit das Netz beschreiben und die restlichen 6 Bit für Hosts zur Verfügung stehen.",
  },
  {
    q: "Wie finde ich heraus, in welchem Subnetz eine IP-Adresse liegt?",
    a: "Berechne zuerst die Blockgröße (256 minus Maskenwert des letzten Oktetts). Dann suchst du das größte Vielfache der Blockgröße, das noch kleiner oder gleich deinem Oktett-Wert ist. Das ist die Netzadresse. Beispiel: 192.168.1.200 bei /26 hat Blockgröße 64, das passende Vielfache ist 192, also liegt sie im Subnetz 192.168.1.192.",
  },
  {
    q: "Was ist der Unterschied zwischen Subnetzmaske und CIDR?",
    a: "Beide beschreiben dasselbe, nur anders geschrieben. Die Subnetzmaske ist die ausführliche Punktschreibweise (z. B. 255.255.255.192), CIDR ist die Kurzform mit dem Präfix (/26). /26 heißt: 26 Bit gehören zum Netz. Genau das drückt auch 255.255.255.192 aus.",
  },
  {
    q: "Kommt Subnetting in der IHK-Prüfung vor?",
    a: "Ja. Subnetting ist ein klassisches Thema in der Abschlussprüfung Teil 1 (AP1) und in der AP2 für Fachinformatiker Systemintegration. Typische Aufgaben sind das Berechnen von Subnetzmaske, Netz- und Broadcast-Adresse sowie der Anzahl der Hosts.",
  },
];

export default function SubnettingPage() {
  return (
    <LernSeite
      titel="Subnetting üben: einfach erklärt, mit Aufgaben und Lösungen"
      lead="Subnetting gehört zu den Klassikern der IHK-Prüfung für Fachinformatiker. Hier lernst du Schritt für Schritt, wie du Subnetzmaske, Netz- und Broadcast-Adresse sowie die Anzahl der Hosts berechnest. Danach übst du es interaktiv in der Lernarena."
      pfad="Subnetting"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Zahlensysteme noch nicht sicher? Dann zuerst{" "}
          <Link href="/lernen/zahlensysteme">Binär und Dezimal umrechnen</Link>, danach fällt
          Subnetting leichter.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "Subnetting interaktiv trainieren.",
        text: "In der Lernarena rechnest du Subnetting-Aufgaben mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jeden Rechenschritt erklärt.",
      }}
    >
      <LsAbschnitt id="was-ist-subnetting" titel="Was ist Subnetting?">
        <p>
          Beim <strong>Subnetting</strong> teilst du ein großes IP-Netz in mehrere kleinere
          Teilnetze auf. Dazu „leihst“ du dir Bits aus dem Host-Teil der IP-Adresse und
          schlägst sie dem Netz-Teil zu. So nutzt du Adressbereiche effizienter und trennst
          Netze logisch, etwa Abteilungen in einer Firma.
        </p>
        <p>
          Eine IPv4-Adresse besteht aus 32 Bit. Die <strong>Subnetzmaske</strong> legt fest,
          welcher Teil davon das Netz beschreibt und welcher die Hosts. In der
          CIDR-Schreibweise steht das als Präfix hinter der Adresse, z. B.{" "}
          <code>192.168.10.0/26</code>. Die ersten 26 Bit sind der Netz-Teil.
        </p>
        <LsHinweis titel="Merkhilfe: das Wohnhaus" icon="haus" label="Merkhilfe">
          <p>
            Die IP-Adresse ist die komplette Anschrift. Der <strong>Netz-Teil</strong> ist
            Straße und Hausnummer (welches Gebäude), der <strong>Host-Teil</strong> ist die
            Wohnungsnummer (welches Gerät im Netz). Subnetting heißt: Du machst aus einem
            großen Haus mehrere kleinere Häuser. Die Subnetzmaske ist die Grenze, die sagt
            „ab hier beginnt die Wohnungsnummer“. Je mehr Bits du dem Netz-Teil gibst
            (größeres Präfix wie /27, /28), desto mehr, aber kleinere Häuser bekommst du.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="tabelle" titel="Die wichtigsten Werte auf einen Blick">
        <p>
          Diese Tabelle solltest du für die Prüfung im Kopf haben. Die nutzbaren Hosts
          berechnen sich immer als <code>2^(32 − Präfix) − 2</code>, weil Netz- und
          Broadcast-Adresse nicht als Host zählen.
        </p>
        <div className="ls-table-wrap" role="region" aria-label="CIDR-Tabelle, seitlich scrollbar" tabIndex={0}>
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">CIDR</th>
                <th scope="col">Subnetzmaske</th>
                <th scope="col" className="num">Adressen</th>
                <th scope="col" className="num">Nutzbare Hosts</th>
              </tr>
            </thead>
            <tbody>
              {cidrTable.map((r) => (
                <tr key={r.cidr}>
                  <td>{r.cidr}</td>
                  <td>{r.mask}</td>
                  <td className="num">{r.addr}</td>
                  <td className="num">{r.hosts}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Beispiel Schritt für Schritt">
        <p className="ls-task">
          <strong>Aufgabe:</strong> Gegeben ist das Netz <code>192.168.10.0/26</code>. Wie
          lauten Subnetzmaske, Blockgröße, Netz- und Broadcast-Adresse des ersten Subnetzes
          und wie viele Hosts sind nutzbar?
        </p>
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Subnetzmaske bestimmen</h3>
              <p>
                /26 bedeutet 26 Einsen. Das letzte Oktett hat also 2 Netz-Bits:{" "}
                <code>11000000</code> = 192. Die Maske ist <code>255.255.255.192</code>.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Blockgröße berechnen</h3>
              <p>
                Blockgröße = 256 − 192 = <strong>64</strong>. Die Subnetze beginnen also bei
                .0, .64, .128 und .192.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Netz- und Broadcast-Adresse</h3>
              <p>
                Erstes Subnetz: Netzadresse <code>192.168.10.0</code>, Broadcast{" "}
                <code>192.168.10.63</code>. Nutzbar sind <code>.1</code> bis <code>.62</code>.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Anzahl Hosts</h3>
              <p>
                2^(32 − 26) − 2 = 2^6 − 2 = <strong>62 nutzbare Hosts</strong> pro Subnetz.
              </p>
            </div>
          </li>
        </ol>
        <LsHinweis titel="Der schnellste Trick ist die Blockgröße">
          <p>
            Rechne einfach <code>256 − Maskenwert</code> des letzten Oktetts. Bei /26 ist die
            Maske 192, also <code>256 − 192 = 64</code>. Diese 64 ist dein „Sprung“: Die
            Subnetze starten bei .0, .64, .128, .192, und der Broadcast liegt immer{" "}
            <strong>eins vor</strong> dem nächsten Start (also .63, .127, .191, .255). Mit
            diesem einen Trick löst du fast jede Subnetting-Aufgabe im Kopf.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Das <strong>−2</strong> bei den Hosts vergessen. Netz- und Broadcast-Adresse
              sind keine nutzbaren Hosts, es sind immer 2 weniger.
            </li>
            <li>
              Broadcast und nächste Netzadresse verwechseln: Der Broadcast ist die{" "}
              <strong>letzte</strong> Adresse im Block (z. B. .63), nicht die erste des
              nächsten (.64).
            </li>
            <li>
              Größeres Präfix = <strong>kleineres</strong> Netz. /28 hat weniger Hosts als
              /26, nicht mehr. Das ist ein häufiger Denkfehler.
            </li>
            <li>
              Die Blockgröße im falschen Oktett anwenden. Prüfe zuerst, in welchem Oktett
              sich die Maske überhaupt ändert.
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="rechner" titel="Subnetz-Rechner mit Rechenweg">
        <p>
          Gib eine IP-Adresse und ein Präfix ein. Der Rechner liefert Subnetzmaske, Netz- und
          Broadcast-Adresse samt Host-Bereich. Auf Wunsch zeigt er dir den{" "}
          <strong>kompletten Rechenweg in Binärdarstellung</strong>, mit farbig markierter
          Grenze zwischen Netz- und Host-Teil.
        </p>
        <SubnetzRechner />
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback, so viele Versuche du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Welche Subnetzmaske gehört zur CIDR-Notation /27?"
          optionen={[
            { text: "255.255.255.192", richtig: false },
            { text: "255.255.255.224", richtig: true },
            { text: "255.255.255.240", richtig: false },
            { text: "255.255.255.248", richtig: false },
          ]}
          erklaerung="/27 bedeutet 3 gesetzte Bits im letzten Oktett: 11100000 = 224. Die Maske ist also 255.255.255.224."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Wie viele nutzbare Hosts hat ein /28-Netz?"
          optionen={[
            { text: "16", richtig: false },
            { text: "30", richtig: false },
            { text: "14", richtig: true },
            { text: "8", richtig: false },
          ]}
          erklaerung="2^(32 − 28) − 2 = 2^4 − 2 = 14. Netz- und Broadcast-Adresse zählen nicht als nutzbare Hosts."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="In welchem Subnetz liegt die Adresse 172.16.5.200 bei einem /26-Präfix?"
          optionen={[
            { text: "Netz 172.16.5.128, Broadcast 172.16.5.191", richtig: false },
            { text: "Netz 172.16.5.192, Broadcast 172.16.5.255", richtig: true },
            { text: "Netz 172.16.5.200, Broadcast 172.16.5.255", richtig: false },
            { text: "Netz 172.16.5.64, Broadcast 172.16.5.127", richtig: false },
          ]}
          erklaerung="Blockgröße bei /26 ist 64, also Subnetze .0, .64, .128, .192. Die .200 liegt im Block .192: Netzadresse 172.16.5.192, Broadcast 172.16.5.255, nutzbar .193 bis .254."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wie lautet die Broadcast-Adresse des Netzes 192.168.1.0/28?"
          optionen={[
            { text: "192.168.1.7", richtig: false },
            { text: "192.168.1.15", richtig: true },
            { text: "192.168.1.16", richtig: false },
            { text: "192.168.1.255", richtig: false },
          ]}
          erklaerung="/28 bedeutet Maske 255.255.255.240 und Blockgröße 256 − 240 = 16. Erstes Subnetz: .0 bis .15. Der Broadcast ist die letzte Adresse im Block, also 192.168.1.15."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Du brauchst mindestens 50 nutzbare Hosts pro Subnetz. Welches Präfix ist das kleinste passende?"
          optionen={[
            { text: "/25", richtig: false },
            { text: "/26", richtig: true },
            { text: "/27", richtig: false },
            { text: "/28", richtig: false },
          ]}
          erklaerung="/26 liefert 2^6 − 2 = 62 Hosts. Das reicht für 50 und lässt am wenigsten Adressen ungenutzt. /27 hätte nur 30 Hosts (zu wenig), /25 mit 126 wäre unnötig groß."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
