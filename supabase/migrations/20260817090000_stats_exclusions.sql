-- ============================================================================
-- Echte Nutzer von Test- und Bot-Accounts trennen
-- ============================================================================
-- Ein Account zaehlt nur als "echter Nutzer", wenn er
--   1. kein Gast (anonym) ist,
--   2. seine E-Mail bestaetigt hat,
--   3. auf kein Muster in public.stats_exclusions passt.
--
-- Weitere Adresse ausschliessen (kein Deployment noetig):
--   insert into public.stats_exclusions (pattern, grund)
--   values ('cnm89@proton.me', 'eigener Account')
--   on conflict (pattern) do nothing;
--
-- Wieder aufnehmen:
--   delete from public.stats_exclusions where pattern = '...';
-- ============================================================================

create table if not exists public.stats_exclusions (
  pattern    text primary key,
  grund      text,
  created_at timestamptz not null default now()
);

comment on table  public.stats_exclusions is
  'E-Mail-Muster (ILIKE), die nicht als echte Nutzer zaehlen. Nur service_role.';
comment on column public.stats_exclusions.pattern is
  'ILIKE-Muster, z.B. %@bot.internal oder max@example.de';

-- RLS an, aber bewusst KEINE Policy: damit kommt weder anon noch authenticated
-- an die Tabelle. Die Statistik-Funktion laeuft als SECURITY DEFINER und sieht
-- sie trotzdem.
alter table public.stats_exclusions enable row level security;

insert into public.stats_exclusions (pattern, grund) values
  ('%@bot.internal', 'Bot-Registrierungen'),
  ('%@test.com',     'Testkonten'),
  ('%@example.com',  'Testkonten')
on conflict (pattern) do nothing;


-- ---------------------------------------------------------------------------
-- Statistik neu: gefiltert + Rohwert zum Vergleich
-- ---------------------------------------------------------------------------
create or replace function public.admin_user_stats()
returns jsonb
language sql
security definer
set search_path = public, auth
as $$
with echte as (
  select u.id, u.created_at, u.last_sign_in_at
    from auth.users u
   where coalesce(u.is_anonymous, false) = false
     and u.email_confirmed_at is not null
     and not exists (
           select 1
             from public.stats_exclusions x
            where u.email ilike x.pattern
         )
),
roh as (
  select count(*) as c
    from auth.users
   where coalesce(is_anonymous, false) = false
)
select jsonb_build_object(
  'total',     (select count(*) from echte),
  'total_raw', (select c from roh),
  'excluded',  (select c from roh) - (select count(*) from echte),

  'today',     (select count(*) from echte
                 where created_at >= ((now() at time zone 'Europe/Berlin')::date)
                                      at time zone 'Europe/Berlin'),
  'week',      (select count(*) from echte
                 where created_at >= now() - interval '7 days'),

  'active7',   (select count(*) from echte
                 where last_sign_in_at >= now() - interval '7 days'),
  'active30',  (select count(*) from echte
                 where last_sign_in_at >= now() - interval '30 days'),

  'premium',   (select count(*) from public.profiles p
                  join echte e on e.id = p.id
                 where p.is_premium is true),

  'guests',    (select count(*) from auth.users
                 where coalesce(is_anonymous, false) = true),

  'last_signup', (select max(created_at) from echte)
);
$$;

comment on function public.admin_user_stats() is
  'Nutzerkennzahlen fuer Telegram (/stats) und den Signup-Trigger. Nur service_role.';

revoke all     on function public.admin_user_stats() from public, anon, authenticated;
grant  execute on function public.admin_user_stats() to service_role;

notify pgrst, 'reload schema';
