# Provenance Society

A private society for serious fragrance collectors. Flutter app (iOS first, Android second), a Next.js admin and public site, and a Supabase backend, in one repository.

Read `docs/SPEC.md` before changing anything, and `docs/PLAYBOOK.md` for the brand voice. Build status lives in `docs/PROGRESS.md`.

```
apps/mobile      Flutter app
apps/admin       Next.js admin dashboard and public pages (Vercel root directory)
packages/tokens  tokens.json, the single source of design tokens
supabase/        migrations, Edge Functions, seed, database tests
docs/            SPEC, PLAYBOOK, PROGRESS, SECURITY
scripts/         type generation, progress report, repo tests
.claude/skills/  design-system, testing, phase-review, marketing
.github/         CI per app, security scans
```

## Requirements

Flutter 3.44 (stable), Node 22 (`.nvmrc`), Docker, the Supabase CLI, `gitleaks` and `osv-scanner` for local security scans.

## Setup

```sh
npm install                      # admin dependencies and workspace tooling
supabase start                   # local Postgres, Auth, Storage (needs Docker)
cp apps/mobile/.env.example apps/mobile/.env
cp apps/admin/.env.example apps/admin/.env.local
cp supabase/.env.example supabase/.env
```

Fill the local anon key from the output of `supabase start`. Without keys the apps run against mock repositories; each mock is listed in `docs/PROGRESS.md`. Real `.env` files are never committed.

## Run

```sh
# Mobile
cd apps/mobile
flutter pub get && flutter gen-l10n
flutter run --dart-define-from-file=.env

# Admin
npm run dev --workspace provenance-admin

# Local Supabase stack
supabase start
supabase db reset                # replay every migration and the seed
supabase test db                 # row level security and schema tests
supabase stop
```

## Checks

```sh
# Mobile
cd apps/mobile
dart format --set-exit-if-changed lib test tool
flutter analyze --fatal-infos
dart run tool/design_lint.dart   # fails on raw colours, curves, icon fonts, default Material
flutter test

# Admin
npm run lint --workspace provenance-admin
npm run typecheck --workspace provenance-admin
npm test --workspace provenance-admin

# Repo
npm run check                    # tokens fresh, contrast, repo tests, PROGRESS.md in sync
gitleaks git --redact .
osv-scanner scan source --recursive .
```

## Design tokens

Edit `packages/tokens/tokens.json`, then run `npm run tokens`. This regenerates the Dart token classes in `apps/mobile/lib/design/tokens/` and the Tailwind theme in `apps/admin/src/design/tokens.css`. CI fails if the generated files are stale.

## Schema and types

Schema changes are made only by adding files to `supabase/migrations/`, never in the dashboard. After a migration, run `supabase db reset` then `npm run types` to regenerate `apps/admin/src/lib/database.types.ts` and `apps/mobile/lib/data/remote/models.g.dart`.

## Progress report

Statuses live in `docs/requirements.json` and `docs/progress.meta.json`. Run `npm run progress` to render `docs/PROGRESS.md`.

## Continuous integration and branches

`main` is protected: work happens on a branch per phase (`phase-1`, `phase-2`, ...), goes through a pull request and is squash-merged once CI is green.

`.github/workflows/ci.yml` is the single entrypoint. It runs `security` and `repo` on every change, and `mobile`, `admin` and `supabase` only when their folders (or `packages/tokens/`, `supabase/`) change. The `ci-ok` job always runs and passes only if every workflow that ran passed; skipped workflows count as passing. `ci-ok` is the one required status check.
