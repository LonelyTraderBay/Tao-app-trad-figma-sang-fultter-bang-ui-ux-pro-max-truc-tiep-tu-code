import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingTaxJurisdictionTab extends StatelessWidget {
  const StakingTaxJurisdictionTab({
    super.key,
    required this.snapshot,
    required this.selectedId,
    required this.onChanged,
  });

  final StakingTaxGuideSnapshot snapshot;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.jurisdictions.firstWhere(
      (item) => item.id == selectedId,
      orElse: () => snapshot.jurisdictions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final jurisdiction in snapshot.jurisdictions)
              _JurisdictionChip(
                jurisdiction: jurisdiction,
                selected: jurisdiction.id == selected.id,
                onTap: () => onChanged(jurisdiction.id),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _JurisdictionDetail(jurisdiction: selected),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Tài liệu tham khảo',
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  for (final resource in selected.resources) ...[
                    _ResourceRow(resource: resource),
                    if (resource != selected.resources.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const StakingTaxWarningNote(
          text:
              'Thông tin trên chỉ mang tính tổng quan. Quy định thuế có thể thay đổi. Vui lòng tham khảo chuyên gia thuế hoặc website cơ quan thuế chính thức.',
        ),
      ],
    );
  }
}

class _JurisdictionChip extends StatelessWidget {
  const _JurisdictionChip({
    required this.jurisdiction,
    required this.selected,
    required this.onTap,
  });

  final StakingTaxJurisdictionDraft jurisdiction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: StakingTaxGuideKeys.jurisdiction(jurisdiction.id),
      label: jurisdiction.name.split('(').first.trim(),
      selected: selected,
      onTap: onTap,
      accentColor: AppColors.primary,
      padding: EarnSpacingTokens.earnCardPaddingX3X2,
      leading: StakingTaxCodeBadge(code: jurisdiction.code, small: true),
    );
  }
}

class _JurisdictionDetail extends StatelessWidget {
  const _JurisdictionDetail({required this.jurisdiction});

  final StakingTaxJurisdictionDraft jurisdiction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StakingTaxCodeBadge(code: jurisdiction.code, large: true),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jurisdiction.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      jurisdiction.taxAuthority,
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
          Text(
            'Cách xử lý thuế:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            jurisdiction.treatment,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingTaxFooterLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _JurisdictionMetric(
                  label: 'Thuế suất',
                  value: jurisdiction.rate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _JurisdictionMetric(
                  label: 'Biểu mẫu',
                  value: jurisdiction.reportingForm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JurisdictionMetric extends StatelessWidget {
  const _JurisdictionMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: EarnSpacingTokens.stakingTaxJurisdictionMetricMinHeight,
      ),
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height:
                      EarnSpacingTokens.stakingTaxJurisdictionMetricLineHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final StakingTaxResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Row(
          children: [
            const Icon(
              Icons.public_rounded,
              color: AppColors.primary,
              size: EarnSpacingTokens.stakingTaxResourceIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                resource.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.primary,
              size: EarnSpacingTokens.stakingTaxResourceExternalIcon,
            ),
          ],
        ),
      ),
    );
  }
}
