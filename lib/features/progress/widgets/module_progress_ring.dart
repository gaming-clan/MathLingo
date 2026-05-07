import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../responsive.dart';

// 5 module keys dhe ngjyrat e tyre
const _moduleKeys = [
  'Mbledhje',
  'Zbritje',
  'Shumëzim',
  'Pjesëtim',
  'Gjeometri',
];

const _moduleColors = [
  Color(0xFF4CAF50), // gjelbër — Mbledhje
  Color(0xFFF44336), // kuq — Zbritje
  Color(0xFFFF9800), // portokalli — Shumëzim
  Color(0xFF2196F3), // blu — Pjesëtim
  Color(0xFF00EEFC), // cyan — Gjeometri
];

/// Ring chart me 5 harqe për 5 modulet. Animohet kur ngarkohet.
class ModuleProgressRing extends ConsumerStatefulWidget {
  const ModuleProgressRing({super.key});

  @override
  ConsumerState<ModuleProgressRing> createState() => _ModuleProgressRingState();
}

class _ModuleProgressRingState extends ConsumerState<ModuleProgressRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);
    final isTablet = AdaptiveLayout.isTablet(context);
    final ringSize = isTablet ? 240.0 : 160.0;

    return progressAsync.when(
      loading: () => SizedBox(
        width: ringSize,
        height: ringSize,
        child: const CircularProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final fractions = _moduleKeys
            .map((k) => progress.progressForModule(k))
            .toList();
        final totalPoints = progress.totalPoints;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: CustomPaint(
                    painter: _RingPainter(
                      fractions: fractions,
                      colors: _moduleColors,
                      animValue: _animation.value,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$totalPoints',
                            style: TextStyle(
                              color: CosmicColors.primaryContainer,
                              fontSize: isTablet ? 32 : 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'pikë',
                            style: TextStyle(
                              color: CosmicColors.onSurfaceVariant,
                              fontSize: isTablet ? 13 : 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < _moduleKeys.length; i++)
                  _RingLegendItem(
                    label: _moduleKeys[i],
                    color: _moduleColors[i],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fractions,
    required this.colors,
    required this.animValue,
  });

  final List<double> fractions;
  final List<Color> colors;
  final double animValue;

  static const _strokeWidth = 14.0;
  static const _gapDegrees = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - _strokeWidth;

    // Background ring (faded)
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // 5 arqe, secila 72° me 8° gap
    const totalGap = _gapDegrees * 5;
    const usable = 360.0 - totalGap;
    const arcSpan = usable / 5;

    for (var i = 0; i < fractions.length; i++) {
      final startDeg = -90.0 + i * (arcSpan + _gapDegrees);
      final sweepDeg = arcSpan * fractions[i] * animValue;

      if (sweepDeg < 0.5) continue;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(startDeg),
        _degToRad(sweepDeg),
        false,
        paint,
      );
    }
  }

  double _degToRad(double deg) => deg * math.pi / 180;

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.animValue != animValue || old.fractions != fractions;
}

class _RingLegendItem extends StatelessWidget {
  const _RingLegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: CosmicColors.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
