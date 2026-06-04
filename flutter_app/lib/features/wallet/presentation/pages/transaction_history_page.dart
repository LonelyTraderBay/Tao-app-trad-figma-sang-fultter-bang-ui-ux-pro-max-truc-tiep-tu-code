import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

part '../widgets/transaction_history_page_sections.dart';
part '../widgets/transaction_history_page_common.dart';

const _historyBackground = AppColors.bg;
const _historyPrimary = AppColors.primary;
const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;
const _historyAmber = AppColors.caution;

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc136_transaction_history_content');
  static const exportKey = Key('sc136_transaction_history_export');
  static Key filterKey(String id) => Key('sc136_transaction_filter_$id');
  static Key transactionKey(String id) => Key('sc136_transaction_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(walletTransactionHistoryProvider);
    final transactions = _filteredTransactions(snapshot.transactions);
    final grouped = _groupByDate(transactions);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-136 TxHistoryPage',
      child: Material(
        color: _historyBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử giao dịch',
            subtitle: 'Lịch sử · Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
            actions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                tooltip: 'Xuất lịch sử',
                onPressed: () => _showExportNotice(transactions.length),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: TransactionHistoryPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ExportBar(
                        count: transactions.length,
                        onExport: () => _showExportNotice(transactions.length),
                      ),
                      const SizedBox(height: 24),
                      _FilterTabs(
                        filters: snapshot.filters,
                        active: _filter,
                        onChanged: (id) => setState(() => _filter = id),
                      ),
                      const SizedBox(height: 22),
                      for (final group in grouped)
                        _TransactionGroup(
                          group: group,
                          onTransactionTap: (tx) => context.go(
                            AppRoutePaths.walletTransaction(tx.id),
                          ),
                        ),
                      if (transactions.isNotEmpty) const _EndOfList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<WalletTransaction> _filteredTransactions(
    List<WalletTransaction> transactions,
  ) {
    return transactions.where((tx) {
      return switch (_filter) {
        'deposit' => tx.type == WalletTransactionType.deposit,
        'withdraw' => tx.type == WalletTransactionType.withdraw,
        'trade' =>
          tx.type == WalletTransactionType.tradeBuy ||
              tx.type == WalletTransactionType.tradeSell,
        'p2p' =>
          tx.type == WalletTransactionType.p2pBuy ||
              tx.type == WalletTransactionType.p2pSell,
        _ => true,
      };
    }).toList();
  }

  List<_TransactionDateGroup> _groupByDate(
    List<WalletTransaction> transactions,
  ) {
    final groups = <String, List<WalletTransaction>>{};
    for (final tx in transactions) {
      final date = tx.createdAt.split(' ').first;
      groups.putIfAbsent(date, () => <WalletTransaction>[]).add(tx);
    }
    return [
      for (final entry in groups.entries)
        _TransactionDateGroup(date: entry.key, transactions: entry.value),
    ];
  }

  void _showExportNotice(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count giao dịch đã được chuẩn bị để xuất CSV'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }
}
