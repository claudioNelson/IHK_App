-- 2026-09-17: Tagesplan (Pruefungs-Countdown Phase 2) - Datengrundlage.
--
-- Plan: claude/pruefungs-countdown-plan.md. Die App berechnet den Tagesplan
-- clientseitig (lib/services/lernplan_service.dart); damit sie dafuer nicht
-- 17 Module einzeln nachladen muss, liefert die RPC lernplan_status() alles
-- in einem Aufruf: alle Themen mit Fragenzahl, bestem Score und heute
-- beantworteten Fragen, dazu faellige/heute erledigte Wiederholungen und
-- die letzte Uebungspruefung. SECURITY INVOKER wie modul_zaehler(): RLS
-- der Nutzertabellen greift, auth.uid() ist der Aufrufer.
--
-- Zuordnung der Module zu den Pruefungen liegt in drei neuen Spalten an
-- module (ap1, ap2_ae, ap2_si), damit sie ohne App-Release aenderbar ist.
-- Erstbelegung: AP1 = alles ausser Web, Cloud/DevOps, Datenstrukturen;
-- AP2 AE = Programmierung, Web, DSA, Datenbanken, IT-Sicherheit + WiSo/PM/QM;
-- AP2 SI = Netzwerke, Betriebssysteme, Hardware, IT-Sicherheit, Cloud,
-- Datenbanken + WiSo/PM/QM. Kernthemen-Module (kategorie='kernthema')
-- bleiben aussen vor.
--
-- p_tagesbeginn kommt vom Client (lokale Mitternacht als UTC), damit
-- "heute" zur Geraetezeit passt, wie in daily_goal_service.dart.

begin;

alter table public.module
  add column if not exists ap1    boolean not null default true,
  add column if not exists ap2_ae boolean not null default true,
  add column if not exists ap2_si boolean not null default true;

comment on column public.module.ap1    is 'Modul ist fuer die AP1 relevant (Tagesplan).';
comment on column public.module.ap2_ae is 'Modul ist fuer die AP2 Anwendungsentwicklung relevant (Tagesplan).';
comment on column public.module.ap2_si is 'Modul ist fuer die AP2 Systemintegration relevant (Tagesplan).';

update public.module set ap1 = false where id in (9009, 9010, 9011);            -- Web, Cloud & DevOps, DSA
update public.module set ap2_ae = false where id in (9004, 9005, 9006, 9010);   -- Netzwerke, Betriebssysteme, Hardware, Cloud
update public.module set ap2_si = false where id in (9007, 9009, 9011);         -- Programmierung, Web, DSA

create or replace function public.lernplan_status(p_tagesbeginn timestamptz default date_trunc('day', now()))
returns json
language sql
security invoker
set search_path = public, pg_temp
as $$
  with uid as (select auth.uid() as id),
  themen_liste as (
    select t.id as thema_id, t.name as thema_name, t.module_id as modul_id, m.name as modul_name,
           coalesce(t.required_score, 80) as required_score, t.sort_index,
           m.ap1, m.ap2_ae, m.ap2_si,
           (select count(*) from public.fragen f where f.thema_id = t.id) as fragen,
           (select s.best_score from public.thema_scores s
             where s.user_id = (select id from uid) and s.thema_id = t.id and s.modul_id = t.module_id) as best_score,
           (select count(*) from public.user_progress p
             where p.user_id = (select id from uid) and p.thema_id = t.id and p.answered_at >= p_tagesbeginn) as heute,
           (select max(p.answered_at) from public.user_progress p
             where p.user_id = (select id from uid) and p.thema_id = t.id) as zuletzt
      from public.themen t
      join public.module m on m.id = t.module_id
     where coalesce(m.kategorie, '') <> 'kernthema'
  )
  select json_build_object(
    'themen', (select coalesce(json_agg(json_build_object(
        'thema_id', thema_id, 'thema_name', thema_name, 'modul_id', modul_id, 'modul_name', modul_name,
        'required_score', required_score, 'sort_index', sort_index,
        'ap1', ap1, 'ap2_ae', ap2_ae, 'ap2_si', ap2_si,
        'fragen', fragen, 'best_score', best_score, 'heute', heute, 'zuletzt', zuletzt
      ) order by modul_id, sort_index, thema_id), '[]'::json) from themen_liste),
    'heute_fragen', (select count(*) from public.user_progress p
                      where p.user_id = (select id from uid) and p.answered_at >= p_tagesbeginn),
    'faellig', (select count(*) from public.spaced_repetition r
                 where r.user_id = (select id from uid) and r.next_review_at <= now()),
    'heute_wiederholt', (select count(*) from public.spaced_repetition r
                          where r.user_id = (select id from uid) and r.last_reviewed_at >= p_tagesbeginn),
    'letzte_pruefung', (select max(a.submitted_at) from public.user_exam_attempts a
                         where a.user_id = (select id from uid)),
    'heute_pruefung', (select count(*) > 0 from public.user_exam_attempts a
                        where a.user_id = (select id from uid) and a.submitted_at >= p_tagesbeginn)
  );
$$;

revoke all on function public.lernplan_status(timestamptz) from public, anon;
grant execute on function public.lernplan_status(timestamptz) to authenticated;

commit;

-- Kontrolle:
-- select id, name, ap1, ap2_ae, ap2_si from module where coalesce(kategorie,'') <> 'kernthema' order by id;
-- select json_array_length((lernplan_status())->'themen');   -- erwartet 70 (als eingeloggter Nutzer; im SQL-Editor ohne auth.uid() sind Scores null)
