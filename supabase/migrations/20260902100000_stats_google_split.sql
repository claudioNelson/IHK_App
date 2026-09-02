-- 20260902100000_stats_google_split.sql
--
-- admin_user_stats liefert die Gaeste jetzt aufgeteilt:
--   guests        alle anonymen Accounts (wie bisher, bleibt kompatibel)
--   guests_google davon als Google-Testgeraet markiert (is_google_test)
--   guests_echt   der Rest, also echte Menschen
-- Grundlage ist das Flag aus Migration 20260902090000, gesetzt von der
-- Edge Function notify-signup.

create or replace function public.admin_user_stats()
 returns jsonb
 language sql
 security definer
 set search_path to 'public', 'auth'
as $function$
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
),
gaeste as (
  select u.id,
         coalesce(p.is_google_test, false) as ist_google
    from auth.users u
    left join public.profiles p on p.id = u.id
   where coalesce(u.is_anonymous, false) = true
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
  'guests',        (select count(*) from gaeste),
  'guests_google', (select count(*) from gaeste where ist_google),
  'guests_echt',   (select count(*) from gaeste where not ist_google),
  'last_signup', (select max(created_at) from echte)
);
$function$;
