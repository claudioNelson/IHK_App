import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 2: Variablen und Datentypen",
  description:
    "Variablen, Datentypen (str, int, float, bool) und input() verständlich erklärt, mit Übungen direkt im Browser. Lektion 2 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-2" },
};

export default function Lektion2() {
  // Jahr beim Rendern statt fest im Text (Tipp und Musterloesung zu Uebung 2.1)
  const jahr = new Date().getFullYear();

  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={2}
      lead="Variablen, Datentypen (str, int, float, bool) und input() verständlich erklärt, mit Übungen direkt im Browser."
      uebungen={2}
    >
      <LsAbschnitt id="variablen" titel="Variablen">
        <p>
          Eine <strong>Variable</strong> ist ein beschrifteter Karton: Du legst einen Wert hinein
          und kannst ihn später über den Namen wiederfinden. In Python brauchst du dafür nur ein
          Gleichheitszeichen:
        </p>

        <PythonRunner
          rows={6}
          dateiname="variablen.py"
          initialCode={`name = "Alex"
alter = 21
groesse = 1.78

print(name)
print(alter)
print(groesse)`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="datentypen" titel="Datentypen">
        <p>
          Damit hast du schon drei der wichtigsten <strong>Datentypen</strong> benutzt, und die sind
          übrigens auch AP1-Prüfungsstoff:
        </p>
        <p>
          <code>str</code> (String) ist Text in Anführungszeichen. <code>int</code> (Integer) ist
          eine ganze Zahl. <code>float</code> ist eine Kommazahl, die im Code mit{" "}
          <strong>Punkt</strong> geschrieben wird (1.78, nicht 1,78). Und <code>bool</code> kennt
          nur <code>True</code> oder <code>False</code>. Mit <code>type()</code> fragst du Python,
          welcher Typ in einer Variable steckt:
        </p>

        <PythonRunner
          rows={5}
          dateiname="datentypen.py"
          initialCode={`bestanden = True

print(type("Hallo"))
print(type(42))
print(type(1.78))
print(type(bestanden))`}
        />
      </LsAbschnitt>

      <LsAbschnitt id="input" titel="Eingaben mit input()">
        <p>
          Richtig praktisch werden Variablen mit <code>input()</code>: Damit fragst du den Nutzer
          etwas und speicherst die Antwort. Führ das mal aus, dein Browser fragt dich dann nach
          deinem Namen:
        </p>

        <PythonRunner
          rows={3}
          dateiname="eingabe.py"
          initialCode={`name = input("Wie heißt du? ")
print("Hallo " + name + "!")`}
        />

        <LsHinweis titel="Merksatz für die Prüfung">
          <p>
            <code>input()</code> liefert <strong>immer</strong> einen String, auch wenn jemand
            „21“ eintippt. Zum Rechnen musst du erst mit <code>int(...)</code> umwandeln. Dieser
            Stolperstein ist ein Klassiker, auch im IHK-Pseudocode gibt es dafür
            Typumwandlungen.
          </p>
        </LsHinweis>
      </LsAbschnitt>

      <LsAbschnitt id="uebungen" titel="Übungen">
        <p>Erst selbst versuchen, dann die Lösung aufklappen.</p>

        <Aufgabe nr="2.1">
          <p>
            Frag den Nutzer nach seinem Geburtsjahr und gib aus, wie alt er dieses Jahr wird.
            Tipp: Du brauchst <code>int(input(...))</code> und <code>{`${jahr} - jahr`}</code>.
          </p>
          <PythonRunner
            rows={4}
            dateiname="uebung_2_1.py"
            label="Python-Code: Übung 2.1"
            initialCode={`# Dein Code:
`}
          />
          <Loesung
            code={`jahr = int(input("Dein Geburtsjahr? "))
alter = ${jahr} - jahr
print("Du wirst dieses Jahr", alter)`}
          />
        </Aufgabe>

        <Aufgabe nr="2.2">
          <p>
            Im Code unten steckt ein Fehler. Führ ihn aus, lies die Fehlermeldung in Ruhe und
            repariere ihn.
          </p>
          <PythonRunner
            rows={3}
            dateiname="uebung_2_2.py"
            label="Python-Code: Übung 2.2"
            initialCode={`alter = input("Wie alt bist du? ")
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)`}
          />
          <Loesung
            code={`alter = int(input("Wie alt bist du? "))
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)

# Der Fehler: input() liefert einen String, und
# "21" + 1 kann Python nicht rechnen (TypeError).
# int(...) macht aus dem Text eine Zahl.`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
