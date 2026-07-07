import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingTaxCalculatorTab extends StatelessWidget {
  const StakingTaxCalculatorTab({
    super.key,
    required this.snapshot,
    required this.rewardsController,
    required this.rateController,
    required this.onChanged,
  });

  final StakingTaxGuideSnapshot snapshot;
  final TextEditingController rewardsController;
  final TextEditingController rateController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final rewards = double.tryParse(rewardsController.text);
    final rate = double.tryParse(rateController.text);
    final hasResult =
        rewards != null && rate != null && rewards >= 0 && rate >= 0;
    final taxOwed = hasResult ? rewards * (rate / 100) : 0.0;
    final afterTax = hasResult ? rewards - taxOwed : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: EarnSpacingTokens.stakingTaxCalculatorIconBox,
                    child: DecoratedBox(
                      decoration: const ShapeDecoration(
                        color: AppColors.primary12,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.primary20,
                            width: EarnSpacingTokens.stakingTaxBorderWidth,
                          ),
                          borderRadius: AppRadii.cardRadius,
                        ),
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        color: AppColors.primary,
                        size: EarnSpacingTokens.stakingTaxCalculatorIcon,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.calculatorTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          snapshot.calculatorSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitInput(
                controller: rewardsController,
                fieldKey: const Key('sc356_tax_rewards_input'),
                label: 'Tổng phần thưởng staking (USD)',
                hintText: '1000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.savings_rounded),
                onChanged: (_) => onChanged(),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitInput(
                controller: rateController,
                fieldKey: const Key('sc356_tax_rate_input'),
                label: 'Thuế suất của bạn (%)',
                hintText: '30',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.percent_rounded),
                onChanged: (_) => onChanged(),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                snapshot.calculatorHint,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (hasResult) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                _TaxResultCard(
                  rewards: rewards,
                  rate: rate,
                  taxOwed: taxOwed,
                  afterTax: afterTax,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        StakingTaxWarningNote(text: snapshot.calculatorDisclaimer),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: snapshot.faqTitle,
          children: [for (final faq in snapshot.faqs) _FaqCard(faq: faq)],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        StakingTaxFooterCard(text: snapshot.footer),
      ],
    );
  }
}

class _TaxResultCard extends StatelessWidget {
  const _TaxResultCard({
    required this.rewards,
    required this.rate,
    required this.taxOwed,
    required this.afterTax,
  });

  final double rewards;
  final double rate;
  final double taxOwed;
  final double afterTax;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: StakingTaxGuideKeys.calculatorResult,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardLargeRadius),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kết quả:',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _ResultRow(
                label: 'Tổng phần thưởng',
                value: stakingTaxMoney(rewards),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              _ResultRow(
                label:
                    'Thuế phải nộp (${rate.toStringAsFixed(rate.truncateToDouble() == rate ? 0 : 1)}%)',
                value: '-${stakingTaxMoney(taxOwed)}',
                color: AppColors.sell,
              ),
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
              _ResultRow(
                label: 'Sau thuế',
                value: stakingTaxMoney(afterTax),
                color: AppColors.buy,
                highlight: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.color,
    this.highlight = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final valueStyle = highlight
        ? AppTextStyles.baseMedium
        : AppTextStyles.body;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: highlight ? AppColors.text1 : AppColors.text3,
              fontWeight: highlight ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          value,
          style: valueStyle.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faq});

  final StakingTaxFaqDraft faq;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.question,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            faq.answer,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingTaxFooterLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
