import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../models/child_profile.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';

/// Raporti i prindërit — statistika per-child.
class ParentReportScreen extends ConsumerWidget {
  const ParentReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final family = ref.watch(familyProvider).family;

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: family == null || family.children.isEmpty
          ? const Center(
              child: Text(
                'Nuk ka fëmijë të regjistruar.',
                style: TextStyle(color: CosmicColors.onSurfaceVariant),
              ),
            )
          : ResponsivePage(
              maxWidth: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Raporti i Prindërit',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: CosmicColors.primaryContainer),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${family.children.length} fëmijë · '
                    'Familje e krijuar ${_formatDate(family.createdAt)}',
                    style: const TextStyle(
                      color: CosmicColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...family.children.map(
                    (child) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ChildReportCard(child: child),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}

// ---------------------------------------------------------------------------
// _ChildReportCard
// ---------------------------------------------------------------------------
class _ChildReportCard extends StatelessWidget {
  const _ChildReportCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: CosmicColors.primaryContainer.withValues(alpha: 0.12),
                  border: Border.all(
                    color: CosmicColors.primaryContainer.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.pseudonym,
                      style: const TextStyle(
                        color: CosmicColors.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${child.totalPoints} pikë totale',
                      style: const TextStyle(
                        color: CosmicColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.check_circle_outline,
                label: 'Sesione',
                value: '${child.completedSessions}',
                color: CosmicColors.secondaryContainer,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.track_changes,
                label: 'Saktësi',
                value:
                    '${child.totalAccuracy.toStringAsFixed(0)}%',
                color: CosmicColors.tertiaryContainer,
              ),
            ],
          ),

          // Module breakdown
          if (child.moduleHistory.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: CosmicColors.outline, height: 1),
            const SizedBox(height: 14),
            Text(
              'Sipas modulit',
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...child.moduleHistory.entries.map(
              (e) => _ModuleRow(moduleKey: e.key, data: e.value),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: CosmicColors.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({required this.moduleKey, required this.data});

  final String moduleKey;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final sessions = (data['sessions'] as num?)?.toInt() ?? 0;
    final points = (data['points'] as num?)?.toInt() ?? 0;
    final accuracy =
        (data['totalAccuracy'] as num?)?.toDouble() ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              moduleKey,
              style: const TextStyle(
                color: CosmicColors.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '$sessions sesione · $points pikë · '
            '${accuracy.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
