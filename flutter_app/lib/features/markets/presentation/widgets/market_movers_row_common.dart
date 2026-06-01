part of '../pages/market_movers_page.dart';

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    super.key,
    required this.rank,
    required this.mover,
    required this.tab,
    required this.change,
    required this.last,
    required this.onTap,
  });

  final int rank;
  final MarketMover mover;
  final String tab;
  final double change;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metric = _metricForTab();
    final metricColor = metric.positive ? AppColors.buy : AppColors.sell;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _ListRankBadge(rank: rank),
            const SizedBox(width: 8),
            _CoinAvatar(mover: mover),
            const SizedBox(width: 10),
            Expanded(child: _MoverIdentity(mover: mover)),
            const SizedBox(width: 8),
            SizedBox(
              width: 66,
              height: 30,
              child: CustomPaint(
                painter: _SparklinePainter(
                  values: mover.sparkline,
                  color: metricColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 74,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPrice(mover.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    metric.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: metricColor,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _MoverMetric _metricForTab() {
    if (tab == 'Hoạt động') {
      return _MoverMetric(
        label: _formatCompact(mover.volume24h, prefix: r'$'),
        positive: true,
      );
    }
    if (tab == 'KL bất thường') {
      return _MoverMetric(
        label: 'KL ${_formatSignedPercent(mover.volumeChange24h)}',
        positive: mover.volumeChange24h >= 0,
      );
    }
    return _MoverMetric(
      label: _formatSignedPercent(change),
      positive: change >= 0,
    );
  }
}

class _MoverMetric {
  const _MoverMetric({required this.label, required this.positive});

  final String label;
  final bool positive;
}

class _ListRankBadge extends StatelessWidget {
  const _ListRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
          height: 1,
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    final labelLength = mover.symbol.length < 3 ? mover.symbol.length : 3;
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: mover.color.withValues(alpha: 0.16),
        border: Border.all(color: mover.color.withValues(alpha: 0.32)),
        shape: BoxShape.circle,
      ),
      child: Text(
        mover.symbol.substring(0, labelLength),
        style: AppTextStyles.micro.copyWith(
          color: mover.color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _MoverIdentity extends StatelessWidget {
  const _MoverIdentity({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                mover.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 5),
            _MarketCapRankBadge(rank: mover.marketCapRank),
            if (mover.isNew) ...[const SizedBox(width: 5), const _NewBadge()],
          ],
        ),
        const SizedBox(height: 7),
        Text(
          mover.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _MarketCapRankBadge extends StatelessWidget {
  const _MarketCapRankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        '#$rank',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: _marketPrimary.withValues(alpha: 0.15),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        'MỚI',
        style: AppTextStyles.micro.copyWith(
          color: _marketPrimary,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _DataRefreshFooter extends StatelessWidget {
  const _DataRefreshFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dữ liệu cập nhật mỗi 30 giây',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3, height: 1),
      ),
    );
  }
}
