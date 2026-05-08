import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_routes.dart';
import 'colors.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'l10n/app_localizations.dart';
import 'shared/utils/user_progress_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserProgressStorage.initialize();
  runApp(const ProviderScope(child: MathLingoApp()));
}

class MathLingoApp extends StatelessWidget {
  const MathLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.dashboard,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: const Locale('sq'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
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
