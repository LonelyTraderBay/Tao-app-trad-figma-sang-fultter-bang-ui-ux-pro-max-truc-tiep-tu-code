part of 'home_page.dart';

class _RankedRow extends StatelessWidget {
  const _RankedRow({
    required this.rank,
    required this.pair,
    required this.positive,
    required this.onTap,
  });

  final int rank;
  final HomeCryptoPair pair;
  final bool positive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitRankedAssetRow(
      rank: rank,
      leading: VitAssetAvatar(
        label: pair.baseAsset,
        accentColor: pair.logoColor,
      ),
      title: pair.symbol,
      badgeLabel: _formatPct(pair.change24h),
      trend: positive ? VitTrendDirection.positive : VitTrendDirection.negative,
      highlightRank: rank == 1 && positive,
      onTap: onTap,
    );
  }
}

String _formatUsd(double value, {bool forceTwoDecimals = false}) {
  final decimals = forceTwoDecimals || value >= 1 ? 2 : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final buffer = StringBuffer();
  final whole = parts.first;
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatBillions(double value) {
  return (value / 1000000000).toStringAsFixed(2);
}
