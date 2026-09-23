import type { Metadata } from "next";
import Link from "next/link";
import LernSeite, { type Abschnitt, type MetaEintrag, type Verwandt } from "../_components/LernSeite";
import { LsAbschnitt, LsFaq, LsHinweis, type FaqEintrag } from "../_components/LsBausteine";
import QuizFrage from "../_components/QuizFrage";

export const metadata: Metadata = {
  title: "Normalisierung: 1. bis 3. Normalform erklärt (IHK)",
  description:
    "Datenbank-Normalisierung einfach erklärt: 1., 2. und 3. Normalform mit Beispielen, Anomalien und Merksätzen, dazu interaktive Übungsaufgaben für die IHK-Prüfung.",
  alternates: {
    canonical: "https://lernarena.app/lernen/normalisierung",
  },
  openGraph: {
    type: "article",
    url: "https://lernarena.app/lernen/normalisierung",
    title: "Normalisierung: 1. bis 3. Normalform erklärt (IHK)",
    description: "1NF, 2NF und 3NF mit Beispielen und Merksätzen für die Fachinformatiker-Prüfung.",
    images: ["/og-image.png"],
  },
};

const abschnitte: Abschnitt[] = [
  { id: "warum", titel: "Warum normalisieren?" },
  { id: "normalformen", titel: "Die drei Normalformen" },
  { id: "beispiel", titel: "Beispiel Rechnungstabelle" },
  { id: "fehler", titel: "Häufige Fehler" },
  { id: "quiz", titel: "Selbst testen" },
  { id: "faq", titel: "Häufige Fragen" },
];

const meta: MetaEintrag[] = [
  { icon: "zeit", text: "Etwa 6 Minuten" },
  { icon: "rechner", text: "Regeltabelle und Beispiel in drei Schritten" },
  { icon: "quiz", text: "5 Quizfragen" },
  { icon: "pruefung", text: "Datenbankaufgaben der IHK-Prüfung" },
];

const verwandt: Verwandt[] = [
  { href: "/lernen/er-diagramm", titel: "ER-Diagramm", untertitel: "Entitäten, Kardinalitäten, n:m-Auflösung" },
  { href: "/lernen/sql", titel: "SQL üben", untertitel: "SELECT, JOIN und GROUP BY" },
  { href: "/lernen", titel: "Alle Lernthemen", untertitel: "10 Themen für AP1 und AP2" },
  { href: "/pruefungen", titel: "Übungsprüfungen", untertitel: "Aufgaben im IHK-Stil mit Korrektur" },
];

const normalformen: { nf: string; regel: string; merksatz: string }[] = [
  {
    nf: "1. NF",
    regel: "Alle Attribute sind atomar, also keine Listen oder zusammengesetzten Werte in einem Feld",
    merksatz: "Ein Wert pro Feld",
  },
  {
    nf: "2. NF",
    regel: "1. NF und jedes Nicht-Schlüssel-Attribut hängt vom ganzen Primärschlüssel ab",
    merksatz: "Keine partiellen Abhängigkeiten",
  },
  {
    nf: "3. NF",
    regel: "2. NF und kein Nicht-Schlüssel-Attribut hängt von einem anderen Nicht-Schlüssel-Attribut ab",
    merksatz: "Keine transitiven Abhängigkeiten",
  },
];

const faq: FaqEintrag[] = [
  {
    q: "Was bedeutet die 1. Normalform?",
    a: "Alle Attributwerte müssen atomar sein, das heißt: In jedem Feld steht genau ein Wert. Listen, Aufzählungen oder zusammengesetzte Angaben wie „Name, Vorname“ in einem Feld verletzen die 1. Normalform.",
  },
  {
    q: "Was bedeutet die 2. Normalform?",
    a: "Die Tabelle ist in der 1. Normalform und jedes Nicht-Schlüssel-Attribut hängt vom gesamten Primärschlüssel ab, nicht nur von einem Teil. Relevant ist das bei zusammengesetzten Schlüsseln, etwa (rechnungs_nr, artikel_nr).",
  },
  {
    q: "Was bedeutet die 3. Normalform?",
    a: "Die Tabelle ist in der 2. Normalform und kein Nicht-Schlüssel-Attribut hängt transitiv, also über ein anderes Nicht-Schlüssel-Attribut, vom Schlüssel ab. Beispiel: Der Ort hängt von der Postleitzahl ab. Dann gehören PLZ und Ort in eine eigene Tabelle.",
  },
  {
    q: "Welche Anomalien verhindert die Normalisierung?",
    a: "Änderungsanomalien (derselbe Wert müsste an vielen Stellen geändert werden), Einfügeanomalien (Daten lassen sich nicht ohne fremde Daten anlegen) und Löschanomalien (beim Löschen gehen ungewollt andere Informationen verloren).",
  },
];

