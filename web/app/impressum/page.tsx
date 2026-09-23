import type { Metadata } from "next";
import RechtSeite, { type Abschnitt } from "../components/RechtSeite";
import { LsAbschnitt } from "../lernen/_components/LsBausteine";

export const metadata: Metadata = {
  title: "Impressum",
  description: "Impressum und Anbieterkennzeichnung gemäß § 5 DDG",
  alternates: {
    canonical: "https://lernarena.app/impressum",
  },
};

const abschnitte: Abschnitt[] = [
  { id: "anbieter", titel: "Anbieter" },
  { id: "kontakt", titel: "Kontakt" },
  { id: "taetigkeit", titel: "Angaben zur Tätigkeit" },
  { id: "haftung", titel: "Haftungsausschluss" },
  { id: "streitbeilegung", titel: "Verbraucherstreitbeilegung" },
  { id: "urheberrecht", titel: "Urheberrecht" },
];

export default function ImpressumPage() {
  return (
    <RechtSeite
      titel="Impressum"
      untertitel="Angaben gemäß § 5 DDG (Digitale-Dienste-Gesetz)"
      abschnitte={abschnitte}
    >
      <LsAbschnitt id="anbieter" titel="Anbieter">
        <p>
          <strong>Claudio Medeiros Magalhaes</strong>
          <br />
          Westfalenweg 3
          <br />
          49504 Lotte
          <br />
          Deutschland
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="kontakt" titel="Kontakt">
        <p>
          E-Mail: <a href="mailto:info@lernarena.app">info@lernarena.app</a>
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="taetigkeit" titel="Angaben zur Tätigkeit">
        <p>Tätigkeitsbereich: Softwareentwicklung und digitale Bildungsangebote</p>
        <p>Unternehmensform: Einzelunternehmen</p>
      </LsAbschnitt>

      <LsAbschnitt id="haftung" titel="Haftungsausschluss">
        <h3>Haftung für Inhalte</h3>
        <p>
          Als Diensteanbieter sind wir gemäß § 7 Abs. 1 DDG für eigene
          Inhalte auf diesen Seiten nach den allgemeinen Gesetzen
          verantwortlich. Nach §§ 8 bis 10 DDG sind wir als
          Diensteanbieter jedoch nicht verpflichtet, übermittelte oder
          gespeicherte fremde Informationen zu überwachen oder nach
          Umständen zu forschen, die auf eine rechtswidrige Tätigkeit
          hinweisen.
        </p>

        <h3>Keine offizielle IHK-Zugehörigkeit</h3>
        <p>
          Lernarena ist ein unabhängiges, privates Lernangebot und steht
          in keiner offiziellen Verbindung zur IHK (Industrie- und
          Handelskammer) oder anderen Prüfungsbehörden. Alle
          Prüfungsfragen und Lerninhalte dienen ausschließlich der
          Prüfungsvorbereitung und erheben keinen Anspruch auf
          Vollständigkeit oder offizielle Gültigkeit.
        </p>

        <h3>Haftung für Links</h3>
        <p>
          Unser Angebot enthält Links zu externen Websites Dritter, auf
          deren Inhalte wir keinen Einfluss haben. Deshalb können wir für
          diese fremden Inhalte auch keine Gewähr übernehmen. Für die
          Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter
          oder Betreiber der Seiten verantwortlich.
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="streitbeilegung" titel="Verbraucherstreitbeilegung">
        <p>
          Wir sind nicht bereit und nicht verpflichtet, an
          Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle
          teilzunehmen (§ 36 VSBG).
        </p>
      </LsAbschnitt>

      <LsAbschnitt id="urheberrecht" titel="Urheberrecht">
        <p>
          Die durch den Seitenbetreiber erstellten Inhalte und Werke auf
          diesen Seiten unterliegen dem deutschen Urheberrecht. Die
          Vervielfältigung, Bearbeitung, Verbreitung und jede Art der
          Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der
          schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers.
        </p>
      </LsAbschnitt>
    </RechtSeite>
  );
}