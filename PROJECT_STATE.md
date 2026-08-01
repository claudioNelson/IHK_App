# Projektstatus — Lernarena (ihk_app)

Aktualisiert: **2026-07-27**
Repo: **github.com/claudioNelson/IHK_App** · Branch **main**
Lokal: **C:\Users\cnm89\Desktop\Projekte\IHK\ihk_app**
App-Version: **1.0.1+3** (versionName 1.0.1, versionCode 3)

> Hinweis: Diese Datei wurde bis 09/2025 automatisch von `Update-ProjectState.ps1` erzeugt (nur Git-/Datei-Metadaten). Seit 07/2026 wird sie manuell als echte Projekt-Übersicht gepflegt. Das alte Skript spiegelt den Stand nicht mehr wider.

---

## 1. Was ist Lernarena?

Eine **Lern- und Prüfungsvorbereitungs-App für angehende Fachinformatiker** (Ausbildung & Umschulung), Fachrichtungen **Anwendungsentwicklung (AE)** und **Systemintegration (SI)**. Ziel: gezielte Vorbereitung auf **AP1** und **AP2** (gestreckte Abschlussprüfung, Gewichtung 20 % / 80 %).

Zwei Produkte, ein Projekt:
- **Mobile App** (Flutter, Android) — das eigentliche Lernprodukt: Kernthemen, Karteikarten, Level-Modus, echte IHK-Prüfungssimulation, KI-Tutor „Ada", Zertifikate, Statistiken.
- **Web** (`lernarena.app`, Next.js auf Vercel) — Marketing- + SEO-Seite mit eigenen Lernseiten, Prüfungs-Guide und einem Web-Prüfungstutor.

---

## 2. Tech-Stack

**Mobile App**
- **Flutter / Dart** (SDK `^3.8.1`)
- State-Management: **provider**
- Backend & Auth: **Supabase** (`supabase_flutter`), inkl. Sign in with Apple (`sign_in_with_apple`), Deep Links (`app_links`)
- KI-Tutor „Ada": **Google Gemini** (`google_generative_ai`, `lib/services/gemini_service.dart`)
- UI/Extras: `google_fonts`, `confetti` (Badges), `audioplayers` (Sound), `flutter_highlight` (Code), `flutter_markdown_plus`, `image_picker`, `url_launcher`
- Config: `dotenv` (API-Keys aus `.env`), Icons via `flutter_launcher_icons`, Paketname via `change_app_package_name`

**Android / Release**
- `applicationId = app.lernarena`, `compileSdk = 36`, `targetSdk = 36` (Android 16, hart gesetzt), `minSdk = 23`
- AGP 8.9.1 / Gradle 8.12, NDK 27
- Build: `flutter build appbundle --release` → `.aab`

**Web**
- **Next.js (App Router, TypeScript)**, Deployment **Vercel**
- Web-Prüfungstutor: API-Route `web/app/api/ki-korrektur/route.ts` → **Groq** (`llama-3.3-70b-versatile`)
- MailerLite (Warteliste-Popup), SEO-Cluster (Details siehe Claude-Projekt-Doc `claude/seo-status-web.md`)

**Infrastruktur / Konten**
- E-Mail: `admin@lernarena.app` + `info@lernarena.app` (Zoho)
- Domain: lernarena.app
- KI-Anbieter: **Claude Haiku 4.5 (primär, App + Web)** mit Failover: Web-Tutor Claude→Groq; Ada (Edge Function ai-tutor) Claude→Groq→Gemini.

---

## 3. App-Aufbau (`lib/`)

`main.dart` wurde von einem 184-KB-Monolithen (jetzt nur noch als `main.dart.BACKUP*` vorhanden) auf **~4,6 KB** refaktoriert; die Logik liegt in strukturierten Ordnern:

