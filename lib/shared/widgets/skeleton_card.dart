import 'package:flutter/material.dart';

import 'glass_panel.dart';

/// CosmicShimmer — GlassPanel me gradient shimmer animuar.
///
/// Përdorimi:
///   CosmicShimmer(height: 120)           // kartë e thjeshtë
///   CosmicShimmer(height: 200, rows: 3)  // kartë me rreshta
class CosmicShimmer extends StatefulWidget {
  const CosmicShimmer({
    super.key,
    this.height = 100,
    this.rows = 1,
    this.borderRadius = 16.0,
  });

  final double height;
  final int rows;
  final double borderRadius;

  @override
  State<CosmicShimmer> createState() => _CosmicShimmerState();
}

class _CosmicShimmerState extends State<CosmicShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        final shimmerOffset = Alignment(
          -1.5 + _shimmer.value * 3.0,
          0,
        );
        return GlassPanel(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            height: widget.height,
            child: ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Color(0x00EEEBFF),
                  Color(0x1AEEEBFF),
                  Color(0x33EEEBFF),
                  Color(0x1AEEEBFF),
                  Color(0x00EEEBFF),
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                transform: _SlideTransform(shimmerOffset.x),
              ).createShader(bounds),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < widget.rows; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _ShimmerLine(
                      width: i == 0 ? 0.6 : 0.85,
                      height: i == 0 ? 20 : 14,
                    ),
                  ],
                  if (widget.rows == 1) const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.width, required this.height});

  /// [width] si fraksion i gjerësisë totale (0.0–1.0).
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0x22EEEBFF),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

/// GradientTransform që zhvendos gradentin horizontalisht.
class _SlideTransform extends GradientTransform {
  const _SlideTransform(this.dx);

  final double dx;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * dx, 0.0, 0.0);
  }
}
