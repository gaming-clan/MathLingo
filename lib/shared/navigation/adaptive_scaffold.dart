import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/cosmic_bottom_nav.dart';

/// AdaptiveScaffold shfaq:
///   < 600px  → BottomNav (CosmicBottomNav)
///   600–839px → NavigationRail kompakt (vetëm ikona)
///   ≥ 840px  → NavigationRail extended (ikona + etiketa) + Master-Detail slot
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.body,
    this.appBar,
    this.detailPane,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;

  /// Kur ≥ 840px: kolonë e djathtë (detail). null → vetëm body (full-width).
  final Widget? detailPane;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return Scaffold(
        backgroundColor: CosmicColors.background,
        appBar: appBar,
        body: body,
        bottomNavigationBar: CosmicBottomNav(
          selectedIndex: selectedIndex,
          onSelected: onSelected,
        ),
      );
    }

    final extended = width >= 840;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: appBar,
      body: Row(
        children: [
          _CosmicRail(
            selectedIndex: selectedIndex,
            onSelected: onSelected,
            extended: extended,
          ),
          if (extended && detailPane != null) ...[
            Expanded(flex: 4, child: body),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0x1FEEEBFF),
            ),
            Expanded(flex: 6, child: detailPane!),
          ] else
            Expanded(child: body),
        ],
      ),
    );
  }
}

class _CosmicRail extends StatelessWidget {
  const _CosmicRail({
    required this.selectedIndex,
    required this.onSelected,
    required this.extended,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.dashboard_rounded, l10n.tabDailyChallenge),
      (Icons.school_rounded, l10n.tabLessons),
      (Icons.grid_3x3_rounded, l10n.tabTables),
      (Icons.trending_up_rounded, l10n.tabProgress),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: CosmicColors.surface,
        border: Border(
          right: BorderSide(color: Color(0x1FEEEBFF)),
        ),
      ),
      child: NavigationRail(
        extended: extended,
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelected,
        backgroundColor: Colors.transparent,
        minWidth: 72,
        minExtendedWidth: 200,
        indicatorColor: Color(0x33BC13FE),
        selectedIconTheme: const IconThemeData(
          color: CosmicColors.primaryContainer,
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Color(0x99EEEBFF),
          size: 24,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: CosmicColors.primaryContainer,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: Color(0x99EEEBFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        destinations: [
          for (final item in items)
            NavigationRailDestination(
              icon: Icon(item.$1),
              label: Text(item.$2),
            ),
        ],
      ),
    );
  }
}
