// Rahmen fuer die Auth-Seiten: gemeinsamer Header und Footer ohne
// "App laden" im Header, dazu die Konto-Styles (Praefix kt-).
import type { ReactNode } from "react";
import PageShell from "@/app/components/shell/PageShell";
import "@/app/components/konto/konto.css";

export default function KontoAuthLayout({ children }: { children: ReactNode }) {
  return (
    <PageShell className="kt" cta={null}>
      {children}
    </PageShell>
  );
}
