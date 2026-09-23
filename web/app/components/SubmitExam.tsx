"use client";

// Abgabe: Block am Ende der Pruefung, Bestaetigungsdialog und der Dialog
// bei abgelaufener Zeit. Offene Teilaufgaben (ohne Antwort) werden mit
// Kennung genannt und am Seitenende als Sprunglinks angeboten.

import ExamDialog from "./ExamDialog";
import Icon from "./ExamIcons";

export interface OpenQuestion {
  id: string;      // Question.id
  label: string;   // 1a, 2b, ...
  title: string;
}

function openText(open: number): string {
  if (open === 0) return "Alle Teilaufgaben sind beantwortet. Du kannst abgeben oder die restliche Zeit zum Prüfen nutzen.";
  const head = open === 1 ? "Eine Teilaufgabe ist noch ohne Antwort." : `${open} Teilaufgaben sind noch ohne Antwort.`;
  return `${head} Leere Antworten zählen mit 0 Punkten.`;
}

/** Abgabeblock am Ende der Pruefung. */
export default function SubmitExam({
  open,
  onOpenDialog,
}: {
  open: OpenQuestion[];
  onOpenDialog: () => void;
}) {
  return (
    <section className="ex-panel ex-submit" aria-labelledby="ex-h-submit">
      <h2 id="ex-h-submit">Abgabe</h2>
      <p>{openText(open.length)}</p>
      {open.length > 0 && (
        <nav className="ex-open" aria-label="Teilaufgaben ohne Antwort">
          {open.map((q) => (
            <a key={q.id} href={`#q-${q.id}`}>
              <span>{q.label}</span>
              {q.title}
            </a>
          ))}
        </nav>
      )}
      <button className="btn btn-primary" type="button" onClick={onOpenDialog}>
        Prüfung abgeben
      </button>
    </section>
  );
}

/** Bestaetigung vor der Abgabe. Der sichere Knopf hat den Fokus. */
export function SubmitDialog({
  isOpen,
  open,
  total,
  onCancel,
  onConfirm,
}: {
  isOpen: boolean;
  open: OpenQuestion[];
  total: number;
  onCancel: () => void;
  onConfirm: () => void;
}) {
  return (
    <ExamDialog open={isOpen} onClose={onCancel} labelledBy="ex-dlg-submit-h" describedBy="ex-dlg-submit-state">
      <div className="ex-dialog-body">
        <h2 id="ex-dlg-submit-h">Prüfung abgeben?</h2>
        {open.length > 0 ? (
          <div className="ex-note is-warn" id="ex-dlg-submit-state">
            <Icon name="alert" />
            <span>
              <b>{open.length} von {total} Teilaufgaben ohne Antwort:</b> {open.map((q) => q.label).join(", ")}.
            </span>
          </div>
        ) : (
          <div className="ex-note is-ok" id="ex-dlg-submit-state">
            <Icon name="check-c" />
            <span><b>Alle {total} Teilaufgaben beantwortet.</b></span>
          </div>
        )}
        <p>Danach kannst du deine Antworten noch ansehen, aber nicht mehr ändern. Ada korrigiert sie, sobald du die Korrektur anforderst.</p>
      </div>
      <div className="ex-dialog-actions">
        <button className="btn btn-ghost" type="button" onClick={onCancel} data-autofocus>
          Weiter bearbeiten
        </button>
        <button className="btn btn-primary" type="button" onClick={onConfirm}>
          Jetzt abgeben
        </button>
      </div>
    </ExamDialog>
  );
}

/** Zeit abgelaufen: bereits automatisch abgegeben, laesst sich nicht wegklicken. */
export function TimeUpDialog({
  isOpen,
  answered,
  total,
  onContinue,
}: {
  isOpen: boolean;
  answered: number;
  total: number;
  onContinue: () => void;
}) {
  return (
    <ExamDialog open={isOpen} onClose={onContinue} dismissable={false} labelledBy="ex-dlg-timeup-h" describedBy="ex-dlg-timeup-text">
      <div className="ex-dialog-body">
        <h2 id="ex-dlg-timeup-h">Die Zeit ist abgelaufen</h2>
        <p id="ex-dlg-timeup-text">
          Deine Antworten wurden automatisch abgegeben. {answered} von {total} Teilaufgaben waren beantwortet.
        </p>
      </div>
      <div className="ex-dialog-actions">
        <button className="btn btn-primary" type="button" onClick={onContinue} data-autofocus>
          Zum Ergebnis
        </button>
      </div>
    </ExamDialog>
  );
}
