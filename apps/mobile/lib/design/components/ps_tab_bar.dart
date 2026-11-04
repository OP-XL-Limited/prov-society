import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_glass.dart';
import 'package:provenance_society/design/components/ps_text.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/motion.dart';
import 'package:provenance_society/design/tokens/space.dart';
import 'package:provenance_society/design/tokens/type.dart';

class PsTabItem {
  const PsTabItem({required this.kind, required this.label});

  final AppIconKind kind;
  final String label;
}

/// Custom-drawn floating bar of smoked glass (NAV-01). Not a stock
/// navigation bar: icons are 3D glyphs and the active one sits in a soft glow.
class PsTabBar extends StatelessWidget {
  const PsTabBar({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  /// Bar height before the bottom safe area.
  static const height = 68.0;

  final List<PsTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        PsSpace.gutter,
        0,
        PsSpace.gutter,
        bottom > 0 ? bottom - 2 : PsSpace.m,
      ),
      // Labels keep their size at the largest Dynamic Type so five tabs fit;
      // every tab still carries a full screen reader label.
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.2,
        child: SizedBox(
          height: height,
          child: PsGlass(
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _TabButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final PsTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PsTheme.of(context);
    final palette = theme.palette;
    final duration = PsTheme.reducedMotion(context)
        ? Duration.zero
        : PsMotion.ui;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: PsSpace.minTouchTarget,
            minHeight: PsSpace.minTouchTarget,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: selected ? 1 : 0,
                        duration: duration,
                        curve: PsMotion.settle,
                        child: SizedBox(
                          width: 40,
                          height: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  palette.verdigris.withValues(alpha: 0.5),
                                  palette.verdigris.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: selected ? 1 : 0.62,
                      child: AppIcon(
                        item.kind,
                        size: 26,
                        tint: selected
                            ? AppIconTint.verdigris
                            : AppIconTint.vellum,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PsSpace.xs),
              PsText(
                item.label,
                PsType.labelS,
                color: selected ? palette.vellum : palette.ash,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
