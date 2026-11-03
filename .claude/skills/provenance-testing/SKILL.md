---
name: provenance-testing
description: Use when writing or running tests, goldens, screenshots or simulator runs for the Provenance app.
---

# Provenance testing

## Naming
- Every test name starts with its checklist ID from SPEC section 12 (and sections 14 to 20), e.g. test('VAULT-05 cost per wear shows dash before first wear').
- Each checklist ID needs at least one test proving its pass condition.
- Commit messages reference the same IDs (Conventional Commits, ENG-09).

## Test types
- Unit: every calculation in SPEC section 5 (ranks, rarity points, recognition weight, percentile, holder counts, cost per wear, empty forecast, suggestions, Nose rating). Include edge cases: zero wears, empty collection, holder count of 1.
- Widget and golden: every screen, both themes, default and large text scale. Store goldens in test/goldens/.
- Integration (integration_test or Patrol): onboarding with invite, add and verify bottle, log wear and compliment, paywall sandbox purchase, viewing grant expiry, provenance transfer.
- Security: tests proving Row Level Security blocks non-owners from bottles, wears, prices and compliments (SECX-09 runs as anonymous, another member and each staff role); a test proving uploads contain no EXIF or location.
- Rank integrity: a test proving payment status never changes rank score.
- Backend: each Edge Function has its own tests (ENG-08). Admin app: lint, type-check and tests (ENG-07).

## Running
1. flutter analyze (must be clean; very_good_analysis, zero warnings).
2. Design lint (fails on raw Color(, Colors., literal TextStyle fonts, Curves. outside tokens).
3. flutter test.
4. flutter test integration_test on the iOS simulator, then the Android emulator.
5. Admin app: lint, tsc --noEmit, tests. Edge Functions: deno test.
6. Security scans: gitleaks, OSV-Scanner, flutter pub outdated.
7. Capture screenshots of every new screen into screenshots/<phase>/ (Nocturne and Atelier, default and large text).

## Rules
- Never delete or weaken a failing test to make it pass. Fix the code.
- Never mark a test skip without listing it in PROGRESS.md with the reason.
- Use mock repositories when backend keys are missing; note each in PROGRESS.md.
- Tests must not use real location, real payment or real personal data.
