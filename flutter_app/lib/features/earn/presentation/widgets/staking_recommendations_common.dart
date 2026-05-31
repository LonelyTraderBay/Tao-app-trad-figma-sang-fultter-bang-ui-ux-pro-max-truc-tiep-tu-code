import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';

final class StakingRecommendationsKeys {
  const StakingRecommendationsKeys._();

  static const hero = Key('sc372_hero');
  static const profile = Key('sc372_profile');
  static const amountField = Key('sc372_amount_field');
  static const strategyList = Key('sc372_strategy_list');
  static const detailCta = Key('sc372_strategy_detail_cta');
  static const riskButton = Key('sc372_profile_update');
  static const tips = Key('sc372_tips');

  static Key strategy(String id) => Key('sc372_strategy_$id');
}

class StakingRecommendationsSmallPill extends StatelessWidget {
  const StakingRecommendationsSmallPill({
    super.key,
    required this.label,
    required this.color,
  });

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

class StakingRecommendationsRoundIcon extends StatelessWidget {
  const StakingRecommendationsRoundIcon({
    super.key,
    required this.icon,
    required this.color,
  });

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

class StakingRecommendationsAssetBadge extends StatelessWidget {
  const StakingRecommendationsAssetBadge({
    super.key,
    required this.asset,
    required this.color,
  });

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

String stakingRecommendationsFormatUsd(double value) {
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

String stakingRecommendationsFormatPercent(double value) {
  if (value == value.roundToDouble()) return '${value.toStringAsFixed(0)}%';
  return '${value.toStringAsFixed(1)}%';
}

String stakingRecommendationsProfileRiskLabel(
  StakingRecommendationProfileRisk value,
) {
  return switch (value) {
    StakingRecommendationProfileRisk.conservative => 'Thận trọng',
    StakingRecommendationProfileRisk.moderate => 'Trung bình',
    StakingRecommendationProfileRisk.aggressive => 'Tích cực',
  };
}

String stakingRecommendationsHorizonLabel(StakingRecommendationHorizon value) {
  return switch (value) {
    StakingRecommendationHorizon.short => '<3 tháng',
    StakingRecommendationHorizon.medium => '3-12 tháng',
    StakingRecommendationHorizon.long => '>12 tháng',
  };
}

String stakingRecommendationsLiquidityLabel(
  StakingRecommendationLiquidity value,
) {
  return switch (value) {
    StakingRecommendationLiquidity.high => 'Cao',
    StakingRecommendationLiquidity.medium => 'Trung bình',
    StakingRecommendationLiquidity.low => 'Thấp',
  };
}

String stakingRecommendationsRiskLabel(StakingRecommendationRiskLevel value) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => 'Rủi ro thấp',
    StakingRecommendationRiskLevel.medium => 'Rủi ro TB',
    StakingRecommendationRiskLevel.high => 'Rủi ro cao',
  };
}

String stakingRecommendationsRiskLevelLabel(
  StakingRecommendationRiskLevel value,
) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => 'Thấp',
    StakingRecommendationRiskLevel.medium => 'Trung bình',
    StakingRecommendationRiskLevel.high => 'Cao',
  };
}

Color stakingRecommendationsRiskColor(StakingRecommendationRiskLevel value) {
  return switch (value) {
    StakingRecommendationRiskLevel.low => AppColors.buy,
    StakingRecommendationRiskLevel.medium => AppColors.warn,
    StakingRecommendationRiskLevel.high => AppColors.sell,
  };
}

Color stakingRecommendationsAssetColor(String asset) {
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

Color stakingRecommendationsTipColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}

IconData stakingRecommendationsTipIcon(String iconKey) {
  return switch (iconKey) {
    'target' => Icons.track_changes_rounded,
    'zap' => Icons.bolt_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.auto_awesome_rounded,
  };
}
