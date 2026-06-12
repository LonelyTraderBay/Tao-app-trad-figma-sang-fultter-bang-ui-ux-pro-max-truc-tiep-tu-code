part of '../pages/transaction_detail_page.dart';

class _SupportButton extends StatelessWidget {
  const _SupportButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: TransactionDetailPage.supportKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.inputHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _detailAmber.withValues(alpha: .08),
          border: Border.all(color: _detailAmber.withValues(alpha: .24)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: _detailAmber,
              size: AppSpacing.walletTransactionActionIcon,
            ),
            const SizedBox(width: AppSpacing.rowGapCompact),
            Text(
              'Liên hệ hỗ trợ',
              style: AppTextStyles.caption.copyWith(
                color: _detailAmber,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingTransaction extends StatelessWidget {
  const _MissingTransaction({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.walletTransactionMissingTopPad),
        Container(
          width: AppSpacing.walletTransactionMissingIcon,
          height: AppSpacing.walletTransactionMissingIcon,
          decoration: BoxDecoration(
            color: _detailPanel2,
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(Icons.error_outline_rounded, color: _detailRed),
        ),
        const SizedBox(height: AppSpacing.walletTransactionSummaryTopGap),
        Text(
          'Không tìm thấy giao dịch',
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.walletTransactionAfterHashGap),
        GestureDetector(
          onTap: onBack,
          child: Container(
            height: AppSpacing.walletTransactionMissingActionHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.walletTransactionMissingActionPad,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _detailPrimary,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              'Quay lại lịch sử',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VitCardSurface extends StatelessWidget {
  const _VitCardSurface({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

final class _DetailTypeMeta {
  const _DetailTypeMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;

  factory _DetailTypeMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _DetailTypeMeta(
        label: 'Nạp tiền',
        color: _detailGreen,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
      ),
      WalletTransactionType.withdraw => const _DetailTypeMeta(
        label: 'Rút tiền',
        color: _detailRed,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
      ),
      WalletTransactionType.tradeBuy => const _DetailTypeMeta(
        label: 'Mua giao dịch',
        color: _detailGreen,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
      ),
      WalletTransactionType.tradeSell => const _DetailTypeMeta(
        label: 'Bán giao dịch',
        color: _detailRed,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
      ),
      WalletTransactionType.p2pBuy => const _DetailTypeMeta(
        label: 'P2P Mua',
        color: _detailGreen,
        icon: Icons.handshake_rounded,
        isDebit: false,
      ),
      WalletTransactionType.p2pSell => const _DetailTypeMeta(
        label: 'P2P Bán',
        color: _detailRed,
        icon: Icons.handshake_rounded,
        isDebit: true,
      ),
    };
  }
}

final class _DetailStatusMeta {
  const _DetailStatusMeta({required this.label, required this.icon});

  final String label;
  final IconData icon;

  factory _DetailStatusMeta.from(WalletTransactionStatus status) {
    return switch (status) {
      WalletTransactionStatus.completed => const _DetailStatusMeta(
        label: 'Hoàn thành',
        icon: Icons.check_circle_outline_rounded,
      ),
      WalletTransactionStatus.pending => const _DetailStatusMeta(
        label: 'Đang xử lý',
        icon: Icons.access_time_rounded,
      ),
      WalletTransactionStatus.failed => const _DetailStatusMeta(
        label: 'Thất bại',
        icon: Icons.cancel_outlined,
      ),
    };
  }
}

VitStatusPillStatus _detailPillStatus(WalletTransactionStatus status) {
  return switch (status) {
    WalletTransactionStatus.completed => VitStatusPillStatus.success,
    WalletTransactionStatus.pending => VitStatusPillStatus.warning,
    WalletTransactionStatus.failed => VitStatusPillStatus.error,
  };
}

final class _ProgressStep {
  const _ProgressStep(
    this.label,
    this.time, {
    required this.done,
    this.failed = false,
  });

  final String label;
  final String? time;
  final bool done;
  final bool failed;
}

final class _DetailRowData {
  const _DetailRowData({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;
}

List<_DetailRowData> _detailsFor(WalletTransaction tx, bool isDebit) {
  final rows = <_DetailRowData>[];
  if (tx.txHash != null) {
    rows.add(
      _DetailRowData(
        label: 'Mã giao dịch (TxID)',
        value: tx.txHash!,
        copyable: true,
      ),
    );
  }
  if (tx.network != null) {
    rows.add(_DetailRowData(label: 'Mạng', value: tx.network!));
  }
  if (tx.address != null) {
    rows.add(
      _DetailRowData(
        label: isDebit ? 'Địa chỉ nhận' : 'Địa chỉ gửi',
        value: tx.address!,
        copyable: true,
      ),
    );
  }
  if (tx.fee != null && tx.fee! > 0) {
    rows.add(
      _DetailRowData(label: 'Phí giao dịch', value: _formatFee(tx.fee!)),
    );
  }
  rows.add(_DetailRowData(label: 'Thời gian', value: tx.createdAt));
  return rows;
}

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return _formatNumber(tx.amount, fractionDigits: 2);
}

String _formatFee(double value) => '\$${value.toStringAsFixed(2)}';

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
