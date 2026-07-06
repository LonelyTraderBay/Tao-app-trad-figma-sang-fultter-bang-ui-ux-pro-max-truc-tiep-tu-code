import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceStrategySection extends StatelessWidget {
  const LaunchpadRebalanceStrategySection({
    super.key,
    required this.sectionKey,
    required this.strategies,
    required this.activeId,
    required this.strategyButtonKey,
    required this.onChanged,
  });

  final Key sectionKey;
  final List<LaunchpadRebalanceStrategyDraft> strategies;
  final String activeId;
  final Key Function(String id) strategyButtonKey;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: VitPageSection(
        label: 'Chien luoc',
        accentColor: AppColors.accent,
        children: [
          Row(
            children: [
              for (final strategy in strategies) ...[
                Expanded(
                  child: _StrategyCard(
                    cardKey: strategyButtonKey(strategy.id),
                    strategy: strategy,
                    active: activeId == strategy.id,
                    onTap: () => onChanged(strategy.id),
                  ),
                ),
                if (strategy != strategies.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.cardKey,
    required this.strategy,
    required this.active,
    required this.onTap,
  });

  final Key cardKey;
  final LaunchpadRebalanceStrategyDraft strategy;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: cardKey,
      variant: active ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: active
          ? strategy.accent.resolve().withValues(alpha: .38)
          : AppColors.cardBorder,
      padding: AppSpacing.launchpadPaddingX3,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox.square(
            dimension: AppSpacing.launchpadBox28,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: strategy.accent.resolve().withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                Icons.shield_outlined,
                color: strategy.accent.resolve(),
                size: AppSpacing.launchpadIconLg,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            strategy.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? strategy.accent.resolve() : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            strategy.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.chartLabelXs.copyWith(
              color: AppColors.text3,
              height: AppSpacing.launchpadLineHeightMicro,
            ),
          ),
        ],
      ),
    );
  }
}
