-- 2026-09-20: Rabatt-Prozent fuer den Badge im Premium-Kauf-Sheet.
--
-- Auf iOS liefert StoreKit der App keinen Einfuehrungspreis (nur die
-- Berechtigung), Google liefert ihn. Damit die Monatskarte auf beiden
-- Plattformen denselben Badge "-50 %" tragen kann, steht der Prozentwert
-- hier - reine Anzeige, waehrungsunabhaengig, kein Preis. Der echte Preis
-- kommt weiterhin aus dem Store.

begin;

alter table public.aktionen
  add column if not exists rabatt_prozent smallint
  check (rabatt_prozent is null or (rabatt_prozent between 1 and 99));

comment on column public.aktionen.rabatt_prozent is 'Rabatt in Prozent fuer den Badge (Anzeige), z. B. 50. Kein Preis.';

update public.aktionen set rabatt_prozent = 50 where schluessel = 'endspurt_ap1_2026';

commit;

-- Kontrolle:
-- select schluessel, plan, rabatt_prozent, aktiv from aktionen;
