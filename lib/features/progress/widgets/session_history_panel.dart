import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../models/user_progress.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';

const _moduleColors = <String, Color>{
  'Mbledhje': Color(0xFF4CAF50),
  'Zbritje': Color(0xFFF44336),
  'Shumëzim': Color(0xFFFF9800),
  'Pjesëtim': Color(0xFF2196F3),
  'Gjeometri': Color(0xFF00EEFC),
};

const _moduleIcons = <String, IconData>{
  'Mbledhje': Icons.add,
  'Zbritje': Icons.remove,
  'Shumëzim': Icons.close,
  'Pjesëtim': Icons.percent,
  'Gjeometri': Icons.change_history,
};

/// Panel me historinë e 10 sesioneve të fundit (kolona e djathtë landscape).
class SessionHistoryPanel extends ConsumerWidget {
  const SessionHistoryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(activeProgressProvider);

    return progressAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final sessions = progress.recentSessions.reversed.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(),
            const SizedBox(height: 12),
            if (sessions.isEmpty)
              _EmptyState()
            else
              Expanded(
                child: ListView.separated(
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _SessionItem(session: sessions[index]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CosmicColors.primaryContainer.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: CosmicColors.primaryContainer.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 14, color: CosmicColors.primaryContainer),
              const SizedBox(width: 5),
              Text(
                'Historiku',
                style: TextStyle(
                  color: CosmicColors.primaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({required this.session});

  final SessionRecord session;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min më parë';
    if (diff.inHours < 24) return '${diff.inHours}h më parë';
    return '${diff.inDays}d më parë';
  }

  @override
  Widget build(BuildContext context) {
    final moduleKey = session.moduleKey ?? 'Tjetër';
    final color = _moduleColors[moduleKey] ?? CosmicColors.outline;
    final icon = _moduleIcons[moduleKey] ?? Icons.star;

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moduleKey,
                  style: const TextStyle(
                    color: CosmicColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(session.timestamp),
                  style: const TextStyle(
                    color: CosmicColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${session.points}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${session.accuracy}%',
                style: const TextStyle(
                  color: CosmicColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MascotFrame(size: 100),
          const SizedBox(height: 16),
          Text(
            'Fillo sfidën e parë!',
            style: TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sesionet do të shfaqen këtu.',
            style: TextStyle(
              color: CosmicColors.outlineVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
