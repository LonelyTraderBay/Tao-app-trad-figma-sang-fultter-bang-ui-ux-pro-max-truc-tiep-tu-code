import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalanceSuggestionsSection extends StatelessWidget {
  const LaunchpadRebalanceSuggestionsSection({
    super.key,
    required this.sectionKey,
    required this.suggestionKey,
    required this.suggestions,
  });

  final Key sectionKey;
  final Key Function(String id) suggestionKey;
  final List<RebalanceSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: VitPageSection(
        label: 'De xuat rebalance',
        accentColor: AppColors.warn,
        children: [
          for (final suggestion in suggestions)
            _SuggestionCard(
              cardKey: suggestionKey(suggestion.asset.id),
              suggestion: suggestion,
            ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.cardKey, required this.suggestion});

  final Key cardKey;
  final RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = launchpadRebalanceActionColor(suggestion.action);
    return VitCard(
      key: cardKey,
      clip: true,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Row(
                  children: [
                    _AssetBadge(asset: suggestion.asset),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpacing.x2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                suggestion.asset.symbol,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                  fontSize: 12,
                                ),
                              ),
                              _ActionPill(
                                action: suggestion.action,
                                color: color,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            '${suggestion.currentPercent.toStringAsFixed(1)}% -> ${suggestion.targetPercent.toStringAsFixed(1)}%   ${suggestion.deviation > 0 ? '-' : '+'}${suggestion.deviation.abs().toStringAsFixed(1)}%',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (suggestion.action != LaunchpadRebalanceAction.hold)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${suggestion.suggestedValue.toStringAsFixed(0)}',
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${launchpadRebalanceAmount(suggestion.suggestedAmount)} ${suggestion.asset.symbol}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset});

  final LaunchpadRebalanceAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: asset.accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.substring(0, math.min(2, asset.symbol.length)),
        style: AppTextStyles.micro.copyWith(
          color: asset.accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.action, required this.color});

  final LaunchpadRebalanceAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(launchpadRebalanceActionIcon(action), color: color, size: 9),
            const SizedBox(width: 3),
            Text(
              launchpadRebalanceActionLabel(action),
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
