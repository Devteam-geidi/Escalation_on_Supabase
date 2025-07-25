alter table "public"."escalation_responses" add column "escalation_id" bigint;

UPDATE "public"."escalation_responses" 
    SET escalation_id = e.id
    FROM "public"."escalated_tickets" e
    WHERE "public"."escalation_responses".subject = e.gc_name;

alter table "public"."escalation_responses" add constraint "fk_escalation_id" FOREIGN KEY (escalation_id) REFERENCES escalated_tickets(id) ON DELETE SET NULL;

alter table "public"."escalation_responses" validate constraint "fk_escalation_id";


