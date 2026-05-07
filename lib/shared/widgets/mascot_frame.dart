import 'package:flutter/material.dart';

import '../../colors.dart';

class MascotFrame extends StatefulWidget {
  const MascotFrame({required this.size, this.celebratory = false, super.key});

  final double size;
  final bool celebratory;

  @override
  State<MascotFrame> createState() => _MascotFrameState();
}

class _MascotFrameState extends State<MascotFrame>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _swayController;
  late AnimationController _celebrationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _swayAnimation;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _swayController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _swayAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    if (widget.celebratory) {
      _celebrationController.forward();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _swayController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _bounceAnimation,
          _swayAnimation,
          _celebrationAnimation,
        ]),
        builder: (context, child) {
          final bounceOffset = widget.celebratory
              ? _celebrationAnimation.value * 20
              : _bounceAnimation.value;
          final swayOffset = widget.celebratory ? 0.0 : _swayAnimation.value;
          final scale = widget.celebratory
              ? 0.8 + (_celebrationAnimation.value * 0.2)
              : 1.0;
          final rotation = widget.celebratory
              ? _celebrationAnimation.value * 0.1
              : 0.0;

          return Center(
            child: Transform.translate(
              offset: Offset(swayOffset, -bounceOffset),
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Image.asset(
                    'assets/icons/stich_icon.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.smart_toy,
                      color: CosmicColors.secondaryContainer,
                      size: widget.size * 0.6,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}