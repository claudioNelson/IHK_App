import type { Metadata } from "next";
import { LsAbschnitt, LsHinweis } from "../../lernen/_components/LsBausteine";
import PythonRunner from "../_components/PythonRunner";
import LektionLayout from "../../components/kurs/LektionLayout";
import { pythonKurs } from "../_components/lektionen";
import { Aufgabe, Loesung } from "../../components/kurs/KursBausteine";

export const metadata: Metadata = {
  title: "Python Lektion 9: Fehler verstehen und Debugging",
  description:
    "Tracebacks lesen, die häufigsten Python-Fehler (TypeError, NameError, IndexError) verstehen und mit try/except abfangen. Lektion 9 des kostenlosen Python-Kurses.",
  alternates: { canonical: "https://lernarena.app/python-kurs/lektion-9" },
};

export default function Lektion9() {
  return (
    <LektionLayout
      kurs={pythonKurs}
      nr={9}
      lead="Tracebacks lesen, die häufigsten Python-Fehler (TypeError, NameError, IndexError) verstehen und mit try/except abfangen."
      uebungen={2}
    >
      <LsAbschnitt id="fehlermeldungen" titel="Fehlermeldungen lesen">
        <p>
          Fehler gehören zum Programmieren wie Kabel zum Serverraum. Der Unterschied zwischen
          Anfängern und Profis ist nicht, dass Profis keine Fehler machen, sondern dass sie{" "}
          <strong>Fehlermeldungen lesen</strong> können. Führ das hier aus und schau dir die
          Meldung genau an:
        </p>

        <PythonRunner
          rows={4}
          dateiname="tippfehler.py"
          initialCode={`zahl = 5
print(zhal)`}
        />

        <p>
          Python sagt dir drei Dinge: die <strong>Zeile</strong>, in der es knallte, die{" "}
          <strong>Fehlerart</strong> (<code>NameError</code>) und eine Beschreibung („zhal is not
          defined“, oft sogar mit Korrekturvorschlag). Immer von unten nach oben lesen! Die
          häufigsten Fehlerarten:
        </p>
        <p>
          <code>SyntaxError</code>: Tippfehler in der Sprache selbst, z. B. fehlender Doppelpunkt.{" "}
          <code>NameError</code>: Variable falsch geschrieben oder nie angelegt.{" "}
          <code>TypeError</code>: Typen passen nicht zusammen, der Klassiker „String + Zahl“ aus
          Lektion 2. <code>ValueError</code>: richtiger Typ, unsinniger Wert, z. B.{" "}
          <code>int(&quot;abc&quot;)</code>. <code>IndexError</code>: Zugriff auf ein
          Listenelement, das es nicht gibt.
        </p>

        <Aufgabe nr="9.1">
          <p>
            Im Code unten stecken DREI Fehler. Führ ihn aus, lies die Meldung, behebe den ersten
            Fehler, führ erneut aus, und so weiter, bis alles läuft.
          </p>
          <PythonRunner
            rows={6}
            dateiname="uebung_9_1.py"
            label="Python-Code: Übung 9.1"
            initialCode={`namen = ["Alex", "Sam", "Kim"]

print("Erster Name: " + namen[0]
print("Letzter Name: " + namen[3])
print("Anzahl: " + len(namen))`}
          />
          <Loesung
            code={`namen = ["Alex", "Sam", "Kim"]

print("Erster Name: " + namen[0])      # Klammer fehlte (SyntaxError)
print("Letzter Name: " + namen[2])     # Index 3 gibt es nicht (IndexError)
print("Anzahl: " + str(len(namen)))    # Zahl erst zu String machen (TypeError)`}
          />
        </Aufgabe>
      </LsAbschnitt>

      <LsAbschnitt id="try-except" titel="Fehler abfangen mit try/except">
        <p>
          Manche Fehler kannst du nicht verhindern, etwa wenn ein Nutzer „abc“ eintippt, wo eine
          Zahl erwartet wird. Mit <code>try/except</code> stürzt dein Programm dann nicht ab,
          sondern reagiert kontrolliert:
        </p>

        <PythonRunner
          rows={7}
          dateiname="try_except.py"
          initialCode={`eingabe = input("Eine Zahl: ")

try:
    zahl = int(eingabe)
    print(f"Das Doppelte ist {zahl * 2}")
except ValueError:
    print("Das war keine Zahl!")`}
        />

        <LsHinweis titel="Debugging-Trick Nummer 1">
          <p>
            Wenn dein Programm Unsinn macht, aber nicht abstürzt, streu <code>print()</code>
            -Zeilen ein und gib Zwischenwerte aus („Was steht WIRKLICH in der Variable?“). Das
            klingt banal, findet aber 90 Prozent aller Logikfehler.
          </p>
        </LsHinweis>

        <Aufgabe nr="9.2">
          <p>
            Baue eine absturzsichere Altersabfrage: Frag so lange nach dem Alter, bis eine gültige
            Zahl kommt. Kombiniere dafür die while-Schleife aus Lektion 5 mit try/except.
          </p>
          <PythonRunner
            rows={9}
            dateiname="uebung_9_2.py"
            label="Python-Code: Übung 9.2"
            initialCode={`# Dein Code:

`}
          />
          <Loesung
            code={`while True:
    eingabe = input("Wie alt bist du? ")
    try:
        alter = int(eingabe)
        break
    except ValueError:
        print("Bitte eine Zahl eingeben!")

print(f"Alles klar, du bist {alter}.")`}
          />
        </Aufgabe>
      </LsAbschnitt>
    </LektionLayout>
  );
}
