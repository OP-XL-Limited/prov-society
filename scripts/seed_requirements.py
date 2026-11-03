#!/usr/bin/env python3
"""One-off generator for docs/requirements.json. After this, edit the JSON (status/test/commit) directly."""
import json
R = []
def add(phase, pairs):
    for i, t in pairs:
        R.append({"id": i, "title": t, "phase": phase, "status": "Not started", "test": "", "commit": ""})
# Phase 0
add("0", [("REPO-01","Per-app CI, path-filtered"),("REPO-02","Generated TS and Dart types from schema"),("REPO-03","Schema changes only via migrations"),("REPO-04","Root README with run commands"),
 ("OPS-01","Three environments, .env.example per app"),("OPS-02","Keys inventory with mocks until supplied"),
 ("SECX-03","Platform crypto only, anon key only in build"),("SECX-07","Pinned deps, pub outdated, OSV scan in CI"),("SECX-18","Secret stores, gitleaks in CI"),
 ("ENG-01","Effective Dart, very_good_analysis, zero warnings"),("ENG-02","Feature-first folders, repositories behind interfaces"),("ENG-03","Riverpod codegen, freezed, typed results"),
 ("ENG-07","TypeScript strict, ESLint, Prettier, Server Components, zod"),("ENG-08","Edge Functions in Deno with tests, RLS reviewed per migration"),
 ("ENG-09","Conventional Commits with IDs, CI runs all checks"),("ENG-10","Security follows section 19"),("WEBD-03","Shared tokens.json generates Dart and Tailwind"),
 ("DS-01","Design tokens"),("DS-03","Contrast meets WCAG AA")])
# Phase 1
add("1", [("DS-02","Two themes"),("DS-04","3D icons via AppIcon"),("DS-05","Reduced motion"),("NAV-01","Custom tab bar"),
 ("ENG-04","Platform guidelines for system behaviour"),("ENG-05","WCAG 2.2 AA, 44 pt targets, labels"),("ENG-06","Performance targets"),
 ("PSY-01","Discretion is the luxury"),("PSY-02","Earned, never bought"),("PSY-03","Honest scarcity"),("PSY-04","Recognition weighted by knowledge"),
 ("PSY-05","Ritual over habit loops"),("PSY-06","Ceremony at real milestones only"),("PSY-07","The object is the hero"),("PSY-08","Language of the house"),
 ("PSY-09","Safety you can feel"),("PSY-15","Anti-patterns fail review"),("PSY-16","Per-screen principle note")])
# Phase 2
add("2", [("VAULT-01","Add bottle"),("VAULT-02","Shelf views"),("VAULT-03","Biometric lock"),("VAULT-04","Bottle detail"),("VAULT-05","Cost per wear"),("VAULT-06","Empty forecast"),
 ("VAULT-07","Preservation mode"),("VAULT-08","Samples"),("VAULT-09","Insights"),("NAV-02","Transitions"),("SEC-01","No location"),
 ("SYNC-02","Drift source of truth, merge rules"),("SYNC-03","Local data uploads on sign-up"),("CAT-01","Seeded catalogue of 300+"),("CAT-02","Member-submitted fragrances"),
 ("UX-01","Empty, loading, error states"),("UX-02","Screen reader labels, large text"),("UX-03","Currency, locale, ARB strings"),
 ("SECX-01","Keychain and SQLCipher"),("SECX-02","Backup exclusion, app switcher blur"),("SECX-04","Biometric tied to Keychain item, 5 min relock"),
 ("PSY-10","Signature: the Vault opening"),("PSY-13","Signature: the catalogue entry")])
# Phase 3
add("3", [("TODAY-01","Suggestions"),("TODAY-02","Occasion and seeing tags"),("TODAY-03","Don't-repeat warning"),("TODAY-04","Notifications"),("TODAY-05","Compliment log")])
# Phase 4
add("4", [("ONB-01","Invite gate"),("ONB-02","Waitlist"),("ONB-03","Sign-in"),("VAULT-10","Free limit"),("PAY-01","Subscriptions"),("PAY-02","Founding Patron"),("SEC-02","Row Level Security"),
 ("MEM-01","Four access states"),("MEM-04","Invite allowances"),("DATA-01","Missing tables"),("DATA-02","Member columns"),("DATA-03","Foreign key delete rules"),("SYNC-01","Private buckets, signed URLs, thumbnails"),
 ("SECX-05","TLS, key pinning"),("SECX-09","RLS deny-by-default with role tests"),("SECX-10","Staff 2FA, session expiry, lockout"),("SECX-11","Explicit field lists, private fields"),
 ("SECX-12","Rate limits, upload validation"),("SECX-13","Service role server-only"),("SECX-14","Transactional business flows, webhook signature")])
