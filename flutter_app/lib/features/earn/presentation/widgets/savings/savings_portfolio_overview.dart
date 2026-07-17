import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/hub/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_formatters.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_hero.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings/savings_portfolio_maturity.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.snapshot,
    required this.hideBalance,
    required this.onToggleBalance,
  });

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      fullBleed: true,
      children: [
        PortfolioHero(
          snapshot: snapshot,
          hideBalance: hideBalance,
          onToggleBalance: onToggleBalance,
        ),
        const SectionLabel(label: 'Phân bổ tài sản', color: AppColors.primary),
        _AllocationCard(
          positions: snapshot.positions,
          total: snapshot.totalDepositedUsd,
        ),
        const SectionLabel(label: 'Dự phóng thu nhập', color: AppColors.buy),
        _IncomeProjectionRow(items: snapshot.incomeProjections),
        const EarnInfoBanner(
          text:
              'Ước tính dựa trên APY hiện tại. Lãi suất có thể thay đổi theo điều kiện thị trường.',
        ),
        const SectionLabel(label: 'Lịch đáo hạn', color: AppColors.warn),
        MaturitySummary(events: snapshot.maturityEvents),
        for (final event in snapshot.maturityEvents) MaturityCard(event: event),
        const EarnWarningBanner(
          text:
              'Khi đáo hạn, bạn có thể gia hạn để tiếp tục nhận lãi hoặc rút về ví. Rút trước hạn có thể mất lãi tích lũy.',
        ),
      ],
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.positions, required this.total});

  final List<SavingsPortfolioPositionDraft> positions;
  final String total;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: savingsPortfolioCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: savingsPortfolioDonutExtent,
            child: CustomPaint(
              painter: DonutPainter(
                segments: [
                  for (final position in positions)
                    DonutSegment(
                      value: allocationValue(position.allocationLabel),
                      color: assetColor(position.asset),
                    ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tổng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      total,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final position in positions) ...[
            AllocationRow(position: position),
            if (position != positions.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class AllocationRow extends StatelessWidget {
  const AllocationRow({super.key, required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = assetColor(position.asset);
    return Column(
      children: [
        Row(
          children: [
            TinyDot(
              color: color,
              size: EarnSpacingTokens.savingsPortfolioAllocationDot,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                position.asset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              position.usdValue,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            SizedBox(
              width: EarnSpacingTokens.savingsPortfolioAllocationPercentWidth,
              child: Text(
                position.allocationLabel,
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitProgressBar(
          progress: allocationValue(position.allocationLabel),
          color: color,
          trackColor: AppColors.surface3,
          height: AppSpacing.pageRhythmCompactInnerGap,
          borderRadius: AppRadii.xlRadius,
        ),
      ],
    );
  }
}

class _IncomeProjectionRow extends StatelessWidget {
  const _IncomeProjectionRow({required this.items});

  final List<SavingsIncomeProjectionDraft> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _IncomeProjectionCard(item: item)),
          if (item != items.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _IncomeProjectionCard extends StatelessWidget {
  const _IncomeProjectionCard({required this.item});

  final SavingsIncomeProjectionDraft item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.icon) {
      'month' => Icons.calendar_month_outlined,
      'year' => Icons.bar_chart_rounded,
      _ => Icons.wb_sunny_outlined,
    };
    return VitCard(
      radius: VitCardRadius.large,
      padding: savingsPortfolioCardPadding,
      child: Column(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.primary12,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            item.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
