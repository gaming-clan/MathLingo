import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../core/providers/family_provider.dart';
import '../../models/child_profile.dart';

class CosmicTopBar extends ConsumerWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChild =
        showBackButton ? null : ref.watch(activeChildProvider);

    return AppBar(
      backgroundColor: const Color(0xCC0B0C21),
      elevation: 0,
      toolbarHeight: 76,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          if (showBackButton)
            _RoundIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.maybePop(context),
            )
          else
            _ProfileButton(
              child: activeChild,
              onPressed: onProfilePressed,
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

/// Butoni i profilit — shfaq emojin e fëmijës aktiv ose ikonën person.
class _ProfileButton extends StatelessWidget {
  const _ProfileButton({this.child, this.onPressed});

  final ChildProfile? child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return _RoundIconButton(icon: Icons.person, onPressed: onPressed);
    }
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: CosmicColors.primaryContainer.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            ChildAvatars.get(child!.avatarIndex),
            style: const TextStyle(fontSize: 22),
          ),
        ),
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