- **`services/`** — Auth, App-Cache, Progress, Level, Streak, Daily-Goal, Spaced-Repetition, Flashcards, Badges, Subscription, Usage-Tracker (Limits Free/Premium), Sound, Report, Deep-Link, Gemini (KI), Telegram, Async-Duel, Exam, Question-Validator
- **`screens/`** — auth, onboarding, splash, learning (Hub, Flashcards, Review, Core-Topics, KI-Tutor-Chat), levels (Level-Play, Pfad, Ada-Sheet, Result), module (Modul-/Themen-/Testfragen), pruefen, simulation (Async-Match/Duell, Leaderboard), zertifikate, profile, legal
- **`pages/pruefung/`** — IHK-Prüfung: Liste, Detail, Exam-Screen
- **`widgets/`** — Fragen-Router + viele Fragetypen: Multiple-Choice, Freitext, Code/Code-Editor, Tabellen-Vervollständigung, Diagramm, **Binär-**, **Netzwerk-/Subnetting-**, **RAID-Rechner**, **DNS-/Port-Zuordnung**, **ER→Tabellen**, Lückentext, Sequenz, Rechenaufgaben, Foto-Upload; dazu Premium-Lock, Limit-Dialoge/-Pille, Streak-Kalender, Badge-Dialog, Navigation
- **`data/`** — `exam_data.dart`, `themen_summaries.dart` (~108 KB Lerninhalte) und Prüfungssätze `exams/` (**ae-1/2/3**, **si-1/2**)
- **`models/`**, **`theme/`** (app_colors/text_styles/theme/provider), **`mixins/`**

**Kern-Features:** Modul-/Themen-Lernpfade, Karteikarten mit Spaced Repetition, gamifizierter Level-Modus, echte IHK-Prüfungssimulation mit KI-Korrektur, Async-Duell + Leaderboard, Zertifikate, Streaks/Tagesziele, Badges, Premium-Abo mit Nutzungslimits, Report-Funktion.

---

## 4. Release-Status (Google Play)

- App ist in der **geschlossenen Testphase** (Closed Testing, Alpha-Track) im Google Play Store.
- 14-Tage-Test **abgeschlossen**; Fragebogen „Apply for production access" wurde ausgefüllt und eingereicht → wartet auf Googles Prüfung.
- Play-Policy „App must target Android 16 (API 36)" ist **erledigt** (target/compileSdk 36). Aktueller Track-Release: **versionCode 6 (1.0.2+6)** — enthält die Google-Play-Billing-Bibliothek (versionCode 4/5 waren Fehlversuche ohne Billing; Ursache: hängender Gradle-Daemon, gelöst per Java-Prozess-Kill + Cache-Löschung).

---

## 4b. Monetarisierung (Stand 31.07.2026 — FUNKTIONIERT end-to-end)

**Google Payments-Profil:** Unternehmensprofil (Einzelunternehmer/Kleingewerbe, rechtl. Name = eigener Name, Statement-Name LERNARENA), Bankkonto per Cent-Gutschrift verifiziert.

**Produkte (Play Console):** Abo `lernarena_premium` mit 3 aktiven Base Plans: `monthly` · `half-year` · `annual` (je Auto-renewing, Grace 7 Tage). ⚠️ Toter Base Plan `yearly` existiert deaktiviert (war versehentlich monatlich — Base Plans sind unveränderlich, ID verbrannt). KEIN Lifetime mehr.

**Preise (deutsche Endpreise inkl. 19 % MwSt.):** 11,99 €/M · 47,99 €/6M · 84,99 €/Jahr. (Ursprünglich 9,99/39,99/69,99 netto eingegeben; Google hat MwSt. aufgeschlagen — bewusst so belassen.) Alle Texte in App (Kauf-Sheet, PremiumLock, In-App-AGB) und Web (Startseite, /upgrade, AGB) auf die Endpreise aktualisiert; €/Monat-Anzeige im Kauf-Sheet rechnet dynamisch aus echten Google-Preisen.

**App-Integration:** `lib/services/billing_service.dart` (in_app_purchase ^3.2.0, Produkt-Mapping über basePlanId, Kauf, Restore, completePurchase) + `lib/widgets/premium_kauf_sheet.dart` (Bottom Sheet, 3 Pläne). Verdrahtet an: IHK-Prüfungs-Paywall, beide Zertifikat-Paywalls, KI-Tutor-Limit, Modul-Fragen-Limit (practice_limit_mixin). Init in main.dart + restorePurchases nach Login. Prüfungs-Karten in pruefen_screen navigieren jetzt **in-App** zur Detailseite (Website-Link entfernt — Play-Policy: keine externen Kaufwege; Website-Stripe bleibt separat geplant).

**Supabase:** Schutz-Trigger `trg_protect_premium` (blockt direkte Premium-Feld-Änderungen durch User) wurde erweitert um Sitzungs-Schalter `app.premium_grant`; neue RPC `activate_premium_purchase(p_tier, p_days)` (SECURITY DEFINER, validiert Tier/Laufzeit, verkürzt nie) ist der einzige Kauf-Schreibweg. App und Web lesen dasselbe `profiles.is_premium` → **einmal kaufen = überall Premium**.

