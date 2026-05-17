import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../core/services/family_profile_service.dart';
import '../../../models/child_profile.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/cosmic_button.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import 'parent_pin_dialog.dart';
import 'parent_report_screen.dart';

/// Ekrani i ndërrimit të profilit dhe shtimit të fëmijëve të rinj.
class FamilySwitcherScreen extends ConsumerStatefulWidget {
  const FamilySwitcherScreen({super.key});

  @override
  ConsumerState<FamilySwitcherScreen> createState() =>
      _FamilySwitcherScreenState();
}

class _FamilySwitcherScreenState
    extends ConsumerState<FamilySwitcherScreen> {
  bool _showAddForm = false;

  @override
  Widget build(BuildContext context) {
    final familyState = ref.watch(familyProvider);
    final children = familyState.family?.children ?? [];
    final activeId = familyState.activeChild?.id;
    final isFull = familyState.family?.isFull ?? false;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: ResponsivePage(
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kush luan sot?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CosmicColors.primaryContainer,
                  ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Zgjidh profilin ose shto fëmijë të ri.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bar_chart, size: 18),
                  label: const Text('Raporti'),
                  style: TextButton.styleFrom(
                    foregroundColor: CosmicColors.tertiaryContainer,
                  ),
                  onPressed: () async {
                    final ok = await ParentPinDialog.verify(context);
                    if (!ok || !mounted) return;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ParentReportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ChildCard(
                  child: child,
                  isActive: child.id == activeId,
                  onSelect: () async {
                    await ref
                        .read(familyProvider.notifier)
                        .switchChild(child.id);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  onDelete: children.length > 1
                      ? () => _confirmDelete(child)
                      : null,
                ),
              ),
            ),
            if (!isFull && !_showAddForm) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Shto fëmijë të ri'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CosmicColors.secondaryContainer,
                  side: const BorderSide(color: CosmicColors.secondaryContainer),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final ok = await ParentPinDialog.verify(context);
                  if (ok && mounted) setState(() => _showAddForm = true);
                },
              ),
            ],
            if (_showAddForm) ...[
              const SizedBox(height: 16),
              _AddChildForm(
                onAdded: () => setState(() => _showAddForm = false),
                onCancel: () => setState(() => _showAddForm = false),
              ),
            ],
            // ---------------------------------------------------------------
            // Zona e Prindërit
            // ---------------------------------------------------------------
            const SizedBox(height: 32),
            const Divider(color: CosmicColors.outlineVariant),
            const SizedBox(height: 8),
            Text(
              'Zona e Prindërit',
              style: TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            _ParentPinTile(onChanged: () => setState(() {})),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(ChildProfile child) async {
    // Verifikim PIN prindëror para fshirjes
    if (!mounted) return;
    final pinOk = await ParentPinDialog.verify(context);
    if (!pinOk || !mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CosmicColors.surface,
        title: Text(
          'Fshi ${child.pseudonym}?',
          style: const TextStyle(color: CosmicColors.onSurface),
        ),
        content: const Text(
          'Të gjitha të dhënat e këtij profili do të fshihen përgjithmonë.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anulo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Fshi',
              style: TextStyle(color: CosmicColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(familyProvider.notifier).deleteChild(child.id);
    }
  }
}

// ---------------------------------------------------------------------------
// _ChildCard
// ---------------------------------------------------------------------------
class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.isActive,
    required this.onSelect,
    this.onDelete,
  });

  final ChildProfile child;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? CosmicColors.secondaryContainer
        : CosmicColors.outline.withValues(alpha: 0.3);

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive
                  ? CosmicColors.secondaryContainer.withValues(alpha: 0.12)
                  : CosmicColors.surfaceLow,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                ChildAvatars.get(child.avatarIndex),
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      child.pseudonym,
                      style: TextStyle(
                        color: isActive
                            ? CosmicColors.secondaryContainer
                            : CosmicColors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: CosmicColors.secondaryContainer
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: CosmicColors.secondaryContainer,
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Aktiv',
                          style: TextStyle(
                            color: CosmicColors.secondaryContainer,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.totalPoints} pikë · ${child.completedSessions} sesione',
                  style: const TextStyle(
                    color: CosmicColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          if (!isActive)
            TextButton(
              onPressed: onSelect,
              child: const Text('Zgjidh'),
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: CosmicColors.error.withValues(alpha: 0.7),
              onPressed: onDelete,
              tooltip: 'Fshi',
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ParentPinTile — vendos ose ndrysho PIN prindëror
// ---------------------------------------------------------------------------
class _ParentPinTile extends StatelessWidget {
  const _ParentPinTile({required this.onChanged});

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final hasPin = FamilyProfileService.hasParentPin;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        hasPin ? Icons.lock : Icons.lock_open,
        color: hasPin
            ? CosmicColors.secondaryContainer
            : CosmicColors.onSurfaceVariant,
      ),
      title: Text(
        hasPin ? 'PIN i konfiguruar' : 'Vendos PIN Prindëror',
        style: TextStyle(
          color: CosmicColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        hasPin
            ? 'Tap për të ndryshuar PIN-in.'
            : 'Mbron shtimin/fshirjen e profileve dhe raportin.',
        style: TextStyle(color: CosmicColors.onSurfaceVariant, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: CosmicColors.onSurfaceVariant,
      ),
      onTap: () async {
        if (hasPin) {
          // Kërko PIN aktual para ndryshimit
          final ok = await ParentPinDialog.verify(context);
          if (!ok) return;
        }
        if (!context.mounted) return;
        // ignore: use_build_context_synchronously
        final saved = await SetParentPinDialog.show(context);
        if (saved) onChanged();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _AddChildForm
// ---------------------------------------------------------------------------
class _AddChildForm extends ConsumerStatefulWidget {
  const _AddChildForm({required this.onAdded, required this.onCancel});

  final VoidCallback onAdded;
  final VoidCallback onCancel;

  @override
  ConsumerState<_AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends ConsumerState<_AddChildForm> {
  final _ctrl = TextEditingController();
  int _avatar = 0;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Shkruaj pseudonimin.');
      return;
    }
    if (name.length > 20) {
      setState(() => _error = 'Max 20 karaktere.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    await ref.read(familyProvider.notifier).addChild(
          pseudonym: name,
          avatarIndex: _avatar,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name u shtua me sukses!'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        backgroundColor: CosmicColors.secondaryContainer.withValues(alpha: 0.9),
      ),
    );
    widget.onAdded();
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fëmijë i ri',
            style: TextStyle(
              color: CosmicColors.primaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _AvatarSelectorSmall(
            selected: _avatar,
            onChanged: (i) => setState(() => _avatar = i),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            maxLength: 20,
            style: const TextStyle(color: CosmicColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Pseudonimi…',
              hintStyle: const TextStyle(color: CosmicColors.onSurfaceVariant),
              filled: true,
              fillColor: CosmicColors.surfaceLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              errorText: _error,
              isDense: true,
              counterStyle:
                  const TextStyle(color: CosmicColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _saving
                    ? const Center(child: CircularProgressIndicator())
                    : CosmicButton(
                        label: 'Shto',
                        icon: Icons.add,
                        onPressed: _save,
                      ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Anulo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarSelectorSmall extends StatelessWidget {
  const _AvatarSelectorSmall({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(ChildAvatars.all.length, (i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? CosmicColors.primaryContainer.withValues(alpha: 0.15)
                  : CosmicColors.surfaceLow,
              border: Border.all(
                color: isSelected
                    ? CosmicColors.primaryContainer
                    : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                ChildAvatars.get(i),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      }),
    );
  }
}