export default function NormalisierungPage() {
  return (
    <LernSeite
      titel="Normalisierung: die 1. bis 3. Normalform einfach erklärt"
      lead="Kaum eine Datenbankprüfung ohne Normalisierung: Tabellen in die 1., 2. und 3. Normalform bringen. Hier bekommst du die drei Regeln mit Beispielen und Merksätzen und testest dich direkt."
      pfad="Normalisierung"
      meta={meta}
      abschnitte={abschnitte}
      seitenNotiz={
        <>
          Entitäten und Schlüssel noch unklar? Dann zuerst das{" "}
          <Link href="/lernen/er-diagramm">ER-Diagramm</Link> ansehen.
        </>
      }
      verwandt={verwandt}
      cta={{
        titel: "Datenbanken interaktiv trainieren.",
        text: "In der Lernarena normalisierst du Tabellen mit sofortigem Feedback, Aufgaben im IHK-Stil und der KI-Tutorin Ada, die dir jeden Schritt erklärt.",
      }}
    >
      <LsAbschnitt id="warum" titel="Warum normalisieren?">
        <p>
          Schlecht strukturierte Tabellen führen zu <strong>Redundanz</strong> (dieselben
          Daten mehrfach) und <strong>Anomalien</strong>: Änderungsanomalie (ein Wert muss an
          vielen Stellen geändert werden), Einfügeanomalie (Daten können nicht ohne fremde
          Daten angelegt werden) und Löschanomalie (beim Löschen gehen ungewollt
          Informationen verloren). Die Normalformen beseitigen diese Probleme Schritt für
          Schritt.
        </p>
        <LsHinweis titel="Merkhilfe: das chaotische Adressbuch" icon="buch" label="Merkhilfe">
          <p>
            Wenn du die Telefonnummer eines Freundes auf zehn verschiedenen Seiten notiert
            hast und er umzieht, musst du zehnmal korrigieren und vergisst dabei garantiert
            eine Stelle (das ist die <em>Änderungsanomalie</em>). Normalisieren heißt: Jede
            Information steht nur an <strong>einer</strong> Stelle. Änderst du sie dort,
            stimmt sie überall. Genau darum zerlegen wir eine große, unübersichtliche Tabelle
            in mehrere saubere.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="normalformen" titel="Die drei Normalformen">
        <div
          className="ls-table-wrap"
          role="region"
          aria-label="Die drei Normalformen, seitlich scrollbar"
          tabIndex={0}
        >
          <table className="ls-table">
            <thead>
              <tr>
                <th scope="col">Normalform</th>
                <th scope="col">Regel</th>
                <th scope="col">Merksatz</th>
              </tr>
            </thead>
            <tbody>
              {normalformen.map((n) => (
                <tr key={n.nf}>
                  <td>{n.nf}</td>
                  <td className="txt">{n.regel}</td>
                  <td className="txt">{n.merksatz}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <LsHinweis titel="Der berühmte Merksatz">
          <p>
            Jedes Nicht-Schlüssel-Attribut hängt ab „
            <strong>vom Schlüssel, vom ganzen Schlüssel und von nichts als dem Schlüssel</strong>
            “. Übersetzt: <code>1. NF</code> heißt ein Wert pro Feld, <code>2. NF</code> heißt
            vom <em>ganzen</em> Schlüssel (keine Teil-Abhängigkeit), <code>3. NF</code> heißt
            von <em>nichts als</em> dem Schlüssel (keine Umleitung über andere Attribute).
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="beispiel" titel="Beispiel: eine Rechnungstabelle normalisieren">
        <p className="ls-task">
          <strong>Ausgangslage (unnormalisiert):</strong> Im Feld <code>artikel_liste</code>{" "}
          stehen mehrere Artikel als Text.
        </p>
        <pre className="ls-pre" tabIndex={0}>
          <code>{`rechnung(rechnungs_nr, datum, kunde_name, kunde_ort, artikel_liste)`}</code>
        </pre>
        <ol className="ls-steps">
          <li className="ls-step">
            <div>
              <h3>1. Normalform</h3>
              <p>
                Die Artikelliste wird aufgelöst: pro Artikel eine eigene Zeile, alle Felder
                atomar.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>2. Normalform</h3>
              <p>
                Bei zusammengesetztem Schlüssel <code>(rechnungs_nr, artikel_nr)</code>{" "}
                hängen die Artikeldaten nur von <code>artikel_nr</code> ab. Sie kommen
                deshalb in eine eigene Artikel-Tabelle.
              </p>
            </div>
          </li>
          <li className="ls-step">
            <div>
              <h3>3. Normalform</h3>
              <p>
                <code>kunde_ort</code> hängt von <code>kunde_name</code> ab (nicht vom
                Schlüssel <code>rechnungs_nr</code>). Daraus wird eine eigene Kunden-Tabelle.
                Ergebnis: <code>rechnung</code>, <code>rechnungsposition</code>,{" "}
                <code>artikel</code>, <code>kunde</code>.
              </p>
            </div>
          </li>
        </ol>
      </LsAbschnitt>

      <LsAbschnitt id="fehler" titel="Häufige Fehler in der Prüfung">
        <LsHinweis art="warnung" titel="Vier Stolperfallen, die regelmäßig Punkte kosten">
          <ul>
            <li>
              Normalformen überspringen. Du musst der Reihe nach vorgehen: erst 1. NF, dann
              2. NF, dann 3. NF. Eine höhere setzt die niedrigere voraus.
            </li>
            <li>
              Die 2. NF prüfen, obwohl es <strong>keinen zusammengesetzten Schlüssel</strong>{" "}
              gibt. Ohne mehrteiligen Schlüssel ist die 2. NF automatisch erfüllt.
            </li>
            <li>
              Transitive Abhängigkeiten übersehen (z. B. der Ort hängt von der{" "}
              <code>PLZ</code> ab). Das ist der typische 3.-NF-Verstoß.
            </li>
            <li>
              Beim Zerlegen den <strong>Fremdschlüssel vergessen</strong>, der die neuen
              Tabellen wieder verbindet.
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
          frage="In einem Feld steht „Müller, Hans, Berlin“. Welche Normalform ist verletzt?"
          optionen={[
            { text: "1. Normalform", richtig: true },
            { text: "2. Normalform", richtig: false },
            { text: "3. Normalform", richtig: false },
            { text: "Keine, das ist erlaubt", richtig: false },
          ]}
          erklaerung="Mehrere Werte in einem Feld verletzen die Atomarität. Das ist ein klassischer Verstoß gegen die 1. Normalform."
        />

        <QuizFrage
          nr={2}
          von={5}
          frage="Der Ort hängt von der Postleitzahl ab, die PLZ vom Schlüssel. Welche Normalform ist verletzt?"
          optionen={[
            { text: "1. Normalform", richtig: false },
            { text: "2. Normalform", richtig: false },
            { text: "3. Normalform", richtig: true },
            { text: "Keine", richtig: false },
          ]}
          erklaerung="Das ist eine transitive Abhängigkeit: Ort hängt über die PLZ (ein Nicht-Schlüssel-Attribut) vom Schlüssel ab. Das ist ein Verstoß gegen die 3. Normalform."
        />

        <QuizFrage
          nr={3}
          von={5}
          frage="Ein Wert muss bei einer Änderung in 20 Zeilen gleichzeitig angepasst werden. Wie heißt dieses Problem?"
          optionen={[
            { text: "Löschanomalie", richtig: false },
            { text: "Einfügeanomalie", richtig: false },
            { text: "Änderungsanomalie", richtig: true },
            { text: "Transitive Abhängigkeit", richtig: false },
          ]}
          erklaerung="Wenn derselbe Wert redundant in vielen Zeilen steht und überall geändert werden muss, spricht man von einer Änderungsanomalie."
        />

        <QuizFrage
          nr={4}
          von={5}
          frage="Was fordert die 1. Normalform?"
          optionen={[
            { text: "Keine transitiven Abhängigkeiten", richtig: false },
            { text: "Atomare Werte, also nur ein Wert pro Feld", richtig: true },
            { text: "Einen zusammengesetzten Primärschlüssel", richtig: false },
            { text: "Mindestens drei Tabellen", richtig: false },
          ]}
          erklaerung="Die 1. NF verlangt Atomarität: In jedem Feld steht genau ein Wert, keine Listen oder zusammengesetzten Angaben."
        />

        <QuizFrage
          nr={5}
          von={5}
          frage="Wann ist die 2. Normalform automatisch erfüllt (sofern 1. NF gilt)?"
          optionen={[
            { text: "Wenn es keine Fremdschlüssel gibt", richtig: false },
            { text: "Wenn der Primärschlüssel aus nur einem Attribut besteht", richtig: true },
            { text: "Wenn alle Attribute Text sind", richtig: false },
            { text: "Nie, man muss sie immer prüfen", richtig: false },
          ]}
          erklaerung="Partielle Abhängigkeiten können nur bei zusammengesetzten Schlüsseln auftreten. Bei einem einteiligen Primärschlüssel ist die 2. NF also automatisch erfüllt."
        />
      </LsAbschnitt>

      <LsAbschnitt id="faq" titel="Häufige Fragen">
        <LsFaq eintraege={faq} />
      </LsAbschnitt>
    </LernSeite>
  );
}
