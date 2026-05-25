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

class StakingRecommendationsPage extends ConsumerStatefulWidget {
  const StakingRecommendationsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc372_hero');
  static const profileKey = Key('sc372_profile');
  static const amountFieldKey = Key('sc372_amount_field');
  static const strategyListKey = Key('sc372_strategy_list');
  static const detailCtaKey = Key('sc372_strategy_detail_cta');
  static const riskButtonKey = Key('sc372_profile_update');
  static const tipsKey = Key('sc372_tips');

  static Key strategyKey(String id) => Key('sc372_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRecommendationsPage> createState() =>
      _StakingRecommendationsPageState();
}

class _StakingRecommendationsPageState
    extends ConsumerState<StakingRecommendationsPage> {
  String _amountText = '10000';

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRecommendationsRepositoryProvider)
        .getRecommendations();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-372 StakingRecommendationsPage',
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
                    ),
                    VitPageSection(
                      label: 'Chiến lược được Đề xuất',
                      accentColor: AppColors.primarySoft,
                      children: [
                        Column(
                          key: StakingRecommendationsPage.strategyListKey,
                          children: [
                            for (final strategy in snapshot.strategies) ...[
                              _StrategyCard(
                                key: StakingRecommendationsPage.strategyKey(
                                  strategy.id,
                                ),
                                strategy: strategy,
                                amount: _amount,
                                onTap: () => _openStrategySheet(
                                  strategy,
                                  snapshot.stakingRoute,
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
                      key: StakingRecommendationsPage.tipsKey,
                      label: 'Tips Cá nhân hóa',
                      accentColor: AppColors.primarySoft,
                      children: [
                        Column(
                          children: [
                            for (final tip in snapshot.tips) ...[
                              _TipCard(tip: tip),
                              if (tip != snapshot.tips.last)
                                const SizedBox(height: AppSpacing.x3),
                            ],
                          ],
                        ),
                      ],
                    ),
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
    StakingStrategyDraft strategy,
    String stakingRoute,
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
                  stakingRoute: stakingRoute,
                ),
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

  final StakingRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRecommendationsPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
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
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.snapshot});

  final StakingRecommendationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final profile = snapshot.profile;
    return VitCard(
      key: StakingRecommendationsPage.profileKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Profile của bạn', style: AppTextStyles.baseMedium),
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
                      label: 'Risk Tolerance',
                      value: _profileRiskLabel(profile.riskTolerance),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Investment Horizon',
                      value: _horizonLabel(profile.investmentHorizon),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Liquidity Needs',
                      value: _liquidityLabel(profile.liquidityNeed),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ProfileMetric(
                      label: 'Portfolio Size',
                      value: _formatUsd(profile.totalPortfolio),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            key: StakingRecommendationsPage.riskButtonKey,
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.riskAssessmentRoute);
            },
            child: const Text('Cập nhật Profile'),
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
  });

  final String amountText;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mô phỏng với số lượng khác',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          TextField(
            key: StakingRecommendationsPage.amountFieldKey,
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
        ],
      ),
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

  final StakingStrategyDraft strategy;
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
                _SmallPill(label: 'Được đề xuất', color: AppColors.primary),
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
                      strategy.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.45,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - (AppSpacing.x2 * 2)) / 3;
              return Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final item in strategy.allocation.take(3))
                    SizedBox(
                      width: itemWidth,
                      child: _AllocationTile(item: item),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _SmallPill(
                label: _riskLabel(strategy.riskLevel),
                color: _riskColor(strategy.riskLevel),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '~${_formatUsd(amount * strategy.expectedApy / 100)}/năm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
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

class _AllocationTile extends StatelessWidget {
  const _AllocationTile({required this.item});

  final StakingRecommendationAllocationDraft item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.asset,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '${item.percentage}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final StakingPersonalizedTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _tipColor(tip.tone);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _tipIcon(tip.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
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
    required this.stakingRoute,
  });

  final StakingStrategyDraft strategy;
  final double amount;
  final String stakingRoute;

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
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              _SheetMetric(
                label: 'Expected APY',
                value: _formatPercent(strategy.expectedApy),
                color: AppColors.buy,
              ),
              _SheetMetric(
                label: 'Risk Level',
                value: _riskLevelLabel(strategy.riskLevel),
                color: _riskColor(strategy.riskLevel),
              ),
              _SheetMetric(
                label: 'Với ${_formatUsd(amount)}',
                value:
                    '~${_formatUsd(amount * strategy.expectedApy / 100)}/năm',
                color: AppColors.buy,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
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
        const SizedBox(height: AppSpacing.x5),
        _BulletSection(
          title: 'Ưu điểm',
          items: strategy.pros,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x4),
        _BulletSection(
          title: 'Nhược điểm',
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
          key: StakingRecommendationsPage.detailCtaKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
            context.go(stakingRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Áp dụng chiến lược này'),
        ),
      ],
    );
  }
}

class _AllocationDetailRow extends StatelessWidget {
  const _AllocationDetailRow({required this.item, required this.amount});

  final StakingRecommendationAllocationDraft item;
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
              Text(
                'APY: ${_formatPercent(item.apy)}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

String _profileRiskLabel(StakingRecommendationProfileRisk value) {
  return switch (value) {
    StakingRecommendationProfileRisk.conservative => 'Thận trọng',
    StakingRecommendationProfileRisk.moderate => 'Trung bình',
    StakingRecommendationProfileRisk.aggressive => 'Tích cực',
  };
}

String _horizonLabel(StakingRecommendationHorizon value) {
  return switch (value) {
    StakingRecommendationHorizon.short => '<3 tháng',
    StakingRecommendationHorizon.medium => '3-12 tháng',
    StakingRecommendationHorizon.long => '>12 tháng',
  };
}

String _liquidityLabel(StakingRecommendationLiquidity value) {
  return switch (value) {
    StakingRecommendationLiquidity.high => 'Cao',
    StakingRecommendationLiquidity.medium => 'Trung bình',
    StakingRecommendationLiquidity.low => 'Thấp',
  };
}

String _riskLabel(StakingRecommendationRiskLevel value) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => 'Rủi ro thấp',
    StakingRecommendationRiskLevel.medium => 'Rủi ro TB',
    StakingRecommendationRiskLevel.high => 'Rủi ro cao',
  };
}

String _riskLevelLabel(StakingRecommendationRiskLevel value) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => 'Thấp',
    StakingRecommendationRiskLevel.medium => 'Trung bình',
    StakingRecommendationRiskLevel.high => 'Cao',
  };
}

Color _riskColor(StakingRecommendationRiskLevel value) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => AppColors.buy,
    StakingRecommendationRiskLevel.medium => AppColors.warn,
    StakingRecommendationRiskLevel.high => AppColors.sell,
  };
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    'SOL' => AppColors.accent,
    'stETH' => AppColors.primarySoft,
    'rETH' => AppColors.accent,
    _ => AppColors.text2,
  };
}

Color _tipColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}

IconData _tipIcon(String iconKey) {
  return switch (iconKey) {
    'target' => Icons.track_changes_rounded,
    'zap' => Icons.bolt_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.auto_awesome_rounded,
  };
}
