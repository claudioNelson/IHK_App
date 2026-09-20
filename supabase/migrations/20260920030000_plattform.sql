-- 2026-09-20: Plattform je Nutzer (Android / iOS / Web / Windows).
--
-- Wunsch: sehen, ueber welchen Store die Nutzer kommen. Bisher gab es dazu
-- nichts - auth.sessions.user_agent ist bei Flutter nur "Dart/3.x", die
-- Store-Transaktionen decken nur Kaeufer ab.
--
-- Zwei Quellen, beide ohne Raten:
--   1. Registrierung: App und Web schicken 'plattform' in den User-Metadaten
--      (auth.signUp data / signInAnonymously data / updateUser bei Gast-
--      Umwandlung). Der Signup-Trigger liest sie, schreibt sie ins Profil
--      und meldet sie per Telegram mit.
--   2. App-Start: SubscriptionService.load() schreibt profiles.plattform +
--      plattform_gesehen, sobald ein Nutzer die App (ab 1.7.1) oeffnet.
--      Damit werden auch ALTE Konten nach und nach zugeordnet.
--
-- Werte: 'android' | 'ios' | 'macos' | 'windows' | 'linux' | 'web'.
-- Auswertung (SQL-Editor):
--   select coalesce(plattform, 'unbekannt') as plattform, count(*)
--     from profiles p join auth.users u on u.id = p.id
--    where coalesce(u.is_anonymous, false) = false
--    group by 1 order by 2 desc;

begin;

alter table public.profiles
  add column if not exists plattform         text,
  add column if not exists plattform_gesehen timestamptz;

comment on column public.profiles.plattform         is 'Zuletzt genutzte Plattform: android, ios, macos, windows, linux, web (aus Signup-Metadaten oder App-Start).';
comment on column public.profiles.plattform_gesehen is 'Wann die Plattform zuletzt gemeldet wurde.';

-- Signup-Trigger: Plattform aus den Metadaten uebernehmen und mitmelden.
create or replace function public.notify_new_signup()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, auth, vault
as $$
declare
  v_total     integer;
  v_today     integer;
  v_premium   integer;
  v_active7   integer;
  v_secret    text;
  v_midnight  timestamptz;
  v_plattform text;
  v_verteilung jsonb;
begin
  -- ---------------------------------------------------------------- GAESTE --
  -- Gast-Accounts sollen aktuell MITgemeldet werden.
  -- Zum Abschalten einfach die naechste Zeile einkommentieren:
  -- if coalesce(new.is_anonymous, false) then return new; end if;
  -- --------------------------------------------------------------------------

  -- Plattform aus den Signup-Metadaten (App ab 1.7.1, Web ab Deploy).
  v_plattform := lower(nullif(trim(new.raw_user_meta_data ->> 'plattform'), ''));
  if v_plattform is not null then
    -- Profil existiert schon (handle_new_user laeuft vorher, gleiche Insert-
    -- Transaktion); falls nicht, schreibt die App es beim ersten Start.
    update public.profiles
       set plattform = v_plattform, plattform_gesehen = now()
     where id = new.id;
  end if;

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

  -- Verteilung nach Plattform (echte Accounts), z. B.
  -- {"android": 120, "ios": 15, "web": 30, "unbekannt": 200}
  select coalesce(jsonb_object_agg(k, n), '{}'::jsonb) into v_verteilung
    from (
      select coalesce(p.plattform, 'unbekannt') as k, count(*) as n
        from public.profiles p
        join auth.users u on u.id = p.id
       where coalesce(u.is_anonymous, false) = false
       group by 1
    ) t;

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
                 'plattform',    v_plattform,
                 'is_anonymous', coalesce(new.is_anonymous, false),
                 'created_at',   new.created_at,
                 'stats',        jsonb_build_object(
                                   'total',      v_total,
                                   'today',      v_today,
                                   'premium',    v_premium,
                                   'active7',    v_active7,
                                   'plattformen', v_verteilung
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

commit;

-- Kontrolle:
-- select column_name from information_schema.columns where table_name='profiles' and column_name like 'plattform%';
-- Danach: supabase functions deploy notify-signup --no-verify-jwt
