<#  Update-ProjectState.ps1  (PowerShell 5.1)
    Erzeugt/aktualisiert PROJECT_STATE.md mit Repo-/Projektstatus.
    Voraussetzung: Git ist im PATH.
#>

param(
  [string]$Output = "PROJECT_STATE.md"
)

# --- Git Runner ---
function Run-Git([string]$ArgsLine) {
  try {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "git"
    $psi.Arguments = $ArgsLine
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow  = $true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi
    [void]$p.Start()
    $out = $p.StandardOutput.ReadToEnd()
    $p.WaitForExit()
    if ($p.ExitCode -ne 0) { return "" }
    return ($out -replace "`r","").TrimEnd()
  } catch { return "" }
}

# --- Repo prüfen ---
$repoRoot = Run-Git "rev-parse --show-toplevel"
if (-not $repoRoot) {
  Write-Host "⚠️  Kein Git-Repo erkannt. Bitte im Repo-Ordner ausführen." -ForegroundColor Yellow
  exit 1
}
Set-Location $repoRoot

# --- Git Infos ---
$branch     = Run-Git "rev-parse --abbrev-ref HEAD"
$remoteUrl  = Run-Git "config --get remote.origin.url"
$lastCommit = Run-Git 'log -1 --pretty=format:"%h | %ad | %an | %s" --date=iso'
$pending    = Run-Git "status --porcelain=v1"

# --- Flutter / Dart ---
$pubspecPath = Join-Path $repoRoot "pubspec.yaml"
$pubspec = ""
if (Test-Path $pubspecPath) { $pubspec = Get-Content $pubspecPath -Raw }

# --- Pfad-Helfer (PS5.1-sicher) ---
function Get-RelativePath([string]$BasePath, [string]$FullPath) {
  $base = New-Object System.Uri(($BasePath.TrimEnd('\') + '\'))
  $full = New-Object System.Uri($FullPath)
  $rel  = $base.MakeRelativeUri($full).ToString()  # bereits mit '/'
  return ($rel -replace '%20',' ')
}
function To-Rel([string]$p) { Get-RelativePath $repoRoot $p }

# --- Dateien sammeln ---
$libFiles = @()
$libPath = Join-Path $repoRoot "lib"
if (Test-Path $libPath) {
  $libFiles = Get-ChildItem -Path $libPath -Recurse -File -Filter *.dart -ErrorAction SilentlyContinue |
              ForEach-Object { To-Rel $_.FullName }
}
$csvFiles = Get-ChildItem -Path $repoRoot -Recurse -File -Filter *.csv -ErrorAction SilentlyContinue |
            ForEach-Object { To-Rel $_.FullName }
$sqlFiles = Get-ChildItem -Path $repoRoot -Recurse -File -Filter *.sql -ErrorAction SilentlyContinue |
            ForEach-Object { To-Rel $_.FullName }

# --- Zeitstempel & Hinweise ---
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$moduleHinweis = @'
- **Modul „Rechnungswesen“** (ID 9001) vorbereitet:
  - Themen: 9101–9105 (Buchführung, Bilanz & GuV, Kostenrechnung, Steuern, Controlling)
  - CSVs: `module_rechnungswesen.csv`, `themen_rechnungswesen.csv`,
          `fragen_rechnungswesen.csv`, `antworten_rechnungswesen.csv`
- Import-Reihenfolge: **module → themen → fragen → antworten**
- DB-Schema kompatibel zur Flutter-App (Tabellen: module, themen, fragen, antworten)
'@

# --- Markdown Builder (keine Backticks/Formatoperator in problematischen Strings) ---
$nl = [Environment]::NewLine
$sb = New-Object System.Text.StringBuilder

# Header
[void]$sb.AppendLine('# Projektstatus')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('Erzeugt: **' + $now + '**  ')
[void]$sb.AppendLine('Repo: **' + $repoRoot + '**  ')
[void]$sb.AppendLine('Branch: **' + $branch + '**')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('---')
[void]$sb.AppendLine('')

# Git-Abschnitt
[void]$sb.AppendLine('**Remote**')
[void]$sb.AppendLine($remoteUrl)
[void]$sb.AppendLine('')
[void]$sb.AppendLine('**Letzter Commit**')
[void]$sb.AppendLine($lastCommit)
[void]$sb.AppendLine('')

# Offene Änderungen
[void]$sb.AppendLine('**Offene Änderungen**')
if ([string]::IsNullOrWhiteSpace($pending)) {
  [void]$sb.AppendLine('- (none)')
} else {
  # Als Codeblock ausgeben, damit Sonderzeichen sicher sind
  [void]$sb.AppendLine('```')
  [void]$sb.AppendLine($pending)
  [void]$sb.AppendLine('```')
}
[void]$sb.AppendLine('')

# pubspec.yaml
if (-not [string]::IsNullOrWhiteSpace($pubspec)) {
  [void]$sb.AppendLine('**pubspec.yaml**')
  [void]$sb.AppendLine('```yaml')
  [void]$sb.Append($pubspec)
  [void]$sb.AppendLine('```')
  [void]$sb.AppendLine('')
} else {
  [void]$sb.AppendLine('**pubspec.yaml**')
  [void]$sb.AppendLine('- (nicht gefunden)')
  [void]$sb.AppendLine('')
}

# Listenfunktion (Backticks nur in Single Quotes)
function Add-MDList([System.Text.StringBuilder]$builder, $title, $arr) {
  [void]$builder.AppendLine($title)
  if (-not $arr -or $arr.Count -eq 0) {
    [void]$builder.AppendLine('- (none)')
  } else {
    foreach ($item in $arr) {
      [void]$builder.AppendLine('- `' + $item + '`')
    }
  }
  [void]$builder.AppendLine('')
}

Add-MDList -builder $sb -title '**Dart-Dateien (lib/)**' -arr $libFiles
Add-MDList -builder $sb -title '**CSV-Dateien**'         -arr $csvFiles
Add-MDList -builder $sb -title '**SQL-Dateien**'         -arr $sqlFiles

# Hinweise
[void]$sb.AppendLine('---')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('## Hinweise / Nächste Schritte')
[void]$sb.AppendLine('')
[void]$sb.AppendLine($moduleHinweis)

$mdText = $sb.ToString()

# --- Schreiben ---
try {
  $outPath = Join-Path $repoRoot $Output
  $mdText | Out-File -FilePath $outPath -Encoding UTF8
  Write-Host ('✅ {0} wurde erstellt/aktualisiert: {1}' -f $Output, $outPath) -ForegroundColor Green
} catch {
  Write-Host ('❌ Konnte {0} nicht schreiben: {1}' -f $Output, $_.Exception.Message) -ForegroundColor Red
  exit 1
}
