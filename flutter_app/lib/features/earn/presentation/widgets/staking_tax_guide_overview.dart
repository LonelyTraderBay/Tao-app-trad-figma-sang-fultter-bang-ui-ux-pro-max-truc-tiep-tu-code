import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingTaxOverviewTab extends StatelessWidget {
  const StakingTaxOverviewTab({super.key, required this.snapshot});

  final StakingTaxGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.overviewTitle,
          children: [
            VitCard(
              key: StakingTaxGuideKeys.overview,
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.overviewBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: EarnSpacingTokens.stakingTaxOverviewLineHeight,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  for (final event in snapshot.incomeEvents) ...[
                    _IncomeEventCard(event: event),
                    if (event != snapshot.incomeEvents.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: snapshot.summaryTitle,
          children: [
            VitCard(
              key: StakingTaxGuideKeys.summary,
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  for (final summary in snapshot.countrySummaries) ...[
                    _CountrySummaryRow(summary: summary),
                    if (summary != snapshot.countrySummaries.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: snapshot.toolsTitle,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnCardPaddingX4,
              child: Column(
                children: [
                  _ToolRow(
                    key: StakingTaxGuideKeys.historyTool,
                    icon: Icons.receipt_long_rounded,
                    title: 'Lịch sử Staking',
                    subtitle: 'Xem tất cả giao dịch staking',
                    onTap: () => context.go(snapshot.historyRoute),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  _ToolRow(
                    key: StakingTaxGuideKeys.taxReportsTool,
                    icon: Icons.file_download_outlined,
                    title: 'Báo cáo Thuế',
                    subtitle: 'Xuất CSV/PDF cho khai thuế',
                    onTap: () => context.go(snapshot.taxReportsRoute),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        StakingTaxFooterCard(text: snapshot.footer),
      ],
    );
  }
}

class _IncomeEventCard extends StatelessWidget {
  const _IncomeEventCard({required this.event});

  final StakingTaxIncomeEventDraft event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface3,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              event.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: EarnSpacingTokens.stakingTaxEventLineHeight,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              event.example,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontStyle: FontStyle.italic,
                height: EarnSpacingTokens.stakingTaxExampleLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountrySummaryRow extends StatelessWidget {
  const _CountrySummaryRow({required this.summary});

  final StakingTaxCountrySummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StakingTaxCodeBadge(code: summary.code),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary.country,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${summary.treatment} · CGT: ${summary.cgt}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.text1,
            size: EarnSpacingTokens.stakingTaxToolIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: EarnSpacingTokens.stakingTaxExternalIcon,
          ),
        ],
      ),
    );
  }
}
