# Projektstatus — Lernarena (ihk_app)

Aktualisiert: **2026-08-26**
Repo: **github.com/claudioNelson/IHK_App** · Branch **main**
Lokal: **C:\Users\cnm89\Desktop\Projekte\IHK\ihk_app**
App-Version im Store: **1.4.1+12** (Production, eingereicht 22.08.2026) · lokal bereits weiter: Lernmodule-Design, Arena-Fixes, Ada-Pill-Button (kommen mit v13)

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

## 4c. App Store Release (iOS) — TestFlight-Builds LAUFEN (Stand 19.08.2026)

**Update 16.–19.08. (aus den Merge-Commits der Lernarena-Kopie, jetzt in main):**
- Apple Developer Account AKTIV (seit 16.08.). App-ID `app.lernarena` registriert, App in App Store Connect angelegt.
- **Korrekte numerische Apple-ID: `6802045311`** (in codemagic.yaml; ein früherer Wert war falsch).
- **Signierte iOS-Builds laufen über Codemagic**: Tags `ios-v1.2.1` bis `ios-v1.2.4`. Signing über `fetch-signing-files` (App Store Connect Integration), Build-Nummer kollisionssicher (PROJECT_BUILD_NUMBER + TestFlight-Maximum), `beta_groups` entfernt.
- **Beta-Review/TestFlight-Submission DEAKTIVIERT, bis das iOS-IAP steht** (Apple-Regel 3.1.1: Paywall in der App braucht StoreKit).
- Info.plist komplett (Display-Name, Kamera/Foto-Texte, Deep-Link-Scheme, ITSAppUsesNonExemptEncryption=false), iOS-Icons generiert.
- **Repo-Zusammenführung 19.08.:** iOS-Arbeit (aus Desktop\Lernarena\ihk_app gepusht) und Kurs-/Bot-Arbeit (Desktop\Projekte\IHK\ihk_app) per Merge vereint, Konflikt nur in PROJECT_STATE.md (ours). Ab jetzt gilt: NUR NOCH in `Desktop\Projekte\IHK\ihk_app` arbeiten, die Lernarena-Kopie ist Alt-Stand.

