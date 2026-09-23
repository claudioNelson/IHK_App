// Rahmen der schmalen Auth-Karte (420px) direkt unter dem Header:
//   <AuthKarte titelId="h-login" fuss={<>Neu hier?<Link ...>Registrieren</Link></>}>
//     ...Kopf, Formular, Google...
//   </AuthKarte>
// Optional ein Zurueck-Link ueber der Karte. Styles in konto.css.

import type { ReactNode } from "react";
import Link from "next/link";
import Icon from "./Icon";

export default function AuthKarte({
  titelId,
  children,
  fuss,
  zurueck,
}: {
  titelId: string;
  children: ReactNode;
  fuss?: ReactNode;
  zurueck?: { href: string; label: string };
}) {
  return (
    <div className="kt-auth">
      <div className="wrap">
        <section className="kt-auth-inner" aria-labelledby={titelId}>
          {zurueck && (
            <Link className="kt-back" href={zurueck.href}>
              <Icon name="arrow-l" />
              {zurueck.label}
            </Link>
          )}
          <div className="kt-card">{children}</div>
          {fuss && <p className="kt-auth-foot">{fuss}</p>}
        </section>
      </div>
    </div>
  );
}

export function KartenKopf({ titel, titelId, children }: { titel: string; titelId: string; children?: ReactNode }) {
  return (
    <div className="kt-card-head">
      <h1 id={titelId}>{titel}</h1>
      {children && <p>{children}</p>}
    </div>
  );
}
