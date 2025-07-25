🧱 Supabase Schema & RLS Best Practices
Simple Team Workflow for Small Databases
🎯 Purpose
This document outlines our best-practice workflow for managing PostgreSQL schema and Row-Level Security (RLS) in Supabase using version control and the Supabase CLI.

This approach is designed for small teams working with simple databases—keeping everything clean, trackable, and deployable with zero guesswork.

✅ Why This Matters
Avoiding the GUI trap (Supabase Dashboard, pgAdmin): - ❌ GUI changes are instant and untracked - ❌ No audit trail, no rollback capability - ❌ Easy to accidentally break production or development environments - ❌ RLS policies are hidden from code reviewers - ❌ Team members get out of sync

Benefits of CLI + Git approach: - 🧠 Everything lives in Git — full version history - ✅ Changes can be code-reviewed, tested, and approved - 🔄 Easy to reproduce environments (dev/staging/prod) - 🛡️ RLS policies are visible, testable, and consistent - 💥 Reduced risk, better control, cleaner development workflow

🚀 Workflow Overview
Write schema changes in SQL migration files
Save files in /supabase/migrations/ and commit to Git
Apply changes using Supabase CLI
Sync all team members from common schema state
Include RLS policies alongside tables, tracked in version control
🔧 Setup Instructions
1. Install Supabase CLI
npm install -g supabase

sucessfully installed


2. Initialize Supabase Project
If starting fresh:

supabase init
This creates:

supabase/
├── config.toml
├── migrations/
└── seed.sql
3. Link to Remote Project
Connect your local setup to your Supabase project:

supabase link --project-ref your-project-ref
4. Create Migration Files
Create descriptively named migration files:

supabase/migrations/20250723120000_add_users_table.sql
Example migration:

-- Create users table with RLS
create table public.users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  full_name text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.users enable row level security;

-- Create policies
create policy "Users can read own data" 
  on public.users for select 
  using (auth.uid() = id);

create policy "Users can update own data" 
  on public.users for update 
  using (auth.uid() = id);

-- Create updated_at trigger
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger handle_users_updated_at
  before update on public.users
  for each row execute function public.handle_updated_at();
5. Apply Migrations
For local development:

supabase db reset  # Resets local DB and applies all migrations
For remote environments:

supabase db push  # Applies new migrations to remote DB
💡 Best Practices & Conventions
File Naming
Use timestamps: YYYYMMDDHHMMSS_description.sql
Be descriptive: 20250723120000_add_user_profiles_with_rls.sql
One logical change per migration
Migration Content
Always include RLS policies when creating tables
Add comments for complex logic
Use explicit schema names (public.users not just users)
Include necessary indexes for performance
Git Workflow
One migration per PR when possible
Never modify existing migration files — create new ones instead
Review migrations like any other code
Test locally before pushing to remote
Example Migration Types
Adding a new table:

-- 20250723120000_add_posts_table.sql
create table public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.users(id) on delete cascade,
  title text not null,
  content text,
  published boolean default false,
  created_at timestamptz default now()
);

alter table public.posts enable row level security;

create policy "Users can read published posts" 
  on public.posts for select 
  using (published = true);

create policy "Users can manage own posts" 
  on public.posts for all 
  using (auth.uid() = user_id);
Adding a column:

-- 20250724130000_add_avatar_url_to_users.sql
alter table public.users 
add column avatar_url text;
Modifying RLS policies:

-- 20250725140000_update_posts_read_policy.sql
drop policy "Users can read published posts" on public.posts;

create policy "Users can read published posts or own drafts" 
  on public.posts for select 
  using (published = true or auth.uid() = user_id);
📂 Project Structure
your-app/
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   │   ├── 20250723120000_add_users_table.sql
│   │   ├── 20250724130000_add_posts_table.sql
│   │   └── 20250725140000_add_user_profiles.sql
│   └── seed.sql
├── src/
├── package.json
└── README.md
🧪 Team Git Workflow
Create feature branch: git checkout -b feature/add-user-profiles
Add migration: Create new .sql file in supabase/migrations/
Test locally: supabase db reset to verify migration works
Commit changes: git add . && git commit -m "Add user profiles table"
Push & create PR: Standard code review process
After merge: Deploy with supabase db push
🛡️ Row-Level Security (RLS) Guidelines
Key Principles
Secure by default: Supabase requires explicit policies for table access
Database-level enforcement: RLS runs at PostgreSQL level, not just API
Include with table creation: Add policies in same migration as table
Common Policy Patterns
User owns resource:

create policy "Users manage own records" 
  on table_name for all 
  using (auth.uid() = user_id);
Public read, authenticated write:

create policy "Public read access" 
  on table_name for select 
  using (true);

create policy "Authenticated users can insert" 
  on table_name for insert 
  with check (auth.role() = 'authenticated');
Role-based access:

create policy "Admins have full access" 
  on table_name for all 
  using (auth.jwt() ->> 'role' = 'admin');
🔧 Common Commands Reference
# Initialize new project
supabase init

# Link to remote project
supabase link --project-ref your-ref

# Start local development
supabase start

# Reset local DB (applies all migrations)
supabase db reset

# Apply new migrations to remote
supabase db push

# Generate migration from schema diff
supabase db diff -f new_migration_name

# View local database URL
supabase status
⚡ Quick Troubleshooting
Migration fails? - Check SQL syntax in your migration file - Ensure you're not modifying existing migrations - Verify foreign key references exist

RLS blocking access? - Check that policies exist for your use case - Verify auth.uid() is returning expected value - Test policies in SQL editor first

Team out of sync? - Everyone should git pull and supabase db reset after schema changes - Use supabase db diff to see what's different

📊 Workflow Comparison
Feature	This Workflow	GUI-Only Approach
Version control	✅ Full Git history	❌ No tracking
Code review	✅ PR-based review	❌ No review process
Environment parity	✅ Consistent across envs	❌ Manual sync required
Rollback capability	✅ Git revert + new migration	❌ Manual fixes only
Team collaboration	✅ Merge conflicts prevent issues	❌ Last-change-wins
RLS visibility	✅ Policies in code	❌ Hidden in GUI
🤝 Getting Help
Questions about workflow? Ask in our dev channel
Complex schema changes? Pair with a senior developer
RLS policy help? Check Supabase docs or ask for review
Migration issues? Never force-fix in production — create a new migration
Remember: Schema changes are permanent and affect everyone. When in doubt, ask for a second pair of eyes! 👀