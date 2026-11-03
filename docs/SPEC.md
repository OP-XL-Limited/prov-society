Provenance Society — Build Spec for Claude Code
A private society for serious fragrance collectors. Flutter app targeting iOS first, Android second. Read this whole file before writing code. Build in the phase order in the final section. Do not skip the design system: visual quality is a hard requirement, not polish for later.
1. Product summary
Provenance has two layers.
• The Vault (private, daily use): the user's collection, wear logging, cost per wear, compliment log, "don't repeat" memory, bottle level and empty forecast, preservation mode for rare bottles, batch and age tracking, sample and decant log, Year in Scent.
• The Society (status, controlled reveal): verified bottles, rarity tiers, earned ranks, sealed profiles, weighted recognition, holder counts, Wanted list alerts, rarity percentile, Exhibitions, provenance transfer, Blind Circles and Nose rating, invite-only access, Founding Patron numbers.
Core principles:
1. Status comes from verified rarity, discernment and time held, never from money spent. Payment never raises rank.
2. Private by default. Nothing about a collection is public unless the owner reveals it.
3. Every scarcity number shown must be real data. No fake counts.
4. Physical safety: never store or display location; strip all photo metadata; value figures always sit behind Face ID / biometrics.
2. Tech stack
• Flutter (latest stable), Dart null safety, single codebase for iOS and Android.
• State: Riverpod (with code generation).
• Routing: go_router with custom page transitions (see section 5).
• Local storage: Drift (SQLite), offline-first. All Vault features must work with no network.
• Backend: Supabase (Postgres, Auth, Storage, Row Level Security, Edge Functions). RLS must enforce privacy: a collection row is readable only by its owner or by a user holding an active viewing grant.
• Payments: RevenueCat across App Store and Google Play. Products: monthly $2.99, lifetime $19.99, Founding Patron (non-consumable, capped at 500, numbered server-side).
• Biometrics: local_auth for Vault lock and value figures.
• Camera and scanning: camera plus mobile_scanner for barcodes and batch-code capture; strip EXIF before upload.
• NFC: nfc_manager for optional NFC caps (read on both platforms; write support where the platform allows).
• Widgets: home_widget for iOS Home and Lock Screen widgets and Android home widgets.
• Apple Wallet: membership pass (.pkpass) generated and signed server-side in an Edge Function; Android equivalent via Google Wallet generic pass.
• Notifications: flutter_local_notifications for the morning "wearing today" prompt and evening compliment prompt; push via FCM/APNs for Wanted list alerts.
• Weather: a weather API called with coarse city-level location only, entered manually or approximated, never stored.
• Animation: flutter_animate for choreography, Rive for hero moments (rank ascension, verification seal), custom shaders (FragmentProgram) for glass and liquid effects.
• Testing: flutter_test, integration_test, golden tests for every screen, Patrol for native permission flows.
3. Design direction
The reference is not a luxury-brand template. No black-and-gold, no generic glassmorphism, no default Material look. Think a private members' archive: aged paper, smoked glass, lacquer, apothecary labels, museum catalogue typography. Every screen should feel composed, like a printed object, with motion that feels heavy and deliberate, like a cabinet drawer or a glass stopper.
3.1 Colour system
Two themes: Nocturne (default, dark) and Atelier (light). Define all colours as named tokens; never hard-code.
Nocturne:
• Ink — background, #0F0E0D
• Smoke — raised surface, #1A1817
• Lacquer — deep accent surface, #2A1416 (oxblood-black)
• Vellum — primary text, #ECE4D6
• Ash — secondary text, #9A9186
• Verdigris — primary accent, #6E9A8C (aged copper patina)
• Oxblood — rank and rarity accent, #7A2630
• Resin — warm highlight, used sparingly, #B9864F
• Hairline — dividers, Vellum at 10% opacity
Atelier: Vellum background #F2ECE1, Ink text, same accents slightly deepened for contrast.
Rarity tier colours (used on seals, chips and bottle halos):
• In production — Ash
• Reformulated — Resin
• Discontinued — Verdigris
• Vintage — Oxblood
• Numbered limited — iridescent shader (slow hue drift between Verdigris, Resin and Oxblood)
All text must meet WCAG AA contrast against its surface.
3.2 Typography
• Display: a high-contrast editorial serif (for example Fraunces, or a licensed face such as Canela if budget allows). Used for bottle names, rank titles and screen titles, with optical sizing and tight tracking at large sizes.
• Text: a refined grotesk (for example Inter Tight or Söhne if licensed) for body and UI.
• Numerals: tabular figures for all stats; small caps for labels such as BATCH, HELD SINCE, RARITY.
• Build a type scale as tokens: displayXL, displayL, titleM, bodyM, labelS, numeralL.
3.3 Icons
Custom 3D glossy icons, not an icon font. Style: soft, rendered, plastic-lacquer finish with specular highlights and gentle shadow, like collectible objects. Tint them into the palette (Verdigris, Oxblood, Resin, Vellum) so they feel bespoke rather than toy-like.
• Produce them as rendered assets (Blender or similar) exported at 1x, 2x and 3x PNG, or as Rive files where they animate.
• Required set: vault, bottle, seal (verified), rank crest, recognition, exhibition, blind circle, wanted, provenance chain, NFC cap, compliment, calendar wear, droplet level, sample vial, invite key, wallet card, settings.
• Until final renders exist, generate placeholder 3D-style icons with layered gradients, inner highlight and drop shadow via CustomPainter, behind a single AppIcon widget so they can be swapped without touching screens.
3.4 Surfaces and depth
• Use stacked layers deliberately: Stack with parallax depth, layered cards that peek beneath each other, and sheets that rise like drawers.
• Smoked-glass panels: blur plus subtle grain texture plus a 1px top highlight. Grain is mandatory on large surfaces to avoid a flat digital look.
• Bottles are the hero: show them large, cut out, with a soft floor reflection and a rarity halo behind.
3.5 Motion
Motion should feel weighty, slow to start and soft to land, never bouncy or springy-cute.
• Curves: define tokens. Settle = cubic(0.2, 0.0, 0.0, 1.0). Drawer = cubic(0.32, 0.72, 0.0, 1.0). Default durations 280ms (UI), 520ms (hero), 900ms (ceremony).
• Shared-element bottle transitions: a bottle in a grid lifts, its reflection fades, and it travels into the detail screen while the background dims to Ink.
• Drawer transitions: detail sheets rise from the bottom with a slight scale-down of the screen behind, like a cabinet drawer sliding out.
• Verification seal: a Rive animation of a wax-style seal pressing down, with a single haptic thud (HapticFeedback.heavyImpact) on contact.
• Rank ascension ceremony: full-screen Rive moment when the user moves up a rank, with the new crest forming from fine particles and the rank title set in display serif.
• Liquid level: the bottle level indicator is a shader with a gentle surface wobble driven by device tilt (sensors_plus), clamped to subtle movement.
• Numbers: stats roll up with tabular digits; never jump instantly.
• Haptics: light selection taps on chips, medium on logging a wear, heavy only for verification and rank-up.
• Reduced motion: respect the OS setting; replace hero motion with crossfades.
4. Navigation and screens
Five-tab bottom bar, custom-drawn (not BottomNavigationBar): a smoked-glass bar floating above content, with a soft glow under the active 3D icon.
Tabs: Today · Vault · Society · Wanted · Me.
4.1 Onboarding and access
• Invitation gate: first screen asks for an invite key. Without one, the user can join the waitlist or use the free private Vault (up to 5 bottles, no rank).
• Waitlist position: shows the user's place and how many invites exist this week. Real numbers only.
• Account: Sign in with Apple, Google, or email. Choose a member handle (no real name required).
• Privacy promise screen: plain statement that the collection is private by default, no location is ever stored, and photo metadata is stripped.
• First bottle: guided add of the first bottle, ending with an animated placement onto an empty shelf.
4.2 Today
• Morning card: "What are you wearing today?" with three suggestions as large bottle cards, swiped horizontally.
• Each suggestion shows why it was picked in one short line, e.g. "Cool evening, not worn in 3 weeks."
• Occasion chips: Work, Date, Family, Event, Travel, Leisure. Optional "seeing" field (free-text tag such as "boss") powering the don't-repeat memory.
• Warning banner when a choice repeats: "You wore this the last two times you saw Boss."
• One tap logs the wear. Evening prompt: "Any compliments?" with tap-to-log and optional who and where tags.
• Streak indicator, understated: a small row of filled droplets, not a flame.
4.3 Vault
• Opens behind Face ID. Shelf view (default): bottles on lit glass shelves in a horizontally scrolling cabinet, grouped by house or by rarity. Alternate grid and list views.
• Filters: rarity tier, house, season, verified or not, sample or full bottle.
• Bottle detail: hero bottle with halo, name in display serif, house, concentration, batch code, manufacture date, held since, rarity tier seal, verification status, liquid level shader, wears count, cost per wear, compliments, last worn, notes.
• Preservation mode on discontinued and vintage bottles: "At your pace, this runs out in 2029" with options to set a wear budget or add a backup to Wanted.
• Add bottle: search shared database, scan barcode, or manual entry. Fields: house, name, concentration, size ml, price paid (optional, private), purchase date, batch code, sprays per wear.
• Verify bottle: in-app camera only (no gallery import) capturing bottle, batch code and box. Batch code decoded to a production date where the house's format is known. Submission goes to verification review.
• Samples and decants: separate shelf of vials, each with rating and a "Want the full bottle" action that adds it to Wanted.
• Insights: cost per wear ranking, compliment ranking by season and setting, least-worn bottles, empty forecasts.
4.4 Society
• Feed of Exhibitions and recognitions, not posts. Editorial layout: one large featured Exhibition at the top, then a staggered masonry of smaller ones.
• Sealed profile (others' view): member handle, rank crest, member number if Founding Patron, declared signature scent, teaser lines ("Holds 4 discontinued bottles · 1 numbered edition · Collection value: undisclosed"), Nose rating, Exhibitions. Full shelf hidden.
• Request a viewing: sends a request; owner can grant a 24-hour viewing. During a viewing the visitor sees the shelf in a read-only gallery with a visible countdown. Screenshots: show a discreet watermark with the visitor's handle.
• Recognition: a single gesture (long-press, the seal presses down). Weighted by the giver's rank. Totals are never shown as raw numbers to others, only as standing (e.g. "Recognised by 2 Maîtres").
• Rankings: the leaderboard is the signature screen. Not a plain list. Design it as a museum hall: the top three members stand on tiered plinths with crests lit from above; below, ranks flow as engraved catalogue entries with rank, handle, rarity score, and movement arrow. Tabs: Rarity, Nose, Curation, Tenure. Users can opt out of rankings and appear as "A private collector".
• Holder counts on bottle pages: "Only 6 verified members hold this batch."
• Rarity percentile on the user's own profile: "Top 7% for rarity."
4.5 Exhibitions
• Create: choose 3 to 7 verified bottles, title, short curator's note, and ordering. Layout presets: Gallery Wall, Timeline, Pairing.
• Viewer: full-screen, swipe between bottles like turning gallery pages, curator's note in serif.
• Featured Exhibitions are chosen weekly by recognition weight, with staff override.
4.6 Blind Circles
• Host creates a Circle (date, private invite list). Attendance confirmed by scanning the host's rotating QR code in person.
• Host enters the correct answers per numbered strip; attendees submit guesses in the app during the session.
• Results reveal with a staged animation; correct identifications update each attendee's Nose rating (Elo-style, weighted by difficulty).
4.7 Wanted
• List of bottles the user seeks, each with target batch or era and notes.
• Alerts: "A Curator just verified a bottle on your Wanted list." Tapping opens a private message request to that owner (owner may decline; no public contact info ever).
• Preservation mode and samples feed bottles into Wanted automatically when the user chooses.
4.8 Provenance transfer
• Seller starts a transfer on a verified bottle and enters the buyer's handle. Buyer confirms on receipt by re-photographing the bottle and batch code. On confirmation, ownership moves and the bottle's chain records "Previously held by a [rank]" (handles hidden unless both agree).
• The app does not process the sale payment; it records provenance only. Sale price is optional and private, used only in aggregate for valuation.
• NFC caps: tapping a phone to a registered cap opens the bottle's public provenance card.
4.9 Me
• Own profile as others see it, with a toggle to preview the sealed view.
• Wallet card: add the membership card to Apple Wallet or Google Wallet, showing handle, rank, and member number.
• Year in Scent (available in December): a vertical story of full-screen cards. Most worn, top compliment-getter, rank movement, rarity percentile change, recognitions received. A share card shows rank and highlights; money stays private unless the user chooses to reveal it.
• Invites: remaining invite keys, who accepted.
• Settings: theme (Nocturne, Atelier), notification times, privacy (ranking opt-out, viewing requests on or off), currency, data export, delete account.
4.10 Paywall
• Shown when the user adds a sixth bottle or opens a Society feature.
• Tone is a members' invitation, not a sales page: one sentence, the three tiers, and a quiet restore-purchases link.
• Founding Patron shows the live count remaining ("212 of 500 numbers remain") from the server.
5. Rules and calculations
• Ranks: Initiate, Connoisseur, Curator, Maître. Score = rarity points of verified bottles + tenure points (months each verified bottle has been held) + contribution points (accepted verifications reviewed, Exhibitions recognised) + Nose rating bonus. Thresholds are configurable server-side. Payment status never enters the formula.
• Rarity points per verified bottle: In production 1, Reformulated 3, Discontinued 8, Vintage 15, Numbered limited 25. Configurable.
• Recognition weight: Initiate 1, Connoisseur 3, Curator 8, Maître 20.
• Rarity percentile: user's total rarity points ranked against all members with at least one verified bottle. Recompute nightly.
• Holder counts: count of distinct members with a verified, currently held bottle of that fragrance and batch. Show only when the count is 2 or more, to avoid revealing a single owner.
• Cost per wear: price paid divided by logged wears; show "—" until the first wear.
• Empty forecast: remaining ml = size × level estimate; ml per wear = sprays per wear × 0.1 ml (configurable); days left = remaining ml ÷ ml per wear ÷ average wears per day over the last 60 days.
• Suggestions (Today): score each owned bottle by season match to current temperature, day or night match, occasion tags, days since last worn (higher is better), and a penalty if worn recently with the same "seeing" tag. Return the top three with a reason string. Pure rules, no AI.
• Nose rating: Elo-style, start at 1200, difficulty weighted by how many attendees missed that strip.
6. Data model (Supabase, mirrored locally in Drift)
• members: id, handle, rank, rank_score, patron_number (nullable), signature_fragrance_id, ranking_opt_out, created_at.
• fragrances (shared catalogue): id, house, name, concentration, release_year, discontinued, reformulated, seasons, day_night, strength.
• bottles: id, owner_id, fragrance_id, size_ml, price_paid (private), purchased_at, batch_code, manufactured_at, rarity_tier, level_estimate, sprays_per_wear, is_sample, verification_status, held_since.
• verifications: id, bottle_id, photo_paths, decoded_date, status, reviewer_id, decided_at.
• wears: id, bottle_id, worn_at, occasion, seeing_tag.
• compliments: id, wear_id, who_tag, where_tag.
• wanted: id, member_id, fragrance_id, target_batch_or_era, notes.
• recognitions: id, giver_id, target_type, target_id, weight, created_at.
• exhibitions and exhibition_items: curator, title, note, layout, ordered bottles.
• viewing_grants: owner_id, viewer_id, expires_at.
• circles, circle_strips, circle_guesses: host, attendees, answers, guesses.
• transfers: bottle_id, from_id, to_id, status, confirmed_at, sale_price (private, optional).
• invites: key, issuer_id, redeemed_by, redeemed_at.
Row Level Security: bottles, wears, compliments and prices readable only by the owner, or by a viewer with an unexpired viewing grant (excluding prices and compliments). Aggregates such as holder counts are served through Edge Functions, never raw rows.
7. Security and privacy
• No location stored anywhere. Strip EXIF from every image before upload.
• Vault, price and value figures require biometrics each session.
• Rate-limit viewing requests and messages; allow blocking and reporting.
• Fake verification: reports from members, review by Curator and Maître ranks, and a dispute flow. Bottles found fake lose verification and the owner's score is recalculated.
• Data export and full account deletion from Settings, as required by both app stores.
8. Build order
1. Project setup, design tokens, theming, type scale, AppIcon placeholder system, custom tab bar, motion curves.
2. Vault offline: add bottle, shelf, detail, wears, compliments, cost per wear, empty forecast, preservation mode, samples.
3. Today: suggestions, notifications, don't-repeat memory.
4. Auth, Supabase sync, invites, paywall with RevenueCat.
5. Verification flow, rarity tiers, ranks, sealed profiles, holder counts, percentile.
6. Recognition, rankings hall, Wanted alerts.
7. Exhibitions, viewings, provenance transfer, NFC caps.
8. Blind Circles and Nose rating.
9. Wallet passes, widgets, Year in Scent.
10. Final 3D icon renders and Rive hero animations swapped in.
9. Testing and done criteria
• Unit tests for every calculation in section 5.
• Golden tests for every screen in both themes and at two text sizes.
• Integration tests for: onboarding with invite, add and verify bottle, log wear and compliment, paywall purchase (sandbox), viewing grant and expiry, transfer confirm.
• Run on an iOS simulator and an Android emulator after each phase; fix all analyzer warnings.
• A phase is done only when its tests pass and its screens match this spec in both themes.
10. Instructions to Claude Code
• Work phase by phase from section 8. After each phase, run the tests and the app, then summarise what is done and what is left.
• Never use default Material widgets visibly unstyled. Every colour, font and curve comes from tokens.
• Ask before adding paid services or fonts that need a licence.
11. Guardrails for Claude Code
These rules are mandatory. A phase is not complete until every rule below holds for it.
1. Traceability. Every requirement has an ID in the checklist (section 12). Reference the ID in the test name and the commit message, e.g. test('VAULT-03 vault requires biometrics').
2. Acceptance tests. Each checklist item gets at least one automated test proving its pass condition. No test means not done.
3. Screenshot review. After each phase, capture every new screen on the iOS simulator in Nocturne and Atelier, at default and large text sizes. Save to /screenshots/<phase>/. Review each against section 3 and fix deviations before continuing.
4. Design lint. Add a custom lint or CI check that fails on raw Color(, Colors., TextStyle( with literal fonts, or Curves. outside the tokens folder. Fail on any visible unstyled Material widget.
5. Definition of done. Tests pass, flutter analyze is clean, the app launches on iOS simulator and Android emulator, no TODO, FIXME or stub screens remain for that phase.
6. No silent shortcuts. Anything mocked, stubbed, or untested on a real device is listed in PROGRESS.md under "Needs real-device or real-key check".
7. Checklist report. PROGRESS.md contains the full checklist with each ID marked Done, Partial, or Not started, and the test that proves each Done item.
8. Real-device items. Haptics, Face ID, NFC, camera, Wallet passes, widgets and push are always listed for manual verification on a physical device, even if simulator tests pass.
12. Requirements checklist
ID
Requirement
Pass condition
DS-01
Design tokens
All colours, type, curves and durations come from token files; design lint passes
DS-02
Two themes
Every screen renders correctly in Nocturne and Atelier; goldens exist for both
DS-03
Contrast
All text meets WCAG AA against its surface
DS-04
3D icons
Every icon renders via AppIcon; no icon-font glyphs anywhere
DS-05
Reduced motion
With OS reduced motion on, hero animations become crossfades
NAV-01
Custom tab bar
Five tabs, smoked-glass floating bar, no BottomNavigationBar
NAV-02
Transitions
Bottle shared-element and drawer transitions used per section 3.5
ONB-01
Invite gate
App requires a valid invite for Society; free Vault available without one
ONB-02
Waitlist
Shows real position from server or mock, never hard-coded
ONB-03
Sign-in
Apple, Google and email sign-in work; handle required, real name not
VAULT-01
Add bottle
Search, barcode scan and manual entry all create a bottle
VAULT-02
Shelf views
Shelf, grid and list views with all filters in 4.3
VAULT-03
Biometric lock
Vault, prices and value figures require biometrics each session
VAULT-04
Bottle detail
Shows every field listed in 4.3
VAULT-05
Cost per wear
Correct per section 5; shows "—" before first wear
VAULT-06
Empty forecast
Correct per section 5 formula
VAULT-07
Preservation mode
Shown only on discontinued and vintage bottles; can add backup to Wanted
VAULT-08
Samples
Separate shelf; rating; "want full bottle" adds to Wanted
VAULT-09
Insights
Cost per wear, compliment, least-worn and forecast rankings
VAULT-10
Free limit
Sixth bottle triggers paywall for free users
TODAY-01
Suggestions
Three rule-based picks with reason strings per section 5
TODAY-02
Occasion and seeing tags
Selectable and saved with the wear
TODAY-03
Don't-repeat warning
Shown when the bottle was worn on the last two occasions with the same seeing tag
TODAY-04
Notifications
Morning and evening prompts at user-set times; max two per day
TODAY-05
Compliment log
One-tap evening log with optional who and where
SOC-01
Verification
In-app camera only; EXIF stripped; status flow Pending, Verified, Rejected
SOC-02
Rarity tiers
Five tiers with correct colours and seals
SOC-03
Ranks
Score per section 5; payment status never affects it (test proves it)
SOC-04
Rank-up ceremony
Plays once per promotion
SOC-05
Sealed profile
Others see only fields in 4.4; full shelf hidden
SOC-06
Viewing grants
24-hour access, countdown, auto-expiry, watermark
SOC-07
Recognition
Weighted per section 5; raw totals never shown to others
SOC-08
Rankings hall
Plinth design for top three, catalogue entries below, four tabs, opt-out works
SOC-09
Holder counts
Real counts; hidden when below 2
SOC-10
Rarity percentile
Recomputed nightly; shown on own profile
EXH-01
Exhibitions
Create with 3 to 7 verified bottles, three layouts, viewer, featured selection
CIRC-01
Blind Circles
QR attendance, guesses, staged reveal, Nose rating update
WANT-01
Wanted list
Add, edit, alerts on matching verification, private message request
PROV-01
Transfer
Seller start, buyer photo confirm, chain updated, handles hidden by default
PROV-02
NFC caps
Tap opens provenance card
ME-01
Wallet card
Apple and Google Wallet passes with handle, rank, member number
ME-02
Year in Scent
Story cards; money hidden on share card unless revealed
ME-03
Invites
Shows remaining keys and who accepted
ME-04
Settings
Theme, notification times, privacy, currency, export, delete account
PAY-01
Subscriptions
Monthly $2.99 and lifetime $19.99 via RevenueCat; restore works
PAY-02
Founding Patron
Capped at 500, numbered server-side, live remaining count
SEC-01
No location
No location stored or sent anywhere; test inspects uploads
SEC-02
Row Level Security
Tests prove non-owners cannot read bottles, wears, prices or compliments
SEC-03
Reporting
Block, report, and fake-verification dispute flows
WID-01
Widgets
iOS Home and Lock Screen widgets and Android widget show today's scent and percentile
13. Claude Code skills
Save each block below as its own file at .claude/skills/<skill-name>/SKILL.md inside the project. Claude Code loads them automatically when the task matches the description.
13.1 provenance-design-system
Path: .claude/skills/provenance-design-system/SKILL.md
---
name: provenance-design-system
description: Use whenever creating or editing any Flutter screen, widget, theme, icon, animation or transition in the Provenance app.
---

# Provenance design system

Source of truth: SPEC.md section 3. Read it before any UI work.

## Hard rules
- Never use raw Color(), Colors.*, literal TextStyle fonts, or Curves.* outside lib/design/tokens/.
- Never ship a visible default Material widget. Wrap or rebuild: buttons, chips, sheets, dialogs, tab bar, app bar, text fields.
- All icons go through AppIcon. No Icons.* or icon fonts.
- Every screen must render in both Nocturne and Atelier themes.
- Large surfaces get the grain texture. Smoked-glass panels get blur + grain + 1px top highlight.
- Bottles are the hero: large, cut out, floor reflection, rarity halo.

## Tokens (lib/design/tokens/)
- colors.dart: Ink #0F0E0D, Smoke #1A1817, Lacquer #2A1416, Vellum #ECE4D6, Ash #9A9186, Verdigris #6E9A8C, Oxblood #7A2630, Resin #B9864F, Hairline = Vellum 10%. Atelier variants per SPEC 3.1.
- rarity.dart: In production Ash, Reformulated Resin, Discontinued Verdigris, Vintage Oxblood, Numbered limited iridescent shader.
- type.dart: displayXL, displayL, titleM, bodyM, labelS, numeralL. Display serif, text grotesk, tabular numerals, small-caps labels.
- motion.dart: settle cubic(0.2,0,0,1), drawer cubic(0.32,0.72,0,1); durations ui 280ms, hero 520ms, ceremony 900ms.

## Motion
- Weighty, slow to start, soft to land. No bouncy springs.
- Bottle grid to detail: shared-element lift, reflection fade, background dims to Ink.
- Sheets rise like drawers with the screen behind scaling down slightly.
- Numbers roll up with tabular digits.
- Haptics: light for chips, medium for logging a wear, heavy only for verification and rank-up.
- Respect reduced motion: replace hero motion with crossfades.

## Before finishing any UI task
1. Run the design lint.
2. Capture the screen in both themes and at large text size.
3. Compare against SPEC section 3 and the relevant screen section in 4. Fix deviations.
13.2 provenance-testing
Path: .claude/skills/provenance-testing/SKILL.md
---
name: provenance-testing
description: Use when writing or running tests, goldens, screenshots or simulator runs for the Provenance app.
---

# Provenance testing

## Naming
- Every test name starts with its checklist ID from SPEC section 12, e.g. test('VAULT-05 cost per wear shows dash before first wear').
- Each checklist ID needs at least one test proving its pass condition.

## Test types
- Unit: every calculation in SPEC section 5 (ranks, rarity points, recognition weight, percentile, holder counts, cost per wear, empty forecast, suggestions, Nose rating). Include edge cases: zero wears, empty collection, holder count of 1.
- Widget and golden: every screen, both themes, default and large text scale. Store goldens in test/goldens/.
- Integration (integration_test or Patrol): onboarding with invite, add and verify bottle, log wear and compliment, paywall sandbox purchase, viewing grant expiry, provenance transfer.
- Security: tests proving Row Level Security blocks non-owners from bottles, wears, prices and compliments; a test proving uploads contain no EXIF or location.
- Rank integrity: a test proving payment status never changes rank score.

## Running
1. flutter analyze (must be clean).
2. flutter test.
3. flutter test integration_test on the iOS simulator, then the Android emulator.
4. Capture screenshots of every new screen into screenshots/<phase>/.

## Rules
- Never delete or weaken a failing test to make it pass. Fix the code.
- Never mark a test skip without listing it in PROGRESS.md with the reason.
- Use mock repositories when backend keys are missing; note it in PROGRESS.md.
13.3 provenance-phase-review
Path: .claude/skills/provenance-phase-review/SKILL.md
---
name: provenance-phase-review
description: Use at the end of every build phase in SPEC section 8, before starting the next phase or reporting progress.
---

# Provenance phase review

A phase is not done until every step below passes.

## Steps
1. List every checklist ID (SPEC section 12) that belongs to this phase.
2. For each ID, confirm the feature exists and name the test that proves it.
3. Run the provenance-testing skill's full run sequence. All must pass.
4. Search the codebase for TODO, FIXME, UnimplementedError and placeholder screens in this phase's code. Resolve them all.
5. Run the design lint and review screenshots with the provenance-design-system skill.
6. Launch the app on the iOS simulator and walk through the phase's main flows.
7. Commit with message: "Phase N: <summary> (IDs: ...)".

## Update PROGRESS.md
- Full checklist table: ID, status (Done, Partial, Not started), proving test.
- "Mocked or stubbed" list.
- "Needs real-device or real-key check" list: always include haptics, Face ID, NFC, camera, Wallet passes, widgets and push.
- Exact commands to run the app and tests.
- Blockers and the decision needed from Felix.

## Then
Start the next phase. Do not stop to ask unless blocked by a missing key, licence or paid service.
14. Addendum: invites, photography and sharing
The app name is Provenance Society. These requirements extend sections 4, 7 and 12.
Invites (INV)
• INV-01: Each new Society member gets 2 invites. More unlock with rank: 5 at Curator, unlimited at Maître. Invites are personal and can't be transferred.
• INV-02: The sponsor link (who invited whom) is hidden by default and visible only to the sponsor and the invitee. Either one can choose to show it on their profile. It is always recorded server-side.
• INV-03: Anyone can download the app and use the private Vault free. Society access is by in-app application or waitlist. Approval runs in admin batches, prioritised by collection size and verified bottles.
• INV-04: If an invitee is confirmed to have faked a verification, the sponsor loses unused invites and earns them back more slowly.
Photography (PHO)
• PHO-01: Bottle photos are taken with the in-app camera, which also feeds verification.
• PHO-02: On-device background removal places the bottle on a dark plinth with soft studio lighting and grain, using Nocturne tokens.
• PHO-03: Strip all EXIF and location data. Offer optional background blur before upload.
• PHO-04: Photos appear on Vault cards, in each bottle's gallery, in Exhibitions and in the rankings hall.
• PHO-05: Catalogue imagery comes from members' verified photos only. Never scrape brand or third-party images.
Hallmark and sharing (SHR)
• SHR-01: Exported images carry a subtle hallmark: "Provenance Society" in the editorial serif, plus a verified seal and the rarity tier. Stored Vault images stay clean.
• SHR-02: Sharing is one bottle at a time, never the whole Vault. Value and location never appear. The member chooses whether to show their handle.
• SHR-03: Share images include a small waitlist or App Clip link.
• SHR-04: Offer 2 or 3 export formats: square, story (9:16) and print-quality.
15. Feature requests (REQ)
• REQ-01: A "Requests" board under Me lets members submit a feature request (title, up to 300 characters, optional screenshot).
• REQ-02: Members vote on requests. Votes are weighted by rank: Initiate 1, Connoisseur 2, Curator 3, Maître 5. Each member has 5 active votes at a time.
• REQ-03: Every request shows a status: Under review, Planned, In progress, Shipped or Declined (with a one-line reason).
• REQ-04: When a request ships, everyone who voted gets a notification. The requester can opt in to be credited publicly.
• REQ-05: Duplicate requests are merged by an admin, combining their votes.
• REQ-06: Free Vault users can view the board but not submit or vote.
• REQ-07: Store requests in Supabase tables feature_requests and feature_votes, with RLS so members can only edit their own requests.
16. Admin dashboard and background jobs (ADM, JOB)
A separate web app, provenance-admin, built with Next.js (App Router, TypeScript, Tailwind) and hosted on Vercel. It uses the same Supabase project. Only staff accounts can sign in, and they must use two-factor authentication.
Roles
Role
Can
Cannot
Owner
Everything, including pricing, Founding Patron seats, staff management and data exports
—
Manager
Review waitlist, approve or reject members, adjust invite allowances, handle verification disputes, run the feature request board, track Curator outreach
Payments, pricing, staff roles, deleting members
Moderator
Review flagged photos and verifications
Approvals, invites, settings
Requirements
• ADM-01: Staff roles are stored in a staff table and enforced with Supabase RLS and server-side checks. Never rely on hiding buttons alone.
• ADM-02: Waitlist queue. Shows applicant, collection size and verified bottles, with approve, reject and batch-approve actions.
• ADM-03: Member management. Search members, view rank and invites, adjust invite allowance with a required reason, suspend or reinstate.
• ADM-04: Sponsor tree. Staff can see who invited whom, even when hidden from public profiles.
• ADM-05: Verification disputes. Review flagged bottles side by side with the original photos; confirm or clear. Confirming a fake applies INV-04 automatically.
• ADM-06: Curator outreach tracker with stages: contacted, replied, onboarded, posted.
• ADM-07: Feature request admin. Change status, merge duplicates, add the declined reason.
• ADM-08: Overview page. Waitlist size, approvals this week, Founding Patron seats sold, active members, and top requests.
• ADM-09: Audit log. Every staff action is recorded with who, what, when and the reason. Visible to the Owner only, and it can't be edited or deleted.
• ADM-10: The dashboard uses the Nocturne design tokens, but layout is plain and functional.
Background jobs
Run with Supabase pg_cron calling Edge Functions. Each job logs its result in a job_runs table, and failures show on the admin overview.
ID
Job
Schedule
JOB-01
Recalculate rank scores and percentiles
Nightly, 02:00 UTC
JOB-02
Expire 24-hour viewing grants
Hourly
JOB-03
Send Wanted-list alerts for new holdings
Hourly
JOB-04
Refresh holder counts and rarity stats
Nightly, 02:30 UTC
JOB-05
Month-end invite top-ups by rank
1st of each month
JOB-06
Weekly summary email to the Owner
Mondays, 07:00 Lagos time
JOB-07
Clean up expired invites and stale sessions
Daily
Weather for daily suggestions is fetched on the device from Open-Meteo and needs no server job.
17. Monorepo, extra phases and checklist additions
This section extends sections 2, 8 and 12. Every ID in sections 14–16 is mandatory, carries the same weight as the original 50, and must appear in PROGRESS.md.
Repository layout
provenance-society/
  apps/
    mobile/        Flutter app (iOS + Android)
    admin/         Next.js admin dashboard (Vercel root directory)
  supabase/
    migrations/    single source of truth for the schema and RLS
    functions/     Edge Functions, incl. scheduled jobs
    seed.sql       catalogue + mock data
  docs/
    SPEC.md  PLAYBOOK.md  PROGRESS.md
  .claude/skills/  design-system, testing, phase-review, marketing
  .github/workflows/  CI per app
• REPO-01: One git repo. Each app has its own CI job that runs only when its folder or supabase/ changes.
• REPO-02: Generate TypeScript types for the admin app from the Supabase schema (supabase gen types). Generate Dart models for the mobile app from the same migrations. Never hand-write duplicate types.
• REPO-03: Schema changes are made only through new files in supabase/migrations/, never in the dashboard UI.
• REPO-04: A root README lists the commands to run each app and the local Supabase stack.
Additional build phases
These follow the ten phases in section 8.
Phase
Scope
Requirement IDs
11
Invites, waitlist and sponsor links
INV-01–04
12
Photography pipeline, hallmark and sharing
PHO-01–05, SHR-01–04
13
Feature request board
REQ-01–07
14
Admin dashboard: auth, roles, audit log
ADM-01, ADM-09, ADM-10
15
Admin dashboard: operations screens
ADM-02–08
16
Background jobs and monitoring
JOB-01–07
0 (before phase 1)
Monorepo scaffold
REPO-01–04
Checklist additions
Add these rows to the section 12 checklist in PROGRESS.md, each with status, test name and commit:
ID range
Count
Section
REPO-01–04
4
17
INV-01–04
4
14
PHO-01–05
5
14
SHR-01–04
4
14
REQ-01–07
7
15
ADM-01–10
10
16
JOB-01–07
7
16
Total: 41 new requirements, 91 in all. The definition of done in section 11 applies to every one.
18. Gap closure (read with every earlier section)
This section fills gaps found in a full review. Where it conflicts with an earlier section, this section wins. Every ID here is mandatory and joins the checklist.
18.1 Membership tiers and Founding Curators (MEM)
• MEM-01: Four access states. Free Vault (no invite needed, up to 5 bottles, no rank, no Society). Waitlisted (applied, Free Vault rules apply). Member (paid monthly or lifetime, full Vault and Society). Founding Patron (numbered 1–500, Member plus patron number on profile and Wallet card).
• MEM-02: Founding Curator is a separate flag for the 50 seeded collectors: numbered 1–50, free lifetime Member access granted by the Owner in the admin dashboard, and a Curator hallmark on their profile. It does not grant rank; rank is still earned.
• MEM-03: Default rank thresholds (configurable in a settings table): Connoisseur 100 points, Curator 400, Maître 1,200. Tenure points: 1 per verified bottle per full month held. Contribution points: 5 per accepted verification review, 3 per Exhibition recognised by a Curator or above.
• MEM-04: Invite allowances. Initiate 2, Connoisseur 3, Curator 5, Maître unlimited. JOB-05 tops each member up to their rank's allowance on the 1st of the month. Unused invites don't accumulate beyond the allowance. Invite keys expire 14 days after issue.
18.2 Missing data model tables (DATA)
• DATA-01: Add these tables, each with created_at and updated_at: applications (member_id, collection_size, verified_count, note, status, decided_by, decided_at); sponsorships (sponsor_id, invitee_id, invite_key, sponsor_visible, invitee_visible); founding_curators (member_id, number); photos (id, bottle_id, storage_path, kind [bottle, batch, box, plinth_render], width, height); messages and message_threads (see 18.4); reports (reporter_id, target_type, target_id, reason, status); blocks (blocker_id, blocked_id); nfc_tags (uid_hash, bottle_id, registered_at); device_tokens (member_id, platform, token); notification_prefs; entitlements (member_id, product, source, expires_at; written only by the RevenueCat webhook); staff; audit_log; job_runs; settings; feature_requests; feature_votes.
• DATA-02: Add to members: access_state, invite_allowance, founding_curator_number (nullable), country (optional, for currency default only, never city), suspended_at.
• DATA-03: All foreign keys have explicit on delete rules. Account deletion removes or anonymises every row owned by the member, and keeps provenance chain entries as "a former member".
18.3 Fragrance catalogue and batch codes (CAT)
• CAT-01: Ship a seeded catalogue in supabase/seed.sql of at least 300 well-known fragrances (house, name, concentration, release year, discontinued flag, seasons, day or night). Enter facts by hand from public knowledge. Never scrape Fragrantica, Parfumo or brand sites.
• CAT-02: Members can submit a missing fragrance. It's usable in their own Vault at once and enters the shared catalogue after staff approval.
• CAT-03: Batch code decoding is a pluggable rule set per house, stored in a batch_rules table (house, pattern regex, decode function name). Start with 5 houses where formats are publicly documented. Unknown formats show "Date not decodable", never a guess.
18.4 Private messages (MSG)
• MSG-01: Messages exist only as replies to a Wanted alert or a viewing request. There is no open direct messaging.
• MSG-02: The first message is a request. The recipient accepts or declines; nothing more can be sent until they accept.
• MSG-03: Text only, 1,000 characters per message, no links or contact details in the first message (block phone numbers, emails and URLs with a pattern filter).
• MSG-04: Rate limit: 5 new requests per member per day. Block and report are available on every thread.
18.5 Verification review pipeline (VER)
• VER-01: Until the Society has 20 members at Curator rank or above, staff Moderators review every verification in the admin dashboard.
• VER-02: After that, each submission goes to 2 randomly chosen Curators or Maîtres who don't own that fragrance batch. Two approvals verify it; one rejection sends it to staff.
• VER-03: Target review time is 72 hours. The member sees status and an estimated wait.
• VER-04: Reviewers see the photos and batch code but never the owner's handle.
18.6 Valuation (VAL)
• VAL-01: A bottle's value is the member's own estimate if set, else the median recorded sale price of that fragrance and size from the last 24 months of transfers (only when there are 3 or more), else the price paid. With none of these, it shows "Unvalued".
• VAL-02: Collection value is the sum of bottle values. It always sits behind biometrics and never leaves the device in shares, profiles or exports.
• VAL-03: Recorded sale prices are only ever used in aggregate and never shown individually.
18.7 Public web pages and deep links (WEB)
• WEB-01: The Next.js app in apps/admin also serves public pages at the root domain: a landing page in the brand voice, a waitlist sign-up form (email and optional collection size), privacy policy, terms of service, and a public bottle provenance card at /b/<public_id> (used by NFC taps and shared images). Staff pages live under /admin and require staff sign-in.
• WEB-02: Universal Links (iOS) and App Links (Android) open /b/<public_id> and /invite/<key> in the app when installed, and in the web page otherwise.
• WEB-03: iOS App Clip shows the provenance card and a "Request membership" button. If the App Clip can't be built in time, list it in PROGRESS.md as deferred; the web page is the fallback.
• WEB-04: Public provenance cards show fragrance, rarity tier, verification status, number of owners and "held since" year only. Never handles (unless both agreed), value or photos of anything but the bottle.
18.8 Notifications (NOTIF)
• NOTIF-01: Notification types: morning prompt, evening compliment prompt, Wanted alert, viewing request, message request, verification result, rank-up, invite accepted, feature request shipped.
• NOTIF-02: Each type can be switched off in Settings. Quiet hours default to 22:00–07:00 local time.
• NOTIF-03: Maximum 4 push notifications per member per day, excluding verification results.
18.9 Storage, sync and offline (SYNC)
• SYNC-01: Supabase Storage buckets are private. Images are served with signed URLs that expire after 1 hour. Generate thumbnails at 256 px and 1,024 px.
• SYNC-02: Drift is the source of truth on the device. Changes queue locally and sync when online. On conflict, the most recent updated_at wins for each field, and wears and compliments always merge (never overwrite).
• SYNC-03: Free Vault users without an account keep data on the device only. When they sign up, their local data uploads to their new account.
18.10 Environments, secrets and monitoring (OPS)
• OPS-01: Three environments: local (Supabase CLI), staging and production. Each app reads its keys from .env files that are never committed; provide .env.example in each app.
• OPS-02: Keys needed: Supabase URL and anon key, Supabase service role key (server only), RevenueCat API keys (iOS and Android), RevenueCat webhook secret, Apple Wallet pass certificate, Google Wallet issuer ID, APNs key, FCM credentials, email provider key (for JOB-06). Use mocks until each is supplied.
• OPS-03: Crash reporting with Sentry (free tier) in both apps. No third-party product analytics. Count key events (sign-up, first bottle, verification submitted, purchase) in a Supabase events table with no personal data beyond member ID.
• OPS-04: First Owner account: a one-time CLI script supabase/scripts/create_owner.ts creates the Owner staff row from an email address. There is no public admin sign-up.
18.11 App store compliance (STORE)
• STORE-01: Provide App Store and Play reviewers with a working demo account and invite key in the review notes, because the app is invite-only.
• STORE-02: User-generated content rules: report, block, a content filter on text, and staff removal within 24 hours, as both stores require.
• STORE-03: Sign in with Apple is offered wherever Google sign-in is offered.
• STORE-04: In-app account deletion, privacy policy link and terms link are reachable from Settings and the paywall.
• STORE-05: Prepare store listing copy, screenshots for every required device size, and the privacy nutrition labels (no location, no tracking).
18.12 Quality states, accessibility and locale (UX)
• UX-01: Every screen has designed empty, loading and error states in the brand style. No spinners on plain backgrounds; use skeletons with grain.
• UX-02: Every interactive element has a screen reader label. Layouts work at the largest Dynamic Type and Android font sizes.
• UX-03: Currency defaults from the device locale and can be changed (including NGN, USD, GBP, EUR, AED). Dates and numbers follow the device locale. Copy is English only at launch, with all strings in ARB files ready for translation.
18.13 Where these go in the build
Phase
Adds
0
OPS-01, OPS-02
2
SYNC-02, SYNC-03, CAT-01, CAT-02, UX-01–03
4
MEM-01, MEM-04, DATA-01–03, SYNC-01
5
MEM-02, MEM-03, CAT-03, VER-01–04, VAL-01–03
6
MSG-01–04, NOTIF-01–03
7
WEB-02–04
14
WEB-01, OPS-04
16
OPS-03
Before submission
STORE-01–05
This adds 43 requirements: 134 in total. Claude Code also saves the marketing skill from docs/PLAYBOOK.md section 11 to .claude/skills/provenance-marketing/SKILL.md during phase 0.
19. Security standard (SECX)
The security baseline is OWASP: MASVS (L1 plus the resilience controls below) for the Flutter app, ASVS Level 2 for the admin web app, public pages and Edge Functions, and the API Security Top 10 for every endpoint. Section 7 still applies; this section makes it testable.
19.1 Mobile app (MASVS)
• SECX-01 (STORAGE): Tokens and keys go in iOS Keychain or Android Keystore via flutter_secure_storage. The Drift database is encrypted with SQLCipher, using a key held in the Keychain or Keystore. Nothing sensitive goes in SharedPreferences or logs.
• SECX-02 (STORAGE): Exclude the Vault database and image cache from iCloud and Android backups. Blur the app switcher snapshot while the Vault is open.
• SECX-03 (CRYPTO): Use only platform crypto or well-known libraries. No custom encryption. No secrets compiled into the app; the anon key is the only key in the build.
• SECX-04 (AUTH): Biometric unlock is tied to a Keychain or Keystore item requiring user presence, not just a true/false check. The Vault re-locks after 5 minutes in the background.
• SECX-05 (NETWORK): HTTPS only, TLS 1.2+, no cleartext exceptions in iOS ATS or Android network security config. Pin the Supabase certificate's public key, with a backup pin.
• SECX-06 (PLATFORM): Deep links and Universal Links validate every parameter. WebViews are not used. Screenshot watermarking during viewings per SOC-06.
• SECX-07 (CODE): Dependencies are pinned. CI runs flutter pub outdated and a vulnerability scan (OSV-Scanner) on every pull request and fails on high-severity findings.
• SECX-08 (RESILIENCE): Release builds are obfuscated (--obfuscate --split-debug-info). Detect jailbroken or rooted devices and hide value figures on them, with a plain explanation. Use App Attest (iOS) and Play Integrity (Android) on verification submissions and purchases.
19.2 Backend and admin (ASVS L2, API Top 10)
• SECX-09 (Broken object level authorisation): RLS is enabled on every table, with a deny-by-default policy. A CI test runs as an anonymous user, another member and staff of each role, and proves each can reach only what the spec allows.
• SECX-10 (Authentication): Staff need two-factor authentication. Admin sessions expire after 12 hours idle. Rate-limit sign-in and lock after 10 failed attempts in 15 minutes.
• SECX-11 (Property level authorisation): Edge Functions return explicit field lists, never select *. Private fields (price_paid, sale_price, value) never appear in responses to anyone but the owner.
• SECX-12 (Resource consumption): Rate limits on every Edge Function and public form. Image uploads are capped at 15 MB, checked for real image type, and re-encoded server-side.
• SECX-13 (Function level authorisation): The service role key is used only inside Edge Functions and the admin server, never in a browser or the mobile app. Every admin action is checked server-side against the staff role.
• SECX-14 (Business flows): Invite redemption, Founding Patron numbering and provenance transfer run in single database transactions with row locks, so they can't be raced or double-used. Entitlements change only from the verified RevenueCat webhook (signature checked).
• SECX-15 (Injection and XSS): Parameterised queries only. All user text is escaped on output. The web app sets a strict Content Security Policy, HSTS, X-Frame-Options DENY and SameSite cookies, and protects every form against CSRF.
• SECX-16 (SSRF and inputs): No endpoint fetches a URL supplied by a user. All inputs are validated with a schema (zod on the web, typed models in Dart).
• SECX-17 (Logging): Security events (sign-ins, failed sign-ins, role changes, data exports, deletions) are logged without personal content. Logs are kept 90 days. Alert the Owner by email on repeated failed staff sign-ins.
• SECX-18 (Secrets): Secrets live in Supabase and Vercel secret stores. CI runs gitleaks to block committed secrets.
19.3 Process
• SECX-19: Before each store submission, run through the OWASP MASTG checklist for the MASVS items above and record the results in docs/SECURITY.md.
• SECX-20: docs/SECURITY.md also holds a short threat model (stalking a collector to steal bottles, fake verification, invite abuse, account takeover, data leak of values) with the control that answers each.
• SECX-21: Publish a security contact at /.well-known/security.txt.
These are built in phase 0 (SECX-03, 07, 18), phase 2 (SECX-01, 02, 04), phase 4 (SECX-05, 09–14), phase 14 (SECX-15–17) and before submission (SECX-06, 08, 19–21). This adds 21 requirements: 155 in total.
20. Design psychology, web design and engineering standards (PSY, WEBD, ENG)
Read this before any UI work. When a screen or state isn't described in this spec, decide it from the principles below, never from a template or a default.
20.1 Who it is for and how it should feel
The member is a serious collector who already owns things most people never see. They don't want to be sold to, gamified or rushed. They want to feel recognised by peers who know, and safe. The app should feel like being let into a private archive after hours: quiet, dim, deliberate, a little ceremonial.
20.2 Psychological principles
• PSY-01 Discretion is the luxury. Hiding is the default and revealing is a choice. Locked, sealed and veiled states must look beautiful, not like errors: frosted glass, a wax seal, a one-line teaser. The member should feel the pleasure of holding something back.
• PSY-02 Earned, never bought. Status comes only from rarity, knowledge and time. Rank, seals and crests never appear on the paywall and are never shown next to a price. Paying gives access, not standing.
• PSY-03 Honest scarcity. Every count is real (holder counts, patron seats, waitlist). Never use fake urgency, countdown timers on purchases, "only 2 left" tricks or streak guilt. Trust is the product.
• PSY-04 Recognition from peers, weighted by knowledge. Approval from a Maître should feel like a gallery owner nodding, not a like. Show standing in words ("Recognised by 2 Maîtres"), never as running totals.
• PSY-05 Ritual over habit loops. Daily use is a calm ritual: the morning choice, the evening note. No badges for opening the app, no red notification dots, no infinite feed. Sessions are allowed to end; each screen should feel finished.
• PSY-06 Ceremony at real milestones only. Big motion and heavy haptics are reserved for verification, rank-up, title transfer and patron number. Everything else is restrained, so these moments land.
• PSY-07 The object is the hero. Bottles are shown like museum pieces: large, isolated, lit, with generous empty space. Interface chrome stays small and quiet around them.
• PSY-08 Language of the house, not the app. Copy uses the vocabulary of auction houses and archives: Vault, Exhibition, Viewing, Provenance, Held since, Title transfer. No exclamation marks, no emoji, no "Awesome!". Short, assured sentences. Errors are courteous: "This viewing has closed."
• PSY-09 Safety you can feel. Privacy controls are visible and explained in plain words where they act. Value figures appear only after biometrics, with a soft unveil, so the member senses the protection.
20.3 Signature moments (must exist and must not look common)
• PSY-10: The Vault opening. After Face ID, cabinet doors part along a vertical light seam, and shelf lights come on one by one from left to right (reduced motion: crossfade).
• PSY-11: The seal. Verification ends with the wax seal pressing onto the bottle card, a single heavy haptic, and the rarity halo blooming behind.
• PSY-12: The veiled profile. A sealed profile shows the shelf behind smoked glass, with silhouettes of bottles but no detail, and the teaser lines set in serif.
• PSY-13: The catalogue entry. Bottle details use museum-label layout: small caps labels, hairline rules, tabular figures, an accession-style number (for example "PS-0142").
• PSY-14: The hall. The rankings hall is lit from above, with the top three on plinths and everything else as engraved entries, per SOC-08.
20.4 Anti-patterns (fail review if present)
• PSY-15: Fail any screen that uses: default Material or Cupertino look; black and gold; gradients on buttons; rounded "bubbly" cards with drop shadows everywhere; stock illustrations or emoji; confetti; red badges; toasts with exclamation marks; dense dashboards on mobile; carousels of promotions; or any layout that could be another app with the logo swapped.
• PSY-16: Before marking a screen done, Claude Code answers in PROGRESS.md: which principle from 20.2 shaped it, and what makes it unlike a generic app.
20.5 Web design (WEBD)
• WEBD-01 Public pages (landing, waitlist, bottle cards, legal) are an extension of the app: Nocturne colours, the same display serif and grotesk, grain on large surfaces, bottles as the hero. The landing page reads like an auction catalogue's opening page: one bottle, one sentence, the waitlist form. No feature grids, testimonials carousels or pricing tables.
• WEBD-02 Admin dashboard is plain, fast and dense, but uses Nocturne tokens and the same type, so it feels like the back office of the same house. Tables with sorting and filters, keyboard shortcuts for approve and reject, and confirmation dialogs that ask for a reason on destructive actions.
• WEBD-03 Shared design tokens live in one file (packages/tokens/tokens.json) and generate both the Dart token classes and the Tailwind theme, so mobile and web can't drift.
• WEBD-04 Fonts are self-hosted on the web (no Google Fonts requests). Public pages score 90 or above on Lighthouse for performance, accessibility and best practices.
20.6 Engineering standards: mobile (ENG)
• ENG-01: Follow Effective Dart. Use very_good_analysis (or equivalent strict lints) with zero warnings.
• ENG-02: Feature-first folders under lib/features/<feature>/ with data, domain and presentation layers. Shared design code in lib/design/. Repositories behind interfaces so mocks swap in for tests.
• ENG-03: Riverpod with code generation; no business logic inside widgets. Immutable models with freezed. Errors are typed results, not thrown strings.
• ENG-04: Follow Apple's Human Interface Guidelines and Android's platform rules for system behaviour (back gestures, safe areas, permissions prompts, Dynamic Type), even though the visual style is custom.
• ENG-05: Accessibility to WCAG 2.2 AA: contrast, 44 pt minimum touch targets, screen reader labels, and no meaning carried by colour alone (rarity tiers also have a name and seal shape).
• ENG-06: Performance: 60 fps on a mid-range Android phone, cold start under 2 seconds, images cached and sized to display. Profile shaders and remove any that drop frames.
20.7 Engineering standards: web and backend
• ENG-07: TypeScript strict mode, ESLint and Prettier, Next.js App Router conventions with Server Components by default and Server Actions for mutations, validated with zod.
• ENG-08: Edge Functions in TypeScript (Deno), one function per job or endpoint, each with tests. SQL migrations are reviewed for RLS on every new table.
• ENG-09: Conventional Commits with requirement IDs. Every pull request runs lint, tests, the design lint, the security scans in section 19, and golden tests.
• ENG-10: Security follows section 19 (OWASP MASVS, ASVS Level 2, API Security Top 10).
Phases: PSY and WEBD-03 apply from phase 1 onward and are checked in every phase review; WEBD-01, 02 and 04 in phases 14–15; ENG items from phase 0. This adds 30 requirements: 185 in total. Update the provenance-design-system skill to tell Claude Code to read section 20 before any UI work.