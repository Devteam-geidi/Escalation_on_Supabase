
alter table "public"."Company" enable row level security;

alter table "public"."HozTeam" enable row level security;

alter table "public"."dev_bug_tracker" enable row level security;


alter table "public"."emails" enable row level security;

alter table "public"."escalation_activity_log" enable row level security;

alter table "public"."escalation_responses" enable row level security;

alter table "public"."flow_error_logs" enable row level security;

alter table "public"."incident_reports" enable row level security;

alter table "public"."threads" alter column "id" set default gen_random_uuid();

alter table "public"."threads" enable row level security;



