# Projektstatus — Lernarena (ihk_app)

Aktualisiert: **2026-08-09**
Repo: **github.com/claudioNelson/IHK_App** · Branch **main**
Lokal: **C:\Users\cnm89\Desktop\Projekte\IHK\ihk_app**
App-Version im Store: **1.1.0+7** (Closed Track, approved, bei Testern) · lokal bereit: **v8-Stand** mit Flutter 3.44.8 + neuer Billing-Lib (NICHT hochladen bis nach dem Launch)

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
- **Flutter 3.44.8 / Dart 3.12.2** (Upgrade 01.08.2026; pubspec-SDK `^3.8.1`)
- State-Management: **provider**
- Backend & Auth: **Supabase** (`supabase_flutter`), inkl. Sign in with Apple (`sign_in_with_apple`), Deep Links (`app_links`)
- KI-Tutor „Ada": Supabase Edge Function `ai-tutor` → **Claude Haiku 4.5** (Failover Groq → Gemini). Aufruf aus `lib/services/gemini_service.dart` (Name historisch, Keys liegen nur serverseitig)
- Billing: `in_app_purchase ^3.3.0` + `in_app_purchase_android ^0.5.2` (**neue Play-Billing-Bibliothek, Google-Frist 31.08.2026 erfüllt**)
- UI/Extras: `google_fonts`, `confetti` (Badges), `audioplayers` (Sound), `flutter_highlight` (Code), `flutter_markdown_plus`, `image_picker`, `url_launcher`
- Config: `dotenv` (API-Keys aus `.env`), Icons via `flutter_launcher_icons`, Paketname via `change_app_package_name`

**Android / Release**
- `applicationId = app.lernarena`, `compileSdk = 36`, `targetSdk = 36` (Android 16, hart gesetzt), `minSdk = 23`
- AGP 8.9.1 / Gradle 8.12, NDK 27 · Flutter-Tool hat beim Upgrade `build.gradle.kts` + `gradle.properties` automatisch angepasst
- ⚠️ Nicht blockierende „will soon be dropped"-Warnungen: Gradle → ≥8.14, AGP → ≥8.11.1, Kotlin → ≥2.2.20 (später zusammen erledigen)
- Lokales SDK-Setup komplett: cmdline-tools + NDK installiert, alle Lizenzen akzeptiert (`flutter doctor`: No issues)
- Build: `flutter build appbundle --release` → `.aab`

**Web**
- **Next.js (App Router, TypeScript)**, Deployment **Vercel**
- Web-Prüfungstutor: API-Route `web/app/api/ki-korrektur/route.ts` → **Claude Haiku 4.5** (Fallback Groq `llama-3.3-70b-versatile`), strukturierte JSON-Korrektur
- SEO-Cluster (Details siehe Claude-Projekt-Doc `claude/seo-status-web.md`) · MailerLite wurde komplett entfernt
- `public/.well-known/assetlinks.json` live (Digital Asset Links für App-Deep-Links, SHA-256 aus Play App Signing)

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

