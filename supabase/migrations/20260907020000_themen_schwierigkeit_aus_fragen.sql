-- 2026-09-07: Themen-Schwierigkeit aus dem echten Fragen-Mix berechnen.
--
-- Befund (Modul-Analyse 07.09.): Bei den elf neueren Modulen (9001-9011)
-- tragen ALLE Themen pauschal 'mittel', obwohl z. B. "SQL Basics" nur
-- einfache und "Transaktionen & Indexe" nur schwere Fragen enthaelt.
-- Die App zeigt themen.schwierigkeitsgrad als Badge (leicht/mittel/schwer).
--
-- Regel (pro Thema, ueber fragen.schwierigkeitsgrad 'einfach'|'mittel'|'schwer'):
--   * >= 40 % einfach UND <= 10 % schwer  -> 'leicht'
--   * >= 50 % schwer                       -> 'schwer'
--   * sonst                                -> 'mittel'
--   * Themen ohne Fragen bleiben unveraendert.
--
-- Als Funktion, damit sie nach jeder Inhaltsrunde (neue Fragen) einfach
-- erneut aufgerufen werden kann:  select public.refresh_themen_schwierigkeit();
--
-- Nur Daten (Labels), keine App-Aenderung. 31 Themen aendern sich beim
-- ersten Lauf (Stand 07.09.), davon 29 in Richtung leicht/schwer und 2
-- (Betriebswirtschaft: Kostenrechnung, Controlling) von 'leicht' auf
-- 'mittel', weil dort noch keine einfachen Fragen existieren.

create or replace function public.refresh_themen_schwierigkeit()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer;
begin
  with mix as (
    select t.id,
           count(f.id) as n,
           count(*) filter (where f.schwierigkeitsgrad = 'einfach') as e,
           count(*) filter (where f.schwierigkeitsgrad = 'schwer')  as s
      from public.themen t
      left join public.fragen f on f.thema_id = t.id and f.modul_id = t.module_id
     group by t.id
  ), neu as (
    select id,
           case when e * 5 >= n * 2 and s * 10 <= n then 'leicht'
                when s * 2 >= n                     then 'schwer'
                else 'mittel' end as grad
      from mix
     where n > 0
  )
  update public.themen t
     set schwierigkeitsgrad = neu.grad
    from neu
   where neu.id = t.id
     and t.schwierigkeitsgrad is distinct from neu.grad;
  get diagnostics v_count = row_count;
  raise log 'refresh_themen_schwierigkeit: % Themen aktualisiert', v_count;
  return v_count;
end;
$$;

revoke execute on function public.refresh_themen_schwierigkeit() from public, anon, authenticated;
grant  execute on function public.refresh_themen_schwierigkeit() to postgres, service_role;

-- Einmal ausfuehren (erwartet: 31)
select public.refresh_themen_schwierigkeit() as aktualisiert;

-- Kontrolle:
-- select m.name, t.sort_index, t.name, t.schwierigkeitsgrad
--   from themen t join module m on m.id = t.module_id order by m.id, t.sort_index, t.id;
