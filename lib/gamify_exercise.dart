import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

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
        setState(() {
          _selectedImage = File(pickedFile.path);
          _recognizedText = null;
          _solution = null;
        });
        _processImage();
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
        setState(() {
          _selectedImage = File(pickedFile.path);
          _recognizedText = null;
          _solution = null;
        });
        _processImage();
      }
    } catch (e) {
      _showErrorSnackBar(l10n.gamifyImagePickError('$e'));
    }
  }

  Future<void> _processImage() async {
    setState(() {
      _recognizedText = AppLocalizations.of(context).gamifyRecognizedPlaceholder;
    });
  }

  void _generateSolution() {
    final l10n = AppLocalizations.of(context);
    final exerciseText = _recognizedText ?? _exerciseController.text;

    if (exerciseText.isEmpty) {
      _showErrorSnackBar(l10n.gamifyEmptyEquationError);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate processing delay
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      // Parse and generate fun solution
      final solution = _generateFunSolution(exerciseText);

      setState(() {
        _solution = solution;
        _isProcessing = false;
      });
    });
  }

  String _generateFunSolution(String exercise) {
    final l10n = AppLocalizations.of(context);
    exercise = exercise.toLowerCase().trim();

    exercise = exercise
        .replaceAll('zgjidh', '')
        .replaceAll('llogarit', '')
        .replaceAll('sa është', '')
        .replaceAll('janë', '')
        .trim();

    try {
      if (exercise.contains('+')) {
        final parts = exercise.split('+');
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          final answer = num1 + num2;

          return l10n.gamifyAdditionSolution(num1, num2, answer);
        }
      } else if (exercise.contains('-')) {
        final parts = exercise.split('-');
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          final answer = num1 - num2;

          return l10n.gamifySubtractionSolution(num1, num2, answer);
        }
      } else if (exercise.contains('*') ||
          exercise.contains('×') ||
          exercise.contains('x')) {
        final delimiter = exercise.contains('*')
            ? '*'
            : exercise.contains('×')
            ? '×'
            : 'x';
        final parts = exercise.split(delimiter);
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          final answer = num1 * num2;

          return l10n.gamifyMultiplicationSolution(num1, num2, answer);
        }
      } else if (exercise.contains('/') || exercise.contains('÷')) {
        final delimiter = exercise.contains('/') ? '/' : '÷';
        final parts = exercise.split(delimiter);
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          if (num2 != 0) {
            final answer = num1 ~/ num2;

            return l10n.gamifyDivisionSolution(num1, num2, answer);
          }
        }
      }

      return l10n.gamifyGenericSolution(exercise);
    } catch (e) {
      return l10n.gamifyInvalidSolution(exercise);
    }
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
