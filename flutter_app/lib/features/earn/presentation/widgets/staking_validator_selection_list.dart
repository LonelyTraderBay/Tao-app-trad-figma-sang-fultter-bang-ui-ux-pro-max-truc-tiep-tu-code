import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingValidatorSelectionValidatorList extends StatelessWidget {
  const StakingValidatorSelectionValidatorList({
    super.key,
    required this.validators,
    required this.onTap,
  });

  final List<StakingValidatorDraft> validators;
  final ValueChanged<StakingValidatorDraft> onTap;

  @override
  Widget build(BuildContext context) {
    if (validators.isEmpty) {
      return const VitEmptyState(
        icon: Icons.shield_outlined,
        title: 'Không tìm thấy validator',
        message: 'Điều chỉnh bộ lọc hoặc từ khóa để xem validator phù hợp.',
      );
    }

    return Column(
      children: [
        for (var i = 0; i < validators.length; i++) ...[
          _ValidatorCard(
            key: StakingValidatorSelectionKeys.validator(validators[i].id),
            validator: validators[i],
            onTap: () => onTap(validators[i]),
          ),
          if (i != validators.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ValidatorCard extends StatelessWidget {
  const _ValidatorCard({
    super.key,
    required this.validator,
    required this.onTap,
  });

  final StakingValidatorDraft validator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = stakingValidatorAccent(validator);

    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ValidatorAvatar(validator: validator, accent: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            validator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (validator.verified) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.buy,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        _TierPill(tier: validator.tier),
                        if (validator.slashingHistory == 0)
                          const _StatusPill(
                            label: 'No Slashing',
                            color: AppColors.buy,
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
                    '${validator.apy.toStringAsFixed(2)}%',
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
          Row(
            children: [
              Expanded(
                child: _ValidatorMetric(
                  label: 'Commission',
                  value: '${validator.commission.toStringAsFixed(0)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Uptime',
                  value: '${validator.uptime.toStringAsFixed(2)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Delegators',
                  value: '${(validator.delegators / 1000).round()}k',
                ),
              ),
            ],
          ),
          if (validator.slashingHistory > 0) ...[
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.sell10,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
              ),
              child: Padding(
                padding: AppSpacing.earnPaddingX2,
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.sell,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        '${validator.slashingHistory} slashing event(s) in history',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ValidatorAvatar extends StatelessWidget {
  const _ValidatorAvatar({required this.validator, required this.accent});

  final StakingValidatorDraft validator;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: accent.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: SizedBox(
        width: AppSpacing.buttonStandard,
        height: AppSpacing.buttonStandard,
        child: Center(
          child: validator.id == 'v7'
              ? Text(
                  'US',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                )
              : Icon(
                  stakingValidatorIcon(validator),
                  color: accent,
                  size: AppSpacing.stakingValidatorSelectionIcon,
                ),
        ),
      ),
    );
  }
}

class _ValidatorMetric extends StatelessWidget {
  const _ValidatorMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.earnCardPaddingX3,
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
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierPill extends StatelessWidget {
  const _TierPill({required this.tier});

  final StakingValidatorTier tier;

  @override
  Widget build(BuildContext context) {
    final color = stakingValidatorTierColor(tier);
    return _StatusPill(label: stakingValidatorTierLabel(tier), color: color);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.stakingValidatorSelectionPillLineHeight,
          ),
        ),
      ),
    );
  }
}
