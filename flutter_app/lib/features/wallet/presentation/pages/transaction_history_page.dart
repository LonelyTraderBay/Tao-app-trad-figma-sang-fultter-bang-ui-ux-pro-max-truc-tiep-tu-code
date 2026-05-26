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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

const _historyBackground = AppColors.bg;
const _historyPanel2 = AppColors.surface2;
const _historyPrimary = AppColors.primary;
const _historyGreen = Color(0xFF10B981);
const _historyRed = Color(0xFFEF4444);
const _historyAmber = Color(0xFFF59E0B);

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
    final snapshot = ref
        .watch(walletRepositoryProvider)
        .getTransactionHistory();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sử giao dịch',
              subtitle: 'Lịch sử · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
              trailing: _HeaderExportButton(
                onTap: () => _showExportNotice(transactions.length),
              ),
            ),
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
                        onTransactionTap: (tx) =>
                            context.go(AppRoutePaths.walletTransaction(tx.id)),
                      ),
                    if (transactions.isNotEmpty) const _EndOfList(),
                  ],
                ),
              ),
            ),
          ],
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

class _HeaderExportButton extends StatelessWidget {
  const _HeaderExportButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _historyPanel2,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: Colors.white.withValues(alpha: .04)),
        ),
        child: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.text1,
          size: 22,
        ),
      ),
    );
  }
}

class _ExportBar extends StatelessWidget {
  const _ExportBar({required this.count, required this.onExport});

  final int count;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count giao dịch',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
        GestureDetector(
          key: TransactionHistoryPage.exportKey,
          onTap: onExport,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: _historyPrimary.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  color: _historyPrimary,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  'Xuất CSV',
                  style: AppTextStyles.micro.copyWith(
                    color: _historyPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<WalletTransactionFilter> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _FilterChip(
              filter: filters[i],
              active: filters[i].id == active,
              onTap: () => onChanged(filters[i].id),
            ),
            if (i != filters.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final WalletTransactionFilter filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransactionHistoryPage.filterKey(filter.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _historyPrimary.withValues(alpha: .18)
              : Colors.transparent,
          borderRadius: AppRadii.inputRadius,
          border: Border.all(
            color: active
                ? _historyPrimary.withValues(alpha: .48)
                : Colors.transparent,
          ),
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _historyPrimary : AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _TransactionDateGroup {
  const _TransactionDateGroup({required this.date, required this.transactions});

  final String date;
  final List<WalletTransaction> transactions;
}

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({
    required this.group,
    required this.onTransactionTap,
  });

  final _TransactionDateGroup group;
  final ValueChanged<WalletTransaction> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 41,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 19),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Text(
            _formatDate(group.date),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        for (final tx in group.transactions)
          _TransactionRow(tx: tx, onTap: () => onTransactionTap(tx)),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx, required this.onTap});

  final WalletTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _TransactionMeta.from(tx);

    return GestureDetector(
      key: TransactionHistoryPage.transactionKey(tx.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 84),
        padding: const EdgeInsets.fromLTRB(17, 13, 16, 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _TransactionIcon(meta: meta),
            const SizedBox(width: 56),
            Expanded(
              child: _TransactionInfo(tx: tx, meta: meta),
            ),
            const SizedBox(width: 8),
            _AmountStatus(tx: tx, meta: meta),
            const SizedBox(width: 9),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({required this.meta});

  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    if (meta.isTrade) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: .12),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _historyPrimary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.currency_exchange_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: Icon(meta.icon, color: AppColors.text1, size: 22),
    );
  }
}

class _TransactionInfo extends StatelessWidget {
  const _TransactionInfo({required this.tx, required this.meta});

  final WalletTransaction tx;
  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${meta.label} ${tx.asset}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _timePart(tx.createdAt),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 12,
            height: 1,
          ),
        ),
        if (tx.network != null) ...[
          const SizedBox(height: 5),
          Text(
            'Mạng: ${tx.network}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
        ],
        if (tx.txHash != null) ...[
          const SizedBox(height: 5),
          Text(
            tx.txHash!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: _historyPrimary,
              fontSize: 11,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}

class _AmountStatus extends StatelessWidget {
  const _AmountStatus({required this.tx, required this.meta});

  final WalletTransaction tx;
  final _TransactionMeta meta;

  @override
  Widget build(BuildContext context) {
    final status = _StatusMeta.from(tx.status);

    return SizedBox(
      width: 126,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${meta.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: AppTextStyles.caption.copyWith(
              color: meta.color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status.label,
              style: AppTextStyles.micro.copyWith(
                color: status.color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          if (tx.fee != null && tx.fee! > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Phí: \$${tx.fee!.toStringAsFixed(2)}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EndOfList extends StatelessWidget {
  const _EndOfList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 31, height: 1, color: AppColors.borderSolid),
          const SizedBox(width: 10),
          Text(
            'Đã tải hết',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 31, height: 1, color: AppColors.borderSolid),
        ],
      ),
    );
  }
}

final class _TransactionMeta {
  const _TransactionMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
    required this.isTrade,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;
  final bool isTrade;

  factory _TransactionMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _TransactionMeta(
        label: 'Nạp',
        color: _historyGreen,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
        isTrade: false,
      ),
      WalletTransactionType.withdraw => const _TransactionMeta(
        label: 'Rút',
        color: _historyRed,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
        isTrade: false,
      ),
      WalletTransactionType.tradeBuy => const _TransactionMeta(
        label: 'Mua',
        color: _historyGreen,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
        isTrade: true,
      ),
      WalletTransactionType.tradeSell => const _TransactionMeta(
        label: 'Bán',
        color: _historyRed,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
        isTrade: true,
      ),
      WalletTransactionType.p2pBuy => const _TransactionMeta(
        label: 'P2P Mua',
        color: _historyGreen,
        icon: Icons.handshake_rounded,
        isDebit: false,
        isTrade: false,
      ),
      WalletTransactionType.p2pSell => const _TransactionMeta(
        label: 'P2P Bán',
        color: _historyRed,
        icon: Icons.handshake_rounded,
        isDebit: true,
        isTrade: false,
      ),
    };
  }
}

final class _StatusMeta {
  const _StatusMeta({required this.label, required this.color});

  final String label;
  final Color color;

  factory _StatusMeta.from(WalletTransactionStatus status) {
    return switch (status) {
      WalletTransactionStatus.completed => const _StatusMeta(
        label: 'Hoàn thành',
        color: _historyGreen,
      ),
      WalletTransactionStatus.pending => const _StatusMeta(
        label: 'Đang xử lý',
        color: _historyAmber,
      ),
      WalletTransactionStatus.failed => const _StatusMeta(
        label: 'Thất bại',
        color: _historyRed,
      ),
    };
  }
}

String _formatDate(String rawDate) {
  final parts = rawDate.split('-');
  if (parts.length != 3) return rawDate;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

String _timePart(String raw) {
  final parts = raw.split(' ');
  return parts.length > 1 ? parts[1] : raw;
}

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return _formatNumber(tx.amount, fractionDigits: 2);
}

String _formatNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts[1]}';
}
