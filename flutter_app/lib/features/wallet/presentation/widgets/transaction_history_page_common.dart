part of '../pages/transaction_history_page.dart';

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
