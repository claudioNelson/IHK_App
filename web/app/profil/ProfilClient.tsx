"use client";

// Profil-Ansicht: links Lernstand und Pruefungsverlauf, rechts (sticky) die
// Abo-Karte und die Konto-Zeilen. Unter 1024px sortiert konto.css neu:
// Abo, Lernstand, Verlauf, Konto. Alle Daten kommen fertig aus page.tsx.

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { openCustomerPortal } from "@/lib/portal";
import Icon from "@/app/components/konto/Icon";
import { FALLBACK } from "@/app/components/konto/fehler";

export type AboArt = "free" | "web" | "google" | "apple" | "lifetime" | "unbekannt";
export type AboDaten = {
  art: AboArt;
  tier: "monthly" | "halfyear" | "yearly" | "lifetime" | null;
  // Ablauf bzw. naechste Verlaengerung als TT.MM.JJJJ
  bis: string | null;
};

export type Lernstand = {
  fragen: number | null;
  richtigProzent: number | null;
  serie: number | null;
  zuletzt: string | null;
  elo: number | null;
  eloMax: number | null;
  pruefungen: number;
  bestanden: number;
  schnitt: string | null;
  schnittLetzte3: string | null;
};

export type Versuch = {
  id: string;
  iso: string;
  datum: string;
  name: string;
  sub: string | null;
  prozent: number;
  note: number;
  bestanden: boolean;
};

const TIER_WORT: Record<string, string> = {
  monthly: "monatlich",
  halfyear: "halbjährlich",
  yearly: "jährlich",
};

// Web-Endpreise (Stripe) je Laufzeit
const TIER_PREIS: Record<string, string> = {
  monthly: "11,99 € pro Monat",
  halfyear: "47,99 € pro Halbjahr",
  yearly: "84,99 € pro Jahr",
};

const zahl = (n: number) => n.toLocaleString("de-DE");

export default function ProfilClient({
  name,
  email,
  mitgliedSeit,
  mitPasswort,
  abo,
  lernstand,
  verlauf,
  offen,
}: {
  name: string;
  email: string;
  mitgliedSeit: string | null;
  mitPasswort: boolean;
  abo: AboDaten;
  lernstand: Lernstand;
  verlauf: Versuch[];
  offen: number;
}) {
  const [alleZeigen, setAlleZeigen] = useState(false);
  const sichtbar = alleZeigen ? verlauf : verlauf.slice(0, 5);

  return (
    <div className="kt-page">
      <div className="wrap">
        <header className="kt-me">
          <div className="kt-avatar" aria-hidden="true">
            {(name || "?").charAt(0).toUpperCase()}
          </div>
          <div className="kt-me-text">
            <h1>{name}</h1>
            <ul className="kt-meta">
              {email && (
                <li>
                  <Icon name="mail" />
                  <span>{email}</span>
                </li>
              )}
              {mitgliedSeit && (
                <li>
                  <Icon name="calendar" />
                  <span>Mitglied seit {mitgliedSeit}</span>
                </li>
              )}
            </ul>
          </div>
        </header>

        <div className="kt-profile">
          <div className="kt-main">
            <section className="kt-section" aria-labelledby="h-zahlen">
              <div className="kt-section-head">
                <h2 id="h-zahlen">Dein Lernstand</h2>
              </div>
              <Statistik s={lernstand} />
            </section>

            <section className="kt-section" aria-labelledby="h-verlauf">
              <div className="kt-section-head">
                <h2 id="h-verlauf">Deine Übungsprüfungen</h2>
                <Link className="kt-link" href="/pruefungen">Zu den Prüfungen</Link>
              </div>
              {verlauf.length === 0 ? (
                <p className="kt-empty">
                  Noch keine Übungsprüfung abgeschlossen. Nach der Abgabe siehst du hier Note und Punkte.
                  <br />
                  <Link className="kt-link" href="/pruefungen">Zu den Prüfungen</Link>
                </p>
              ) : (
                <ol className="kt-history">
                  {sichtbar.map((v) => (
                    <li key={v.id}>
                      <Link href="/pruefungen">
                        <time className="kt-h-date" dateTime={v.iso}>{v.datum}</time>
                        <span>
                          <span className="kt-h-name">{v.name}</span>
                          {v.sub && <span className="kt-h-sub">{v.sub}</span>}
                        </span>
                        <span className="kt-h-result" data-passed={v.bestanden ? "true" : "false"}>
                          <span className="kt-h-grade">Note {v.note}</span>
                          <span className="kt-h-pct kt-num">
                            {v.prozent} %, {v.bestanden ? "bestanden" : "nicht bestanden"}
                          </span>
                        </span>
                        <Icon name="arrow-r" />
                      </Link>
                    </li>
                  ))}
                </ol>
              )}
              {verlauf.length > 5 && (
                <button
                  className="btn btn-ghost btn-sm kt-more"
                  type="button"
                  aria-expanded={alleZeigen}
                  onClick={() => setAlleZeigen((a) => !a)}
                >
                  {alleZeigen ? "Weniger anzeigen" : `Alle ${verlauf.length} Versuche anzeigen`}
                </button>
              )}
              {offen > 0 && (
                <p className="kt-pending">
                  {offen === 1 ? "1 Versuch ist abgegeben" : `${offen} Versuche sind abgegeben`}, aber noch nicht
                  bewertet. Starte die Korrektur in der App, dann erscheint das Ergebnis hier.
                </p>
              )}
            </section>
          </div>

          <aside className="kt-side" aria-label="Abo und Konto">
            <AboKarte abo={abo} />
            <KontoZeilen email={email} mitPasswort={mitPasswort} />
          </aside>
        </div>
      </div>
    </div>
  );
}

