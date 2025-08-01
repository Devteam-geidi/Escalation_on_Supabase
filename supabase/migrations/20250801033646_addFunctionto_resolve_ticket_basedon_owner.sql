set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.resolve_ticket_for_tech(p_email text, p_ticket_id integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  updated_rows integer;
BEGIN
  UPDATE escalated_tickets
  SET status = 'Resolved'
  WHERE id = p_ticket_id AND tech_email = p_email;

  GET DIAGNOSTICS updated_rows = ROW_COUNT;

  IF updated_rows = 0 THEN
    RETURN 'Unauthorized or ticket not found';
  ELSE
    RETURN 'Ticket successfully resolved';
  END IF;
END;
$function$
;


