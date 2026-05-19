// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get appTitle => 'MathLingo - Udhëtimi i matematikës';

  @override
  String get commonPointsLabel => 'Pikët';

  @override
  String get commonAccuracyLabel => 'Saktësia';

  @override
  String get commonContinue => 'Vazhdo';

  @override
  String get tabDailyChallenge => 'Sfida e ditës';

  @override
  String get tabLessons => 'Mësime';

  @override
  String get tabTables => 'Tabelat';

  @override
  String get tabProgress => 'Progresi';

  @override
  String get dashboardWelcomeTitle => 'Mirë se vjen!';

  @override
  String get dashboardWelcomeSubtitle =>
      'Mirë se vjen në stacionin kozmik. Zgjidh rrugëtimin tënd në matematikë: i lehtë ose sfidues.';

  @override
  String get dashboardDailyChallengeTitle => 'Gjeometria Bazë';

  @override
  String get dashboardDailyChallengeDescription =>
      'Mësoni format dhe llogaritni sipërfaqe të thjeshta me ndihmën e mikut tuaj AI.';

  @override
  String get dashboardStartChallenge => 'Fillo Sfidën';

  @override
  String get dashboardGamifyChip => 'Argëto ushtrimet';

  @override
  String get dashboardGamifyTitle => 'Fotografo ose shkruaj ushtrimin';

  @override
  String get dashboardGamifyDescription =>
      'Fotografo ekuacionin që të duket i vështirë, ose shkruaje drejtpërdrejt, dhe Stitch do të të udhëheqë hap pas hapi drejt zgjidhjes.';

  @override
  String get dashboardStartAdventure => 'Nis aventurën';

  @override
  String get dashboardProgressModuleTitle => 'Progresi i moduleve';

  @override
  String get dashboardProgressAbstractAlgebra => 'Algjebra abstrakte';

  @override
  String get dashboardProgressMathematicalAnalysis => 'Analiza matematike';

  @override
  String dashboardProgressPointsLabel(int points) {
    return 'Pikë totale: $points';
  }

  @override
  String dashboardProgressAccuracyLabel(int accuracy) {
    return 'Saktësia mesatare: $accuracy%';
  }

  @override
  String get dashboardQuickActionsTitle => 'Veprime të shpejta';

  @override
  String get dashboardProfileComingSoon => 'Profili do të shtohet së shpejti.';

  @override
  String get dashboardNotificationsComingSoon =>
      'Njoftimet do të shtohen së shpejti.';

  @override
  String get dashboardOperationAddition => 'Mbledhja';

  @override
  String get dashboardOperationSubtraction => 'Zbritja';

  @override
  String get dashboardOperationMultiplication => 'Shumëzimi';

  @override
  String get dashboardOperationDivision => 'Pjesëtimi';

  @override
  String get challengeKicker => 'ALGJEBRA BAZË';

  @override
  String get challengeTitle => 'Zgjidh ekuacionin';

  @override
  String challengeScoreLabel(int score) {
    return 'Pikët: $score';
  }

  @override
  String challengeEquationPrompt(int num1, Object symbol, int num2) {
    return '$num1 $symbol $num2 = ?';
  }

  @override
  String get challengeCorrectFeedback => 'Saktë! Vazhdon fluturimi.';

  @override
  String get challengeIncorrectFeedback => 'Provo përsëri. Je shumë afër.';

  @override
  String get resultsTitle => 'Bravo!';

  @override
  String get resultsSubtitle => 'Përfundove me sukses sfidën.';

  @override
  String resultsPointsValue(int points) {
    return '+$points';
  }

  @override
  String resultsAccuracyValue(int accuracy) {
    return '$accuracy%';
  }

  @override
  String get geometryKicker => 'GJEOMETRIA BAZË';

  @override
  String get geometryTitle => 'Sfida Gjeometrike';

  @override
  String geometryScoreLabel(int score) {
    return 'Pikët: $score';
  }

  @override
  String get geometryCorrectFeedback => 'Saktë! Forma u analizua.';

  @override
  String get geometryIncorrectFeedback =>
      'Jo ende. Shiko matjet dhe provo përsëri.';

  @override
  String get geometryRectanglePrompt => 'Sa është sipërfaqja e drejtkëndëshit?';

  @override
  String get geometryTrianglePrompt => 'Sa është sipërfaqja e trekëndëshit?';

  @override
  String get geometrySquarePrompt => 'Sa është perimetri i katrorit?';

  @override
  String geometryRectangleMeasurement(int width, int height) {
    return 'gjerësi $width, lartësi $height';
  }

  @override
  String geometryTriangleMeasurement(int width, int height) {
    return 'bazë $width, lartësi $height';
  }

  @override
  String geometrySquareMeasurement(int width) {
    return 'brinja $width';
  }

  @override
  String get legacyGeometryRectangleLabel => 'Drejtkëndësh';

  @override
  String get legacyGeometrySquareLabel => 'Katror';

  @override
  String get legacyGeometryTriangleLabel => 'Trekëndësh';

  @override
  String get legacyGeometryPerimeterQuestion => 'Sa është perimetri?';

  @override
  String get legacyGeometryAreaQuestion => 'Sa është sipërfaqja?';

  @override
  String get legacyGeometryWrongAnswer => 'E gabuar, provo përsëri!';

  @override
  String get legacyGeometryResultTitle => 'Përfundim!';

  @override
  String legacyGeometryScoreSummary(int score, int total) {
    return 'Pikët: $score/$total';
  }

  @override
  String get legacyGeometrySuccessMessage => '👏 Bravo!';

  @override
  String get legacyGeometryRetryMessage => 'Përpiqu përsëri!';

  @override
  String get legacyGeometryFinish => 'Mbaroj';

  @override
  String legacyGeometryQuestionTitle(int current, int total) {
    return 'Pyetja $current/$total';
  }

  @override
  String legacyGeometryCurrentScore(int score) {
    return 'Pikët: $score';
  }

  @override
  String legacyGeometryShapeDimensions(Object shape, int width, int height) {
    return '$shape ($width × $height)';
  }

  @override
  String get lessonsToolsTitle => 'Mjetet e llogaritjes';

  @override
  String get progressPageTitle => 'Bravo!';

  @override
  String get progressPageSubtitle => 'Progresi yt po rritet çdo ditë.';

  @override
  String get progressPageTotalPointsLabel => 'Pikët totale';

  @override
  String get progressPageAverageAccuracyLabel => 'Saktësia mesatare';

  @override
  String get tablesTitle => 'Tabelat e matematikës';

  @override
  String get tablesSubtitle => 'Praktiko dhe zotëro të gjitha operacionet';

  @override
  String get tablesTabAddition => 'Mbledhje +';

  @override
  String get tablesTabSubtraction => 'Zbritje -';

  @override
  String get tablesTabMultiplication => 'Shumëzim ×';

  @override
  String get tablesTabDivision => 'Pjesëtim ÷';

  @override
  String tablesHeader(Object operation, int table) {
    return '$operation - Tabela e $table';
  }

  @override
  String get tablesChooseNumber => 'Zgjidh numrin';

  @override
  String tablesEquationSnackBar(
    int selectedTable,
    Object symbol,
    int operand,
    int result,
  ) {
    return '$selectedTable $symbol $operand = $result';
  }

  @override
  String get gamifyScreenTitle => 'Argëto ushtrimet';

  @override
  String get gamifyInputTitle => 'Fotografo ose shkruaj ushtrimin';

  @override
  String get gamifyInputSubtitle =>
      'Mund ta fotografosh ose ta shkruash ushtrimin. OCR funksionon më mirë me tekst të shtypur dhe imazhe të qarta.';

  @override
  String get gamifyClear => 'Fshij';

  @override
  String get gamifySolve => 'Zgjidh';

  @override
  String get gamifySolutionTitle => 'Zgjidhja kozmike';

  @override
  String get gamifyRecognizedTextLabel => 'Teksti i njohur:';

  @override
  String get gamifyCameraButton => 'Fotografo';

  @override
  String get gamifyGalleryButton => 'Galeria';

  @override
  String get gamifyWriteExerciseLabel => 'Shkruaj ushtrimin';

  @override
  String get gamifyExerciseHint => 'Shembull: 15 + 7';

  @override
  String get gamifyRecognizedPlaceholder =>
      'Ekuacioni u identifikua nga imazhi...';

  @override
  String get gamifyOcrProcessing => 'Po lexoj tekstin nga imazhi...';

  @override
  String get gamifyOcrNoTextDetected =>
      'Nuk u gjet tekst në imazh. Provo një foto më të qartë ose shkruaje ushtrimin manualisht.';

  @override
  String get gamifyOcrNoEquationFound =>
      'Nuk u gjet asnjë ekuacion matematikor në imazh.';

  @override
  String gamifyOcrProcessingError(Object error) {
    return 'Ndodhi një parregullsi gjatë leximit të tekstit: $error';
  }

  @override
  String get gamifyEmptyEquationError =>
      'Të lutem, shkruaj ose fotografo një ekuacion.';

  @override
  String gamifyImagePickError(Object error) {
    return 'Ndodhi një parregullsi gjatë zgjedhjes së imazhit: $error';
  }

  @override
  String gamifySubtractionNeedsPositiveResult(int num1, int num2) {
    return 'Ky ushtrim krijon rezultat negativ ($num1 - $num2). Përdor një zbritje ku numri i parë është më i madh.';
  }

  @override
  String get gamifyDivisionByZero => 'Pjesëtimi me zero nuk lejohet.';

  @override
  String gamifyDivisionNeedsWholeResult(int num1, int num2) {
    return 'Ky pjesëtim nuk jep numër të plotë ($num1 ÷ $num2). Zgjidh një ushtrim që pjesëtohet pa mbetje.';
  }

  @override
  String gamifyAdditionSolution(int num1, int num2, int answer) {
    return 'Misioni kozmik i zgjidhjes\n\nEkuacioni: $num1 + $num2 = ?\n\nHapi 1: Imagjino $num1 yje në orbitë.\nHapi 2: Shto edhe $num2 yje.\nPërgjigjja: $answer.\n\nStitch të kujton: te mbledhja i bashkojmë të gjitha pjesët në një tërësi.';
  }

  @override
  String gamifySubtractionSolution(int num1, int num2, int answer) {
    return 'Misioni kozmik i zgjidhjes\n\nEkuacioni: $num1 - $num2 = ?\n\nHapi 1: Nisemi me $num1 njësi.\nHapi 2: Heqim $num2 njësi.\nPërgjigjja: $answer.\n\nStitch të kujton: te zbritja gjejmë sa mbetet pas heqjes.';
  }

  @override
  String gamifyMultiplicationSolution(int num1, int num2, int answer) {
    return 'Misioni kozmik i zgjidhjes\n\nEkuacioni: $num1 × $num2 = ?\n\nHapi 1: Krijo $num2 grupe të barabarta.\nHapi 2: Në çdo grup vendos $num1 njësi.\nPërgjigjja: $answer.\n\nStitch të kujton: shumëzimi është mbledhje e përsëritur.';
  }

  @override
  String gamifyDivisionSolution(int num1, int num2, int answer) {
    return 'Misioni kozmik i zgjidhjes\n\nEkuacioni: $num1 ÷ $num2 = ?\n\nHapi 1: Merr $num1 njësi për t\'i ndarë.\nHapi 2: Ndaji në $num2 grupe të barabarta.\nPërgjigjja: $answer.\n\nStitch të kujton: pjesëtimi tregon sa merr çdo grup.';
  }

  @override
  String gamifyGenericSolution(Object exercise) {
    return 'Misioni kozmik i zgjidhjes\n\nShprehja jote: \"$exercise\"\n\nKjo sfidë kërkon pak më shumë vëzhgim.\n1. Vëzhgo numrat dhe shenjat matematikore.\n2. Përcakto veprimin: mbledhja, zbritja, shumëzimi ose pjesëtimi.\n3. Zgjidhe hap pas hapi.\n4. Kontrollo rezultatin në fund.\n\nStitch të kujton: çdo ushtrim ndahet në hapa të vegjël dhe të qartë.';
  }

  @override
  String gamifyInvalidSolution(Object exercise) {
    return 'Misioni kozmik i zgjidhjes\n\nShprehja: \"$exercise\"\n\nKjo shprehje nuk u lexua qartë. Provoje përsëri me numra dhe veprime të plota.\n\nShembuj të vlefshëm:\n- \"5 + 3\"\n- \"10 - 7\"\n- \"6 * 4\"\n- \"20 / 5\"\n\nStitch pret komandën tënde të radhës.';
  }

  @override
  String get fractionKicker => 'FRAKSIONET';

  @override
  String get fractionTitle => 'Identifiko fraksionin';

  @override
  String get fractionPrompt => 'Cili fraksion tregon pjesën e ngjyrosur?';

  @override
  String get fractionCorrectFeedback => 'Saktë! Vazhdon fluturimi.';

  @override
  String get fractionIncorrectFeedback => 'Provo përsëri. Je shumë afër.';

  @override
  String get fractionOneHalf => 'gjysmë (½)';

  @override
  String get fractionOneThird => 'një e treta (⅓)';

  @override
  String get fractionOneQuarter => 'një e katërta (¼)';

  @override
  String get fractionThreeQuarters => 'tre të katërtat (¾)';

  @override
  String get fractionTwoThirds => 'dy të tretat (⅔)';

  @override
  String get fractionOneEighth => 'një e teta (⅛)';

  @override
  String get fractionThreeEighths => 'tre të tetat (⅜)';

  @override
  String get fractionFiveEighths => 'pesë të tetat (⅝)';

  @override
  String get fractionSevenEighths => 'shtatë të tetat (⅞)';

  @override
  String get dashboardFractionsChip => 'Fraksionet';

  @override
  String get dashboardFractionsTitle => 'Mëso fraksionet';

  @override
  String get dashboardFractionsDescription =>
      'Identifiko fraksionet duke shikuar figura vizuale si tarte dhe shirita të ndarë.';

  @override
  String get dashboardFractionsButton => 'Fillo sfidën';

  @override
  String gamifySymbolicSolution(
    Object exercise,
    Object leftOperand,
    Object rightOperand,
  ) {
    return '✨ SHPREHJE ALGJEBRIKE ✨\n\nShprehja: $exercise\n\n🔤 Kjo është një shprehje me ndryshore, jo një llogaritje me numra të gatshëm.\n🧩 Termat $leftOperand dhe $rightOperand duhen zëvendësuar me vlera për të gjetur përgjigjen.\n\n📘 Shembull:\nNëse a = 3 dhe b = 4, atëherë a^2 + b^2 = 3^2 + 4^2 = 9 + 16 = 25.\n\n💡 Pa vlerat e ndryshoreve, shprehja nuk ka një përgjigje numerike të vetme.';
  }

  @override
  String gamifyDifferenceOfSquaresSolution(
    Object exercise,
    Object leftOperand,
    Object rightOperand,
  ) {
    return '✨ DIFERENCA E KATRORËVE ✨\n\nShprehja: $exercise\n\n🧠 Kjo është një formulë e njohur: a^2 - b^2 = (a - b)(a + b).\n🧩 Për termat $leftOperand dhe $rightOperand, forma e faktorizuar bëhet:\n($leftOperand - $rightOperand)($leftOperand + $rightOperand)\n\n💡 Ky truk të ndihmon të kalosh nga katrorët te prodhimi i dy kllapave.';
  }

  @override
  String gamifyQuadraticSolution(
    Object exercise,
    Object variable,
    Object factorization,
  ) {
    return '✨ SHPREHJE KUADRATIKE ✨\n\nShprehja: $exercise\n\n📘 Kjo është një ekuacion kuadratik me ndryshoren $variable.\n🧩 Një mënyrë e zakonshme zgjidhjeje është faktorizimi:\n$factorization\n\n💡 Pasi faktorizon, vendos secilën kllapë baraz me zero për të gjetur zgjidhjet.';
  }

  @override
  String get authSignUpTitle => 'Krijo llogari prindi';

  @override
  String get authSignInTitle => 'Hyrja e prindit';

  @override
  String get authSignInSubtitle =>
      'Hyr për të sinkronizuar progresin në pajisje të shumta.';

  @override
  String get authSignUpSubtitle => 'Rezervo progresin e fëmijëve në cloud.';

  @override
  String get authEmailLabel => 'Email-i i prindit';

  @override
  String get authEmailHint => 'prindi@shembull.com';

  @override
  String get authPasswordLabel => 'Fjalëkalimi';

  @override
  String get authPasswordHint => 'Min. 8 karaktere, 1 numër';

  @override
  String get authWeakPasswordHint => 'Min. 8 karaktere dhe 1 numër.';

  @override
  String get authConfirmPasswordLabel => 'Konfirmo fjalëkalimin';

  @override
  String get authConfirmPasswordHint => 'Shkruaje sërish fjalëkalimin';

  @override
  String get authSignUpButton => 'Regjistrohu';

  @override
  String get authSignInButton => 'Hyr';

  @override
  String get authSigningUp => 'Duke u regjistruar...';

  @override
  String get authSigningIn => 'Duke hyrë...';

  @override
  String get authHaveAccount => 'Ke llogari? Hyr këtu';

  @override
  String get authNoAccount => 'Nuk ke llogari? Regjistrohu';

  @override
  String get authForgotPassword => 'Harruat fjalëkalimin?';

  @override
  String get authResetEmailEnterFirst => 'Shkruaj fillimisht email-in.';

  @override
  String get authResetEmailSent => 'Email-i i rivendosjes u dërgua.';

  @override
  String get authResetEmailError => 'Ndodhi një gabim. Kontrollo email-in.';

  @override
  String get authPrivacyNote =>
      'Të dhënat ruhen me enkriptim. Nuk ndahen me palë të treta.';

  @override
  String get authErrorEmailInUse => 'Ky email është i regjistruar tashmë.';

  @override
  String get authErrorInvalidEmail => 'Formati i email-it nuk është i saktë.';

  @override
  String get authErrorWeakPassword =>
      'Fjalëkalimi duhet të ketë ≥8 karaktere dhe 1 numër.';

  @override
  String get authErrorPasswordMismatch => 'Fjalëkalimet nuk përputhen.';

  @override
  String get authErrorUserNotFound => 'Nuk u gjet llogari me këtë email.';

  @override
  String get authErrorWrongPassword => 'Fjalëkalimi nuk është i saktë.';

  @override
  String get authErrorTooManyRequests =>
      'Shumë tentativa. Provo pas disa minutash.';

  @override
  String get authErrorNetwork => 'Problem me lidhjen. Kontrollo internetin.';

  @override
  String get authErrorFirebaseNotReady =>
      'Shërbimi nuk është gati. Provo sërish.';

  @override
  String get authErrorUserDisabled => 'Kjo llogari është çaktivizuar.';

  @override
  String get authErrorUnknown => 'Ndodhi një gabim. Provo sërish.';

  @override
  String get authErrorEmptyFields => 'Plotësoni të gjitha fushat.';

  @override
  String get syncEnabled => 'Sinkronizimi në cloud është aktiv';

  @override
  String get syncDisabled => 'Sinkronizimi në cloud nuk është aktiv';

  @override
  String syncLastSync(Object date) {
    return 'Sinkronizim i fundit: $date';
  }

  @override
  String get authDeleteAccountTitle => 'Fshi llogarinë në cloud';

  @override
  String get authDeleteAccountConfirm =>
      'Kjo do të fshijë llogarinë tuaj dhe të gjitha të dhënat nga cloud. Veprimi nuk mund të zhbëhet.';

  @override
  String get authDeleteAccountButton => 'Fshi llogarinë';

  @override
  String get authSignOutButton => 'Dil nga llogaria';

  @override
  String get parentReportTitle => 'Raporti javor';

  @override
  String get weeklyTrend => 'Tendenca e javës';

  @override
  String get dailyPoints => 'Pikët ditore';

  @override
  String get accuracyTrend => 'Tendenca e saktësisë';

  @override
  String get noDataYet => 'Nis sfidën e parë për të parë progresin këtu.';
}
