# Projektstatus — Lernarena

**Stand:** 2026-08-16
**Repo:** `C:/Users/cnm89/Desktop/Lernarena/ihk_app`
**Remote:** https://github.com/claudioNelson/ihk_app.git
**Apple Team ID:** `C4S4889PBN`
**Produkt:** Lernarena — IHK-Prüfungsvorbereitung für Fachinformatiker:innen (AE & SI)
**Domain:** lernarena.app · **Kontakt:** info@lernarena.app

---

## Plattform-Übersicht

| Plattform | Bundle/Package-ID | Status |
|---|---|---|
| Android (Flutter) | `app.lernarena` | Live / Play Store |
| iOS (Flutter) | `app.lernarena` | **In Vorbereitung → TestFlight** |
| Web (Next.js, Vercel) | — | Live |
| Backend | Supabase (PostgreSQL + RLS, Auth, Edge Functions) | Live |

---

## App Store Release (iOS)

### ✅ Schritt 1 — Apple Developer Account (16.08.2026)
Der Apple Developer Account ist seit dem **16.08.2026 AKTIV**.

### ✅ Schritt 2 — Lokaler iOS-Stand verifiziert (16.08.2026)

| Prüfpunkt | Vorher | Jetzt |
|---|---|---|
| `PRODUCT_BUNDLE_IDENTIFIER` (project.pbxproj) | `app.lernarena` ✅ | unverändert ✅ |
| `CFBundleDisplayName` (Info.plist) | ❌ `Ihk App` | ✅ `Lernarena` |
| `CFBundleName` (Info.plist) | ❌ `ihk_app` | ✅ `Lernarena` |
| iOS App-Icons (Assets.xcassets) | ❌ Flutter-Default (blaues Logo) | ✅ Lernarena-Icon, 15 Größen |
| Alpha-Kanal / runde Ecken im Icon | ❌ schwarze Ecken im Quell-PNG | ✅ vollflächig, RGB ohne Alpha |

Hinweise:
- `RunnerTests` nutzt korrekt `app.lernarena.RunnerTests`.
- In `pubspec.yaml` stand `flutter_launcher_icons: ios: false` — deshalb waren nur die
  Android-Icons erzeugt. Jetzt auf `ios: true` + `remove_alpha_ios: true` umgestellt.
- Neues, für iOS bereinigtes Quellbild: `assets/icon/app_icon_ios.png`
  (1254×1254, RGB, keine eigenen runden Ecken — iOS legt die Maske selbst an).

> **⚠️ Stolperfalle — nicht vergessen:** `assets/icon/app_icon.png` hat **schwarze**
> abgerundete Ecken (kein Alpha, echtes Schwarz). iOS legt seine Maske selbst an, das
> ergibt schwarze Ränder im fertigen Icon. Deshalb steht in `pubspec.yaml` zwingend
> `image_path_ios: "assets/icon/app_icon_ios.png"`.
> Am 16.08. ist diese Zeile bei einer Wiederherstellung des Arbeitsverzeichnisses
> verlorengegangen; der anschließende Lauf von `flutter_launcher_icons` hat alle 15
> Icons wieder aus der falschen Quelle erzeugt (dunkelster Pixelwert 0 = pechschwarze
> Ecken). Wurde korrigiert. **`flutter pub run flutter_launcher_icons` nie ohne
> `image_path_ios` ausführen.**

### ✅ Schritt 3 — Codemagic-Signing vorbereitet (16.08.2026)

Im Repo lag **keine** `codemagic.yaml` — der erste (unsignierte) Build lief über den
Codemagic-Workflow-Editor (UI). Neu angelegt: **`codemagic.yaml`** im Repo-Root mit
zwei Workflows.

**Workflow `ios-release` (iOS Release → TestFlight)**

- Instanz: `mac_mini_m2`, Flutter `stable`, Xcode `latest`
- Automatisches Code Signing über **App Store Connect API Key**
  (`ios_signing: distribution_type: app_store`, `bundle_identifier: app.lernarena`)
- Build-Nummer wird automatisch aus der letzten TestFlight-Build-Nummer hochgezählt
- Build-Kommando: `flutter build ipa --release`
- Publishing: **TestFlight-Upload aktiv** (`submit_to_testflight: true`),
  `submit_to_app_store: false` (bewusst noch aus)
- Trigger: Git-Tags nach dem Muster `ios-v*`
- E-Mail-Benachrichtigung an info@lernarena.app

**Workflow `ios-unsigned`** — unsignierter Smoke-Build ohne Upload (wie bisher).

