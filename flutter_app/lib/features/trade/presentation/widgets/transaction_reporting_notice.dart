import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';

class TransactionReportingComplianceNotice extends StatelessWidget {
  const TransactionReportingComplianceNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: transactionReportPrimary.withValues(alpha: .10),
        border: Border.all(
          color: transactionReportPrimary.withValues(alpha: .35),
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: transactionReportPrimary,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MiFID II Article 26 Compliance',
                  style: AppTextStyles.badge.copyWith(
                    color: transactionReportPrimary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All transactions must be reported to ARM within T+1. Reports include 65+ RTS 22 fields. Auto-submission enabled.',
                  style: AppTextStyles.micro.copyWith(
                    color: transactionReportPrimary,
                    height: 1.4,
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
      left: 20,
      right: 20,
      bottom: 108 + MediaQuery.paddingOf(context).bottom,
      child: Material(
        color: AppColors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          decoration: BoxDecoration(
            color: transactionReportPanel,
            border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
            borderRadius: AppRadii.cardRadius,
            boxShadow: const [
              BoxShadow(
                color: AppColors.modalScrim,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: transactionReportGreen,
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