function Statistik({ s }: { s: Lernstand }) {
  return (
    <dl className="kt-stats">
      <div className="kt-stat">
        <dt>Fragen beantwortet</dt>
        <dd>{s.fragen === null ? "Keine Daten" : zahl(s.fragen)}</dd>
        {s.fragen !== null && s.fragen > 0 && s.richtigProzent !== null && (
          <dd className="kt-stat-sub">davon {s.richtigProzent} % richtig</dd>
        )}
      </div>
      <div className="kt-stat">
        <dt>Lernserie</dt>
        <dd>
          {zahl(s.serie ?? 0)}
          <small>{s.serie === 1 ? "Tag" : "Tage"}</small>
        </dd>
        {s.zuletzt && <dd className="kt-stat-sub">zuletzt aktiv am {s.zuletzt}</dd>}
      </div>
      <div className="kt-stat">
        <dt>Arena-Wertung (Elo)</dt>
        <dd>{s.elo === null ? "Keine" : zahl(s.elo)}</dd>
        <dd className="kt-stat-sub">
          {s.elo === null ? "Noch kein Duell gespielt" : s.eloMax !== null ? `Höchstwert ${zahl(s.eloMax)}` : ""}
        </dd>
      </div>
      <div className="kt-stat">
        <dt>Prüfungen absolviert</dt>
        <dd>{zahl(s.pruefungen)}</dd>
        {s.pruefungen > 0 && <dd className="kt-stat-sub">{s.bestanden} davon bestanden</dd>}
      </div>
      <div className="kt-stat">
        <dt>Note im Schnitt</dt>
        <dd>{s.schnitt ?? "Keine"}</dd>
        <dd className="kt-stat-sub">
          {s.schnitt === null
            ? "Noch keine Note"
            : s.schnittLetzte3
              ? `letzte drei: ${s.schnittLetzte3}`
              : `aus ${s.pruefungen} ${s.pruefungen === 1 ? "Prüfung" : "Prüfungen"}`}
        </dd>
      </div>
    </dl>
  );
}

