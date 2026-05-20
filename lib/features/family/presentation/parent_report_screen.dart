import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../../../core/providers/family_provider.dart';
import '../../../core/providers/weekly_stats_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/child_profile.dart';
import '../../../models/daily_stats.dart';
import '../../../responsive.dart';
import '../../../shared/widgets/cosmic_top_bar.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/mascot_frame.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

const _alDays = ['Hën', 'Mar', 'Mër', 'Enj', 'Pre', 'Sht', 'Die'];

String _dayLabel(String date) {
  try {
    final dt = DateTime.parse(date);
    return _alDays[dt.weekday - 1];
  } catch (_) {
    return '';
  }
}

double _scaled(BuildContext context, double value) {
  return AdaptiveLayout.scalePadding(context, value);
}

// ─── Screen ──────────────────────────────────────────────────────────────────

/// Raporti javor i prindërit — grafiku i pikëve dhe saktësisë.
class ParentReportScreen extends ConsumerStatefulWidget {
  const ParentReportScreen({super.key});

  @override
  ConsumerState<ParentReportScreen> createState() =>
      _ParentReportScreenState();
}

class _ParentReportScreenState extends ConsumerState<ParentReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weeklyStatsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final family = ref.watch(familyProvider).family;
    final weeklyState = ref.watch(weeklyStatsProvider);

    return Scaffold(
      backgroundColor: CosmicColors.background,
      appBar: const CosmicTopBar(showBackButton: true),
      body: RefreshIndicator(
        onRefresh: () => ref.read(weeklyStatsProvider.notifier).refresh(),
        color: CosmicColors.primaryContainer,
        backgroundColor: CosmicColors.surface,
        child: family == null || family.children.isEmpty
            ? ListView(children: [_EmptyFamilyView(l10n: l10n)])
            : ResponsivePage(
                maxWidth: 700,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(_scaled(context, 10)),
                          decoration: BoxDecoration(
                            color: CosmicColors.primaryContainer
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: CosmicColors.primaryContainer
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: const Icon(
                            Icons.bar_chart_rounded,
                            color: CosmicColors.primaryContainer,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: _scaled(context, 14)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.parentReportTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: CosmicColors.primaryContainer,
                                    ),
                              ),
                              Text(
                                '${family.children.length} fëmijë',
                                style: const TextStyle(
                                  color: CosmicColors.onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _scaled(context, 28)),

                    // ── Grafiku javor ────────────────────────────────────
                    _WeeklySection(state: weeklyState, l10n: l10n),
                    SizedBox(height: _scaled(context, 28)),

                    // ── A-04: Aktiviteti i Fundit ─────────────────────────
                    _RecentActivitySection(state: weeklyState, l10n: l10n),
                    SizedBox(height: _scaled(context, 28)),

                    // ── Statistika per-child ─────────────────────────────
                    ...family.children.map(
                      (child) => Padding(
                        padding: EdgeInsets.only(bottom: _scaled(context, 16)),
                        child: _ChildReportCard(child: child),
                      ),
                    ),
                    SizedBox(height: _scaled(context, 24)),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─── Weekly Section ──────────────────────────────────────────────────────────

class _WeeklySection extends StatelessWidget {
  const _WeeklySection({required this.state, required this.l10n});

  final WeeklyStatsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeeklyStatsInitial() || WeeklyStatsLoading() =>
        _LoadingCard(l10n: l10n),
      WeeklyStatsError() => _NoDataCard(l10n: l10n),
      WeeklyStatsLoaded(:final stats) => stats.isEmpty
          ? _NoDataCard(l10n: l10n)
          : _ChartsSection(stats: stats, l10n: l10n),
    };
  }
}

// ─── A-04: Recent Activity Section ───────────────────────────────────────────

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({required this.state, required this.l10n});

  final WeeklyStatsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (state is! WeeklyStatsLoaded) return const SizedBox.shrink();
    final stats = (state as WeeklyStatsLoaded).stats;
    if (stats.isEmpty) return const SizedBox.shrink();

    // Merr max 5 ditët e fundit (stats janë tashmë të renditura kronologjikisht)
    final recent = stats.length > 5 ? stats.sublist(stats.length - 5) : stats;
    final reversed = recent.reversed.toList();

    return GlassPanel(
      padding: EdgeInsets.all(_scaled(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 16,
                color: CosmicColors.primaryContainer,
              ),
              SizedBox(width: _scaled(context, 8)),
              Text(
                'Aktiviteti i Fundit',
                style: const TextStyle(
                  color: CosmicColors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: _scaled(context, 14)),
          ...reversed.map((day) => _ActivityRow(stats: day)),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.stats});

  final DailyStats stats;

  static const _alDays = ['Hën', 'Mar', 'Mër', 'Enj', 'Pre', 'Sht', 'Die'];

  String get _label {
    try {
      final dt = DateTime.parse(stats.date);
      return '${_alDays[dt.weekday - 1]} ${dt.day}/${dt.month}';
    } catch (_) {
      return stats.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracyPct = (stats.avgAccuracy * 100).round();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _scaled(context, 6)),
      child: Row(
        children: [
          SizedBox(
            width: _scaled(context, 80),
            child: Text(
              _label,
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: _scaled(context, 8)),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded,
                    size: 13, color: CosmicColors.primaryContainer),
                SizedBox(width: _scaled(context, 3)),
                Text(
                  '${stats.totalPoints} pikë',
                  style: const TextStyle(
                    color: CosmicColors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded,
                  size: 13, color: CosmicColors.secondaryContainer),
              SizedBox(width: _scaled(context, 3)),
              Text(
                '$accuracyPct%',
                style: const TextStyle(
                  color: CosmicColors.secondaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(width: _scaled(context, 12)),
          Text(
            '${stats.sessionsCount} ses.',
            style: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading placeholder ───────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.all(_scaled(context, 40)),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: CosmicColors.primaryContainer,
              strokeWidth: 2.5,
            ),
            SizedBox(height: _scaled(context, 16)),
            const Text(
              'Po ngarkon statistikat...',
              style: TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty / no-data state ─────────────────────────────────────────────────────

class _NoDataCard extends StatelessWidget {
  const _NoDataCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.symmetric(
        vertical: _scaled(context, 32),
        horizontal: _scaled(context, 24),
      ),
      child: Column(
        children: [
          const MascotFrame(size: 90),
          SizedBox(height: _scaled(context, 16)),
          Text(
            l10n.noDataYet,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CosmicColors.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Charts Section ────────────────────────────────────────────────────────────

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({required this.stats, required this.l10n});

  final List<DailyStats> stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.weeklyTrend,
          style: const TextStyle(
            color: CosmicColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: _scaled(context, 12)),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _PointsBarChart(stats: stats, l10n: l10n)),
                  SizedBox(width: _scaled(context, 12)),
                  Expanded(
                      child: _AccuracyLineChart(stats: stats, l10n: l10n)),
                ],
              )
            : Column(
                children: [
                  _PointsBarChart(stats: stats, l10n: l10n),
                  SizedBox(height: _scaled(context, 12)),
                  _AccuracyLineChart(stats: stats, l10n: l10n),
                ],
              ),
      ],
    );
  }
}

// ─── Bar Chart — Pikët Ditorë ─────────────────────────────────────────────────

class _PointsBarChart extends StatelessWidget {
  const _PointsBarChart({required this.stats, required this.l10n});

  final List<DailyStats> stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final maxY = stats
        .map((s) => s.totalPoints.toDouble())
        .fold(0.0, (a, b) => a > b ? a : b);
    final adjustedMax = (maxY < 10 ? 10.0 : maxY) * 1.25;

    return GlassPanel(
      padding: EdgeInsets.fromLTRB(
        _scaled(context, 12),
        _scaled(context, 16),
        _scaled(context, 12),
        _scaled(context, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: _scaled(context, 4)),
            child: Row(
              children: [
                const Icon(Icons.star_rounded,
                    size: 15, color: CosmicColors.primaryContainer),
                SizedBox(width: _scaled(context, 6)),
                Text(
                  l10n.dailyPoints,
                  style: const TextStyle(
                    color: CosmicColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _scaled(context, 16)),
          SizedBox(
            height: _scaled(context, 160),
            child: BarChart(
              BarChartData(
                maxY: adjustedMax,
                barGroups: stats.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.totalPoints.toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            CosmicColors.primaryContainer
                                .withValues(alpha: 0.65),
                            CosmicColors.primaryContainer,
                          ],
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: CosmicColors.outline.withValues(alpha: 0.18),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= stats.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _dayLabel(stats[idx].date),
                            style: const TextStyle(
                              color: CosmicColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => CosmicColors.surfaceHighest,
                    getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                      '${rod.toY.toInt()} pikë',
                      const TextStyle(
                        color: CosmicColors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Line Chart — Saktësia ───────────────────────────────────────────────────

class _AccuracyLineChart extends StatelessWidget {
  const _AccuracyLineChart({required this.stats, required this.l10n});

  final List<DailyStats> stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final spots = stats
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.avgAccuracy * 100))
        .toList();

    return GlassPanel(
      padding: EdgeInsets.fromLTRB(
        _scaled(context, 12),
        _scaled(context, 16),
        _scaled(context, 12),
        _scaled(context, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: _scaled(context, 4)),
            child: Row(
              children: [
                const Icon(Icons.track_changes_rounded,
                    size: 15, color: CosmicColors.secondaryContainer),
                SizedBox(width: _scaled(context, 6)),
                Text(
                  l10n.accuracyTrend,
                  style: const TextStyle(
                    color: CosmicColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _scaled(context, 16)),
          SizedBox(
            height: _scaled(context, 160),
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: CosmicColors.secondaryContainer,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, ___) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: CosmicColors.secondaryContainer,
                        strokeWidth: 1.5,
                        strokeColor: CosmicColors.surface,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CosmicColors.secondaryContainer
                              .withValues(alpha: 0.28),
                          CosmicColors.secondaryContainer
                              .withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: CosmicColors.outline.withValues(alpha: 0.18),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 32,
                      getTitlesWidget: (v, meta) => Text(
                        '${v.toInt()}%',
                        style: const TextStyle(
                          color: CosmicColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= stats.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _dayLabel(stats[idx].date),
                            style: const TextStyle(
                              color: CosmicColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => CosmicColors.surfaceHighest,
                    getTooltipItems: (spots) => spots
                        .map(
                          (s) => LineTooltipItem(
                            '${s.y.toStringAsFixed(1)}%',
                            const TextStyle(
                              color: CosmicColors.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty family view ────────────────────────────────────────────────────────

class _EmptyFamilyView extends StatelessWidget {
  const _EmptyFamilyView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: const Center(
        child: Text(
          'Nuk ka fëmijë të regjistruar.',
          style: TextStyle(color: CosmicColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

// ─── Per-child stat card ──────────────────────────────────────────────────────

class _ChildReportCard extends StatelessWidget {
  const _ChildReportCard({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.all(_scaled(context, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: _scaled(context, 52),
                height: _scaled(context, 52),
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
              SizedBox(width: _scaled(context, 14)),
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
                    SizedBox(height: _scaled(context, 2)),
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
          SizedBox(height: _scaled(context, 20)),

          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.check_circle_outline_rounded,
                label: 'Sesione',
                value: '${child.completedSessions}',
                color: CosmicColors.secondaryContainer,
              ),
              SizedBox(width: _scaled(context, 12)),
              _StatChip(
                icon: Icons.track_changes_rounded,
                label: 'Saktësi',
                value: '${child.totalAccuracy.toStringAsFixed(0)}%',
                color: CosmicColors.tertiaryContainer,
              ),
            ],
          ),

          // Module breakdown
          if (child.moduleHistory.isNotEmpty) ...[
            SizedBox(height: _scaled(context, 20)),
            const Divider(color: CosmicColors.outline, height: 1),
            SizedBox(height: _scaled(context, 14)),
            Text(
              'Sipas modulit',
              style: const TextStyle(
                color: CosmicColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: _scaled(context, 10)),
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
        padding: EdgeInsets.symmetric(
          horizontal: _scaled(context, 14),
          vertical: _scaled(context, 12),
        ),
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
                SizedBox(width: _scaled(context, 6)),
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
            SizedBox(height: _scaled(context, 4)),
            Text(
              value,
              style: const TextStyle(
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
      padding: EdgeInsets.only(bottom: _scaled(context, 8)),
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
