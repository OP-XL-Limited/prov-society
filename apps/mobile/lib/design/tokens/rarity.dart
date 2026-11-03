// GENERATED FILE. Edit packages/tokens/tokens.json and run `npm run tokens`.
// dart format off
enum PsRarity {
  inProduction(label: 'In production', colorToken: 'ash', seal: 'circle'),
  reformulated(label: 'Reformulated', colorToken: 'resin', seal: 'square'),
  discontinued(label: 'Discontinued', colorToken: 'verdigris', seal: 'hexagon'),
  vintage(label: 'Vintage', colorToken: 'oxblood', seal: 'octagon'),
  numberedLimited(label: 'Numbered limited', colorToken: 'iridescent', seal: 'crest'),
  ;

  const PsRarity({required this.label, required this.colorToken, required this.seal});

  /// Human name. Tier is never carried by colour alone (ENG-05).
  final String label;

  /// Palette token name, or 'iridescent' for the shader tier.
  final String colorToken;

  /// Seal silhouette name, so tiers differ by shape as well as colour.
  final String seal;

  bool get isIridescent => colorToken == 'iridescent';
}

/// Palette tokens the iridescent tier drifts between.
const psIridescentDrift = <String>['verdigris', 'resin', 'oxblood'];
