import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';

/// Procedural film grain, generated once per theme from a fixed seed so
/// goldens are stable. Light grain on Nocturne, dark grain on Atelier.
abstract final class PsGrainTexture {
  static const _side = 96;
  // Dark grain on light paper reads stronger than light grain on dark.
  static int _maxAlpha(PsThemeMode m) => m == PsThemeMode.nocturne ? 26 : 11;
  static final _cache = <PsThemeMode, ui.Image>{};
  static final _pending = <PsThemeMode, Future<ui.Image>>{};

  static ui.Image? cached(PsThemeMode mode) => _cache[mode];

  static Future<ui.Image> load(PsThemeMode mode) {
    final hit = _cache[mode];
    if (hit != null) return Future.value(hit);
    return _pending[mode] ??= _generate(mode).then((image) {
      _cache[mode] = image;
      return image;
    });
  }

  static Future<ui.Image> _generate(PsThemeMode mode) {
    final tone = PsTheme.paletteOf(mode).vellum.toARGB32();
    final r = (tone >> 16) & 0xFF;
    final g = (tone >> 8) & 0xFF;
    final b = tone & 0xFF;
    final pixels = Uint8List(_side * _side * 4);
    var seed = 0x9E3779B9;
    for (var i = 0; i < _side * _side; i++) {
      seed = (seed * 1664525 + 1013904223) & 0xFFFFFFFF;
      final a = (seed >> 24) % _maxAlpha(mode);
      // Premultiplied alpha.
      pixels[i * 4] = r * a ~/ 255;
      pixels[i * 4 + 1] = g * a ~/ 255;
      pixels[i * 4 + 2] = b * a ~/ 255;
      pixels[i * 4 + 3] = a;
    }
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      _side,
      _side,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }
}

/// Grain overlay for large surfaces. Never intercepts touches.
class PsGrain extends StatefulWidget {
  const PsGrain({super.key});

  @override
  State<PsGrain> createState() => _PsGrainState();
}

class _PsGrainState extends State<PsGrain> {
  ui.Image? _image;
  PsThemeMode? _mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mode = PsTheme.of(context).mode;
    if (mode == _mode) return;
    _mode = mode;
    _image = PsGrainTexture.cached(mode);
    if (_image == null) {
      unawaited(
        PsGrainTexture.load(mode).then((image) {
          if (mounted && _mode == mode) setState(() => _image = image);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) return const SizedBox.expand();
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(image),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  _GrainPainter(this.image);

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_GrainPainter oldDelegate) => image != oldDelegate.image;
}
