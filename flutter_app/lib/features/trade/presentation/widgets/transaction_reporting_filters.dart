import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      height: AppSpacing.x7 + AppSpacing.x2,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.$1,
              label: tab.$2,
              widgetKey: transactionReportingTabKey(tab.$1),
            ),
        ],
      ),
    );
  }
}
