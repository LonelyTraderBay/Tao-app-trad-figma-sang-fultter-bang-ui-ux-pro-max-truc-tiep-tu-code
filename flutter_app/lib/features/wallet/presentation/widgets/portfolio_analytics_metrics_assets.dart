part of '../pages/portfolio_analytics_page.dart';

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final List<WalletPortfolioMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chỉ số hiệu suất',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1,
            ),
          ),
          const SizedBox(height: 17),
          for (final metric in metrics)
            _MetricRow(metric: metric, isLast: metric == metrics.last),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metric, required this.isLast});

  final WalletPortfolioMetric metric;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metric.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            metric.value,
            style: AppTextStyles.caption.copyWith(
              color: Color(metric.colorHex),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetsCard extends StatelessWidget {
  const _AssetsCard({required this.assets, required this.totalUsd});

  final List<WalletAsset> assets;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
            child: Text(
              'Vị thế hiện tại',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              totalUsd: totalUsd,
              isLast: i == assets.length - 1,
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.totalUsd,
    required this.isLast,
  });

  final WalletAsset asset;
  final double totalUsd;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    final pct = totalUsd == 0 ? 0.0 : (asset.usdValue / totalUsd) * 100;
    final trendColor = asset.change24h >= 0 ? _analyticsGreen : _analyticsRed;

    return Container(
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _AssetAvatar(asset: asset, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        asset.symbol,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    Text(
                      _formatUsd(asset.usdValue),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: math.min(1, pct / 100),
                          minHeight: 4,
                          backgroundColor: AppColors.surface3,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${asset.change24h >= 0 ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: trendColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  '${pct.toStringAsFixed(1)}% danh mục',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
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

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final WalletAsset asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: .56)),
      ),
      alignment: Alignment.center,
      child: Text(
        asset.symbol.length <= 3 ? asset.symbol : asset.symbol.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: asset.symbol.length > 3 ? 8 : 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
