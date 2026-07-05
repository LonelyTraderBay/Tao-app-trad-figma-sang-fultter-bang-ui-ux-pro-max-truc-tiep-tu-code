import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_dashboard_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingPositionsSection extends StatelessWidget {
  const StakingPositionsSection({
    super.key,
    required this.sectionKey,
    required this.positionKey,
    required this.positions,
  });

  final Key sectionKey;
  final Key Function(String id) positionKey;
  final List<StakingPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'Vị thế Hoạt động (${positions.length})',
      accentColor: AppColors.primary,
      children: [
        for (final position in positions)
          _PositionCard(cardKey: positionKey(position.id), position: position),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.cardKey, required this.position});

  final Key cardKey;
  final StakingPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final accent = stakingAssetColor(position.colorIndex);

    return VitCard(
      key: cardKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            position.product,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (position.daysUntilMaturity != null)
                          _MaturityPill(days: position.daysUntilMaturity!),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          stakingTypeIcon(position.type),
                          color: stakingTypeColor(position.type),
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          stakingTypeLabel(position.type),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
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
                    '${position.apy.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppModuleAccents.earn,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY ước tính',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _PositionMetric(
                  label: 'Đang stake',
                  value:
                      '${stakingFormatAmount(position.amount)} ${position.asset}',
                  detail: stakingFormatUsd(position.usdValue),
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _PositionMetric(
                  label: 'Đã nhận',
                  value:
                      '+${stakingFormatAmount(position.earned)} ${position.asset}',
                  detail: '+${stakingFormatUsd(position.earnedUsd)}',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
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
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
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

class _MaturityPill extends StatelessWidget {
  const _MaturityPill({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn10,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          '$days ngày nữa',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String detail;
  final Color valueColor;

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
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            detail,
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
