import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 3: Rechnen, Modulo & f-Strings",
  description:
    "Division, Ganzzahl-Division, Modulo und f-Strings in Python, mit interaktiven Übungen im Browser. Lektion 3 des kostenlosen Python-Kurses für Fachinformatiker.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-3" },
};

export default function Lektion3() {
  return (
    <LektionLayout nr={3}>
      <p>
        Python ist ein vollwertiger Taschenrechner. Neben{" "}
        <span className="lp-mono">+</span>, <span className="lp-mono">-</span>,{" "}
        <span className="lp-mono">*</span> und{" "}
        <span className="lp-mono">/</span> gibt es drei Operatoren, die du noch
        nicht aus der Schule kennst, die aber in der Praxis (und in
        Prüfungsaufgaben) dauernd vorkommen:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`print(17 / 5)    # normale Division -> 3.4
print(17 // 5)   # Ganzzahl-Division -> 3 (Rest wird abgeschnitten)
print(17 % 5)    # Modulo -> 2 (nur der Rest!)
print(2 ** 10)   # Potenz -> 1024

# Klassiker: Ist eine Zahl gerade?
print(8 % 2)     # 0 bedeutet: glatt teilbar, also gerade`}
      />

      <p>
        Besonders <span className="lp-mono">%</span> (Modulo) solltest du dir
        merken: &quot;Rest bei der Division&quot;. Damit prüfst du, ob eine
        Zahl gerade ist, ob ein Jahr ein Schaltjahr ist oder wie viele Minuten
        in einer Sekundenzahl stecken. Das taucht in fast jeder
        Programmier-Prüfungsaufgabe irgendwo auf.
      </p>

      <h3>Schöne Ausgaben mit f-Strings</h3>
      <p>
        Bisher hast du Ausgaben mit <span className="lp-mono">+</span> oder
        Kommas zusammengebaut. Es geht eleganter: Ein{" "}
        <strong>f-String</strong> ist ein String mit einem{" "}
        <span className="lp-mono">f</span> davor, in den du Variablen direkt in
        geschweiften Klammern einsetzt:
      </p>

      <PythonRunner
        rows={6}
        initialCode={`name = "Alex"
punkte = 87

print(f"{name} hat {punkte} von 100 Punkten.")
print(f"Das sind {punkte / 100} Prozent als Dezimalzahl.")
print(f"In 3 Jahren: {punkte + 3} Punkte (Quatsch, aber es rechnet!)")`}
      />

      <p>
        Strings können noch mehr. Mit{" "}
        <span className="lp-mono">len()</span> misst du die Länge, mit{" "}
        <span className="lp-mono">.upper()</span> und{" "}
        <span className="lp-mono">.lower()</span> änderst du die
        Schreibweise:
      </p>

      <PythonRunner
        rows={5}
        initialCode={`wort = "Fachinformatiker"

print(len(wort))
print(wort.upper())
print(wort.lower())`}
      />

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 3.1:</strong> Ein Netto-Preis von 250 Euro soll mit 19
          Prozent Mehrwertsteuer ausgegeben werden. Berechne den Brutto-Preis
          und gib ihn mit einem f-String aus, z. B. &quot;Brutto: 297.5
          Euro&quot;.
        </p>
      </div>
      <PythonRunner
        rows={4}
        initialCode={`netto = 250
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`netto = 250
brutto = netto * 1.19
print(f"Brutto: {brutto} Euro")`}</pre>
      </details>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 3.2:</strong> Wandle 347 Sekunden in Minuten und
          Sekunden um (Ergebnis: 5 Minuten, 47 Sekunden). Tipp: Ganzzahl-Division{" "}
          <span className="lp-mono">//</span> für die Minuten, Modulo{" "}
          <span className="lp-mono">%</span> für den Rest.
        </p>
      </div>
      <PythonRunner
        rows={5}
        initialCode={`sekunden = 347
# Dein Code:
`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`sekunden = 347
minuten = sekunden // 60
rest = sekunden % 60
print(f"{minuten} Minuten, {rest} Sekunden")`}</pre>
      </details>
    </LektionLayout>
  );
}
