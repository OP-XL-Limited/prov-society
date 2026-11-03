---
name: provenance-design-system
description: Use whenever creating or editing any Flutter screen, widget, theme, icon, animation or transition in the Provenance app, or any public web page or admin screen.
---

# Provenance design system

Source of truth: docs/SPEC.md section 3 AND section 20. Read both before any UI work. Section 20 (design psychology, web design, engineering standards) is mandatory: when a screen or state is not described in the spec, decide it from the section 20 principles, never from a template or a default. Brand voice lives in docs/PLAYBOOK.md.

## Hard rules
- Never use raw Color(), Colors.*, literal TextStyle fonts, or Curves.* outside lib/design/tokens/.
- Never ship a visible default Material or Cupertino widget. Wrap or rebuild: buttons, chips, sheets, dialogs, tab bar, app bar, text fields.
- All icons go through AppIcon. No Icons.* or icon fonts.
- Every screen must render in both Nocturne and Atelier themes.
- Large surfaces get the grain texture. Smoked-glass panels get blur + grain + 1px top highlight.
- Bottles are the hero: large, cut out, floor reflection, rarity halo.
- Tokens are generated from packages/tokens/tokens.json (WEBD-03). Edit the JSON, never the generated Dart or Tailwind files.

## Section 20 checklist (read before every UI task)
- PSY-01 Discretion is the luxury: locked, sealed and veiled states must look beautiful, never like errors.
- PSY-02 Earned, never bought: no rank, seal or crest on the paywall or beside a price.
- PSY-03 Honest scarcity: every count is real. No fake urgency, purchase countdowns or streak guilt.
- PSY-04 Standing in words ("Recognised by 2 Maîtres"), never running totals.
- PSY-05 Ritual over habit loops: no red badges, no infinite feed, screens feel finished.
- PSY-06 Ceremony only for verification, rank-up, title transfer, patron number.
- PSY-07 The object is the hero; chrome stays small and quiet.
- PSY-08 Auction-house vocabulary. No exclamation marks, no emoji, no "Awesome!". Errors are courteous.
- PSY-09 Safety you can feel: privacy controls explained in plain words; values appear only after biometrics with a soft unveil.
- PSY-10 to PSY-14 signature moments: Vault opening, the seal, veiled profile, catalogue entry (accession number such as PS-0142), the hall.
- PSY-15 Anti-patterns fail review: default Material/Cupertino look, black and gold, gradients on buttons, bubbly cards with shadows everywhere, stock illustrations, emoji, confetti, red badges, exclamation toasts, dense mobile dashboards, promo carousels, any layout that could be another app with the logo swapped.
- PSY-16 In docs/PROGRESS.md, for each screen: which principle shaped it, and what makes it unlike a generic app.
- ENG-04/05/06 Platform behaviour, WCAG 2.2 AA, 44 pt targets, labels, no meaning by colour alone, 60 fps.
- UX-01/02 Designed empty, loading (grain skeletons, no bare spinners) and error states; screen reader labels; largest text sizes.

## Tokens (lib/design/tokens/)
- colors.dart: Ink #0F0E0D, Smoke #1A1817, Lacquer #2A1416, Vellum #ECE4D6, Ash #9A9186, Verdigris #6E9A8C, Oxblood #7A2630, Resin #B9864F, Hairline = Vellum 10%. Atelier variants per SPEC 3.1.
- rarity.dart: In production Ash, Reformulated Resin, Discontinued Verdigris, Vintage Oxblood, Numbered limited iridescent shader. Tiers also carry a name and seal shape (ENG-05).
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
2. Capture the screen in both themes and at large text size into screenshots/<phase>/.
3. Compare against SPEC section 3, section 20 and the relevant screen section in 4. Fix deviations.
4. Add the PSY-16 note to docs/PROGRESS.md.
