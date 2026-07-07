import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_guide_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsGuideGlossaryTab extends StatelessWidget {
  const SavingsGuideGlossaryTab({super.key, required this.snapshot});

  final SavingsGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsGuideKeys.glossaryList,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${snapshot.terms.length} thuật ngữ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final term in snapshot.terms) ...[
          _TermCard(term: term),
          if (term != snapshot.terms.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.disclaimer,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    height: EarnSpacingTokens.earnGuideBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({required this.term});

  final SavingsGuideTermDraft term;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SavingsGuideRoundIcon(
            icon: Icons.text_fields_rounded,
            color: AppColors.primary,
            label: term.term.length < 2 ? term.term : term.term.substring(0, 2),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.term,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  term.definition,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: EarnSpacingTokens.earnGuideTipLineHeight,
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
