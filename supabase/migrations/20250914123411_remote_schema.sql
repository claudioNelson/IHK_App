drop extension if exists "pg_net";


  create table "public"."antworten" (
    "id" bigint not null,
    "frage_id" bigint not null,
    "text" text not null,
    "ist_richtig" boolean not null,
    "erklaerung" text
      );



  create table "public"."fragen" (
    "id" bigint not null,
    "modul_id" bigint not null,
    "thema_id" bigint,
    "frage" text not null,
    "erklaerung" text,
    "schwierigkeitsgrad" text
      );



  create table "public"."module" (
    "id" bigint not null,
    "name" text not null,
    "beschreibung" text
      );



  create table "public"."themen" (
    "id" bigint not null,
    "module_id" bigint not null,
    "name" text not null,
    "beschreibung" text,
    "sort_index" integer,
    "required_score" integer default 80,
    "unlocked_by" bigint
      );


CREATE UNIQUE INDEX antworten_pkey ON public.antworten USING btree (id);

CREATE UNIQUE INDEX fragen_pkey ON public.fragen USING btree (id);

CREATE INDEX idx_antworten_frage_id ON public.antworten USING btree (frage_id);

CREATE INDEX idx_fragen_modul_id ON public.fragen USING btree (modul_id);

CREATE INDEX idx_fragen_thema_id ON public.fragen USING btree (thema_id);

CREATE INDEX idx_themen_module_id ON public.themen USING btree (module_id);

CREATE INDEX idx_themen_unlocked_by ON public.themen USING btree (unlocked_by);

CREATE UNIQUE INDEX module_pkey ON public.module USING btree (id);

CREATE UNIQUE INDEX themen_pkey ON public.themen USING btree (id);

CREATE UNIQUE INDEX uniq_one_correct_per_frage ON public.antworten USING btree (frage_id) WHERE (ist_richtig = true);

alter table "public"."antworten" add constraint "antworten_pkey" PRIMARY KEY using index "antworten_pkey";

alter table "public"."fragen" add constraint "fragen_pkey" PRIMARY KEY using index "fragen_pkey";

alter table "public"."module" add constraint "module_pkey" PRIMARY KEY using index "module_pkey";

alter table "public"."themen" add constraint "themen_pkey" PRIMARY KEY using index "themen_pkey";

alter table "public"."antworten" add constraint "antworten_frage_id_fkey" FOREIGN KEY (frage_id) REFERENCES fragen(id) ON DELETE CASCADE not valid;

alter table "public"."antworten" validate constraint "antworten_frage_id_fkey";

alter table "public"."fragen" add constraint "fragen_modul_id_fkey" FOREIGN KEY (modul_id) REFERENCES module(id) ON DELETE CASCADE not valid;

alter table "public"."fragen" validate constraint "fragen_modul_id_fkey";

alter table "public"."fragen" add constraint "fragen_thema_id_fkey" FOREIGN KEY (thema_id) REFERENCES themen(id) ON DELETE SET NULL not valid;

alter table "public"."fragen" validate constraint "fragen_thema_id_fkey";

alter table "public"."themen" add constraint "themen_module_id_fkey" FOREIGN KEY (module_id) REFERENCES module(id) ON DELETE CASCADE not valid;

alter table "public"."themen" validate constraint "themen_module_id_fkey";

alter table "public"."themen" add constraint "themen_unlocked_by_fkey" FOREIGN KEY (unlocked_by) REFERENCES themen(id) ON DELETE SET NULL not valid;

alter table "public"."themen" validate constraint "themen_unlocked_by_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_question_with_answers(p_modul_name text, p_thema_name text, p_frage text, p_erklaerung text, p_schwierigkeit text DEFAULT 'leicht'::text, p_answers jsonb DEFAULT '[]'::jsonb)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  v_modul_id  int;
  v_thema_id  int;
  v_frage_id  int;
  v_item      jsonb;
  v_text      text;
  v_ok        boolean;
  v_erk       text;
