import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';

enum _OptimizerTab { frontier, correlation, backtest, risk }

class DCAPortfolioOptimizer extends ConsumerStatefulWidget {
  const DCAPortfolioOptimizer({super.key, this.shellRenderMode});

  static const contentKey = Key('sc174_portfolio_optimizer_content');
  static const applyKey = Key('sc174_apply_allocation');
  static const driftSettingsKey = Key('sc174_drift_settings');

  static Key tabKey(String tabName) => Key('sc174_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPortfolioOptimizer> createState() =>
      _DCAPortfolioOptimizerState();
}

class _DCAPortfolioOptimizerState extends ConsumerState<DCAPortfolioOptimizer> {
  _OptimizerTab _activeTab = _OptimizerTab.frontier;
  bool _showSuggestions = true;
  bool _showDriftBanner = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaRepositoryProvider).getPortfolioOptimizer();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final floatingBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.tabBar + AppSpacing.x2
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x2) +
        MediaQuery.paddingOf(context).bottom;
    final contentBottom = floatingBottom + AppSpacing.buttonStandard;

    return VitPageLayout(
      semanticLabel: 'SC-174 DCAPortfolioOptimizer',
      child: Column(
        children: [
          VitHeader(
            title: 'Portfolio Optimizer',
            subtitle: 'Tối ưu · DCA',
            showBack: true,
            onBack: _close,
            trailing: _HeaderShareButton(onPressed: _showExportNotice),
          ),
          Expanded(
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: DCAPortfolioOptimizer.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: contentBottom),
                    child: VitPageContent(
                      customGap: AppSpacing.x5,
                      children: [
                        if (_showDriftBanner)
                          _DriftBanner(
                            snapshot: snapshot,
                            onDismiss: () {
                              setState(() => _showDriftBanner = false);
                            },
                            onSettings: _showDriftSettings,
                          ),
                        _ComparisonHero(snapshot: snapshot),
                        _OptimizerTabs(
                          activeTab: _activeTab,
                          onChanged: (tab) {
                            setState(() => _activeTab = tab);
                          },
                        ),
                        _TabContent(
                          activeTab: _activeTab,
                          snapshot: snapshot,
                          showSuggestions: _showSuggestions,
                          onToggleSuggestions: () {
                            setState(
                              () => _showSuggestions = !_showSuggestions,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.contentPad,
                  right: AppSpacing.contentPad,
                  bottom: floatingBottom,
                  child: _FloatingActions(
                    onShare: _showExportNotice,
                    onSettings: _showDriftSettings,
                    onApply: () => context.go(AppRoutePaths.dcaRebalanceConfig),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showExportNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Portfolio report ready to share')),
    );
  }

  void _showDriftSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Drift threshold: 5%')));
  }
}

class _HeaderShareButton extends StatelessWidget {
  const _HeaderShareButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.share_outlined,
            color: AppColors.text1,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}

class _DriftBanner extends StatelessWidget {
  const _DriftBanner({
    required this.snapshot,
    required this.onDismiss,
    required this.onSettings,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final VoidCallback onDismiss;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.sell10,
              borderRadius: AppRadii.mdRadius,
              border: Border.all(color: AppColors.sell20),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Portfolio Drift Cao',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallPill(
                      label: '${snapshot.driftPercent.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Danh mục đã lệch ${snapshot.driftPercent.toStringAsFixed(1)}% so với phân bổ mục tiêu (ngưỡng: ${snapshot.driftThresholdPercent.toStringAsFixed(0)}%). Xem xét tái cân bằng.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x2,
                  children: [
                    _MiniButton(
                      label: 'Cài đặt',
                      icon: Icons.tune_rounded,
                      color: AppColors.sell,
                      onTap: onSettings,
                    ),
                    _MiniButton(
                      label: 'Tạm ẩn',
                      icon: Icons.visibility_off_outlined,
                      color: AppColors.text2,
                      onTap: onDismiss,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSpacing.x6,
              minHeight: AppSpacing.x6,
            ),
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonHero extends StatelessWidget {
  const _ComparisonHero({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Comparison',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Hiện tại vs Tối ưu',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              _ScoreBadge(score: snapshot.score),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _MetricStrip(snapshot: snapshot),
          const SizedBox(height: AppSpacing.x5),
          for (final allocation in snapshot.currentAllocations) ...[
            _AllocationRow(allocation: allocation),
            if (allocation != snapshot.currentAllocations.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.portfolioBtnGhostBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Score',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '$score',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.buy,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            '/100',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        label: 'Sharpe tối ưu',
        value: snapshot.optimalSharpe.toStringAsFixed(2),
        color: AppColors.accent,
      ),
      (
        label: 'Return/năm',
        value: '+${snapshot.optimalReturnPercent.toStringAsFixed(0)}%',
        color: AppColors.buy,
      ),
      (
        label: 'Drift hiện tại',
        value: '${snapshot.driftPercent.toStringAsFixed(1)}%',
        color: AppColors.sell,
      ),
    ];

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          for (final metric in metrics) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x4,
                ),
                child: Column(
                  children: [
                    Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      metric.value,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: metric.color,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (metric != metrics.last)
              Container(
                width: 1,
                height: AppSpacing.x7,
                color: AppColors.border,
              ),
          ],
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.allocation});

  final DcaPortfolioAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(allocation.accent);
    final diff = allocation.diffPercent;
    final maxPercent = math.max(
      1.0,
      math.max(allocation.currentPercent, allocation.optimalPercent),
    );

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x3,
                height: AppSpacing.x3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  allocation.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(
                label: '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(0)}%',
                color: diff > 0
                    ? AppColors.buy
                    : diff < 0
                    ? AppColors.sell
                    : AppColors.text3,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _PercentBar(
            label: 'Hiện tại',
            value: allocation.currentPercent,
            maxValue: maxPercent,
            color: accent.withValues(alpha: .65),
            valueColor: AppColors.portfolioTextDim,
          ),
          const SizedBox(height: AppSpacing.x2),
          _PercentBar(
            label: 'Tối ưu',
            value: allocation.optimalPercent,
            maxValue: maxPercent,
            color: accent,
            valueColor: AppColors.text1,
          ),
        ],
      ),
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.valueColor,
  });

  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.x7,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: value / maxValue,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: AppSpacing.x6,
          child: Text(
            '${value.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptimizerTabs extends StatelessWidget {
  const _OptimizerTabs({required this.activeTab, required this.onChanged});

  final _OptimizerTab activeTab;
  final ValueChanged<_OptimizerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x2),
      child: Row(
        children: [
          for (final tab in _OptimizerTab.values)
            Expanded(
              child: _OptimizerTabButton(
                key: DCAPortfolioOptimizer.tabKey(tab.name),
                tab: tab,
                active: tab == activeTab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptimizerTabButton extends StatelessWidget {
  const _OptimizerTabButton({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final _OptimizerTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _tabIcon(tab),
              color: active ? AppColors.accent : AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              _tabLabel(tab),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: active ? AppColors.text1 : AppColors.text3,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.activeTab,
    required this.snapshot,
    required this.showSuggestions,
    required this.onToggleSuggestions,
  });

  final _OptimizerTab activeTab;
  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final VoidCallback onToggleSuggestions;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      _OptimizerTab.frontier => _FrontierContent(
        snapshot: snapshot,
        showSuggestions: showSuggestions,
        onToggleSuggestions: onToggleSuggestions,
      ),
      _OptimizerTab.correlation => const _CorrelationContent(),
      _OptimizerTab.backtest => const _BacktestContent(),
      _OptimizerTab.risk => _RiskContent(snapshot: snapshot),
    };
  }
}

class _FrontierContent extends StatelessWidget {
  const _FrontierContent({
    required this.snapshot,
    required this.showSuggestions,
    required this.onToggleSuggestions,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final VoidCallback onToggleSuggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(
          icon: Icons.adjust_rounded,
          title: 'Efficient Frontier',
          color: AppColors.accent,
          trailing: _MiniButton(
            label: 'So sánh',
            icon: Icons.compare_arrows_rounded,
            color: AppColors.text3,
            onTap: () {},
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardLabel(
                color: AppColors.accent,
                title: 'Risk-Return Scatter',
                subtitle:
                    'Mỗi điểm đại diện một phân bổ tối ưu. Điểm càng cao = lợi nhuận lớn hơn.',
              ),
              const SizedBox(height: AppSpacing.x4),
              SizedBox(
                height: 220,
                width: double.infinity,
                child: CustomPaint(
                  painter: _FrontierChartPainter(snapshot.frontier),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.frontier.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
            itemBuilder: (context, index) {
              final point = snapshot.frontier[index];
              final active = point.label == 'Optimal (Max Sharpe)';
              return _FrontierChip(point: point, active: active);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _SelectedPortfolioCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        _SuggestionsCard(
          suggestions: snapshot.suggestions,
          expanded: showSuggestions,
          onToggle: onToggleSuggestions,
        ),
      ],
    );
  }
}

class _SelectedPortfolioCard extends StatelessWidget {
  const _SelectedPortfolioCard({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final optimalAllocations = snapshot.currentAllocations
        .where((allocation) => allocation.optimalPercent > 0)
        .toList(growable: false);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: BoxDecoration(
                  color: AppColors.accent10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optimal (Max Sharpe)',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Phân bổ đề xuất',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SmallPill(
                label: 'Sharpe ${snapshot.optimalSharpe.toStringAsFixed(2)}',
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(
                    label: 'Lợi nhuận/năm',
                    value:
                        '+${snapshot.optimalReturnPercent.toStringAsFixed(0)}%',
                    color: AppColors.buy,
                  ),
                ),
                Container(
                  width: 1,
                  height: AppSpacing.x7,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _StatCell(
                    label: 'Biến động (Vol)',
                    value: '${snapshot.optimalRiskPercent.toStringAsFixed(0)}%',
                    color: AppColors.warn,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final allocation in optimalAllocations) ...[
            _SimpleAllocationBar(allocation: allocation),
            if (allocation != optimalAllocations.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _SuggestionsCard extends StatelessWidget {
  const _SuggestionsCard({
    required this.suggestions,
    required this.expanded,
    required this.onToggle,
  });

  final List<DcaPortfolioSuggestion> suggestions;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.mdRadius,
            child: Row(
              children: [
                const _IconBubble(
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.warn,
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    'Gợi ý tối ưu (${suggestions.length})',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x4),
            for (final suggestion in suggestions) ...[
              _SuggestionRow(suggestion: suggestion),
              if (suggestion != suggestions.last)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ],
      ),
    );
  }
}

class _CorrelationContent extends StatelessWidget {
  const _CorrelationContent();

  @override
  Widget build(BuildContext context) {
    const assets = ['BTC', 'ETH', 'SOL', 'BNB', 'ADA'];
    final correlations = [
      [1.00, .82, .71, .68, .65],
      [.82, 1.00, .78, .73, .70],
      [.71, .78, 1.00, .58, .62],
      [.68, .73, .58, 1.00, .55],
      [.65, .70, .62, .55, 1.00],
    ];

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.hub_outlined,
            title: 'Ma trận tương quan',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tương quan càng thấp = diversification tốt. Càng cao = di chuyển cùng hướng.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              const SizedBox(width: AppSpacing.x7),
              for (final asset in assets)
                Expanded(
                  child: Text(
                    asset,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (var row = 0; row < assets.length; row++) ...[
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.x7,
                  child: Text(
                    assets[row],
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (var col = 0; col < assets.length; col++)
                  Expanded(
                    child: _CorrelationCell(value: correlations[row][col]),
                  ),
              ],
            ),
            if (row != assets.length - 1) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _BacktestContent extends StatelessWidget {
  const _BacktestContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.bar_chart_rounded,
                title: 'DCA vs HODL (12 tháng)',
                color: AppColors.buy,
              ),
              const SizedBox(height: AppSpacing.x4),
              SizedBox(
                height: 210,
                width: double.infinity,
                child: CustomPaint(painter: _BacktestChartPainter()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: const [
            Expanded(
              child: _MiniStatCard(
                label: 'DCA Final',
                value: '12.9M',
                color: AppColors.buy,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'HODL Final',
                value: '11.2M',
                color: AppColors.warn,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'DCA trội hơn',
                value: '+14.7%',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        const _DisclaimerCard(
          text:
              'Kết quả dựa trên dữ liệu lịch sử, không đảm bảo hiệu suất tương lai.',
        ),
      ],
    );
  }
}

class _RiskContent extends StatelessWidget {
  const _RiskContent({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Biến động/năm',
        '${snapshot.optimalRiskPercent.toStringAsFixed(1)}%',
        AppColors.warn,
      ),
      ('Max Drawdown', '-27.8%', AppColors.sell),
      (
        'Sharpe Ratio',
        snapshot.optimalSharpe.toStringAsFixed(2),
        AppColors.accent,
      ),
      ('Sortino Ratio', '1.78', AppColors.primary),
      ('VaR 95%', '-7.5%', AppColors.sell),
      ('Beta', '1.20', AppColors.buy),
    ];

    return Column(
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.shield_outlined,
                title: 'Đánh giá rủi ro',
                color: AppColors.sell,
              ),
              const SizedBox(height: AppSpacing.x4),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metrics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x3,
                ),
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  return _MiniStatCard(
                    label: metric.$1,
                    value: metric.$2,
                    color: metric.$3,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _DisclaimerCard(
          text:
              'Các chỉ số dựa trên dữ liệu lịch sử. Hãy đa dạng hóa và chỉ đầu tư số tiền bạn chấp nhận mất.',
        ),
      ],
    );
  }
}

class _FloatingActions extends StatelessWidget {
  const _FloatingActions({
    required this.onShare,
    required this.onSettings,
    required this.onApply,
  });

  final VoidCallback onShare;
  final VoidCallback onSettings;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FloatingIconButton(icon: Icons.share_outlined, onTap: onShare),
        const SizedBox(width: AppSpacing.x3),
        _FloatingIconButton(
          key: DCAPortfolioOptimizer.driftSettingsKey,
          icon: Icons.notifications_none_rounded,
          iconColor: AppColors.warn,
          onTap: onSettings,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: DCAPortfolioOptimizer.applyKey,
            onPressed: onApply,
            leading: const Icon(Icons.arrow_outward_rounded),
            child: const Text('Áp dụng phân bổ'),
          ),
        ),
      ],
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.navCenterIcon,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      child: VitCtaButton(
        onPressed: onTap,
        fullWidth: false,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: iconColor, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: color.withValues(alpha: .16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(icon: icon, color: color),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.inputRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _FrontierChip extends StatelessWidget {
  const _FrontierChip({required this.point, required this.active});

  final DcaFrontierPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: active ? AppColors.accent10 : AppColors.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(
          color: active ? AppColors.accent30 : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            point.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Text(
                '+${point.returnPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                ' · ',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                '${point.riskPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleAllocationBar extends StatelessWidget {
  const _SimpleAllocationBar({required this.allocation});

  final DcaPortfolioAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(allocation.accent);
    return Row(
      children: [
        Container(
          width: AppSpacing.x7,
          height: AppSpacing.x7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: .10),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Text(
            allocation.symbol,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: allocation.optimalPercent / 100,
              color: accent,
              backgroundColor: AppColors.surface2,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: AppSpacing.x6,
          child: Text(
            '${allocation.optimalPercent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion});

  final DcaPortfolioSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final positive =
        suggestion.type == DcaPortfolioSuggestionType.add ||
        suggestion.type == DcaPortfolioSuggestionType.increase;
    final color = positive ? AppColors.buy : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(
            icon: positive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      suggestion.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      '${suggestion.currentPercent.toStringAsFixed(0)}% → ${suggestion.suggestedPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  suggestion.reason,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrelationCell extends StatelessWidget {
  const _CorrelationCell({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= .7
        ? AppColors.sell
        : value >= .4
        ? AppColors.warn
        : AppColors.buy;
    return Container(
      height: AppSpacing.x7,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: value == 1 ? .08 : .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        value.toStringAsFixed(2),
        style: AppTextStyles.micro.copyWith(
          color: value == 1 ? AppColors.text3 : color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBubble(
            icon: Icons.warning_amber_rounded,
            color: AppColors.warn,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrontierChartPainter extends CustomPainter {
  const _FrontierChartPainter(this.points);

  final List<DcaFrontierPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x6 - AppSpacing.x3,
      size.height - AppSpacing.x6,
    );
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .45)
      ..strokeWidth = 1;

    for (var i = 0; i <= 3; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final x = chart.left + chart.width * i / 3;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
    }
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      axisPaint,
    );

    for (final point in points) {
      final x = chart.left + chart.width * (point.riskPercent / 60);
      final y = chart.bottom - chart.height * (point.returnPercent / 60);
      final active = point.label == 'Optimal (Max Sharpe)';
      final paint = Paint()
        ..color = active ? AppColors.accent : AppColors.accent30;
      canvas.drawCircle(
        Offset(x, y),
        active ? AppSpacing.x3 : AppSpacing.x2,
        paint,
      );
      if (active) {
        canvas.drawCircle(
          Offset(x, y),
          AppSpacing.x4,
          Paint()
            ..color = AppColors.accent20
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }

    _paintChartLabel(
      canvas,
      'Rủi ro (%)',
      Offset(chart.center.dx - AppSpacing.x6, size.height - AppSpacing.x3),
    );
    canvas.save();
    canvas.translate(AppSpacing.x3, chart.center.dy + AppSpacing.x7);
    canvas.rotate(-math.pi / 2);
    _paintChartLabel(canvas, 'Lợi nhuận (%)', Offset.zero);
    canvas.restore();
  }

  void _paintChartLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _FrontierChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _BacktestChartPainter extends CustomPainter {
  const _BacktestChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      AppSpacing.x4,
      AppSpacing.x2,
      size.width - AppSpacing.x5,
      size.height - AppSpacing.x4,
    );
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    final dca = [8, 12, 16, 22, 24, 28, 34, 39, 46, 53, 57, 64];
    final hodl = [8, 11, 14, 19, 21, 25, 31, 36, 42, 47, 51, 56];
    _drawSeries(canvas, chart, dca, AppColors.buy);
    _drawSeries(canvas, chart, hodl, AppColors.warn);
  }

  void _drawSeries(Canvas canvas, Rect chart, List<int> values, Color color) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - chart.height * values[i] / 70;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BacktestChartPainter oldDelegate) => false;
}

Color _assetColor(DcaPortfolioAssetAccent accent) {
  return switch (accent) {
    DcaPortfolioAssetAccent.btc => AppColors.primarySoft,
    DcaPortfolioAssetAccent.eth => AppColors.accent,
    DcaPortfolioAssetAccent.usdt => AppColors.buy,
    DcaPortfolioAssetAccent.sol => AppColors.accent,
    DcaPortfolioAssetAccent.bnb => AppColors.warn,
  };
}

String _tabLabel(_OptimizerTab tab) {
  return switch (tab) {
    _OptimizerTab.frontier => 'Frontier',
    _OptimizerTab.correlation => 'Tương quan',
    _OptimizerTab.backtest => 'Backtest',
    _OptimizerTab.risk => 'Rủi ro',
  };
}

IconData _tabIcon(_OptimizerTab tab) {
  return switch (tab) {
    _OptimizerTab.frontier => Icons.adjust_rounded,
    _OptimizerTab.correlation => Icons.hub_outlined,
    _OptimizerTab.backtest => Icons.bar_chart_rounded,
    _OptimizerTab.risk => Icons.shield_outlined,
  };
}
