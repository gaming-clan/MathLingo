import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../models/achievement.dart';
import '../../../shared/widgets/glass_panel.dart';

/// G-03 — Overlay i shfaqur pas sesionit kur deblokhen arritje të reja.
///
/// Shfaqet si dialog i plotë. Fëmija sheh badge-t e reja një nga një.
class BadgeNotificationOverlay extends StatefulWidget {
  const BadgeNotificationOverlay({
    super.key,
    required this.achievements,
  });

  final List<Achievement> achievements;

  /// Shfaq overlay-in si dialog.
  /// Kthehet kur përdoruesi mbyll.
  static Future<void> show(
    BuildContext context,
    List<Achievement> achievements,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) =>
          BadgeNotificationOverlay(achievements: achievements),
    );
  }

  @override
  State<BadgeNotificationOverlay> createState() =>
      _BadgeNotificationOverlayState();
}

class _BadgeNotificationOverlayState
    extends State<BadgeNotificationOverlay>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < widget.achievements.length - 1) {
      setState(() {
        _current++;
        _controller.forward(from: 0);
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievements[_current];
    final isLast = _current == widget.achievements.length - 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GlassPanel(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Etiketa
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: CosmicColors.primaryContainer.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: CosmicColors.primaryContainer.withValues(alpha: 0.5),
                  ),
                ),
                child: const Text(
                  'ARRITJE E RE!',
                  style: TextStyle(
                    color: CosmicColors.primaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Emoji i madh
              Text(a.emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 16),

              // Emri i badge-it
              Text(
                a.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),

              // Përshkrimi
              Text(
                a.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CosmicColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Counter nëse ka shumë badge
              if (widget.achievements.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${_current + 1} / ${widget.achievements.length}',
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Butoni
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    isLast ? 'Vazhdoj! 🎉' : 'Tjetri →',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