begin
  select id into v_modul_id from module where name = p_modul_name limit 1;
  if v_modul_id is null then
    raise exception 'Modul % nicht gefunden', p_modul_name;
  end if;

  select id into v_thema_id
  from themen
  where module_id = v_modul_id and name = p_thema_name
  limit 1;
  if v_thema_id is null then
    raise exception 'Thema % in Modul % nicht gefunden', p_thema_name, p_modul_name;
  end if;

  select id into v_frage_id
  from fragen
  where frage = p_frage
    and modul_id = v_modul_id
    and (thema_id is not distinct from v_thema_id)
  limit 1;

  if v_frage_id is null then
    insert into fragen (frage, erklaerung, schwierigkeitsgrad, modul_id, thema_id)
    values (p_frage, p_erklaerung, coalesce(p_schwierigkeit,'leicht'), v_modul_id, v_thema_id)
    returning id into v_frage_id;
  end if;

  for v_item in
    select * from jsonb_array_elements(coalesce(p_answers, '[]'::jsonb))
  loop
    v_text := coalesce(v_item->>'text','');
    v_ok   := coalesce((v_item->>'ist_richtig')::boolean, false);
    v_erk  := v_item->>'erklaerung';

    if v_text <> '' and not exists (
      select 1 from antworten where frage_id = v_frage_id and text = v_text
    ) then
      insert into antworten (frage_id, text, ist_richtig, erklaerung)
      values (v_frage_id, v_text, v_ok, nullif(v_erk,''));
    end if;
  end loop;

  return v_frage_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.auth_role()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
  select coalesce(
    nullif(current_setting('request.jwt.claims', true), '')::jsonb
      -> 'app_metadata' ->> 'role',
    ''
  );
$function$
;

CREATE OR REPLACE FUNCTION public.btrim_null(txt text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$
  select nullif(btrim($1), '');
$function$
;

CREATE OR REPLACE FUNCTION public.delete_module_data(p_module_id integer, p_delete_module boolean DEFAULT false)
 RETURNS TABLE(deleted_antworten integer, deleted_fragen integer, deleted_themen integer, deleted_module integer)
 LANGUAGE plpgsql
AS $function$
declare
  v_cnt int;
begin
  deleted_antworten := 0;
  deleted_fragen     := 0;
  deleted_themen     := 0;
  deleted_module     := 0;

  -- 1) Antworten löschen (alle Fragen im Modul)
  delete from antworten a
  using fragen f
  where a.frage_id = f.id
    and f.modul_id = p_module_id;
  get diagnostics v_cnt = row_count;
  deleted_antworten := v_cnt;

  -- 2) Fragen löschen
  delete from fragen
  where modul_id = p_module_id;
  get diagnostics v_cnt = row_count;
  deleted_fragen := v_cnt;

  -- 3) Themen löschen
  delete from themen
  where module_id = p_module_id;
  get diagnostics v_cnt = row_count;
  deleted_themen := v_cnt;

  -- 4) Modul löschen (optional)
  if p_delete_module then
    delete from module
    where id = p_module_id;
    get diagnostics v_cnt = row_count;
    deleted_module := v_cnt;
  end if;

  return next;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.didactic_explanation_sync()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  correct_row antworten;
  frage_row   fragen;
BEGIN
  -- zugehörige Frage + (aktuelle) richtige Antwort laden
  SELECT * INTO frage_row
  FROM fragen
  WHERE id = COALESCE(NEW.frage_id, OLD.frage_id);

  SELECT *
  INTO correct_row
  FROM antworten
  WHERE frage_id = COALESCE(NEW.frage_id, OLD.frage_id)
    AND ist_richtig = TRUE
    AND (id <> COALESCE(NEW.id, -1))  -- beim Update nicht sich selbst greifen
  ORDER BY id
  LIMIT 1;

  -- Sicherstellen: höchstens eine richtige Antwort
  IF (TG_OP IN ('INSERT','UPDATE')) AND NEW.ist_richtig IS TRUE THEN
    IF EXISTS (
      SELECT 1 FROM antworten
      WHERE frage_id = NEW.frage_id
        AND ist_richtig = TRUE
        AND id <> COALESCE(NEW.id, -1)
    ) THEN
      RAISE EXCEPTION 'Nur eine richtige Antwort pro Frage % erlaubt', NEW.frage_id;
    END IF;
  END IF;

  -- Fall 1: Falsche Antwort wird eingefügt/aktualisiert -> Erklärung sofort setzen
  IF (TG_OP IN ('INSERT','UPDATE')) AND COALESCE(NEW.ist_richtig, FALSE) = FALSE THEN
    IF correct_row.id IS NOT NULL THEN
      NEW.erklaerung :=
        'Nicht korrekt. Richtig wäre: "' || correct_row.text || '". '
        || COALESCE(correct_row.erklaerung, '')
        || CASE WHEN COALESCE(frage_row.erklaerung,'') <> ''
                THEN ' Merke: ' || frage_row.erklaerung
                ELSE ''
           END;
    END IF;
    RETURN NEW;
  END IF;

  -- Fall 2: Die richtige Antwort selbst ändert sich -> alle falschen neu schreiben
  IF (TG_OP = 'UPDATE' AND NEW.ist_richtig = TRUE)
     OR (TG_OP = 'INSERT' AND NEW.ist_richtig = TRUE) THEN
    UPDATE antworten a
    SET erklaerung =
        'Nicht korrekt. Richtig wäre: "' || NEW.text || '". '
        || COALESCE(NEW.erklaerung, '')
        || CASE WHEN COALESCE(frage_row.erklaerung,'') <> ''
                THEN ' Merke: ' || frage_row.erklaerung
                ELSE ''
           END
    WHERE a.frage_id = NEW.frage_id
      AND a.ist_richtig = FALSE;
    RETURN NEW;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$function$
