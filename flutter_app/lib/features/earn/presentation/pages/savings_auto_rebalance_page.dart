import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

TextStyle get _captionMedium =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.medium);
TextStyle get _baseBold =>
    AppTextStyles.base.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _smBold =>
    AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold);

class SavingsAutoRebalancePage extends ConsumerStatefulWidget {
  const SavingsAutoRebalancePage({super.key, this.shellRenderMode});

  static const allocationKey = Key('sc344_allocation');
  static const driftStatusKey = Key('sc344_drift_status');
  static const driftChartKey = Key('sc344_drift_chart');
  static const autoStatusKey = Key('sc344_auto_status');
  static const statsKey = Key('sc344_stats');
  static const previewButtonKey = Key('sc344_preview_button');
  static const previewSheetKey = Key('sc344_preview_sheet');

  static Key tabKey(String tab) => Key('sc344_tab_$tab');
  static Key strategyKey(String id) => Key('sc344_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAutoRebalancePage> createState() =>
      _SavingsAutoRebalancePageState();
}

class _SavingsAutoRebalancePageState
    extends ConsumerState<SavingsAutoRebalancePage> {
  String? _tab;
  String? _strategyId;
  bool? _autoEnabled;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsAutoRebalanceRepositoryProvider)
        .getRebalance();
    final activeTab = _tab ?? snapshot.defaultTab;
    final strategy = _activeStrategy(snapshot);
    final drift = _totalDrift(snapshot.positions, strategy);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const footerHeight = 92.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final showFooter = activeTab == snapshot.defaultTab && drift >= 3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-344 SavingsAutoRebalancePage',
      child: Material(
        color: AppColors.bg,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  subtitle: snapshot.subtitle,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.contentPad,
                    ),
                    child: VitTabBar(
                      variant: VitTabBarVariant.underline,
                      activeKey: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                      tabs: [
                        for (final tab in snapshot.tabs)
                          VitTabItem(key: tab, label: tab),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.defaultGap,
                      children: [
                        if (activeTab == 'Tổng quan') ...[
                          _AllocationComparisonCard(
                            snapshot: snapshot,
                            strategy: strategy,
                          ),
                          _DriftStatusCard(
                            drift: drift,
                            threshold: snapshot.settings.driftThreshold,
                            onPreview: _openPreview,
                          ),
                          _DriftHistoryCard(points: snapshot.driftHistory),
                          _AutoStatusCard(
                            autoEnabled:
                                _autoEnabled ?? snapshot.settings.autoEnabled,
                            settings: snapshot.settings,
                            onChanged: (value) =>
                                setState(() => _autoEnabled = value),
                          ),
                          _StatsRow(snapshot: snapshot, strategy: strategy),
                        ] else if (activeTab == 'Chiến lược') ...[
                          _StrategyList(
                            snapshot: snapshot,
                            activeId: strategy.id,
                            onChanged: (id) {
                              HapticFeedback.selectionClick();
                              setState(() => _strategyId = id);
                            },
                          ),
                          _StrategyComparison(strategies: snapshot.strategies),
                        ] else if (activeTab == 'Lịch sử')
                          _HistoryList(history: snapshot.history)
                        else
                          _SettingsPanel(
                            settings: snapshot.settings,
                            autoEnabled:
                                _autoEnabled ?? snapshot.settings.autoEnabled,
                            onAutoChanged: (value) =>
                                setState(() => _autoEnabled = value),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showFooter)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: SavingsAutoRebalancePage.previewButtonKey,
                    onPressed: _openPreview,
                    leading: const Icon(Icons.sync_rounded),
                    child: const Text('Tái cân bằng ngay'),
                  ),
                ),
              ),
            if (_showPreview)
              Positioned.fill(
                child: _PreviewSheet(
                  snapshot: snapshot,
                  strategy: strategy,
                  drift: drift,
                  onClose: () => setState(() => _showPreview = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SavingsRebalanceStrategyDraft _activeStrategy(
    SavingsAutoRebalanceSnapshot snapshot,
  ) {
    final id = _strategyId ?? snapshot.defaultStrategyId;
    return snapshot.strategies.firstWhere(
      (item) => item.id == id,
      orElse: () => snapshot.strategies.first,
    );
  }

  void _openPreview() {
    HapticFeedback.selectionClick();
    setState(() => _showPreview = true);
  }
}

class _AllocationComparisonCard extends StatelessWidget {
  const _AllocationComparisonCard({
    required this.snapshot,
    required this.strategy,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final drift = _totalDrift(snapshot.positions, strategy);

    return VitCard(
      key: SavingsAutoRebalancePage.allocationKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.compare_arrows_rounded,
            iconColor: AppColors.primary,
            label: 'Hiện tại vs Mục tiêu',
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _AllocationRing(
                  label: 'Hiện tại',
                  allocations: {
                    for (final position in snapshot.positions)
                      position.asset: position.currentPct,
                  },
                  positions: snapshot.positions,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                child: Column(
                  children: [
                    const Icon(
                      Icons.compare_arrows_rounded,
                      color: AppColors.text3,
                      size: 18,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    _TonePill(
                      label: 'Drift ${drift.toStringAsFixed(1)}%',
                      color: _driftColor(drift),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _AllocationRing(
                  label: strategy.name,
                  allocations: strategy.allocations,
                  positions: snapshot.positions,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final position in snapshot.positions) ...[
            _AssetDriftRow(position: position, strategy: strategy),
            if (position != snapshot.positions.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AllocationRing extends StatelessWidget {
  const _AllocationRing({
    required this.label,
    required this.allocations,
    required this.positions,
  });

  final String label;
  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: 118,
          child: CustomPaint(
            painter: _AllocationRingPainter(
              allocations: allocations,
              positions: positions,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AssetDriftRow extends StatelessWidget {
  const _AssetDriftRow({required this.position, required this.strategy});

  final SavingsRebalancePositionDraft position;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    final drift = position.currentPct - target;
    final color = _assetColor(position);
    final driftColor = _driftColor(drift.abs());

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              position.asset,
              style: _captionMedium.copyWith(color: color),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${position.currentPct.toStringAsFixed(1)}% -> ${target.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const Spacer(),
                  if (position.locked) ...[
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: AppColors.text3,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                  ],
                  Text(
                    '${drift >= 0 ? '+' : ''}${drift.toStringAsFixed(1)}%',
                    style: _captionMedium.copyWith(color: driftColor),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              SizedBox(
                height: 6,
                child: CustomPaint(
                  painter: _DriftTrackPainter(
                    color: color,
                    driftColor: driftColor,
                    current: position.currentPct,
                    target: target,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriftStatusCard extends StatelessWidget {
  const _DriftStatusCard({
    required this.drift,
    required this.threshold,
    required this.onPreview,
  });

  final double drift;
  final double threshold;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final color = _driftColor(drift);
    final needsAction = drift >= threshold;

    return VitCard(
      key: SavingsAutoRebalancePage.driftStatusKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              needsAction
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  needsAction ? 'Cần tái cân bằng' : 'Danh mục cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tổng drift: ${drift.toStringAsFixed(1)}% · Ngưỡng: ${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (needsAction)
            TextButton(
              onPressed: onPreview,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x2,
                ),
                backgroundColor: AppColors.primary08,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  side: const BorderSide(color: AppColors.primary20),
                ),
              ),
              child: const Text('Xem trước'),
            ),
        ],
      ),
    );
  }
}

class _DriftHistoryCard extends StatelessWidget {
  const _DriftHistoryCard({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.driftChartKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.primary,
            label: 'Lịch sử Drift',
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(height: 160, child: _DriftBarChart(points: points)),
          const SizedBox(height: AppSpacing.x2),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(label: '< 3% Tốt', color: AppColors.buy),
              SizedBox(width: AppSpacing.x3),
              _LegendDot(label: '3-8% Lệch', color: AppColors.primary),
              SizedBox(width: AppSpacing.x3),
              _LegendDot(label: '> 8% Cao', color: AppColors.sell),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriftBarChart extends StatelessWidget {
  const _DriftBarChart({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [8, 6, 4, 2, 0];
        final chartTop = 8.0;
        final chartHeight = constraints.maxHeight - 28;
        final step = (constraints.maxWidth - 42) / points.length;
        const labelWidth = 54.0;
        const labelIndexes = [1, 3, 5, 7, 9];

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _DriftBarPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 8) - 6,
                child: _AxisText('$label%'),
              ),
            for (final i in labelIndexes)
              Positioned(
                left: math
                    .max(
                      0,
                      math.min(
                        constraints.maxWidth - labelWidth,
                        34 + step * i + step / 2 - labelWidth / 2,
                      ),
                    )
                    .toDouble(),
                bottom: 0,
                width: labelWidth,
                child: _AxisText(points[i].date, align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _AutoStatusCard extends StatelessWidget {
  const _AutoStatusCard({
    required this.autoEnabled,
    required this.settings,
    required this.onChanged,
  });

  final bool autoEnabled;
  final SavingsRebalanceSettingsDraft settings;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.autoStatusKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: autoEnabled ? AppColors.buy10 : AppColors.hoverBg,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(
              autoEnabled ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: autoEnabled ? AppColors.buy : AppColors.text3,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tự động tái cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  autoEnabled
                      ? '${settings.frequencyLabel} · Ngưỡng ${settings.driftThreshold.toStringAsFixed(0)}%'
                      : 'Đã tắt',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: autoEnabled,
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot, required this.strategy});

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final completed = snapshot.history
        .where((item) => item.status == SavingsRebalanceHistoryStatus.completed)
        .length;
    final totalMoved = snapshot.history.fold<double>(
      0,
      (sum, item) => sum + item.totalMoved,
    );

    return Row(
      key: SavingsAutoRebalancePage.statsKey,
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.sync_rounded,
            color: AppColors.primary,
            value: '$completed',
            label: 'Lần cân bằng',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.compare_arrows_rounded,
            color: AppColors.buy,
            value: _formatUsd(totalMoved),
            label: 'Tổng di chuyển',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            color: AppColors.warn,
            value: '${strategy.expectedApy.toStringAsFixed(2)}%',
            label: 'APY kỳ vọng',
          ),
        ),
      ],
    );
  }
}

class _StrategyList extends StatelessWidget {
  const _StrategyList({
    required this.snapshot,
    required this.activeId,
    required this.onChanged,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chiến lược đề xuất',
      accentColor: AppColors.primary,
      children: [
        for (final strategy in snapshot.strategies)
          _StrategyCard(
            strategy: strategy,
            active: strategy.id == activeId,
            onTap: () => onChanged(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.active,
    required this.onTap,
  });

  final SavingsRebalanceStrategyDraft strategy;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(strategy.riskLevel);

    return VitCard(
      key: SavingsAutoRebalancePage.strategyKey(strategy.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: active ? color.withValues(alpha: .42) : null,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(_riskIcon(strategy.riskLevel), color: color),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        _TonePill(
                          label: _riskLabel(strategy.riskLevel),
                          color: color,
                        ),
                        if (active) ...[
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            Icons.check_circle_rounded,
                            color: color,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${strategy.expectedApy.toStringAsFixed(2)}%',
                    style: _captionMedium.copyWith(color: color),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          if (active) ...[
            const SizedBox(height: AppSpacing.x3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.xl),
              child: Row(
                children: [
                  for (final entry in strategy.allocations.entries)
                    Expanded(
                      flex: entry.value.round().clamp(1, 100).toInt(),
                      child: ColoredBox(
                        color: _assetColorName(entry.key),
                        child: const SizedBox(height: 6),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StrategyComparison extends StatelessWidget {
  const _StrategyComparison({required this.strategies});

  final List<SavingsRebalanceStrategyDraft> strategies;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            label: 'So sánh chiến lược',
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in [
            ('APY', [for (final item in strategies) '${item.expectedApy}%']),
            (
              'Rủi ro',
              [for (final item in strategies) _riskLabel(item.riskLevel)],
            ),
            (
              'Stablecoin',
              [
                for (final item in strategies)
                  '${item.allocations['USDT']?.toStringAsFixed(0)}%',
              ],
            ),
            (
              'BTC',
              [
                for (final item in strategies)
                  '${item.allocations['BTC']?.toStringAsFixed(0)}%',
              ],
            ),
          ])
            _CompareRow(label: row.$1, values: row.$2),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history});

  final List<SavingsRebalanceHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${history.length} lần tái cân bằng',
      accentColor: AppColors.primary,
      children: [for (final event in history) _HistoryCard(event: event)],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.event});

  final SavingsRebalanceHistoryDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _historyColor(event.status);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(_historyIcon(event.status), color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.strategy,
                      style: _captionMedium.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TonePill(label: _historyLabel(event.status), color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${event.date} · ${event.actions} thao tác · ${_formatUsd(event.totalMoved)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${event.driftBefore.toStringAsFixed(1)}% → ${event.driftAfter.toStringAsFixed(1)}%',
            style: _captionMedium.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.settings,
    required this.autoEnabled,
    required this.onAutoChanged,
  });

  final SavingsRebalanceSettingsDraft settings;
  final bool autoEnabled;
  final ValueChanged<bool> onAutoChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AutoStatusCard(
          autoEnabled: autoEnabled,
          settings: settings,
          onChanged: onAutoChanged,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              _SettingsRow(
                icon: Icons.calendar_today_rounded,
                label: 'Tần suất',
                value: settings.frequencyLabel,
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.tune_rounded,
                label: 'Ngưỡng rebalance',
                value: '${settings.driftThreshold.toStringAsFixed(0)}%',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.lock_outline_rounded,
                label: 'Bỏ qua vị thế khóa',
                value: settings.skipLocked ? 'Bật' : 'Tắt',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.payments_outlined,
                label: 'Lệnh tối thiểu',
                value: _formatUsd(settings.minTradeSize),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.snapshot,
    required this.strategy,
    required this.drift,
    required this.onClose,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;
  final double drift;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final actions = _rebalanceActions(snapshot, strategy);
    final totalMove = actions.fold<double>(0, (sum, item) => sum + item.amount);

    return ColoredBox(
      color: Colors.black.withValues(alpha: .55),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: VitCard(
          key: SavingsAutoRebalancePage.previewSheetKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xem trước tái cân bằng',
                        style: _baseBold.copyWith(color: AppColors.text1),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
                _PreviewRow(label: 'Chiến lược', value: strategy.name),
                _PreviewRow(
                  label: 'Drift hiện tại',
                  value: '${drift.toStringAsFixed(1)}%',
                  valueColor: _driftColor(drift),
                ),
                _PreviewRow(
                  label: 'Tổng di chuyển ước tính',
                  value: _formatUsd(totalMove / 2),
                ),
                _PreviewRow(label: 'Số thao tác', value: '${actions.length}'),
                const SizedBox(height: AppSpacing.x3),
                for (final action in actions.take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                    child: Row(
                      children: [
                        Icon(
                          action.increase
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: action.increase
                              ? AppColors.buy
                              : AppColors.sell,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            '${action.increase ? 'Tăng' : 'Giảm'} ${action.asset}',
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          _formatUsd(action.amount),
                          style: _captionMedium.copyWith(
                            color: action.increase
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.x2),
                VitCtaButton(
                  onPressed: onClose,
                  variant: VitCtaButtonVariant.warning,
                  child: const Text('Xác nhận tái cân bằng'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: _captionMedium.copyWith(color: AppColors.text1)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: _smBold.copyWith(color: AppColors.text1)),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TonePill extends StatelessWidget {
  const _TonePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadii.xs),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AxisText extends StatelessWidget {
  const _AxisText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: _captionMedium.copyWith(color: AppColors.text1),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(value, style: _captionMedium.copyWith(color: AppColors.text1)),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(value, style: _captionMedium.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _RebalanceActionDraft {
  const _RebalanceActionDraft({
    required this.asset,
    required this.increase,
    required this.amount,
  });

  final String asset;
  final bool increase;
  final double amount;
}

class _AllocationRingPainter extends CustomPainter {
  const _AllocationRingPainter({
    required this.allocations,
    required this.positions,
  });

  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = math.min(size.width, size.height) * .2;
    final rect = Offset.zero & size;
    final ringRect = rect.deflate(stroke / 2);
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    for (final entry in allocations.entries) {
      final sweep = math.pi * 2 * (entry.value / 100);
      paint.color = _assetColorName(entry.key);
      canvas.drawArc(ringRect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_AllocationRingPainter oldDelegate) {
    return oldDelegate.allocations != allocations ||
        oldDelegate.positions != positions;
  }
}

class _DriftTrackPainter extends CustomPainter {
  const _DriftTrackPainter({
    required this.color,
    required this.driftColor,
    required this.current,
    required this.target,
  });

  final Color color;
  final Color driftColor;
  final double current;
  final double target;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final track = RRect.fromRectAndRadius(Offset.zero & size, radius);
    canvas.drawRRect(track, Paint()..color = AppColors.surface2);
    final left = size.width * (math.min(current, target) / 100);
    final right = size.width * (math.max(current, target) / 100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, right, size.height),
        radius,
      ),
      Paint()..color = driftColor.withValues(alpha: .72),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (current / 100), 0, 2, size.height),
      Paint()..color = color,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * (target / 100), 0, 2, size.height),
      Paint()..color = AppColors.text2.withValues(alpha: .62),
    );
  }

  @override
  bool shouldRepaint(_DriftTrackPainter oldDelegate) {
    return oldDelegate.current != current ||
        oldDelegate.target != target ||
        oldDelegate.color != color ||
        oldDelegate.driftColor != driftColor;
  }
}

class _DriftBarPainter extends CustomPainter {
  const _DriftBarPainter({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 8, size.width - 42, size.height - 28);
    final grid = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (final value in [0, 2, 4, 6, 8]) {
      final y = chart.bottom - chart.height * (value / 8);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), grid);
    }

    final step = chart.width / points.length;
    final barWidth = step * .64;
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final height = chart.height * (point.drift / 8).clamp(0, 1);
      final x = chart.left + step * i + (step - barWidth) / 2;
      final color = _driftColor(point.drift).withValues(alpha: .86);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
          const Radius.circular(AppRadii.xs),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_DriftBarPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

double _totalDrift(
  List<SavingsRebalancePositionDraft> positions,
  SavingsRebalanceStrategyDraft strategy,
) {
  final total = positions.fold<double>(0, (sum, position) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    return sum + (position.currentPct - target).abs();
  });
  return total / 2;
}

List<_RebalanceActionDraft> _rebalanceActions(
  SavingsAutoRebalanceSnapshot snapshot,
  SavingsRebalanceStrategyDraft strategy,
) {
  return [
    for (final position in snapshot.positions)
      if (position.rebalanceable)
        (() {
          final target =
              strategy.allocations[position.asset] ?? position.targetPct;
          final diff = target - position.currentPct;
          final amount = (diff.abs() / 100) * snapshot.totalPortfolio;
          if (diff.abs() < .5 || amount < snapshot.settings.minTradeSize) {
            return null;
          }
          return _RebalanceActionDraft(
            asset: position.asset,
            increase: diff > 0,
            amount: amount,
          );
        })(),
  ].whereType<_RebalanceActionDraft>().toList();
}

Color _assetColor(SavingsRebalancePositionDraft position) {
  return _assetColorName(position.asset);
}

Color _assetColorName(String asset) {
  switch (asset) {
    case 'USDT':
      return AppColors.buy;
    case 'BTC':
      return AppColors.primary;
    case 'SOL':
      return AppColors.accent;
    case 'ETH':
      return AppColors.text2;
    default:
      return AppColors.text3;
  }
}

Color _driftColor(double drift) {
  if (drift < 2.5) return AppColors.buy;
  if (drift < 8) return AppColors.primary;
  return AppColors.sell;
}

Color _riskColor(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return AppColors.buy;
    case SavingsRebalanceRiskLevel.medium:
      return AppColors.primary;
    case SavingsRebalanceRiskLevel.high:
      return AppColors.sell;
  }
}

String _riskLabel(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return 'Thấp';
    case SavingsRebalanceRiskLevel.medium:
      return 'Trung bình';
    case SavingsRebalanceRiskLevel.high:
      return 'Cao';
  }
}

IconData _riskIcon(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return Icons.shield_outlined;
    case SavingsRebalanceRiskLevel.medium:
      return Icons.adjust_rounded;
    case SavingsRebalanceRiskLevel.high:
      return Icons.trending_up_rounded;
  }
}

Color _historyColor(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return AppColors.buy;
    case SavingsRebalanceHistoryStatus.partial:
      return AppColors.primary;
    case SavingsRebalanceHistoryStatus.failed:
      return AppColors.sell;
  }
}

String _historyLabel(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return 'Hoàn tất';
    case SavingsRebalanceHistoryStatus.partial:
      return 'Một phần';
    case SavingsRebalanceHistoryStatus.failed:
      return 'Thất bại';
  }
}

IconData _historyIcon(SavingsRebalanceHistoryStatus status) {
  switch (status) {
    case SavingsRebalanceHistoryStatus.completed:
      return Icons.check_circle_outline_rounded;
    case SavingsRebalanceHistoryStatus.partial:
      return Icons.warning_amber_rounded;
    case SavingsRebalanceHistoryStatus.failed:
      return Icons.error_outline_rounded;
  }
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(value >= 1000 ? 2 : 0);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) return '\$$buffer.${parts.last}';
  return '\$$buffer';
}
