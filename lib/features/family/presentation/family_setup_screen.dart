import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../models/child_profile.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/glass_panel.dart';

/// Ekrani i konfigurimit të parë — shfaqet kur nuk ka familje të konfiguruar.
class FamilySetupScreen extends ConsumerStatefulWidget {
  const FamilySetupScreen({super.key, this.onComplete});

  /// Thirret pasi familja krijohet me sukses.
  final VoidCallback? onComplete;

  @override
  ConsumerState<FamilySetupScreen> createState() => _FamilySetupScreenState();
}

class _FamilySetupScreenState extends ConsumerState<FamilySetupScreen> {
  final _controller = TextEditingController();
  int _selectedAvatar = 0;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Shkruaj pseudonimin e fëmijës.');
      return;
    }
    if (name.length > 20) {
      setState(() => _error = 'Pseudonimi nuk mund të jetë më shumë se 20 karaktere.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    await ref.read(familyProvider.notifier).createFamily(
          pseudonym: name,
          avatarIndex: _selectedAvatar,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicColors.background,
      body: ResponsivePage(
        maxWidth: 560,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            Center(
              child: Text(
                '👋',
                style: const TextStyle(fontSize: 64),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Mirë se vini në MathLingo!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Si e quajmë fëmijën? (pseudonim, jo emër real)',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: CosmicColors.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            GlassPanel(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar selector
                  Text(
                    'Zgjidhni avatarin:',
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AvatarSelector(
                    selected: _selectedAvatar,
                    onChanged: (i) => setState(() => _selectedAvatar = i),
                  ),
                  const SizedBox(height: 20),
                  // Pseudonym field
                  TextField(
                    controller: _controller,
                    maxLength: 20,
                    style: const TextStyle(
                      color: CosmicColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'p.sh. Fluturo, Ylli, Luanit…',
                      hintStyle: TextStyle(
                        color: CosmicColors.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      filled: true,
                      fillColor: CosmicColors.surfaceLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: CosmicColors.primaryContainer,
                          width: 1.5,
                        ),
                      ),
                      errorText: _error,
                      counterStyle: const TextStyle(
                        color: CosmicColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _saving
                ? const Center(child: CircularProgressIndicator())
                : CosmicButton(
                    label: 'Fillo Aventurën',
                    icon: Icons.rocket_launch,
                    onPressed: _submit,
                  ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Nuk ruhet asnjë emër real. Plotësisht offline.',
                style: TextStyle(
                  color: CosmicColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AvatarSelector
// ---------------------------------------------------------------------------
class _AvatarSelector extends StatelessWidget {
  const _AvatarSelector({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(ChildAvatars.all.length, (i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? CosmicColors.primaryContainer.withValues(alpha: 0.15)
                  : CosmicColors.surfaceLow,
              border: Border.all(
                color: isSelected
                    ? CosmicColors.primaryContainer
                    : Colors.transparent,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                ChildAvatars.get(i),
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
        );
      }),
    );
  }
}
