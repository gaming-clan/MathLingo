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

  /// No description provided for @commonPointsLabel.
  ///
  /// In sq, this message translates to:
  /// **'Pikët'**
  String get commonPointsLabel;

  /// No description provided for @commonAccuracyLabel.
  ///
  /// In sq, this message translates to:
  /// **'Saktësia'**
  String get commonAccuracyLabel;

  /// No description provided for @commonContinue.
  ///
  /// In sq, this message translates to:
  /// **'Vazhdo'**
  String get commonContinue;

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

  /// No description provided for @dashboardProgressPointsLabel.
  ///
  /// In sq, this message translates to:
  /// **'Pikë totale: {points}'**
  String dashboardProgressPointsLabel(int points);

  /// No description provided for @dashboardProgressAccuracyLabel.
  ///
  /// In sq, this message translates to:
  /// **'Saktësia mesatare: {accuracy}%'**
  String dashboardProgressAccuracyLabel(int accuracy);

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In sq, this message translates to:
  /// **'Veprime të Shpejta'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardProfileComingSoon.
  ///
  /// In sq, this message translates to:
  /// **'Profili do të shtohet së shpejti.'**
  String get dashboardProfileComingSoon;

  /// No description provided for @dashboardNotificationsComingSoon.
  ///
  /// In sq, this message translates to:
  /// **'Njoftimet do të shtohen së shpejti.'**
  String get dashboardNotificationsComingSoon;

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

  /// No description provided for @challengeKicker.
  ///
  /// In sq, this message translates to:
  /// **'ALGJEBRA BAZË'**
  String get challengeKicker;

  /// No description provided for @challengeTitle.
  ///
  /// In sq, this message translates to:
  /// **'Zgjidh ekuacionin'**
  String get challengeTitle;

  /// No description provided for @challengeScoreLabel.
  ///
  /// In sq, this message translates to:
  /// **'Pikët: {score}'**
  String challengeScoreLabel(int score);

  /// No description provided for @challengeEquationPrompt.
  ///
  /// In sq, this message translates to:
  /// **'{num1} {symbol} {num2} = ?'**
  String challengeEquationPrompt(int num1, Object symbol, int num2);

  /// No description provided for @challengeCorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Saktë! Vazhdon fluturimi.'**
  String get challengeCorrectFeedback;

  /// No description provided for @challengeIncorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Provo përsëri. Je shumë afër.'**
  String get challengeIncorrectFeedback;

  /// No description provided for @resultsTitle.
  ///
  /// In sq, this message translates to:
  /// **'Bravo!'**
  String get resultsTitle;

  /// No description provided for @resultsSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Përfundove me sukses sfidën.'**
  String get resultsSubtitle;

  /// No description provided for @resultsPointsValue.
  ///
  /// In sq, this message translates to:
  /// **'+{points}'**
  String resultsPointsValue(int points);

  /// No description provided for @resultsAccuracyValue.
  ///
  /// In sq, this message translates to:
  /// **'{accuracy}%'**
  String resultsAccuracyValue(int accuracy);

  /// No description provided for @geometryKicker.
  ///
  /// In sq, this message translates to:
  /// **'GJEOMETRIA BAZË'**
  String get geometryKicker;

  /// No description provided for @geometryTitle.
  ///
  /// In sq, this message translates to:
  /// **'Sfida Gjeometrike'**
  String get geometryTitle;

  /// No description provided for @geometryScoreLabel.
  ///
  /// In sq, this message translates to:
  /// **'Pikët: {score}'**
  String geometryScoreLabel(int score);

  /// No description provided for @geometryCorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Saktë! Forma u analizua.'**
  String get geometryCorrectFeedback;

  /// No description provided for @geometryIncorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Jo ende. Shiko matjet dhe provo përsëri.'**
  String get geometryIncorrectFeedback;

  /// No description provided for @geometryRectanglePrompt.
  ///
  /// In sq, this message translates to:
  /// **'Sa është sipërfaqja e drejtkëndëshit?'**
  String get geometryRectanglePrompt;

  /// No description provided for @geometryTrianglePrompt.
  ///
  /// In sq, this message translates to:
  /// **'Sa është sipërfaqja e trekëndëshit?'**
  String get geometryTrianglePrompt;

  /// No description provided for @geometrySquarePrompt.
  ///
  /// In sq, this message translates to:
  /// **'Sa është perimetri i katrorit?'**
  String get geometrySquarePrompt;

  /// No description provided for @geometryRectangleMeasurement.
  ///
  /// In sq, this message translates to:
  /// **'gjerësi {width}, lartësi {height}'**
  String geometryRectangleMeasurement(int width, int height);

  /// No description provided for @geometryTriangleMeasurement.
  ///
  /// In sq, this message translates to:
  /// **'bazë {width}, lartësi {height}'**
  String geometryTriangleMeasurement(int width, int height);

  /// No description provided for @geometrySquareMeasurement.
  ///
  /// In sq, this message translates to:
  /// **'brinja {width}'**
  String geometrySquareMeasurement(int width);

  /// No description provided for @legacyGeometryRectangleLabel.
  ///
  /// In sq, this message translates to:
  /// **'Drejtkëndësh'**
  String get legacyGeometryRectangleLabel;

  /// No description provided for @legacyGeometrySquareLabel.
  ///
  /// In sq, this message translates to:
  /// **'Katror'**
  String get legacyGeometrySquareLabel;

  /// No description provided for @legacyGeometryTriangleLabel.
  ///
  /// In sq, this message translates to:
  /// **'Trekëndësh'**
  String get legacyGeometryTriangleLabel;

  /// No description provided for @legacyGeometryPerimeterQuestion.
  ///
  /// In sq, this message translates to:
  /// **'Sa është perimetri?'**
  String get legacyGeometryPerimeterQuestion;

  /// No description provided for @legacyGeometryAreaQuestion.
  ///
  /// In sq, this message translates to:
  /// **'Sa është sipërfaqja?'**
  String get legacyGeometryAreaQuestion;

  /// No description provided for @legacyGeometryWrongAnswer.
  ///
  /// In sq, this message translates to:
  /// **'E gabuar, provo përsëri!'**
  String get legacyGeometryWrongAnswer;

  /// No description provided for @legacyGeometryResultTitle.
  ///
  /// In sq, this message translates to:
  /// **'Përfundim!'**
  String get legacyGeometryResultTitle;

  /// No description provided for @legacyGeometryScoreSummary.
  ///
  /// In sq, this message translates to:
  /// **'Pikët: {score}/{total}'**
  String legacyGeometryScoreSummary(int score, int total);

  /// No description provided for @legacyGeometrySuccessMessage.
  ///
  /// In sq, this message translates to:
  /// **'👏 Bravo!'**
  String get legacyGeometrySuccessMessage;

  /// No description provided for @legacyGeometryRetryMessage.
  ///
  /// In sq, this message translates to:
  /// **'Përpiqu përsëri!'**
  String get legacyGeometryRetryMessage;

  /// No description provided for @legacyGeometryFinish.
  ///
  /// In sq, this message translates to:
  /// **'Mbaroj'**
  String get legacyGeometryFinish;

  /// No description provided for @legacyGeometryQuestionTitle.
  ///
  /// In sq, this message translates to:
  /// **'Pyetja {current}/{total}'**
  String legacyGeometryQuestionTitle(int current, int total);

  /// No description provided for @legacyGeometryCurrentScore.
  ///
  /// In sq, this message translates to:
  /// **'Pikët: {score}'**
  String legacyGeometryCurrentScore(int score);

  /// No description provided for @legacyGeometryShapeDimensions.
  ///
  /// In sq, this message translates to:
  /// **'{shape} ({width} × {height})'**
  String legacyGeometryShapeDimensions(Object shape, int width, int height);

  /// No description provided for @lessonsToolsTitle.
  ///
  /// In sq, this message translates to:
  /// **'Mjetet e Llogaritjes'**
  String get lessonsToolsTitle;

  /// No description provided for @progressPageTitle.
  ///
  /// In sq, this message translates to:
  /// **'Bravo!'**
  String get progressPageTitle;

  /// No description provided for @progressPageSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Progresi yt po rritet çdo ditë.'**
  String get progressPageSubtitle;

  /// No description provided for @progressPageTotalPointsLabel.
  ///
  /// In sq, this message translates to:
  /// **'Pikët totale'**
  String get progressPageTotalPointsLabel;

  /// No description provided for @progressPageAverageAccuracyLabel.
  ///
  /// In sq, this message translates to:
  /// **'Saktësia mesatare'**
  String get progressPageAverageAccuracyLabel;

  /// No description provided for @tablesTitle.
  ///
  /// In sq, this message translates to:
  /// **'Tabelat Matematikore'**
  String get tablesTitle;

  /// No description provided for @tablesSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Praktiko dhe zotëro të gjitha operacionet'**
  String get tablesSubtitle;

  /// No description provided for @tablesTabAddition.
  ///
  /// In sq, this message translates to:
  /// **'Mbledhje +'**
  String get tablesTabAddition;

  /// No description provided for @tablesTabSubtraction.
  ///
  /// In sq, this message translates to:
  /// **'Zbritje -'**
  String get tablesTabSubtraction;

  /// No description provided for @tablesTabMultiplication.
  ///
  /// In sq, this message translates to:
  /// **'Shumëzim ×'**
  String get tablesTabMultiplication;

  /// No description provided for @tablesTabDivision.
  ///
  /// In sq, this message translates to:
  /// **'Pjesëtim ÷'**
  String get tablesTabDivision;

  /// No description provided for @tablesHeader.
  ///
  /// In sq, this message translates to:
  /// **'{operation} - Tabela e {table}'**
  String tablesHeader(Object operation, int table);

  /// No description provided for @tablesChooseNumber.
  ///
  /// In sq, this message translates to:
  /// **'Zgjidh numrin'**
  String get tablesChooseNumber;

  /// No description provided for @tablesEquationSnackBar.
  ///
  /// In sq, this message translates to:
  /// **'{selectedTable} {symbol} {operand} = {result}'**
  String tablesEquationSnackBar(
    int selectedTable,
    Object symbol,
    int operand,
    int result,
  );

  /// No description provided for @gamifyScreenTitle.
  ///
  /// In sq, this message translates to:
  /// **'Argëto Ushtrimet'**
  String get gamifyScreenTitle;

  /// No description provided for @gamifyInputTitle.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ose Shkruaj Ushtrimin'**
  String get gamifyInputTitle;

  /// No description provided for @gamifyInputSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Mund ta fotografosh ose ta shkruash ushtrimin. OCR funksionon më mirë me tekst të shtypur dhe imazhe të qarta.'**
  String get gamifyInputSubtitle;

  /// No description provided for @gamifyClear.
  ///
  /// In sq, this message translates to:
  /// **'Fshij'**
  String get gamifyClear;

  /// No description provided for @gamifySolve.
  ///
  /// In sq, this message translates to:
  /// **'Zgjidh'**
  String get gamifySolve;

  /// No description provided for @gamifySolutionTitle.
  ///
  /// In sq, this message translates to:
  /// **'✨ Zgjidhja Argëtuese ✨'**
  String get gamifySolutionTitle;

  /// No description provided for @gamifyRecognizedTextLabel.
  ///
  /// In sq, this message translates to:
  /// **'Teksti i Njohur:'**
  String get gamifyRecognizedTextLabel;

  /// No description provided for @gamifyCameraButton.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo'**
  String get gamifyCameraButton;

  /// No description provided for @gamifyGalleryButton.
  ///
  /// In sq, this message translates to:
  /// **'Galeria'**
  String get gamifyGalleryButton;

  /// No description provided for @gamifyWriteExerciseLabel.
  ///
  /// In sq, this message translates to:
  /// **'Shkruaj Ushtrimin'**
  String get gamifyWriteExerciseLabel;

  /// No description provided for @gamifyExerciseHint.
  ///
  /// In sq, this message translates to:
  /// **'Shembull: 15 + 7'**
  String get gamifyExerciseHint;

  /// No description provided for @gamifyRecognizedPlaceholder.
  ///
  /// In sq, this message translates to:
  /// **'Ekuacioni u identifikua nga imazhi...'**
  String get gamifyRecognizedPlaceholder;

  /// No description provided for @gamifyOcrProcessing.
  ///
  /// In sq, this message translates to:
  /// **'Po lexoj tekstin nga imazhi...'**
  String get gamifyOcrProcessing;

  /// No description provided for @gamifyOcrNoTextDetected.
  ///
  /// In sq, this message translates to:
  /// **'Nuk u gjet tekst në imazh. Provo një foto më të qartë ose shkruaje ushtrimin manualisht.'**
  String get gamifyOcrNoTextDetected;

  /// No description provided for @gamifyOcrNoEquationFound.
  ///
  /// In sq, this message translates to:
  /// **'Nuk u gjet asnjë ekuacion matematikor në imazh.'**
  String get gamifyOcrNoEquationFound;

  /// No description provided for @gamifyOcrProcessingError.
  ///
  /// In sq, this message translates to:
  /// **'Gabim gjatë leximit të tekstit: {error}'**
  String gamifyOcrProcessingError(Object error);

  /// No description provided for @gamifyEmptyEquationError.
  ///
  /// In sq, this message translates to:
  /// **'Ju lutemi shkruani ose fotografoni një ekuacion.'**
  String get gamifyEmptyEquationError;

  /// No description provided for @gamifyImagePickError.
  ///
  /// In sq, this message translates to:
  /// **'Gabim në zgjedhjen e imazhit: {error}'**
  String gamifyImagePickError(Object error);

  /// No description provided for @gamifySubtractionNeedsPositiveResult.
  ///
  /// In sq, this message translates to:
  /// **'Ky ushtrim krijon rezultat negativ ({num1} - {num2}). Përdor një zbritje ku numri i parë është më i madh.'**
  String gamifySubtractionNeedsPositiveResult(int num1, int num2);

  /// No description provided for @gamifyDivisionByZero.
  ///
  /// In sq, this message translates to:
  /// **'Pjesëtimi me zero nuk lejohet.'**
  String get gamifyDivisionByZero;

  /// No description provided for @gamifyDivisionNeedsWholeResult.
  ///
  /// In sq, this message translates to:
  /// **'Ky pjesëtim nuk jep rezultat të plotë ({num1} ÷ {num2}). Zgjidh një ushtrim që ndahet pa mbetje.'**
  String gamifyDivisionNeedsWholeResult(int num1, int num2);

  /// No description provided for @gamifyAdditionSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: {num1} + {num2} = ?\n\n📚 HAPI I PARË: Imagjinoni {num1} ballona që ngrihen në qiell!\n🎈 HAPI I DYTË: Shtojmë edhe {num2} ballona - tani kemi {answer} në total!\n✨ PËRGJIGJA FINALE: {answer}\n\n💡 TRIKU ARGËTUES: Çdo shifër në {answer} përfaqëson një yll në qiellin e natës! 🌟'**
  String gamifyAdditionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifySubtractionSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: {num1} - {num2} = ?\n\n🍎 HAPI I PARË: Kemi {num1} mollë të shijshme në një kosh!\n😋 HAPI I DYTË: Hamë {num2} mollë - mbeten {answer} mollë të shijshme!\n✨ PËRGJIGJA FINALE: {answer}\n\n💡 TRIKU ARGËTUES: {answer} janë mollët që mbeten për piknikun tënd! 🍎'**
  String gamifySubtractionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyMultiplicationSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: {num1} × {num2} = ?\n\n🏗️ HAPI I PARË: Ndërtojmë një fort me {num1} kube në çdo rresht!\n🏰 HAPI I DYTË: Forti ka {num2} rreshta - në total {answer} kube!\n✨ PËRGJIGJA FINALE: {answer}\n\n💡 TRIKU ARGËTUES: Shumëzimi është si të ndërtosh me blloqe - sa më shumë rreshta, aq më i madh forti! 📦'**
  String gamifyMultiplicationSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyDivisionSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: {num1} ÷ {num2} = ?\n\n🍕 HAPI I PARË: Kemi {num1} pjesë pice për t’i ndarë!\n👨‍👩‍👧‍👦 HAPI I DYTË: I ndajmë mes {num2} shokëve - secili merr {answer} pjesë!\n✨ PËRGJIGJA FINALE: {answer}\n\n💡 TRIKU ARGËTUES: Pjesëtimi është si të ndash një surprizë - çdo mik merr pjesën e vet! 🎉'**
  String gamifyDivisionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyGenericSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE 🎮\n\nEkuacioni juaj: \"{exercise}\"\n\n📚 Duket si një sfidë interesante!\n🧮 Këtu janë disa këshilla për ta zgjidhur:\n\n1. 🔍 Shikoni me kujdes numrat në ekuacion\n2. 🧠 Mendoni se çfarë operacioni të përdorni (+, -, ×, ÷)\n3. ✍️ Shkruani hap pas hapi\n4. ✅ Kontrolloni përgjigjen tuaj\n\n💡 Kujtohuni: Matematika është një lojë argëtuese! 🎮\n\nPër shembull:\n- 5 + 3 = 8 (Mbledhje)\n- 10 - 4 = 6 (Zbritje)\n- 7 × 2 = 14 (Shumëzim)\n- 12 ÷ 3 = 4 (Pjesëtim)'**
  String gamifyGenericSolution(Object exercise);

  /// No description provided for @gamifyInvalidSolution.
  ///
  /// In sq, this message translates to:
  /// **'🎮 ZGJIDHJA ARGËTUESE 🎮\n\nEkuacioni: \"{exercise}\"\n\nHmm, duhet të jetë më i qartë! 🤔\n📝 Përpiquni ta rishkruani ekuacionin me numra dhe operacione të qarta.\n\nShembuj të mirë:\n✅ \"5 + 3\"\n✅ \"10 - 7\"\n✅ \"6 * 4\"\n✅ \"20 / 5\"\n\nPërpiquni përsëri! 💪'**
  String gamifyInvalidSolution(Object exercise);

  /// No description provided for @gamifySymbolicSolution.
  ///
  /// In sq, this message translates to:
  /// **'✨ SHPREHJE ALGJEBRIKE ✨\n\nShprehja: {exercise}\n\n🔤 Kjo është një shprehje me ndryshore, jo një llogaritje me numra të gatshëm.\n🧩 Termat {leftOperand} dhe {rightOperand} duhen zëvendësuar me vlera për të gjetur përgjigjen.\n\n📘 Shembull:\nNëse a = 3 dhe b = 4, atëherë a^2 + b^2 = 3^2 + 4^2 = 9 + 16 = 25.\n\n💡 Pa vlerat e ndryshoreve, shprehja nuk ka një përgjigje numerike të vetme.'**
  String gamifySymbolicSolution(
    Object exercise,
    Object leftOperand,
    Object rightOperand,
  );

  /// No description provided for @gamifyDifferenceOfSquaresSolution.
  ///
  /// In sq, this message translates to:
  /// **'✨ DIFERENCA E KATRORËVE ✨\n\nShprehja: {exercise}\n\n🧠 Kjo është një formulë e njohur: a^2 - b^2 = (a - b)(a + b).\n🧩 Për termat {leftOperand} dhe {rightOperand}, forma e faktorizuar bëhet:\n({leftOperand} - {rightOperand})({leftOperand} + {rightOperand})\n\n💡 Ky truk të ndihmon të kalosh nga katrorët te prodhimi i dy kllapave.'**
  String gamifyDifferenceOfSquaresSolution(
    Object exercise,
    Object leftOperand,
    Object rightOperand,
  );

  /// No description provided for @gamifyQuadraticSolution.
  ///
  /// In sq, this message translates to:
  /// **'✨ SHPREHJE KUADRATIKE ✨\n\nShprehja: {exercise}\n\n📘 Kjo është një ekuacion kuadratik me ndryshoren {variable}.\n🧩 Një mënyrë e zakonshme zgjidhjeje është faktorizimi:\n{factorization}\n\n💡 Pasi faktorizon, vendos secilën kllapë baraz me zero për të gjetur zgjidhjet.'**
  String gamifyQuadraticSolution(
    Object exercise,
    Object variable,
    Object factorization,
  );
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
