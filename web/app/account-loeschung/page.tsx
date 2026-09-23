import type { Metadata } from "next";
import Link from "next/link";
import Icon from "@/app/components/konto/Icon";
import KopierenKnopf from "./KopierenKnopf";

export const metadata: Metadata = {
    title: "Konto löschen",
    description:
        "So beantragst du die Löschung deines Lernarena-Kontos und aller Daten dazu: per E-Mail von der Adresse deines Kontos.",
};

const KONTAKT = "info@lernarena.app";
const BETREFF = "Konto löschen";

// Angezeigter und kopierter Text (mit Platzhaltern)
const MAIL_TEXT =
    "Hallo Lernarena-Team,\n" +
    "bitte löscht mein Konto und alle zugehörigen Daten.\n" +
    "Meine Konto-E-Mail: [deine Adresse]\n" +
    "Mein Nutzername: [dein Nutzername]";

// Text fuer das Mailprogramm (Felder zum Ausfuellen leer)
const MAILTO =
    `mailto:${KONTAKT}` +
    `?subject=${encodeURIComponent(BETREFF)}` +
    `&body=${encodeURIComponent(
        "Hallo Lernarena-Team,\n\n" +
            "bitte löscht mein Konto und alle zugehörigen Daten.\n\n" +
            "Meine Konto-E-Mail: \n" +
            "Mein Nutzername: ",
    )}`;

export default function AccountLoeschungPage() {
    return (
        <div className="kt-page">
            <div className="wrap kt-del">
                <div className="kt-main">
                    <div className="page-head">
                        <nav className="crumbs" aria-label="Pfad">
                            <Link href="/">Lernarena</Link>
                            <span aria-hidden="true">/</span>
                            <span aria-current="page">Konto löschen</span>
                        </nav>
                        <h1>Konto löschen</h1>
                        <p className="lead">
                            Du kannst dein Konto und alle Daten dazu jederzeit löschen lassen. Das läuft per E-Mail,
                            damit niemand anderes es in deinem Namen tun kann.
                        </p>
                    </div>

                    <div className="kt-note" role="note">
                        <Icon name="alert" />
                        <b>Hast du Premium? Kündige zuerst dein Abo.</b>
                        <p>
                            Ein Abo aus der App läuft über Google Play oder den App Store und endet nicht automatisch,
                            wenn wir dein Konto löschen. Kündige es dort. Ein Web-Abo kündigst du im{" "}
                            <Link className="kt-link" href="/profil">Profil</Link> unter „Abo verwalten“.
                        </p>
                    </div>

                    <section className="kt-section" aria-labelledby="h-so">
                        <div className="kt-section-head">
                            <h2 id="h-so">So beantragst du die Löschung</h2>
                        </div>
                        <ol className="kt-steps">
                            <li>
                                <b>Schreib uns eine E-Mail</b>
                                <p>
                                    An <a className="kt-link" href={`mailto:${KONTAKT}`}>{KONTAKT}</a> mit dem Betreff
                                    „{BETREFF}“. Die Vorlage auf dieser Seite kannst du so übernehmen.
                                </p>
                            </li>
                            <li>
                                <b>Von der Adresse deines Kontos</b>
                                <p>
                                    Sende die E-Mail von der Adresse, mit der du dich bei Lernarena anmeldest. Nur so
                                    können wir sicher sein, dass die Anfrage von dir kommt.
                                </p>
                            </li>
                            <li>
                                <b>Wir bestätigen und löschen</b>
                                <p>Du bekommst eine Eingangsbestätigung. Spätestens nach 30 Tagen ist alles gelöscht.</p>
                            </li>
                        </ol>
                    </section>

                    <section className="kt-section" aria-labelledby="h-was">
                        <div className="kt-section-head">
                            <h2 id="h-was">Was dabei passiert</h2>
                        </div>
                        <div className="kt-split">
                            <div>
                                <h3>Wird dauerhaft gelöscht</h3>
                                <ul className="kt-list">
                                    <li><Icon name="x" />Dein Profil: Nutzername, E-Mail-Adresse und Anmeldung</li>
                                    <li><Icon name="x" />Lernfortschritt, Statistiken und Lernserie</li>
                                    <li><Icon name="x" />Karteikarten und Wiederholungen</li>
                                    <li><Icon name="x" />Ergebnisse deiner Übungsprüfungen, Zertifikate und Abzeichen</li>
                                    <li><Icon name="x" />Arena-Wertung, Duelle und Einträge in Bestenlisten</li>
                                </ul>
                            </div>
                            <div>
                                <h3>Bleibt bestehen</h3>
                                <ul className="kt-list">
                                    <li>
                                        <Icon name="minus" />
                                        Allgemeine Inhalte wie Fragen, Lernseiten und Kurse. Sie gehören zu niemandem
                                        persönlich.
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <p className="kt-prose" style={{ marginTop: 24 }}>
                            Die Löschung ist <strong>endgültig</strong>. Wenn du später wiederkommst, fängst du mit
                            einem neuen Konto bei null an.
                        </p>
                    </section>
                </div>

                <aside className="kt-mail kt-card" aria-labelledby="h-mail">
                    <h2 id="h-mail">Deine E-Mail an uns</h2>
                    <p>Öffne sie direkt in deinem Mailprogramm oder kopiere den Text.</p>
                    <dl className="kt-mail-box">
                        <div>
                            <dt>An</dt>
                            <dd>{KONTAKT}</dd>
                        </div>
                        <div>
                            <dt>Betreff</dt>
                            <dd>{BETREFF}</dd>
                        </div>
                        <div>
                            <dt>Text</dt>
                            <dd className="kt-mail-body">{MAIL_TEXT}</dd>
                        </div>
                    </dl>
                    <div className="kt-mail-actions">
                        <a className="btn btn-primary" href={MAILTO}>
                            <Icon name="mail" size={18} />
                            E-Mail öffnen
                        </a>
                        <KopierenKnopf text={MAIL_TEXT} />
                    </div>
                </aside>
            </div>
        </div>
    );
}
