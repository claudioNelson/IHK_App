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
