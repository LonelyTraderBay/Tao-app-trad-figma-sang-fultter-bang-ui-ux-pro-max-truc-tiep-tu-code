import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class TransactionReportingComplianceNotice extends StatelessWidget {
  const TransactionReportingComplianceNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.transactionReportingComplianceNoticePadding,
      borderColor: transactionReportPrimary.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: transactionReportPrimary,
            size: 17,
          ),
          const SizedBox(width: AppSpacing.rowGapRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MiFID II Article 26 Compliance',
                  style: AppTextStyles.badge.copyWith(
                    color: transactionReportPrimary,
                    height: AppSpacing.transactionReportingLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'All transactions must be reported to ARM within T+1. Reports include 65+ RTS 22 fields. Auto-submission enabled.',
                  style: AppTextStyles.micro.copyWith(
                    color: transactionReportPrimary,
                    height: AppSpacing.transactionReportingNoticeLineHeight,
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

class TransactionReportingNoticePanel extends StatelessWidget {
  const TransactionReportingNoticePanel({
    required this.text,
    required this.onClose,
    super.key,
  });

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.contentPad,
      right: AppSpacing.contentPad,
      bottom:
          AppSpacing.bottomNavCapsuleHeightVisual +
          AppSpacing.x7 +
          MediaQuery.paddingOf(context).bottom,
      child: Material(
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          padding: AppSpacing.transactionReportingNoticePanelPadding,
          borderColor: AppColors.primary.withValues(alpha: .4),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: transactionReportGreen,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.rowGapRegular + AppSpacing.x1),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitInlineIconAction(
                icon: Icons.close_rounded,
                tooltip: 'Dismiss notice',
                onPressed: onClose,
                color: AppColors.text3,
                size: 18,
                padding: AppSpacing.x1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
