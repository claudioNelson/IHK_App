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

### ✅ Schritt 3 — Codemagic-Signing eingerichtet (16.08.2026)

Im Repo lag **keine** `codemagic.yaml` — der erste (unsignierte) Build lief über den
Codemagic-Workflow-Editor (UI). Neu angelegt im Repo-Root, mit zwei Workflows:

**`ios-release` — iOS Release → TestFlight**

- Instanz `mac_mini_m2`, Flutter `stable`, Xcode `latest`
- Build-Kommando `flutter build ipa --release`
- Build-Nummer wird aus der letzten TestFlight-Nummer hochgezählt
- Publishing: `submit_to_testflight: true`, `submit_to_app_store: false`

> **⚠️ Kein `beta_groups:` im Publishing.** Das Feld gilt nur für **externe**
> Tester-Gruppen. Interne Gruppen wie `Internal Testers` bekommen jeden Build
> automatisch; die API antwortet sonst mit
> *„Builds cannot be assigned to this internal group."* und der Post-Processing-Schritt
> „App Store distribution" schlägt fehl — obwohl der Upload längst geklappt hat.
- Trigger: Git-Tags `ios-v*`; manueller Start jederzeit möglich

**`ios-unsigned`** — unsignierter Smoke-Build ohne Upload.

#### Code Signing — so läuft es wirklich

Automatisches Signing über den App Store Connect API Key, umgesetzt als
explizite Schritte im Workflow:

```
keychain initialize
app-store-connect fetch-signing-files "$BUNDLE_ID" --type IOS_APP_STORE --create
keychain add-certificates
xcode-project use-profiles
```

`--create` legt Distributionszertifikat und Provisioning-Profil bei Apple an,
falls sie fehlen.

> **⚠️ Kein `ios_signing:` im Workflow!** Das ist Codemagics *manueller* Signing-Weg.
> Er erwartet fertig hinterlegte Zertifikate und legt selbst nichts an. Zusammen mit
> `fetch-signing-files` ergibt das den Fehler
> *„No matching profiles found for bundle identifier app.lernarena and distribution
> type app_store"*. Am 16.08. genau daran gescheitert — nicht wieder einbauen.

**Konfiguration in Codemagic (einmalig):**

| Ort | Inhalt |
|---|---|
| Settings → Integrations → **Developer Portal** | Key „Lernarena API Key": Issuer ID, Key ID, `.p8`-Datei |
| App IHK_App → Environment variables | `CERTIFICATE_PRIVATE_KEY`, Group **`appstore_credentials`**, *Secure* |

`APP_STORE_APPLE_ID` (`6802045311`) und `BUNDLE_ID` stehen fest in der
`codemagic.yaml` — keine Secrets.

> **⚠️ Vorsicht bei der Apple-ID.** Die Zahl in der Browser-URL von App Store Connect
> (`/apps/6748392017/...`) war **nicht** die richtige. Maßgeblich ist die `Id` aus dem
> API-Objekt, die im Build-Log unter *„Find application entry from App Store Connect"*
> steht: **`6802045311`**. Mit der falschen ID findet
> `get-latest-testflight-build-number` nichts, fällt auf 0 zurück und vergibt beim
> zweiten Build erneut die Nummer 1 — Apple lehnt den Upload dann ab.

> **⚠️ Der RSA-Schlüssel darf keine Passphrase haben.** Zeile 2 mit
> `Proc-Type: 4,ENCRYPTED` → Codemagic bricht ab mit
> *„argument --certificate-key: Not a valid certificate private key"*.
> Erzeugen mit: `ssh-keygen -t rsa -b 2048 -m PEM -f ios_cert_key -N '""'`
> Immer denselben Schlüssel weiterverwenden — Apple begrenzt die Zahl aktiver
> Distributionszertifikate. Liegt in `Desktop\Lernarena\Apple` samt `LIESMICH.txt`.

Ein Prüfschritt „Signing-Voraussetzungen prüfen" im Workflow meldet fehlende
Variablen und verschlüsselte Schlüssel im Klartext, bevor der Build weiterläuft.

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
| Apple-ID (numerisch) | **`6802045311`** — steht fest in `codemagic.yaml`, kein Secret |
| Status | iOS 1.0 — In Vorbereitung zur Übermittlung |

### ✅ Schritt 8 — Erster signierter Build in TestFlight (16.08.2026)

Der Workflow `ios-release` läuft durch: Signing, IPA-Build, Upload nach App Store
Connect, Verarbeitung abgeschlossen. Distributionszertifikat und Provisioning-Profil
wurden automatisch bei Apple angelegt und werden ab jetzt wiederverwendet.

Build-UUID des ersten Uploads: `0c69473d-d242-4901-b838-11477b2cac41`

Der Post-Processing-Schritt meldete danach noch einen Fehler beim Zuweisen der
Tester-Gruppe (siehe `beta_groups`-Hinweis oben) — der Build selbst war zu dem
Zeitpunkt bereits erfolgreich in TestFlight.

### ⚠️ Testen ohne eigenes iPhone

TestFlight läuft nur auf iOS/iPadOS — es gibt keine Windows- oder Web-Variante.
Zum Installieren wird ein echtes Gerät gebraucht. Möglichkeiten:

- Person mit iPhone in App Store Connect → *Users and Access* einladen (Rolle
  „Developer" genügt), dann als internen Tester hinzufügen. Bis zu 100 Personen,
  keine Prüfung durch Apple nötig.
- Codemagic **App Preview** für einen groben Funktionscheck im Browser — ersetzt aber
  kein echtes Gerät (Kamera, Deep Links, Sounds verhalten sich anders).

Mindestens ein Durchlauf auf echtem Gerät vor dem Store-Release ist dringend zu
empfehlen: die App nutzt Kamera, Deep Links für den Passwort-Reset und Audio.

### ⬜ Offen

1. **Build in TestFlight prüfen** — Verarbeitung abwarten, dann auf dem iPhone über die
   TestFlight-App installieren und testen.
2. **Händlerstatus (EU Digital Services Act)** — App Store Connect zeigt dafür einen
   Banner. Ohne Händlerstatus dürfen neue Apps nicht in der EU veröffentlicht werden.
   Muss vom Accountinhaber ausgefüllt werden; die Angaben (Name, Adresse, Kontakt)
   erscheinen später öffentlich im App-Store-Eintrag.
   Für TestFlight mit **internen** Testern noch nicht nötig.

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

*Zuletzt aktualisiert: 16.08.2026 — Build in TestFlight; Apple-ID korrigiert, beta_groups entfernt*

---

## Wichtig: `codemagic.yaml` muss ins Repo

Codemagic liest die Workflow-Definition **aus dem Repository**, nicht aus dem lokalen
Ordner. Solange `codemagic.yaml` nicht committet und gepusht ist, erscheinen die
Workflows `ios-release` / `ios-unsigned` in Codemagic nicht und die Umstellung von
„Workflow Editor" auf „codemagic.yaml" bleibt wirkungslos.

Vor dem ersten signierten Build also committen und pushen — die Datei enthält
bewusst keine Secrets, nur Referenzen auf Codemagic-Variablen.
