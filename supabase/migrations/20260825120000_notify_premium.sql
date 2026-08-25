-- ============================================================================
-- Telegram-Benachrichtigung bei Premium-Kaeufen
-- ============================================================================
-- Trigger auf public.profiles -> pg_net -> Edge Function `notify-premium`.
-- Feuert NUR bei echter Neu-Aktivierung (is_premium wird true) oder bei
-- einem Planwechsel, NICHT bei jedem Auto-Restore beim App-Start (der
-- verlaengert nur premium_until, is_premium bleibt true).
--
-- Nutzt dasselbe Vault-Secret wie der Signup-Bot (notify_signup_secret),
-- es muss also nichts Neues angelegt werden.
-- Vorher deployen: supabase functions deploy notify-premium --no-verify-jwt
-- ============================================================================

create or replace function public.notify_premium_kauf()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, auth, vault
as $$
declare
  v_secret  text;
  v_email   text;
  v_premium integer;
begin
  -- Nur bei Neu-Aktivierung oder Planwechsel melden
  if not (
    (coalesce(old.is_premium, false) = false and new.is_premium is true)
    or (new.is_premium is true
        and new.premium_tier is distinct from old.premium_tier)
  ) then
    return new;
  end if;

  select decrypted_secret
    into v_secret
    from vault.decrypted_secrets
   where name = 'notify_signup_secret'
   limit 1;

  if v_secret is null then
    raise warning 'notify_premium_kauf: vault secret fehlt';
    return new;
  end if;

  select email into v_email from auth.users where id = new.id;

  select count(*) into v_premium
    from public.profiles
   where is_premium is true;

  perform net.http_post(
    url     := 'https://ybvwjmaicoffitngtmzl.supabase.co/functions/v1/notify-premium',
    headers := jsonb_build_object(
                 'Content-Type',    'application/json',
                 'x-signup-secret', v_secret
               ),
    body    := jsonb_build_object(
                 'email',         v_email,
                 'tier',          new.premium_tier,
                 'premium_until', new.premium_until,
                 'premium_count', v_premium
               ),
    timeout_milliseconds := 5000
  );

  return new;

exception when others then
  -- Eine kaputte Benachrichtigung darf NIEMALS die Premium-Freischaltung
  -- verhindern.
  raise warning 'notify_premium_kauf failed: %', sqlerrm;
  return new;
end;
$$;

comment on function public.notify_premium_kauf() is
  'Meldet Premium-Kaeufe per Telegram (Edge Function notify-premium).';

revoke all on function public.notify_premium_kauf() from public, anon, authenticated;

drop trigger if exists on_profile_premium_notify on public.profiles;

create trigger on_profile_premium_notify
  after update on public.profiles
  for each row
  execute function public.notify_premium_kauf();
