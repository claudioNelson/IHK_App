"use client";

// Premium-Seite: links Kopf, Vergleich Kostenlos/Premium und FAQ, rechts
// (sticky) der Kaufkasten mit drei Laufzeiten und EINEM Knopf. Auf Handy
// und Tablet steht der Kaufkasten unter dem Kopf, am Ende ein Abschluss-
// kasten mit demselben Knopf (Reihenfolge in konto.css).

import { useState } from "react";
import Link from "next/link";
import { startCheckout } from "@/lib/checkout";
import Icon from "@/app/components/konto/Icon";

export type Laufzeit = "monthly" | "halfyear" | "yearly";

const PLAENE: Record<
  Laufzeit,
  { name: string; sub: string; preis: string; zeitraum: string; danach: string; sparen: string }
> = {
  monthly: {
    name: "Monatlich",
    sub: "Monatlich kündbar",
    preis: "11,99 €",
    zeitraum: "pro Monat",
    danach: "danach jeden Monat",
    sparen: "",
  },
  halfyear: {
    name: "Halbjährlich",
    sub: "entspricht 8,00 € pro Monat",
    preis: "47,99 €",
    zeitraum: "für 6 Monate",
    danach: "danach alle 6 Monate",
    sparen: "Gegenüber monatlich sparst du 23,95 € im Halbjahr.",
  },
  yearly: {
    name: "Jährlich",
    sub: "entspricht 7,08 € pro Monat",
    preis: "84,99 €",
    zeitraum: "für 12 Monate",
    danach: "danach alle 12 Monate",
    sparen: "Gegenüber monatlich sparst du 58,89 € im Jahr.",
  },
};

const REIHE: Laufzeit[] = ["monthly", "halfyear", "yearly"];

function Ja() {
  return (
    <>
      <Icon name="check" className="kt-yes" />
      <span className="kt-sr">enthalten</span>
    </>
  );
}
function Nein() {
  return (
    <>
      <Icon name="minus" className="kt-no" />
      <span className="kt-sr">nicht enthalten</span>
    </>
  );
}

const FAQ: { f: string; a: string }[] = [
  {
    f: "Wie kündige ich?",
    a: "In deinem Profil unter „Abo verwalten“. Du kündigst zum Ende der laufenden Laufzeit, bis dahin bleibt Premium aktiv. Es gibt keine Mindestlaufzeit über den gewählten Zeitraum hinaus.",
  },
  {
    f: "Wie bezahle ich?",
    a: "Im Web per Karte über unseren Zahlungsanbieter Stripe. Deine Kartendaten landen nur bei Stripe, nicht bei uns. Die Quittung kommt per E-Mail, Rechnungen findest du später unter „Abo verwalten“.",
  },
  {
    f: "Verlängert sich das Abo automatisch?",
    a: "Ja, jeweils um den gewählten Zeitraum zum selben Preis, bis du kündigst. Das Datum der nächsten Zahlung steht in deinem Profil.",
  },
  {
    f: "Ich habe Premium in der App gekauft. Gilt das hier auch?",
    a: "Ja, Premium hängt an deinem Konto, nicht am Gerät. Melde dich im Web mit demselben Konto an und kauf nicht noch einmal. Verwalten und kündigen kannst du einen App-Kauf nur in Google Play oder im App Store.",
  },
];

