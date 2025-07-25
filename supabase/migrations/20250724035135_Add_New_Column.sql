
ALTER TABLE "public"."escalated_tickets" 
    ADD COLUMN comp_id bigint,
    ADD COLUMN hoz_id bigint;

UPDATE "public"."escalated_tickets" 
    SET comp_id = c.id
    FROM "public"."Company" c
    WHERE "public"."escalated_tickets".comp_name = c.title;

UPDATE "public"."escalated_tickets" 
    SET hoz_id = h.id
    FROM "public"."HozTeam" h
    WHERE "public"."escalated_tickets".hoz_team = h.title;

ALTER TABLE "public"."escalated_tickets" 
    ADD CONSTRAINT fk_comp_id
    FOREIGN KEY (comp_id)
    REFERENCES "public"."Company"(id)
    ON DELETE SET NULL,
    ADD CONSTRAINT fk_hoz_id
    FOREIGN KEY (hoz_id) REFERENCES "public"."HozTeam"(id) ON DELETE SET NULL;