function AboKarte({ abo }: { abo: AboDaten }) {
  const [portal, setPortal] = useState<"ruhe" | "laedt" | "fehler">("ruhe");
  const premium = abo.art !== "free";
  const wort = abo.tier ? TIER_WORT[abo.tier] : undefined;
  const planName = wort ? `Premium, ${wort}` : "Premium";

  async function verwalten() {
    setPortal("laedt");
    const err = await openCustomerPortal();
    if (err) {
      setPortal("fehler");
      requestAnimationFrame(() => document.getElementById("portal-err")?.focus());
    }
  }

  return (
    <section className="kt-plan-card" aria-labelledby="h-abo" data-premium={premium ? "true" : "false"}>
      <div className="kt-plan-top">
        <h2 id="h-abo">Dein Abo</h2>
        {premium ? (
          <span className="kt-chip kt-chip-premium">
            <Icon name="star" />
            Premium
          </span>
        ) : (
          <span className="kt-chip">Kostenlos</span>
        )}
      </div>

      {abo.art === "free" && (
        <div>
          <p className="kt-plan-name">Kostenlos</p>
          <p className="kt-plan-text">Basis-Levels aller Lernpfade, Karteikarten und 3 Arena-Duelle am Tag.</p>
          <div className="kt-plan-actions">
            <Link className="btn btn-primary" href="/upgrade">Premium freischalten</Link>
          </div>
          <p className="kt-plan-hint">
            Alle Levels, Übungsprüfungen mit Korrektur und Ada ohne Limit. Ab 7,08 € im Monat, jederzeit kündbar.
          </p>
        </div>
      )}

      {abo.art === "web" && (
        <div>
          <p className="kt-plan-name">{planName}</p>
          <p className="kt-plan-text">Bezahlt im Web mit Karte.</p>
          <dl className="kt-plan-facts">
            {abo.tier && TIER_PREIS[abo.tier] && (
              <div>
                <dt>Preis</dt>
                <dd className="kt-num">{TIER_PREIS[abo.tier]}</dd>
              </div>
            )}
            {abo.bis && (
              <div>
                <dt>Verlängert sich am</dt>
                <dd className="kt-num">{abo.bis}</dd>
              </div>
            )}
          </dl>
          {portal === "fehler" && (
            <div className="kt-alert" id="portal-err" role="alert" tabIndex={-1}>
              <Icon name="alert" />
              <p>Der Kundenbereich konnte nicht geöffnet werden.</p>
              <p>{FALLBACK}</p>
            </div>
          )}
          <div className="kt-plan-actions">
            <button
              className="btn btn-ghost"
              type="button"
              onClick={verwalten}
              disabled={portal === "laedt"}
              aria-busy={portal === "laedt" || undefined}
            >
              {portal === "laedt" ? (
                <>
                  <span className="kt-spin" aria-hidden="true" />
                  Wird geöffnet
                </>
              ) : (
                "Abo verwalten"
              )}
            </button>
          </div>
          <p className="kt-plan-hint">
            Kündigen, Zahlungsart ändern und Rechnungen findest du im Kundenbereich unseres Zahlungsanbieters Stripe.
            Nach einer Kündigung bleibt Premium bis zum Ende der Laufzeit.
          </p>
        </div>
      )}

      {abo.art === "google" && (
        <div>
          <p className="kt-plan-name">{planName}</p>
          <p className="kt-plan-text">Gekauft in der App über Google Play.</p>
          {abo.bis && (
            <dl className="kt-plan-facts">
              <div>
                <dt>Verlängert sich am</dt>
                <dd className="kt-num">{abo.bis}</dd>
              </div>
            </dl>
          )}
          <div className="kt-store">
            <b>Verwalten und kündigen in Google Play</b>
            Käufe aus der App können wir hier nicht ändern. So geht es:
            <ol>
              <li>Play Store auf dem Handy öffnen</li>
              <li>Profilbild, dann Zahlungen und Abos, dann Abos</li>
              <li>Lernarena auswählen</li>
            </ol>
            <a
              className="kt-link"
              href="https://play.google.com/store/account/subscriptions"
              target="_blank"
              rel="noopener noreferrer"
            >
              Abos in Google Play öffnen
            </a>
          </div>
        </div>
      )}

      {abo.art === "apple" && (
        <div>
          <p className="kt-plan-name">{planName}</p>
          <p className="kt-plan-text">Gekauft in der App über den App Store.</p>
          {abo.bis && (
            <dl className="kt-plan-facts">
              <div>
                <dt>Verlängert sich am</dt>
                <dd className="kt-num">{abo.bis}</dd>
              </div>
            </dl>
          )}
          <div className="kt-store">
            <b>Verwalten und kündigen im App Store</b>
            Käufe aus der App können wir hier nicht ändern. So geht es:
            <ol>
              <li>Einstellungen auf dem iPhone öffnen</li>
              <li>Deinen Namen antippen, dann Abonnements</li>
              <li>Lernarena auswählen</li>
            </ol>
            <a className="kt-link" href="https://apps.apple.com/account/subscriptions" target="_blank" rel="noopener noreferrer">
              Abos im App Store öffnen
            </a>
          </div>
        </div>
      )}

      {abo.art === "lifetime" && (
        <div>
          <p className="kt-plan-name">Premium dauerhaft</p>
          <p className="kt-plan-text">
            Einmal freigeschaltet, ohne Laufzeit. Es gibt nichts zu verwalten oder zu kündigen.
          </p>
        </div>
      )}

      {abo.art === "unbekannt" && (
        <div>
          <p className="kt-plan-name">{planName}</p>
          <p className="kt-plan-text">Für dein Konto freigeschaltet.</p>
          {abo.bis && (
            <dl className="kt-plan-facts">
              <div>
                <dt>Läuft bis</dt>
                <dd className="kt-num">{abo.bis}</dd>
              </div>
            </dl>
          )}
          <p className="kt-plan-hint">
            Bei Fragen schreib uns an{" "}
            <a className="kt-link" href="mailto:info@lernarena.app">info@lernarena.app</a>.
          </p>
        </div>
      )}
    </section>
  );
}

