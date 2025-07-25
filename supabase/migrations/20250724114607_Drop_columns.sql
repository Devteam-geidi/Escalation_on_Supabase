alter table "public"."escalated_tickets" drop constraint "Escalated Tickets_comp_name_fkey";

alter table "public"."escalated_tickets" drop constraint "Escalated Tickets_hoz_team_fkey";

alter table "public"."escalation_responses" drop constraint "escalation_responses_subject_fkey";

alter table "public"."escalated_tickets" drop column "comp_name";

alter table "public"."escalated_tickets" drop column "hoz_team";

alter table "public"."escalation_responses" drop column "subject";


