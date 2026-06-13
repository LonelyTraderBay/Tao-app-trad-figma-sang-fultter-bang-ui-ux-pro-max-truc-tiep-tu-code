import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class TransactionReportingSearchField extends StatefulWidget {
  const TransactionReportingSearchField({
    required this.query,
    required this.onChanged,
    super.key,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<TransactionReportingSearchField> createState() =>
      _TransactionReportingSearchFieldState();
}

class _TransactionReportingSearchFieldState
    extends State<TransactionReportingSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant TransactionReportingSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query == _controller.text) return;
    _controller
      ..text = widget.query
      ..selection = TextSelection.collapsed(offset: widget.query.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: _controller,
      fieldKey: transactionReportingSearchKey,
      placeholder: 'Search by transaction ID or instrument...',
      variant: VitSearchBarVariant.compact,
      onChanged: widget.onChanged,
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
                          style: AppTextStyles.navLabel.copyWith(
                            color: activeId == tab.$1
                                ? AppColors.primary
                                : AppColors.text3,
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
