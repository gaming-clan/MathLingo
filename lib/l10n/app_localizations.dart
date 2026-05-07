import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_sq.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('sq')];

  /// No description provided for @appTitle.
  ///
  /// In sq, this message translates to:
  /// **'MathLingo - Aventura e Matematikës'**
  String get appTitle;

  /// No description provided for @tabDailyChallenge.
  ///
  /// In sq, this message translates to:
  /// **'Sfida e Ditës'**
  String get tabDailyChallenge;

  /// No description provided for @tabLessons.
  ///
  /// In sq, this message translates to:
  /// **'Mësime'**
  String get tabLessons;

  /// No description provided for @tabTables.
  ///
  /// In sq, this message translates to:
  /// **'Tabelat'**
  String get tabTables;

  /// No description provided for @tabProgress.
  ///
  /// In sq, this message translates to:
  /// **'Progresi'**
  String get tabProgress;

  /// No description provided for @dashboardWelcomeTitle.
  ///
  /// In sq, this message translates to:
  /// **'Mirësevini!'**
  String get dashboardWelcomeTitle;

  /// No description provided for @dashboardWelcomeSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Zgjedh një mënyrë për të mësuar matematikën - më lehtë ose më sfiduese.'**
  String get dashboardWelcomeSubtitle;

  /// No description provided for @dashboardDailyChallengeTitle.
  ///
  /// In sq, this message translates to:
  /// **'Gjeometria Bazë'**
  String get dashboardDailyChallengeTitle;

  /// No description provided for @dashboardDailyChallengeDescription.
  ///
  /// In sq, this message translates to:
  /// **'Mësoni format dhe llogaritni sipërfaqe të thjeshta me ndihmën e mikut tuaj AI.'**
  String get dashboardDailyChallengeDescription;

  /// No description provided for @dashboardStartChallenge.
  ///
  /// In sq, this message translates to:
  /// **'Fillo Sfidën'**
  String get dashboardStartChallenge;

  /// No description provided for @dashboardGamifyChip.
  ///
  /// In sq, this message translates to:
  /// **'Argëto Ushtrimet'**
  String get dashboardGamifyChip;

  /// No description provided for @dashboardGamifyTitle.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ose Shkruaj Ushtrimin'**
  String get dashboardGamifyTitle;

  /// No description provided for @dashboardGamifyDescription.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ekuacionin që nuk e kupton, shkruaje direkt, dhe merrni zgjidhje argëtuese që të bëjnë matematikën më të lehtë për të kuptuar!'**
  String get dashboardGamifyDescription;

  /// No description provided for @dashboardStartAdventure.
  ///
  /// In sq, this message translates to:
  /// **'Filloi Aventurën'**
  String get dashboardStartAdventure;

  /// No description provided for @dashboardProgressModuleTitle.
  ///
  /// In sq, this message translates to:
  /// **'Progresi i Modulit'**
  String get dashboardProgressModuleTitle;

  /// No description provided for @dashboardProgressAbstractAlgebra.
  ///
  /// In sq, this message translates to:
  /// **'Algjebra Abstrakte'**
  String get dashboardProgressAbstractAlgebra;

  /// No description provided for @dashboardProgressMathematicalAnalysis.
  ///
  /// In sq, this message translates to:
  /// **'Analiza Matematike'**
  String get dashboardProgressMathematicalAnalysis;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In sq, this message translates to:
  /// **'Veprime të Shpejta'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardOperationAddition.
  ///
  /// In sq, this message translates to:
  /// **'Mbledhje'**
  String get dashboardOperationAddition;

  /// No description provided for @dashboardOperationSubtraction.
  ///
  /// In sq, this message translates to:
  /// **'Zbritje'**
  String get dashboardOperationSubtraction;

  /// No description provided for @dashboardOperationMultiplication.
  ///
  /// In sq, this message translates to:
  /// **'Shumëzim'**
  String get dashboardOperationMultiplication;

  /// No description provided for @dashboardOperationDivision.
  ///
  /// In sq, this message translates to:
  /// **'Pjesëtim'**
  String get dashboardOperationDivision;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'sq':
      return AppLocalizationsSq();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
