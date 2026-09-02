-- 20260902130000_premium_ddl_ins_repo.sql
--
-- Zweck: DDL, das bisher ausschliesslich per Supabase-SQL-Editor in der
--        Live-Datenbank angelegt wurde, ins Repo holen. Damit ist der
--        Premium-Stack (RPCs, Schutz-Trigger, Rechte) reproduzierbar.
--
-- Stand: 02.09.2026 (aus pg_get_functiondef / pg_get_triggerdef rekonstruiert,
--        per Lese-Agent; Signaturen gegen pg_proc geprueft)
--
-- NOCH NICHT AUF DIE LIVE-DB ANGEWENDET. Vor dem Einspielen im SQL-Editor
-- pruefen (siehe Kontrollabfrage am Ende).
--
-- Aenderungen gegenueber dem Live-Stand (bewusst, sicherheitsrelevant):
--   * activate_premium_purchase : search_path NEU gesetzt (war NULL)
--   * protect_premium_columns   : search_path NEU gesetzt (war NULL)
--   * grant_premium_from_server : search_path 'public' -> 'public, pg_temp'
--                                 + profiles -> public.profiles qualifiziert
--   * set_premium               : search_path 'public' -> 'public, pg_temp'
--   * update_premium_by_customer: search_path 'public' -> 'public, pg_temp'
--   * notify_premium_kauf       : NICHT enthalten (liegt bereits in
--                                 20260825120000_notify_premium.sql)
--
-- auth.uid() / auth.role() sind in allen Funktionen schema-qualifiziert,
-- daher genuegt 'public, pg_temp'.
--
-- Idempotent: create or replace + drop trigger if exists + revoke/grant.

begin;

-- ---------------------------------------------------------------------------
-- 1) Schutz-Triggerfunktion: Premium-Spalten gegen Client-Writes sperren
-- ---------------------------------------------------------------------------
create or replace function public.protect_premium_columns()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
begin
  -- Kein normaler User-Kontext (Admin/Server/SQL-Editor) -> alles erlaubt
  if auth.uid() is null then
    return new;
  end if;
  -- Service-Role explizit auch erlauben
  if auth.role() = 'service_role' then
    return new;
  end if;
  -- Freigabe durch die Premium-RPCs (set_config('app.premium_grant','on'))
  if current_setting('app.premium_grant', true) = 'on' then
    return new;
  end if;
  -- Normaler eingeloggter Nutzer: Premium-Spalten gesperrt
  if new.is_premium     is distinct from old.is_premium
     or new.premium_tier  is distinct from old.premium_tier
     or new.premium_until is distinct from old.premium_until then
    raise exception 'Premium-Felder duerfen nicht direkt geaendert werden.';
  end if;
  return new;
end;
$function$;

comment on function public.protect_premium_columns() is
  'BEFORE-UPDATE-Wachhund auf public.profiles: verhindert, dass eingeloggte Clients is_premium/premium_tier/premium_until direkt setzen. Umgehung nur ueber die SECURITY-DEFINER-RPCs via app.premium_grant.';

-- ---------------------------------------------------------------------------
-- 2) Legacy-RPC aus der Google-Play-Zeit (v7)
--    Existiert weiterhin, ist aber gesperrt (Abschnitt 6) und wird spaeter
--    gedroppt, sobald kein Client sie mehr aufruft.
-- ---------------------------------------------------------------------------
create or replace function public.activate_premium_purchase(p_tier text, p_days integer)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
declare
  v_uid uuid := auth.uid();
  v_current timestamptz;
  v_until timestamptz;
begin
  if v_uid is null then
    raise exception 'Nicht eingeloggt.';
  end if;
  if p_tier not in ('monthly', 'half-year', 'yearly') then
    raise exception 'Ungueltiger Tarif.';
  end if;
  if p_days is null or p_days < 1 or p_days > 372 then
    raise exception 'Ungueltige Laufzeit.';
  end if;

  select premium_until into v_current
  from public.profiles
  where id = v_uid;

  v_until := greatest(
    coalesce(v_current, '-infinity'::timestamptz),
    now() + make_interval(days => p_days)
  );

  perform set_config('app.premium_grant', 'on', true);

  update public.profiles
  set is_premium    = true,
      premium_tier  = p_tier,
      premium_until = v_until
  where id = v_uid;
end;
$function$;

comment on function public.activate_premium_purchase(text, integer) is
  'DEPRECATED (Google-Play-Legacy, v7). Gesperrt: kein EXECUTE fuer anon/authenticated/PUBLIC. Wird nach Abloese-Frist gedroppt.';

