import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _advancedBackground = AppColors.bg;
const _advancedPanel = AppColors.surface;
const _advancedPanel2 = AppColors.surface2;
const _advancedBorder = AppColors.borderSolid;
const _advancedPrimary = AppColors.primary;
const _advancedGreen = Color(0xFF10B981);
const _advancedRed = Color(0xFFEF4444);
const _advancedPurple = Color(0xFF8B5CF6);
const _advancedAmber = Color(0xFFF59E0B);

class AdvancedAnalyticsPage extends ConsumerStatefulWidget {
  const AdvancedAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc092_advanced_analytics_content');
  static Key tabKey(String id) => Key('sc092_advanced_tab_$id');
  static Key filterKey(String id) => Key('sc092_advanced_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedAnalyticsPage> createState() =>
      _AdvancedAnalyticsPageState();
}

class _AdvancedAnalyticsPageState extends ConsumerState<AdvancedAnalyticsPage> {
  String _tab = 'ai';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getAdvancedAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-092 AdvancedAnalyticsPage',
      child: Material(
        color: _advancedBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Advanced Analytics',
              subtitle: 'AI & Professional Tools',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeMargin),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: AdvancedAnalyticsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroCard(stats: snapshot.stats),
                    const SizedBox(height: 16),
                    _UnderlineTabs(
                      activeId: _tab,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    const SizedBox(height: 16),
                    if (_tab == 'ai')
                      _AiSignalsTab(
                        snapshot: snapshot,
                        activeFilter: _filter,
                        onFilterChanged: (id) => setState(() => _filter = id),
                      )
                    else if (_tab == 'risk')
                      _RiskAnalysisTab(snapshot: snapshot)
                    else if (_tab == 'journal')
                      _TradeJournalTab(snapshot: snapshot)
                    else
                      _PositionSizingTab(snapshot: snapshot),
                    const SizedBox(height: 12),
                    _ModelInfoCard(),
                    const SizedBox(height: 12),
                    _FeaturesCard(features: snapshot.features),
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeAdvancedAnalyticsStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surface2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'P3: Advanced Analytics',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'AI-powered insights va professional trading tools',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: .72),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.stat});

  final TradeAdvancedAnalyticsStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: Colors.white.withValues(alpha: .62),
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('ai', 'AI Signals', Icons.psychology_rounded),
    ('risk', 'Risk Analysis', Icons.shield_outlined),
    ('journal', 'Trade Journal', Icons.menu_book_rounded),
    ('sizing', 'Position Sizing', Icons.calculate_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: _advancedPanel,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: AdvancedAnalyticsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: activeId == tab.$1
                            ? _advancedPrimary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.$3,
                        color: activeId == tab.$1
                            ? _advancedPrimary
                            : AppColors.text3,
                        size: 15,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: activeId == tab.$1
                              ? _advancedPrimary
                              : AppColors.text3,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AiSignalsTab extends StatelessWidget {
  const _AiSignalsTab({
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final TradeAdvancedAnalyticsSnapshot snapshot;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final visibleSignals = activeFilter == 'all'
        ? snapshot.signals
        : snapshot.signals
              .where((signal) => signal.direction == activeFilter)
              .toList();
    final avgConfidence =
        snapshot.signals.fold<int>(0, (sum, item) => sum + item.confidence) /
        snapshot.signals.length;
    final longCount = snapshot.signals
        .where((signal) => signal.direction == 'long')
        .length;
    final shortCount = snapshot.signals
        .where((signal) => signal.direction == 'short')
        .length;

    return _Card(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.psychology_rounded,
            color: _advancedPurple,
            title: 'AI Trading Signals',
            subtitle: 'Machine learning powered predictions',
            iconSize: 24,
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _MiniStatBox(
                  label: 'Active',
                  value: '${snapshot.signals.length}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatBox(
                  label: 'Avg Confidence',
                  value: '${avgConfidence.toStringAsFixed(0)}%',
                  valueColor: _advancedGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatBox(
                  label: 'L/S Ratio',
                  value: '$longCount/$shortCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final filter in const ['all', 'long', 'short']) ...[
                Expanded(
                  child: _FilterChip(
                    id: filter,
                    selected: activeFilter == filter,
                    onTap: () => onFilterChanged(filter),
                  ),
                ),
                if (filter != 'short') const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 16),
          for (final signal in visibleSignals) ...[
            _SignalCard(signal: signal),
            if (signal != visibleSignals.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          const _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: AdvancedAnalyticsPage.filterKey(id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? _advancedPurple.withValues(alpha: .18)
              : _advancedPanel2,
          border: Border.all(
            color: selected ? _advancedPurple : _advancedBorder,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          id.toUpperCase(),
          style: AppTextStyles.caption.copyWith(
            color: selected ? _advancedPurple : AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  const _SignalCard({required this.signal});

  final TradeAiSignal signal;

  @override
  Widget build(BuildContext context) {
    final isLong = signal.direction == 'long';
    final tone = isLong ? _advancedGreen : _advancedRed;
    final icon = isLong
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    final confidenceColor = signal.confidence >= 80
        ? _advancedGreen
        : _advancedPrimary;
    final rrColor = signal.riskReward >= 3 ? _advancedGreen : _advancedPrimary;

    return Container(
      constraints: const BoxConstraints(minHeight: 232),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: _advancedPanel,
        border: Border.all(color: tone.withValues(alpha: .28), width: 1.5),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(icon, color: tone, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.pair,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _SignalBadge(
                          label: signal.direction.toUpperCase(),
                          color: tone,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          signal.timeframe,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ConfidenceBox(
                  confidence: signal.confidence,
                  color: confidenceColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Risk/Reward',
                  value: '1:${signal.riskReward.toStringAsFixed(1)}',
                  valueColor: rrColor,
                  alignLeft: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PriceTarget(
                  label: 'Entry',
                  value: signal.entryPrice,
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _PriceTarget(
                  label: 'Target',
                  value: signal.targetPrice,
                  color: _advancedGreen,
                ),
              ),
              Expanded(
                child: _PriceTarget(
                  label: 'Stop Loss',
                  value: signal.stopLoss,
                  color: _advancedRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final reason in signal.reasoning.take(2)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: tone, size: 13),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reason,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 10,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (reason != signal.reasoning.take(2).last)
              const SizedBox(height: 7),
          ],
          const SizedBox(height: 13),
          Container(height: 1, color: _advancedBorder.withValues(alpha: .72)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.psychology_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'GPT-4 + TradingView v2.1',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${signal.accuracy}% accuracy',
                style: AppTextStyles.micro.copyWith(
                  color: signal.accuracy >= 70
                      ? _advancedGreen
                      : _advancedAmber,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBox extends StatelessWidget {
  const _ConfidenceBox({required this.confidence, required this.color});

  final int confidence;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _advancedPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Confidence',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 6,
                    child: Stack(
                      children: [
                        const ColoredBox(color: _advancedBorder),
                        FractionallySizedBox(
                          widthFactor: confidence / 100,
                          child: ColoredBox(color: color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '$confidence%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignLeft = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _advancedPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatBox extends StatelessWidget {
  const _MiniStatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      decoration: BoxDecoration(
        color: _advancedPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceTarget extends StatelessWidget {
  const _PriceTarget({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '\$${_formatPrice(value)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'monospace',
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SignalBadge extends StatelessWidget {
  const _SignalBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _advancedAmber.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _advancedAmber,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Prediction Disclaimer',
                  style: AppTextStyles.caption.copyWith(
                    color: _advancedAmber,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Signals are predictions, not guarantees. Always conduct your own research and risk management. Past accuracy does not guarantee future results.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.45,
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

class _RiskAnalysisTab extends StatelessWidget {
  const _RiskAnalysisTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final risk = snapshot.risk;
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.shield_outlined,
                color: _advancedAmber,
                title: 'Portfolio Risk Analyzer',
                subtitle: 'VaR, Sharpe Ratio, Max Drawdown, Beta',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _advancedPanel2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: _advancedAmber,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Score',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${risk.riskLevel} risk',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${risk.riskScore}',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: _advancedAmber,
                        fontSize: 34,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'VaR 95%',
                      value: '${risk.var95.toStringAsFixed(1)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Sharpe',
                      value: risk.sharpeRatio.toStringAsFixed(2),
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max DD',
                      value: '${risk.maxDrawdown.toStringAsFixed(1)}%',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          color: _advancedPrimary,
          icon: Icons.shield_outlined,
          title: 'Enterprise Risk Management',
          body:
              'VaR calculated using Monte Carlo simulation. Sharpe and Sortino ratios update daily with a 30-day rolling window.',
        ),
      ],
    );
  }
}

class _TradeJournalTab extends StatelessWidget {
  const _TradeJournalTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final journal = snapshot.journal;
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.menu_book_rounded,
                color: _advancedGreen,
                title: 'Trade Journal',
                subtitle: 'Detailed tracking and performance attribution',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Win Rate',
                      value: '${journal.winRate.toStringAsFixed(1)}%',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Trades',
                      value: '${journal.totalTrades}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Total PnL',
                      value: '+\$${_formatCompact(journal.totalPnl)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Win',
                      value: '+\$${journal.avgWin.toStringAsFixed(0)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Loss',
                      value: '-\$${journal.avgLoss.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          color: _advancedGreen,
          icon: Icons.menu_book_rounded,
          title: 'Performance Attribution',
          body:
              'Automatic trade tagging, setup classification, pattern recognition and export-ready analytics.',
        ),
      ],
    );
  }
}

class _PositionSizingTab extends StatelessWidget {
  const _PositionSizingTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sizing = snapshot.sizing;
    final riskAmount = sizing.accountBalance * sizing.recommendedRiskPct / 100;
    return Column(
      children: [
        _Card(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(
                icon: Icons.calculate_outlined,
                color: _advancedAmber,
                title: 'Position Sizing Calculator',
                subtitle: 'Kelly Criterion optimization',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Balance',
                      value: '\$${_formatCompact(sizing.accountBalance)}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Risk',
                      value: '${sizing.recommendedRiskPct.toStringAsFixed(0)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max Loss',
                      value: '\$${riskAmount.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _MetricBox(
                label: 'Suggested Position Size',
                value: '${sizing.positionSize.toStringAsFixed(2)} BTC',
                valueColor: _advancedPrimary,
                alignLeft: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _InfoCard(
          color: _advancedAmber,
          icon: Icons.calculate_outlined,
          title: 'Kelly Criterion Optimization',
          body:
              'Kelly percent is capped at half-Kelly for safety and adjusted by your actual win rate and R:R ratio.',
        ),
      ],
    );
  }
}

class _ModelInfoCard extends StatelessWidget {
  const _ModelInfoCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      color: _advancedPurple,
      icon: Icons.psychology_rounded,
      title: 'AI Model: GPT-4 + TradingView Integration',
      body:
          'Signals generated using technical indicators, on-chain data, sentiment analysis and volume profiling.',
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'P3 Features Included',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: features.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 38,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: _advancedPanel2,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _advancedGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        features[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.iconSize = 22,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Icon(icon, color: color, size: iconSize),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.45,
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

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _advancedPanel,
        border: Border.all(color: _advancedBorder.withValues(alpha: .7)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

String _formatPrice(double value) {
  final fractionDigits = value >= 1000 || value == value.roundToDouble()
      ? 0
      : 1;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}

String _formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
