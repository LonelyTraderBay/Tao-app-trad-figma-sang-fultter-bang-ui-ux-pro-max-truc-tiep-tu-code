import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

class UnifiedPortfolioDashboard extends ConsumerStatefulWidget {
  const UnifiedPortfolioDashboard({super.key, this.shellRenderMode});

  static const contentKey = Key('sc321_unified_portfolio_content');
  static const refreshKey = Key('sc321_refresh_data');
  static Key tabKey(UnifiedPortfolioTab tab) => Key('sc321_tab_${tab.name}');
  static Key moduleKey(UnifiedPortfolioModuleId id) =>
      Key('sc321_module_${id.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<UnifiedPortfolioDashboard> createState() =>
      _UnifiedPortfolioDashboardState();
}

class _UnifiedPortfolioDashboardState
    extends ConsumerState<UnifiedPortfolioDashboard> {
  UnifiedPortfolioTab _activeTab = UnifiedPortfolioTab.overview;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(unifiedPortfolioControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-321 UnifiedPortfolioDashboard',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _DashboardTabs(
              tabs: snapshot.tabs,
              active: _activeTab,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                key: UnifiedPortfolioDashboard.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == UnifiedPortfolioTab.overview)
                      _OverviewTab(snapshot: snapshot)
                    else if (_activeTab == UnifiedPortfolioTab.analysis)
                      _AnalysisTab(snapshot: snapshot)
                    else
                      _HistoryTab(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTabs extends StatelessWidget {
  const _DashboardTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<UnifiedPortfolioTabDraft> tabs;
  final UnifiedPortfolioTab active;
  final ValueChanged<UnifiedPortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    key: UnifiedPortfolioDashboard.tabKey(tab.tab),
                    onTap: () => onChanged(tab.tab),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.x4,
                          ),
                          child: Text(
                            tab.label,
                            style: AppTextStyles.caption.copyWith(
                              color: tab.tab == active
                                  ? AppColors.primary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          height: 2,
                          width: tab.tab == active ? AppSpacing.buttonHero : 0,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TotalValueCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        _DistributionCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Module Breakdown',
          accentColor: AppColors.primary,
          customGap: AppSpacing.x4,
          children: [
            for (final module in snapshot.modules)
              _ModuleCard(module: module, totalValue: snapshot.totalValue),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _RefreshButton(onPressed: () => HapticFeedback.lightImpact()),
        const SizedBox(height: AppSpacing.sectionGap),
        const _BoundaryInfoCard(),
      ],
    );
  }
}

class _TotalValueCard extends StatelessWidget {
  const _TotalValueCard({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pnlPositive = snapshot.totalPnl >= 0;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              Text(
                _formatUsd(snapshot.totalValue),
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              _PnlInline(
                value: snapshot.totalPnl,
                percent: snapshot.totalPnlPercent,
                positive: pnlPositive,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Total Positions',
                  value: '${snapshot.totalPositions}',
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Active Modules',
                  value: '${snapshot.activeModules}',
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Total P&L',
                  value: _formatSignedUsd(snapshot.totalPnl),
                  valueColor: pnlPositive ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PnlInline extends StatelessWidget {
  const _PnlInline({
    required this.value,
    required this.percent,
    required this.positive,
  });

  final int value;
  final double percent;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          '${_formatSignedUsd(value)} (${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%)',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Distribution',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: CustomPaint(
              painter: _DonutDistributionPainter(
                modules: modules,
                total: snapshot.totalValue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x6,
            runSpacing: AppSpacing.x3,
            children: [
              for (final module in modules) _LegendItem(module: module),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.module});

  final UnifiedPortfolioModuleDraft module;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonHero + AppSpacing.x7,
      child: Row(
        children: [
          Container(
            width: AppSpacing.x4,
            height: AppSpacing.x4,
            decoration: BoxDecoration(
              color: _moduleAccent(module.id),
              borderRadius: AppRadii.xsRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              _shortModuleName(module),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.totalValue});

  final UnifiedPortfolioModuleDraft module;
  final int totalValue;

  @override
  Widget build(BuildContext context) {
    final accent = _moduleAccent(module.id);
    return VitCard(
      key: UnifiedPortfolioDashboard.moduleKey(module.id),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      clip: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => context.go(module.route),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ModuleIcon(id: module.id),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module.name,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            '${module.activePositions} active positions',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                if (module.pointsOnly)
                  const _ArenaBoundaryPill()
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryMetric(
                          label: 'Value',
                          value: _formatUsd(module.value),
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: '24h Change',
                          value:
                              '${module.change24h >= 0 ? '+' : ''}${module.change24h.toStringAsFixed(1)}%',
                          valueColor: module.change24h >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: 'P&L',
                          value: _formatSignedUsd(module.pnl),
                          valueColor: module.pnl >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  ClipRRect(
                    borderRadius: AppRadii.xlRadius,
                    child: LinearProgressIndicator(
                      value: totalValue == 0 ? 0 : module.value / totalValue,
                      minHeight: AppSpacing.x2,
                      backgroundColor: AppColors.surface3,
                      color: accent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleIcon extends StatelessWidget {
  const _ModuleIcon({required this.id});

  final UnifiedPortfolioModuleId id;

  @override
  Widget build(BuildContext context) {
    final accent = _moduleAccent(id);
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .14),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(_moduleIcon(id), color: accent, size: AppSpacing.iconMd),
    );
  }
}

class _ArenaBoundaryPill extends StatelessWidget {
  const _ArenaBoundaryPill();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Text(
        'Arena Points Only - Not included in portfolio value',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.warn,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: UnifiedPortfolioDashboard.refreshKey,
      variant: VitCtaButtonVariant.ghost,
      onPressed: onPressed,
      leading: const Icon(Icons.refresh_rounded),
      child: const Text('Refresh Data'),
    );
  }
}

class _BoundaryInfoCard extends StatelessWidget {
  const _BoundaryInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Arena Points are not included in portfolio value as they are points-only and not financial assets. Each module maintains separate accounting.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  const _AnalysisTab({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    final ranked = [...modules]
      ..sort((a, b) => _returnPercent(b).compareTo(_returnPercent(a)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'P&L by Module',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              SizedBox(
                height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
                child: CustomPaint(
                  painter: _PnlBarPainter(modules: modules),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Performance Ranking',
          children: [
            for (var i = 0; i < ranked.length; i++)
              _RankingRow(rank: i + 1, module: ranked[i]),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Allocation Analysis',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final module in modules) ...[
                _AllocationRow(module: module, totalValue: snapshot.totalValue),
                if (module != modules.last)
                  const SizedBox(height: AppSpacing.x4),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.rank, required this.module});

  final int rank;
  final UnifiedPortfolioModuleDraft module;

  @override
  Widget build(BuildContext context) {
    final returnPercent = _returnPercent(module);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonCompact,
            child: rank == 1
                ? const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  )
                : Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _ModuleIcon(id: module.id),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _shortModuleName(module),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _formatUsd(module.value),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: returnPercent >= 0 ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                _formatSignedUsd(module.pnl),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.module, required this.totalValue});

  final UnifiedPortfolioModuleDraft module;
  final int totalValue;

  @override
  Widget build(BuildContext context) {
    final allocation = totalValue == 0 ? 0.0 : module.value / totalValue * 100;
    final returnPercent = _returnPercent(module);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _shortModuleName(module),
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            VitStatusPill(
              label:
                  '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(1)}%',
              status: returnPercent >= 0
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              '${allocation.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: LinearProgressIndicator(
            value: allocation / 100,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface3,
            color: _moduleAccent(module.id),
          ),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final modules = snapshot.financialModules.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Portfolio Growth History',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              SizedBox(
                height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
                child: CustomPaint(
                  painter: _HistoryLinePainter(points: snapshot.history),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Module Growth (6 months)',
          children: [
            for (final module in modules)
              _GrowthRow(module: module, history: snapshot.history),
          ],
        ),
      ],
    );
  }
}

class _GrowthRow extends StatelessWidget {
  const _GrowthRow({required this.module, required this.history});

  final UnifiedPortfolioModuleDraft module;
  final List<UnifiedPortfolioHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    final oldValue = _historyValue(history.first, module.id);
    final growth = oldValue == 0
        ? 0.0
        : (module.value - oldValue) / oldValue * 100;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              module.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: growth >= 0 ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${_formatUsd(oldValue)} -> ${_formatUsd(module.value)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutDistributionPainter extends CustomPainter {
  const _DonutDistributionPainter({required this.modules, required this.total});

  final List<UnifiedPortfolioModuleDraft> modules;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .36;
    final stroke = AppSpacing.x6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = AppColors.surface3;
    canvas.drawCircle(center, radius, bg);

    for (final module in modules) {
      final sweep = total == 0 ? 0.0 : module.value / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = _moduleAccent(module.id);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutDistributionPainter oldDelegate) =>
      oldDelegate.modules != modules || oldDelegate.total != total;
}

class _PnlBarPainter extends CustomPainter {
  const _PnlBarPainter({required this.modules});

  final List<UnifiedPortfolioModuleDraft> modules;

  @override
  void paint(Canvas canvas, Size size) {
    if (modules.isEmpty) return;
    final maxAbs = modules
        .map((module) => module.pnl.abs())
        .reduce((value, element) => math.max(value, element));
    final chartTop = AppSpacing.x4;
    final chartBottom = size.height - AppSpacing.x6;
    final zeroY = chartTop + (chartBottom - chartTop) * .58;
    final slot = size.width / modules.length;
    final barWidth = math.min(AppSpacing.x7, slot * .55);

    final axisPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), axisPaint);

    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      final x = slot * i + (slot - barWidth) / 2;
      final height = maxAbs == 0
          ? 0.0
          : (module.pnl.abs() / maxAbs) * AppSpacing.buttonHero;
      final top = module.pnl >= 0 ? zeroY - height : zeroY;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, height),
        const Radius.circular(AppSpacing.x2),
      );
      final paint = Paint()
        ..color = module.pnl >= 0 ? AppColors.buy : AppColors.sell;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PnlBarPainter oldDelegate) =>
      oldDelegate.modules != modules;
}

class _HistoryLinePainter extends CustomPainter {
  const _HistoryLinePainter({required this.points});

  final List<UnifiedPortfolioHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final allValues = [
      for (final point in points) ...[
        point.wallet,
        point.trading,
        point.p2p,
        point.predictions,
        point.dca,
      ],
    ];
    final minValue = allValues.reduce(math.min).toDouble();
    final maxValue = allValues.reduce(math.max).toDouble();

    void drawSeries(
      int Function(UnifiedPortfolioHistoryPoint point) valueOf,
      Color color,
    ) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = i / (points.length - 1) * size.width;
        final raw = valueOf(points[i]).toDouble();
        final normalized = (raw - minValue) / (maxValue - minValue);
        final y = size.height - normalized * (size.height - AppSpacing.x6);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.x1
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawPath(path, paint);
    }

    drawSeries((point) => point.wallet, AppModuleAccents.wallet);
    drawSeries((point) => point.trading, AppModuleAccents.trade);
    drawSeries((point) => point.p2p, AppModuleAccents.p2p);
    drawSeries((point) => point.predictions, AppModuleAccents.predictions);
    drawSeries((point) => point.dca, AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant _HistoryLinePainter oldDelegate) =>
      oldDelegate.points != points;
}

String _formatUsd(int value) {
  final negative = value < 0;
  final raw = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${negative ? '-' : ''}\$${buffer.toString()}';
}

String _formatSignedUsd(int value) => value >= 0
    ? '+${_formatUsd(value)}'
    : '-${_formatUsd(value.abs()).replaceFirst('-', '')}';

String _shortModuleName(UnifiedPortfolioModuleDraft module) {
  switch (module.id) {
    case UnifiedPortfolioModuleId.wallet:
      return 'Wallet';
    case UnifiedPortfolioModuleId.trading:
      return 'Trading';
    case UnifiedPortfolioModuleId.p2p:
      return 'P2P';
    case UnifiedPortfolioModuleId.predictions:
      return 'Prediction';
    case UnifiedPortfolioModuleId.arena:
      return 'Arena';
    case UnifiedPortfolioModuleId.dca:
      return 'DCA';
  }
}

double _returnPercent(UnifiedPortfolioModuleDraft module) {
  final principal = module.value - module.pnl;
  if (principal == 0) return 0;
  return module.pnl / principal * 100;
}

Color _moduleAccent(UnifiedPortfolioModuleId id) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return AppModuleAccents.wallet;
    case UnifiedPortfolioModuleId.trading:
      return AppColors.buy;
    case UnifiedPortfolioModuleId.p2p:
      return AppModuleAccents.p2p;
    case UnifiedPortfolioModuleId.predictions:
      return AppModuleAccents.predictions;
    case UnifiedPortfolioModuleId.arena:
      return AppModuleAccents.arena;
    case UnifiedPortfolioModuleId.dca:
      return AppColors.accent;
  }
}

IconData _moduleIcon(UnifiedPortfolioModuleId id) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return Icons.account_balance_wallet_outlined;
    case UnifiedPortfolioModuleId.trading:
      return Icons.bar_chart_rounded;
    case UnifiedPortfolioModuleId.p2p:
      return Icons.shopping_cart_outlined;
    case UnifiedPortfolioModuleId.predictions:
      return Icons.adjust_rounded;
    case UnifiedPortfolioModuleId.arena:
      return Icons.bolt_rounded;
    case UnifiedPortfolioModuleId.dca:
      return Icons.timeline_rounded;
  }
}

int _historyValue(
  UnifiedPortfolioHistoryPoint point,
  UnifiedPortfolioModuleId id,
) {
  switch (id) {
    case UnifiedPortfolioModuleId.wallet:
      return point.wallet;
    case UnifiedPortfolioModuleId.trading:
      return point.trading;
    case UnifiedPortfolioModuleId.p2p:
      return point.p2p;
    case UnifiedPortfolioModuleId.predictions:
      return point.predictions;
    case UnifiedPortfolioModuleId.dca:
      return point.dca;
    case UnifiedPortfolioModuleId.arena:
      return 0;
  }
}