# Phase 5
add("5", [("SOC-01","Verification"),("SOC-02","Rarity tiers"),("SOC-03","Ranks"),("SOC-04","Rank-up ceremony"),("SOC-05","Sealed profile"),("SOC-09","Holder counts"),("SOC-10","Rarity percentile"),
 ("MEM-02","Founding Curator flag"),("MEM-03","Rank thresholds and points"),("CAT-03","Batch code rules"),("VER-01","Staff review until 20 Curators"),("VER-02","Peer review after 20 Curators"),
 ("VER-03","72 hour target"),("VER-04","Reviewers never see handle"),("VAL-01","Bottle value rules"),("VAL-02","Collection value behind biometrics"),("VAL-03","Sale prices in aggregate only"),
 ("PSY-11","Signature: the seal"),("PSY-12","Signature: the veiled profile")])
# Phase 6
add("6", [("SOC-07","Recognition"),("SOC-08","Rankings hall"),("WANT-01","Wanted list"),("SEC-03","Reporting and blocking"),("MSG-01","Replies only"),("MSG-02","Request then accept"),
 ("MSG-03","Text only, pattern filter"),("MSG-04","Rate limit"),("NOTIF-01","Notification types"),("NOTIF-02","Per-type switches, quiet hours"),("NOTIF-03","Max 4 pushes a day"),("PSY-14","Signature: the hall")])
# Phase 7
add("7", [("EXH-01","Exhibitions"),("SOC-06","Viewing grants"),("PROV-01","Transfer"),("PROV-02","NFC caps"),("WEB-02","Universal and App Links"),("WEB-03","App Clip or documented deferral"),("WEB-04","Public provenance card fields")])
# Phase 8, 9, 10
add("8", [("CIRC-01","Blind Circles")])
add("9", [("ME-01","Wallet card"),("ME-02","Year in Scent"),("ME-04","Settings"),("WID-01","Widgets")])
# 11-16
add("11", [("INV-01","Invite counts by rank"),("INV-02","Sponsor link hidden by default"),("INV-03","Application and waitlist approval"),("INV-04","Fake verification penalty"),("ME-03","Invites screen")])
add("12", [("PHO-01","In-app camera"),("PHO-02","On-device background removal and plinth"),("PHO-03","Strip EXIF, optional blur"),("PHO-04","Photos across surfaces"),("PHO-05","Member photos only"),
 ("SHR-01","Hallmark on exports"),("SHR-02","One bottle at a time, no value or location"),("SHR-03","Waitlist or App Clip link"),("SHR-04","Square, story, print formats")])
add("13", [(f"REQ-0{i}", t) for i, t in enumerate(["Requests board","Rank-weighted votes","Request statuses","Shipped notifications","Duplicate merge","Free users read only","Tables with RLS"], 1)])
add("14", [("ADM-01","Staff roles enforced by RLS"),("ADM-09","Audit log"),("ADM-10","Nocturne tokens, functional layout"),("WEB-01","Public landing, waitlist, legal, provenance card"),("OPS-04","Owner creation script"),
 ("SECX-15","Injection, XSS, CSP, CSRF"),("SECX-16","No user-supplied URL fetches, schema validation"),("SECX-17","Security logging and alerts"),
 ("WEBD-01","Public pages as catalogue opening"),("WEBD-02","Dense admin with shortcuts"),("WEBD-04","Self-hosted fonts, Lighthouse 90+")])
add("15", [("ADM-02","Waitlist queue"),("ADM-03","Member management"),("ADM-04","Sponsor tree"),("ADM-05","Verification disputes"),("ADM-06","Curator outreach tracker"),("ADM-07","Feature request admin"),("ADM-08","Overview page")])
add("16", [("JOB-01","Rank scores and percentiles"),("JOB-02","Expire viewing grants"),("JOB-03","Wanted alerts"),("JOB-04","Holder counts and rarity stats"),("JOB-05","Invite top-ups"),("JOB-06","Weekly owner email"),("JOB-07","Cleanup"),("OPS-03","Sentry and events table")])
add("Before submission", [("STORE-01","Reviewer demo account"),("STORE-02","UGC rules"),("STORE-03","Sign in with Apple parity"),("STORE-04","Deletion, privacy and terms links"),("STORE-05","Store listing assets"),
 ("SECX-06","Deep link validation, no WebViews"),("SECX-08","Obfuscation, jailbreak detection, attestation"),("SECX-19","MASTG pass recorded"),("SECX-20","Threat model"),("SECX-21","security.txt")])
ids = [r["id"] for r in R]
assert len(ids) == len(set(ids)), [i for i in ids if ids.count(i) > 1]
json.dump(R, open("docs/requirements.json", "w"), indent=2, ensure_ascii=False)
print(len(R), "requirements")
