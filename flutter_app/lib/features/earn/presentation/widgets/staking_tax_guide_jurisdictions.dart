import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
        const SizedBox(height: AppSpacing.x4),
        _JurisdictionDetail(jurisdiction: selected),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Tài liệu tham khảo',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final resource in selected.resources) ...[
                    _ResourceRow(resource: resource),
                    if (resource != selected.resources.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
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
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        key: StakingTaxGuideKeys.jurisdiction(jurisdiction.id),
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary20 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StakingTaxCodeBadge(code: jurisdiction.code, small: true),
              const SizedBox(width: AppSpacing.x2),
              Text(
                jurisdiction.name.split('(').first.trim(),
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JurisdictionDetail extends StatelessWidget {
  const _JurisdictionDetail({required this.jurisdiction});

  final StakingTaxJurisdictionDraft jurisdiction;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Cách xử lý thuế:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            jurisdiction.treatment,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.stakingTaxFooterLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
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
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.stakingTaxJurisdictionMetricMinHeight,
      ),
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.stakingTaxJurisdictionMetricLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final StakingTaxResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.public_rounded,
            color: AppColors.primary,
            size: AppSpacing.stakingTaxResourceIcon,
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
            size: AppSpacing.stakingTaxResourceExternalIcon,
          ),
        ],
      ),
    );
  }
}
