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

class StakingAnalyticsPage extends ConsumerStatefulWidget {
  const StakingAnalyticsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc359_summary_card');
  static const calculateButtonKey = Key('sc359_calculate_button');
  static const exportButtonKey = Key('sc359_export_button');
  static const tabBarKey = Key('sc359_tab_bar');
  static const earningsChartKey = Key('sc359_earnings_chart');
  static const assetGridKey = Key('sc359_asset_grid');
  static const calculatorKey = Key('sc359_calculator');
  static const apyChartKey = Key('sc359_apy_chart');
  static const roiChartKey = Key('sc359_roi_chart');
  static const productListKey = Key('sc359_product_list');

  static Key assetKey(String asset) => Key('sc359_asset_$asset');
  static Key productKey(String asset) => Key('sc359_product_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAnalyticsPage> createState() =>
      _StakingAnalyticsPageState();
}

class _StakingAnalyticsPageState extends ConsumerState<StakingAnalyticsPage> {
  String? _tab;
  bool _showCalculator = false;
  bool _compound = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAnalyticsRepositoryProvider)
        .getAnalytics();
    final activeTab = _tab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-359 StakingAnalyticsPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryCard(
                      snapshot: snapshot,
                      showCalculator: _showCalculator,
                      onCalculate: _toggleCalculator,
                      onExport: _exportReport,
                    ),
                    if (_showCalculator)
                      _CalculatorCard(
                        key: StakingAnalyticsPage.calculatorKey,
                        compound: _compound,
                        onToggleCompound: () {
                          HapticFeedback.selectionClick();
                          setState(() => _compound = !_compound);
                        },
                      ),
                    _AnalyticsTabs(
                      key: StakingAnalyticsPage.tabBarKey,
                      tabs: snapshot.tabs,
                      activeTab: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'earnings')
                      _EarningsTab(snapshot: snapshot)
                    else if (activeTab == 'apy')
                      _ApyTab(snapshot: snapshot)
                    else if (activeTab == 'roi')
                      _RoiTab(snapshot: snapshot)
                    else
                      _ProductsTab(snapshot: snapshot),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalculator() {
    HapticFeedback.selectionClick();
    setState(() => _showCalculator = !_showCalculator);
  }

