part of '../pages/asset_detail_page.dart';

class _AssetTransactions extends StatelessWidget {
  const _AssetTransactions({
    required this.transactions,
    required this.onNavigate,
  });

  final List<WalletAssetDetailTransaction> transactions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const VitEmptyState(
        title: 'No asset transactions',
        message:
            'Recent deposit, withdrawal, transfer, and trade activity will appear here.',
      );
    }

    return VitCard(
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.overlayStroke,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          Text(
            'Lịch sử giao dịch',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          for (final tx in transactions)
            _AssetTransactionRow(tx: tx, onTap: () => onNavigate(tx.route)),
        ],
      ),
    );
  }
}

class _AssetTransactionRow extends StatelessWidget {
  const _AssetTransactionRow({required this.tx, required this.onTap});

  final WalletAssetDetailTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = tx.isIncoming ? _assetGreen : _assetRed;
    return VitCard(
      key: AssetDetailPage.transactionKey(tx.id),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      padding: AppSpacing.zeroInsets.copyWith(
        top: _assetTransactionVerticalPad,
        bottom: _assetTransactionVerticalPad,
      ),
      onTap: onTap,
      child: Row(
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            width: _assetTransactionIconSize,
            height: _assetTransactionIconSize,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .20),
            child: Icon(
              tx.isIncoming
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: color,
              size: AppSpacing.walletAssetTransactionGlyph,
            ),
          ),
          const SizedBox(width: _assetInlineGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _assetSmallGap),
                Text(
                  tx.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tx.isIncoming ? '+' : '-'}${_formatFixed(tx.amount, 6)} ${tx.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _assetSmallGap),
                Text(
                  tx.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatUsd(double value) => '\$${_withCommas(value.toStringAsFixed(2))}';

String _formatFixed(double value, int decimals) {
  return _withCommas(value.toStringAsFixed(decimals));
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
