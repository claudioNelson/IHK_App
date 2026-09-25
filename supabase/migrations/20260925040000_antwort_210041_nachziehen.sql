-- Nachzug zu 20260925030000: Antwort 210041 (Frage 110011, Deckungsbeitrag).
-- Der Trigger didactic_explanation_sync baut die Erklaerung falscher Antworten
-- aus dem Text der richtigen Antwort. 210041 wurde VOR der richtigen Antwort
-- 210042 aktualisiert und bekam deshalb noch den alten Text mit Strich.
-- Ein leeres Update loest den Trigger erneut aus, jetzt mit dem neuen Text.
begin;
update antworten set text = text where id = 210041;
commit;

-- Kontrolle (Erwartung 0):
-- select count(*) from antworten
--  where text ~ ('[' || chr(8212) || chr(8211) || ']')
--     or coalesce(erklaerung, '') ~ ('[' || chr(8212) || chr(8211) || ']');
