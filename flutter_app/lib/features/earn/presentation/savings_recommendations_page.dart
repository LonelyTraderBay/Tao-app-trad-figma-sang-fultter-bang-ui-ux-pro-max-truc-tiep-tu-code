import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class SavingsRecommendationsPage extends ConsumerStatefulWidget {
  const SavingsRecommendationsPage({super.key, this.shellRenderMode});

  static const amountFieldKey = Key('sc338_amount_field');
  static const strategyListKey = Key('sc338_strategy_list');
  static const compareButtonKey = Key('sc338_compare_button');
  static const riskButtonKey = Key('sc338_risk_button');
  static const productsButtonKey = Key('sc338_products_button');
  static const detailCtaKey = Key('sc338_strategy_detail_cta');

  static Key strategyKey(String id) => Key('sc338_strategy_$id');
  static Key amountChipKey(int amount) => Key('sc338_amount_$amount');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRecommendationsPage> createState() =>
      _SavingsRecommendationsPageState();
}

class _SavingsRecommendationsPageState
    extends ConsumerState<SavingsRecommendationsPage> {
  String _amountText = '15000';

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsRecommendationsRepositoryProvider)
        .getRecommendations();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-338 SavingsRecommendationsPage',
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
                    _HeroCard(snapshot: snapshot),
                    _ProfileCard(snapshot: snapshot),
                    _AmountSimulator(
                      amountText: _amountText,
                      onAmountChanged: (value) =>
                          setState(() => _amountText = value),
                      onQuickAmount: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _amountText = '$value');
                      },
                    ),
                    _CompareButton(
                      onTap: () => _openCompareSheet(snapshot.strategies),
                    ),
                    VitPageSection(
                      label: 'Chiến lược được Đề xuất',
                      accentColor: AppColors.accent,
                      children: [
                        Column(
                          key: SavingsRecommendationsPage.strategyListKey,
                          children: [
                            for (final strategy in snapshot.strategies) ...[
                              _StrategyCard(
                                key: SavingsRecommendationsPage.strategyKey(
                                  strategy.id,
                                ),
                                strategy: strategy,
                                amount: _amount,
                                onTap: () => _openStrategySheet(
                                  strategy,
                                  snapshot.savingsRoute,
                                ),
                              ),
                              if (strategy != snapshot.strategies.last)
                                const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                        ),
                      ],
                    ),
                    VitPageSection(
                      label: 'Gợi ý Cá nhân hóa',
                      accentColor: AppColors.buy,
                      children: [
                        Column(
                          children: [
                            for (final insight in snapshot.insights) ...[
                              _InsightCard(insight: insight),
                              if (insight != snapshot.insights.last)
                                const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                        ),
                      ],
                    ),
                    _QuickLinks(snapshot: snapshot),
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStrategySheet(
    SavingsStrategyDraft strategy,
    String savingsRoute,
  ) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _StrategyDetailSheet(
                  strategy: strategy,
                  amount: _amount,
                  savingsRoute: savingsRoute,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCompareSheet(List<SavingsStrategyDraft> strategies) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _CompareSheet(strategies: strategies, amount: _amount),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent08,
        border: Border.all(color: AppColors.accent20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accent,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    snapshot.heroSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final profile = snapshot.profile;
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Hồ sơ của bạn', style: AppTextStyles.baseMedium),
              ),
              if (profile.hasCompletedAssessment)
                _SmallPill(
                  label: 'Đã đánh giá ${profile.assessmentDate}',
                  color: AppColors.buy,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Mức rủi ro',
                      value: _riskToleranceLabel(profile.riskTolerance),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Thời gian đầu tư',
                      value: _horizonLabel(profile.investmentHorizon),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Nhu cầu thanh khoản',
                      value: _liquidityLabel(profile.liquidityNeed),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Tài sản yêu thích',
                      value: profile.preferredAssets.join(', '),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            child: Text(
              profile.hasCompletedAssessment
                  ? 'Làm lại đánh giá rủi ro'
                  : 'Đánh giá rủi ro',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
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
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSimulator extends StatelessWidget {
  const _AmountSimulator({
    required this.amountText,
    required this.onAmountChanged,
    required this.onQuickAmount,
  });

  final String amountText;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    const amounts = [1000, 5000, 10000, 50000];
    final activeAmount = int.tryParse(amountText);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Mô phỏng với số tiền khác',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          TextField(
            key: SavingsRecommendationsPage.amountFieldKey,
            keyboardType: TextInputType.number,
            onChanged: onAmountChanged,
            controller: TextEditingController(text: amountText)
              ..selection = TextSelection.collapsed(offset: amountText.length),
            cursorColor: AppColors.primary,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            decoration: const InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.surface2,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.borderSolid),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadii.inputRadius,
                borderSide: BorderSide(color: AppColors.primary30),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final amount in amounts) ...[
                Expanded(
                  child: _AmountChip(
                    key: SavingsRecommendationsPage.amountChipKey(amount),
                    amount: amount,
                    selected: activeAmount == amount,
                    onTap: () => onQuickAmount(amount),
                  ),
                ),
                if (amount != amounts.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    super.key,
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final int amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : Colors.transparent,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Text(
            amount >= 1000 ? '\$${amount ~/ 1000}K' : '\$$amount',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CompareButton extends StatelessWidget {
  const _CompareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SavingsRecommendationsPage.compareButtonKey,
      variant: VitCtaButtonVariant.ghost,
      height: AppSpacing.buttonCompact,
      leading: const Icon(Icons.bar_chart_rounded),
      onPressed: onTap,
      child: const Text('So sánh tất cả chiến lược'),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    super.key,
    required this.strategy,
    required this.amount,
    required this.onTap,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: strategy.recommended ? AppColors.primary : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (strategy.recommended) ...[
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                _SmallPill(
                  label: 'Phù hợp nhất với bạn',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strategy.title, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPercent(strategy.expectedApy),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _AllocationBar(allocation: strategy.allocation),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final item in strategy.allocation)
                _AllocationChip(item: item),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _SmallPill(
                label: 'Match ${strategy.matchScore}%',
                color: strategy.matchScore >= 80
                    ? AppColors.buy
                    : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallPill(
                label: _strategyRiskLabel(strategy.riskLevel),
                color: _strategyRiskColor(strategy.riskLevel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '+${_formatUsd(amount * strategy.expectedApy / 100)}/năm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.allocation});

  final List<SavingsStrategyAllocationDraft> allocation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: Row(
        children: [
          for (final item in allocation)
            Expanded(
              flex: item.percentage,
              child: DecoratedBox(
                decoration: BoxDecoration(color: _assetColor(item.asset)),
                child: const SizedBox(height: AppSpacing.x2),
              ),
            ),
        ],
      ),
    );
  }
}

class _AllocationChip extends StatelessWidget {
  const _AllocationChip({required this.item});

  final SavingsStrategyAllocationDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          '${item.asset} ${item.percentage}%',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final SavingsRecommendationInsightDraft insight;

  @override
  Widget build(BuildContext context) {
    final color = _insightColor(insight.tone);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _insightIcon(insight.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  insight.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.snapshot});

  final SavingsRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.riskButtonKey,
            variant: VitCtaButtonVariant.warning,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            leading: const Icon(Icons.shield_outlined),
            child: const Text('Đánh giá rủi ro'),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: VitCtaButton(
            key: SavingsRecommendationsPage.productsButtonKey,
            variant: VitCtaButtonVariant.success,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.savingsRoute);
            },
            leading: const Icon(Icons.savings_outlined),
            child: const Text('Tất cả sản phẩm'),
          ),
        ),
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyDetailSheet extends StatelessWidget {
  const _StrategyDetailSheet({
    required this.strategy,
    required this.amount,
    required this.savingsRoute,
  });

  final SavingsStrategyDraft strategy;
  final double amount;
  final String savingsRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(strategy.title, style: AppTextStyles.sectionTitle),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            _SmallPill(
              label: 'Match ${strategy.matchScore}%',
              color: strategy.matchScore >= 80
                  ? AppColors.buy
                  : AppColors.primary,
            ),
            _SmallPill(
              label: 'Rủi ro ${_strategyRiskLabel(strategy.riskLevel)}',
              color: _strategyRiskColor(strategy.riskLevel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            children: [
              _SheetMetric(
                label: 'APY trung bình',
                value: _formatPercent(strategy.expectedApy),
                color: AppColors.buy,
              ),
              _SheetMetric(
                label: 'Thanh khoản tức thì',
                value: '${strategy.liquidityRatio}%',
                color: strategy.liquidityRatio >= 50
                    ? AppColors.buy
                    : AppColors.warn,
              ),
              _SheetMetric(
                label: 'Ước tính lãi/năm (${_formatUsd(amount)})',
                value: '+${_formatUsd(amount * strategy.expectedApy / 100)}',
                color: AppColors.buy,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Phân bổ chi tiết',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in strategy.allocation) ...[
          _AllocationDetailRow(item: item, amount: amount),
          if (item != strategy.allocation.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        _AllocationBar(allocation: strategy.allocation),
        const SizedBox(height: AppSpacing.x5),
        _BulletSection(
          title: 'Ưu điểm',
          items: strategy.pros,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        _BulletSection(
          title: 'Lưu ý / Nhược điểm',
          items: strategy.cons,
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x4),
        _BulletSection(
          title: 'Phù hợp với',
          items: strategy.bestFor,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: SavingsRecommendationsPage.detailCtaKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
            context.go(savingsRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Đăng ký sản phẩm theo chiến lược'),
        ),
      ],
    );
  }
}

class _CompareSheet extends StatelessWidget {
  const _CompareSheet({required this.strategies, required this.amount});

  final List<SavingsStrategyDraft> strategies;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'So sánh Chiến lược',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _CompareRow(
          label: '',
          values: [for (final strategy in strategies) strategy.title],
          header: true,
        ),
        _CompareRow(
          label: 'APY',
          values: [
            for (final strategy in strategies)
              _formatPercent(strategy.expectedApy),
          ],
          color: AppColors.buy,
        ),
        _CompareRow(
          label: 'Thanh khoản',
          values: [
            for (final strategy in strategies) '${strategy.liquidityRatio}%',
          ],
          color: AppColors.primary,
        ),
        _CompareRow(
          label: 'Match',
          values: [
            for (final strategy in strategies) '${strategy.matchScore}%',
          ],
          color: AppColors.accent,
        ),
        _CompareRow(
          label: 'Rủi ro',
          values: [
            for (final strategy in strategies)
              _strategyRiskLabel(strategy.riskLevel),
          ],
        ),
        _CompareRow(
          label: 'Lãi/năm',
          values: [
            for (final strategy in strategies)
              '+${_formatUsd(amount * strategy.expectedApy / 100)}',
          ],
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.label,
    required this.values,
    this.color,
    this.header = false,
  });

  final String label;
  final List<String> values;
  final Color? color;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                maxLines: header ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: color ?? (header ? AppColors.text1 : AppColors.text2),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
          Text(
            value,
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

class _AllocationDetailRow extends StatelessWidget {
  const _AllocationDetailRow({required this.item, required this.amount});

  final SavingsStrategyAllocationDraft item;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(item.asset);
    return Row(
      children: [
        _AssetBadge(asset: item.asset, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  Icon(
                    item.type == SavingsStrategyAllocationType.flexible
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    color: item.type == SavingsStrategyAllocationType.flexible
                        ? AppColors.buy
                        : AppColors.warn,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      item.type == SavingsStrategyAllocationType.flexible
                          ? 'Linh hoạt'
                          : 'Cố định ${item.lockDays}D',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    '${_formatPercent(item.apy)} APY',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              _formatUsd(amount * item.percentage / 100),
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: SizedBox(
                  width: AppSpacing.x1,
                  height: AppSpacing.x1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  final rounded = value.abs() >= 1000
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = rounded.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$$buffer';
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) return '${value.toStringAsFixed(0)}%';
  return '${value.toStringAsFixed(1)}%';
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}

String _riskToleranceLabel(SavingsProfileRiskTolerance value) {
  return switch (value) {
    SavingsProfileRiskTolerance.conservative => 'Thận trọng',
    SavingsProfileRiskTolerance.moderate => 'Trung bình',
    SavingsProfileRiskTolerance.aggressive => 'Tích cực',
  };
}

String _horizonLabel(SavingsInvestmentHorizon value) {
  return switch (value) {
    SavingsInvestmentHorizon.short => 'Ngắn hạn',
    SavingsInvestmentHorizon.medium => 'Trung hạn',
    SavingsInvestmentHorizon.long => 'Dài hạn',
  };
}

String _liquidityLabel(SavingsLiquidityNeed value) {
  return switch (value) {
    SavingsLiquidityNeed.high => 'Cao',
    SavingsLiquidityNeed.medium => 'Trung bình',
    SavingsLiquidityNeed.low => 'Thấp',
  };
}

String _strategyRiskLabel(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => 'Thấp',
    SavingsStrategyRiskLevel.medium => 'Trung bình',
    SavingsStrategyRiskLevel.high => 'Cao',
  };
}

Color _strategyRiskColor(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => AppColors.buy,
    SavingsStrategyRiskLevel.medium => AppColors.warn,
    SavingsStrategyRiskLevel.high => AppColors.sell,
  };
}

Color _insightColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}

IconData _insightIcon(String iconKey) {
  return switch (iconKey) {
    'target' => Icons.track_changes_rounded,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
