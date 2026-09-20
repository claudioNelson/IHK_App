-- 2026-09-20: Telegram-Kaufmeldung mit Store, Preis, Angebot und
-- Testkauf-Kennzeichnung.
--
-- Bisher meldete notify_premium_kauf() nur E-Mail, Tier und Ablaufdatum -
-- der Preis im Text war der Listenpreis aus einer Tabelle in der Function,
-- unabhaengig davon, was wirklich gezahlt wurde (Aktion 5,99 statt 11,99),
-- und Sandbox-/Lizenztester-Kaeufe sahen aus wie echte Verkaeufe.
--
-- Loesung ohne App-Release: Die Edge Functions verify-purchase(-ios) rufen
-- claim_store_transaktion() VOR grant_premium_from_server() - dort landen
-- jetzt zusaetzlich Preis, Waehrung und Angebots-ID (Apple: price/currency/
-- offerType aus der signierten Transaktion; Google: offerId aus
-- offerDetails, Preis liefert die subscriptionsv2-API nicht). Der Trigger
-- liest beim Melden die juengste Zeile des Nutzers und schickt Store,
-- Umgebung, Preis und Angebot mit. Ohne Zeile (Stripe/Web) bleibt alles
-- leer und die Function zeigt "Web".
--
-- Signatur von claim_store_transaktion aendert sich (drei neue optionale
-- Parameter). Die alte 5-Parameter-Version wird entfernt, sonst waere ein
-- Aufruf mit fuenf benannten Parametern ueber PostgREST mehrdeutig; die
-- alten Function-Deployments passen durch die Defaults weiter.
--
-- Danach deployen:
--   supabase functions deploy verify-purchase
--   supabase functions deploy verify-purchase-ios
--   supabase functions deploy notify-premium --no-verify-jwt

begin;

alter table public.store_transaktionen
  add column if not exists preis    numeric(10,2),
  add column if not exists waehrung text,
  add column if not exists angebot  text;

comment on column public.store_transaktionen.preis    is 'Gezahlter Betrag der letzten bestaetigten Transaktion (Apple: aus dem JWS; Google: unbekannt).';
comment on column public.store_transaktionen.waehrung is 'ISO-Waehrung zum Preis, z. B. EUR.';
comment on column public.store_transaktionen.angebot  is 'Angebots-Kennung: Google offerId (z. B. endspurt-2026), Apple intro/promo:<id>/code.';

drop function if exists public.claim_store_transaktion(text, text, uuid, text, text);

create or replace function public.claim_store_transaktion(
  p_store text,
  p_transaktion text,
  p_user_id uuid,
  p_product_id text default null,
  p_environment text default null,
  p_preis numeric default null,
  p_waehrung text default null,
  p_angebot text default null
)
returns boolean
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_owner uuid;
begin
  select user_id into v_owner
    from public.store_transaktionen
   where store = p_store and transaktion = p_transaktion
   for update;

  if not found then
    insert into public.store_transaktionen
      (store, transaktion, user_id, product_id, environment, preis, waehrung, angebot)
    values
      (p_store, p_transaktion, p_user_id, p_product_id, p_environment, p_preis, p_waehrung, p_angebot);
    return true;
  end if;

  if v_owner = p_user_id then
    update public.store_transaktionen
       set last_seen   = now(),
           product_id  = coalesce(p_product_id, product_id),
           environment = coalesce(p_environment, environment),
           preis       = coalesce(p_preis, preis),
           waehrung    = coalesce(p_waehrung, waehrung),
           angebot     = coalesce(p_angebot, angebot)
     where store = p_store and transaktion = p_transaktion;
    return true;
  end if;

  -- Gebundenes Konto geloescht? Dann darf die Transaktion wandern.
  if not exists (select 1 from auth.users u where u.id = v_owner) then
    update public.store_transaktionen
       set user_id     = p_user_id,
           last_seen   = now(),
           product_id  = coalesce(p_product_id, product_id),
           environment = coalesce(p_environment, environment),
           preis       = coalesce(p_preis, preis),
           waehrung    = coalesce(p_waehrung, waehrung),
           angebot     = coalesce(p_angebot, angebot)
     where store = p_store and transaktion = p_transaktion;
    return true;
  end if;

  raise log 'claim_store_transaktion: % % gehoert %, Anfrage von % abgelehnt',
    p_store, p_transaktion, v_owner, p_user_id;
  return false;
end;
$$;

revoke execute on function public.claim_store_transaktion(text, text, uuid, text, text, numeric, text, text) from public, anon, authenticated;
grant  execute on function public.claim_store_transaktion(text, text, uuid, text, text, numeric, text, text) to service_role;

-- Trigger-Funktion: Store-Details mitschicken.
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
  v_tx      record;
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

  -- Juengste Store-Transaktion dieses Nutzers (von claim_store_transaktion
  -- unmittelbar vor der Freischaltung geschrieben). Fehlt bei Stripe/Web.
  select store, environment, product_id, preis, waehrung, angebot
    into v_tx
    from public.store_transaktionen
   where user_id = new.id
   order by last_seen desc
   limit 1;

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
                 'premium_count', v_premium,
                 'store',         v_tx.store,
                 'environment',   v_tx.environment,
                 'product_id',    v_tx.product_id,
                 'preis',         v_tx.preis,
                 'waehrung',      v_tx.waehrung,
                 'angebot',       v_tx.angebot
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

commit;

-- Kontrolle:
-- select proname, pg_get_function_identity_arguments(oid) from pg_proc where proname = 'claim_store_transaktion';
--   -> genau EINE Zeile mit 8 Parametern
-- select column_name from information_schema.columns where table_name='store_transaktionen' order by ordinal_position;
