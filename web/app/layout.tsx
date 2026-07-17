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
    "Strukturierte Lernpfade, echte IHK-Simulation und ein KI-Tutor: Bereite dich gezielt auf AP1 und AP2 als Fachinformatiker Anwendungsentwicklung oder Systemintegration vor. Hunderte Prüfungsfragen, mehrere Lernpfade.",
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
      "Strukturierte Lernpfade, echte IHK-Simulation und ein KI-Tutor. Bereite dich gezielt auf AP1 und AP2 vor.",
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
      "Strukturierte Lernpfade, echte IHK-Simulation, KI-Tutor. Mehrere Prüfungspfade.",
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
    icon: [
      { url: "/favicon.ico" },
      { url: "/favicon-16x16.png", sizes: "16x16", type: "image/png" },
      { url: "/favicon-32x32.png", sizes: "32x32", type: "image/png" },
    ],
    apple: [
      { url: "/apple-touch-icon.png", sizes: "180x180", type: "image/png" },
    ],
    other: [
      {
        rel: "icon",
        url: "/android-chrome-192x192.png",
        sizes: "192x192",
        type: "image/png",
      },
      {
        rel: "icon",
        url: "/android-chrome-512x512.png",
        sizes: "512x512",
        type: "image/png",
      },
    ],
  },
  manifest: "/site.webmanifest",
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