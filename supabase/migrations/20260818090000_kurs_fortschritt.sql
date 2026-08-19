-- ============================================================================
-- Fortschritt in den Kursen (SQL, Python)
-- ============================================================================
-- Eine Zeile pro Nutzer und gelöster Aufgabe. Bewusst so simpel:
-- kein Zähler, kein Status, nur "gelöst am". Alles Weitere (Prozente,
-- Abzeichen) lässt sich daraus jederzeit berechnen.

create table if not exists public.kurs_fortschritt (
  user_id    uuid not null references auth.users(id) on delete cascade,
  aufgabe_id text not null,
  geloest_am timestamptz not null default now(),
  primary key (user_id, aufgabe_id)
);

comment on table public.kurs_fortschritt is
  'Geloeste Kursaufgaben (SQL-/Python-Kurs in der App).';

alter table public.kurs_fortschritt enable row level security;

-- Jeder sieht und schreibt nur seinen eigenen Fortschritt.
create policy "eigener_fortschritt_lesen"
  on public.kurs_fortschritt for select
  using (auth.uid() = user_id);

create policy "eigener_fortschritt_schreiben"
  on public.kurs_fortschritt for insert
  with check (auth.uid() = user_id);

-- Loeschen erlauben wir dem Nutzer ebenfalls (Konto-Reset, DSGVO).
create policy "eigener_fortschritt_loeschen"
  on public.kurs_fortschritt for delete
  using (auth.uid() = user_id);

-- Update braucht niemand: geloest ist geloest. Kein UPDATE-Policy,
-- damit ist es automatisch verboten.
