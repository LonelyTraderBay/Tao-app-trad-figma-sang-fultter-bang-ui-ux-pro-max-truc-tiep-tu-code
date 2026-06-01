part of '../pages/p2p_wallet_page.dart';

class _InlineActionButton extends StatelessWidget {
  const _InlineActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .13),
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowDetailButton extends StatelessWidget {
  const _EscrowDetailButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PWalletPage.escrowKey(asset),
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Container(
          height: AppSpacing.inputHeight,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.text2,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Xem chi tiết Escrow',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.snapshot});

  final P2PWalletSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletPage.transactionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Giao dịch gần đây',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(snapshot.historyRoute),
              style: TextButton.styleFrom(
                foregroundColor: AppModuleAccents.p2p,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Xem tất cả'),
                  SizedBox(width: AppSpacing.x1),
                  Icon(Icons.chevron_right_rounded, size: 15),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (
                var index = 0;
                index < snapshot.transactions.length;
                index++
              ) ...[
                _TransactionRow(tx: snapshot.transactions[index]),
                if (index != snapshot.transactions.length - 1)
                  const Divider(height: 1, color: AppColors.borderSolid),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final P2PWalletTransactionDraft tx;

  @override
  Widget build(BuildContext context) {
    final color = _transactionColor(tx.type);
    final positive = _transactionIsPositive(tx.type);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(_transactionIcon(tx.type), color: color, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _transactionLabel(tx.type),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 11,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Flexible(
                      child: Text(
                        tx.orderId == null
                            ? tx.time
                            : '${tx.time}  ·  ${tx.orderId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 142),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${positive ? '+' : '-'}${_formatTransactionAmount(tx.amount, tx.asset)} ${tx.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _statusLabel(tx.status),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor(tx.status),
                    fontSize: 12,
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

IconData _assetIcon(String asset) {
  return switch (asset) {
    'BTC' => Icons.currency_bitcoin_rounded,
    'VND' => Icons.price_change_rounded,
    _ => Icons.attach_money_rounded,
  };
}

Color _assetColor(String asset) {
  return switch (asset) {
    'BTC' => AppColors.text1,
    'VND' => AppColors.text2,
    _ => AppColors.buy,
  };
}

IconData _transactionIcon(String type) {
  return switch (type) {
    'deposit' || 'transfer_in' => Icons.south_west_rounded,
    'withdraw' || 'transfer_out' => Icons.north_east_rounded,
    'escrow_lock' => Icons.lock_outline_rounded,
    'escrow_release' => Icons.shield_outlined,
    _ => Icons.attach_money_rounded,
  };
}

Color _transactionColor(String type) {
  return switch (type) {
    'deposit' || 'transfer_in' || 'escrow_release' => AppColors.buy,
    'withdraw' || 'transfer_out' => AppColors.sell,
    'escrow_lock' => AppModuleAccents.p2p,
    _ => AppColors.text2,
  };
}

bool _transactionIsPositive(String type) {
  return type == 'deposit' || type == 'transfer_in' || type == 'escrow_release';
}

String _transactionLabel(String type) {
  return switch (type) {
    'deposit' => 'Nạp tiền',
    'withdraw' => 'Rút tiền',
    'transfer_in' => 'Chuyển vào từ Main Wallet',
    'transfer_out' => 'Chuyển ra Main Wallet',
    'escrow_lock' => 'Khóa Escrow',
    'escrow_release' => 'Giải phóng Escrow',
    _ => 'Giao dịch',
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'completed' => 'Hoàn thành',
    'pending' => 'Đang xử lý',
    'failed' => 'Thất bại',
    _ => status,
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'completed' => AppColors.buy,
    'pending' => AppModuleAccents.p2p,
    'failed' => AppColors.sell,
    _ => AppColors.text3,
  };
}

String _formatAssetTotal(P2PWalletBalanceDraft balance) {
  if (balance.asset == 'VND') return _formatVnd(balance.total);
  return _formatComma(balance.total, balance.asset == 'BTC' ? 8 : 2);
}

String _formatBalancePart(double value, String asset) {
  if (asset == 'VND') return _formatVnd(value);
  return _formatComma(value, asset == 'BTC' ? 8 : 2);
}

String _formatTransactionAmount(double value, String asset) {
  return _formatComma(value, asset == 'BTC' ? 8 : 2);
}

String _formatVnd(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
