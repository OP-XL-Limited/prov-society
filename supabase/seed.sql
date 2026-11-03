-- Seed data. The fragrance catalogue (CAT-01) arrives in phase 2.
-- Defaults here are configurable at runtime through public.settings.
insert into public.settings (key, value) values
  ('rank_thresholds', '{"connoisseur": 100, "curator": 400, "maitre": 1200}'),
  ('rarity_points', '{"in_production": 1, "reformulated": 3, "discontinued": 8, "vintage": 15, "numbered_limited": 25}'),
  ('recognition_weight', '{"initiate": 1, "connoisseur": 3, "curator": 8, "maitre": 20}'),
  ('invite_allowance', '{"initiate": 2, "connoisseur": 3, "curator": 5, "maitre": null}')
on conflict (key) do nothing;