export default function UpgradeClient({
  angemeldet,
  schonPremium,
  next,
  startPlan,
}: {
  angemeldet: boolean;
  schonPremium: boolean;
  next: string | null;
  startPlan: Laufzeit;
}) {
  const [plan, setPlan] = useState<Laufzeit>(startPlan);
  const [zustand, setZustand] = useState<"normal" | "laedt" | "fehler">("normal");
  const p = PLAENE[plan];

  async function zurZahlung() {
    setZustand("laedt");
    const zurueck = `/upgrade?plan=${plan}${next ? `&next=${encodeURIComponent(next)}` : ""}`;
    const err = await startCheckout(plan, zurueck);
    if (err) {
      setZustand("fehler");
      requestAnimationFrame(() => document.getElementById("buy-err")?.focus());
    }
    // Erfolg oder Anmeldung: der Browser wechselt die Seite
  }

  const busy = zustand === "laedt";
  const knopf = (
    <button className="btn btn-primary kt-submit" type="button" onClick={zurZahlung} disabled={busy} aria-busy={busy || undefined}>
      {busy ? (
        <>
          <span className="kt-spin" aria-hidden="true" />
          Weiter zu Stripe
        </>
      ) : (
        "Weiter zur Zahlung"
      )}
    </button>
  );

  return (
    <div className="kt-page">
      <div className="wrap kt-up">
        <div className="kt-main">
          <div className="page-head">
            <nav className="crumbs" aria-label="Pfad">
              {angemeldet ? <Link href="/profil">Profil</Link> : <Link href="/">Lernarena</Link>}
              <span aria-hidden="true">/</span>
              <span aria-current="page">Premium</span>
            </nav>
            <h1>Premium für die heiße Phase vor der Prüfung</h1>
            <p className="lead">
              Alle Levels, Übungsprüfungen mit Korrektur und Ada ohne Limit. Im Web und in der App, mit demselben Konto.
            </p>
            <ul className="kt-up-points">
              <li>
                <Icon name="refresh" />
                Jederzeit kündbar
              </li>
              <li>
                <Icon name="lock" />
                Zahlung über Stripe
              </li>
              <li>
                <Icon name="phone" />
                Gilt auch in der App
              </li>
            </ul>
          </div>

          <section className="kt-section" aria-labelledby="h-vergleich">
            <div className="kt-section-head">
              <h2 id="h-vergleich">Was Premium freischaltet</h2>
            </div>
            <div className="kt-compare-wrap">
              <table className="kt-compare">
                <caption className="kt-sr">Funktionen kostenlos und mit Premium im Vergleich</caption>
                <thead>
                  <tr>
                    <th scope="col"><span className="kt-sr">Funktion</span></th>
                    <th scope="col">Kostenlos</th>
                    <th scope="col" className="kt-col-pro">Premium</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th scope="row">
                      Levels und Themen
                      <small>Basis-Levels aller Lernpfade frei, dazu Praxis- und Prüfungs-Levels mit Premium</small>
                    </th>
                    <td>Basis-Levels</td>
                    <td className="kt-col-pro">Alle, ohne Kontingent</td>
                  </tr>
                  <tr>
                    <th scope="row">
                      Übungsprüfungen
                      <small>Mit Korrektur, Note und Auswertung je Aufgabe</small>
                    </th>
                    <td><Nein /></td>
                    <td className="kt-col-pro"><Ja /></td>
                  </tr>
                  <tr>
                    <th scope="row">
                      KI-Tutorin Ada
                      <small>Erklärt dir Fehler und beantwortet Rückfragen</small>
                    </th>
                    <td>Bei Fehlern</td>
                    <td className="kt-col-pro">Unbegrenzt</td>
                  </tr>
                  <tr>
                    <th scope="row">Arena-Duelle</th>
                    <td>3 pro Tag</td>
                    <td className="kt-col-pro">Unbegrenzt</td>
                  </tr>
                  <tr>
                    <th scope="row">Tagesplan, Karteikarten und Wiederholungen</th>
                    <td><Ja /></td>
                    <td className="kt-col-pro"><Ja /></td>
                  </tr>
                  <tr>
                    <th scope="row">
                      Cloud-Zertifikate
                      <small>Vorbereitung für AWS, Azure, GCP und SAP</small>
                    </th>
                    <td><Nein /></td>
                    <td className="kt-col-pro"><Ja /></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <section className="kt-section" aria-labelledby="h-faq">
            <div className="kt-section-head">
              <h2 id="h-faq">Häufige Fragen</h2>
            </div>
            <div className="kt-faq">
              {FAQ.map((q) => (
                <details key={q.f}>
                  <summary>
                    {q.f}
                    <Icon name="plus" />
                  </summary>
                  <p>{q.a}</p>
                </details>
              ))}
            </div>
          </section>

          {!schonPremium && (
            <section className="kt-end" aria-labelledby="h-end">
              <h2 id="h-end">Bereit für die Prüfung?</h2>
              <p>
                Heute {p.preis}, {p.danach}. Jederzeit kündbar.
              </p>
              {knopf}
            </section>
          )}
        </div>

        {schonPremium ? (
          <aside className="kt-buy kt-card" aria-labelledby="h-buy">
            <h2 id="h-buy" className="kt-plan-name">Du hast schon Premium</h2>
            <p className="kt-plan-text">
              Alles ist freigeschaltet, im Web und in der App. Laufzeit und Verwaltung findest du in deinem Profil.
            </p>
            <div className="kt-plan-actions">
              {next && <Link className="btn btn-primary" href={next}>Weiter</Link>}
              <Link className={next ? "btn btn-ghost" : "btn btn-primary"} href="/profil">Zu deinem Profil</Link>
            </div>
          </aside>
        ) : (
          <aside className="kt-buy kt-card" aria-labelledby="h-buy">
            <form onSubmit={(e) => { e.preventDefault(); zurZahlung(); }}>
              <fieldset>
                <legend id="h-buy">Laufzeit wählen</legend>
                <div className="kt-opts">
                  {REIHE.map((t) => {
                    const x = PLAENE[t];
                    return (
                      <label className="kt-opt" key={t}>
                        <input
                          type="radio"
                          name="tier"
                          value={t}
                          checked={plan === t}
                          onChange={() => setPlan(t)}
                          disabled={busy}
                        />
                        <span className="kt-opt-name">
                          {x.name}
                          {t === "yearly" && <span className="kt-tag">Empfehlung</span>}
                        </span>
                        <span className="kt-opt-sub">{x.sub}</span>
                        <span className="kt-opt-price">
                          <b>{x.preis}</b>
                          <span>{x.zeitraum}</span>
                        </span>
                      </label>
                    );
                  })}
                </div>
              </fieldset>

              <p className="kt-buy-sum" aria-live="polite">
                Heute zahlst du <b>{p.preis}</b>, {p.danach}.{p.sparen && ` ${p.sparen}`}
              </p>

              {zustand === "fehler" && (
                <div className="kt-alert" id="buy-err" role="alert" tabIndex={-1}>
                  <Icon name="alert" />
                  <p>Die Zahlung konnte nicht gestartet werden.</p>
                  <p>
                    Versuch es gleich noch einmal. Wenn es wieder nicht klappt, schreib uns an{" "}
                    <a className="kt-link" href="mailto:info@lernarena.app">info@lernarena.app</a>.
                  </p>
                </div>
              )}

              {knopf}

              <ul className="kt-fine">
                <li>
                  <Icon name="lock" />
                  Sichere Zahlung per Karte über Stripe. Alle Preise sind Endpreise.
                </li>
                <li>
                  <Icon name="phone" />
                  In der App kaufst du über Google Play oder den App Store.
                </li>
              </ul>
            </form>
          </aside>
        )}
      </div>
    </div>
  );
}