*Historie (03.–04.08., Vorbereitung):*

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
4. ~~„Profil bearbeiten" beim Gast prüfen~~ — ✅ getestet (09.08.2026): Benutzername ändern funktioniert auch als Gast.
5. ~~Cleanup-Job für verwaiste Gast-Accounts~~ — ✅ eingerichtet (09.08.2026): SQL-Funktion `public.cleanup_guest_accounts()` (security definer, löscht `auth.users` mit `is_anonymous = true` und >30 Tage inaktiv, pro User mit Exception-Handling, execute für anon/authenticated revoked) + pg_cron-Job `cleanup-guest-accounts` täglich 03:00 UTC (`cron.job` zeigt active=true; Testlauf lief fehlerfrei, 0 Löschungen wie erwartet). Captcha bleibt optional für später.
6. ~~BillingService: Platform-Check~~ — ✅ gefixt & getestet (09.08.2026): `_iap` ist jetzt `late final` mit Initializer (wird erst beim ersten Zugriff erzeugt) + neuer Getter `platformSupported` (Android/iOS/macOS); `init()` überspringt Billing auf Windows/Linux/Web sauber mit Log statt LateInitializationError („Plattform nicht unterstützt — übersprungen" auf Windows verifiziert). Alle übrigen Methoden sind über `_available == false` automatisch abgesichert.
7. ~~Kauf-Flow-Regressionstest~~ — ✅ bestanden (09.08.2026): Mit echtem Account zeigt das Kauf-Sheet die drei Pläne mit echten Google-Preisen; Neukauf (monthly, Lizenztester) lief komplett durch inkl. serverseitiger Belegprüfung → Premium aktiviert. Anmerkung: Das alte Test-Abo war zuvor abgelaufen (Lizenztester-Abos laufen stark verkürzt), daher fand „Käufe wiederherstellen" korrekt nichts — Restore hat aktuell kein UI-Feedback (kosmetisch, evtl. später Snackbar).

**➡️ Damit ist die v9-Feature-Liste KOMPLETT — der Branch ist inhaltlich releasefertig.** Vor dem v9-Release noch: Version in `pubspec.yaml` auf 1.2.0+9 bumpen, `flutter build appbundle`, in Play Console Closed Track hochladen.

---

## 4e. Telegram-Bot (Stand 17.08.2026 — LÄUFT)

Bot **@lernarena_admin_bot** meldet Registrierungen und liefert Kennzahlen auf Abruf. Baut auf den vorhandenen Secrets `TELEGRAM_BOT_TOKEN` / `TELEGRAM_ADMIN_CHAT_ID` auf (wie `report-bug`).

**Automatische Meldung bei Registrierung** (inkl. Gäste, als solche markiert):
- Trigger `on_auth_user_created_notify` auf `auth.users` → pg_net → Edge Function `notify-signup` (Deploy mit `--no-verify-jwt`; Schutz über Header `x-signup-secret`).
- Secret liegt doppelt: Supabase Vault (`notify_signup_secret`, für den Trigger) + Function-Secret `NOTIFY_SIGNUP_SECRET`. Trigger ist fehlertolerant (EXCEPTION-Block): eine kaputte Meldung kann NIE eine Registrierung verhindern.
- Migrationen: `20260816170000_notify_new_signup.sql`, `20260816180000_admin_user_stats.sql`, `20260817090000_stats_exclusions.sql` (alle im SQL Editor eingespielt; `db push` wegen unsynchronem migrations-Ordner bewusst vermieden).

**Befehle** (Edge Function `telegram-bot`, Webhook mit `secret_token`, antwortet NUR im Admin-Chat; dauerhafte Button-Tastatur „📊 Nutzer" / „▶️ Play Store"):
- `/stats`: DB-Kennzahlen aus `public.admin_user_stats()` (nur service_role). Zählt „echte Nutzer" = nicht anonym + E-Mail bestätigt + kein Muster in `public.stats_exclusions` (ILIKE-Tabelle; aktuell %@bot.internal, %@test.com, %@example.com). Zeigt zusätzlich Roh-/Gefiltert-Zahl. Stand 17.08.: 31 echte von 50 roh, 2 Premium.
- `/play`: Play-Store-Installationszahlen aus dem GCS-Bucket `pubsite_prod_9123174190363235283` (`stats/installs/*_country.csv`, UTF-16). Nutzt das vorhandene Dienstkonto (`GOOGLE_PLAY_SERVICE_ACCOUNT`) mit Scope `devstorage.read_only`; Secret `PLAY_REPORT_BUCKET`. Nimmt die neuesten Dateien im Bucket (nicht nach Kalender geraten).
- `/play debug` (Dateiliste im Bucket) und `/play raw` (Rohinhalt der neuesten CSV) zur Diagnose.
- ⚠️ OFFEN: Bucket-Reports hingen zuletzt auf Stand 03.08. (Datei zuletzt 09.08. geschrieben, nur ~300 B). `/play raw` klärt, ob Google die Monatsdatei wirklich so selten füllt — Play Developer Reporting API ist KEIN Ersatz (kann nur Vitals, keine Installs).
- Hilfsskripte: `tools/test-notify-signup.ps1` (Function-Test ohne echten User, Testfall 3 = 403-Check), `tools/set-telegram-webhook.ps1` (setWebhook + Gegenprobe).

## 4f. SQL-Kurs in der App (FEATURE-KOMPLETT 19.08.2026, 14 Lektionen / 81 Aufgaben)

**Zusatz-Features (19.08., abends):**
- **Freispiel-Logik AKTIV**: Lektion N öffnet erst, wenn alle Aufgaben von Lektion N-1 gelöst sind. Verriegelte Kacheln abgedunkelt mit grauem Schloss; Tipp darauf → Snackbar „Löse erst Lektion X, es fehlen noch Y Aufgaben". Schalter `kursReihenfolgeAktiv` in `kurs_config.dart` (zum Testen auf false).
- **Premium-Gate GEBAUT, ABER AUS** (Entscheidung: Kurs startet komplett kostenlos als Wachstums-Zugpferd): Schalter `kursPremiumAktiv` in `kurs_config.dart`. Bei true: Lektion 8–14 (premium: true) zeigen violettes Schloss → `showPremiumKaufSheet`; Check über SubscriptionService. Umschalten = eine Konstante + Release. Merkhilfe: graues Schloss = freispielen, violettes = kaufen; Freispiel-Check kommt zuerst.
- **Kurs-Badges** (in badges-Tabelle EINGETRAGEN, inkl. category='kurs', requirement_type/value): `kurs_sql_start` 🌱 (1 Lektion) · `kurs_sql_haelfte` ⚡ (7) · `kurs_sql_meister` 🏆 (14). Vergabe nach jeder Lektion über `BadgeService.checkKursBadges`, Feier über BadgeCelebrationDialog.
- **BadgeService generalüberholt** (API unverändert): 8x kopierte Vergabe-Logik → einmal `_pruefeUndVergebe()`; upsert mit ignoreDuplicates (earned_at wird nicht mehr überschrieben); debugPrint statt print; `oderId`→`userId`; neu `getBadgeDetails()`. BadgeCelebrationDialog ist jetzt theme-fähig (vorher grell weiß im Dark Mode).

**Python-Kurs (gestartet 21.08.2026, gleiche Engine):** `lib/data/kurse/python_kurs.dart`, **ALLE 14 Lektionen geschrieben, 95 Aufgaben** (print · Variablen · Rechnen/Text · input/f-Strings · if/elif/else · Listen · for · while · Funktionen 1+2 · Dictionaries · Strings/split/Slicing · Fehlermeldungen+try/except · Finale mit Trockenlauf, Pseudocode-Uebersetzung und Nachbestell-Programm; ab Lektion 8 premium: true wie bei SQL). Kein Live-Python in der App: Aufgabentypen sind Luecke/Reihenfolge/Fehler/Auswahl, Ausgabe-Vorhersage ersetzt das Ausfuehren. Roter Faden wieder Nordwind GmbH. Kachel im Lern-Hub (Tag PY, gelb). `Kurs.lektionenGeplant = 14`: Badges (kurs_python_start 🐍 / haelfte 🔥 / meister 👑, in DB) rechnen gegen die geplanten 14, nicht die vorhandenen Lektionen. Engine-Fixes dabei: alleinstehende Ueberschrift landet auf der Aufgabenseite (statt leerer Seite), Seiten vertikal zentriert + Akzentbalken + Icon auf Textseiten, ListTile-Warnung (Tipp-ExpansionTile in Material gewrappt). OFFEN: kompletter Durchspiel-Test, dann Release v11. ACHTUNG: `kursReihenfolgeAktiv` steht lokal zum Testen auf false, vor dem naechsten Release auf true zuruecksetzen (nicht committen!). Untertitel der Hub-Kachel von "im Aufbau" auf etwas Finales aendern, wenn der Test durch ist.

**Update 20.08.2026 (Durchspiel-Test Lektion 1 + Badge-Debugging):**
- **Durchspiel-Test bestanden**: Lektion 1 gelöst, Freischaltung, Sounds, Fortschritts-Sync und 🌱-Badge mit Konfetti funktionieren. Zwei Bugs gefunden und behoben:
  1. `kurs_fortschritt`-Sync scheiterte mit 42501 → Tabellen-GRANTs fehlten (Policies allein reichen nicht): `grant select, insert, delete ... to authenticated` eingespielt, Sync läuft (verifiziert).
  2. Kurs-Badges scheiterten mit FK-Fehler 23503 → das Badge-Insert war (wie zuvor die Migration) im FALSCHEN Supabase-Projekt gelandet. Im richtigen Projekt (ybvwjmaicoffitngtmzl) eingetragen; badges-Tabelle hat Pflichtspalten category/requirement_type/requirement_value (Migrationsdatei entsprechend korrigiert). **Merke: SQL immer im Projekt ybvwjmaicoffitngtmzl ausführen, Projektname im Dashboard prüfen!**
- **Profil-Cache-Bug behoben**: `new_profile_page` zeigte nur die beim App-Start gecachten Badges (AppCacheService) — neu verdiente Badges erschienen erst nach App-Neustart. Jetzt: Cache für Sofort-Anzeige, dann Hintergrund-Refresh + Cache-Update.
- **Sieges-Sound** spielt jetzt im BadgeCelebrationDialog selbst (gilt für alle Vergabestellen). Debug-Snackbar in der Kursübersicht wieder aus (`_badgeDebug = false`, Schalter bleibt drin).
- **Badge-Inventur** (alle 22 IDs in DB verifiziert, Abgleich-SQL lief): Vergabe an 4 Stellen — Kurs, Module (test_fragen_screen), Zertifikate, Duelle. **Lücke:** `checkExamBadges` (exam_first/perfect/all) hat KEINEN Aufrufer — Prüfungssimulationen vergeben nie Badges. TODO: in ihk_pruefung_exam_screen verdrahten.
- **NEU: Anschluss-Badges** 🔌 `anschluss_kenner` (Quiz ≥80 %) · 🎯 `anschluss_profi` (100 %), Vergabe auf der Quiz-Ergebnisseite (`checkAnschlussBadges`), Migration `20260820100000_anschluss_badges.sql` (in DB eingetragen).
- **NEU: Store-Bewertungsabfrage** (`in_app_review` ^2.0.9, `lib/services/rating_service.dart`): offizielles Play/App-Store-5-Sterne-Fenster (KEIN eigener Vorfilter-Dialog — verstößt gegen Store-Richtlinien). Regeln: ab dem 5. App-Start, nur eingeloggte Nutzer, 10 s nach Start; Wiederholung frühestens nach 30 Tagen UND 15 weiteren Starts. Zähler in shared_preferences (`rating_*`). Achtung: Das Fenster erscheint zuverlässig nur bei Installationen über Play (z. B. Closed Track); im Debug-Build zeigt Google es meist nicht an — requestReview() schlägt dann still fehl, das ist normal.

Interaktive Kurse in der Flutter-App (der Web-Python-Kurs bleibt unberührt). SQL fertig geschrieben, Python folgt auf derselben Engine.

**Stand 19.08.:** Alle 14 Lektionen geschrieben (1 SELECT · 2 AS/DISTINCT · 3 WHERE/NULL · 4 ORDER BY/LIMIT · 5 Aggregate · 6 GROUP BY · 7 HAVING · 8 Schlüssel/Beziehungen · 9 INNER JOIN · 10 LEFT JOIN · 11 Unterabfragen · 12 INSERT/UPDATE/DELETE · 13 CREATE TABLE · 14 Normalisierung/ER). Einstieg über den Lern-Hub (Sektion KURSE, NEU-Badge). Eigenes Kurs-Theme aus den AppColors (`lib/theme/kurs_theme.dart`), Screens sehen aus wie der Rest der App. **Ada im Kurs:** Knopf oben rechts in jeder Lektion, bekommt Lektions- und Aufgabenkontext, darf laut Prompt keine Lösungen verraten, läuft über `GeminiService`/ai-tutor (5er-Limit greift). Vorstellungs-Fix in `gemini_service.dart`: Ada stellt sich nur noch beim ersten Austausch vor (wirkt app-weit). Migration `kurs_fortschritt` ist eingespielt, Sync läuft. `lib/kurs_test.dart` ist obsolet (kein ThemeProvider mehr) und kann gelöscht werden.

**Architektur — Inhalte sind Daten, keine Screens:**
- `lib/models/kurs_aufgabe.dart`: Kurs → Lektion → Blöcke (Text/Überschrift/Code/Hinweis/Aufgabe). Aufgabentypen: Lückentext, Reihenfolge (Drag & Drop/Parsons), Fehler-finden+korrigieren, Auswahl, SQL mit echter Ausführung.
- `lib/services/sql_sandbox.dart`: führt Nutzer-SQL gegen **SQLite in-memory auf dem Gerät** aus (Pakete `sqlite3` + `sqlite3_flutter_libs`, in pubspec). DB wird pro Ausführung frisch aufgebaut (DELETE-Übungen gefahrlos). Geprüft wird das ERGEBNIS gegen die Musterlösung, nicht der Wortlaut. Fehlermeldungen ins Deutsche übersetzt.
- `lib/data/kurse/sql_datensaetze.dart`: durchgehendes Szenario „Nordwind GmbH" (6 Tabellen: kunden, artikel, bestellungen, positionen, mitarbeiter, abteilungen; deutsche Namen wie in IHK-Aufgaben).
- `lib/data/kurse/sql_kurs.dart`: alle 14 Lektionen, 81 Aufgaben, ca. 3,5 h. Rote Fäden: Lektion 8 macht den Join VON HAND (zwei Abfragen), 9 löst ihn auf; Lena Fricke (abteilung_id NULL) und Kunde 12 (nie bestellt) sind die Cliffhanger für LEFT JOIN; Lektion 11 löst das MAX-Versprechen aus Lektion 5 ein; 14 erklärt 2NF an positionen und 3NF an abteilungen.
- `lib/widgets/kurs/`: `kurs_aufgaben_widgets.dart` + `sql_aufgabe_widget.dart` (Editor, Ergebnistabelle, „Tabellen"-Sheet, Tipp erst ab 2. Versuch; drei Rückmeldungen: läuft nicht / läuft aber falsches Ergebnis / richtig).
- `lib/screens/kurse/`: Übersicht (Kacheln + Fortschritt) und Lektions-Screen als **PageView-Schritte** (eine Aufgabe pro Bildschirm; Texte werden an Überschriften automatisch geteilt; ungelöste Aufgaben blockieren nicht → Knopf heißt dann „Überspringen").
- Fortschritt: `lib/services/kurs_fortschritt_service.dart` — lokal (shared_preferences) sofort, Supabase-Sync wenn eingeloggt (Tabelle `kurs_fortschritt`, RLS eigener Fortschritt, kein UPDATE). Migration eingespielt.

**Didaktik-Regeln (aus Nutzertest mit dem Entwickler):**
- Langsam ansteigend: neue Sache immer allein einführen (ohne Fallen), dann Wiederholung mit anderer Tabelle, DANN Distraktoren. Lektion 2+3 starten mit „Kurz zurückblicken"-Aufgabe aus der Vorlektion.
- SQL-Aufgaben früh im **Baustein-Modus** (antippen statt tippen, wie Mimo), mit gezielt falschen Bausteinen (==, 'Köln' ohne Quotes, artikeln, UNIQUE statt DISTINCT …); Umschalter „Selbst tippen" vorhanden. Ab ca. Lektion 6 ohne Bausteine.
- KEINE Gedankenstriche (—) in sichtbaren Texten (KI-Erkennungsmerkmal, gleiche Regel wie Social Media). Kein Jargon ohne Erklärung („teuer" für Laufzeit o. Ä.).
- Erklärung nach jeder Aufgabe sagt, was das Ergebnis BEDEUTET, nicht nur ob es stimmt.

**Nächste Schritte Kurs:** `flutter analyze lib` + Durchspiel-Test auf dem Gerät (Lektion 1 komplett lösen → prüft Freischaltung von L2 UND 🌱-Badge mit Konfetti) · `lib/kurs_test.dart` löschen · Verlinkung von der Lektions-Abschlussseite ins Level-Modul „Datenbanken & SQL" (Kurs lehrt, Level drillt; bewusste Entscheidung: Kurs ERSETZT die Levels nicht) · Python-Kurs auf derselben Engine · Release (Versions-Bump, Closed Track) · Marketing: „Kompletter SQL-Kurs, kostenlos" zur AP1-Saison · später: Premium-Gate einschalten (kursPremiumAktiv), Kursinhalte nach Supabase umziehen (Fixes ohne App-Release).

---

## 5. Web / SEO (Kurzfassung)

Voller Stand in `claude/seo-status-web.md` (Claude-Projekt). Kurz: SEO-Landingpage-Cluster unter `/lernen/*` (10 Themen), Pillar-Seite `/fachinformatiker-pruefung`, Sitemap, strukturierte Daten, OG-Bild, 301-Redirect, Hell/Dunkel-Theme. **07/2026:** alle 10 Lernseiten inhaltlich vertieft (Alltags-Vergleiche, Prüfungstipp- & „Häufige Fehler"-Kästen, sichtbarer FAQ, je 5 Quizfragen; RAID auf themefähiges System umgebaut) — ✅ **live deployt und verifiziert**. MailerLite komplett entfernt. Neue strukturierte Prüfungs-Ergebnisseite (`ExamResult.tsx`) live.

---

## 6. Offene Punkte / Nächste Schritte

**App**
- **Profil-Fortschritt neu: Pruefungsbereitschaft (26.08.2026, kommt mit v13):** Die alten Kacheln "Fragen" und "Trefferquote" sind raus (waren irrefuehrend: nur der Uebungsbereich schrieb in user_progress, Levels/Kurse/Arena nicht -> 100 % trotz Fehlern). Neu: grosse Bereitschafts-Karte mit Ring ("Pruefungsbereit: X %"), beim Antippen Aufschluesselung nach BEREICHEN: Lernmodule (gemeisterte Themen aus thema_scores, ab required_score), Levels (level_progress ab Schwelle), SQL-Kurs und Python-Kurs (geloeste Aufgaben aus kurs_fortschritt). Gesamtwert = Durchschnitt der vier Bereichs-Prozente. Neuer `BereitschaftsService` (lib/services/bereitschafts_service.dart). Darunter schlanke Reihe Streak/Zertifikate/Pruefungen. Merke Spaltennamen: themen.module_id vs thema_scores.modul_id.
- **Telegram: Google-Testgeraete-Erkennung in notify-signup (26.08.2026):** Nach jedem Play-Upload erzeugen Googles Testgeraete Gast-Accounts im Minutentakt (IPs 74.125.x/66.249.x/66.102.x/108.177.x, alle Google). Die Function holt jetzt die Session-IP (RPC `get_signup_ip`, Migration 20260826120000, nur service_role) und markiert Signups aus Google-Bereichen als "🤖 Google-Testgeraet"; jede Meldung zeigt zudem die IP. Echte Gaeste seit 13.08.: ca. 8.
- ✅ **Antwortlaengen-Fix datenbankweit (26.08.2026, NUR DB, kein Release noetig):** Das Muster "laengste Antwort = richtig" war bei 62.8 % aller MC-Fragen erratbar (343 krasse Faelle mit Verhaeltnis >1.3). Fix: 480 Fragen ueberarbeitet, 1333 Antworttexte per SQL angepasst (meist falsche Antworten fachlich plausibel verlaengert, bei 172 Fragen die aufgeblaehte richtige gekuerzt). Ergebnis nachgemessen: 30.8 % (unter Ratewahrscheinlichkeit 25 %+Streuung), krasse Faelle 0. Skript: `tools/fix_antwortlaengen_20260826.sql`. Vorgehen: CSV-Export aus SQL Editor -> parallele Umschreibung -> automatische Endkontrolle (Laengenband 0.6-1.1, keine Gedankenstriche, keine Duplikate). Wahr/Falsch-Fragen (2 Antworten) waren Fehlalarme und blieben unangetastet. Rest-Bestand (Verhaeltnis 1.0-1.3) ist unauffaellig.
- **Arena-Fixes (26.08.2026, app-seitig, kommt mit v13):** (1) FK-Crash `match_answers_antwort_id_fkey` bei Pseudo-MC-Fragen aus calculation_data behoben (Antwort-Index 0..3 wurde als antwort_id gesendet; jetzt Sentinel wie bei Spezialfragen). (2) Timer je Fragetyp statt pauschal 30 s: sequence/fill_blank 60 s, freitext_ada 120 s (`_zeitFuerTyp` in async_match_play_screen.dart). (3) Alte offene Matches mit nicht mehr erlaubten Fragetypen (freitext etc., aus der Zeit vor dem Filter in `create_async_match_any`) per Aufraeum-SQL entfernt.
- ✅ **v8 (1.1.1+8) LIVE IN PRODUKTION** (09.08.2026, 16:14 — Submission activity „Published"): Belegprüfung, Anschlüsse-Quiz, eigene Sounds, neue Billing-Lib für alle Store-Nutzer. (Warnung beim Promote „1.022 Geräte nicht mehr unterstützt" = Uralt-Androids durch Flutter-Upgrade-minSdk, unkritisch akzeptiert.)
- **Matchmaking-Bots aufgestockt** (21.08.2026): 10 neue Bots (LeonZockt, annalenaaa, jonas.k, Kabelklaus, der_echte_finn, paul_ffm, Milchschnitte, ninaberlin, fraeulein_toni, lukas.hd) mit Elo 950-1048, jetzt 20 gesamt. Skript: `tools/bots_rangliste_20260821.sql`. System: `run_bot_takeover` (pg_cron alle 10 Min) laesst Bots mit `profiles.is_bot=true` offene Matches uebernehmen, die 6+ h warten (Elo ±200, Trefferquote elo-abhaengig ~50 % bei 1000). Stolperfalle dokumentiert: Signup-Trigger `handle_new_user` legt Profile NACH den CTEs an, daher Profile nie selbst inserten, sondern nachtraeglich updaten. Merker: Supabase-Hinweis "enable RLS" auf player_stats/profiles NICHT blind klicken (App braucht erst Policies) — RLS-Review als offener Punkt.
- **Lernmodule-Seite aufgehuebscht** (26.08.2026): Icon + eigene Akzentfarbe pro Modul (Zuordnung per Namens-Keyword in `_modulStil`, modul_liste_screen.dart), Fortschrittsring statt Prozent-Text auf jeder Kachel (Liste + Grid), "Weiterlernen"-Karte mit zuletzt geoeffnetem Modul (Pref `weiterlernen_modul_id`). Offen als Idee: Themen-Gruppierung nach Pruefungsbereich.
- **Telegram-Meldung bei Problem-Reports LIVE** (26.08.2026, getestet): Eigener privater Kanal "Lernarena Meldungen" (Chat-ID -1004312008296, Secret TELEGRAM_REPORTS_CHAT_ID, Bot ist Kanal-Admin). Trigger `on_question_report_notify` auf question_reports -> Edge Function `notify-report` (Fallback Admin-Chat, wenn Secret fehlt). DABEI GEFUNDEN: question_reports hatte NIE GRANTs/Policies — kein Nutzer konnte je eine Meldung absenden (42501). Gefixt (RLS + Policies + GRANTs). Merkzettel Kanal-ID: Nachrichtenlink t.me/c/XXXX/N -> Chat-ID = -100XXXX; getUpdates geht nicht (Webhook aktiv), Bots nur ueber @username suchbar.
- **Telegram-Meldung bei Premium-Kaeufen LIVE** (25.08.2026, getestet): Trigger `on_profile_premium_notify` auf profiles (feuert nur bei Neu-Aktivierung oder Planwechsel, nicht bei Auto-Restore) -> pg_net -> Edge Function `notify-premium` (deployt mit --no-verify-jwt, nutzt dieselben Secrets wie notify-signup). Migration 20260825120000. Kulanz-Rezept dokumentiert: Erstattung ohne Premium-Entzug via Play Console -> Bestellverwaltung -> Refund OHNE "Remove entitlement" (so beim ersten Premium-Kunden Florian gemacht, 25.08.).
- **v11 (1.4.0+11) IN PRODUCTION eingereicht** (22.08.2026): kompletter Python-Kurs, Kurs-Politur, Loesungsschutz. Zuvor im internen Track getestet (Lehre: zum Selbst-Testen IMMER erst interner Track, Updates kommen dort in Minuten an; im Alpha-Track dauert die Verteilung Stunden bis 24h).
- **v12 (1.4.1+12) HOTFIX Uebungsbereich** (22.08.2026, Ausloeser: Premium-Kunden-Bugreport "Fortschritt wird nicht gespeichert"): 5 Fixes. (1) Themen-Score wurde NIE gespeichert (Schluessel score_mod_* wurde nur gelesen, nirgends geschrieben) → test_fragen_screen speichert jetzt das beste Runden-Ergebnis. (2) Score zusaetzlich in die Cloud (NEU Tabelle `thema_scores` + `ThemaScoreService`, Migration 20260822100000; noetig weil auth_service.signOut alle lokalen Daten loescht → Logout killte den Fortschritt). (3) Fragenzaehler auf den Themen-Kacheln addierte bei jedem Reload auf (77 statt 11 = 7 Reloads) → frisch zaehlen statt aufaddieren. (4) Ergebnis-Dialog zaehlte alle JEMALS richtigen Antworten statt der aktuellen Runde (immer 100%) → neue Menge _rundeRichtig. (5) Report-Dialog: Overflow + im Dark Mode unsichtbare Texte (fixe Hellgrau-Farben) → scrollbar + Theme-Farben. NEBENBEFUND: Meldungen aus "Problem melden" landen in `question_reports`, aber NIEMAND wird benachrichtigt → TODO Telegram-Trigger wie bei Signups. Fragen-Inhalte Netzwerke-Modul geprueft (25 von 44): fachlich alle korrekt; Muster "laengste Antwort = richtig" am 26.08. datenbankweit entschaerft (siehe Antwortlaengen-Fix oben).
- **v10 (1.3.0+10) IM CLOSED TRACK (Alpha)** seit 20.08.2026, 15:44: SQL-Kurs komplett, Kurs- und Anschluss-Badges, Sounds, Store-Bewertungsabfrage, Profil-Badge-Fix. Nächster Schritt: auf Testgerät über Play installieren, durchtesten (inkl. Bewertungsfenster ab 5. Start, geht nur in Play-Builds), dann Promote to Production.
- ✅ **v9 (1.2.0+9, Gast-Modus) LIVE IN PRODUKTION** (10.08.2026): Closed-Track-Review bestanden → Promote to Production → Rollout. Alle Nutzer haben jetzt Gast-Modus, Gast→Account-Umwandlung, Kauf-Sperre für Gäste, Passwort-Reset-Flow. (Hinweis: Tester bekommen Closed-Track-Updates im Store z. T. mit Stunden Verzögerung — nur Propagation, kein Fehler.)
- ✅ **Ada-Limit gilt automatisch auch für Gäste** (10.08.2026 verifiziert): serverseitiges `FREE_LIMIT = 5`/Tag in Edge Function `ai-tutor` (usage_tracking pro User+Tag) — Gäste sind normale (anonyme) User und laufen durch denselben Check; Block nach 5 Fragen auf Gerät getestet. Bekanntes Schlupfloch: Gast könnte sich neu einloggen (neue User-ID = frisches Limit) — bewusst akzeptiert; Optionen falls KI-Kosten steigen: Gäste-Limit auf 3 senken (`user.is_anonymous` in der Function) oder Ada für Gäste sperren.
- **TODO nach v9-Verbreitung:** alte RPC `activate_premium_purchase` dichtmachen (`revoke execute from authenticated`), wenn v7/v8-Nutzer migriert sind.
- ✅ **`feature/gast-modus` in `main` gemergt** (10.08.2026, Fast-Forward auf `794beeb`, gepusht): main = kompletter v9-Stand. Neue Features starten ab jetzt frisch von `main`. (Beim ersten Merge-Versuch scheiterte `git checkout main` an uncommitteten Dateien — die Folge-Kommandos sahen erfolgreich aus, waren es aber nicht. Merke: nach checkout-Fehler erst committen, dann von vorn.)
- Später: Gradle ≥8.14, AGP ≥8.11.1, Kotlin ≥2.2.20 (nicht blockierende Flutter-Warnungen) + `withOpacity`→`withValues`-Aufräum-Session (384 Analyzer-Infos).
- KI-Kosten im Blick behalten (Ada läuft über Claude Haiku; Nutzungslimits über `usage_tracker`).

**Web**
- ✅ Play-Store-Badge live auf der Startseite (Hero, Schluss-CTA, Footer).
- ✅ **Prüfungs-ASCII-Diagramme durch SVG-Grafiken ersetzt** (10.08.2026, mit dem Merge live): 7 SVGs in `web/public/images/` (ap1-netzplan mit Vorgangsliste+Ablauf, ae1-streckennetz mit Routentabelle, ae1-klasse-transport, ae2-klasse-scan, ae2-treffer-beispiel, ae2-treffer-min, ae3-zeiterfassung) — einheitlicher Stil (dunkler Hintergrund #1a1a2e, Zebra-Tabellen, Pfeil-Marker). `image`-Feld der Fragen genutzt (Lightbox vorhanden); `.q-image` in ExamContent.tsx auf volle Breite umgestellt. Einfache `|`-Texttabellen bewusst gelassen (Monospace richtet sauber aus). Altes hs2-graph.png (ohne Kanten-Gewichte) durch ae1-streckennetz.svg ersetzt.
- ✅ **Vercel-Preview-Builds gefixt** (10.08.2026): Branch-Previews schlugen fehl, weil `NEXT_PUBLIC_SUPABASE_URL`/`ANON_KEY` nur für Production hinterlegt waren → in Vercel auch für die Preview-Umgebung freigegeben. Production war nie betroffen.
- ✅ **Python-Kurs KOMPLETT: alle 12 Lektionen** (10.08.2026): 1 Start/print, 2 Variablen/input, 3 Rechnen/Modulo/f-Strings, 4 if/elif/else (echter IHK-Notenschlüssel), 5 Schleifen, 6 🎮 Zahlenraten (binäre-Suche-Tipp), 7 Listen/Dictionaries, 8 Funktionen (DRY-Tipp), 9 Fehler/Tracebacks/try-except, 10 OOP (Klassen, Vererbung, UML-Brücke), 11 🎮 Snake (Abschlussprojekt LOKAL: Python-Installation + komplettes turtle-Snake mit Verweisen auf alle Kurslektionen, 3 Erweiterungs-Übungen), 12 Abschluss mit Python↔IHK-Pseudocode-Übersetzungstabelle, Minimum-Aufgabe in beiden Schreibweisen, Off-by-one-Warnung (IHK-Arrays oft ab Index 1). **Struktur:** `/python-kurs` = Übersicht (Kacheln als Links, FAQ, CTA); jede Lektion eigene Seite `/python-kurs/lektion-N` mit SEO-Metadata + Vor/Zurück-Navigation. Gemeinsames CSS `_components/kursTheme.ts`, Liste `_components/lektionen.ts`, Rahmen `_components/LektionLayout.tsx`. Sitemap: /python-kurs + alle 12 Lektions-URLs. Noch offen: auf `/lernen` + Startseite verlinken.
- ✅ **Python-Editor Terminal-Look** (10.08.2026): Editor hat jetzt eine eigene dunkle Farbwelt (GitHub-Dark-Palette #0D1117, hellere Kopfleiste, Schatten, abgesetzter Ausgabe-Bereich) — hebt sich in beiden Themes klar vom Seitenhintergrund ab.
- ✅ **Theme-Persistenz gefixt & getestet** (10.08.2026): Hell/Dunkel-Wahl (`localStorage lernarena-theme`) wird jetzt zentral im Root-`layout.tsx` per Inline-Script VOR dem ersten Paint angewendet — gilt damit auf allen Seiten (vorher fiel z. B. /lernen/* beim Seitenwechsel auf Dunkel zurück).
- **KI-Korrektur verbessert (07.08.):** Gesamtergebnis wird jetzt clientseitig aus den Einzelbewertungen summiert (Fix für „0/100 trotz Punkten"-Widerspruch), Konsistenz-Regeln im Prompt, große farbige Noten-Karte in `ExamResult.tsx`.
- `/upgrade` (Web-Stripe-Checkout) fertig bauen; Play-Premium-Nutzern dort keinen Doppelkauf anbieten.
- Nach 2–3 Wochen Search-Console-Daten prüfen → Seiten mit Impressionen weiter ausbauen; ggf. neue Themenseiten (VLAN, DHCP/DNS, USV, Scrum, …).

**KI / Kosten**
- ✅ ERLEDIGT (31.07.): Anthropic-Zahlung erfolgreich (Blocker war der VPN). Beide KI-Anbindungen auf **Claude Haiku 4.5** umgestellt:
  - Web-Tutor (`web/app/api/ki-korrektur/route.ts`): Claude primär → Groq-Fallback. Liefert jetzt **strukturiertes JSON**; neue Ergebnis-Ansicht in `ExamResult.tsx` (Punkte-Header, Note/Bestanden-Badges, Aufgaben-Karten mit Farbpunkten, Stärken/Verbesserungen/Lernempfehlungen). Fallback auf Rohtext, falls JSON-Parse scheitert.
  - Ada in der App (`supabase/functions/ai-tutor/index.ts`): Claude → Groq → Gemini. Edge Function deployed.
  - Keys: ANTHROPIC_API_KEY in Vercel-Env + Supabase-Secrets (nie im Code/Repo).
- Anthropic-Guthaben im Blick behalten (Start: 20 $; Haiku ≈ 1–2 Cent pro Prüfungskorrektur).

**Telegram-Bot / Zahlen**
- `/play raw` ausführen → klären, warum die Play-CSV auf Stand 03.08. hängt.
- Eigene Accounts ggf. in `stats_exclusions` eintragen (eine INSERT-Zeile, kein Deploy).
- Auffällig (17.08.): seit 7 Tagen keine echte Registrierung; „aktiv 7 Tage" misst nur Neu-Logins (last_sign_in_at), nicht echte Nutzung — bei Bedarf auf ein echtes Aktivitätssignal umbauen.

**Repo-Hygiene**
- ⚠️ ZWEI Repo-Kopien: `Desktop\Projekte\IHK\ihk_app` (dieses, aktiv, web/public vollständig) und `Desktop\Lernarena\ihk_app` (iOS-Arbeit vom 16.08.: codemagic.yaml, Info.plist, iOS-Icons; web/public LEER). Die "deleted:"-Einträge im git status der Lernarena-Kopie waren nur die unvollständige Kopie, nichts wurde gelöscht. TODO: iOS-Änderungen hierher übernehmen, danach eine Kopie stilllegen.
- `Desktop\Projekte\IHK\ihk_pruefung_widget` = toter Flach-Export vom 17.12.2025 (13 Dateien, ohne pub get nie lauffähig; verursachte 106 Analyzer-Fehler, solange er im VS-Code-Workspace hing). Kann archiviert/gelöscht werden.

**Social / Marketing**
- Fertiges Subnetting-Video auf TikTok + Instagram Reels posten.
- Social-Accounts nach Account-Checkliste vervollständigen (siehe `claude/account-checkliste.md`).

---

## 7. Arbeitsweise / Konventionen

- Ordner-Freigabe via Device-Bridge (pro Sitzung neu erteilen) — Claude liest/schreibt direkt in `web/` bzw. `ihk_app/`.
- **Commit-Regel (ab 19.08.2026):** Nach jedem wichtigen Arbeitspaket wird SOFORT committet und gepusht, nicht erst am Ende. Claude kann Git nicht selbst ausführen (Device-Bridge überträgt nur Dateien) und liefert deshalb nach jedem Paket die fertigen Befehle zum Kopieren; der User führt sie aus. GitHub-Konto für Pushes: claudioNelson.
- **Secrets** (API-Keys) kommen in `.env` / Vercel-Env, **nie** in den Chat oder ins Repo. `.env.old` bleibt in `.gitignore`.
- Projekt-Regel: **Schritt für Schritt arbeiten, Chat nicht überfüllen. Antworten auf Deutsch.**
- **Regel (ab 26.08.2026): Eine Frage ist KEIN Arbeitsauftrag.** Wenn der User etwas fragt ("was bedeutet X?", "warum ist Y so?"), erst erklaeren und dann fragen, ob er etwas geaendert haben will. Niemals ungefragt Code umbauen, nur weil im Gespraech ein moeglicher Verbesserungspunkt auffaellt — Verbesserung vorschlagen, auf Freigabe warten.

---

## App-Store-Screenshots (28.08.2026)

### Anforderungen (Stand 2026)

Apple verlangt nur noch **eine** iPhone-Größe: **6,9 Zoll, 1320 × 2868 px**
(iPhone 16/17 Pro Max). 1–10 Bilder je Sprache, PNG oder JPEG.
iPad-Screenshots (13 Zoll) nur, wenn die App iPad unterstützt.

### iPad deaktiviert

`TARGETED_DEVICE_FAMILY` in `ios/Runner.xcodeproj/project.pbxproj` von `"1,2"`
auf `"1"` gesetzt (drei Stellen). Lernarena ist damit eine reine iPhone-App:
kein iPad-Screenshot-Satz nötig, kein iPad-Layout-Risiko im Review.
Jederzeit umkehrbar — dann aber iPad-Bilder nachliefern.

### Workflow `ios-screenshots`

Auf Windows gibt es keinen iOS-Simulator; Codemagic baut auf macOS, dort sind
Simulatoren vorhanden. Neuer Workflow, **manuell zu starten** (kein Tag-Trigger):

1. Sucht einen 6,9-Zoll-Simulator (iPhone 17 Pro Max → 16 Pro Max → beliebiges
   Pro Max → beliebiges iPhone) und startet ihn
2. Setzt die Statusleiste auf 09:41 Uhr, volles Netz, volle Batterie
3. Fährt die App per Integrationstest durch: Login mit Demo-Account, dann die
   Tabs *Lernen*, *Prüfen*, *Arena*, *Profil* und ein Inhaltsbildschirm
4. Prüft die Maße jedes Bildes und warnt bei Abweichung von 1320 × 2868
5. Stellt alles unter `screenshots/*.png` als Artefakt bereit

**Neue Dateien:**
- `integration_test/screenshots_test.dart` — steuert die App, löst die Aufnahmen aus
- `test_driver/integration_test.dart` — schreibt die PNGs nach `screenshots/`
- `pubspec.yaml` — `integration_test` in den dev_dependencies

**Erforderlich in Codemagic:** Variablengruppe **`screenshot_credentials`** mit
`SHOT_EMAIL` und `SHOT_PASSWORD` (bestehender Testaccount mit Premium, beide
*Secure*). Die Zugangsdaten gehen per `--dart-define` in den Lauf und stehen
nirgends im Repo.

Der Test ist fehlertolerant: findet er einen Tab-Namen nicht, überspringt er ihn
und macht weiter. `pumpAndSettle` wird nicht verwendet, weil es bei
Dauer-Animationen (Confetti, Ladespinner) hängen bleibt — stattdessen feste
Wartezeiten.

---

## ⚠️ Zwei Arbeitskopien — Verwechslungsgefahr (28.08.2026)

Es existieren mehrere Checkouts desselben Repos:

| Pfad | Status |
|---|---|
| `Desktop\Projekte\IHK\ihk_app` | **aktuelle Arbeitskopie**, entspricht `origin/main` |
| `Desktop\Lernarena\ihk_app` | veraltete Kopie — sollte nicht mehr benutzt werden |
| `~\ihk_app` | alte Kopie von Aug 2025, unbenutzt |

Am 28.08. wurde versehentlich in der Lernarena-Kopie gearbeitet, was zu einem
abgelehnten Push und einem abgebrochenen Rebase führte. **Vor jedem `git`-Befehl
mit `git remote -v` und dem Prompt prüfen, in welcher Kopie man steht.**
Zusätzlich ist `C:\Users\cnm89` selbst ein Git-Repo (Telegram-Shop) — Befehle
außerhalb eines Projektordners landen dort.

---

## ⚠️ Icon-Stolperfalle

`assets/icon/app_icon.png` hat **schwarze** abgerundete Ecken (kein Alpha, echtes
Schwarz). iOS legt seine Maske selbst an, das ergibt schwarze Ränder im fertigen
Icon. Deshalb steht in `pubspec.yaml` zwingend
`image_path_ios: "assets/icon/app_icon_ios.png"` (vollflächiges Quadrat).
**`flutter pub run flutter_launcher_icons` nie ohne `image_path_ios` ausführen** —
sonst sind die schwarzen Ecken sofort wieder da.

---

## ⬜ Offen für den iOS-Store-Release

1. **Screenshots erzeugen** — Workflow `ios-screenshots` starten, Bilder sichten,
   4–6 auswählen und in App Store Connect hochladen. Die ersten 2–3 erscheinen in
   der Suchergebnisliste, dort die stärksten Screens zeigen.
2. **Händlerstatus (EU Digital Services Act)** — am 28.08. eingereicht,
   Status **In Prüfung**. Ohne ihn keine Veröffentlichung in der EU.
3. **In-App-Käufe für iOS** — bisher nur Google Play umgesetzt. Auf iOS findet
   `queryProductDetails` nichts, der Kauf schlägt fehl → Reject-Risiko
   (Richtlinie 2.1). Nötig: Abo-Gruppe mit drei Produkten in App Store Connect
   (`app.lernarena.premium.monthly` / `.halfyear` / `.annual`),
   `billing_service.dart` plattformabhängig, und in der Edge Function
   `verify-purchase` ein Apple-Zweig gegen die App Store Server API.
   Der Paid Applications Agreement ist seit 16.08. **aktiv**.
4. **Testinformationen** in TestFlight (Feedback-E-Mail, Kontaktdaten,
   Demo-Login) — erst für **externe** Tester nötig. Danach in `codemagic.yaml`
   `submit_to_testflight: true` setzen.
5. **App-Store-Metadaten** — Beschreibung, Keywords, Untertitel,
   Datenschutzangaben, Altersfreigabe, Kategorie, Support-URL.

---

## Demo-Account für Screenshots und Apple-Review (28.08.2026)

**E-Mail:** `demo@lernarena.app` · Passwort liegt in Codemagic
(`SHOT_PASSWORD`, Gruppe `screenshot_credentials`) und gehört **nicht** in dieses
Dokument.

Angelegt über Supabase → Authentication → Users → *Add user*, mit
**Auto Confirm User**. Derselbe Account dient später als Demo-Login für Apples
App-Review — hinter dem Login sieht der Prüfer sonst nichts.

### Ausstattung

| Bereich | Wert | Tabelle |
|---|---|---|
| Anzeigename | `Alex` | `profiles.username` |
| Premium | `is_premium = true`, `premium_tier = 'lifetime'`, `premium_until = null` | `profiles` |
| Streak | 12 Tage | `profiles.streak_days` |
| Beantwortete Fragen | 1.261 von 1.507, davon 1.110 richtig (88 %) | `user_progress` |
| Gemeisterte Themen | rund 85 % von 70 | `thema_scores` |
| Gemeisterte Levels | 82 von 92 (89 %) | `level_progress` |

`premium_tier = 'lifetime'` mit `premium_until = null` ist bewusst gewählt:
`subscription_service.dart` prüft das Ablaufdatum nur, wenn der Tier **nicht**
`lifetime` ist. Der Account kann also nicht mitten in einem Screenshot-Lauf
ablaufen.

### Wie die Prüfungsbereitschaft wirklich gerechnet wird

Der Ring auf dem Profil kommt aus `bereitschafts_service.dart` und speist sich
aus **zwei** Quellen — `user_progress` gehört **nicht** dazu:

1. **Lernmodule:** gemeisterte Themen / alle Themen. Gemeistert, wenn
   `thema_scores.best_score >= themen.required_score` (Standard 80).
   Module mit `kategorie = 'kernthema'` sind ausgenommen.
2. **Levels:** `level_progress.best_score >= levels.schwelle` (70/80/100).

`user_progress` füllt dagegen die Fortschrittsbalken im Lernbereich und die
Modul-Abschlussquote in `progress_service.dart` (Modul gilt ab 80 % richtiger
Antworten als abgeschlossen).

### Zurücksetzen

```sql
delete from public.user_progress   where user_id = (select id from auth.users where email = 'demo@lernarena.app');
delete from public.thema_scores    where user_id = (select id from auth.users where email = 'demo@lernarena.app');
delete from public.level_progress  where user_id = (select id from auth.users where email = 'demo@lernarena.app');
```

### Offen

- Den Account in `stats_exclusions` eintragen (Migration
  `20260817090000_stats_exclusions.sql`), damit er die Nutzerstatistiken nicht
  verfälscht.
- In TestFlight → Testinformationen als Demo-Login hinterlegen, sobald externe
  Tester dazukommen.

---

## Datenbefund am Rande (28.08.2026)

Von **1.507** Fragen haben **1.026 keine `thema_id`** und **246 keine
`modul_id`**. Nur 481 sind vollständig zugeordnet. Fragen ohne Themenzuordnung
tauchen in themenbasierten Lernbereichen vermutlich nicht auf — das kann Absicht
sein (etwa wenn sie nur über Prüfungssimulationen laufen) oder eine Altlast aus
einem Import. Lohnt einen genaueren Blick: potenziell viel ungenutzter Inhalt.

---

## Arena-Screenshot und Browser-Hinweis (30.08.2026)

Zwei Änderungen, beide ausschließlich für die App-Store-Bilder gedacht.

### 1. Hinweisbox auf dem Prüfen-Screen entfernt

`lib/screens/pruefen/pruefen_screen.dart`, Methode `_buildIhkList()`. Ganz oben
in der Liste stand:

> IHK-Prüfungen bearbeitest du in der Web-Version. Diagramme, SQL und lange
> Texte gehen am Laptop einfach besser. Tippe auf eine Prüfung — sie öffnet
> sich im Browser.

Die Box ist raus, an ihrer Stelle steht ein Kommentar mit dem Grund. Zwei
Motive:

1. Sie saß über allem und war damit auf **jedem** Screenshot des Prüfen-Tabs.
2. „Öffnet sich im Browser" ist genau die Formulierung, an der Apples Review
   bei **Guideline 4.2 (Minimum Functionality)** hängen bleibt. Eine App, die
   ihren Kernbereich in den Browser auslagert, gilt schnell als Website-Hülle.
   Lernen, Levels und Kurse laufen in-app, damit ist die App vermutlich sicher
   — aber man muss den Prüfer nicht mit der Nase darauf stoßen.

Zurückholen: `git log -p -- lib/screens/pruefen/pruefen_screen.dart`, Commit
vom 30.08.2026.

**Offen und wichtiger als der Text:** Der Tap auf eine Prüfung öffnet weiterhin
den Browser. Für den Store sollte mittelfristig entweder ein In-App-Webview mit
eigener Navigation her oder die Prüfungen wandern in die App.

### 2. Arena mit Demo-Daten füllen

Der Arena-Tab zeigte beim Demo-Konto „AKTIVE MATCHES · 0 / Keine aktiven
Matches" und keinen ELO-Banner — als Store-Bild wertlos. Skript dafür:
`tools/arena_demo_fuellen.sql`.

Was der Screen woraus liest (`async_match_demo_screen.dart` +
`async_duel_service.dart`):

| Element im Screen | Quelle |
|---|---|
| ELO-Banner mit Stufe, Siegen, Winrate | `player_stats` — erscheint **nur**, wenn `matches_played > 0` |
| Stufenname (BRONZE … MEISTER) | `elo_rating`: ≥850 Bronze, ≥1000 Silber, ≥1150 Gold, ≥1300 Diamant, ≥1500 Meister |
| „AKTIVE MATCHES · n" | `matches` mit `player1_id` oder `player2_id` = ich, Status **nicht** completed/finalized/finished |
| Badge „NOCH x FRAGEN" | `total_questions` minus Anzahl eigener Zeilen in `match_answers` |
| „HISTORY · n" | dieselben Matches mit Status completed/finalized/finished, Scores aus `match_scores` |

Die Match-Karte zeigt **keinen Gegnernamen**, nur `#MATCHID`, den Status und
die Fragenzahl. Deshalb brauchen die Demo-Matches keinen zweiten Spieler:
`player2_id` bleibt leer, genau wie bei einem frisch erstellten Match aus der
App (`create_async_match_any`).

Das Skript setzt ELO 1180 (GOLD), 17 Siege / 2 Remis / 5 Niederlagen = 70 %
Winrate, und legt drei Matches mit 4 / 7 / 0 beantworteten Fragen an. Abschnitt
0 gibt das Schema aus, Abschnitt 4 macht alles rückgängig.

**Nicht sicher bekannt:** Die Spalten von `matches`, `match_answers` und
`player_stats` stehen in keiner Migration im Repo — sie leben nur in der
Remote-Datenbank. Das Skript ist deshalb defensiv geschrieben (UPDATE-dann-
INSERT statt `ON CONFLICT`, Fallback von Status `active` auf `open`). Falls es
mit „column … does not exist" abbricht, liefert Abschnitt 0 die echten Spalten.

### 3. Screenshot-Test aufgeräumt (30.08.2026, nachmittags)

Nach dem Lauf mit den Arena-Daten waren von neun Aufnahmen mehrere unbrauchbar.
`integration_test/screenshots_test.dart` erzeugt jetzt sieben statt neun Bilder:

| Datei | Screen |
|---|---|
| `01_lernen` | Lernhub, „Guten Morgen, Alex" |
| `02_pruefen` | IHK-Prüfungen, AE-Liste |
| `03_zertifikate` | Zertifikate (über den Umschalter oben) |
| `04_arena` | ELO-Banner + aktive Matches |
| `05_levels` | Level-Pfade mit Fortschritt |
| `06_kurs` | SQL von Grund auf |
| `07_anschluesse` | Anschlüsse-Quiz |

Entfallen sind:

- **`03_pruefungsliste`** — der Tap auf „Anwendungsentwicklung" führte nirgendwo
  hin, das ist bloß eine Überschrift. Das Bild war eine exakte Dublette von
  `02_pruefen`.
- **`04_pruefung_detail`** — der Tap auf eine Prüfungskarte öffnet den Browser
  und verlässt damit die App. Eine In-App-Detailansicht existiert nicht.
- **Das blinde Scrollen für die Zertifikate.** `scrolle(tester, 900)` landete
  zwischen zwei Karten; oben im Bild schwebte ein „90 Minuten · 100 Punkte ·
  Starten" ohne Titel. Stattdessen tippt der Test jetzt auf den Umschalter
  „Zertifikate" im Kopf des Prüfen-Tabs. Die Hilfsfunktion `scrolle()` ist
  ersatzlos raus.

**Merksatz für später:** Im Prüfen-Tab nicht scrollen, sondern umschalten.
Blindes Scrollen um feste Pixelwerte trifft bei unterschiedlich hohen Karten
nie zuverlässig eine Kartengrenze.

### Die fünf Store-Bilder (Stand 30.08.2026)

Aus dem letzten Lauf sind fünf brauchbare Aufnahmen gekommen. Reihenfolge in
App Store Connect, Größe **6,9" iPhone / 1320 × 2868** — nur diese eine Größe
ist nötig, Apple skaliert für kleinere Geräte selbst:

1. `01_lernen` — Lernhub, „Guten Morgen, Alex"
2. `02_pruefen` — IHK-Prüfungen, AE-Liste
3. `05_levels` — Level-Pfade mit Fortschritt
4. `03_zertifikate` — SAP, AZ-900, GCP, AWS
5. `04_arena` — GOLD, ELO 1180, aktive Matches

Lernen und Prüfen stehen vorn, weil die ersten beiden Bilder schon in der
Suchergebnisliste erscheinen, ohne dass jemand die Produktseite öffnet.

`06_kurs` und `07_anschluesse` sind im Lauf nicht entstanden — Ursache nicht
untersucht, fünf Bilder reichen. Apple erlaubt bis zu zehn und verlangt nur
eines; nachträglich austauschen geht jederzeit per Drag-and-drop.

### Store-Bilder mit Überschrift (30.08.2026)

Die nackten Simulator-Aufnahmen wandern nicht direkt in den Store, sondern
bekommen erst die Marketing-Überschrift — dasselbe Layout wie bei den
Play-Store-Bildern: violette Serifenschrift oben, darunter der Screenshot in
einem abgerundeten Rahmen, der unten aus dem Bild läuft.

**Skript:** `tools/store_bilder/render_store_bilder.py`

Es rendert eine HTML-Vorlage in headless Chromium (Playwright) und
fotografiert sie in 1320 × 2868 ab. Chromium statt Pillow, weil sich damit
**Instrument Serif** einbetten lässt — dieselbe Schrift wie in der App. Die
Schrift kommt über npm, nicht über Google Fonts:

```
cd tools/store_bilder
npm install @fontsource/instrument-serif
mkdir quelle          # hier die Codemagic-Artefakte ablegen
python3 render_store_bilder.py
```

Die Quelldateien müssen `quelle/01_lernen.png` … `quelle/05_arena.png` heißen
und exakt 1320 × 2868 groß sein. Ergebnis landet in `ausgabe/`.

Überschriften ändern: oben in der Liste `BILDER`. Zeilenumbrüche werden mit
`\n` **von Hand** gesetzt, nie automatisch — sonst reißt es Wörter
auseinander. Genau das war in den Play-Store-Bildern passiert
(„Prüfungsbedingunge/n."). Zu lange Zeilen verkleinert das Skript
automatisch, bis sie in die Breite passen.

**Warum nicht die Play-Store-Bilder wiederverwenden:** urheberrechtlich
spricht nichts dagegen, es ist eigenes Material. Aber auf ihnen steckt ein
Android-Telefon — Punch-Hole-Kamera in der Statusleiste, Android-Icons,
Gestenbalken unten. Apple lehnt Screenshots ab, die die App auf fremder
Hardware zeigen. Dazu kommt das falsche Seitenverhältnis (9:16 statt 1:2,17),
das sich nicht ohne Beschnitt oder Verzerrung anpassen lässt.

Fertige Bilder liegen unter `Desktop\Lernarena\AppStore-Bilder\` — bewusst
außerhalb des Repos, damit die PNGs die Historie nicht aufblähen.

---

## App-Store-Metadaten (30.08.2026)

Festgelegt für die erste iOS-Einreichung. Sprache: Deutsch.

### Version

**1.5.0** — nicht 1.0. Apple verlangt, dass die Versionsnummer in App Store
Connect **exakt** der `CFBundleShortVersionString` des ausgewählten Builds
entspricht. `pubspec.yaml` steht auf `1.5.0+14`, die Nummer ist über die
Android-Veröffentlichungen gewachsen. Passt die Nummer nicht, bleibt die
Build-Auswahlliste in App Store Connect einfach leer, ohne Fehlermeldung.

Der Build in TestFlight war zu diesem Zeitpunkt noch **1.2.0 (10)**, also muss
ein neuer Build mit 1.5.0 hochgeladen werden, bevor sich die Version
einreichen lässt.

### Feste Felder

| Feld | Wert |
|---|---|
| Support-URL | `https://lernarena.app/impressum` (besser: eigene `/support`-Seite) |
| Marketing-URL | `https://lernarena.app` |
| Copyright | `2026 Claudio Medeiros Magalhaes` (aus dem Impressum) |

### Schlüsselwörter (97 von 100 Zeichen)

```
IHK,Azubi,AP1,AP2,Anwendungsentwicklung,Systemintegration,Umschulung,Ausbildung,Prüfung,SQL,Python
```

Überlegungen dahinter:

- **„Fachinformatiker" und „Lernarena" fehlen bewusst.** Beide stehen im
  App-Namen („Lernarena: Fachinformatiker") und werden dort schon indexiert.
  Doppelt einzutragen wären 26 verschenkte Zeichen.
- **AP1 / AP2** sind die stärksten Begriffe: so nennen Azubis die gestreckte
  Abschlussprüfung, und kaum eine Lern-App belegt sie.
- **Kein Leerzeichen nach dem Komma** — Apple zählt es mit.
- **Keine Wortgruppen.** Apple kombiniert die Begriffe selbst, „IHK Prüfung"
  entsteht aus `IHK` und `Prüfung`.
- **„Lernen" und „Quiz" wurden gestrichen**, zu allgemein — dort konkurriert
  man mit Duolingo und Quizlet.
- **„Programmierung" bewusst nicht**: 15 Zeichen für einen Begriff, bei dem
  man gegen jede Coding-App antritt. `SQL` und `Python` treffen dasselbe
  Publikum für 11 Zeichen genauer.

### Beschreibung

Der Text liegt in App Store Connect. Zwei Regeln beim Ändern:

1. **Premium wird nicht erwähnt.** Solange der In-App-Kauf auf iOS fehlt,
   wäre das die Ankündigung von etwas, das der Prüfer nicht kaufen kann —
   und genau danach sucht er (Guideline 3.1.1 / 2.1). Sobald StoreKit drin
   ist, kommt ein Abschnitt dazu.
2. **Leerzeilen zwischen den Abschnitten erhalten**, sonst klebt im Store
   alles zu einem Block zusammen und die Überschriften gehen unter.

### Untertitel

Noch offen. 30 Zeichen, wird zusätzlich indexiert und kostet kein
Keyword-Budget. Kandidaten: `IHK-Prüfung üben, AP1 und AP2` (29).

---

## Premium-Kauf auf iOS ausgeblendet (30.08.2026)

`billing_service.dart` spricht ausschließlich Google Play — der Cast auf
`GooglePlayProductDetails` in `_basePlanIdOf` macht das unmissverständlich.
Auf iOS gäbe es also Kauf-Knöpfe, die ins Leere führen. Das ist bei Apples
Prüfung ein sicherer Ablehnungsgrund (Richtlinie 2.1, App Completeness).

### Der Schalter

Neu in `lib/widgets/premium_kauf_sheet.dart`:

```dart
bool get premiumKaufMoeglich => kIsWeb || !Platform.isIOS;
```

`kIsWeb` muss zuerst stehen, `Platform` wirft im Browser. Zusätzlich gibt
`showPremiumKaufSheet()` auf iOS sofort `null` zurück, falls doch jemand
daran vorbei aufruft.

### Wo überall gekauft werden konnte

Erst nach vollständigem Durchsuchen von `lib/` sichtbar geworden — ein erster
Teildurchlauf hatte nur zwei der fünf Stellen gefunden:

| Datei | Was passierte |
|---|---|
| `pages/pruefung/ihk_pruefung_detail_screen.dart:31` | `PremiumLock` vor jeder IHK-Prüfung |
| `screens/zertifikate/zertifikat_test_screen.dart:485` | `PremiumLock` vor dem Zertifikatstest |
| `screens/zertifikate/certificate_practice_screen.dart:285` | `PremiumLock` vor dem Übungsmodus |
| `screens/kurse/kurs_uebersicht_screen.dart` | Kauf-Sheet beim Tippen auf eine gesperrte Lektion |
| `screens/learning/ai_tutor_chat_screen.dart:97` | Kauf-Sheet aus dem Limit-Dialog von Ada |

Gelöst an drei zentralen Stellen statt an fünf Aufrufstellen:

- **`premium_lock.dart`** — Preisangabe („11,99€/M · …") und der Knopf
  „Premium aktivieren" verschwinden. Die Vorteilsliste bleibt, sie erklärt
  nur, was Premium ist. Das deckt drei der fünf Stellen ab.
- **`limit_reached_dialog.dart`** — statt „Später / Premium" nur noch ein
  „Verstanden". Deckt Ada und die Arena ab.
- **`kurs_uebersicht_screen.dart`** — gesperrte Lektion zeigt einen Snackbar
  statt des Kauf-Sheets.

### Ebenfalls raus: die Web-Empfehlung

`_buildWebCard()` im Prüfungsdetail verlinkte per `launchUrl` auf
`https://lernarena.app`. Dort werden Abos verkauft, und Nutzer zu einem
Kaufweg außerhalb des App Store zu lotsen verstößt gegen Richtlinie 3.1.3.
Unabhängig davon nährt „bearbeite das lieber am Desktop" den Verdacht, die
App sei nur eine Hülle um eine Website (Richtlinie 4.2). Die Karte wird auf
iOS nicht mehr gerendert.

**Grundregel für später:** Bei fehlender Kaufmöglichkeit bleiben gesperrte
Inhalte einfach gesperrt. Nicht auf die Web-Version verweisen, auch nicht
dezent — genau das ist der Verstoß.

### Korrektur eines Irrtums aus diesem Chat

Zwischenzeitlich stand hier die Annahme, die IHK-Prüfungen würden beim
Antippen im Browser geöffnet. Das stimmt nicht. `pruefen_screen.dart`
navigiert per `Navigator.push` in `IHKPruefungDetailScreen`, also in-app.
Der Browser-Hinweis stammte aus einer veralteten Info-Box, die wir vorher
entfernt haben. Die Guideline-4.2-Sorge ist damit weitgehend vom Tisch.

### Was noch fehlt

StoreKit. Für 1.6: Abo-Gruppe in App Store Connect anlegen, plattformabhängige
Produkt-IDs in `billing_service.dart`, Apple-Zweig in der Edge Function
`verify-purchase`, Sandbox-Test auf einem echten iPhone. Danach
`premiumKaufMoeglich` auf `true` ziehen und die Beschreibung im Store um
einen Premium-Abschnitt ergänzen.

---

## Premium auf beiden Plattformen (geplant für 1.6)

Ziel: ein Codestand, der auf Google Play und im App Store verkauft, ohne
zwei Build-Varianten. Der Plan steht, umgesetzt ist noch nichts.

### Was schon richtig gebaut ist

`subscription_service.dart` liest den Premium-Status ausschließlich aus
`profiles` — `is_premium`, `premium_until`, `premium_tier`. Die App fragt
**nie** den Store, sondern immer die eigene Datenbank. Damit ist die
Grundarchitektur bereits plattformneutral: Beide Stores schreiben am Ende in
dieselben drei Spalten, alles darüber bleibt unverändert. Auch das Paket
`in_app_purchase` muss nicht getauscht werden, die StoreKit-Implementierung
bringt es mit.

Zu ändern sind nur vier Stellen.

### 1. Produkt-IDs sind plattformabhängig

Google Play kennt **ein** Abo `lernarena_premium` mit drei Base Plans
darunter. Apple kennt keine Base Plans — dort ist jede Laufzeit ein eigenes
Produkt innerhalb einer Abo-Gruppe.

```dart
// billing_service.dart
String get _abo =>
    Platform.isIOS ? 'app.lernarena.premium' : 'lernarena_premium';

Set<String> get _produktIds => Platform.isIOS
    ? {
        'app.lernarena.premium.monthly',
        'app.lernarena.premium.halfyear',
        'app.lernarena.premium.annual',
      }
    : {'lernarena_premium'};
```

### 2. Der Google-Cast muss ein Zweig werden

`_basePlanIdOf` castet hart auf `GooglePlayProductDetails` — auf iOS wirft
das. Dort **ist** die Produkt-ID bereits die Laufzeit, es gibt nichts
abzuleiten. Dasselbe beim Kauf: Android braucht `GooglePlayPurchaseParam`
mit Offer-Token, iOS reicht ein schlichtes `PurchaseParam`.

### 3. Zweiter Zweig in der Edge Function `verify-purchase`

Der eigentliche Brocken. Heute spricht die Funktion die Play Developer API.
Apple liefert stattdessen eine **signierte Transaktion (JWS)**, die gegen die
App Store Server API geprüft wird; `verifyReceipt` ist abgekündigt und darf
nicht mehr die Grundlage sein. Dafür braucht es einen eigenen
In-App-Purchase-Key aus App Store Connect als Secret — **nicht** derselbe
Key wie der für Codemagic.

Die App schickt ein Feld `platform` mit, die Funktion verzweigt darauf.
Beide Zweige enden identisch: `profiles` aktualisieren.

Zusätzlich eine Spalte `store` in der Abo-Tabelle anlegen. Bei
Rückerstattungen und Support-Anfragen muss man wissen, wo man nachsieht.

### 4. "Käufe wiederherstellen"

Apple verlangt einen solchen Knopf, Google nicht. Gehört ins Kauf-Sheet,
sichtbar auf beiden Plattformen (schadet auf Android nicht).

### Danach

`premiumKaufMoeglich` in `premium_kauf_sheet.dart` auf `true` ziehen — dann
kommen Kauf-Sheet, Preisangabe im `PremiumLock` und der Premium-Knopf im
Limit-Dialog automatisch zurück. Und die Store-Beschreibung um einen
Premium-Abschnitt ergänzen.

### Der praktische Blocker: Testen

StoreKit lässt sich im iOS-Simulator nur mit einer StoreKit-Konfigurations-
datei aus Xcode testen — dafür braucht man einen Mac. Ohne Mac und ohne
iPhone ist der Kaufweg nicht selbst durchspielbar, sondern nur über einen
Tester mit Gerät und Sandbox-Account (App Store Connect → Benutzer und
Zugriff → Sandbox).

**Deshalb wurde für 1.5.0 ausgeblendet statt eingebaut:** Ungetesteten
Kaufcode einzureichen ist riskanter als gar keinen. Ein Kauf, der beim
Prüfer abbricht, ist eine sichere Ablehnung; eine App ohne Kaufmöglichkeit
ist es nicht.

---

## Gemini aus dem KI-Failover entfernt (30.08.2026)

### Was die Kette vorher war

`supabase/functions/ai-tutor/index.ts` versuchte der Reihe nach:

```
Claude (claude-haiku-4-5)  →  Groq  →  Gemini
```

Die App spricht keinen der Anbieter direkt an, sie ruft nur die Edge
Function; die Schlüssel liegen nie auf dem Gerät. Das war und bleibt richtig.

### Warum Gemini raus musste

Der Gemini-Zugang war die **kostenlose Stufe**. Google verwendet dort Prompts
und Antworten zur Verbesserung der eigenen Produkte, einschließlich
menschlicher Sichtung; erst in der kostenpflichtigen Stufe ist das
ausgeschlossen. Für eine App mit deutschen Nutzern und einer
Datenschutzerklärung, die Zweckbindung zusagt, ist das nicht haltbar.

Anthropic läuft über einen kostenpflichtigen Zugang, dort ist Training über
die API ausgeschlossen. Groq trainiert ebenfalls nicht auf API-Inhalten.

Rückholen ist erlaubt, sobald ein **kostenpflichtiger** Gemini-Zugang
existiert — dann muss Google gleichzeitig in Abschnitt 6 der
Datenschutzerklärung auftauchen. Ein entsprechender Warnkommentar steht oben
in der Edge Function.

### Der eigentliche Fund: die Datenschutzerklärung war falsch

Abschnitt 6 nannte **ausschließlich Groq**, obwohl Anthropic der Anbieter
ist, der die Anfragen zuerst bekommt. Art. 13 DSGVO verlangt die Benennung
der Empfänger. Zusätzlich vergleicht Apples Prüfung die Datenschutzangaben
im Store mit der verlinkten Erklärung — eine Unstimmigkeit genau dort ist
teuer.

Ebenfalls gestrichen: die Zusage *"wir haben bei Groq die
Zero-Data-Retention-Einstellung aktiviert"*. Zero Data Retention ist bei Groq
üblicherweise Vertragsbestandteil und nichts, was man im kostenlosen Konto
anklickt. Unbelegte Zusagen in Rechtstexten sind schlechter als vorsichtige
Formulierungen. **Offen:** In der Groq-Console prüfen, ob ZDR für das Konto
tatsächlich gesetzt ist. Falls ja, darf der Satz zurück.

### Geändert wurde an drei Orten

Die Rechtstexte existieren **doppelt** und müssen immer gemeinsam gepflegt
werden — der Kommentar am Kopf von `legal_texts.dart` sagt das auch:

| Ort | Datei |
|---|---|
| App (offline eingebettet) | `lib/screens/legal/legal_texts.dart` |
| Website (Next.js, Vercel) | `web/app/datenschutz/page.tsx` |
| Edge Function | `supabase/functions/ai-tutor/index.ts` |

Die Web-App liegt im **selben Repo** unter `web/` — ein Next.js-Projekt, nicht
zu verwechseln mit dem Flutter-`web/`-Build-Ordner anderer Projekte. Das
Stand-Datum steckt dort in der Konstante `STAND` am Dateikopf. Die
Sprungmarke des Abschnitts hieß `groq` und heißt jetzt `ki-anbieter`.

Die AGB wurden nicht angefasst, deren Stand-Datum bleibt der 28. Juni 2026.

### Deployment

- Edge Function: `supabase functions deploy ai-tutor` (lief trotz
  "WARNING: Docker is not running" durch, die CLI weicht auf den API-Weg aus)
- `GEMINI_API_KEY` wurde mit `supabase secrets unset` entfernt
- Website: Vercel deployt bei Push auf main automatisch

**Wichtig für den iOS-Build:** Der eingebettete Rechtstext steckt im Binary.
Build 22 (Commit 311a063) enthält noch die alte Fassung. Deshalb Tag
`ios-v1.5.0-2` → Build 23, und den muss man in App Store Connect auswählen.

---

## App-Datenschutz-Fragebogen (30.08.2026)

Angekreuzt in App Store Connect → Vertrauen und Sicherheit → App-Datenschutz:

| Kategorie | Datentyp | Woher |
|---|---|---|
| Kontaktinformationen | E-Mail-Adresse | Registrierung über Supabase |
| Benutzerinhalte | Sonstige Benutzerinhalte | Chateingaben an Ada, selbst erstellte Karteikarten |
| Benutzerinhalte | Kundendienst | „Fehler melden"-Dialog |
| Kennungen | Benutzer-ID | Supabase-Konto-ID und Benutzername |
| Nutzungsdaten | Produktinteraktion | Lernfortschritt, Testergebnisse, Elo, `usage_tracking` |

Alles andere: nein.

### Warum bestimmte Punkte NICHT angekreuzt sind

**Name** — die Registrierung fragt nur Benutzername („dein_name"), E-Mail und
Passwort ab. Ein Handle ordnet Apple den *Kennungen* zu, nicht dem Datentyp
*Name*. Nachgesehen in `lib/screens/auth/register_screen.dart`.

**Diagnose (Crash-, Leistungsdaten)** — es ist kein Analyse- oder Crash-SDK
verbaut. Kein Firebase, kein Sentry, kein Crashlytics. Geprüft in
`pubspec.yaml`.

**Zahlungsdaten** — läuft über Stripe bzw. später StoreKit außerhalb der App,
wir haben nie Zugriff. Apple sagt selbst, dass das nicht als Erfassung gilt.

**Käufe** — diese iOS-Version kennt keinen Kauf. **Beim Einbau von StoreKit
nachziehen**, das vergisst man beim nächsten Release leicht.

**Fotos und Videos** — siehe nächster Abschnitt.

---

## Fotos in der Prüfung: bleiben auf dem Gerät (30.08.2026)

Bei Diagramm-Aufgaben in der IHK-Prüfung blendet
`ihk_pruefung_exam_screen.dart` das `PhotoUploadWidget` ein. Es nutzt den
ImagePicker mit Kamera und Galerie. Trotzdem ist „Fotos und Videos" im
Datenschutz-Fragebogen **nicht** anzukreuzen:

```dart
setState(() { _photoPath = image.path; });
widget.onPhotoSelected(image.path);
```

Gespeichert wird nur der **Dateipfad**, nicht das Bild. Der landet über
`_saveProgress()` in den SharedPreferences. Kein Supabase Storage, kein
Base64, kein Upload — das Foto verlässt das Gerät nie. Apple definiert
„erfassen" als Übertragung vom Gerät; rein lokale Daten werden nicht
deklariert.

Die Zweckbeschreibungen `NSCameraUsageDescription` und
`NSPhotoLibraryUsageDescription` in der `Info.plist` braucht es trotzdem —
die verlangt iOS beim Zugriff selbst, unabhängig vom Fragebogen.

### Zwei echte Mängel, die dabei aufgefallen sind

**1. Das Foto kann verschwinden.** Der ImagePicker legt die Datei im
temporären Verzeichnis der App ab. iOS räumt das bei Speicherdruck auf. Nach
einigen Tagen zeigt die Prüfung dann einen Pfad, hinter dem nichts mehr
liegt. Sauber wäre: die Datei in das Dokumentenverzeichnis der App kopieren
(`getApplicationDocumentsDirectory()`) und diesen Pfad speichern — oder,
besser, in Supabase Storage hochladen. Letzteres macht das Foto dann aber zu
erfassten Daten und muss im Fragebogen nachgetragen werden.

**2. Prüfungsantworten liegen gerätelokal.** `_saveProgress()` schreibt alle
Antworten in SharedPreferences. Wer das Gerät wechselt oder die App neu
installiert, verliert den Zwischenstand. Dieselbe Bauart wie beim
Modul-Fortschritt (`app_cache_service.dart`), der uns bei den Screenshots
0 % angezeigt hat, obwohl 1.261 Antworten in der Datenbank lagen.

Beides sind Produktmängel, keine Store-Blocker. Für die Einreichung
unerheblich, für die Nutzer nicht.

---

## Inhaltsrechte und Herkunft der Aufgaben (30.08.2026)

### Was gegenüber Apple erklärt wurde

App-Informationen → Inhaltsrechte: **"Nein, sie enthält und zeigt keine
Inhalte von Drittanbietern an."**

Grundlage: Die Zertifikatsfragen wurden per KI erzeugt, die IHK-Aufgaben sind
eigene Nachbildungen im Stil echter Prüfungen. Kein übernommenes fremdes
Material. Sollte sich das ändern — etwa durch lizenzierte Aufgabensammlungen
— muss die Antwort mitgeändert werden.

### Titel entschärft

Die fünf Prüfungen hießen `AE Prüfung 1 - Winter 2016/17` und so weiter. Das
liest sich, als sei es der Originalprüfungssatz dieses Termins. Neu:

| Datei | Titel |
|---|---|
| `lib/data/exams/ae-1.dart` | AE Übungsprüfung 1 |
| `lib/data/exams/ae-2.dart` | AE Übungsprüfung 2 |
| `lib/data/exams/ae-3.dart` | AE Übungsprüfung 3 |
| `lib/data/exams/si-1.dart` | SI Übungsprüfung 1 |
| `lib/data/exams/si-2.dart` | SI Übungsprüfung 2 |

Die Felder `year` und `season` bleiben unverändert, das Badge über der Karte
zeigt weiterhin "WINTER 2016" bzw. "SOMMER 2017". Die Einordnung bleibt also
sichtbar, ohne dass der Titel behauptet, es *sei* diese Prüfung.

### Zwei Hinweise ergänzt

**Herkunft** — erster Punkt in den "Wichtigen Hinweisen" der
Prüfungsdetailseite (`ihk_pruefung_detail_screen.dart`):

> Eigene Übungsaufgaben im Stil der IHK-Abschlussprüfung — keine
> Originalaufgaben der IHK

**Marken** — in der Infobox über der Zertifikatsliste
(`pruefen_screen.dart`):

> Unabhängige Übungsaufgaben, nicht von AWS, Microsoft, Google oder SAP
> autorisiert oder unterstützt.

Die Simulationen heißen "AWS Certified Cloud Practitioner", "Microsoft Azure
Fundamentals (AZ-900)", "Google Cloud Digital Leader" und "SAP Certified
Application Associate" — alles eingetragene Marken. Eine Marke zu **nennen**,
um zu sagen, worauf man vorbereitet, ist zulässig (nominative Nutzung). Der
Eindruck einer offiziellen Zusammenarbeit wäre es nicht. Genau diesen
Eindruck schließt der Satz aus. SAP und Microsoft reagieren darauf
erfahrungsgemäß empfindlicher als die IHK.

### Nebenbei korrigiert

Der Hinweis "Foto-Upload: Fotografiere Diagramme und lade sie hoch" war
falsch — es wird nichts hochgeladen, nur der Dateipfad landet in den
SharedPreferences. Jetzt: "Diagramme kannst du fotografieren und der Aufgabe
anhängen." Das deckt sich mit dem, was im Datenschutz-Fragebogen erklärt
wurde.

### Offener Punkt

Bei KI-generierten Aufgaben ist die fachliche Richtigkeit das eigene Risiko.
Wer eine falsche Antwort als richtig lernt, merkt es erst in der Prüfung. Der
"Fehler melden"-Dialog sollte in den Zertifikatstests gut sichtbar bleiben
und die Meldungen tatsächlich abgearbeitet werden.
