"use client";

// Intro vor dem Start: links Ausgangssituation und Aufbau, rechts eine
// klebende Startkarte mit Eckdaten, Regeln, Uebungsmodus und "Pruefung
// starten". Rahmen mit normalem SiteHeader und Footer (PageShell).

import { useState } from "react";
import Link from "next/link";
import type { Exam } from "@/data/exam-types";
import PageShell from "@/app/components/shell/PageShell";
import Icon from "./ExamIcons";
import { answerableQuestions, groupLabel, passPoints } from "@/app/pruefungen/exam-state";
import { TextBlocks } from "./ExamText";

interface ExamIntroProps {
  exam: Exam;
  onStart: (practice: boolean) => void;
}

export default function ExamIntro({ exam, onStart }: ExamIntroProps) {
  const [practice, setPractice] = useState(false);

  const sectionCount = exam.sections.length;
  const partCount = answerableQuestions(exam).length;
  const choose = exam.sectionsToChoose && exam.sectionsToChoose < sectionCount ? exam.sectionsToChoose : null;

  return (
    <PageShell className="ex">
      <div className="wrap">
        <div className="ex-intro">
          <div>
            <header className="ex-intro-head">
              <nav className="crumbs" aria-label="Brotkrumen">
                <Link href="/pruefungen">Prüfungen</Link>
                <span aria-hidden="true">/</span>
                <span>{groupLabel(exam.level, exam.fachrichtung)}</span>
              </nav>
              <h1>{exam.title}</h1>
              <p className="ex-meta">
                <span>{exam.season} {exam.year}</span>
                <span>{exam.company}</span>
              </p>
            </header>

            {exam.scenario && (
              <section className="ex-prose" aria-labelledby="ex-h-situation">
                <h2 id="ex-h-situation">Ausgangssituation</h2>
                <TextBlocks text={exam.scenario} />
              </section>
            )}

            <section className="ex-prose" aria-labelledby="ex-h-aufbau">
              <h2 id="ex-h-aufbau">Aufbau</h2>
              <ol className="ex-outline">
                {exam.sections.map((s, i) => (
                  <li key={s.id}>
                    <span className="ex-q-id">{i + 1}</span>
                    <span>{s.title}</span>
                    <span className="ex-pts">{s.totalPoints} Punkte</span>
                  </li>
                ))}
              </ol>
            </section>
          </div>

          <aside className="ex-panel ex-start" aria-label="Start">
            <dl className="ex-facts">
              <div>
                <dt>Bearbeitungszeit</dt>
                <dd>{exam.duration}<small>Min</small></dd>
              </div>
              <div>
                <dt>Punkte</dt>
                <dd>{exam.totalPoints}</dd>
              </div>
              <div>
                <dt>Aufgaben</dt>
                {choose ? (
                  <dd>{choose}<small>von {sectionCount} wählen</small></dd>
                ) : (
                  <dd>{sectionCount}<small>mit {partCount} Teilen</small></dd>
                )}
              </div>
              <div>
                <dt>Bestanden ab</dt>
                <dd>{passPoints(exam.totalPoints)}<small>Punkten</small></dd>
              </div>
            </dl>

            <ul className="ex-rules">
              <li>
                <Icon name="clock" />
                <span><b>Die Zeit läuft ab dem Start</b> und lässt sich nicht anhalten. Wenn sie abläuft, wird automatisch abgegeben.</span>
              </li>
              <li>
                <Icon name="refresh" />
                <span><b>Antworten werden laufend gespeichert,</b> auch wenn du die Seite neu lädst.</span>
              </li>
              <li>
                <Icon name="ban" />
                <span><b>Ohne Hilfsmittel</b> übst du so, wie es am Prüfungstag zählt.</span>
              </li>
              <li>
                <Icon name="chat" />
                <span><b>Nach der Abgabe korrigiert Ada</b> jede Teilaufgabe nach Punkteschema.</span>
              </li>
            </ul>

            <label className="ex-switch">
              <span className="ex-switch-label">Übungsmodus</span>
              <span className="ex-switch-help" id="ex-practice-help">Ohne Zeitlimit. Die Zeit wird nur mitgezählt.</span>
              <input
                type="checkbox"
                role="switch"
                checked={practice}
                onChange={(e) => setPractice(e.target.checked)}
                aria-checked={practice}
                aria-describedby="ex-practice-help"
              />
            </label>

            <button className="btn btn-primary" type="button" onClick={() => onStart(practice)}>
              Prüfung starten
            </button>
          </aside>
        </div>
      </div>
    </PageShell>
  );
}
