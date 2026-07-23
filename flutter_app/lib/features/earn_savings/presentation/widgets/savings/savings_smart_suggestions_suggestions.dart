import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsSmartSuggestionList extends StatelessWidget {
  const SavingsSmartSuggestionList({
    super.key,
    required this.suggestions,
    required this.helpful,
    required this.onHelpful,
    required this.onDismiss,
  });

  final List<SavingsSuggestionDraft> suggestions;
  final Set<String> helpful;
  final ValueChanged<String> onHelpful;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsSmartSuggestionsKeys.suggestionsList,
      children: [
        for (final suggestion in suggestions) ...[
          SavingsSmartSuggestionCard(
            suggestion: suggestion,
            helpful: helpful.contains(suggestion.id),
            onHelpful: () => onHelpful(suggestion.id),
            onDismiss: () => onDismiss(suggestion.id),
          ),
          if (suggestion != suggestions.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}

class SavingsSmartSuggestionCard extends StatelessWidget {
  const SavingsSmartSuggestionCard({
    super.key,
    required this.suggestion,
    required this.helpful,
    required this.onHelpful,
    required this.onDismiss,
  });

  final SavingsSuggestionDraft suggestion;
  final bool helpful;
  final VoidCallback onHelpful;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final typeColor = savingsSmartTypeColor(suggestion.type);
    final priorityColor = savingsSmartPriorityColor(suggestion.priority);
    final confidenceColor = savingsSmartConfidenceColor(suggestion.confidence);

    return VitCard(
      key: SavingsSmartSuggestionsKeys.suggestion(suggestion.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SavingsSmartSuggestionIcon(
                type: suggestion.type,
                color: typeColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SavingsSmartMetaPill(
                          label: suggestion.typeLabel,
                          color: typeColor,
                        ),
                        SavingsSmartMetaPill(
                          label: suggestion.priorityLabel,
                          color: priorityColor,
                        ),
                        if (suggestion.status ==
                            SavingsSuggestionStatus.newItem)
                          const SavingsSmartNewDot(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      suggestion.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: savingsSmartCaptionBold.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Icon(
                suggestion.impactPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: suggestion.impactPositive
                    ? AppColors.buy
                    : AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  suggestion.impact,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: savingsSmartCaptionBold.copyWith(
                    color: suggestion.impactPositive
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SavingsSmartConfidenceBar(
            value: suggestion.confidence,
            color: confidenceColor,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            color: AppColors.divider,
            height: EarnSpacingTokens.savingsConsumerDividerHeight,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  suggestion.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (suggestion.actionRoute != null)
                SavingsSmartSmallActionButton(
                  key: SavingsSmartSuggestionsKeys.action(suggestion.id),
                  icon: Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  onTap: () => context.go(suggestion.actionRoute!),
                ),
              const SizedBox(width: AppSpacing.x2),
              SavingsSmartSmallActionButton(
                key: SavingsSmartSuggestionsKeys.dismiss(suggestion.id),
                icon: Icons.thumb_down_alt_outlined,
                color: AppColors.sell,
                onTap: onDismiss,
              ),
              const SizedBox(width: AppSpacing.x2),
              SavingsSmartSmallActionButton(
                key: SavingsSmartSuggestionsKeys.helpful(suggestion.id),
                icon: helpful
                    ? Icons.thumb_up_alt_rounded
                    : Icons.thumb_up_alt_outlined,
                color: AppColors.buy,
                onTap: onHelpful,
              ),
              const SizedBox(width: AppSpacing.x2),
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

class SavingsSmartConfidenceBar extends StatelessWidget {
  const SavingsSmartConfidenceBar({
    super.key,
    required this.value,
    required this.color,
  });

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: AppSpacing.x1,
              color: color,
              backgroundColor: AppColors.borderSolid,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$value%',
          style: savingsSmartMicroBold.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class SavingsSmartSuggestionIcon extends StatelessWidget {
  const SavingsSmartSuggestionIcon({
    super.key,
    required this.type,
    required this.color,
  });

  final SavingsSuggestionType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(
          savingsSmartTypeIcon(type),
          color: color,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class SavingsSmartMetaPill extends StatelessWidget {
  const SavingsSmartMetaPill({
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
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: EarnSpacingTokens.savingsConsumerPillLineHeight,
          ),
        ),
      ),
    );
  }
}

class SavingsSmartNewDot extends StatelessWidget {
  const SavingsSmartNewDot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EarnSpacingTokens.earnTopPaddingX1,
      child: Icon(Icons.circle, color: AppColors.sell, size: AppSpacing.x2),
    );
  }
}

class SavingsSmartSmallActionButton extends StatelessWidget {
  const SavingsSmartSmallActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      clip: true,
      background: ColoredBox(color: color.withValues(alpha: .12)),
      onTap: onTap,
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class SavingsSmartDisclaimer extends StatelessWidget {
  const SavingsSmartDisclaimer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      borderColor: AppColors.warn15,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