**Neu (06.08.2026) — Anschlüsse-Quiz (erster SI-Baustein):** 16 selbst erstellte, lizenzfreie Anschluss-Illustrationen (`assets/anschluesse/`, je labeled + quiz-Variante; Quelle: SVG-Generator, reproduzierbar). Lern-Modus (Karten) + Quiz (Bild ohne Label, 4 Optionen, Feedback mit Erklärung) in `anschluesse_quiz_screen.dart`, Daten in `data/anschluesse_data.dart`, Einstieg im Learning Hub (Tag „SI", cyan). Läuft komplett offline, kein Supabase. Geplant: eigener AE/SI-Fachrichtungs-Bereich (AP1 gemeinsam, AP2 getrennt), Fachrichtungs-Wahl im Onboarding/Profil.

**Neu (06.08.2026) — Eigene lokale Sounds:** `assets/sounds/` (correct, wrong, victory, defeat, click, timeup) — selbst synthetisiert, lizenzfrei. SoundService von freesound-Streaming-URLs auf `AssetSource` umgestellt → offline-fähig, keine Latenz. Anschlüsse-Quiz spielt richtig/falsch + Victory ab ≥80 %.

---

## 4. Release-Status (Google Play)

- 🚀 **DIE APP IST LIVE IM PLAY STORE (seit 02.08.2026)!** Produktionszugriff genehmigt, Production-Release (v7, Länder DE/AT/CH) eingereicht und von Google freigegeben. Store-Link: https://play.google.com/store/apps/details?id=app.lernarena — Suche nach „Fachinformatiker" findet die App bereits.
- Launch-Entscheidung: **Option A** — mit v7 (clientseitige Freischaltung) launchen, serverseitige Belegprüfung sofort nachrüsten (in v8 fertig gebaut, siehe 4b).
- Wichtig fürs Bewertungs-Thema: **Eingetragene Closed-Tester können NICHT öffentlich bewerten** (sie sehen nur „privates Feedback an den Entwickler" + „interne Betaversion"-Label). Zum öffentlichen Bewerten müssen sie das Testprogramm verlassen: https://play.google.com/apps/testing/app.lernarena
- Historie: 14-Tage-Test abgeschlossen, Produktionszugriff-Fragebogen bestanden.
- Aktueller Track-Release: **versionCode 7 (1.1.0+7)** — approved & bei den Testern. Enthält das komplette Kauf-System (Kauf-Sheet, BillingService, In-App-Navigation statt Website-Links). Historie: v4/v5 Fehlversuche ohne Billing (hängender Gradle-Daemon), v6 = Billing-Lib ohne Kauf-UI.
- ⚠️ Gelernte Lektion: In der Play Console reicht **Save nicht** — ein Release braucht **Edit → Rollout → Publishing overview → Submit for review**, sonst bleibt es als Draft liegen.
- **v8 (1.1.1+8) am 07.08. in den Closed Track hochgeladen & submitted** — Inhalt: serverseitige Belegprüfung (end-to-end getestet), Anschlüsse-Quiz, lokale Sounds, neue Billing-Lib (Flutter 3.44.8). Nach Googles Freigabe: als Tester kurz aus dem Store prüfen → **„Promote release" → Production**.
- Play-Policy „target Android 16 (API 36)" ✅ · Edge-to-edge-Hinweise (Android 15) durch Flutter-Upgrade erledigt.
- Open Testing bewusst NICHT genutzt (erst nach Produktionszugriff möglich; offene Tester würden echt zahlen).

---

## 4b. Monetarisierung (Stand 31.07.2026 — FUNKTIONIERT end-to-end)

**Google Payments-Profil:** Unternehmensprofil (Einzelunternehmer/Kleingewerbe, rechtl. Name = eigener Name, Statement-Name LERNARENA), Bankkonto per Cent-Gutschrift verifiziert.

**Produkte (Play Console):** Abo `lernarena_premium` mit 3 aktiven Base Plans: `monthly` · `half-year` · `annual` (je Auto-renewing, Grace 7 Tage). ⚠️ Toter Base Plan `yearly` existiert deaktiviert (war versehentlich monatlich — Base Plans sind unveränderlich, ID verbrannt). KEIN Lifetime mehr.

**Preise (deutsche Endpreise inkl. 19 % MwSt.):** 11,99 €/M · 47,99 €/6M · 84,99 €/Jahr. (Ursprünglich 9,99/39,99/69,99 netto eingegeben; Google hat MwSt. aufgeschlagen — bewusst so belassen.) Alle Texte in App (Kauf-Sheet, PremiumLock, In-App-AGB) und Web (Startseite, /upgrade, AGB) auf die Endpreise aktualisiert; €/Monat-Anzeige im Kauf-Sheet rechnet dynamisch aus echten Google-Preisen.

**App-Integration:** `lib/services/billing_service.dart` (in_app_purchase ^3.3.0, Produkt-Mapping über basePlanId, Kauf, Restore, completePurchase) + `lib/widgets/premium_kauf_sheet.dart` (Bottom Sheet, 3 Pläne). Verdrahtet an: IHK-Prüfungs-Paywall, beide Zertifikat-Paywalls, KI-Tutor-Limit, Modul-Fragen-Limit (practice_limit_mixin). Init in main.dart + restorePurchases nach Login. Prüfungs-Karten in pruefen_screen navigieren jetzt **in-App** zur Detailseite (Website-Link entfernt — Play-Policy: keine externen Kaufwege; Website-Stripe bleibt separat geplant).

**Supabase:** Schutz-Trigger `trg_protect_premium` (blockt direkte Premium-Feld-Änderungen durch User) wurde erweitert um Sitzungs-Schalter `app.premium_grant`; neue RPC `activate_premium_purchase(p_tier, p_days)` (SECURITY DEFINER, validiert Tier/Laufzeit, verkürzt nie) ist der einzige Kauf-Schreibweg. App und Web lesen dasselbe `profiles.is_premium` → **einmal kaufen = überall Premium**.

**Getestet:** Lizenz-Tester eingerichtet (Testkarten sieht NUR, wer in Play Console → Einstellungen → License testing eingetragen ist — alle anderen zahlen echt); Testkauf mit Testkarte aus der Store-Version v7 auf echtem Gerät erfolgreich: purchased → RPC → `isPremium=true`. Free-Limits im Code verifiziert: 5 Modul-Fragen/Modul/Tag, 5 KI-Fragen, 5 Duelle; Karteikarten bewusst unbegrenzt (Konstante 30 existiert, wird nicht durchgesetzt).

**Gebühren:** ✅ 15-%-Service-Fee-Programm enrolled (31.07.).

**✅ Serverseitige Belegprüfung (07.08.2026, END-TO-END GETESTET):** Edge Function `verify-purchase` (holt Google-Token via Service-Account `lernarena-play-verify@gen-lang-client-0675834051`, prüft Abo bei Google, Base Plan → Tier, echtes Ablaufdatum) + DB-Funktion `grant_premium_from_server` (nur service_role). App (v8) schickt nur noch den purchaseToken; Restore läuft über denselben Weg (Auto-Restore beim App-Start). Getestet: Frischkauf + Restore, beides fehlerfrei. Gefundener & behobener Bug: Secret `GOOGLE_PLAY_SERVICE_ACCOUNT` war beim ersten Einfügen kein valides JSON (SyntaxError in den Function-Logs) → Secret neu eingefügt. Alte RPC `activate_premium_purchase` bleibt aktiv, bis v7-Nutzer auf v8 sind — DANN dichtmachen (revoke execute from authenticated).

---

## 4c. App Store Release (iOS) — in Vorbereitung

**Schritt 1 — Apple Developer Account:** bezahlt am 03.08.2026, wartet auf Apples Freischaltung (dauert meist 1–2 Tage, manchmal bis 48 h nach Zahlungseingang).

**Schritt 2 — Projekt-Check (03.08.2026):**
- `ios/`-Ordner existiert ✅ (inkl. Runner.xcodeproj, xcworkspace, RunnerTests)
- Bundle-ID: **`app.lernarena`** — identisch mit der Android applicationId ✅ (keine Änderung nötig; RunnerTests: app.lernarena.RunnerTests)
- App-Name (CFBundleDisplayName in Info.plist): war „Ihk App" → auf **„Lernarena"** korrigiert ✅
- App-Icons: waren noch **Flutter-Standard** ❌ → `flutter_launcher_icons` in pubspec auf `ios: true` + `remove_alpha_ios: true` umgestellt (App Store lehnt Alpha-Kanal ab). **TODO:** `dart run flutter_launcher_icons` ausführen, dann sind die iOS-Icons generiert.
- in_app_purchase: Plugin ist föderiert — iOS-Unterstützung (in_app_purchase_storekit) kommt automatisch mit `in_app_purchase ^3.3.0`. Kein Podfile vorhanden — normal, wird beim ersten iOS-Build erzeugt. Pods/CocoaPods lassen sich **nur auf einem Mac** prüfen.

**Schritt 3 — Codemagic eingerichtet (04.08.2026):** ✅ Account (GitHub-Login), Repo claudioNelson/IHK_App verbunden, Default Workflow auf iOS/macOS M2. **Erster unsignierter iOS-Build ERFOLGREICH** — das Projekt kompiliert für iOS (inkl. StoreKit/Billing-Pods). Free-Tier: 500 macOS-M2-Minuten/Monat.

**Offene Punkte / Realität-Check:**
- iOS-Builds laufen über **Codemagic** (Mac in der Cloud) — kein eigener Mac nötig. Testen ohne iPhone: Appetize.io (Simulator im Browser); für Kauf-Tests + TestFlight-Endtest einmal ein echtes iPhone leihen.
- App Store Connect: App anlegen, Abo-Produkte (monthly/half-year/annual) NEU anlegen — Apple hat eigenes Abo-System, Preise/Produkte aus der Play Console gelten dort nicht.
- Belegprüfung: `verify-purchase` prüft nur Google-Käufe. Für iOS braucht es einen zweiten Prüfweg (App Store Server API) — bauen, wenn iOS-Version konkret wird.
- Apple-Abos: Kommission ebenfalls 15 % (Small Business Program, muss nach Freischaltung beantragt werden).
- Sign in with Apple ist Pflicht, wenn Google-Login angeboten wird — `sign_in_with_apple` ist schon im Projekt ✅.

---

## 4d. Gast-Modus (Branch `feature/gast-modus`, Stand 08.08.2026) — wird **v9**

Anonymes Ausprobieren ohne Registrierung, damit Neugierige die App sofort testen können.

- **Supabase Anonymous Sign-ins aktiviert** (Dashboard: Authentication → Sign In/Up).
- **Trigger `handle_new_user` anonym-sicher gemacht:** Username-Fallback „Gast-XXXX", E-Mail-Fallback `<user-id>@gast.lernarena.app` (nötig, weil `profiles.email` NOT NULL ist).
- **Login-Screen:** Button „Ohne Account ausprobieren" → `signInAnonymously()` → NavRoot.
- **Paket-Migration mitgezogen:** `supabase_flutter` 1.10.3 → 2.17.1, `app_links` 3.5.1 → 7.x. Nötige Code-Fixes: `.in_` → `.inFilter` (6 Stellen), `getInitialAppLink` → `getInitialLink`, Future.wait-Typfix in `new_profile_page.dart`.
- **✅ Getestet (Windows-Desktop):** Gast-Login, Profil „Gast-1758", Ada, Logout → Login-Screen, normaler Login nach Migration — alles fehlerfrei.

**Android App Links eingerichtet (09.08.2026):** Damit die Auth-Mails (Bestätigung + Passwort-Reset) direkt in der App landen statt im Browser.
- `web/public/.well-known/assetlinks.json`: Package `app.lernarena`, **zwei** SHA-256-Fingerprints — `02:5F:…:00:35` (Play-App-Signing-Key, Store-Builds) **und** `B5:12:…:37:61` (lokaler Debug/Upload-Key, `flutter run`-Builds). Beide nötig, weil Debug-Installs mit dem lokalen Key signiert sind und die Verifizierung sonst mit Status `1024` (failed) scheitert.
- ⚠️ **Gefundener & behobener Bug:** `web/vercel.json` leitete `/.well-known/assetlinks.json` per Rewrite auf die API-Route `/api/assetlinks` um, die einen **veralteten Fingerprint** (`B5:12:…`) auslieferte → live wurde der falsche Wert serviert. Rewrite entfernt (statische Datei wird jetzt direkt ausgeliefert), API-Route-Fingerprint zur Sicherheit ebenfalls korrigiert, `.well-known/` aus dem `proxy.ts`-Matcher (Next-16-Middleware) ausgeschlossen.
- `AndroidManifest.xml`: HTTPS-Intent-Filter (`autoVerify="true"`) auf `android:pathPrefix="/auth/callback"` eingeschränkt — nur Auth-Callbacks öffnen die App, normale Website-/SEO-Links bleiben im Browser. Custom-Scheme `app.lernarena://` bleibt.
- `auth_service.dart` nutzte bereits `https://lernarena.app/auth/callback` (signUp + resetPassword) → konsistent, keine Änderung.
- **Deploy-Weg:** assetlinks-Fix (nur die 4 Web-Dateien) per Cherry-Pick auf `main` gebracht (Commit `2ce9c9e`, gepusht) — Produktion `lernarena.app` deployt von `main`, nicht vom Feature-Branch. Die Manifest-/AuthService-Änderungen bleiben auf `feature/gast-modus`.
- **✅ App Links live & verifiziert (09.08.2026):** Live-Datei liefert beide Fingerprints aus; `adb pm get-app-links app.lernarena` zeigt `lernarena.app: verified` (vorher `1024`). Debug-Build ist mit `B5:12:…` signiert, daher der zweite Fingerprint nötig.
- **✅ Mail-Flow end-to-end getestet (09.08.2026):** Registrierungs-Bestätigungsmail öffnet auf dem echten Android-Gerät direkt die App und loggt den User ein. Supabase Redirect URLs eingetragen (`https://lernarena.app/auth/callback` + `…/auth/callback**`). Passwort-Reset-Mail noch nicht separat gegengetestet, sollte über denselben Callback laufen.
- ⚠️ **Lesson learned (Git):** Beim Cherry-Pick auf `main` blockierte eine uncommittete `.claude/settings.local.json` den `checkout`; ein `git stash pop` popte danach versehentlich einen **alten, vergessenen Stash** (`WIP on main: 3fc4680`) und riss ~40 Dateien in Merge-Konflikte. Behoben via `git reset --hard HEAD` (HEAD war unberührt `4705095`, `.env` vorher aus dem Index genommen → blieb erhalten). Kein Datenverlust. Merke: alten Stash nicht blind poppen.

**Gast → Account-Umwandlung gebaut & ✅ getestet (09.08.2026):**
- `auth_service.dart`: neuer Getter `isGuest` (`currentUser.isAnonymous`) + `convertGuestToAccount()` — setzt E-Mail/Passwort/Username per `updateUser()` auf dem **anonymen** User (KEIN neuer Account, User-ID + Fortschritt bleiben), Redirect über `https://lernarena.app/auth/callback`; danach werden `profiles.username`/`email` vom Platzhalter auf die echten Werte geupdatet.
- `lib/screens/auth/upgrade_account_screen.dart` (NEU): Formular Username/E-Mail/Passwort/Bestätigen im register_screen-Stil, Fehlertext bei bereits vergebener E-Mail, Erfolgsansicht „Fast geschafft!" mit Bestätigungsmail-Hinweis, `pop(true)` zurück zum Profil.
- `new_profile_page.dart`: Für Gäste auffällige Karte „Account erstellen & Fortschritt sichern" (Accent-Gradient, Hinweis „Fortschritt geht bei Deinstallation verloren") oben im Profil; im ACCOUNT-Block ersetzt „Account erstellen" das „Passwort ändern"-Tile für Gäste; nach erfolgreicher Umwandlung wird der Profil-Cache verworfen und neu geladen.
- ✅ **Auf echtem Gerät getestet (09.08.2026):** Gast-Login → Karte → Formular → Bestätigungsmail → App Link → Account umgewandelt, Fortschritt erhalten, Profil zeigt echte Daten.

