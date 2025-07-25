create table "public"."emails" (
    "id" uuid not null default gen_random_uuid(),
    "message_id" text,
    "subject" text,
    "body_plain" text,
    "body_html" text,
    "received_at" timestamp with time zone,
    "sent_at" timestamp with time zone,
    "in_reply_to" text,
    "reference_ids" text[],
    "thread_id" uuid,
    "is_read" boolean default false,
    "is_flagged" boolean default false,
    "folder" text,
    "from_address" text
);


create table "public"."threads" (
    "id" uuid not null default gen_random_uuid(),
    "subject_hash" text,
    "started_at" timestamp with time zone,
    "updated_at" timestamp with time zone
);


CREATE UNIQUE INDEX emails_message_id_key ON public.emails USING btree (message_id);

CREATE UNIQUE INDEX emails_pkey ON public.emails USING btree (id);

CREATE UNIQUE INDEX threads_pkey ON public.threads USING btree (id);

alter table "public"."emails" add constraint "emails_pkey" PRIMARY KEY using index "emails_pkey";

alter table "public"."threads" add constraint "threads_pkey" PRIMARY KEY using index "threads_pkey";

alter table "public"."emails" add constraint "emails_message_id_key" UNIQUE using index "emails_message_id_key";

alter table "public"."emails" add constraint "emails_thread_id_fkey" FOREIGN KEY (thread_id) REFERENCES threads(id) not valid;

alter table "public"."emails" validate constraint "emails_thread_id_fkey";

grant delete on table "public"."emails" to "anon";

grant insert on table "public"."emails" to "anon";

grant references on table "public"."emails" to "anon";

grant select on table "public"."emails" to "anon";

grant trigger on table "public"."emails" to "anon";

grant truncate on table "public"."emails" to "anon";

grant update on table "public"."emails" to "anon";

grant delete on table "public"."emails" to "authenticated";

grant insert on table "public"."emails" to "authenticated";

grant references on table "public"."emails" to "authenticated";

grant select on table "public"."emails" to "authenticated";

grant trigger on table "public"."emails" to "authenticated";

grant truncate on table "public"."emails" to "authenticated";

grant update on table "public"."emails" to "authenticated";

grant delete on table "public"."emails" to "service_role";

grant insert on table "public"."emails" to "service_role";

grant references on table "public"."emails" to "service_role";

grant select on table "public"."emails" to "service_role";

grant trigger on table "public"."emails" to "service_role";

grant truncate on table "public"."emails" to "service_role";

grant update on table "public"."emails" to "service_role";

grant delete on table "public"."threads" to "anon";

grant insert on table "public"."threads" to "anon";

grant references on table "public"."threads" to "anon";

grant select on table "public"."threads" to "anon";

grant trigger on table "public"."threads" to "anon";

grant truncate on table "public"."threads" to "anon";

grant update on table "public"."threads" to "anon";

grant delete on table "public"."threads" to "authenticated";

grant insert on table "public"."threads" to "authenticated";

grant references on table "public"."threads" to "authenticated";

grant select on table "public"."threads" to "authenticated";

grant trigger on table "public"."threads" to "authenticated";

grant truncate on table "public"."threads" to "authenticated";

grant update on table "public"."threads" to "authenticated";

grant delete on table "public"."threads" to "service_role";

grant insert on table "public"."threads" to "service_role";

grant references on table "public"."threads" to "service_role";

grant select on table "public"."threads" to "service_role";

grant trigger on table "public"."threads" to "service_role";

grant truncate on table "public"."threads" to "service_role";

grant update on table "public"."threads" to "service_role";


