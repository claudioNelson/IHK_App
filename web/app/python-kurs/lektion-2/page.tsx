import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 2: Variablen & Datentypen",
  description:
    "Variablen, Datentypen (str, int, float, bool) und input() verständlich erklärt, mit Übungen direkt im Browser. Lektion 2 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-2" },
};

export default function Lektion2() {
  return (
    <LektionLayout nr={2}>
      <p>
        Eine <strong>Variable</strong> ist ein beschrifteter Karton: Du legst
        einen Wert hinein und kannst ihn später über den Namen wiederfinden.
        In Python brauchst du dafür nur ein Gleichheitszeichen:
      </p>

      <PythonRunner
        rows={6}
        initialCode={`name = "Alex"
alter = 21
groesse = 1.78

print(name)
print(alter)
print(groesse)`}
      />

      <p>
        Damit hast du schon drei der wichtigsten <strong>Datentypen</strong>{" "}
        benutzt, und die sind übrigens auch AP1-Prüfungsstoff:
      </p>
      <p>
        <span className="lp-mono">str</span> (String) ist Text in
        Anführungszeichen. <span className="lp-mono">int</span> (Integer) ist
        eine ganze Zahl. <span className="lp-mono">float</span> ist eine
        Kommazahl, die im Code mit <strong>Punkt</strong> geschrieben wird
        (1.78, nicht 1,78). Und <span className="lp-mono">bool</span> kennt nur{" "}
        <span className="lp-mono">True</span> oder{" "}
        <span className="lp-mono">False</span>. Mit{" "}
        <span className="lp-mono">type()</span> fragst du Python, welcher Typ
        in einer Variable steckt:
      </p>

      <PythonRunner
        rows={5}
        initialCode={`bestanden = True

print(type("Hallo"))
print(type(42))
print(type(1.78))
print(type(bestanden))`}
      />

      <p>
        Richtig praktisch werden Variablen mit{" "}
        <span className="lp-mono">input()</span>: Damit fragst du den Nutzer
        etwas und speicherst die Antwort. Führ das mal aus, dein Browser
        fragt dich dann nach deinem Namen:
      </p>

      <PythonRunner
        rows={3}
        initialCode={`name = input("Wie heißt du? ")
print("Hallo " + name + "!")`}
      />

      <div className="lp-tip">
        <p>
          <strong>Merksatz für die Prüfung:</strong>{" "}
          <span className="lp-mono">input()</span> liefert <strong>immer</strong>{" "}
          einen String, auch wenn jemand &quot;21&quot; eintippt. Zum Rechnen
          musst du erst mit <span className="lp-mono">int(...)</span>{" "}
          umwandeln. Dieser Stolperstein ist ein Klassiker, auch im
          IHK-Pseudocode gibt es dafür Typumwandlungen.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 2.1:</strong> Frag den Nutzer nach seinem Geburtsjahr
          und gib aus, wie alt er dieses Jahr wird. Tipp: Du brauchst{" "}
          <span className="lp-mono">int(input(...))</span> und{" "}
          <span className="lp-mono">2026 - jahr</span>.
        </p>
      </div>
      <PythonRunner
        rows={4}
        initialCode={`# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`jahr = int(input("Dein Geburtsjahr? "))
alter = 2026 - jahr
print("Du wirst dieses Jahr", alter)`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 2.2:</strong> Im Code unten steckt ein Fehler. Führ ihn
          aus, lies die Fehlermeldung in Ruhe und repariere ihn.
        </p>
      </div>
      <PythonRunner
        rows={3}
        initialCode={`alter = input("Wie alt bist du? ")
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`alter = int(input("Wie alt bist du? "))
naechstes_jahr = alter + 1
print("Nächstes Jahr bist du", naechstes_jahr)

# Der Fehler: input() liefert einen String, und
# "21" + 1 kann Python nicht rechnen (TypeError).
# int(...) macht aus dem Text eine Zahl.`}</pre>
      </details>
    </LektionLayout>
  );
}
