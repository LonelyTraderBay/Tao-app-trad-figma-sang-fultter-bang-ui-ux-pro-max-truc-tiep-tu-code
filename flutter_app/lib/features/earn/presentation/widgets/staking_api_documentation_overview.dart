import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_api_documentation_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingApiDocumentationInfoBanner extends StatelessWidget {
  const StakingApiDocumentationInfoBanner({super.key, required this.snapshot});

  final StakingApiDocumentationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingApiDocumentationKeys.info,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.code_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingApiBodyLineHeight,
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

class StakingApiDocumentationQuickStats extends StatelessWidget {
  const StakingApiDocumentationQuickStats({super.key, required this.stats});

  final List<StakingApiStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: StakingApiDocumentationKeys.stats,
      children: [
        for (final stat in stats) ...[
          Expanded(child: _StatCard(stat: stat)),
          if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StakingApiStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return VitCard(
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: SizedBox(
        height: EarnSpacingTokens.stakingApiStatTileHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_statIcon(stat.tone), color: color, size: AppSpacing.iconSm),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                stat.value,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              stat.label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class StakingApiDocumentationTabs extends StatelessWidget {
  const StakingApiDocumentationTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final StakingApiDocumentationTab active;
  final ValueChanged<StakingApiDocumentationTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: StakingApiDocumentationKeys.tabs,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in StakingApiDocumentationTab.values)
            Expanded(
              child: VitCard(
                key: StakingApiDocumentationKeys.tab(tab.name),
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                padding: EarnSpacingTokens.earnTopPaddingX4,
                onTap: () => onChanged(tab),
                child: Column(
                  children: [
                    Text(
                      stakingApiDocumentationTabLabel(tab),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: active == tab
                            ? AppColors.primarySoft
                            : AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 160),
                      tween: Tween<double>(
                        end: active == tab ? AppSpacing.buttonHero : 0,
                      ),
                      builder: (context, width, _) {
                        return SizedBox(
                          width: width,
                          height:
                              EarnSpacingTokens.stakingApiTabIndicatorHeight,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: active == tab
                                  ? AppColors.primarySoft
                                  : AppColors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadii.xsRadius,
                              ),
                            ),
                          ),
                        );
                      },
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

Color _toneColor(String tone) {
  return switch (tone) {
    'warn' => AppColors.warn,
    'buy' => AppColors.buy,
    _ => AppColors.primarySoft,
  };
}

IconData _statIcon(String tone) {
  return switch (tone) {
    'warn' => Icons.bolt_rounded,
    'buy' => Icons.shield_outlined,
    _ => Icons.key_rounded,
  };
}
