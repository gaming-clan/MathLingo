import 'dart:math' as math;

import 'package:flutter/material.dart';

class AdaptiveLayout {
  const AdaptiveLayout._();

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide >= 600 || size.width >= 760;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100 ? 56.0 : (width >= 760 ? 40.0 : 24.0);
    final top = width >= 760 ? 32.0 : 24.0;
    return EdgeInsets.fromLTRB(horizontal, top, horizontal, 36);
  }

  static int columnsForWidth(
    double width, {
    int compact = 2,
    int medium = 3,
    int expanded = 4,
  }) {
    if (width >= 1000) return expanded;
    if (width >= 680) return medium;
    return compact;
  }

  static double gridAspectForColumns(int columns, {double compact = 1.15}) {
    if (columns >= 4) return 1.35;
    if (columns == 3) return 1.25;
    return compact;
  }
}

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth = 1120,
    this.topSafeArea = false,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final bool topSafeArea;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: topSafeArea,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(constraints.maxWidth, maxWidth);
          return SingleChildScrollView(
            padding: padding ?? AdaptiveLayout.pagePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
