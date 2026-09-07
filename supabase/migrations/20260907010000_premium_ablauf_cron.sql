-- 2026-09-07: Abgelaufene Abos serverseitig beenden.
--
-- Problem (billing-status.md Punkt 4, Fall Linda 05.09.):
--   Nach Ablauf von premium_until bleibt is_premium = true in der DB stehen.
--   Die App rechnet lokal richtig (sperrt), aber ihr Versuch, is_premium
--   per direktem UPDATE auf false zu setzen (subscription_service.dart),
--   scheitert am Schutz-Trigger trg_protect_premium. Folge: Telegram-/stats,
--   Rangliste und alles Serverseitige zaehlen abgelaufene Nutzer als Premium.
--
-- Loesung:
--   * expire_premium(): setzt is_premium = false, wo premium_until in der
--     Vergangenheit liegt und das Tier nicht 'lifetime' ist. premium_tier
--     und premium_until bleiben als Historie stehen. Verlaengert NIE etwas.
--   * pg_cron stuendlich (Minute 23, damit es nicht mit den anderen Jobs
--     zusammenfaellt).
--   * Verlaengerte Abos holen sich ihr neues Datum weiterhin beim App-Start
--     ueber verify-purchase / verify-purchase-ios (Auto-Restore).
--
-- Sicherheit:
--   * SECURITY DEFINER + search_path fixiert (wie alle Funktionen seit 04.09.).
--   * Nur postgres/service_role duerfen sie aufrufen (kein Client-Zugriff).
--   * Im Cron-Kontext ist auth.uid() NULL -> trg_protect_premium erlaubt
--     die Aenderung. notify_premium_kauf feuert nur bei false->true oder
--     Tier-Wechsel, also NICHT beim Zurueckstufen.
--
-- App-Aenderung: keine.

create or replace function public.expire_premium()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer;
begin
  update public.profiles
     set is_premium = false
   where is_premium = true
     and lower(trim(coalesce(premium_tier, ''))) <> 'lifetime'
     and premium_until is not null
     and premium_until < now();
  get diagnostics v_count = row_count;
  -- landet in cron.job_run_details.return_message / Postgres-Log
  raise log 'expire_premium: % Abo(s) beendet', v_count;
  return v_count;
end;
$$;

revoke execute on function public.expire_premium() from public, anon, authenticated;
grant  execute on function public.expire_premium() to postgres, service_role;

-- Stuendlich (Minute 23). unschedule zuerst, damit die Migration wiederholbar ist.
do $$
begin
  if exists (select 1 from cron.job where jobname = 'expire_premium') then
    perform cron.unschedule('expire_premium');
  end if;
end $$;
select cron.schedule('expire_premium', '23 * * * *', $$select public.expire_premium()$$);

-- Einmaliger Lauf fuer Altfaelle (Stand 07.09.: erwartet 0)
select public.expire_premium() as sofort_beendet;

-- Kontrolle danach:
-- select jobname, schedule, command from cron.job where jobname = 'expire_premium';
-- select count(*) from public.profiles
--  where is_premium and coalesce(premium_tier,'') <> 'lifetime'
--    and premium_until < now();   -- erwartet 0
