part of 'wallet_page_sections.dart';

class WalletAllocationCard extends StatelessWidget {
  const WalletAllocationCard({super.key, required this.assets});

  final List<WalletAsset> assets;

  @override
  Widget build(BuildContext context) {
    final total = assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _walletPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          CustomPaint(
            size: const Size(92, 92),
            painter: _AllocationPainter(assets: assets, total: total),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                for (final asset in assets.take(6)) ...[
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(asset.colorHex),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          asset.symbol,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${(asset.usdValue / total * 100).toStringAsFixed(1)}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  if (asset != assets.take(6).last) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationPainter extends CustomPainter {
  const _AllocationPainter({required this.assets, required this.total});

  final List<WalletAsset> assets;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;
    for (final asset in assets.take(6)) {
      final sweep = (asset.usdValue / total) * math.pi * 2;
      paint.color = Color(asset.colorHex).withValues(alpha: .88);
      canvas.drawArc(rect.deflate(8), start, sweep, false, paint);
      start += sweep;
    }
    final centerPaint = Paint()..color = _walletPanel;
    canvas.drawCircle(rect.center, 22, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _AllocationPainter oldDelegate) => false;
}

IconData _actionIcon(String key) => switch (key) {
  'deposit' => Icons.file_download_outlined,
  'withdraw' => Icons.file_upload_outlined,
  'buy' => Icons.shopping_cart_outlined,
  'transfer' => Icons.swap_vert_rounded,
  'history' => Icons.schedule_rounded,
  _ => Icons.account_balance_wallet_outlined,
};

IconData _toolIcon(String key) => switch (key) {
  'pending' => Icons.south_west_rounded,
  'limits' => Icons.speed_rounded,
  'dust' => Icons.auto_awesome_rounded,
  'network' => Icons.wifi_rounded,
  _ => Icons.account_balance_wallet_outlined,
};

String _formatUsd(double value) {
  final whole = value.truncate();
  final cents = ((value - whole) * 100).round().abs();
  return '\$${_withCommas(whole)}.${cents.toString().padLeft(2, '0')}';
}

String _formatVnd(double value) => _withDots(value.round());

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatAssetAmount(double value) {
  if (value >= 1000) return _withCommas(value.round());
  if (value >= 10) return value.toStringAsFixed(4);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _withCommas(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _withDots(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}
