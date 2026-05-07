import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../shared/widgets/glass_panel.dart';

/// Gjashtë shembuj ekuacionesh — 2 mbledhje, 2 zbritje, 1 shumëzim, 1 pjesëtim.
/// Tap → feedback cyan glow + SnackBar.
class ExamplesPanel extends StatelessWidget {
  const ExamplesPanel({super.key});

  static const _examples = [
    _Example('3 + 4 = 7', 'Mbledhje'),
    _Example('8 + 6 = 14', 'Mbledhje'),
    _Example('9 - 3 = 6', 'Zbritje'),
    _Example('15 - 7 = 8', 'Zbritje'),
    _Example('4 × 5 = 20', 'Shumëzim'),
    _Example('12 ÷ 4 = 3', 'Pjesëtim'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titulli i panelit
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CosmicColors.secondaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      CosmicColors.secondaryContainer.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calculate,
                    size: 14,
                    color: CosmicColors.secondaryContainer,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Shembuj',
                    style: TextStyle(
                      color: CosmicColors.secondaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            itemCount: _examples.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) =>
                _ExampleCard(example: _examples[i]),
          ),
        ),
      ],
    );
  }
}

class _Example {
  const _Example(this.equation, this.operation);

  final String equation;
  final String operation;
}

class _ExampleCard extends StatefulWidget {
  const _ExampleCard({required this.example});

  final _Example example;

  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnim;
  bool _glowing = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnim = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_glowing) return;
    setState(() => _glowing = true);
    _glowController.forward().then((_) {
      Future<void>.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        _glowController.reverse().then((_) {
          if (mounted) setState(() => _glowing = false);
        });
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bravo! ${widget.example.equation}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return GestureDetector(
          onTap: _onTap,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.example.equation,
                    style: TextStyle(
                      color: Color.lerp(
                        CosmicColors.secondaryContainer,
                        const Color(0xFF00EEFC),
                        _glowAnim.value,
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: CosmicColors.secondaryContainer
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.example.operation,
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
