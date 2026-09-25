// Gemeinsamer Fuss fuer lernarena.app (aus der Startseite herausgeloest,
// 23.09.2026). Server-Komponente, Styles in globals.css (.site-footer, .foot).

import Link from "next/link";
import { LogoMark } from "./SiteHeader";

export const PLAY_URL = "https://play.google.com/store/apps/details?id=app.lernarena";
export const APPSTORE_URL = "https://apps.apple.com/de/app/id6802045311";

export default function SiteFooter() {
  return (
    <footer className="site-footer">
      <div className="wrap">
        <div className="foot">
          <div>
            <Link className="logo" href="/">
              <LogoMark />
              Lernarena
            </Link>
            <p className="foot-tag">Prüfungsvorbereitung für Fachinformatiker. Kein Angebot der IHK.</p>
          </div>
          <div>
            <h4>Produkt</h4>
            <ul>
              <li><Link href="/#product">Funktionen</Link></li>
              <li><Link href="/#pricing">Preise</Link></li>
              <li><Link href="/#ada">Ada</Link></li>
              <li><Link href="/pruefungen">Prüfungen</Link></li>
              <li><Link href="/fachinformatiker-pruefung">Prüfungs-Guide</Link></li>
            </ul>
          </div>
          <div>
            <h4>Lernen</h4>
            <ul>
              <li><Link href="/lernen">Lernseiten</Link></li>
              <li><Link href="/kurse">Kurse</Link></li>
              <li><Link href="/python-kurs">Python-Kurs</Link></li>
              <li><Link href="/uml-kurs">UML-Kurs</Link></li>
              <li><Link href="/struktogramm-kurs">Struktogramm-Kurs</Link></li>
              <li><a href={PLAY_URL} target="_blank" rel="noopener noreferrer">Android-App</a></li>
              <li><a href={APPSTORE_URL} target="_blank" rel="noopener noreferrer">iPhone-App</a></li>
              <li><Link href="/login">Anmelden</Link></li>
              <li><Link href="/signup">Registrieren</Link></li>
            </ul>
          </div>
          <div>
            <h4>Rechtliches</h4>
            <ul>
              <li><Link href="/impressum">Impressum</Link></li>
              <li><Link href="/datenschutz">Datenschutz</Link></li>
              <li><Link href="/agb">AGB</Link></li>
              <li><Link href="/account-loeschung">Konto löschen</Link></li>
              <li><a href="mailto:info@lernarena.app">Kontakt</a></li>
            </ul>
          </div>
        </div>
        <div className="foot-bottom">© {new Date().getFullYear()} Lernarena</div>
      </div>
    </footer>
  );
}
