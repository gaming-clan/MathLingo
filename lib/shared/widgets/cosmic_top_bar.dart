import 'package:flutter/material.dart';

import '../../colors.dart';

class CosmicTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CosmicTopBar({
    super.key,
    this.showBackButton = false,
    this.onProfilePressed,
    this.onNotificationsPressed,
  });

  final bool showBackButton;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onNotificationsPressed;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xCC0B0C21),
      elevation: 0,
      toolbarHeight: 76,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          _RoundIconButton(
            icon: showBackButton ? Icons.arrow_back : Icons.person,
            onPressed: showBackButton
                ? () => Navigator.maybePop(context)
                : onProfilePressed,
          ),
          const Spacer(),
          const Text(
            'MathLingo',
            style: TextStyle(
              color: CosmicColors.primaryContainer,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          _RoundIconButton(
            icon: Icons.notifications,
            onPressed: onNotificationsPressed,
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        foregroundColor: CosmicColors.onSurface,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 22),
    );
  }
}