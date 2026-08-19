# tools/set-telegram-webhook.ps1
#
# Meldet die Edge Function `telegram-bot` als Webhook bei Telegram an.
# Ab dann landet jede Nachricht an den Bot direkt bei Supabase.
#
# Aufruf:
#   .\tools\set-telegram-webhook.ps1
#
# Bot-Token und Webhook-Secret werden abgefragt und NICHT gespeichert.

$ErrorActionPreference = "Stop"

$WebhookUrl = "https://ybvwjmaicoffitngtmzl.supabase.co/functions/v1/telegram-bot"

function Read-Geheim($Beschriftung) {
    $secure = Read-Host $Beschriftung -AsSecureString
    return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    )
}

Write-Host ""
Write-Host "Telegram-Webhook einrichten" -ForegroundColor Cyan
Write-Host "Ziel: $WebhookUrl"
Write-Host ""

$token = Read-Geheim "TELEGRAM_BOT_TOKEN"
if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Kein Token. Abbruch." -ForegroundColor Red; exit 1
}

$secret = Read-Geheim "TELEGRAM_WEBHOOK_SECRET"
if ([string]::IsNullOrWhiteSpace($secret)) {
    Write-Host "Kein Secret. Abbruch." -ForegroundColor Red; exit 1
}

# --- 1. Lebt der Bot ueberhaupt? --------------------------------------------
Write-Host ""
Write-Host "1/3  Bot pruefen..." -ForegroundColor Yellow
try {
    $me = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getMe" -UseBasicParsing
    Write-Host "     OK: @$($me.result.username)" -ForegroundColor Green
}
catch {
    Write-Host "     Token wird von Telegram abgelehnt." -ForegroundColor Red
    exit 1
}

# --- 2. Webhook setzen -------------------------------------------------------
Write-Host "2/3  Webhook setzen..." -ForegroundColor Yellow
$body = @{
    url             = $WebhookUrl
    secret_token    = $secret
    allowed_updates = @("message")
    max_connections = 10
} | ConvertTo-Json -Depth 3

$set = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/setWebhook" `
    -Method Post -ContentType "application/json" -Body $body -UseBasicParsing

if (-not $set.ok) {
    Write-Host "     Fehlgeschlagen: $($set.description)" -ForegroundColor Red
    exit 1
}
Write-Host "     OK: $($set.description)" -ForegroundColor Green

# --- 3. Gegenprobe -----------------------------------------------------------
Write-Host "3/3  Gegenprobe..." -ForegroundColor Yellow
$info = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getWebhookInfo" -UseBasicParsing

Write-Host ""
Write-Host "     URL              : $($info.result.url)"
Write-Host "     Ausstehend       : $($info.result.pending_update_count)"
if ($info.result.last_error_message) {
    Write-Host "     Letzter Fehler   : $($info.result.last_error_message)" -ForegroundColor Red
} else {
    Write-Host "     Letzter Fehler   : keiner" -ForegroundColor Green
}

Write-Host ""
Write-Host "Fertig. Schreib deinem Bot jetzt /stats" -ForegroundColor Green
Write-Host ""
Write-Host "Rueckgaengig machen (Webhook wieder entfernen):" -ForegroundColor DarkGray
Write-Host "  https://api.telegram.org/bot<TOKEN>/deleteWebhook" -ForegroundColor DarkGray
Write-Host ""
