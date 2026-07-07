import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

final class StakingTaxGuideKeys {
  const StakingTaxGuideKeys._();

  static const disclaimer = Key('sc356_tax_disclaimer');
  static const overview = Key('sc356_tax_overview');
  static const summary = Key('sc356_tax_summary');
  static const historyTool = Key('sc356_tax_history_tool');
  static const taxReportsTool = Key('sc356_tax_reports_tool');
  static const calculatorResult = Key('sc356_tax_calculator_result');

  static Key jurisdiction(String id) => Key('sc356_tax_jurisdiction_$id');
}

class StakingTaxWarningNote extends StatelessWidget {
  const StakingTaxWarningNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warningBg,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.warningBorder),
          borderRadius: AppRadii.lgRadius,
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: EarnSpacingTokens.stakingTaxWarningIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingTaxWarningLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StakingTaxFooterCard extends StatelessWidget {
  const StakingTaxFooterCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: EarnSpacingTokens.stakingTaxFooterLineHeight,
        ),
      ),
    );
  }
}

class StakingTaxCodeBadge extends StatelessWidget {
  const StakingTaxCodeBadge({
    super.key,
    required this.code,
    this.small = false,
    this.large = false,
  });

  final String code;
  final bool small;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large
        ? EarnSpacingTokens.stakingTaxCodeBadgeLarge
        : (small
              ? EarnSpacingTokens.stakingTaxCodeBadgeSmall
              : EarnSpacingTokens.stakingTaxCodeBadgeRegular);
    final style = small
        ? AppTextStyles.numericMicro
        : (large ? AppTextStyles.baseMedium : AppTextStyles.body);
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.surface3,
          shape: RoundedRectangleBorder(
            borderRadius: large ? AppRadii.cardRadius : AppRadii.mdRadius,
          ),
        ),
        child: Center(
          child: Text(
            code,
            style: style.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

String stakingTaxMoney(double value) {
  final fixed = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 2,
  );
  final parts = fixed.split('.');
  final head = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < head.length; i++) {
    final remaining = head.length - i;
    buffer.write(head[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$${buffer.toString()}';
}
