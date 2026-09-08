-- 2026-09-08: Fragen- und Fortschrittszaehler der Modul-Uebersicht serverseitig.
--
-- Befund: app_cache_service._preloadModules() hat ALLE Fragen (id, modul_id)
-- geladen und in der App pro Modul gezaehlt. PostgREST liefert ohne Range
-- maximal 1000 Zeilen; der Bestand liegt bei 1825 (nach den Einstiegsfragen).
-- Welche 1000 ankommen, ist ohne ORDER BY zufaellig -> Zaehler in der
-- Uebersicht zu niedrig. Dasselbe Limit trifft user_progress: ein Nutzer hat
-- bereits 1266 Zeilen -> "beantwortet" ebenfalls gedeckelt.
--
-- Fix: eine RPC, die pro Modul zwei Zahlen liefert (16 Zeilen statt 1825+).
-- SECURITY INVOKER: RLS von fragen (oeffentlich lesbar) und user_progress
-- (nur eigene Zeilen) gilt weiter; auth.uid() ist der aufrufende Nutzer.
-- Zaehlweise identisch zur bisherigen App-Logik: Fragen = alle Zeilen in
-- fragen je modul_id, beantwortet = Zeilen in user_progress je modul_id
-- (eine Zeile pro Nutzer und Frage dank Upsert onConflict user_id,frage_id).

create or replace function public.modul_zaehler()
returns table (modul_id integer, fragen_gesamt integer, beantwortet integer)
language sql
stable
security invoker
set search_path = public, pg_temp
as $$
  select f.modul_id,
         count(*)::integer as fragen_gesamt,
         coalesce(p.n, 0)::integer as beantwortet
    from public.fragen f
    left join (
      select up.modul_id, count(*) as n
        from public.user_progress up
       where up.user_id = auth.uid()
       group by up.modul_id
    ) p on p.modul_id = f.modul_id
   where f.modul_id is not null
   group by f.modul_id, p.n
   order by f.modul_id;
$$;

revoke execute on function public.modul_zaehler() from public, anon;
grant  execute on function public.modul_zaehler() to authenticated, service_role;

-- Kontrolle (im SQL-Editor laeuft man als postgres, auth.uid() ist dann NULL
-- -> beantwortet = 0, fragen_gesamt muss aber stimmen):
-- select * from public.modul_zaehler();
-- select modul_id, count(*) from fragen group by 1 order by 1;  -- gleiche Zahlen
