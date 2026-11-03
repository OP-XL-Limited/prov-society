# Security

Baseline: OWASP MASVS (L1 plus resilience) for the mobile app, ASVS Level 2 for the admin app, public pages and Edge Functions, and the API Security Top 10 for every endpoint. Requirement IDs are SPEC section 19 (SECX).

Security contact: published at `/.well-known/security.txt` before launch (SECX-21).

## Controls in place

| Area | Control | Requirement |
|---|---|---|
| Secrets | `.env` files are git-ignored; gitleaks scans full history on every push and pull request | SECX-18 |
| Dependencies | Versions pinned, lockfiles enforced, OSV-Scanner fails CI on high severity, actions pinned to commit SHAs | SECX-07 |
| Mobile build | Only the Supabase anon key and public SDK keys can appear in the build | SECX-03 |
| Database | RLS enabled and forced on every table, deny-by-default, tested in CI | SECX-09 |

## Threat model

To be completed with the controls that answer each threat (SECX-20).

| Threat | Control |
|---|---|
| Stalking a collector to steal bottles | Pending |
| Fake verification | Pending |
| Invite abuse | Pending |
| Account takeover | Pending |
| Data leak of values | Pending |

## MASTG results

Recorded before each store submission (SECX-19). None yet.