;

create or replace view "public"."fragen_progress" as  SELECT f.id,
    f.modul_id,
    f.thema_id,
    f.frage,
    f.erklaerung,
    f.schwierigkeitsgrad,
    t.module_id,
    t.sort_index AS themen_sort,
        CASE f.schwierigkeitsgrad
            WHEN 'einfach'::text THEN 1
            WHEN 'mittel'::text THEN 2
            WHEN 'schwer'::text THEN 3
            ELSE 2
        END AS diff_order
   FROM (fragen f
     JOIN themen t ON ((t.id = f.thema_id)));


CREATE OR REPLACE FUNCTION public.is_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select auth_role() = 'admin';
$function$
;

CREATE OR REPLACE FUNCTION public.set_default_question_difficulty()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.schwierigkeitsgrad IS NULL OR NEW.schwierigkeitsgrad NOT IN ('einfach','mittel','schwer') THEN
    NEW.schwierigkeitsgrad :=
      CASE
        WHEN NEW.thema_id IN (9101,9102,9201,9202) THEN 'einfach'
        WHEN NEW.thema_id IN (9103,9104,9203,9204) THEN 'mittel'
        WHEN NEW.thema_id IN (9105,9205)           THEN 'schwer'
        ELSE 'mittel' -- Fallback
      END;
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_question_explanation(p_modul_name text, p_thema_name text, p_frage text, p_erklaerung_long text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_frage_id int;
begin
  -- Erst versuchen: exakter Match (getrimmt, case-insensitive)
  select f.id into v_frage_id
  from fragen f
  join module m on m.id = f.modul_id
  left join themen t on t.id = f.thema_id
  where m.name = p_modul_name
    and (p_thema_name is null or t.name = p_thema_name)
    and lower(trim(f.frage)) = lower(trim(p_frage))
  limit 1;

  -- Fallback: "enthält"-Match (ILIKE), falls noch nicht gefunden
  if v_frage_id is null then
    select f.id into v_frage_id
    from fragen f
    join module m on m.id = f.modul_id
    left join themen t on t.id = f.thema_id
    where m.name = p_modul_name
      and (p_thema_name is null or t.name = p_thema_name)
      and f.frage ilike '%' || trim(p_frage) || '%'
    order by f.id
    limit 1;
  end if;

  if v_frage_id is null then
    raise notice 'Frage nicht gefunden (Modul=%, Thema=%, Suche=%)', p_modul_name, p_thema_name, p_frage;
    return;
  end if;

  update fragen
     set erklaerung = p_erklaerung_long
   where id = v_frage_id;
end;
$function$
;

CREATE TRIGGER trg_didactic_expl_aiu BEFORE INSERT OR UPDATE ON public.antworten FOR EACH ROW EXECUTE FUNCTION didactic_explanation_sync();

CREATE TRIGGER trg_default_question_difficulty BEFORE INSERT OR UPDATE ON public.fragen FOR EACH ROW EXECUTE FUNCTION set_default_question_difficulty();


