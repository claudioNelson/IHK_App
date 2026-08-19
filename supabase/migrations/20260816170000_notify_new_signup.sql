-- ============================================================================
-- Telegram-Benachrichtigung bei neuen Registrierungen
-- ============================================================================
-- Trigger auf auth.users -> berechnet die Nutzerzahlen -> schickt sie per
-- pg_net an die Edge Function `notify-signup`, die daraus eine Telegram-
-- Nachricht baut.
--
-- Gast-Accounts (anonym) werden ebenfalls gemeldet, aber in der Nachricht
-- klar als Gast markiert. Zum Abschalten: siehe Block "GAESTE" weiter unten.
--
-- WICHTIG — einmalig vorher ausfuehren (Secret liegt bewusst NICHT im Repo):
--   select vault.create_secret('DEIN_SECRET', 'notify_signup_secret');
-- Derselbe Wert muss als Supabase-Secret NOTIFY_SIGNUP_SECRET gesetzt sein.
-- ============================================================================

create extension if not exists pg_net with schema extensions;


create or replace function public.notify_new_signup()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, auth, vault
as $$
declare
  v_total    integer;
  v_today    integer;
  v_premium  integer;
  v_active7  integer;
  v_secret   text;
  v_midnight timestamptz;
begin
  -- ---------------------------------------------------------------- GAESTE --
  -- Gast-Accounts sollen aktuell MITgemeldet werden.
  -- Zum Abschalten einfach die naechste Zeile einkommentieren:
  -- if coalesce(new.is_anonymous, false) then return new; end if;
  -- --------------------------------------------------------------------------

  -- Shared Secret aus dem Supabase Vault holen
  select decrypted_secret
    into v_secret
    from vault.decrypted_secrets
   where name = 'notify_signup_secret'
   limit 1;

  if v_secret is null then
    raise warning 'notify_new_signup: vault secret "notify_signup_secret" fehlt';
    return new;
  end if;

  -- Mitternacht heute in deutscher Zeit
  v_midnight := ((now() at time zone 'Europe/Berlin')::date) at time zone 'Europe/Berlin';

  -- Kennzahlen (echte Accounts, ohne Gaeste)
  select count(*) into v_total
    from auth.users
   where coalesce(is_anonymous, false) = false;

  select count(*) into v_today
    from auth.users
   where coalesce(is_anonymous, false) = false
     and created_at >= v_midnight;

  select count(*) into v_active7
    from auth.users
   where coalesce(is_anonymous, false) = false
     and last_sign_in_at >= now() - interval '7 days';

  select count(*) into v_premium
    from public.profiles
   where is_premium is true;

  -- Ab an die Edge Function (asynchron, blockiert das Signup nicht)
  perform net.http_post(
    url     := 'https://ybvwjmaicoffitngtmzl.supabase.co/functions/v1/notify-signup',
    headers := jsonb_build_object(
                 'Content-Type',    'application/json',
                 'x-signup-secret', v_secret
               ),
    body    := jsonb_build_object(
                 'user_id',      new.id,
                 'email',        new.email,
                 'provider',     coalesce(new.raw_app_meta_data ->> 'provider', 'email'),
                 'is_anonymous', coalesce(new.is_anonymous, false),
                 'created_at',   new.created_at,
                 'stats',        jsonb_build_object(
                                   'total',   v_total,
                                   'today',   v_today,
                                   'premium', v_premium,
                                   'active7', v_active7
                                 )
               ),
    timeout_milliseconds := 5000
  );

  return new;

exception when others then
  -- Eine kaputte Benachrichtigung darf NIEMALS eine Registrierung verhindern.
  raise warning 'notify_new_signup failed: %', sqlerrm;
  return new;
end;
$$;

comment on function public.notify_new_signup() is
  'Meldet neue Registrierungen inkl. Nutzerzahlen per Telegram (Edge Function notify-signup).';

revoke all on function public.notify_new_signup() from public, anon, authenticated;


drop trigger if exists on_auth_user_created_notify on auth.users;

create trigger on_auth_user_created_notify
  after insert on auth.users
  for each row
  execute function public.notify_new_signup();
