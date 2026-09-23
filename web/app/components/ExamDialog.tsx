"use client";

// Natives <dialog> fuer Abgabe, Zeitablauf und Neubeginn.
// showModal() bringt Fokusfalle, Escape und den Top-Layer mit. Beim Oeffnen
// bekommt das Element mit data-autofocus den Fokus (sonst der Dialog selbst),
// beim Schliessen geht der Fokus zurueck an das vorher fokussierte Element.

import { useEffect, useRef, type ReactNode } from "react";

export default function ExamDialog({
  open,
  onClose,
  labelledBy,
  describedBy,
  dismissable = true,
  className,
  children,
}: {
  open: boolean;
  /** Wird bei Escape aufgerufen (nur wenn dismissable). */
  onClose: () => void;
  labelledBy: string;
  describedBy?: string;
  /** false: Escape schliesst nicht (Zeit abgelaufen). */
  dismissable?: boolean;
  className?: string;
  children: ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  const returnFocus = useRef<HTMLElement | null>(null);
  const openRef = useRef(open);
  useEffect(() => {
    openRef.current = open;
  }, [open]);

  useEffect(() => {
    const dlg = ref.current;
    if (!dlg) return;
    if (open && !dlg.open) {
      returnFocus.current = document.activeElement instanceof HTMLElement ? document.activeElement : null;
      try {
        dlg.showModal();
      } catch {
        dlg.setAttribute("open", "");
      }
      const auto = dlg.querySelector<HTMLElement>("[data-autofocus]");
      (auto ?? dlg).focus();
    } else if (!open && dlg.open) {
      dlg.close();
    }
  }, [open]);

  // Fokus zurueckgeben, sobald der Dialog zu ist
  useEffect(() => {
    if (open) return;
    const el = returnFocus.current;
    returnFocus.current = null;
    if (el && el.isConnected) el.focus({ preventScroll: true });
  }, [open]);

  return (
    <dialog
      ref={ref}
      className={className ? `ex-dialog ${className}` : "ex-dialog"}
      role="dialog"
      aria-modal="true"
      aria-labelledby={labelledBy}
      aria-describedby={describedBy}
      tabIndex={-1}
      onCancel={(e) => {
        // Escape: Browser wuerde sofort schliessen, wir steuern es ueber open
        e.preventDefault();
        if (dismissable) onClose();
      }}
      onClose={() => {
        // Der Browser kann trotz preventDefault schliessen (zweites Escape
        // ohne Nutzeraktion). Dann den Zustand nachziehen bzw. wieder oeffnen.
        if (!openRef.current) return;
        if (dismissable) onClose();
        else {
          try {
            ref.current?.showModal();
          } catch {}
        }
      }}
    >
      {children}
    </dialog>
  );
}
