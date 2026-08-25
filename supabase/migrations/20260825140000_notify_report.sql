-- ============================================================================
-- Telegram-Benachrichtigung bei neuen Problem-Meldungen (question_reports)
-- ============================================================================
-- Vorher landeten die Meldungen aus dem "Problem melden"-Dialog stumm in
-- der Tabelle question_reports, niemand hat davon erfahren.
-- Trigger -> pg_net -> Edge Function `notify-report` -> eigener
-- Telegram-Kanal (Secret TELEGRAM_REPORTS_CHAT_ID, Fallback Admin-Chat).
--
-- Vorher: supabase functions deploy notify-report --no-verify-jwt
-- und Secret setzen: supabase secrets set TELEGRAM_REPORTS_CHAT_ID=-100...
-- ============================================================================

create or replace function public.notify_question_report()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, auth, vault
as $$
declare
  v_secret text;
  v_frage  text;
  v_email  text;
begin
  select decrypted_secret
    into v_secret
    from vault.decrypted_secrets
   where name = 'notify_signup_secret'
   limit 1;

  if v_secret is null then
    raise warning 'notify_question_report: vault secret fehlt';
    return new;
  end if;

  select frage into v_frage from public.fragen where id = new.frage_id;
  select email into v_email from auth.users where id = new.user_id;

  perform net.http_post(
    url     := 'https://ybvwjmaicoffitngtmzl.supabase.co/functions/v1/notify-report',
    headers := jsonb_build_object(
                 'Content-Type',    'application/json',
                 'x-signup-secret', v_secret
               ),
    body    := jsonb_build_object(
                 'report_type', new.report_type,
                 'description', new.description,
                 'screen_type', new.screen_type,
                 'frage_id',    new.frage_id,
                 'frage',       v_frage,
                 'email',       v_email
               ),
    timeout_milliseconds := 5000
  );

  return new;

exception when others then
  -- Eine kaputte Benachrichtigung darf das Melden selbst nie verhindern.
  raise warning 'notify_question_report failed: %', sqlerrm;
  return new;
end;
$$;

comment on function public.notify_question_report() is
  'Meldet neue question_reports per Telegram (Edge Function notify-report).';

revoke all on function public.notify_question_report() from public, anon, authenticated;

drop trigger if exists on_question_report_notify on public.question_reports;

create trigger on_question_report_notify
  after insert on public.question_reports
  for each row
  execute function public.notify_question_report();
