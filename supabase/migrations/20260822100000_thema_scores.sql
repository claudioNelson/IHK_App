-- ============================================================================
-- Cloud-Speicher fuer die besten Themen-Ergebnisse im Uebungsbereich
-- ============================================================================
-- Vorher lag der Score nur in SharedPreferences und wurde beim Logout
-- geloescht (auth_service.signOut raeumt lokale Daten auf). Die App liest
-- und schreibt diese Tabelle ueber ThemaScoreService.
-- Im SQL Editor des Projekts ybvwjmaicoffitngtmzl ausfuehren.

create table if not exists public.thema_scores (
  user_id    uuid not null references auth.users(id) on delete cascade,
  modul_id   integer not null,
  thema_id   integer not null,
  best_score double precision not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, modul_id, thema_id)
);

alter table public.thema_scores enable row level security;

create policy "eigene_scores_lesen" on public.thema_scores
  for select using (auth.uid() = user_id);

create policy "eigene_scores_anlegen" on public.thema_scores
  for insert with check (auth.uid() = user_id);

create policy "eigene_scores_aktualisieren" on public.thema_scores
  for update using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- WICHTIG: Policies allein reichen nicht, die Rolle braucht auch GRANTs
-- (Lehre aus dem kurs_fortschritt-Bug, Fehlercode 42501).
grant select, insert, update on table public.thema_scores to authenticated;
grant all on table public.thema_scores to service_role;

notify pgrst, 'reload schema';
