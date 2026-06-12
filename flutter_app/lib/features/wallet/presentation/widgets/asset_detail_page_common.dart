part of '../pages/asset_detail_page.dart';

class _AssetChartPainter extends CustomPainter {
  const _AssetChartPainter({required this.points, required this.color});

  final List<WalletAssetChartPoint> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minPrice = points.map((p) => p.price).reduce(math.min);
    final maxPrice = points.map((p) => p.price).reduce(math.max);
    final range = math.max(1, maxPrice - minPrice);
    final dx = size.width / (points.length - 1);
    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final x = i * dx;
      final normalized = (points[i].price - minPrice) / range;
      final y =
          size.height - normalized * (size.height * .82) - size.height * .08;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: .22), color.withValues(alpha: .02)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _AssetChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

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
      padding: AppSpacing.cardPadding,
      borderColor: AppColors.overlayStroke,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletAssetTransactionsGap,
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
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.walletTransactionDetailsPadVertical,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: AppSpacing.walletAssetTransactionIcon,
            height: AppSpacing.walletAssetTransactionIcon,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.cardRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              tx.isIncoming
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: color,
              size: AppSpacing.walletAssetTransactionGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.walletHistoryFilterGap),
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
                const SizedBox(height: AppSpacing.walletAssetSmallGap),
                Text(
                  tx.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx.isIncoming ? '+' : '-'}${_formatFixed(tx.amount, 6)} ${tx.asset}',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.walletAssetSmallGap),
              Text(
                tx.status,
                style: AppTextStyles.micro.copyWith(color: color),
              ),
            ],
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
