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
  /// **'MathLingo - Udhëtimi i matematikës'**
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
  /// **'Sfida e ditës'**
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
  /// **'Mirë se vjen!'**
  String get dashboardWelcomeTitle;

  /// No description provided for @dashboardWelcomeSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Mirë se vjen në stacionin kozmik. Zgjidh rrugëtimin tënd në matematikë: i lehtë ose sfidues.'**
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
  /// **'Argëto ushtrimet'**
  String get dashboardGamifyChip;

  /// No description provided for @dashboardGamifyTitle.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ose shkruaj ushtrimin'**
  String get dashboardGamifyTitle;

  /// No description provided for @dashboardGamifyDescription.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ekuacionin që të duket i vështirë, ose shkruaje drejtpërdrejt, dhe Stitch do të të udhëheqë hap pas hapi drejt zgjidhjes.'**
  String get dashboardGamifyDescription;

  /// No description provided for @dashboardStartAdventure.
  ///
  /// In sq, this message translates to:
  /// **'Nis aventurën'**
  String get dashboardStartAdventure;

  /// No description provided for @dashboardProgressModuleTitle.
  ///
  /// In sq, this message translates to:
  /// **'Progresi i moduleve'**
  String get dashboardProgressModuleTitle;

  /// No description provided for @dashboardProgressAbstractAlgebra.
  ///
  /// In sq, this message translates to:
  /// **'Algjebra abstrakte'**
  String get dashboardProgressAbstractAlgebra;

  /// No description provided for @dashboardProgressMathematicalAnalysis.
  ///
  /// In sq, this message translates to:
  /// **'Analiza matematike'**
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
  /// **'Veprime të shpejta'**
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
  /// **'Mbledhja'**
  String get dashboardOperationAddition;

  /// No description provided for @dashboardOperationSubtraction.
  ///
  /// In sq, this message translates to:
  /// **'Zbritja'**
  String get dashboardOperationSubtraction;

  /// No description provided for @dashboardOperationMultiplication.
  ///
  /// In sq, this message translates to:
  /// **'Shumëzimi'**
  String get dashboardOperationMultiplication;

  /// No description provided for @dashboardOperationDivision.
  ///
  /// In sq, this message translates to:
  /// **'Pjesëtimi'**
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
  /// **'Mjetet e llogaritjes'**
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
  /// **'Tabelat e matematikës'**
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
  /// **'Argëto ushtrimet'**
  String get gamifyScreenTitle;

  /// No description provided for @gamifyInputTitle.
  ///
  /// In sq, this message translates to:
  /// **'Fotografo ose shkruaj ushtrimin'**
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
  /// **'Zgjidhja kozmike'**
  String get gamifySolutionTitle;

  /// No description provided for @gamifyRecognizedTextLabel.
  ///
  /// In sq, this message translates to:
  /// **'Teksti i njohur:'**
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
  /// **'Shkruaj ushtrimin'**
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
  /// **'Ndodhi një parregullsi gjatë leximit të tekstit: {error}'**
  String gamifyOcrProcessingError(Object error);

  /// No description provided for @gamifyEmptyEquationError.
  ///
  /// In sq, this message translates to:
  /// **'Të lutem, shkruaj ose fotografo një ekuacion.'**
  String get gamifyEmptyEquationError;

  /// No description provided for @gamifyImagePickError.
  ///
  /// In sq, this message translates to:
  /// **'Ndodhi një parregullsi gjatë zgjedhjes së imazhit: {error}'**
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
  /// **'Ky pjesëtim nuk jep numër të plotë ({num1} ÷ {num2}). Zgjidh një ushtrim që pjesëtohet pa mbetje.'**
  String gamifyDivisionNeedsWholeResult(int num1, int num2);

  /// No description provided for @gamifyAdditionSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nEkuacioni: {num1} + {num2} = ?\n\nHapi 1: Imagjino {num1} yje në orbitë.\nHapi 2: Shto edhe {num2} yje.\nPërgjigjja: {answer}.\n\nStitch të kujton: te mbledhja i bashkojmë të gjitha pjesët në një tërësi.'**
  String gamifyAdditionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifySubtractionSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nEkuacioni: {num1} - {num2} = ?\n\nHapi 1: Nisemi me {num1} njësi.\nHapi 2: Heqim {num2} njësi.\nPërgjigjja: {answer}.\n\nStitch të kujton: te zbritja gjejmë sa mbetet pas heqjes.'**
  String gamifySubtractionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyMultiplicationSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nEkuacioni: {num1} × {num2} = ?\n\nHapi 1: Krijo {num2} grupe të barabarta.\nHapi 2: Në çdo grup vendos {num1} njësi.\nPërgjigjja: {answer}.\n\nStitch të kujton: shumëzimi është mbledhje e përsëritur.'**
  String gamifyMultiplicationSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyDivisionSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nEkuacioni: {num1} ÷ {num2} = ?\n\nHapi 1: Merr {num1} njësi për t\'i ndarë.\nHapi 2: Ndaji në {num2} grupe të barabarta.\nPërgjigjja: {answer}.\n\nStitch të kujton: pjesëtimi tregon sa merr çdo grup.'**
  String gamifyDivisionSolution(int num1, int num2, int answer);

  /// No description provided for @gamifyGenericSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nShprehja jote: \"{exercise}\"\n\nKjo sfidë kërkon pak më shumë vëzhgim.\n1. Vëzhgo numrat dhe shenjat matematikore.\n2. Përcakto veprimin: mbledhja, zbritja, shumëzimi ose pjesëtimi.\n3. Zgjidhe hap pas hapi.\n4. Kontrollo rezultatin në fund.\n\nStitch të kujton: çdo ushtrim ndahet në hapa të vegjël dhe të qartë.'**
  String gamifyGenericSolution(Object exercise);

  /// No description provided for @gamifyInvalidSolution.
  ///
  /// In sq, this message translates to:
  /// **'Misioni kozmik i zgjidhjes\n\nShprehja: \"{exercise}\"\n\nKjo shprehje nuk u lexua qartë. Provoje përsëri me numra dhe veprime të plota.\n\nShembuj të vlefshëm:\n- \"5 + 3\"\n- \"10 - 7\"\n- \"6 * 4\"\n- \"20 / 5\"\n\nStitch pret komandën tënde të radhës.'**
  String gamifyInvalidSolution(Object exercise);

  /// No description provided for @fractionKicker.
  ///
  /// In sq, this message translates to:
  /// **'FRAKSIONET'**
  String get fractionKicker;

  /// No description provided for @fractionTitle.
  ///
  /// In sq, this message translates to:
  /// **'Identifiko fraksionin'**
  String get fractionTitle;

  /// No description provided for @fractionPrompt.
  ///
  /// In sq, this message translates to:
  /// **'Cili fraksion tregon pjesën e ngjyrosur?'**
  String get fractionPrompt;

  /// No description provided for @fractionCorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Saktë! Vazhdon fluturimi.'**
  String get fractionCorrectFeedback;

  /// No description provided for @fractionIncorrectFeedback.
  ///
  /// In sq, this message translates to:
  /// **'Provo përsëri. Je shumë afër.'**
  String get fractionIncorrectFeedback;

  /// No description provided for @fractionOneHalf.
  ///
  /// In sq, this message translates to:
  /// **'gjysmë (½)'**
  String get fractionOneHalf;

  /// No description provided for @fractionOneThird.
  ///
  /// In sq, this message translates to:
  /// **'një e treta (⅓)'**
  String get fractionOneThird;

  /// No description provided for @fractionOneQuarter.
  ///
  /// In sq, this message translates to:
  /// **'një e katërta (¼)'**
  String get fractionOneQuarter;

  /// No description provided for @fractionThreeQuarters.
  ///
  /// In sq, this message translates to:
  /// **'tre të katërtat (¾)'**
  String get fractionThreeQuarters;

  /// No description provided for @fractionTwoThirds.
  ///
  /// In sq, this message translates to:
  /// **'dy të tretat (⅔)'**
  String get fractionTwoThirds;

  /// No description provided for @fractionOneEighth.
  ///
  /// In sq, this message translates to:
  /// **'një e teta (⅛)'**
  String get fractionOneEighth;

  /// No description provided for @fractionThreeEighths.
  ///
  /// In sq, this message translates to:
  /// **'tre të tetat (⅜)'**
  String get fractionThreeEighths;

  /// No description provided for @fractionFiveEighths.
  ///
  /// In sq, this message translates to:
  /// **'pesë të tetat (⅝)'**
  String get fractionFiveEighths;

  /// No description provided for @fractionSevenEighths.
  ///
  /// In sq, this message translates to:
  /// **'shtatë të tetat (⅞)'**
  String get fractionSevenEighths;

  /// No description provided for @dashboardFractionsChip.
  ///
  /// In sq, this message translates to:
  /// **'Fraksionet'**
  String get dashboardFractionsChip;

  /// No description provided for @dashboardFractionsTitle.
  ///
  /// In sq, this message translates to:
  /// **'Mëso fraksionet'**
  String get dashboardFractionsTitle;

  /// No description provided for @dashboardFractionsDescription.
  ///
  /// In sq, this message translates to:
  /// **'Identifiko fraksionet duke shikuar figura vizuale si tarte dhe shirita të ndarë.'**
  String get dashboardFractionsDescription;

  /// No description provided for @dashboardFractionsButton.
  ///
  /// In sq, this message translates to:
  /// **'Fillo sfidën'**
  String get dashboardFractionsButton;

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

  /// No description provided for @authSignUpTitle.
  ///
  /// In sq, this message translates to:
  /// **'Krijo llogari prindi'**
  String get authSignUpTitle;

  /// No description provided for @authSignInTitle.
  ///
  /// In sq, this message translates to:
  /// **'Hyrja e prindit'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Hyr për të sinkronizuar progresin në pajisje të shumta.'**
  String get authSignInSubtitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Rezervo progresin e fëmijëve në cloud.'**
  String get authSignUpSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In sq, this message translates to:
  /// **'Email-i i prindit'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In sq, this message translates to:
  /// **'prindi@shembull.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In sq, this message translates to:
  /// **'Fjalëkalimi'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In sq, this message translates to:
  /// **'Min. 8 karaktere, 1 numër'**
  String get authPasswordHint;

  /// No description provided for @authWeakPasswordHint.
  ///
  /// In sq, this message translates to:
  /// **'Min. 8 karaktere dhe 1 numër.'**
  String get authWeakPasswordHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In sq, this message translates to:
  /// **'Konfirmo fjalëkalimin'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In sq, this message translates to:
  /// **'Shkruaje sërish fjalëkalimin'**
  String get authConfirmPasswordHint;

  /// No description provided for @authSignUpButton.
  ///
  /// In sq, this message translates to:
  /// **'Regjistrohu'**
  String get authSignUpButton;

  /// No description provided for @authSignInButton.
  ///
  /// In sq, this message translates to:
  /// **'Hyr'**
  String get authSignInButton;

  /// No description provided for @authSigningUp.
  ///
  /// In sq, this message translates to:
  /// **'Duke u regjistruar...'**
  String get authSigningUp;

  /// No description provided for @authSigningIn.
  ///
  /// In sq, this message translates to:
  /// **'Duke hyrë...'**
  String get authSigningIn;

  /// No description provided for @authHaveAccount.
  ///
  /// In sq, this message translates to:
  /// **'Ke llogari? Hyr këtu'**
  String get authHaveAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In sq, this message translates to:
  /// **'Nuk ke llogari? Regjistrohu'**
  String get authNoAccount;

  /// No description provided for @authForgotPassword.
  ///
  /// In sq, this message translates to:
  /// **'Harruat fjalëkalimin?'**
  String get authForgotPassword;

  /// No description provided for @authResetEmailEnterFirst.
  ///
  /// In sq, this message translates to:
  /// **'Shkruaj fillimisht email-in.'**
  String get authResetEmailEnterFirst;

  /// No description provided for @authResetEmailSent.
  ///
  /// In sq, this message translates to:
  /// **'Email-i i rivendosjes u dërgua.'**
  String get authResetEmailSent;

  /// No description provided for @authResetEmailError.
  ///
  /// In sq, this message translates to:
  /// **'Ndodhi një gabim. Kontrollo email-in.'**
  String get authResetEmailError;

  /// No description provided for @authPrivacyNote.
  ///
  /// In sq, this message translates to:
  /// **'Të dhënat ruhen me enkriptim. Nuk ndahen me palë të treta.'**
  String get authPrivacyNote;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In sq, this message translates to:
  /// **'Ky email është i regjistruar tashmë.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In sq, this message translates to:
  /// **'Formati i email-it nuk është i saktë.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In sq, this message translates to:
  /// **'Fjalëkalimi duhet të ketë ≥8 karaktere dhe 1 numër.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorPasswordMismatch.
  ///
  /// In sq, this message translates to:
  /// **'Fjalëkalimet nuk përputhen.'**
  String get authErrorPasswordMismatch;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In sq, this message translates to:
  /// **'Nuk u gjet llogari me këtë email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In sq, this message translates to:
  /// **'Fjalëkalimi nuk është i saktë.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In sq, this message translates to:
  /// **'Shumë tentativa. Provo pas disa minutash.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetwork.
  ///
  /// In sq, this message translates to:
  /// **'Problem me lidhjen. Kontrollo internetin.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorFirebaseNotReady.
  ///
  /// In sq, this message translates to:
  /// **'Shërbimi nuk është gati. Provo sërish.'**
  String get authErrorFirebaseNotReady;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In sq, this message translates to:
  /// **'Kjo llogari është çaktivizuar.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorUnknown.
  ///
  /// In sq, this message translates to:
  /// **'Ndodhi një gabim. Provo sërish.'**
  String get authErrorUnknown;

  /// No description provided for @authErrorEmptyFields.
  ///
  /// In sq, this message translates to:
  /// **'Plotësoni të gjitha fushat.'**
  String get authErrorEmptyFields;

  /// No description provided for @syncEnabled.
  ///
  /// In sq, this message translates to:
  /// **'Sinkronizimi në cloud është aktiv'**
  String get syncEnabled;

  /// No description provided for @syncDisabled.
  ///
  /// In sq, this message translates to:
  /// **'Sinkronizimi në cloud nuk është aktiv'**
  String get syncDisabled;

  /// No description provided for @syncLastSync.
  ///
  /// In sq, this message translates to:
  /// **'Sinkronizim i fundit: {date}'**
  String syncLastSync(Object date);

  /// No description provided for @authDeleteAccountTitle.
  ///
  /// In sq, this message translates to:
  /// **'Fshi llogarinë në cloud'**
  String get authDeleteAccountTitle;

  /// No description provided for @authDeleteAccountConfirm.
  ///
  /// In sq, this message translates to:
  /// **'Kjo do të fshijë llogarinë tuaj dhe të gjitha të dhënat nga cloud. Veprimi nuk mund të zhbëhet.'**
  String get authDeleteAccountConfirm;

  /// No description provided for @authDeleteAccountButton.
  ///
  /// In sq, this message translates to:
  /// **'Fshi llogarinë'**
  String get authDeleteAccountButton;

  /// No description provided for @authSignOutButton.
  ///
  /// In sq, this message translates to:
  /// **'Dil nga llogaria'**
  String get authSignOutButton;

  /// No description provided for @parentReportTitle.
  ///
  /// In sq, this message translates to:
  /// **'Raporti javor'**
  String get parentReportTitle;

  /// No description provided for @weeklyTrend.
  ///
  /// In sq, this message translates to:
  /// **'Tendenca e javës'**
  String get weeklyTrend;

  /// No description provided for @dailyPoints.
  ///
  /// In sq, this message translates to:
  /// **'Pikët ditore'**
  String get dailyPoints;

  /// No description provided for @accuracyTrend.
  ///
  /// In sq, this message translates to:
  /// **'Tendenca e saktësisë'**
  String get accuracyTrend;

  /// No description provided for @noDataYet.
  ///
  /// In sq, this message translates to:
  /// **'Nis sfidën e parë për të parë progresin këtu.'**
  String get noDataYet;
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
