---
name: provenance-phase-review
description: Use at the end of every build phase in SPEC section 8 and 17, before starting the next phase or reporting progress.
---

# Provenance phase review

A phase is not done until every step below passes.

## Steps
1. List every checklist ID (SPEC sections 12, 14 to 20) that belongs to this phase.
2. For each ID, confirm the feature exists and name the test that proves it.
3. Run the provenance-testing skill's full run sequence. All must pass.
4. Search the codebase for TODO, FIXME, UnimplementedError and placeholder screens in this phase's code. Resolve them all.
5. Run the design lint and review screenshots with the provenance-design-system skill, including the section 20 principles (PSY and WEBD-03 are checked every phase).
6. Launch the app on the iOS simulator and walk through the phase's main flows.
7. Commit with message: "Phase N: <summary> (IDs: ...)".

## Update docs/PROGRESS.md
- Full checklist table: ID, status (Done, Partial, Not started), proving test, commit.
- PSY-16 note per new screen: which principle shaped it, and what makes it unlike a generic app.
- "Mocked or stubbed" list.
- "Needs real-device or real-key check" list: always include haptics, Face ID, NFC, camera, Wallet passes, widgets and push.
- Exact commands to run the app and tests.
- Blockers and the decision needed from Felix.

## Then
Start the next phase. Do not stop to ask unless blocked by a missing key, licence or paid service.
