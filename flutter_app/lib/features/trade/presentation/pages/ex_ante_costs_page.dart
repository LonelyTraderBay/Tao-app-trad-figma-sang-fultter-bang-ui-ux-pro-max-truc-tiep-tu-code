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

const _costBackground = AppColors.bg;
const _costPanel = AppColors.surface;
const _costPanel2 = AppColors.surface2;
const _costBorder = AppColors.borderSolid;
const _costPrimary = AppColors.primary;
const _costGreen = Color(0xFF10B981);
const _costAmber = Color(0xFFF59E0B);
const _costRed = Color(0xFFEF4444);

class ExAnteCostsPage extends ConsumerStatefulWidget {
  const ExAnteCostsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc105_ex_ante_content');
  static const riyKey = Key('sc105_ex_ante_riy');
  static const exPostKey = Key('sc105_ex_ante_ex_post');
  static const kidKey = Key('sc105_ex_ante_kid');
  static Key tabKey(String id) => Key('sc105_ex_ante_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExAnteCostsPage> createState() => _ExAnteCostsPageState();
}

class _ExAnteCostsPageState extends ConsumerState<ExAnteCostsPage> {
  String _tab = 'summary';
  int _holdingPeriod = 3;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getExAnteCosts();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-105 ExAnteCostsPage',
      child: Material(
        color: _costBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Cost Disclosure (Ex-Ante)',
              subtitle: 'Before You Invest',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              trailing: const _DownloadAction(),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ExAnteCostsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _RegulatoryNotice(),
                    const SizedBox(height: 35),
                    _InvestmentCard(snapshot: snapshot),
                    const SizedBox(height: 24),
                    _Tabs(activeId: _tab, onChanged: _setTab),
                    const SizedBox(height: 27),
                    if (_tab == 'summary')
                      _Summary(snapshot: snapshot)
                    else if (_tab == 'breakdown')
                      _Breakdown(snapshot: snapshot)
                    else
                      _Scenarios(
                        snapshot: snapshot,
                        holdingPeriod: _holdingPeriod,
                        onChanged: (period) =>
                            setState(() => _holdingPeriod = period),
                      ),
                    const SizedBox(height: 24),
                    const _QuickLinks(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}

class _DownloadAction extends StatelessWidget {
  const _DownloadAction();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _costPanel2,
        border: Border.all(color: _costBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.smRadius,
      ),
      child: const Icon(
        Icons.download_rounded,
        color: AppColors.text1,
        size: 18,
      ),
    );
  }
}

class _RegulatoryNotice extends StatelessWidget {
  const _RegulatoryNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRIIPs Cost Disclosure',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This document shows all costs you will pay before investing. '
                  'Required by EU regulation for retail clients.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
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

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _costPrimary.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: _costPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Example Investment Amount',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      _formatEur(snapshot.investmentAmount),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Estimated for illustration purposes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Costs (Year 1)',
                  value: _formatEur(snapshot.totalFirstYear),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: '% of Investment',
                  value: '${snapshot.totalPercentage.toStringAsFixed(2)}%',
                  valueColor: _costRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('summary', 'Summary'),
      ('breakdown', 'Breakdown'),
      ('scenarios', 'Scenarios'),
    ];
    return Container(
      height: 53,
      color: _costPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: ExAnteCostsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _costPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _costPrimary,
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

class _Summary extends StatelessWidget {
  const _Summary({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = [
      (
        TradeExAnteCostCategory.oneOff,
        'One-off Costs',
        'Costs paid once when entering or exiting the investment',
        _costPrimary,
        _formatEur(snapshot.oneOffCosts),
      ),
      (
        TradeExAnteCostCategory.recurring,
        'Recurring Costs',
        'Costs paid every year while you hold the investment',
        _costAmber,
        '${_formatEur(snapshot.recurringCosts)}/year',
      ),
      (
        TradeExAnteCostCategory.incidental,
        'Incidental Costs',
        'Performance fees (only paid if investment performs well)',
        _costGreen,
        _formatEur(snapshot.incidentalCosts),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Summary'),
        const SizedBox(height: 12),
        for (final item in categories) ...[
          _CategoryCard(
            color: item.$4,
            title: item.$2,
            description: item.$3,
            amount: item.$5,
          ),
          if (item != categories.last) const SizedBox(height: 14),
        ],
        const SizedBox(height: 25),
        const _SectionLabel('Impact on Returns'),
        const SizedBox(height: 12),
        _RiyCard(snapshot: snapshot),
        const SizedBox(height: 20),
        _FullWidthButton(
          key: ExAnteCostsPage.riyKey,
          icon: Icons.calculate_outlined,
          label: 'Use RIY Calculator',
          onPressed: () => context.go(AppRoutePaths.tradeCopyRiyCalculator),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.color,
    required this.title,
    required this.description,
    required this.amount,
  });

  final Color color;
  final String title;
  final String description;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              Text(
                amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontSize: 16,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiyCard extends StatelessWidget {
  const _RiyCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _costRed.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: const Icon(Icons.trending_down_rounded, color: _costRed),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reduction in Yield (RIY)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How much costs reduce your returns over '
                      '${snapshot.holdingPeriodYears} years',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${snapshot.reductionInYield.toStringAsFixed(2)}%',
                style: AppTextStyles.heroNumber.copyWith(
                  color: _costRed,
                  fontSize: 20,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _WarningBox(
            text:
                'Example: If the investment returns 8% per year, after costs '
                'you would receive approximately '
                '${(8 - snapshot.reductionInYield).toStringAsFixed(2)}% per year.',
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Detailed Cost Breakdown'),
        const SizedBox(height: 12),
        for (final cost in snapshot.costs) ...[
          _CostItemCard(cost: cost),
          if (cost != snapshot.costs.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CostItemCard extends StatelessWidget {
  const _CostItemCard({required this.cost});

  final TradeExAnteCostItem cost;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cost.type,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cost.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Amount',
                  value: _formatEur(cost.amountEur),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: '% of Investment',
                  value: '${cost.percentOfInvestment.toStringAsFixed(2)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Scenarios extends StatelessWidget {
  const _Scenarios({
    required this.snapshot,
    required this.holdingPeriod,
    required this.onChanged,
  });

  final TradeExAnteCostsSnapshot snapshot;
  final int holdingPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final total =
        snapshot.oneOffCosts +
        (snapshot.recurringCosts * holdingPeriod) +
        (snapshot.incidentalCosts * holdingPeriod);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Cost Scenarios by Holding Period'),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final period in const [1, 3, 5]) ...[
              Expanded(
                child: _PeriodButton(
                  label: '$period ${period == 1 ? 'Year' : 'Years'}',
                  selected: holdingPeriod == period,
                  onPressed: () => onChanged(period),
                ),
              ),
              if (period != 5) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Costs Over $holdingPeriod '
                '${holdingPeriod == 1 ? 'Year' : 'Years'}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: 12),
              _ScenarioRow(label: 'One-off Costs', value: snapshot.oneOffCosts),
              _ScenarioRow(
                label: 'Recurring Costs ($holdingPeriod years)',
                value: snapshot.recurringCosts * holdingPeriod,
              ),
              _ScenarioRow(
                label: 'Incidental Costs (estimated)',
                value: snapshot.incidentalCosts * holdingPeriod,
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _costRed.withValues(alpha: .13),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total',
                        style: AppTextStyles.caption.copyWith(
                          color: _costRed,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatEur(total),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _costRed,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.exPostKey,
            icon: Icons.description_outlined,
            label: 'Ex-Post Report',
            color: _costPrimary,
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyExPostCostsReport),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.kidKey,
            icon: Icons.bar_chart_rounded,
            label: 'View KID',
            color: _costGreen,
            onPressed: () => context.go(AppRoutePaths.tradeCopyKidGenerator),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          side: BorderSide(color: _costBorder.withValues(alpha: .72)),
          backgroundColor: _costPanel2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _FullWidthButton extends StatelessWidget {
  const _FullWidthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          side: BorderSide(color: _costBorder.withValues(alpha: .72)),
          backgroundColor: _costPanel2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
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
      height: 56,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _costPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: _costAmber.withValues(alpha: .13),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _costAmber, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _costAmber,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: selected ? _costPrimary : _costPanel2,
          foregroundColor: selected ? Colors.white : AppColors.text2,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(label, style: AppTextStyles.micro.copyWith(fontSize: 12)),
      ),
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  const _ScenarioRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _costPanel2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            _formatEur(value),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _costPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
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
        color: _costPanel,
        border: Border.all(color: _costBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

String _formatEur(double value) {
  final fixed = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < fixed.length; index += 1) {
    if (index > 0 && (fixed.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(fixed[index]);
  }
  return '€${buffer.toString()}';
}
