import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'colors.dart';
import 'l10n/app_localizations.dart';
import 'responsive.dart';

const _floatingSnackBarMargin = EdgeInsets.fromLTRB(16, 8, 16, 24);

class GamifyExerciseScreen extends StatefulWidget {
  const GamifyExerciseScreen({super.key});

  @override
  State<GamifyExerciseScreen> createState() => _GamifyExerciseScreenState();
}

class _GamifyExerciseScreenState extends State<GamifyExerciseScreen> {
  final TextEditingController _exerciseController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  File? _selectedImage;
  String? _recognizedText;
  String? _solution;
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        final image = File(pickedFile.path);
        setState(() {
          _selectedImage = image;
          _recognizedText = null;
          _solution = null;
        });
        await _processImage(image);
      }
    } catch (e) {
      _showErrorSnackBar(l10n.gamifyImagePickError('$e'));
    }
  }

  Future<void> _pickImageFromGallery() async {
    final l10n = AppLocalizations.of(context);
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final image = File(pickedFile.path);
        setState(() {
          _selectedImage = image;
          _recognizedText = null;
          _solution = null;
        });
        await _processImage(image);
      }
    } catch (e) {
      _showErrorSnackBar(l10n.gamifyImagePickError('$e'));
    }
  }

  Future<void> _processImage(File image) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isProcessing = true;
      _recognizedText = l10n.gamifyOcrProcessing;
      _solution = null;
    });

    try {
      debugPrint('[OCR] Starting processImage for path: ${image.path}');
      var recognizedText = await _runOcrAttempt(
        label: 'fromFilePath',
        inputImage: InputImage.fromFilePath(image.path),
      );

      // Fallback: disa pajisje/metadata japin rezultat më të mirë me fromFile.
      if (_isOcrEmpty(recognizedText)) {
        debugPrint('[OCR] Empty result from fromFilePath, retrying with fromFile');
        recognizedText = await _runOcrAttempt(
          label: 'fromFile',
          inputImage: InputImage.fromFile(image),
        );
      }

      // Fallback i tretë: preprocesim i figurës për raste me shkrim dore/kontrast të ulët.
      if (_isOcrEmpty(recognizedText)) {
        debugPrint('[OCR] Empty result after direct attempts, trying preprocessed variants');
        final preprocessedResult = await _runPreprocessedOcr(image);
        if (preprocessedResult != null) {
          recognizedText = preprocessedResult;
        }
      }

      final rawText = recognizedText.text;
      debugPrint('[OCR] blocks=${recognizedText.blocks.length}');
      debugPrint('[OCR] rawText="${rawText.replaceAll('\n', ' ')}"');
      final equation = _extractEquation(recognizedText.text);
      debugPrint('[OCR] extractedEquation=$equation');

      if (!mounted) {
        debugPrint('[OCR] Widget not mounted after OCR, aborting state update');
        return;
      }

      if (equation == null) {
        final visibleText = recognizedText.text.trim();
        debugPrint('[OCR] No equation detected. visibleTextLength=${visibleText.length}');
        setState(() {
          _recognizedText = visibleText.isEmpty
              ? l10n.gamifyOcrNoTextDetected
              : visibleText;
          _isProcessing = false;
        });
        _showErrorSnackBar(l10n.gamifyOcrNoEquationFound);
        return;
      }

      _exerciseController.text = equation;
      setState(() {
        _recognizedText = equation;
        _isProcessing = false;
      });
      _generateSolution(prefilledExercise: equation);
    } catch (e, stack) {
      debugPrint('[OCR] Exception while processing image: $e');
      debugPrint('[OCR] Stack: $stack');
      if (!mounted) {
        return;
      }

      setState(() {
        _isProcessing = false;
        _recognizedText = null;
      });
      _showErrorSnackBar(l10n.gamifyOcrProcessingError('$e'));
    }
  }

  bool _isOcrEmpty(RecognizedText recognizedText) {
    return recognizedText.blocks.isEmpty && recognizedText.text.trim().isEmpty;
  }

  Future<RecognizedText> _runOcrAttempt({
    required String label,
    required InputImage inputImage,
  }) async {
    final result = await _textRecognizer.processImage(inputImage);
    debugPrint(
      '[OCR] Attempt($label): blocks=${result.blocks.length}, textLength=${result.text.trim().length}',
    );
    return result;
  }

  Future<RecognizedText?> _runPreprocessedOcr(File imageFile) async {
    final originalBytes = await imageFile.readAsBytes();
    final original = img.decodeImage(originalBytes);
    if (original == null) {
      debugPrint('[OCR] Preprocess: decodeImage failed');
      return null;
    }

    final variants = <(String, img.Image)>[];

    // Variant 1: grayscale + contrast boost.
    final v1 = img.grayscale(original.clone());
    variants.add(('gray', img.adjustColor(v1, contrast: 1.6, brightness: 0.05)));

    // Variant 2: crop zonën qendrore sipër ku zakonisht është ekuacioni në foto.
    final cropW = (original.width * 0.9).round();
    final cropH = (original.height * 0.45).round();
    final cropX = ((original.width - cropW) / 2).round();
    final cropY = (original.height * 0.15).round();
    final v2 = img.copyCrop(
      original,
      x: cropX.clamp(0, original.width - 1),
      y: cropY.clamp(0, original.height - 1),
      width: cropW.clamp(1, original.width - cropX),
      height: cropH.clamp(1, original.height - cropY),
    );
    variants.add(('crop', img.adjustColor(img.grayscale(v2), contrast: 1.8)));

    // Variant 3: threshold agresiv për penë mbi letër.
    final v3 = img.grayscale(original.clone());
    variants.add(('threshold', img.luminanceThreshold(v3, threshold: 0.62)));

    for (final (label, variant) in variants) {
      File? tempFile;
      try {
        final bytes = img.encodeJpg(variant, quality: 100);
        tempFile = File(
          '${Directory.systemTemp.path}${Platform.pathSeparator}mathlingo_ocr_${DateTime.now().microsecondsSinceEpoch}_$label.jpg',
        );
        await tempFile.writeAsBytes(bytes, flush: true);

        final result = await _runOcrAttempt(
          label: 'preprocessed-$label',
          inputImage: InputImage.fromFilePath(tempFile.path),
        );

        if (!_isOcrEmpty(result)) {
          debugPrint('[OCR] Preprocess success with variant=$label');
          return result;
        }
      } catch (e) {
        debugPrint('[OCR] Preprocess variant failed ($label): $e');
      } finally {
        if (tempFile != null && await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (_) {
            // Best effort cleanup.
          }
        }
      }
    }

    debugPrint('[OCR] Preprocess attempts ended with empty result');
    return null;
  }

  void _generateSolution({String? prefilledExercise}) {
    final l10n = AppLocalizations.of(context);
    final rawInput = prefilledExercise ?? _exerciseController.text;
    final exerciseText =
        _extractEquation(rawInput) ?? _normalizeEquationText(rawInput);

    if (exerciseText.isEmpty) {
      _showErrorSnackBar(l10n.gamifyEmptyEquationError);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final solution = _generateFunSolution(exerciseText);

    setState(() {
      _recognizedText ??= prefilledExercise;
      _solution = solution;
      _isProcessing = false;
    });
  }

  String? _extractEquation(String text) {
    final normalized = _normalizeEquationText(text);

    final numericMatch = RegExp(
      r'^(\d+)\s*([+\-×÷])\s*(\d+)\s*=?.*$',
    ).firstMatch(normalized);
    if (numericMatch != null) {
      final leftOperand = numericMatch.group(1)!;
      final operator = numericMatch.group(2)!;
      final rightOperand = numericMatch.group(3)!;
      return '$leftOperand $operator $rightOperand';
    }

    final quadraticMatch = RegExp(
      r'^([A-Za-z])\^2\s*([+\-])\s*(\d+)([A-Za-z])\s*([+\-])\s*(\d+)\s*=\s*0$',
    ).firstMatch(normalized);
    if (quadraticMatch != null && quadraticMatch.group(1) == quadraticMatch.group(4)) {
      final variable = quadraticMatch.group(1)!;
      final middleSign = quadraticMatch.group(2)!;
      final middleCoeff = quadraticMatch.group(3)!;
      final constantSign = quadraticMatch.group(5)!;
      final constantValue = quadraticMatch.group(6)!;
      return '$variable^2 $middleSign $middleCoeff$variable $constantSign $constantValue = 0';
    }

    final symbolicMatch = RegExp(
      r'^([A-Za-z](?:\^\d+)?)\s*([+\-×÷])\s*([A-Za-z](?:\^\d+)?)\s*=?.*$',
    ).firstMatch(normalized);
    if (symbolicMatch != null) {
      final leftOperand = symbolicMatch.group(1)!;
      final operator = symbolicMatch.group(2)!;
      final rightOperand = symbolicMatch.group(3)!;
      return '$leftOperand $operator $rightOperand';
    }

    return null;
  }

  String _normalizeEquationText(String text) {
    final normalized = text
        .replaceAll(RegExp(r'[\r\n]+'), ' ')
        .replaceAll('²', '^2')
        .replaceAll('³', '^3')
        .replaceAll('⁴', '^4')
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll(RegExp(r'(?<=\d)\s*[xX]\s*(?=\d)'), ' × ')
        .replaceAll(RegExp(r'\s*\^\s*'), '^')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return normalized.replaceAllMapped(
      RegExp(r'([A-Za-z])\s*([0-9]+)(?=\s*(?:[+\-=×÷)]|$))'),
      (match) => '${match.group(1)}^${match.group(2)}',
    );
  }

  String _generateFunSolution(String exercise) {
    final l10n = AppLocalizations.of(context);
    final normalizedExercise =
        _extractEquation(exercise) ?? _normalizeEquationText(exercise);
    final match = RegExp(r'^(\d+)\s*([+\-×÷])\s*(\d+)$').firstMatch(
      normalizedExercise,
    );

    if (match == null) {
      final quadraticMatch = RegExp(
        r'^([A-Za-z])\^2\s*([+\-])\s*(\d+)([A-Za-z])\s*([+\-])\s*(\d+)\s*=\s*0$',
      ).firstMatch(normalizedExercise);
      if (quadraticMatch != null && quadraticMatch.group(1) == quadraticMatch.group(4)) {
        final variable = quadraticMatch.group(1)!;
        final middleSign = quadraticMatch.group(2)!;
        final middleCoeff = int.parse(quadraticMatch.group(3)!);
        final constantSign = quadraticMatch.group(5)!;
        final constantValue = int.parse(quadraticMatch.group(6)!);
        final signedMiddleCoeff = middleSign == '-' ? -middleCoeff : middleCoeff;
        final signedConstant = constantSign == '-' ? -constantValue : constantValue;
        final factorization = _factorQuadratic(variable, signedMiddleCoeff, signedConstant);
        return l10n.gamifyQuadraticSolution(
          normalizedExercise,
          variable,
          factorization ?? 'Nuk u gjet një faktorizim i thjeshtë me numra të plotë.',
        );
      }

      final differenceMatch = RegExp(
        r'^([A-Za-z])\^2\s*-\s*([A-Za-z])\^2$',
      ).firstMatch(normalizedExercise);
      if (differenceMatch != null) {
        final leftOperand = differenceMatch.group(1)!;
        final rightOperand = differenceMatch.group(2)!;
        return l10n.gamifyDifferenceOfSquaresSolution(
          normalizedExercise,
          leftOperand,
          rightOperand,
        );
      }

      final symbolicMatch = RegExp(
        r'^([A-Za-z](?:\^\d+)?)\s*([+\-×÷])\s*([A-Za-z](?:\^\d+)?)$',
      ).firstMatch(normalizedExercise);
      if (symbolicMatch != null) {
        final leftOperand = symbolicMatch.group(1)!;
        final rightOperand = symbolicMatch.group(3)!;
        return l10n.gamifySymbolicSolution(
          normalizedExercise,
          leftOperand,
          rightOperand,
        );
      }

      return normalizedExercise.isEmpty
          ? l10n.gamifyInvalidSolution(exercise)
          : l10n.gamifyGenericSolution(normalizedExercise);
    }

    final num1 = int.parse(match.group(1)!);
    final operator = match.group(2)!;
    final num2 = int.parse(match.group(3)!);

    switch (operator) {
      case '+':
        return l10n.gamifyAdditionSolution(num1, num2, num1 + num2);
      case '-':
        if (num1 < num2) {
          return l10n.gamifySubtractionNeedsPositiveResult(num1, num2);
        }
        return l10n.gamifySubtractionSolution(num1, num2, num1 - num2);
      case '×':
        return l10n.gamifyMultiplicationSolution(num1, num2, num1 * num2);
      case '÷':
        if (num2 == 0) {
          return l10n.gamifyDivisionByZero;
        }
        if (num1 % num2 != 0) {
          return l10n.gamifyDivisionNeedsWholeResult(num1, num2);
        }
        return l10n.gamifyDivisionSolution(num1, num2, num1 ~/ num2);
    }

    return l10n.gamifyGenericSolution(normalizedExercise);
  }

  String? _factorQuadratic(String variable, int middleCoeff, int constant) {
    for (var left = -20; left <= 20; left++) {
      for (var right = -20; right <= 20; right++) {
        if (left + right == middleCoeff && left * right == constant) {
          return '( $variable ${_signedNumber(left)} )( $variable ${_signedNumber(right)} ) = 0';
        }
      }
    }

    return null;
  }

  String _signedNumber(int value) {
    if (value >= 0) {
      return '+ $value';
    }

    return '- ${value.abs()}';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CosmicColors.error,
        behavior: SnackBarBehavior.floating,
        margin: _floatingSnackBarMargin,
      ),
    );
  }

  void _clearInputs() {
    setState(() {
      _exerciseController.clear();
      _selectedImage = null;
      _recognizedText = null;
      _solution = null;
    });
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 760;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: AppBar(
        backgroundColor: CosmicColors.surface,
        title: Text(
          l10n.gamifyScreenTitle,
          style: TextStyle(
            color: CosmicColors.primaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CosmicColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ResponsivePage(
        maxWidth: 920,
        topSafeArea: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.gamifyInputTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CosmicColors.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.gamifyInputSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Responsive layout: side-by-side on tablets, stacked on phones
              if (isTablet)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildImageSection()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildInputSection()),
                  ],
                )
              else ...[
                _buildImageSection(),
                const SizedBox(height: 24),
                _buildInputSection(),
              ],

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CosmicColors.error.withValues(
                          alpha: 0.2,
                        ),
                        foregroundColor: CosmicColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _clearInputs,
                      child: Text(
                        l10n.gamifyClear,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CosmicColors.secondaryContainer,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isProcessing ? null : _generateSolution,
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              l10n.gamifySolve,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Solution display
              if (_solution != null) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CosmicColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: CosmicColors.secondaryContainer.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.gamifySolutionTitle,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: CosmicColors.secondaryContainer),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _solution!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CosmicColors.primaryContainer.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          if (_selectedImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.file(
                _selectedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_recognizedText != null) ...[
                  Text(
                    l10n.gamifyRecognizedTextLabel,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CosmicColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _recognizedText!,
                      style: const TextStyle(
                        color: CosmicColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: Text(l10n.gamifyCameraButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CosmicColors.primaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: Text(l10n.gamifyGalleryButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CosmicColors.secondaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onPressed: _pickImageFromGallery,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gamifyWriteExerciseLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _exerciseController,
          style: const TextStyle(color: CosmicColors.onSurface),
          decoration: InputDecoration(
            hintText: l10n.gamifyExerciseHint,
            hintStyle: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: CosmicColors.surfaceHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: CosmicColors.primaryContainer,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CosmicColors.primaryContainer.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: CosmicColors.primaryContainer,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 3,
          minLines: 1,
        ),
      ],
    );
  }
}