**Secrets — NICHT im Repo, und keine Variablengruppe nötig.**
Die Datei nutzt `auth: integration`. Damit stellt die App Store Connect **Integration**
die Variablen `APP_STORE_CONNECT_ISSUER_ID`, `_KEY_IDENTIFIER` und `_PRIVATE_KEY`
automatisch im Build bereit. Eine zusätzliche Variablengruppe `appstore_credentials`
wäre nicht nur überflüssig, sondern würde den Build fehlschlagen lassen, wenn sie
nicht existiert — sie wurde am 16.08. wieder entfernt.

Einmalig in Codemagic einzutragen:
**Settings → Integrations → App Store Connect → Add key**, Name exakt
**`Lernarena API Key`**, dazu Issuer ID, Key ID und die `.p8`-Datei.

`APP_STORE_APPLE_ID` (`6748392017`) steht fest in der `codemagic.yaml` — kein Secret.

Danach die App in Codemagic (heißt dort **IHK_App**) von „Workflow Editor" auf
**„codemagic.yaml"** umstellen.

### ✅ Schritt 4 — Info.plist auf App-Store-Pflichtangaben geprüft (16.08.2026)

| Key | Wert | Grund |
|---|---|---|
| `ITSAppUsesNonExemptEncryption` | `false` | nur Standard-HTTPS/TLS — spart den Export-Compliance-Dialog bei jedem TestFlight-Build |
| `NSCameraUsageDescription` | gesetzt (DE) | `lib/widgets/photo_upload_widget.dart` nutzt `ImageSource.camera` — ohne Text: Crash + Reject |
| `NSPhotoLibraryUsageDescription` | gesetzt (DE) | dasselbe Widget nutzt `ImageSource.gallery` |
| `CFBundleURLTypes` → `app.lernarena` | neu ergänzt | Deep Links (Passwort-Reset / E-Mail-Bestätigung über Supabase) — `deep_link_service.dart` erwartet dieses Scheme; fehlte auf iOS komplett |
| `CFBundleLocalizations` | `["de"]` | App-Inhalte sind deutsch |

Nicht ergänzt (bewusst): Mikrofon, Standort, Kontakte, Tracking — werden von der App
nicht genutzt. **Sign in with Apple wird nicht benötigt**: die App hat ausschließlich
E-Mail/Passwort-Login, keine Social-Logins (Apple verlangt Sign in with Apple nur,
wenn andere Drittanbieter-Logins angeboten werden).

### ✅ Schritt 5 — App-ID bei Apple registriert (16.08.2026)

Im Apple Developer Portal unter Identifiers angelegt:

| Feld | Wert |
|---|---|
| Description | Lernarena |
| Bundle ID | **Explicit** `app.lernarena` |
| App ID Prefix / Team ID | `C4S4889PBN` |
| Capabilities | **keine aktiviert** — bewusst, die App braucht keine |

### ✅ Schritt 6 — App Store Connect API Key erzeugt (16.08.2026)

Team Key mit Rolle **App Manager**, Name „Codemagic Lernarena". Die `.p8`-Datei liegt
lokal außerhalb des Repos (nur einmal herunterladbar). Issuer ID, Key ID und Private Key
gehen ausschließlich nach Codemagic — **nie ins Repo, nie in einen Chat.**

### ✅ Schritt 7 — App in App Store Connect angelegt (16.08.2026)

| Feld | Wert |
|---|---|
| App-Name (Store) | **Lernarena: Fachinformatiker** (27 von 30 Zeichen) |
| Anzeigename (Homescreen) | **Lernarena** (aus `CFBundleDisplayName`) |
| Plattform | iOS |
| Primärsprache | Deutsch |
| Bundle-ID | `app.lernarena` |
| SKU | `LERNARENA-IOS-001` |
| Apple-ID (numerisch) | **`6748392017`** — steht fest in `codemagic.yaml`, kein Secret |
| Status | iOS 1.0 — In Vorbereitung zur Übermittlung |

### ⬜ Offen — muss bei Apple / App Store Connect erledigt werden

1. **Codemagic konfigurieren** — Settings → Integrations → App Store Connect →
   Add key, Name exakt `Lernarena API Key` (Issuer ID, Key ID, `.p8`).
   Danach App **IHK_App** von „Workflow Editor" auf **`codemagic.yaml`** umstellen.
   Keine Variablengruppe nötig.
2. **Interne Tester-Gruppe „Internal Testers"** in App Store Connect → TestFlight anlegen
   (der Workflow referenziert sie unter `beta_groups`).