  void _exportReport() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xuất báo cáo CSV/PDF sẽ sớm ra mắt')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.showCalculator,
    required this.onCalculate,
    required this.onExport,
  });

  final StakingAnalyticsSnapshot snapshot;
  final bool showCalculator;
  final VoidCallback onCalculate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.attach_money_rounded,
                  label: 'Tổng thu nhập',
                  value: '+${_formatUsd(snapshot.summary.totalEarned)}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.percent_rounded,
                  label: 'APY TB',
                  value: '${snapshot.summary.averageApy.toStringAsFixed(1)}%',
                  color: AppColors.primarySoft,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Tốt nhất',
                  value: '${snapshot.summary.bestRoi.toStringAsFixed(1)}%',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.calculateButtonKey,
                  height: 40,
                  onPressed: onCalculate,
                  leading: Icon(
                    showCalculator
                        ? Icons.expand_less_rounded
                        : Icons.bar_chart_rounded,
                  ),
                  child: const Text('Tính lợi nhuận'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingAnalyticsPage.exportButtonKey,
                  height: 40,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: onExport,
                  leading: const Icon(Icons.file_download_outlined),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({
    super.key,
    required this.compound,
    required this.onToggleCompound,
  });

  final bool compound;
  final VoidCallback onToggleCompound;

  @override
  Widget build(BuildContext context) {
    final principal = 1000.0;
    final apy = 7.5;
    final days = 90.0;
    final earned = compound
        ? principal * math.pow(1 + (apy / 100) / 365, days) - principal
        : principal * (apy / 100) * (days / 365);
    final finalValue = principal + earned;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Mẫu tính lợi nhuận',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Switch.adaptive(
                value: compound,
                onChanged: (_) => onToggleCompound(),
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _CalculatorMetric(
                  label: 'Gốc',
                  value: _formatUsd(principal),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(label: 'APY', value: '$apy%'),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _CalculatorMetric(
                  label: compound ? 'Lãi kép' : 'Lãi đơn',
                  value: '+${_formatUsd(earned)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tổng nhận về ${_formatUsd(finalValue)} sau 90 ngày. Đây là mô phỏng để kiểm UI, không phải cam kết lợi nhuận.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorMetric extends StatelessWidget {
  const _CalculatorMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsTabs extends StatelessWidget {
  const _AnalyticsTabs({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingAnalyticsTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: activeTab,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}

class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitPageSection(
          label: 'Phân tích Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          children: [_EarningsChartCard(points: snapshot.earningsBreakdown)],
        ),
        VitPageSection(
          label: 'Thu nhập theo Tài sản',
          accentColor: AppColors.primary,
          children: [_AssetEarningsGrid(products: snapshot.productPerformance)],
        ),
      ],
    );
  }
}

class _EarningsChartCard extends StatelessWidget {
  const _EarningsChartCard({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAnalyticsPage.earningsChartKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x5,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 214,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _YAxisLabels(
                  labels: ['\$320', '\$240', '\$160', '\$80', '\$0'],
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _StackedAreaPainter(points: points),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      _DateLabels(dates: points.map((p) => p.date).toList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const _LegendRow(
            entries: [
              _LegendEntry(label: 'BTC', color: _AssetPalette.btc),
              _LegendEntry(label: 'USDT', color: _AssetPalette.usdt),
              _LegendEntry(label: 'ETH', color: _AssetPalette.eth),
              _LegendEntry(label: 'SOL', color: _AssetPalette.sol),
              _LegendEntry(label: 'LP', color: _AssetPalette.lp),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetEarningsGrid extends StatelessWidget {
  const _AssetEarningsGrid({required this.products});

  final List<StakingProductPerformanceDraft> products;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: StakingAnalyticsPage.assetGridKey,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: 2.55,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          final color = _assetColor(product.colorIndex);
          return VitCard(
            key: StakingAnalyticsPage.assetKey(product.asset),
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SizedBox(width: 8, height: 8),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        product.asset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '+${_formatUsd(product.earnedUsd)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ApyTab extends StatelessWidget {
  const _ApyTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xu hướng APY (6 tháng)',
      accentColor: AppColors.primary,
      children: [
        VitCard(
          key: StakingAnalyticsPage.apyChartKey,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 220,
                child: Row(
                  children: [
                    const _YAxisLabels(
                      labels: ['25%', '20%', '15%', '10%', '5%'],
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomPaint(
                              painter: _ApyTrendPainter(
                                points: snapshot.apyTrends,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          _DateLabels(
                            dates: snapshot.apyTrends
                                .map((p) => p.date)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Linh hoạt', color: AppColors.buy),
                  _LegendEntry(label: 'Cố định', color: AppColors.primarySoft),
                  _LegendEntry(label: 'DeFi', color: AppColors.warn),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              const _InsightBox(
                text:
                    'APY DeFi biến động cao do thanh khoản pool thay đổi. APY Fixed và Flexible ổn định hơn trong cùng kỳ.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoiTab extends StatelessWidget {
  const _RoiTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'ROI: Staking vs Holding',
      accentColor: AppColors.primary,
      children: [
        VitCard(
          key: StakingAnalyticsPage.roiChartKey,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: CustomPaint(
                  painter: _RoiBarPainter(points: snapshot.roiComparison),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Staking', color: AppColors.buy),
                  _LegendEntry(label: 'Holding', color: AppColors.sell),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              const _InsightBox(
                text:
                    'Staking cho ROI cao hơn holding sau 6 tháng nhờ phần thưởng hằng ngày, nhưng lợi nhuận vẫn phụ thuộc biến động tài sản.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final best = snapshot.productPerformance
        .map((product) => product.roi)
        .reduce(math.max);

    return VitPageSection(
      label: 'Hiệu suất theo Sản phẩm',
      accentColor: AppColors.primary,
      children: [
        KeyedSubtree(
          key: StakingAnalyticsPage.productListKey,
          child: Column(
            children: [
              for (final product in snapshot.productPerformance) ...[
                _ProductPerformanceCard(product: product, maxRoi: best),
                if (product != snapshot.productPerformance.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductPerformanceCard extends StatelessWidget {
  const _ProductPerformanceCard({required this.product, required this.maxRoi});

  final StakingProductPerformanceDraft product;
  final double maxRoi;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(product.colorIndex);
    final progress = maxRoi == 0 ? 0.0 : (product.roi / maxRoi).clamp(0.0, 1.0);

    return VitCard(
      key: StakingAnalyticsPage.productKey(product.asset),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _AssetAvatar(asset: product.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'APY: ${product.apy.toStringAsFixed(1)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${product.roi.toStringAsFixed(2)}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.buy,
                      fontSize: 19,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'ROI',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SmallStat(
                  label: 'Đầu tư',
                  value: _formatUsd(product.investedUsd),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SmallStat(
                  label: 'Thu nhập',
                  value: '+${_formatUsd(product.earnedUsd)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progress,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.45)),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primary,
              size: 17,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final label in labels)
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _DateLabels extends StatelessWidget {
  const _DateLabels({required this.dates});

  final List<String> dates;

  @override
  Widget build(BuildContext context) {
    final indexes = <int>{0, 1, 2, 3, dates.length - 1}.toList()..sort();

    return Row(
      children: [
        for (final index in indexes)
          Expanded(
            child: Text(
              dates[index],
              textAlign: index == 0
                  ? TextAlign.left
                  : index == dates.length - 1
                  ? TextAlign.right
                  : TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.entries});

  final List<_LegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x2,
      children: [
        for (final entry in entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: entry.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const SizedBox(width: 10, height: 3),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                entry.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LegendEntry {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;
}

class _StackedAreaPainter extends CustomPainter {
  const _StackedAreaPainter({required this.points});

  final List<StakingEarningsPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.length < 2) return;

    const series = [
      _SeriesSpec(color: _AssetPalette.btc, selector: _SeriesValue.btc),
      _SeriesSpec(color: _AssetPalette.usdt, selector: _SeriesValue.usdt),
      _SeriesSpec(color: _AssetPalette.eth, selector: _SeriesValue.eth),
      _SeriesSpec(color: _AssetPalette.sol, selector: _SeriesValue.sol),
      _SeriesSpec(color: _AssetPalette.lp, selector: _SeriesValue.lp),
    ];
    final maxValue = math.max(
      320.0,
      points.map((p) => p.total).reduce(math.max),
    );
    var previous = List<double>.filled(points.length, 0);

    for (final spec in series) {
      final next = <double>[
        for (var i = 0; i < points.length; i++)
          previous[i] + spec.value(points[i]),
      ];
      final topPath = _linePath(size, next, maxValue);
      final areaPath = Path.from(topPath);
      for (var i = points.length - 1; i >= 0; i--) {
        areaPath.lineTo(
          _x(size, i, points.length),
          _y(size, previous[i], maxValue),
        );
      }
      areaPath.close();

      canvas.drawPath(
        areaPath,
        Paint()
          ..color = spec.color.withValues(alpha: 0.62)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        topPath,
        Paint()
          ..color = spec.color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      previous = next;
    }
  }

  @override
  bool shouldRepaint(covariant _StackedAreaPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _ApyTrendPainter extends CustomPainter {
  const _ApyTrendPainter({required this.points});

  final List<StakingApyTrendPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.flexible).toList(),
      maxValue: 25,
      color: AppColors.buy,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.fixed).toList(),
      maxValue: 25,
      color: AppColors.primarySoft,
    );
    _drawLine(
      canvas,
      size,
      values: points.map((p) => p.defi).toList(),
      maxValue: 25,
      color: AppColors.warn,
    );
  }

  @override
  bool shouldRepaint(covariant _ApyTrendPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RoiBarPainter extends CustomPainter {
  const _RoiBarPainter({required this.points});

  final List<StakingRoiComparisonPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size, 4);
    if (points.isEmpty) return;

    final baselineY = _y(size, 0, 16, minValue: -4);
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      Paint()
        ..color = AppColors.borderSolid
        ..strokeWidth = 1,
    );

    final groupWidth = size.width / points.length;
    final barWidth = math.min(15.0, groupWidth * 0.25);
    for (var i = 0; i < points.length; i++) {
      final center = groupWidth * i + groupWidth / 2;
      _paintBar(
        canvas,
        size,
        x: center - barWidth - 2,
        width: barWidth,
        value: points[i].staking,
        color: AppColors.buy,
      );
      _paintBar(
        canvas,
        size,
        x: center + 2,
        width: barWidth,
        value: points[i].holding,
        color: AppColors.sell,
      );
    }
  }

  void _paintBar(
    Canvas canvas,
    Size size, {
    required double x,
    required double width,
    required double value,
    required Color color,
  }) {
    final baselineY = _y(size, 0, 16, minValue: -4);
    final valueY = _y(size, value, 16, minValue: -4);
    final top = math.min(baselineY, valueY);
    final height = (baselineY - valueY).abs().clamp(3.0, size.height);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, top, width, height),
      const Radius.circular(5),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RoiBarPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SeriesSpec {
  const _SeriesSpec({required this.color, required this.selector});

  final Color color;
  final _SeriesValue selector;

  double value(StakingEarningsPointDraft point) {
    return switch (selector) {
      _SeriesValue.btc => point.btc,
      _SeriesValue.usdt => point.usdt,
      _SeriesValue.eth => point.eth,
      _SeriesValue.sol => point.sol,
      _SeriesValue.lp => point.lp,
    };
  }
}

enum _SeriesValue { btc, usdt, eth, sol, lp }

final class _AssetPalette {
  const _AssetPalette._();

  static const Color btc = Color(0xFFE58A00);
  static const Color usdt = AppColors.buy;
  static const Color eth = AppColors.accent;
  static const Color sol = AppColors.primarySoft;
  static const Color lp = AppColors.sell;
}

void _paintGrid(Canvas canvas, Size size, int lines) {
  final paint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (var i = 0; i <= lines; i++) {
    final y = size.height * i / lines;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
}

void _drawLine(
  Canvas canvas,
  Size size, {
  required List<double> values,
  required double maxValue,
  required Color color,
}) {
  if (values.length < 2) return;
  final path = _linePath(size, values, maxValue);
  final paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  canvas.drawPath(path, paint);
  final dotPaint = Paint()..color = color;
  for (var i = 0; i < values.length; i++) {
    canvas.drawCircle(
      Offset(_x(size, i, values.length), _y(size, values[i], maxValue)),
      3,
      dotPaint,
    );
  }
}

Path _linePath(Size size, List<double> values, double maxValue) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final point = Offset(
      _x(size, i, values.length),
      _y(size, values[i], maxValue),
    );
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path;
}

double _x(Size size, int index, int length) {
  if (length <= 1) return 0;
  return size.width * index / (length - 1);
}

double _y(Size size, double value, double maxValue, {double minValue = 0}) {
  final safeRange = math.max(1, maxValue - minValue);
  final normalized = ((value - minValue) / safeRange).clamp(0.0, 1.0);
  return size.height - normalized * size.height;
}

Color _assetColor(int index) {
  return switch (index) {
    0 => _AssetPalette.btc,
    1 => _AssetPalette.usdt,
    2 => _AssetPalette.eth,
    3 => _AssetPalette.sol,
    _ => _AssetPalette.lp,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return '\$${buffer.toString()}.${parts.last}';
}