-- ---------------------------------------------------------------------------
-- 3) Server-seitige Freischaltung (Edge Function verify-purchase, service_role)
-- ---------------------------------------------------------------------------
create or replace function public.grant_premium_from_server(
  p_user_id uuid,
  p_tier    text,
  p_until   timestamptz
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $function$
declare
  v_current timestamptz;
begin
  if p_user_id is null then
    raise exception 'user_id fehlt';
  end if;

  if p_tier not in ('monthly', 'half-year', 'yearly') then
    raise exception 'Ungueltiger Tier: %', p_tier;
  end if;

  if p_until is null or p_until <= now() then
    raise exception 'Ungueltiges Ablaufdatum';
  end if;

  select premium_until into v_current
  from public.profiles where id = p_user_id;

  -- Schutz-Trigger fuer diese Transaktion umgehen
  perform set_config('app.premium_grant', 'on', true);

  update public.profiles
  set is_premium    = true,
      premium_tier  = p_tier,
      -- niemals verkuerzen
      premium_until = greatest(coalesce(v_current, '-infinity'::timestamptz), p_until)
  where id = p_user_id;
end;
$function$;

comment on function public.grant_premium_from_server(uuid, text, timestamptz) is
  'Premium serverseitig freischalten (nur service_role). Verlaengert nie rueckwaerts: premium_until = greatest(bisher, neu).';

-- ---------------------------------------------------------------------------
-- 4) Stripe: direktes Setzen und Update ueber die Customer-ID
-- ---------------------------------------------------------------------------
create or replace function public.set_premium(
  p_user_id  uuid,
  p_tier     text,
  p_until    timestamptz,
  p_customer text
)
returns void
language sql
security definer
set search_path = public, pg_temp
as $function$
  update public.profiles
  set is_premium = true,
      premium_tier = p_tier,
      premium_until = p_until,
      stripe_customer_id = p_customer
  where id = p_user_id;
$function$;

comment on function public.set_premium(uuid, text, timestamptz, text) is
  'Stripe-Checkout: Premium setzen und stripe_customer_id verknuepfen (nur service_role).';

create or replace function public.update_premium_by_customer(
  p_customer text,
  p_active   boolean,
  p_tier     text,
  p_until    timestamptz
)
returns void
language sql
security definer
set search_path = public, pg_temp
as $function$
  update public.profiles
  set is_premium = p_active,
      premium_tier = p_tier,
      premium_until = p_until
  where stripe_customer_id = p_customer;
$function$;

comment on function public.update_premium_by_customer(text, boolean, text, timestamptz) is
  'Stripe-Webhook: Abo-Status anhand der stripe_customer_id fortschreiben (nur service_role).';

-- ---------------------------------------------------------------------------
-- 5) Trigger auf public.profiles (exakt wie in der Live-DB)
-- ---------------------------------------------------------------------------
drop trigger if exists trg_protect_premium on public.profiles;

create trigger trg_protect_premium
before update on public.profiles
for each row
execute function public.protect_premium_columns();

-- ---------------------------------------------------------------------------
-- 6) Rechte (Wiederholung von 20260902120000_lock_premium_rpcs, idempotent)
--    create or replace erhaelt bestehende ACLs; bei Neuanlage bekaeme PUBLIC
--    aber wieder EXECUTE. Deshalb hier am Ende erneut.
-- ---------------------------------------------------------------------------
revoke all on function public.activate_premium_purchase(text, integer)
  from public, anon, authenticated, service_role;

revoke all on function public.grant_premium_from_server(uuid, text, timestamptz)
  from public, anon, authenticated;
grant execute on function public.grant_premium_from_server(uuid, text, timestamptz)
  to service_role;

revoke all on function public.set_premium(uuid, text, timestamptz, text)
  from public, anon, authenticated;
grant execute on function public.set_premium(uuid, text, timestamptz, text)
  to service_role;

revoke all on function public.update_premium_by_customer(text, boolean, text, timestamptz)
  from public, anon, authenticated;
grant execute on function public.update_premium_by_customer(text, boolean, text, timestamptz)
  to service_role;

-- Triggerfunktion: Live-Stand hat EXECUTE fuer PUBLIC; unkritisch, weil der
-- Trigger als Tabellenbesitzer feuert. Optionale Haertung:
-- revoke all on function public.protect_premium_columns() from public, anon, authenticated;

commit;

-- Kontrollabfrage nach dem Einspielen:
-- select p.oid::regprocedure::text, p.proacl::text, p.proconfig
--   from pg_proc p join pg_namespace n on n.oid = p.pronamespace
--  where n.nspname='public' and p.proname in
--   ('activate_premium_purchase','grant_premium_from_server','set_premium',
--    'update_premium_by_customer','protect_premium_columns');
-- Erwartung: proconfig = {search_path=public, pg_temp} bei allen fuenf.
