-- Premium-RPCs absichern (02.09.2026)
--
-- Befund aus pg_proc.proacl (Live-DB):
--   activate_premium_purchase(text,integer)        -> authenticated hatte EXECUTE  (Luecke)
--   set_premium(uuid,text,timestamptz,text)        -> PUBLIC hatte EXECUTE        (Luecke)
--   update_premium_by_customer(text,boolean,text,timestamptz) -> PUBLIC hatte EXECUTE (Luecke)
--   grant_premium_from_server(uuid,text,timestamptz) -> nur service_role          (ok)
--
-- Alle vier sind SECURITY DEFINER und umgehen RLS + trg_protect_premium.
-- Kein Client-Code (App, Web, Edge Functions) ruft activate_premium_purchase
-- noch auf; set_premium / update_premium_by_customer werden nur vom
-- stripe-webhook mit Service-Role-Key aufgerufen.

-- 1) Alte Kauf-RPC fuer Clients sperren
revoke all on function public.activate_premium_purchase(text, integer)
  from public, anon, authenticated;

-- 2) Stripe-RPCs nur noch fuer service_role
revoke all on function public.set_premium(uuid, text, timestamptz, text)
  from public, anon, authenticated;
grant execute on function public.set_premium(uuid, text, timestamptz, text)
  to service_role;

revoke all on function public.update_premium_by_customer(text, boolean, text, timestamptz)
  from public, anon, authenticated;
grant execute on function public.update_premium_by_customer(text, boolean, text, timestamptz)
  to service_role;

-- 3) grant_premium_from_server war bereits korrekt; idempotent bestaetigen
revoke all on function public.grant_premium_from_server(uuid, text, timestamptz)
  from public, anon, authenticated;
grant execute on function public.grant_premium_from_server(uuid, text, timestamptz)
  to service_role;

-- Spaeter (nach 2-4 Wochen ohne Fehler in den Postgres-Logs):
-- drop function if exists public.activate_premium_purchase(text, integer);

-- Kontrolle danach:
-- select p.oid::regprocedure, p.proacl from pg_proc p
--   join pg_namespace n on n.oid = p.pronamespace
--  where n.nspname='public' and p.proname in
--   ('activate_premium_purchase','grant_premium_from_server','set_premium','update_premium_by_customer');
-- Erwartung: ueberall nur postgres=X und service_role=X.
