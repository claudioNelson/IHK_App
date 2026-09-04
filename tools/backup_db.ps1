# tools/backup_db.ps1 — Lernarena-Datenbank sichern (alle Tabellen in public als CSV)
#
# Weg: Supabase REST-API (PostgREST) mit dem Service-Role-Key. Braucht KEIN
# Datenbank-Passwort und keinen Pooler. Sichert Inhalte (Daten), nicht das Schema;
# das Schema liegt in supabase/migrations/ und in claude/datenbank.md.
#
# Einmalige Einrichtung:
#   Supabase Dashboard -> Project Settings -> API Keys -> Reiter "Legacy anon, service_role"
#   -> service_role (eyJ...)  ODER  Reiter "Publishable and secret" -> Secret key (sb_secret_...)
#   Den Key als einzige Zeile speichern in (AUSSERHALB des Repos):
#       C:\Users\cnm89\backups\lernarena\service_role.txt
#   Dieser Key umgeht RLS -> niemals in den Chat, ins Repo oder in die App.
#
# Aufruf:  powershell -ExecutionPolicy Bypass -File tools\backup_db.ps1
# Ergebnis: C:\Users\cnm89\backups\lernarena\2026-09-04_1530\<tabelle>.csv (+ _info.txt)
# Aeltere Backups: die letzten 12 Ordner bleiben.

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$projectRef = "ybvwjmaicoffitngtmzl"
$baseUrl    = "https://$projectRef.supabase.co/rest/v1"
$backupRoot = Join-Path $HOME "backups\lernarena"
$keyFile    = Join-Path $backupRoot "service_role.txt"
$keep       = 12
$pageSize   = 1000

if (-not (Test-Path $backupRoot)) { New-Item -ItemType Directory -Path $backupRoot | Out-Null }
if (-not (Test-Path $keyFile)) { Write-Host "Fehlt: $keyFile  (siehe Kopf dieses Skripts)" -ForegroundColor Red; exit 1 }
$key = (Get-Content $keyFile -Raw).Trim()
if ($key.Length -lt 40) { Write-Host "service_role.txt sieht nicht nach einem Key aus (zu kurz)" -ForegroundColor Red; exit 1 }

# Legacy service_role-Key (eyJ...) braucht apikey + Authorization; neuer sb_secret_-Key nur apikey
if ($key.StartsWith("sb_secret_")) { $headers = @{ "apikey" = $key } }
else { $headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" } }

# Tabellenliste aus der OpenAPI-Beschreibung von PostgREST
try {
    $spec = Invoke-RestMethod -Uri "$baseUrl/" -Headers $headers -Method Get
} catch {
    Write-Host "API nicht erreichbar oder Key ungueltig: $($_.Exception.Message)" -ForegroundColor Red; exit 1
}
$tables = @($spec.definitions.PSObject.Properties.Name | Sort-Object)
if ($tables.Count -eq 0) { Write-Host "Keine Tabellen gefunden" -ForegroundColor Red; exit 1 }

$stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$outDir = Join-Path $backupRoot $stamp
New-Item -ItemType Directory -Path $outDir | Out-Null

$summary = @()
foreach ($t in $tables) {
    $file = Join-Path $outDir "$t.csv"
    $offset = 0; $rows = 0; $first = $true; $ok = $true
    while ($true) {
        $h = $headers.Clone()
        $h["Accept"] = "text/csv"
        # Seitenweise per limit/offset (Range-Header ist in Windows PowerShell 5.1 gesperrt)
        $uri = "$baseUrl/${t}?select=*&limit=${pageSize}&offset=${offset}"
        try {
            $resp = Invoke-WebRequest -Uri $uri -Headers $h -Method Get -UseBasicParsing
        } catch {
            Write-Host ("  {0}: FEHLER {1}" -f $t, $_.Exception.Message) -ForegroundColor Yellow
            $ok = $false; break
        }
        $body = $resp.Content
        if ([string]::IsNullOrWhiteSpace($body)) { break }
        $lines = $body -split "`r?`n" | Where-Object { $_ -ne "" }
        if ($first) {
            [IO.File]::WriteAllText($file, ($lines -join "`n") + "`n", [Text.UTF8Encoding]::new($false))
            $chunk = $lines.Count - 1
            $first = $false
        } else {
            $data = $lines | Select-Object -Skip 1
            if ($data.Count -gt 0) { [IO.File]::AppendAllText($file, ($data -join "`n") + "`n", [Text.UTF8Encoding]::new($false)) }
            $chunk = $data.Count
        }
        $rows += $chunk
        if ($chunk -lt $pageSize) { break }
        $offset += $pageSize
    }
    if ($first -and $ok) { [IO.File]::WriteAllText($file, "", [Text.UTF8Encoding]::new($false)) }
    $summary += ("{0,-28} {1,7} Zeilen{2}" -f $t, $rows, $(if ($ok) { "" } else { "  (FEHLER)" }))
    Write-Host ("  {0,-28} {1,7}" -f $t, $rows)
}

$info = @("Lernarena Backup $stamp", "Projekt: $projectRef", "Weg: REST-API (service_role), CSV je Tabelle", "") + $summary
[IO.File]::WriteAllLines((Join-Path $outDir "_info.txt"), $info, [Text.UTF8Encoding]::new($false))

$size = (Get-ChildItem $outDir | Measure-Object Length -Sum).Sum / 1KB
Write-Host ("Fertig: {0} Tabellen, {1:N0} KB -> {2}" -f $tables.Count, $size, $outDir) -ForegroundColor Green

# Aufraeumen: nur die letzten $keep Backup-Ordner behalten
Get-ChildItem $backupRoot -Directory | Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}_\d{4}$' } |
    Sort-Object Name -Descending | Select-Object -Skip $keep | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