**Noch offen vor Release:**
1. **Deep Links auf echtem Gerät** — ✅ E-Mail-Bestätigung getestet, öffnet App + loggt ein (App Links `verified`). **✅ Passwort-Reset komplett gebaut & Ende-zu-Ende getestet (09.08.2026):** neuer `lib/screens/auth/reset_password_screen.dart` (Formular neues Passwort + Bestätigen, Stil wie change_password_screen, Erfolgsansicht „Passwort gesetzt."); `main.dart` bekam globalen `navigatorKey` + Behandlung von `AuthChangeEvent.passwordRecovery` (öffnet den Screen mit 800 ms Verzögerung, damit der Navigator nach Kaltstart bereit ist). Drei Stolpersteine, alle behoben: (a) Auth-Listener muss VOR `DeepLinkService().initialize()` registriert sein, sonst geht das Event beim Kaltstart über den Mail-Link verloren; (b) das Supabase-Mail-Template „Reset Password" zeigte auf `{{ .SiteURL }}/reset-confirm` — App Link greift aber nur auf `/auth/callback`, Template korrigiert auf `{{ .SiteURL }}/auth/callback?token_hash={{ .TokenHash }}&type=recovery`; (c) Bug in `deep_link_service.dart`: `verifyOTP(token: …)` statt `verifyOTP(tokenHash: …)` → Assertion „email or phone needs to be specified", gefixt. Getestet: Mail-Link öffnet App → Reset-Screen → neues Passwort gesetzt.
2. ~~Gast → Account-Umwandlung~~ — ✅ gebaut & Ende-zu-Ende getestet (siehe oben).
3. ~~Premium-Kauf für Gäste blockieren~~ — ✅ gebaut & getestet (09.08.2026): `premium_kauf_sheet.dart` zeigt Gästen statt der Pläne ein Gate „Sichere zuerst deinen Account." mit Button zur Account-Erstellung (UpgradeAccountScreen); zusätzlich Sicherheitsnetz in `billing_service.dart` `buy()` (anonymer User → Fehlermeldung statt Kaufdialog). Gate erscheint beim Gast auf dem Gerät ✅ (normaler Kauf-Flow wird vor v9 sowieso nochmal regressionsgetestet).
4. **„Profil bearbeiten" beim Gast prüfen.**
5. **Cleanup-Job für verwaiste Gast-Accounts** (>30 Tage inaktiv) + evtl. Captcha.
6. **BillingService: Platform-Check** (Fehler auf Windows ist nur kosmetisch).

---

## 5. Web / SEO (Kurzfassung)

Voller Stand in `claude/seo-status-web.md` (Claude-Projekt). Kurz: SEO-Landingpage-Cluster unter `/lernen/*` (10 Themen), Pillar-Seite `/fachinformatiker-pruefung`, Sitemap, strukturierte Daten, OG-Bild, 301-Redirect, Hell/Dunkel-Theme. **07/2026:** alle 10 Lernseiten inhaltlich vertieft (Alltags-Vergleiche, Prüfungstipp- & „Häufige Fehler"-Kästen, sichtbarer FAQ, je 5 Quizfragen; RAID auf themefähiges System umgebaut) — ✅ **live deployt und verifiziert**. MailerLite komplett entfernt. Neue strukturierte Prüfungs-Ergebnisseite (`ExamResult.tsx`) live.

---

## 6. Offene Punkte / Nächste Schritte

**App**
- ⏳ **v8-Review abwarten** (Closed Track, submitted 07.08.) → testen → Promote to Production.
- **Gast-Modus (feature/gast-modus) fertigstellen** → wird v9 (✅ Gast→Account-Umwandlung getestet, ✅ Premium-Kauf für Gäste blockiert & getestet, ✅ Passwort-Reset gebaut & getestet; offen laut 4d: „Profil bearbeiten" beim Gast prüfen, Cleanup-Job, BillingService-Platform-Check, Kauf-Flow-Regressionstest vor v9).
- Uncommittete Änderungen committen/pushen: `pubspec.yaml`/`pubspec.lock` (neue Billing-Lib), `android/app/build.gradle.kts` + `android/gradle.properties` (Auto-Anpassung durchs Flutter-Upgrade), PROJECT_STATE.md.
- **Nach dem Launch:** v8 hochladen (Version auf 1.1.1+8 bumpen) — idealerweise zusammen mit der serverseitigen Belegprüfung (Pflicht vor Public Launch des Kaufsystems, siehe 4b).
- Tester bitten, den Kauf-Flow in v7 zu testen (dafür ihre Gmail-Adressen als Lizenztester eintragen, sonst zahlen sie echt!).
- Später: Gradle ≥8.14, AGP ≥8.11.1, Kotlin ≥2.2.20 (nicht blockierende Flutter-Warnungen) + `withOpacity`→`withValues`-Aufräum-Session (384 Analyzer-Infos).
- KI-Kosten im Blick behalten (Ada läuft über Claude Haiku; Nutzungslimits über `usage_tracker`).

**Web**
- ✅ Play-Store-Badge live auf der Startseite (Hero, Schluss-CTA, Footer).
- **Python-Kurs ausbauen:** `/python-kurs` mit Browser-Editor (Pyodide, Code läuft clientseitig) und Lektion 1–2 ist gebaut; Lektion 3–12 folgen (Kursplan steht, inkl. 2 Spiele-Projekte). Deploy-Status prüfen (committen/pushen falls noch offen).
- **KI-Korrektur verbessert (07.08.):** Gesamtergebnis wird jetzt clientseitig aus den Einzelbewertungen summiert (Fix für „0/100 trotz Punkten"-Widerspruch), Konsistenz-Regeln im Prompt, große farbige Noten-Karte in `ExamResult.tsx`.
- `/upgrade` (Web-Stripe-Checkout) fertig bauen; Play-Premium-Nutzern dort keinen Doppelkauf anbieten.
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
