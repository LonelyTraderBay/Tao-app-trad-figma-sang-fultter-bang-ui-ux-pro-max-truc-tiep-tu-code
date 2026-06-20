part of '../pages/portfolio_analytics_page.dart';

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final List<WalletPortfolioMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _VitCardSurface(
      padding: AppSpacing.walletAnalyticsMetricsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ch\u1EC9 s\u1ED1 hi\u1EC7u su\u1EA5t',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                metric.value,
                style: AppTextStyles.caption.copyWith(
                  color: Color(metric.colorHex),
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _AssetsCard extends StatelessWidget {
  const _AssetsCard({required this.assets, required this.totalUsd});

  final List<WalletAsset> assets;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    return _VitCardSurface(
      padding: AppSpacing.zeroInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.walletAnalyticsAssetsHeaderPadding,
            child: Text(
              'V\u1ECB th\u1EBF hi\u1EC7n t\u1EA1i',
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
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

    return Column(
      children: [
        if (!isLast)
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        Padding(
          padding: AppSpacing.walletAnalyticsAssetRowPadding,
          child: Row(
            children: [
              _AssetAvatar(asset: asset, color: color),
              const SizedBox(width: AppSpacing.walletAnalyticsAssetGap),
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
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatUsd(asset.usdValue),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadii.xsRadius,
                            child: LinearProgressIndicator(
                              value: math.min(1, pct / 100),
                              minHeight: _walletAnalyticsAssetProgressHeight,
                              backgroundColor: AppColors.surface3,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.walletAnalyticsAssetValueGap,
                        ),
                        Text(
                          '${asset.change24h >= 0 ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                          style: AppTextStyles.micro.copyWith(
                            color: trendColor,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${pct.toStringAsFixed(1)}% danh m\u1EE5c',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final WalletAsset asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: AppSpacing.walletAnalyticsAssetAvatar,
      height: AppSpacing.walletAnalyticsAssetAvatar,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.lg,
      borderColor: color.withValues(alpha: .56),
      background: ColoredBox(color: color.withValues(alpha: .18)),
      clip: true,
      alignment: Alignment.center,
      child: Text(
        asset.symbol.length <= 3 ? asset.symbol : asset.symbol.substring(0, 3),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
