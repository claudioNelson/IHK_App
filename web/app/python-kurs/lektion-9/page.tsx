import type { Metadata } from "next";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../_components/LektionLayout";

export const metadata: Metadata = {
  title: "Python Lektion 9: Fehler verstehen & Debugging",
  description:
    "Tracebacks lesen, die häufigsten Python-Fehler (TypeError, NameError, IndexError) verstehen und mit try/except abfangen. Lektion 9 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-9" },
};

export default function Lektion9() {
  return (
    <LektionLayout nr={9}>
      <p>
        Fehler gehören zum Programmieren wie Kabel zum Serverraum. Der
        Unterschied zwischen Anfängern und Profis ist nicht, dass Profis keine
        Fehler machen, sondern dass sie <strong>Fehlermeldungen lesen</strong>{" "}
        können. Führ das hier aus und schau dir die Meldung genau an:
      </p>

      <PythonRunner
        rows={4}
        initialCode={`zahl = 5
print(zhal)`}
      />

      <p>
        Python sagt dir drei Dinge: die <strong>Zeile</strong>, in der es
        knallte, die <strong>Fehlerart</strong> (
        <span className="lp-mono">NameError</span>) und eine Beschreibung
        (&quot;zhal is not defined&quot;, oft sogar mit Korrekturvorschlag).
        Immer von unten nach oben lesen! Die häufigsten Fehlerarten:
      </p>
      <p>
        <span className="lp-mono">SyntaxError</span>: Tippfehler in der
        Sprache selbst, z. B. fehlender Doppelpunkt.{" "}
        <span className="lp-mono">NameError</span>: Variable falsch
        geschrieben oder nie angelegt.{" "}
        <span className="lp-mono">TypeError</span>: Typen passen nicht
        zusammen, der Klassiker &quot;String + Zahl&quot; aus Lektion 2.{" "}
        <span className="lp-mono">ValueError</span>: richtiger Typ, unsinniger
        Wert, z. B. <span className="lp-mono">int(&quot;abc&quot;)</span>.{" "}
        <span className="lp-mono">IndexError</span>: Zugriff auf ein
        Listenelement, das es nicht gibt.
      </p>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 9.1:</strong> Im Code unten stecken DREI Fehler.
          Führ ihn aus, lies die Meldung, behebe den ersten Fehler, führ
          erneut aus, und so weiter, bis alles läuft.
        </p>
      </div>
      <PythonRunner
        rows={6}
        initialCode={`namen = ["Alex", "Sam", "Kim"]

print("Erster Name: " + namen[0]
print("Letzter Name: " + namen[3])
print("Anzahl: " + len(namen))`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`namen = ["Alex", "Sam", "Kim"]

print("Erster Name: " + namen[0])      # Klammer fehlte (SyntaxError)
print("Letzter Name: " + namen[2])     # Index 3 gibt es nicht (IndexError)
print("Anzahl: " + str(len(namen)))    # Zahl erst zu String machen (TypeError)`}</pre>
      </details>

      <h3>Fehler abfangen mit try/except</h3>
      <p>
        Manche Fehler kannst du nicht verhindern, etwa wenn ein Nutzer
        &quot;abc&quot; eintippt, wo eine Zahl erwartet wird. Mit{" "}
        <span className="lp-mono">try/except</span> stürzt dein Programm dann
        nicht ab, sondern reagiert kontrolliert:
      </p>

      <PythonRunner
        rows={7}
        initialCode={`eingabe = input("Eine Zahl: ")

try:
    zahl = int(eingabe)
    print(f"Das Doppelte ist {zahl * 2}")
except ValueError:
    print("Das war keine Zahl!")`}
      />

      <div className="lp-tip">
        <p>
          <strong>Debugging-Trick Nummer 1:</strong> Wenn dein Programm
          Unsinn macht, aber nicht abstürzt, streu{" "}
          <span className="lp-mono">print()</span>-Zeilen ein und gib
          Zwischenwerte aus (&quot;Was steht WIRKLICH in der Variable?&quot;).
          Das klingt banal, findet aber 90 Prozent aller Logikfehler. Genau so
          haben wir übrigens auch echte Fehler in der Lernarena-App gefunden.
        </p>
      </div>

      <div className="pk-aufgabe">
        <p>
          <strong>Übung 9.2:</strong> Baue eine absturzsichere Altersabfrage:
          Frag so lange nach dem Alter, bis eine gültige Zahl kommt. Kombiniere
          dafür die while-Schleife aus Lektion 5 mit try/except.
        </p>
      </div>
      <PythonRunner
        rows={9}
        initialCode={`# Dein Code:

`}
      />
      <details className="pk-loesung">
        <summary>Musterlösung anzeigen</summary>
        <pre>{`while True:
    eingabe = input("Wie alt bist du? ")
    try:
        alter = int(eingabe)
        break
    except ValueError:
        print("Bitte eine Zahl eingeben!")

print(f"Alles klar, du bist {alter}.")`}</pre>
      </details>
    </LektionLayout>
  );
}
