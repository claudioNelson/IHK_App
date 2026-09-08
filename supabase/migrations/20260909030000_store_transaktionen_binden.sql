-- 2026-09-09: Store-Kaeufe an genau EIN Lernarena-Konto binden.
--
-- Befund (User, 09.09.): Auf dem iPhone bekam jeder Account, mit dem man
-- sich einloggte, Lindas Sandbox-Abo - auch zwei frisch registrierte.
-- Ursache: Der Auto-Restore beim App-Start liefert alle aktiven Abos der
-- Apple-ID des Geraets; verify-purchase-ios prueft den Kauf bei Apple,
-- schreibt Premium aber auf den GERADE EINGELOGGTEN Nutzer. Google
-- (verify-purchase, purchaseToken) hat dasselbe Muster. Im Store waere das
-- ein Schlupfloch: ein Abo, beliebig viele Lernarena-Konten.
--
-- Fix: Tabelle store_transaktionen merkt sich, welcher Nutzer eine
-- Transaktion zuerst eingeloest hat. Die RPC claim_store_transaktion wird
-- von beiden Edge Functions VOR grant_premium_from_server aufgerufen:
--   * unbekannt              -> an diesen Nutzer binden, true
--   * gleicher Nutzer        -> last_seen aktualisieren, true
--   * anderer Nutzer         -> false (Function lehnt mit 409 ab)
--   * gebundener Nutzer existiert nicht mehr (Konto geloescht)
--                            -> neu binden, true
-- Support-Rezept: Soll ein Abo bewusst auf ein anderes Konto wandern
-- (Nutzer hat neu registriert), Zeile in store_transaktionen loeschen.
--
-- Schluessel: Apple = originalTransactionId (bleibt ueber Verlaengerungen
-- gleich), Google = purchaseToken.

begin;

create table if not exists public.store_transaktionen (
  store          text        not null check (store in ('apple', 'google')),
  transaktion    text        not null,
  user_id        uuid        not null,
  product_id     text,
  environment    text,
  first_seen     timestamptz not null default now(),
  last_seen      timestamptz not null default now(),
  primary key (store, transaktion)
);
create index if not exists idx_store_transaktionen_user on public.store_transaktionen(user_id);

-- Nur der Server (service_role) darf lesen/schreiben.
alter table public.store_transaktionen enable row level security;
revoke all on public.store_transaktionen from public, anon, authenticated;
grant select, insert, update, delete on public.store_transaktionen to service_role;

create or replace function public.claim_store_transaktion(
  p_store text,
  p_transaktion text,
  p_user_id uuid,
  p_product_id text default null,
  p_environment text default null
)
returns boolean
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_owner uuid;
begin
  select user_id into v_owner
    from public.store_transaktionen
   where store = p_store and transaktion = p_transaktion
   for update;

  if not found then
    insert into public.store_transaktionen (store, transaktion, user_id, product_id, environment)
    values (p_store, p_transaktion, p_user_id, p_product_id, p_environment);
    return true;
  end if;

  if v_owner = p_user_id then
    update public.store_transaktionen
       set last_seen = now(),
           product_id = coalesce(p_product_id, product_id),
           environment = coalesce(p_environment, environment)
     where store = p_store and transaktion = p_transaktion;
    return true;
  end if;

  -- Gebundenes Konto geloescht? Dann darf die Transaktion wandern.
  if not exists (select 1 from auth.users u where u.id = v_owner) then
    update public.store_transaktionen
       set user_id = p_user_id, last_seen = now(),
           product_id = coalesce(p_product_id, product_id),
           environment = coalesce(p_environment, environment)
     where store = p_store and transaktion = p_transaktion;
    return true;
  end if;

  raise log 'claim_store_transaktion: % % gehoert %, Anfrage von % abgelehnt',
    p_store, p_transaktion, v_owner, p_user_id;
  return false;
end;
$$;

revoke execute on function public.claim_store_transaktion(text, text, uuid, text, text) from public, anon, authenticated;
grant  execute on function public.claim_store_transaktion(text, text, uuid, text, text) to service_role;

commit;

-- Kontrolle nach dem ersten App-Start mit Premium-Konto:
-- select * from store_transaktionen order by first_seen desc;
