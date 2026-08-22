-- ============================================================================
-- 10 zusaetzliche Ranglisten-Bots (ausgefuehrt 21.08.2026, Projekt ybvwjmaicoffitngtmzl)
-- ============================================================================
-- Bots werden von bot_play_match() ueber profiles.is_bot = true erkannt und
-- uebernehmen per Cron (run_bot_takeover, alle 10 Min) offene Matches echter
-- Spieler, die 6+ Stunden warten. Elo bewusst 950 bis 1050 (Mittelfeld,
-- echte Spieler koennen vorbeiziehen). Adressen @bot.internal zaehlen nicht
-- in /stats (stats_exclusions).
--
-- WICHTIG (gelernt beim Einspielen): Der Signup-Trigger handle_new_user()
-- legt Profile automatisch an, und zwar NACH den CTEs desselben Statements.
-- Deshalb Profile hier NICHT selbst anlegen, sondern nach dem Insert per
-- UPDATE mit Namen und is_bot versorgen (Block 2).

-- Block 1: Konten + Rangliste
with bots(username, email, elo, highest, w, l, correct) as (
  values
    ('LeonZockt',      'leonzockt@bot.internal',    1048, 1061, 9, 7, 71),
    ('annalenaaa',     'annalenaaa@bot.internal',   1035, 1035, 8, 7, 64),
    ('jonas.k',        'jonask@bot.internal',       1022, 1040, 7, 6, 55),
    ('Kabelklaus',     'kabelklaus@bot.internal',   1010, 1028, 6, 6, 49),
    ('der_echte_finn', 'derechtefinn@bot.internal', 1002, 1019, 5, 5, 41),
    ('paul_ffm',       'paulffm@bot.internal',       991, 1013, 5, 6, 40),
    ('Milchschnitte',  'milchschnitte@bot.internal', 978, 1009, 4, 6, 34),
    ('ninaberlin',     'ninaberlin@bot.internal',    966, 1004, 3, 6, 28),
    ('fraeulein_toni', 'fraeuleintoni@bot.internal', 957, 1000, 3, 7, 27),
    ('lukas.hd',       'lukashd@bot.internal',       950, 1000, 2, 7, 22)
),
users_neu as (
  insert into auth.users
    (instance_id, id, aud, role, email, encrypted_password,
     email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
     created_at, updated_at)
  select
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    b.email,
    crypt(gen_random_uuid()::text, gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('username', b.username),
    now(), now()
  from bots b
  returning id, email
)
insert into public.player_stats
  (user_id, username, elo_rating, highest_elo, wins, losses, draws,
   matches_played, correct_answers)
select u.id, b.username, b.elo, b.highest, b.w, b.l, 0, b.w + b.l, b.correct
from users_neu u
join bots b on b.email = u.email;

-- Block 2: vom Trigger angelegte Profile mit Name + Bot-Flag versorgen
update public.profiles p
set username = u.raw_user_meta_data->>'username',
    email    = u.email,
    is_bot   = true
from auth.users u
where u.id = p.id
  and u.email like '%@bot.internal'
  and coalesce(p.is_bot, false) = false;
