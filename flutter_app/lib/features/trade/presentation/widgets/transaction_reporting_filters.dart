import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';

class TransactionReportingSearchField extends StatelessWidget {
  const TransactionReportingSearchField({
    required this.query,
    required this.onChanged,
    super.key,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        key: transactionReportingSearchKey,
        controller: TextEditingController(text: query)
          ..selection = TextSelection.collapsed(offset: query.length),
        onChanged: onChanged,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 13,
          height: 1,
        ),
        decoration: InputDecoration(
          hintText: 'Search by transaction ID or instrument...',
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: 18,
          ),
          filled: true,
          fillColor: transactionReportPanel2,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: transactionReportBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: transactionReportBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class TransactionReportingTabs extends StatelessWidget {
  const TransactionReportingTabs({
    required this.activeId,
    required this.stats,
    required this.onChanged,
    super.key,
  });

  final String activeId;
  final TradeTransactionReportingStats stats;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('queue', 'Queue (${stats.pending})'),
      ('history', 'History'),
      ('failed', 'Failed (${stats.failed})'),
      ('stats', 'Stats'),
    ];

    return Container(
      height: 54,
      color: transactionReportPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: transactionReportingTabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? AppColors.primary
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: activeId == tab.$1 ? 58 : 0,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
