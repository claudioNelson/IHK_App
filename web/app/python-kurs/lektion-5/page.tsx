import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 5: Schleifen (for & while)",
  description:
    "for-Schleifen mit range(), while-Schleifen und break, mit Übungen direkt im Browser. Lektion 5 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-5" },
};

export default function Lektion5() {
  return (
    <LektionLayout nr={5}>
      <p>
        Computer sind gut in einer Sache: stumpf wiederholen, ohne sich zu
        beschweren. Eine <span className="lp-mono">for</span>-Schleife mit{" "}
        <span className="lp-mono">range()</span> wiederholt Code eine feste
        Anzahl von Malen:
      </p>

      <PythonRunner
        rows={4}
        initialCode={`for i in range(5):
    print(f"Durchlauf Nummer {i}")`}
      />

      <p>
        Wichtig: <span className="lp-mono">range(5)</span> zählt{" "}
        <strong>ab 0</strong> und hört <strong>vor 5</strong> auf (0, 1, 2, 3,
        4). Das verwirrt jeden am Anfang. Willst du von 1 bis 10 zählen,
        schreibst du <span className="lp-mono">range(1, 11)</span>. Damit
        lassen sich in drei Zeilen Dinge bauen, für die du früher zehn Minuten
        getippt hättest:
      </p>

      <PythonRunner
        rows={6}
        initialCode={`# Summe aller Zahlen von 1 bis 100 (der kleine Gauss)
summe = 0
for zahl in range(1, 101):
    summe = summe + zahl
print(summe)`}
      />

      <p>
        Die zweite Schleifenart ist <span className="lp-mono">while</span>:
        Sie läuft, <strong>solange</strong> eine Bedingung wahr ist. Du weißt
        vorher nicht, wie oft, und genau das ist ihr Einsatzgebiet:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`countdown = 5
while countdown > 0:
    print(countdown)
    countdown = countdown - 1
print("Start!")`}
      />

      <div className="lp-tip">
        <p>
          <strong>Achtung, Endlosschleife:</strong> Wenn du das{" "}
          <span className="lp-mono">countdown = countdown - 1</span> vergisst,
          bleibt die Bedingung für immer wahr und die Schleife läuft endlos.
          Falls dir das hier im Browser passiert: Seite neu laden, Code
          korrigieren, weitermachen. Merke: Eine while-Schleife braucht immer
          etwas, das ihre Bedingung irgendwann kippt.
        </p>
      </div>

      <p>
        Mit <span className="lp-mono">break</span> brichst du eine Schleife
        sofort ab. Das brauchst du gleich in Lektion 6 fürs Spiel:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`for zahl in range(1, 100):
    if zahl * zahl > 200:
        print(f"{zahl} ist die erste Zahl, deren Quadrat ueber 200 liegt.")
        break`}
      />

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 5.1:</strong> Gib das kleine Einmaleins der 7 aus, also
          &quot;1 x 7 = 7&quot; bis &quot;10 x 7 = 70&quot;. Eine
          for-Schleife, ein f-String, fertig.
        </p>
      </div>
      <PythonRunner
        rows={4}
        initialCode={`# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`for i in range(1, 11):
    print(f"{i} x 7 = {i * 7}")`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 5.2:</strong> Simuliere eine PIN-Abfrage: Die richtige
          PIN ist 4711. Frag mit einer while-Schleife so lange nach der PIN,
          bis sie stimmt, und begrüße den Nutzer dann.
        </p>
      </div>
      <PythonRunner
        rows={6}
        initialCode={`richtige_pin = 4711
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`richtige_pin = 4711
eingabe = int(input("PIN eingeben: "))
while eingabe != richtige_pin:
    eingabe = int(input("Falsch! Nochmal: "))
print("Willkommen!")`}</pre>
      </details>
    </LektionLayout>
  );
}
