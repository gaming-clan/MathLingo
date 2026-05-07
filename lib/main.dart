import 'package:flutter/material.dart';

import 'app/app_routes.dart';
import 'colors.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() {
  runApp(const MathLingoApp());
}

class MathLingoApp extends StatelessWidget {
  const MathLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathLingo - Math Learning Adventure',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: CosmicColors.background,
        colorScheme: const ColorScheme.dark(
          primary: CosmicColors.primary,
          onPrimary: CosmicColors.onPrimaryContainer,
          secondary: CosmicColors.secondary,
          surface: CosmicColors.surface,
          onSurface: CosmicColors.onSurface,
          error: CosmicColors.error,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          headlineMedium: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          bodyMedium: TextStyle(
            color: CosmicColors.onSurfaceVariant,
            fontSize: 16,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      routes: {
        AppRoutes.dashboard: (_) => const DashboardScreen(),
      },
    );
  }
}
