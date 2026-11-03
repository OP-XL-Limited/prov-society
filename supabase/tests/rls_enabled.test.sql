-- SECX-09 / ENG-08: every table in public has RLS enabled and forced, and
-- anonymous and authenticated roles hold no direct grants by default.
begin;
select plan(4);

select is(
  (select count(*)::int from pg_class c
     join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity),
  0,
  'SECX-09 every public table has row level security enabled'
);

select is(
  (select count(*)::int from pg_class c
     join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r' and not c.relforcerowsecurity),
  0,
  'SECX-09 every public table forces row level security'
);

set local role anon;
select throws_ok(
  $$ select * from public.settings $$,
  '42501',
  null,
  'SECX-09 anonymous role cannot read settings'
);
reset role;

set local role authenticated;
select throws_ok(
  $$ select * from public.job_runs $$,
  '42501',
  null,
  'SECX-09 an ordinary member cannot read job_runs'
);
reset role;

select * from finish();
rollback;
