import type { Metadata } from "next";
import VergessenFormular from "./VergessenFormular";

export const metadata: Metadata = {
  title: "Passwort vergessen",
  robots: { index: false, follow: true },
};

export default function PasswortVergessenPage() {
  return <VergessenFormular />;
}
