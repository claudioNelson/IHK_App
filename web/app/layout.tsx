import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL("https://lernarena.app"),
  title: {
    default: "Lernarena — IHK-Prüfungsvorbereitung für Fachinformatiker",
    template: "%s · Lernarena",
  },
  description:
    "Strukturierte Lernpfade, echte IHK-Simulation und ein KI-Tutor: Bereite dich gezielt auf AP1 und AP2 als Fachinformatiker Anwendungsentwicklung oder Systemintegration vor. 937 Prüfungsfragen, 3 Lernpfade.",
  keywords: [
    "IHK Prüfung",
    "Fachinformatiker",
    "Anwendungsentwicklung",
    "Systemintegration",
    "AP1",
    "AP2",
    "IHK Vorbereitung",
    "Prüfungsfragen",
    "Lernarena",
    "IT-Ausbildung",
    "Subnetting üben",
    "SQL lernen",
    "IT-Sicherheit",
  ],
  authors: [{ name: "Lernarena" }],
  creator: "Lernarena",
  publisher: "Lernarena",
  alternates: {
    canonical: "https://lernarena.app",
  },
  openGraph: {
    type: "website",
    locale: "de_DE",
    url: "https://lernarena.app",
    siteName: "Lernarena",
    title: "Lernarena — IHK-Prüfungsvorbereitung für Fachinformatiker",
    description:
      "Strukturierte Lernpfade, echte IHK-Simulation und ein KI-Tutor. Bereite dich gezielt auf AP1 und AP2 vor — 937 Fragen, 3 Lernpfade.",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "Lernarena — IHK-Prüfungsvorbereitung",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Lernarena — IHK-Prüfungsvorbereitung für Fachinformatiker",
    description:
      "Strukturierte Lernpfade, echte IHK-Simulation, KI-Tutor. 937 Fragen, 3 Lernpfade.",
    images: ["/og-image.png"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  icons: {
    icon: "/favicon.ico",
    apple: "/apple-touch-icon.png",
  },
  verification: {
    google: "YtbgtecX7ABUi1r3ATEvY9VMuyIWZYvhdaJokguq3eQ",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="de">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}