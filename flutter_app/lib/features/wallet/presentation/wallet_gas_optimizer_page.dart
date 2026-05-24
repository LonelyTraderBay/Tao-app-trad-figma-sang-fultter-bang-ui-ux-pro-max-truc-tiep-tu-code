import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _gasBackground = AppColors.bg;
const _gasPanel = AppColors.surface;
const _gasBorder = Color(0x14FFFFFF);
const _gasPrimary = AppColors.primary;
const _gasGreen = Color(0xFF10B981);
const _gasAmber = Color(0xFFF59E0B);
const _gasRed = Color(0xFFEF4444);

const _tabCurrent = 'Hien tai';
const _tabTrends = 'Xu huong';
const _tabTips = 'Meo tiet kiem';

class WalletGasOptimizerPage extends ConsumerStatefulWidget {
  const WalletGasOptimizerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc149_gas_optimizer_content');
  static const refreshKey = Key('sc149_gas_optimizer_refresh');
  static Key tabKey(String label) => Key('sc149_gas_optimizer_tab_$label');
  static Key speedKey(String speed) => Key('sc149_gas_optimizer_speed_$speed');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletGasOptimizerPage> createState() =>
      _WalletGasOptimizerPageState();
}

class _WalletGasOptimizerPageState
    extends ConsumerState<WalletGasOptimizerPage> {
  String _tab = _tabCurrent;
  String _selectedSpeed = 'standard';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletRepositoryProvider).getGasOptimizer();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-149 WalletGasOptimizerPage',
      child: Material(
        color: _gasBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Gas Optimizer',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            _GasTabs(
              activeTab: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WalletGasOptimizerPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                child: _contentForTab(snapshot),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentForTab(WalletGasOptimizerSnapshot snapshot) {
    if (_tab == _tabTrends) return _TrendsTab(snapshot: snapshot);
    if (_tab == _tabTips) return _TipsTab(snapshot: snapshot);
    return _CurrentGasTab(
      snapshot: snapshot,
      selectedSpeed: _selectedSpeed,
      onSelectSpeed: (speed) => setState(() => _selectedSpeed = speed),
    );
  }
}

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: _gasPanel,
        border: Border(bottom: BorderSide(color: _gasBorder)),
      ),
      child: Row(
        children: [
          for (final tab in const [_tabCurrent, _tabTrends, _tabTips])
            Expanded(
              child: GestureDetector(
                key: WalletGasOptimizerPage.tabKey(tab),
                onTap: () => onChanged(tab),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        tab,
                        style: AppTextStyles.caption.copyWith(
                          color: activeTab == tab
                              ? _gasPrimary
                              : const Color(0xFF566175),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        color: activeTab == tab
                            ? _gasPrimary
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrentGasTab extends StatelessWidget {
  const _CurrentGasTab({
    required this.snapshot,
    required this.selectedSpeed,
    required this.onSelectSpeed,
  });

  final WalletGasOptimizerSnapshot snapshot;
  final String selectedSpeed;
  final ValueChanged<String> onSelectSpeed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GasStatusCard(snapshot: snapshot),
        const SizedBox(height: 19),
        const _SectionLabel(label: 'Chon toc do giao dich'),
        const SizedBox(height: 11),
        for (var i = 0; i < snapshot.levels.length; i++) ...[
          _GasLevelCard(
            level: snapshot.levels[i],
            selected: selectedSpeed == snapshot.levels[i].speed,
            onTap: () => onSelectSpeed(snapshot.levels[i].speed),
          ),
          if (i != snapshot.levels.length - 1) const SizedBox(height: 11),
        ],
        const SizedBox(height: 18),
        _ComparisonCard(comparisons: snapshot.comparisons),
        const SizedBox(height: 17),
        const _RefreshButton(),
      ],
    );
  }
}

class _GasStatusCard extends StatelessWidget {
  const _GasStatusCard({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final vsAverage = snapshot.vsAveragePct;
    final isLow = vsAverage < -10;
    final isHigh = vsAverage > 10;
    final color = isLow ? _gasGreen : (isHigh ? _gasRed : _gasAmber);
    final title = isLow
        ? 'Low Gas Prices - Good Time!'
        : (isHigh ? 'High Gas Prices' : 'Normal Gas Prices');

    return Container(
      height: 76,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: color, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              text: 'Current gas ',
              children: [
                TextSpan(
                  text:
                      '${vsAverage.abs().toStringAsFixed(0)}% ${vsAverage < 0 ? 'below' : 'above'}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ' 24h average'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _gasPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF8791A6),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _GasLevelCard extends StatelessWidget {
  const _GasLevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final WalletGasLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(level.colorHex);
    return GestureDetector(
      key: WalletGasOptimizerPage.speedKey(level.speed),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 85,
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
        decoration: BoxDecoration(
          color: selected ? _gasPrimary.withValues(alpha: .045) : _gasPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: selected ? _gasPrimary : _gasBorder),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            level.label,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          if (level.recommended) ...[
                            const SizedBox(width: 8),
                            const _RecommendedBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        level.timeEstimate,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${level.gwei} Gwei',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Roboto',
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '~\$${level.usd.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                minHeight: 4,
                value: level.gwei / 50,
                color: color,
                backgroundColor: _gasBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _gasGreen.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'RECOMMENDED',
        style: AppTextStyles.micro.copyWith(
          color: _gasGreen,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.comparisons});

  final List<WalletGasComparison> comparisons;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 233,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 17),
      decoration: BoxDecoration(
        color: _gasPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Transaction Type Comparison',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (var i = 0; i < comparisons.length; i++) ...[
            _ComparisonRow(comparison: comparisons[i]),
            if (i != comparisons.length - 1) const SizedBox(height: 15),
          ],
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.comparison});

  final WalletGasComparison comparison;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comparison.type,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${_withCommas(comparison.gas.toString())} gas',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Text(
          '~\$${comparison.usd.toStringAsFixed(2)}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WalletGasOptimizerPage.refreshKey,
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 41,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _gasBackground,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(color: _gasBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh_rounded, color: AppColors.text1, size: 15),
            const SizedBox(width: 8),
            Text(
              'Refresh Prices',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: '24h Gas Price Trends',
          height: 254,
          child: CustomPaint(
            painter: _GasLineChartPainter(points: snapshot.history),
          ),
        ),
        const SizedBox(height: 14),
        _ChartCard(
          title: 'Network Activity',
          height: 194,
          child: CustomPaint(
            painter: _NetworkBarChartPainter(points: snapshot.networkActivity),
          ),
        ),
        const SizedBox(height: 14),
        const _BestTimeCard(),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.height,
    required this.child,
  });

  final String title;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _gasPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BestTimeCard extends StatelessWidget {
  const _BestTimeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gasGreen.withValues(alpha: .07),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasGreen.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.schedule_rounded, color: _gasGreen, size: 17),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best Time to Transact',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gas fees are typically lowest between 2 AM - 6 AM UTC.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _BestTimeMetric(
                  label: 'Avg Low Price',
                  value: '12 Gwei',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _BestTimeMetric(
                  label: 'Potential Saving',
                  value: '~52%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestTimeMetric extends StatelessWidget {
  const _BestTimeMetric({required this.label, required this.value});

  final String label;
  final String value;

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
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _gasGreen,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TipsTab extends StatelessWidget {
  const _TipsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(label: 'Gas Optimization Tips'),
        const SizedBox(height: 10),
        for (var i = 0; i < snapshot.tips.length; i++) ...[
          _TipCard(tip: snapshot.tips[i]),
          if (i != snapshot.tips.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        const _QuickActionsCard(),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final WalletGasTip tip;

  @override
  Widget build(BuildContext context) {
    final color = switch (tip.difficulty) {
      'easy' => _gasGreen,
      'medium' => _gasAmber,
      'advanced' => _gasRed,
      _ => AppColors.text3,
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gasPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _gasAmber.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _gasAmber,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tip.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    _SmallBadge(
                      label: tip.difficulty.toUpperCase(),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _CategoryPill(label: tip.category),
                    const Spacer(),
                    const Icon(
                      Icons.attach_money_rounded,
                      color: _gasGreen,
                      size: 13,
                    ),
                    Text(
                      tip.potentialSaving,
                      style: AppTextStyles.caption.copyWith(
                        color: _gasGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        height: 1,
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
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: const Color(0xFF9AA4B8),
          fontSize: 10,
          height: 1,
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gasPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _gasBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final label in const [
            'Set Gas Price Alert',
            'Schedule Transaction',
            'View L2 Options',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _gasBackground,
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(color: _gasBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_outlined,
                      color: AppColors.text3,
                      size: 16,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GasLineChartPainter extends CustomPainter {
  const _GasLineChartPainter({required this.points});

  final List<WalletGasHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chart = Rect.fromLTWH(10, 4, size.width - 20, size.height - 24);
    _drawGasLine(canvas, chart, points.map((p) => p.slow).toList(), _gasGreen);
    _drawGasLine(
      canvas,
      chart,
      points.map((p) => p.standard).toList(),
      _gasAmber,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.fast).toList(), _gasRed);
  }

  void _drawGasLine(Canvas canvas, Rect chart, List<int> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - ((values[i] - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GasLineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _NetworkBarChartPainter extends CustomPainter {
  const _NetworkBarChartPainter({required this.points});

  final List<WalletNetworkActivityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxTx = points.map((point) => point.txCount).reduce(math.max);
    final barWidth = size.width / (points.length * 2.2);
    final gap = barWidth * 1.2;
    final paint = Paint()..color = _gasPrimary;
    for (var i = 0; i < points.length; i++) {
      final barHeight = (points[i].txCount / maxTx) * (size.height - 10);
      final left = i * (barWidth + gap) + 12;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkBarChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _withCommas(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
