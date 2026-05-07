import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../l10n/app_localizations.dart';

class CosmicBottomNav extends StatelessWidget {
  const CosmicBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.dashboard, l10n.tabDailyChallenge),
      (Icons.school, l10n.tabLessons),
      (Icons.grid_3x3, l10n.tabTables),
      (Icons.trending_up, l10n.tabProgress),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: const Color(0xCC0B0C21),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: CosmicColors.primaryContainer.withValues(alpha: 0.12),
              blurRadius: 22,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _BottomNavItem(
                    icon: items[i].$1,
                    label: items[i].$2,
                    selected: i == selectedIndex,
                    onTap: () => onSelected(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? CosmicColors.primary : CosmicColors.outline;
    return Flexible(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: selected
              ? CosmicColors.primaryContainer.withValues(alpha: 0.12)
              : Colors.transparent,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}