**Getestet:** Lizenz-Tester eingerichtet; Testkauf auf echtem Gerät (24090RA29G) erfolgreich: purchased → RPC → `isPremium=true, tier=yearly`. Free-Limits im Code verifiziert: 5 Modul-Fragen/Modul/Tag, 5 KI-Fragen, 5 Duelle; Karteikarten bewusst unbegrenzt (Konstante 30 existiert, wird nicht durchgesetzt).

**VOR PUBLIC LAUNCH ZWINGEND:** Serverseitige Belegprüfung (Supabase Edge Function + Google Play Developer API), da Freischaltung aktuell clientseitig angestoßen wird. Außerdem: 15-%-Service-Fee-Programm in Play Console aktivieren (sonst 30 % Gebühr!).

---

## 5. Web / SEO (Kurzfassung)

Voller Stand in `claude/seo-status-web.md` (Claude-Projekt). Kurz: SEO-Landingpage-Cluster unter `/lernen/*` (10 Themen), Pillar-Seite `/fachinformatiker-pruefung`, Sitemap, strukturierte Daten, OG-Bild, 301-Redirect, Hell/Dunkel-Theme. **07/2026:** alle 10 Lernseiten inhaltlich vertieft (Alltags-Vergleiche, Prüfungstipp- & „Häufige Fehler"-Kästen, sichtbarer FAQ, je 5 Quizfragen; RAID auf themefähiges System umgebaut). **Noch nicht deployt — `git commit` + `push` steht aus.**

---

## 6. Offene Punkte / Nächste Schritte

**App**
- Auf Googles Antwort zum Produktionszugriff warten.
- **Neuen Build (versionCode 7) mit komplettem Kauf-Code** bauen + in den Track hochladen (v6 im Store hat nur die Billing-Bibliothek, noch nicht das Kauf-Sheet).
- Vor Public Launch: serverseitige Belegprüfung + 15-%-Fee-Programm (siehe 4b).
- App-Änderungen committen/pushen (billing_service, premium_kauf_sheet, verdrahtete Screens, pubspec, Manifest, legal_texts).
- KI-Kosten im Blick behalten (Ada-Tutor läuft über Gemini; Nutzungslimits über `usage_tracker`).

**Web**
- Vertiefte Lernseiten committen + pushen (Vercel-Deploy).
- MailerLite: Domain verifizieren (SPF/DKIM), Absender auf `@lernarena.app` setzen, bevor die erste Broadcast-Mail rausgeht.
- Zum Launch: „Bald verfügbar"-Popup gegen echten Play-Store-Button tauschen.
- Nach 2–3 Wochen Search-Console-Daten prüfen → Seiten mit Impressionen weiter ausbauen; ggf. neue Themenseiten (VLAN, DHCP/DNS, USV, Scrum, …).

**KI / Kosten**
- ✅ ERLEDIGT (31.07.): Anthropic-Zahlung erfolgreich (Blocker war der VPN). Beide KI-Anbindungen auf **Claude Haiku 4.5** umgestellt:
  - Web-Tutor (`web/app/api/ki-korrektur/route.ts`): Claude primär → Groq-Fallback. Liefert jetzt **strukturiertes JSON**; neue Ergebnis-Ansicht in `ExamResult.tsx` (Punkte-Header, Note/Bestanden-Badges, Aufgaben-Karten mit Farbpunkten, Stärken/Verbesserungen/Lernempfehlungen). Fallback auf Rohtext, falls JSON-Parse scheitert.
  - Ada in der App (`supabase/functions/ai-tutor/index.ts`): Claude → Groq → Gemini. Edge Function deployed.
  - Keys: ANTHROPIC_API_KEY in Vercel-Env + Supabase-Secrets (nie im Code/Repo).
- Anthropic-Guthaben im Blick behalten (Start: 20 $; Haiku ≈ 1–2 Cent pro Prüfungskorrektur).

**Social / Marketing**
- Fertiges Subnetting-Video auf TikTok + Instagram Reels posten.
- Social-Accounts nach Account-Checkliste vervollständigen (siehe `claude/account-checkliste.md`).

---

## 7. Arbeitsweise / Konventionen

- Ordner-Freigabe via Device-Bridge (pro Sitzung neu erteilen) — Claude liest/schreibt direkt in `web/` bzw. `ihk_app/`.
- `git commit` / `push` führt der User selbst aus.
- **Secrets** (API-Keys) kommen in `.env` / Vercel-Env, **nie** in den Chat oder ins Repo. `.env.old` bleibt in `.gitignore`.
- Projekt-Regel: **Schritt für Schritt arbeiten, Chat nicht überfüllen. Antworten auf Deutsch.**
