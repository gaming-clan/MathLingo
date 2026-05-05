import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';
import 'responsive.dart';

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
      _showErrorSnackBar('Gabim në zgjedhjen e imazhit: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
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
      _showErrorSnackBar('Gabim në zgjedhjen e imazhit: $e');
    }
  }

  Future<void> _processImage() async {
    // TODO: Implement ML Kit text recognition when available
    // For now, show a placeholder
    setState(() {
      _recognizedText = 'Ekuacioni u identifikua nga imazhi...';
    });
  }

  void _generateSolution() {
    final exerciseText = _recognizedText ?? _exerciseController.text;

    if (exerciseText.isEmpty) {
      _showErrorSnackBar('Ju lutemi shkruajnë ose fotografoni një ekuacion.');
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
    // Simple math expression parser and solver
    exercise = exercise.toLowerCase().trim();

    // Remove common words in Albanian
    exercise = exercise
        .replaceAll('zgjidh', '')
        .replaceAll('llogarit', '')
        .replaceAll('sa është', '')
        .replaceAll('janë', '')
        .trim();

    try {
      // Try to parse simple expressions
      if (exercise.contains('+')) {
        final parts = exercise.split('+');
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          final answer = num1 + num2;

          return '''
🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮

Ekuacioni: $num1 + $num2 = ?

📚 HAPI I PARË: Imagjinoni $num1 ballona humbësira në hava!
🎈 HAPI I DYTË: Shtojmë $num2 më shumë ballona - mbi $answer ballona në total!
✨ PËRGJIGJA FINALE: $answer

💡 TRIKU ARGËTUES: Çdo shifër në $answer përfaqëson një yje në qiellin e natës! 🌟
''';
        }
      } else if (exercise.contains('-')) {
        final parts = exercise.split('-');
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          final answer = num1 - num2;

          return '''
🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮

Ekuacioni: $num1 - $num2 = ?

🍎 HAPI I PARË: Kemi $num1 mollë të shëndosha në një kosh!
😋 HAPI I DYTË: Hanemi $num2 mollë - mbeten $answer mollë të shëndosha!
✨ PËRGJIGJA FINALE: $answer

💡 TRIKU ARGËTUES: $answer këto janë mollët më të ëmbla në kopje! 🍎
''';
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

          return '''
🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮

Ekuacioni: $num1 × $num2 = ?

🏗️ HAPI I PARË: Ndërtojmë një fort me $num1 kube në çdo anë!
🏰 HAPI I DYTË: Fort ka $num2 shtresa - në total $answer kube!
✨ PËRGJIGJA FINALE: $answer

💡 TRIKU ARGËTUES: Shumëzimi është si të radhitësh lugje në raftet - sa më shumë të barturësh, aq më shumë do të kesh! 📦
''';
        }
      } else if (exercise.contains('/') || exercise.contains('÷')) {
        final delimiter = exercise.contains('/') ? '/' : '÷';
        final parts = exercise.split(delimiter);
        if (parts.length == 2) {
          final num1 = int.parse(parts[0].trim());
          final num2 = int.parse(parts[1].trim());
          if (num2 != 0) {
            final answer = num1 ~/ num2;

            return '''
🎮 ZGJIDHJA ARGËTUESE E EKUACIONIT 🎮

Ekuacioni: $num1 ÷ $num2 = ?

🍕 HAPI I PARË: Kemi $num1 pjesë pice për të ndarë!
👨‍👩‍👧‍👦 HAPI I DYTË: Ndajmë në mes të $num2 shokëve - secili merr $answer pjesë!
✨ PËRGJIGJA FINALE: $answer

💡 TRIKU ARGËTUES: Pjesëtimi është si të ndash një surprizë - sa më shumë miq, aq më pak për secilin! 🎉
''';
          }
        }
      }

      // If parsing fails, show generic solution
      return '''
🎮 ZGJIDHJA ARGËTUESE 🎮

Ekuacioni juaj: "$exercise"

📚 Duket si një sfidë interesante!
🧮 Këtu janë disa këshilla për ta zgjidhur:

1. 🔍 Shikoni me kujdes numrat në ekuacion
2. 🧠 Mendoni se çfarë operacioni të përdorni (+, -, ×, ÷)
3. ✍️ Shkruani hapave pas hapave
4. ✅ Kontrolloni përgjigjen tuaj

💡 Kujtohuni: Matematika është lojë argëtuese! 🎮

Për shembull:
- 5 + 3 = 8 (Mbledhje)
- 10 - 4 = 6 (Zbritje)
- 7 × 2 = 14 (Shumëzim)
- 12 ÷ 3 = 4 (Pjesëtim)
''';
    } catch (e) {
      return '''
🎮 ZGJIDHJA ARGËTUESE 🎮

Ekuacioni: "$exercise"

Hmm, duhet të jetë më i qartë! 🤔
📝 Përpiquni të rishkruajnë ekuacionin me numra dhe operacione të qarta.

Shembuj të mirë:
✅ "5 + 3"
✅ "10 - 7"
✅ "6 * 4"
✅ "20 / 5"

Përpiquni përsëri! 💪
''';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: CosmicColors.error),
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
    
    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: AppBar(
        backgroundColor: CosmicColors.surface,
        title: const Text(
          'Argëto Ushtrimet',
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
                'Fotografo ose Shkruaj Ushtrimin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CosmicColors.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Zgjedh çfarëdo mënyre që të preferosh për të futur ushtrimin matematikor.',
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
                      child: const Text(
                        'Fshij',
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
                          : const Text(
                              'Zgjidh',
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
                        '✨ Zgjidhja Argëtuese ✨',
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
                    'Teksti i Njohur:',
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
                        label: const Text('Fotografo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              CosmicColors.primaryContainer,
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
                        label: const Text('Galeria'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              CosmicColors.secondaryContainer,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shkruaj Ushtrimin',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _exerciseController,
          style: const TextStyle(color: CosmicColors.onSurface),
          decoration: InputDecoration(
            hintText: 'Shembull: 15 + 7',
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
