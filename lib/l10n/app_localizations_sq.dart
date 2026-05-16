// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get appTitle => 'MathLingo - Aventura e Matematikës';

  @override
  String get commonPointsLabel => 'Pikët';

  @override
  String get commonAccuracyLabel => 'Saktësia';

  @override
  String get commonContinue => 'Vazhdo';

  @override
  String get tabDailyChallenge => 'Sfida e Ditës';

  @override
  String get tabLessons => 'Mësime';

  @override
  String get tabTables => 'Tabelat';

  @override
  String get tabProgress => 'Progresi';

  @override
  String get dashboardWelcomeTitle => 'Mirësevini!';

  @override
  String get dashboardWelcomeSubtitle =>
      'Zgjedh një mënyrë për të mësuar matematikën - më lehtë ose më sfiduese.';

  @override
  String get dashboardDailyChallengeTitle => 'Gjeometria Bazë';

  @override
  String get dashboardDailyChallengeDescription =>
      'Mësoni format dhe llogaritni sipërfaqe të thjeshta me ndihmën e mikut tuaj AI.';

  @override
  String get dashboardStartChallenge => 'Fillo Sfidën';

  @override
  String get dashboardGamifyChip => 'Argëto Ushtrimet';

  @override
  String get dashboardGamifyTitle => 'Fotografo ose Shkruaj Ushtrimin';

  @override
  String get dashboardGamifyDescription =>
      'Fotografo ekuacionin që nuk e kupton, shkruaje direkt, dhe merrni zgjidhje argëtuese që të bëjnë matematikën më të lehtë për të kuptuar!';

  @override
  String get dashboardStartAdventure => 'Filloi Aventurën';

  @override
  String get dashboardProgressModuleTitle => 'Progresi i Modulit';

  @override
  String get dashboardProgressAbstractAlgebra => 'Algjebra Abstrakte';

  @override
  String get dashboardProgressMathematicalAnalysis => 'Analiza Matematike';

  @override
  String dashboardProgressPointsLabel(int points) {
    return 'Pikë totale: $points';
  }

  @override
  String dashboardProgressAccuracyLabel(int accuracy) {
    return 'Saktësia mesatare: $accuracy%';
  }

  @override
  String get dashboardQuickActionsTitle => 'Veprime të Shpejta';

  @override
  String get dashboardProfileComingSoon => 'Profili do të shtohet së shpejti.';

  @override
  String get dashboardNotificationsComingSoon =>
      'Njoftimet do të shtohen së shpejti.';

  @override
  String get dashboardOperationAddition => 'Mbledhje';

  @override
  String get dashboardOperationSubtraction => 'Zbritje';

  @override
  String get dashboardOperationMultiplication => 'Shumëzim';

  @override
  String get dashboardOperationDivision => 'Pjesëtim';

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
  String get lessonsToolsTitle => 'Mjetet e Llogaritjes';

  @override
  String get progressPageTitle => 'Bravo!';

  @override
  String get progressPageSubtitle => 'Progresi yt po rritet çdo ditë.';

  @override
  String get progressPageTotalPointsLabel => 'Pikët totale';

  @override
  String get progressPageAverageAccuracyLabel => 'Saktësia mesatare';

  @override
  String get tablesTitle => 'Tabelat Matematikore';

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
  String get gamifyScreenTitle => 'Argëto Ushtrimet';

  @override
  String get gamifyInputTitle => 'Fotografo ose Shkruaj Ushtrimin';

  @override
  String get gamifyInputSubtitle =>
      'Mund ta fotografosh ose ta shkruash ushtrimin. OCR funksionon më mirë me tekst të shtypur dhe imazhe të qarta.';

  @override
  String get gamifyClear => 'Fshij';

  @override
  String get gamifySolve => 'Zgjidh';

  @override
  String get gamifySolutionTitle => '✨ Zgjidhja Argëtuese ✨';

  @override
  String get gamifyRecognizedTextLabel => 'Teksti i Njohur:';

  @override
  String get gamifyCameraButton => 'Fotografo';

  @override
  String get gamifyGalleryButton => 'Galeria';

  @override
  String get gamifyWriteExerciseLabel => 'Shkruaj Ushtrimin';

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
    return 'Gabim gjatë leximit të tekstit: $error';
  }

  @override
  String get gamifyEmptyEquationError =>
      'Ju lutemi shkruani ose fotografoni një ekuacion.';

  @override
  String gamifyImagePickError(Object error) {
    return 'Gabim në zgjedhjen e imazhit: $error';
  }

  @override
  String gamifySubtractionNeedsPositiveResult(int num1, int num2) {
    return 'Ky ushtrim krijon rezultat negativ ($num1 - $num2). Përdor një zbritje ku numri i parë është më i madh.';
  }

  @override
  String get gamifyDivisionByZero => 'Pjesëtimi me zero nuk lejohet.';

  @override
  String gamifyDivisionNeedsWholeResult(int num1, int num2) {
    return 'Ky pjesëtim nuk jep rezultat të plotë ($num1 ÷ $num2). Zgjidh një ushtrim që ndahet pa mbetje.';
  }

  @override
  String gamifyAdditionSolution(int num1, int num2, int answer) {
    return '🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: $num1 + $num2 = ?\n\n📚 HAPI I PARË: Imagjinoni $num1 ballona që ngrihen në qiell!\n🎈 HAPI I DYTË: Shtojmë edhe $num2 ballona - tani kemi $answer në total!\n✨ PËRGJIGJA FINALE: $answer\n\n💡 TRIKU ARGËTUES: Çdo shifër në $answer përfaqëson një yll në qiellin e natës! 🌟';
  }

  @override
  String gamifySubtractionSolution(int num1, int num2, int answer) {
    return '🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: $num1 - $num2 = ?\n\n🍎 HAPI I PARË: Kemi $num1 mollë të shijshme në një kosh!\n😋 HAPI I DYTË: Hamë $num2 mollë - mbeten $answer mollë të shijshme!\n✨ PËRGJIGJA FINALE: $answer\n\n💡 TRIKU ARGËTUES: $answer janë mollët që mbeten për piknikun tënd! 🍎';
  }

  @override
  String gamifyMultiplicationSolution(int num1, int num2, int answer) {
    return '🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: $num1 × $num2 = ?\n\n🏗️ HAPI I PARË: Ndërtojmë një fort me $num1 kube në çdo rresht!\n🏰 HAPI I DYTË: Forti ka $num2 rreshta - në total $answer kube!\n✨ PËRGJIGJA FINALE: $answer\n\n💡 TRIKU ARGËTUES: Shumëzimi është si të ndërtosh me blloqe - sa më shumë rreshta, aq më i madh forti! 📦';
  }

  @override
  String gamifyDivisionSolution(int num1, int num2, int answer) {
    return '🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮\n\nEkuacioni: $num1 ÷ $num2 = ?\n\n🍕 HAPI I PARË: Kemi $num1 pjesë pice për t’i ndarë!\n👨‍👩‍👧‍👦 HAPI I DYTË: I ndajmë mes $num2 shokëve - secili merr $answer pjesë!\n✨ PËRGJIGJA FINALE: $answer\n\n💡 TRIKU ARGËTUES: Pjesëtimi është si të ndash një surprizë - çdo mik merr pjesën e vet! 🎉';
  }

  @override
  String gamifyGenericSolution(Object exercise) {
    return '🎮 ZGJIDHJA ARGËTUESE 🎮\n\nEkuacioni juaj: \"$exercise\"\n\n📚 Duket si një sfidë interesante!\n🧮 Këtu janë disa këshilla për ta zgjidhur:\n\n1. 🔍 Shikoni me kujdes numrat në ekuacion\n2. 🧠 Mendoni se çfarë operacioni të përdorni (+, -, ×, ÷)\n3. ✍️ Shkruani hap pas hapi\n4. ✅ Kontrolloni përgjigjen tuaj\n\n💡 Kujtohuni: Matematika është një lojë argëtuese! 🎮\n\nPër shembull:\n- 5 + 3 = 8 (Mbledhje)\n- 10 - 4 = 6 (Zbritje)\n- 7 × 2 = 14 (Shumëzim)\n- 12 ÷ 3 = 4 (Pjesëtim)';
  }

  @override
  String gamifyInvalidSolution(Object exercise) {
    return '🎮 ZGJIDHJA ARGËTUESE 🎮\n\nEkuacioni: \"$exercise\"\n\nHmm, duhet të jetë më i qartë! 🤔\n📝 Përpiquni ta rishkruani ekuacionin me numra dhe operacione të qarta.\n\nShembuj të mirë:\n✅ \"5 + 3\"\n✅ \"10 - 7\"\n✅ \"6 * 4\"\n✅ \"20 / 5\"\n\nPërpiquni përsëri! 💪';
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
  String get dashboardFractionsTitle => 'Mëso Fraksionet';

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
}
