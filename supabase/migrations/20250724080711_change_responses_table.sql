ALTER TABLE "public"."escalation_responses" 
    Drop column escalation_id;

ALTER TABLE "public"."escalation_responses" 
    ADD COLUMN escalation_id bigint;

UPDATE "public"."escalation_responses" 
    SET escalation_id = e.id
    FROM "public"."escalated_tickets" e
    WHERE "public"."escalation_responses".subject = e.gc_name;


ALTER TABLE "public"."escalation_responses" 
    ADD CONSTRAINT fk_escalation_id
    FOREIGN KEY (escalation_id)
    REFERENCES "public"."escalated_tickets"(id)
    ON DELETE SET NULL