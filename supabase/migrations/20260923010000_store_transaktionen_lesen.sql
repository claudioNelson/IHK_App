-- 2026-09-23: Nutzer duerfen ihre eigenen Store-Transaktionen lesen.
--
-- Das Web-Profil leitet daraus die Kaufquelle ab (Google Play / App Store /
-- Web via Stripe), um "Abo verwalten" nur bei Stripe-Abos anzubieten und
-- bei App-Kaeufen auf die Store-Einstellungen zu verweisen. Bisher hatte
-- die Tabelle RLS ohne SELECT-Policy, also war sie fuer Nutzer unsichtbar.
-- Schreiben bleibt weiterhin nur der service_role (Edge Functions) erlaubt.

begin;

create policy "Nutzer sehen eigene Store-Transaktionen"
  on public.store_transaktionen
  for select
  to authenticated
  using (auth.uid() = user_id);

commit;

-- Kontrolle:
-- select policyname, cmd from pg_policies where tablename = 'store_transaktionen';
