import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_insurance_fund_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingInsuranceFundAssetBreakdownCard extends StatelessWidget {
  const StakingInsuranceFundAssetBreakdownCard({
    super.key,
    required this.assets,
  });

  final List<StakingInsuranceFundAssetDraft> assets;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Column(
        children: [
          SizedBox.square(
            dimension: 200,
            child: CustomPaint(
              painter: StakingInsuranceFundPiePainter(assets: assets),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final asset in assets) ...[
            StakingInsuranceFundAssetRow(asset: asset),
            if (asset != assets.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class StakingInsuranceFundAssetRow extends StatelessWidget {
  const StakingInsuranceFundAssetRow({super.key, required this.asset});

  final StakingInsuranceFundAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    final color = stakingInsuranceFundAssetColor(asset.colorKey);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.x3,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color,
                shape: const CircleBorder(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              asset.asset,
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stakingInsuranceFundFormatUsd(asset.value),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${asset.percentage}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
