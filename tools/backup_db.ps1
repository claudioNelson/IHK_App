# tools/backup_db.ps1 — Lernarena-Datenbank sichern (Schema + Daten)
#
# Einmalige Einrichtung:
#   1. Supabase Dashboard -> Projekt -> "Connect" -> Session pooler -> URI kopieren
#      (Form: postgresql://postgres.ybvwjmaicoffitngtmzl:[PASSWORT]@aws-0-eu-central-1.pooler.supabase.com:5432/postgres)
#   2. Passwort einsetzen und die komplette URI in diese Datei schreiben (liegt AUSSERHALB des Repos):
#        C:\Users\cnm89\backups\lernarena\.db_url.txt
#   3. pg_dump muss installiert sein (z. B. `scoop install postgresql` oder Supabase-CLI).
#
# Aufruf:  powershell -ExecutionPolicy Bypass -File tools\backup_db.ps1
# Ergebnis: C:\Users\cnm89\backups\lernarena\2026-09-02_1530_schema.sql und ..._data.sql
# Aeltere Backups: die letzten 12 bleiben, der Rest wird geloescht.

$ErrorActionPreference = "Stop"

$backupDir = Join-Path $HOME "backups\lernarena"
$urlFile   = Join-Path $backupDir ".db_url.txt"
$keep      = 12

if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
if (-not (Test-Path $urlFile)) {
    Write-Host "Fehlt: $urlFile  (siehe Kopf dieses Skripts)" -ForegroundColor Red
    exit 1
}
$dbUrl = (Get-Content $urlFile -Raw).Trim()

$stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$schemaFile = Join-Path $backupDir "${stamp}_schema.sql"
$dataFile   = Join-Path $backupDir "${stamp}_data.sql"

$pgDump = Get-Command pg_dump -ErrorAction SilentlyContinue
$supa   = Get-Command supabase -ErrorAction SilentlyContinue

if ($pgDump) {
    Write-Host "pg_dump: Schema ..."
    & pg_dump $dbUrl --schema=public --schema-only --no-owner --no-privileges -f $schemaFile
    Write-Host "pg_dump: Daten ..."
    & pg_dump $dbUrl --schema=public --data-only --no-owner --column-inserts -f $dataFile
}
elseif ($supa) {
    Write-Host "supabase db dump: Schema ..."
    & supabase db dump --db-url $dbUrl -f $schemaFile
    Write-Host "supabase db dump: Daten ..."
    & supabase db dump --db-url $dbUrl --data-only -f $dataFile
}
else {
    Write-Host "Weder pg_dump noch supabase-CLI gefunden. Installieren: scoop install postgresql" -ForegroundColor Red
    exit 1
}

if ($LASTEXITCODE -ne 0) { Write-Host "Dump fehlgeschlagen (Exit $LASTEXITCODE)" -ForegroundColor Red; exit 1 }

$s = (Get-Item $schemaFile).Length / 1KB
$d = (Get-Item $dataFile).Length / 1KB
Write-Host ("Fertig: {0} ({1:N0} KB), {2} ({3:N0} KB)" -f (Split-Path $schemaFile -Leaf), $s, (Split-Path $dataFile -Leaf), $d) -ForegroundColor Green

# Aufraeumen: nur die letzten $keep Paare behalten
Get-ChildItem $backupDir -Filter "*_data.sql" | Sort-Object Name -Descending | Select-Object -Skip $keep | ForEach-Object {
    $base = $_.Name -replace "_data\.sql$", ""
    Remove-Item (Join-Path $backupDir "${base}_data.sql") -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $backupDir "${base}_schema.sql") -ErrorAction SilentlyContinue
}
