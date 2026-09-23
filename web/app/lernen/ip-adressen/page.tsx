import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "IP-Adressen und IPv6: private Bereiche, Kürzung (IHK)",
  description:
    "IPv4 und IPv6 einfach erklärt: private Adressbereiche, APIPA, Loopback und die IPv6-Kürzungsregeln, mit interaktiven Übungsaufgaben für die IHK-Prüfung als Fachinformatiker.",
  alternates: {
    canonical: "https://lernarena.app/lernen/ip-adressen",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/ip-adressen",
    title: "IP-Adressen und IPv6: private Bereiche, Kürzung (IHK)",
    description:
      "IPv4 und IPv6 für die IHK-Prüfung: private Bereiche, APIPA und IPv6-Kürzung, mit Übungsaufgaben.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "ipv4", titel: "IPv4 in 60 Sekunden" },
  { id: "bereiche", titel: "Bereiche erkennen" },
  { id: "ipv6", titel: "IPv6: das Wichtigste" },
  { id: "kuerzen", titel: "IPv6 kürzen" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 7 Minuten" },
  { icon: "rechner", text: "Tabelle der Sonderbereiche und Kürzungsregeln" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "AP1 und AP2" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/subnetting", titel: "Subnetting üben", untertitel: "Maske, Blockgröße, Broadcast" },
  { href: "/lernen/osi-modell", titel: "OSI-Modell", untertitel: "7 Schichten mit Protokollen und Geräten" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const bereiche: { von: string; cidr: string; bedeutung: string }[] = [
  { von: "10.0.0.0 bis 10.255.255.255", cidr: "10.0.0.0/8", bedeutung: "privat (Klasse A)" },
  { von: "172.16.0.0 bis 172.31.255.255", cidr: "172.16.0.0/12", bedeutung: "privat (Klasse B)" },
  { von: "192.168.0.0 bis 192.168.255.255", cidr: "192.168.0.0/16", bedeutung: "privat (Klasse C)" },
  { von: "127.0.0.0 bis 127.255.255.255", cidr: "127.0.0.0/8", bedeutung: "Loopback (localhost)" },
  { von: "169.254.0.0 bis 169.254.255.255", cidr: "169.254.0.0/16", bedeutung: "APIPA, link-local" },
];

const faq: FaqEintrag[] = [
  {
    q: "Welche IPv4-Adressbereiche sind privat?",
    a: "Die drei privaten Bereiche sind 10.0.0.0/8, 172.16.0.0/12 (also 172.16.0.0 bis 172.31.255.255) und 192.168.0.0/16. Diese Adressen werden im Internet nicht geroutet und dürfen in lokalen Netzen frei verwendet werden.",
  },
  {
    q: "Was bedeutet eine 169.254.x.x-Adresse?",
    a: "Das ist eine APIPA-Adresse (Automatic Private IP Addressing). Der Rechner hat keinen DHCP-Server erreicht und sich selbst eine link-lokale Adresse zugewiesen. In der Praxis ein Hinweis auf ein DHCP- oder Verbindungsproblem.",
  },
  {
    q: "Wie lang ist eine IPv6-Adresse?",
    a: "Eine IPv6-Adresse ist 128 Bit lang und wird hexadezimal in acht Blöcken zu je 16 Bit geschrieben, getrennt durch Doppelpunkte. Zum Vergleich: IPv4 hat nur 32 Bit.",
  },
  {
    q: "Wie kürzt man eine IPv6-Adresse richtig?",
    a: "Zwei Regeln: Führende Nullen in jedem Block dürfen entfallen, und genau eine zusammenhängende Folge von Null-Blöcken darf durch :: ersetzt werden. Aus 2001:0db8:0000:0000:0000:0000:0000:0001 wird so 2001:db8::1.",
  },
];

export default function IpAdressenPage() {
  return (
    <LernSeite
      titel="IP-Adressen und IPv6: private Bereiche, APIPA und Kürzungsregeln"
      lead="Private Adressbereiche erkennen, IPv6-Adressen kürzen, APIPA einordnen: Das sind Standardaufgaben in der IHK-Prüfung. Hier bekommst du alle Tabellen und Regeln kompakt, mit interaktiven Übungen."
      pfad="IP-Adressen und IPv6"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          IPv6 wird hexadezimal geschrieben. Hex noch unsicher? Dann zuerst{" "}
          <Link href="/lernen/zahlensysteme">Zahlensysteme umrechnen</Link>.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "IP-Adressierung interaktiv trainieren.",
        text: "In der Lernarena übst du IPv4, IPv6 und Subnetting mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada.",
      }}
    >
      <LsAbschnitt id="ipv4" titel="IPv4 in 60 Sekunden">
        <p>
          Eine <strong>IPv4-Adresse</strong> ist 32 Bit lang und wird in vier Oktetten
          geschrieben, z. B. <code>192.168.10.25</code>. Zusammen mit der Subnetzmaske
          zerfällt sie in Netz- und Host-Teil. Öffentliche Adressen sind weltweit eindeutig.{" "}
          <strong>Private Adressen</strong> dürfen nur in lokalen Netzen verwendet werden und
          werden im Internet nicht geroutet.
        </p>
        <LsHinweis titel="Merkhilfe: Telefonnummern in einer Firma" icon="haus" label="Merkhilfe">
          <p>
            Die <strong>öffentliche IP</strong> ist die Hauptnummer, die die ganze Welt
            anrufen kann. Die <strong>privaten IPs</strong> sind die internen Durchwahlen
            (z. B. „Apparat 101“): Sie gelten nur im Haus, und jede Firma darf dieselbe
            Durchwahl 101 haben, ohne dass es Chaos gibt. Damit ein internes Gerät ins
            Internet kommt, „übersetzt“ der Router per <strong>NAT</strong> die private
            Adresse auf die öffentliche, wie eine Telefonzentrale, die nach außen vermittelt.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="bereiche" titel="Diese Bereiche musst du erkennen">
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Private und besondere IPv4-Bereiche, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Bereich</th>
                <th scope="col">CIDR</th>
                <th scope="col">Bedeutung</th>
              </tr>
            </thead>
            <tbody>
              {bereiche.map((b) => (
                <tr key={b.cidr}>
                  <td>{b.von}</td>
                  <td>{b.cidr}</td>
                  <td className="txt">{b.bedeutung}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p>
          <strong>APIPA-Merksatz:</strong> Hat ein Rechner eine <code>169.254.x.x</code>-Adresse,
          hat er <strong>keinen DHCP-Server erreicht</strong> und sich selbst eine Adresse
          gegeben. Das ist in der Prüfung ein klassischer Hinweis bei der Fehlersuche.
        </p>
        <LsHinweis titel="Prüfungstipp zur 172er-Falle">
          <p>
            Der private Bereich der „Klasse B“ geht nur von <code>172.16</code> bis{" "}
            <code>172.31</code>. Genau hier baut die IHK gern Fallen: <code>172.32.x.x</code>{" "}
            ist schon <strong>öffentlich</strong>, ebenso <code>172.15.x.x</code>. Merke dir
            die Grenzen 16 und 31 auswendig.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="ipv6" titel="IPv6: das Wichtigste">
        <p>
          Eine <strong>IPv6-Adresse</strong> ist 128 Bit lang und wird hexadezimal in acht
          Blöcken geschrieben. Wichtige Typen: <code>2000::/3</code> (Global Unicast,
          öffentlich), <code>fe80::/10</code> (Link-local, automatisch auf jedem Interface)
          und <code>fc00::/7</code> (Unique Local, das Gegenstück zu privaten IPv4-Adressen).
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="kuerzen" titel="IPv6 kürzen: die zwei Regeln">
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>Führende Nullen weglassen</h3>
              <p>
                In jedem Block dürfen führende Nullen weg: <code>0db8</code> wird zu{" "}
                <code>db8</code>.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>Eine Nullfolge durch :: ersetzen</h3>
              <p>
                <strong>Genau eine</strong> Folge aus Null-Blöcken darf durch <code>::</code>{" "}
                ersetzt werden. Empfohlen ist nach RFC 5952 die längste Folge, bei gleich
                langen Folgen die erste.
              </p>
            </div>
          </li>
        </ol>
        <p>
          Beispiel: <code>2001:0db8:0000:0000:0000:0000:0000:0001</code> wird zu{" "}
          <code>2001:db8::1</code>.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              <code>192.169.x.x</code> für privat halten. Privat ist nur{" "}
              <code>192.168.x.x</code> (eine 8, keine 9).
            </li>
            <li>
              Das <code>::</code> in IPv6 <strong>zweimal</strong> verwenden. Es ist nur{" "}
              <em>einmal</em> pro Adresse erlaubt.
            </li>
            <li>
              APIPA (<code>169.254.x.x</code>) mit einer normalen Adresse verwechseln. Sie
              bedeutet immer „DHCP nicht erreicht“.
            </li>
            <li>
              Loopback ist <code>127.0.0.1</code>, nicht <code>10.0.0.1</code> (ein beliebter
              Verwechsler).
            </li>
          </ul>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="quiz" titel="Jetzt selbst testen">
        <p style={{ marginBottom: 18 }}>
          Beantworte die Fragen und bekomme sofort Feedback. Du hast so viele Versuche, wie
          du willst.
        </p>

        <QuizFrage
          nr={1}
          von={5}
          frage="Welche dieser Adressen ist eine private IPv4-Adresse?"
          optionen={[
            { text: "172.32.10.1", richtig: false },
            { text: "172.20.10.1", richtig: true },
            { text: "11.0.0.5", richtig: false },
            { text: "192.169.1.1", richtig: false },
          ]}
          erklaerung="Der private Bereich lautet 172.16.0.0 bis 172.31.255.255, und 172.20.10.1 liegt darin. 172.32.x.x liegt schon außerhalb, ebenso 11.x und 192.169.x."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Ein PC hat die Adresse 169.254.33.7. Was ist die wahrscheinlichste Ursache?"
          optionen={[
            { text: "Der DHCP-Server wurde nicht erreicht", richtig: true },
            { text: "Der DNS-Server ist falsch konfiguriert", richtig: false },
            { text: "Die Adresse wurde vom Router vergeben", richtig: false },
            { text: "Es handelt sich um eine öffentliche Adresse", richtig: false },
          ]}
          erklaerung="169.254.x.x ist der APIPA-Bereich: Der Rechner hat keinen DHCP-Server erreicht und sich selbst eine link-lokale Adresse gegeben."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Wie lautet die empfohlene Kurzform (RFC 5952) von 2001:0db8:0000:0000:0000:00ff:0000:0001?"
          optionen={[
            { text: "2001:db8::ff::1", richtig: false },
            { text: "2001:db8::ff:0:1", richtig: true },
            { text: "2001:db8::ff:1", richtig: false },
            { text: "2001:db8:0:0:0:ff::1", richtig: false },
          ]}
          erklaerung="Die längste Nullfolge (drei Blöcke nach 2001:db8) wird durch :: ersetzt, führende Nullen fallen weg: 2001:db8::ff:0:1. 2001:db8::ff::1 ist ungültig, weil :: nur einmal vorkommen darf. 2001:db8::ff:1 unterschlägt einen Null-Block und wäre eine andere Adresse. 2001:db8:0:0:0:ff::1 ist nach RFC 4291 zwar gültig, aber nicht die empfohlene Form: RFC 5952 verlangt, die längste Nullfolge zu ersetzen und nie nur einen einzelnen Null-Block."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Wofür steht die Adresse 127.0.0.1?"
          optionen={[
            { text: "Für den Standard-Gateway", richtig: false },
            { text: "Für den eigenen Rechner (Loopback, localhost)", richtig: true },
            { text: "Für eine private Klasse-A-Adresse", richtig: false },
            { text: "Für eine APIPA-Adresse", richtig: false },
          ]}
          erklaerung="127.0.0.1 ist die Loopback-Adresse: Der Rechner spricht damit mit sich selbst (localhost). Der gesamte Bereich 127.0.0.0/8 ist dafür reserviert."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Wie viele Bit hat eine IPv6-Adresse?"
          optionen={[
            { text: "32 Bit", richtig: false },
            { text: "64 Bit", richtig: false },
            { text: "128 Bit", richtig: true },
            { text: "256 Bit", richtig: false },
          ]}
          erklaerung="IPv6 nutzt 128 Bit (acht Blöcke à 16 Bit, hexadezimal). IPv4 hat dagegen nur 32 Bit. Deshalb war ein größerer Adressraum überhaupt nötig."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
