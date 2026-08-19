# tools/test-notify-signup.ps1
#
# Testet die Edge Function `notify-signup`, OHNE einen echten User anzulegen.
# Schickt eine erfundene Registrierung an die Function -> es sollte sofort
# eine Telegram-Nachricht ankommen.
#
# Aufruf:
#   powershell -ExecutionPolicy Bypass -File tools\test-notify-signup.ps1
#
# Das Secret wird abgefragt und NICHT im Skript gespeichert.

$ErrorActionPreference = "Stop"

$FunctionUrl = "https://ybvwjmaicoffitngtmzl.supabase.co/functions/v1/notify-signup"

Write-Host ""
Write-Host "Test: notify-signup" -ForegroundColor Cyan
Write-Host "URL: $FunctionUrl"
Write-Host ""

# --- Secret abfragen (verdeckt) ---------------------------------------------
$secure = Read-Host "NOTIFY_SIGNUP_SECRET" -AsSecureString
$secret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
)

if ([string]::IsNullOrWhiteSpace($secret)) {
    Write-Host "Kein Secret eingegeben. Abbruch." -ForegroundColor Red
    exit 1
}

# --- Testfall waehlen --------------------------------------------------------
Write-Host ""
Write-Host "  [1] Echte Registrierung (Standardfall)"
Write-Host "  [2] Gast-Account (anonym)"
Write-Host "  [3] Falsches Secret (muss 403 liefern)"
$wahl = Read-Host "Auswahl (Enter = 1)"
if ([string]::IsNullOrWhiteSpace($wahl)) { $wahl = "1" }

$istGast = ($wahl -eq "2")
if ($wahl -eq "3") { $secret = "absichtlich-falsch" }

$payload = @{
    user_id      = [guid]::NewGuid().ToString()
    email        = "testlauf@lernarena.app"
    provider     = "email"
    is_anonymous = $istGast
    created_at   = (Get-Date).ToUniversalTime().ToString("o")
    stats        = @{
        total   = 999
        today   = 7
        premium = 42
        active7 = 123
    }
} | ConvertTo-Json -Depth 5

# --- Absenden ----------------------------------------------------------------
Write-Host ""
Write-Host "Sende..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri $FunctionUrl `
        -Method Post `
        -ContentType "application/json" `
        -Headers @{ "x-signup-secret" = $secret } `
        -Body $payload `
        -UseBasicParsing

    Write-Host ""
    Write-Host "HTTP $($response.StatusCode)" -ForegroundColor Green
    Write-Host $response.Content
    Write-Host ""
    Write-Host "Wenn oben 200 / {`"ok`":true} steht: schau auf dein Telegram." -ForegroundColor Green
    Write-Host "Die Zahlen sind Fantasiewerte (999 / 7 / 42 / 123) - so erkennst du den Test." -ForegroundColor DarkGray
}
catch {
    $status = $null
    if ($_.Exception.Response) { $status = [int]$_.Exception.Response.StatusCode }

    Write-Host ""
    Write-Host "HTTP $status" -ForegroundColor Red

    if ($_.ErrorDetails.Message) { Write-Host $_.ErrorDetails.Message }
    else { Write-Host $_.Exception.Message }

    Write-Host ""
    switch ($status) {
        403 { Write-Host "403 = Secret stimmt nicht. Bei Testfall [3] ist das das GEWUENSCHTE Ergebnis." -ForegroundColor Yellow }
        500 { Write-Host "500 = Secrets fehlen in Supabase. Pruefen: supabase secrets list" -ForegroundColor Yellow }
        502 { Write-Host "502 = Telegram lehnt ab. Meist falsche TELEGRAM_ADMIN_CHAT_ID oder Bot nie angeschrieben." -ForegroundColor Yellow }
        401 { Write-Host "401 = Function verlangt JWT. Neu deployen mit --no-verify-jwt" -ForegroundColor Yellow }
        404 { Write-Host "404 = Function nicht deployed. supabase functions deploy notify-signup --no-verify-jwt" -ForegroundColor Yellow }
        default { Write-Host "Logs ansehen: Supabase Dashboard -> Edge Functions -> notify-signup -> Logs" -ForegroundColor Yellow }
    }
    exit 1
}

Write-Host ""