3. **Händlerstatus (EU Digital Services Act)** — App Store Connect zeigt dafür einen
   Banner. Ohne Händlerstatus dürfen neue Apps nicht in der EU veröffentlicht werden.
   Muss vom Accountinhaber ausgefüllt werden; die Angaben (Name, Adresse, Kontakt)
   erscheinen später öffentlich im App-Store-Eintrag.
   Für TestFlight mit **internen** Testern noch nicht nötig.
4. Danach: Tag `ios-v1.0.0` pushen → Build läuft → TestFlight.

### ⬜ Später (vor dem öffentlichen Store-Release)
- App-Store-Screenshots (iPhone 6.7" und 6.5" Pflicht), Beschreibung, Keywords
- Datenschutz-Angaben („App Privacy" / Nutrition Label) — Supabase-Auth, Fotos, KI-Tutor
- Altersfreigabe, Kategorie, Support- und Datenschutz-URL (lernarena.app)
- `submit_to_app_store: true` in `codemagic.yaml` setzen

---

### ⚠️ Wichtig für später — In-App-Purchase / Richtlinie 3.1.1

`lib/widgets/premium_lock.dart` (Preise „Ab 9,99€/M · 59€/J · 99€ Lifetime") und
`lib/widgets/limit_reached_dialog.dart` existieren, werden aber **aktuell nirgends
verwendet** — im gesamten `lib/` gibt es keinen `launchUrl`-Aufruf und keinen Kauf-Flow.
Bezahlt wird nur in der Web-App über Stripe. Für den ersten TestFlight-Build ist das
unkritisch.

**Sobald die Paywall in der iOS-App aktiviert wird:** Apple verlangt für digitale Inhalte
zwingend native **In-App-Purchases** (App Store Review Guideline 3.1.1). Stripe-Checkout
in der App oder ein Link nach außen zum Kaufen führt zum Reject. Dann nötig:
`in_app_purchase`-Paket, Produkte in App Store Connect anlegen, Capability
„In-App Purchase" in der App-ID aktivieren, und `subscription_service.dart` muss beide
Quellen (Stripe für Web, StoreKit für iOS) zusammenführen.
Auf Android gilt dasselbe über Google Play Billing.

---

## Technischer Stand (Flutter-App)

- **Framework:** Flutter (stable, Dart 3.8), State-Management: Provider
- **Version:** `1.2.0+9` (pubspec)
- **Backend:** `supabase_flutter`, Auth per E-Mail/Passwort, RLS auf Nutzer-Tabellen
- **Wichtige Pakete:** `image_picker`, `audioplayers`, `confetti`, `google_fonts`,
  `url_launcher`, `app_links` (Deep Links), `google_generative_ai` (KI-Tutor),
  `flutter_highlight` / `flutter_markdown_plus`, `flutter_dotenv`
- **Struktur:** `lib/screens` (auth, learning, levels, module, pruefen, simulation,
  zertifikate, profile, legal, onboarding), `lib/services` (22 Services),
  `lib/widgets` (Fragetypen, Dialoge, Navigation), `lib/data` (Prüfungen AE 1–3, SI 1–2)

---

## Bekannte offene Punkte / Aufräumen

- `lib/main.dart.BACKUP` und `lib/main.dart.BACKUP_20251128` (je 185 KB) liegen noch im
  Repo — sollten gelöscht oder in `backups/` verschoben werden.
- `keys.txt` und `.env` liegen im Projektordner — prüfen, dass beide in `.gitignore`
  stehen und nie committet wurden.
- `README.md` ist UTF-16-kodiert und beschreibt nur Android als mobile Plattform —
  auf UTF-8 umstellen und iOS ergänzen.
- `Update-ProjectState.ps1` überschreibt diese Datei mit einem generierten Kurzstatus —
  vor dem nächsten Lauf anpassen, sonst geht der Release-Abschnitt oben verloren.

---

*Zuletzt aktualisiert: 16.08.2026 — Icon-Regression behoben, Version auf 1.2.0+9 korrigiert*

---

## Wichtig: `codemagic.yaml` muss ins Repo

Codemagic liest die Workflow-Definition **aus dem Repository**, nicht aus dem lokalen
Ordner. Solange `codemagic.yaml` nicht committet und gepusht ist, erscheinen die
Workflows `ios-release` / `ios-unsigned` in Codemagic nicht und die Umstellung von
„Workflow Editor" auf „codemagic.yaml" bleibt wirkungslos.

Vor dem ersten signierten Build also committen und pushen — die Datei enthält
bewusst keine Secrets, nur Referenzen auf Codemagic-Variablen.