function KontoZeilen({ email, mitPasswort }: { email: string; mitPasswort: boolean }) {
  const router = useRouter();
  const [link, setLink] = useState<"offen" | "laedt" | "gesendet" | "fehler">("offen");
  const [abmelden, setAbmelden] = useState(false);

  async function passwortLink() {
    setLink("laedt");
    const supabase = createClient();
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/update-password`,
    });
    setLink(error ? "fehler" : "gesendet");
  }

  async function abmeldenJetzt() {
    setAbmelden(true);
    const supabase = createClient();
    // Nur diesen Browser abmelden, die App bleibt angemeldet.
    await supabase.auth.signOut({ scope: "local" });
    router.replace("/");
    router.refresh();
  }

  return (
    <section className="kt-rows" aria-labelledby="h-konto">
      <h2 id="h-konto">Konto</h2>

      <div className="kt-row">
        <span className="kt-row-title">Passwort ändern</span>
        {mitPasswort ? (
          <>
            <span className="kt-row-text">Wir schicken dir einen Link an {email}.</span>
            <button
              className="btn btn-ghost btn-sm"
              type="button"
              onClick={passwortLink}
              disabled={link === "laedt" || link === "gesendet"}
              aria-busy={link === "laedt" || undefined}
            >
              {link === "laedt" ? (
                <>
                  <span className="kt-spin" aria-hidden="true" />
                  Wird gesendet
                </>
              ) : link === "gesendet" ? (
                "Gesendet"
              ) : (
                "Link senden"
              )}
            </button>
            {link === "gesendet" && (
              <p className="kt-row-sent" role="status">
                <Icon name="check" />
                Der Link ist unterwegs. Er gilt eine Stunde.
              </p>
            )}
            {link === "fehler" && (
              <p className="kt-error" role="alert">
                <Icon name="alert" />
                <span>Der Link konnte nicht gesendet werden. Warte kurz und versuch es noch einmal.</span>
              </p>
            )}
          </>
        ) : (
          <span className="kt-row-text">Du meldest dich mit Google an.</span>
        )}
      </div>

      <div className="kt-row">
        <span className="kt-row-title">Abmelden</span>
        <span className="kt-row-text">Nur auf diesem Gerät. In der App bleibst du angemeldet.</span>
        <button
          className="btn btn-ghost btn-sm"
          type="button"
          onClick={abmeldenJetzt}
          disabled={abmelden}
          aria-busy={abmelden || undefined}
        >
          {abmelden ? (
            <>
              <span className="kt-spin" aria-hidden="true" />
              Wird abgemeldet
            </>
          ) : (
            "Abmelden"
          )}
        </button>
      </div>

      <div className="kt-row">
        <span className="kt-row-title">Konto löschen</span>
        <span className="kt-row-text">So beantragst du die Löschung deiner Daten.</span>
        <Link className="kt-row-go" href="/account-loeschung" aria-label="Konto löschen: zur Anleitung">
          <Icon name="arrow-r" />
        </Link>
      </div>
    </section>
  );
}
