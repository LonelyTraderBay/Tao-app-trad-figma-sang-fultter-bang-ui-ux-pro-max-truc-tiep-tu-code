import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingValidatorSelectionDetailCard extends StatelessWidget {
  const StakingValidatorSelectionDetailCard({
    super.key,
    required this.validator,
    required this.onClose,
  });

  final StakingValidatorDraft validator;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chi tiết Validator',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Dong',
                onPressed: onClose,
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(validator.name, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.x1),
          Text(
            validator.address,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            validator.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height:
                  EarnSpacingTokens.stakingValidatorSelectionDetailLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final feature in validator.features)
                StakingValidatorSelectionStatusPill(
                  label: feature,
                  color: AppColors.primarySoft,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            onPressed: () {},
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: const Text('Chọn Validator này'),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: EarnSpacingTokens.earnCardPaddingX3,
            child: Text(
              'Khi chọn validator riêng, bạn chịu rủi ro slashing nếu validator vi phạm. Ưu tiên validator Top Tier hoặc Recommended.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height:
                    EarnSpacingTokens.stakingValidatorSelectionDetailLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StakingValidatorSelectionFooterNote extends StatelessWidget {
  const StakingValidatorSelectionFooterNote({
    super.key,
    required this.snapshot,
  });

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorSelectionKeys.footer,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Text(
        snapshot.footerNote,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: EarnSpacingTokens.stakingValidatorSelectionDetailLineHeight,
        ),
      ),
    );
  }
}
