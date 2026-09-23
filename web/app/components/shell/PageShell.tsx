// Seitenrahmen: Kopf, Inhalt, Fuss. Fuer alle Seiten ausser der Startseite
// (die baut ihren Rahmen selbst mit eigenen Anker-Links).
//
//   <PageShell>
//     <section className="wrap">...</section>
//   </PageShell>

import type { ReactNode } from "react";
import SiteHeader, { type NavLink } from "./SiteHeader";
import SiteFooter from "./SiteFooter";

export default function PageShell({
  children,
  links,
  cta,
  className,
}: {
  children: ReactNode;
  links?: NavLink[];
  cta?: NavLink | null;
  className?: string;
}) {
  return (
    <div className={className ? `site ${className}` : "site"}>
      <SiteHeader links={links} cta={cta} />
      <main>{children}</main>
      <SiteFooter />
    </div>
  );
}
