-- Baseline (REPO-03: schema changes only via migration files).
-- Deny-by-default: RLS is enabled on every table and no policy means no access.
-- Only the service role (Edge Functions, admin server) bypasses RLS (SECX-09, SECX-13).

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Tunable values such as rank thresholds (MEM-03) and rarity points (SPEC 5).
create table public.settings (
  key text primary key,
  value jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.settings enable row level security;
alter table public.settings force row level security;
create trigger settings_updated_at before update on public.settings
  for each row execute function public.set_updated_at();

-- One row per background job run (JOB-01..07); failures surface on the admin overview.
create table public.job_runs (
  id bigint generated always as identity primary key,
  job text not null,
  status text not null check (status in ('running', 'succeeded', 'failed')),
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.job_runs enable row level security;
alter table public.job_runs force row level security;
create index job_runs_job_started_idx on public.job_runs (job, started_at desc);
create trigger job_runs_updated_at before update on public.job_runs
  for each row execute function public.set_updated_at();

-- Default grants would let anon/authenticated attempt access; RLS still blocks,
-- but revoke so the surface is closed at both layers.
revoke all on public.settings from anon, authenticated;
revoke all on public.job_runs from anon, authenticated;
