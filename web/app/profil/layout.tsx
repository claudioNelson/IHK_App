// Rahmen fuer die Konto-Seiten: gemeinsamer Header und Footer plus die
// Konto-Styles (Praefix kt-).
import type { ReactNode } from "react";
import PageShell from "@/app/components/shell/PageShell";
import "@/app/components/konto/konto.css";

export default function KontoLayout({ children }: { children: ReactNode }) {
  return <PageShell className="kt">{children}</PageShell>;
}
