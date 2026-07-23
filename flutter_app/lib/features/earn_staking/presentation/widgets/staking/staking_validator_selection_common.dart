import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

enum StakingValidatorSort { apy, uptime, commission, staked }

final class StakingValidatorSelectionKeys {
  const StakingValidatorSelectionKeys._();

  static const info = Key('sc362_info_banner');
  static const summary = Key('sc362_summary_card');
  static const search = Key('sc362_search_field');
  static const filterButton = Key('sc362_filter_button');
  static const filterPanel = Key('sc362_filter_panel');
  static const resultCount = Key('sc362_result_count');
  static const detail = Key('sc362_detail_card');
  static const footer = Key('sc362_footer_note');

  static Key validator(String id) => Key('sc362_validator_$id');
}

String stakingValidatorSortLabel(StakingValidatorSort sort) {
  return switch (sort) {
    StakingValidatorSort.apy => 'APY cao nhất',
    StakingValidatorSort.uptime => 'Uptime cao nhất',
    StakingValidatorSort.commission => 'Phí thấp nhất',
    StakingValidatorSort.staked => 'Stake nhiều nhất',
  };
}

String stakingValidatorSortShortLabel(StakingValidatorSort sort) {
  return switch (sort) {
    StakingValidatorSort.apy => 'APY cao',
    StakingValidatorSort.uptime => 'Uptime cao',
    StakingValidatorSort.commission => 'Phí thấp',
    StakingValidatorSort.staked => 'Stake nhiều',
  };
}

String stakingValidatorTierLabel(StakingValidatorTier tier) {
  return switch (tier) {
    StakingValidatorTier.top => 'Top Tier',
    StakingValidatorTier.recommended => 'Recommended',
    StakingValidatorTier.standard => 'Standard',
  };
}

Color stakingValidatorTierColor(StakingValidatorTier tier) {
  return switch (tier) {
    StakingValidatorTier.top => AppColors.buy,
    StakingValidatorTier.recommended => AppColors.primarySoft,
    StakingValidatorTier.standard => AppColors.text3,
  };
}

Color stakingValidatorAccent(StakingValidatorDraft validator) {
  return switch (validator.id) {
    'v1' => AppColors.primarySoft,
    'v2' => AppColors.accent,
    'v3' => AppColors.primary,
    'v4' => AppColors.accent,
    'v5' => AppColors.text2,
    'v6' => AppColors.warn,
    _ => AppColors.text2,
  };
}

IconData stakingValidatorIcon(StakingValidatorDraft validator) {
  return switch (validator.id) {
    'v1' => Icons.diamond_rounded,
    'v2' => Icons.security_rounded,
    'v3' => Icons.bolt_rounded,
    'v4' => Icons.music_note_rounded,
    'v5' => Icons.link_rounded,
    'v6' => Icons.wb_sunny_rounded,
    _ => Icons.shield_outlined,
  };
}

class StakingValidatorSelectionStatusPill extends StatelessWidget {
  const StakingValidatorSelectionStatusPill({
    super.key,
    required this.label,
    required this.color,
  });

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
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: EarnSpacingTokens.stakingValidatorSelectionPillLineHeight,
          ),
        ),
      ),
    );
  }
}
