-- ============================================================================
-- Nutzerzahlen auf Abruf
-- ============================================================================
-- 1) public.admin_user_stats() — eine einzige Quelle fuer alle Kennzahlen.
--    Wird sowohl vom Signup-Trigger als auch vom Telegram-Befehl /stats genutzt.
-- 2) notify_new_signup() wird darauf umgestellt, damit die Zahlen nicht an
--    zwei Stellen gepflegt werden muessen.
--
-- Die Funktion ist SECURITY DEFINER (sie liest auth.users) und darf deshalb
-- NUR von service_role aufgerufen werden — nicht von anon oder authenticated.
-- ============================================================================

create or replace function public.admin_user_stats()
returns jsonb
language sql
security definer
set search_path = public, auth
as $$
  select jsonb_build_object(
    -- echte Accounts (ohne Gaeste)
    'total',   (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = false),

    'today',   (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = false
                   and created_at >= ((now() at time zone 'Europe/Berlin')::date)
                                      at time zone 'Europe/Berlin'),

    'week',    (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = false
                   and created_at >= now() - interval '7 days'),

    'active7', (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = false
                   and last_sign_in_at >= now() - interval '7 days'),

    'active30',(select count(*) from auth.users
                 where coalesce(is_anonymous, false) = false
                   and last_sign_in_at >= now() - interval '30 days'),

    'premium', (select count(*) from public.profiles
                 where is_premium is true),

    -- Gast-Accounts (anonym), die gerade existieren
    'guests',  (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = true),

    'last_signup', (select max(created_at) from auth.users
                     where coalesce(is_anonymous, false) = false)
  );
$$;

comment on function public.admin_user_stats() is
  'Nutzerkennzahlen fuer Telegram (/stats) und den Signup-Trigger. Nur service_role.';

revoke all     on function public.admin_user_stats() from public, anon, authenticated;
grant  execute on function public.admin_user_stats() to service_role;


-- ---------------------------------------------------------------------------
-- Signup-Trigger auf die gemeinsame Funktion umstellen
-- ---------------------------------------------------------------------------
create or replace function public.notify_new_signup()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, auth, vault
as $$
declare
  v_secret text;
  v_stats  jsonb;
begin
  -- ---------------------------------------------------------------- GAESTE --
  -- Gast-Accounts werden MITgemeldet. Zum Abschalten Zeile einkommentieren:
  -- if coalesce(new.is_anonymous, false) then return new; end if;
  -- --------------------------------------------------------------------------

  select decrypted_secret
    into v_secret
    from vault.decrypted_secrets
   where name = 'notify_signup_secret'
   limit 1;

  if v_secret is null then
    raise warning 'notify_new_signup: vault secret "notify_signup_secret" fehlt';
    return new;
  end if;

  v_stats := public.admin_user_stats();

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
                 'stats',        v_stats
               ),
    timeout_milliseconds := 5000
  );

  return new;

exception when others then
  raise warning 'notify_new_signup failed: %', sqlerrm;
  return new;
end;
$$;
