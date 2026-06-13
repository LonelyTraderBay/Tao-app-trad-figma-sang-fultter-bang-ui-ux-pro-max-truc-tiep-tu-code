part of 'market_overview_page.dart';

class _MarketCapHero extends StatelessWidget {
  const _MarketCapHero({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface2, AppColors.surface, AppColors.bg],
          stops: [0, 0.55, 1],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: 0.24)),
        borderRadius: AppRadii.cardLargeRadius,
        boxShadow: [
          BoxShadow(
            color: _marketPrimary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.language_rounded,
                color: _marketPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Tổng vốn hóa thị trường',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  _formatCompact(stats.totalMarketCap, prefix: r'$'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pageTitle.copyWith(height: 1),
                ),
              ),
              const SizedBox(width: 12),
              _ChangePill(value: stats.totalMarketCapChange24h),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'BTC Dominance',
                  value: '${stats.btcDominance.toStringAsFixed(1)}%',
                  valueColor: _btcOrange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(
                  label: 'ETH Dominance',
                  value: '${stats.ethDominance.toStringAsFixed(1)}%',
                  valueColor: _ethPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(
                  label: 'KL 24h',
                  value: _formatCompact(stats.total24hVolume, prefix: r'$'),
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'DeFi TVL',
                value: _formatCompact(stats.defiTVL, prefix: r'$'),
                change: stats.defiTVLChange24h,
                icon: Icons.layers_rounded,
                color: _sectorPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Stablecoin Vol',
                value: _formatCompact(stats.stablecoinVolume24h, prefix: r'$'),
                icon: Icons.monitor_heart_outlined,
                color: _marketPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Tổng coin',
                value: _formatInt(stats.totalCoins),
                icon: Icons.pie_chart_outline_rounded,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Sàn giao dịch',
                value: _formatInt(stats.totalExchanges),
                icon: Icons.bar_chart_rounded,
                color: AppColors.primarySoft,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? change;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 96,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBubble(icon: icon, color: color, size: 24, iconSize: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1.1,
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  change! >= 0
                      ? Icons.arrow_outward_rounded
                      : Icons.south_east_rounded,
                  color: change! >= 0 ? AppColors.buy : AppColors.sell,
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  _formatSignedPercent(change!),
                  style: AppTextStyles.micro.copyWith(
                    color: change! >= 0 ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SentimentGrid extends StatelessWidget {
  const _SentimentGrid({required this.stats, required this.breadth});

  final GlobalMarketStats stats;
  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: VitCard(
            height: 183,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MiniHeader(
                  icon: Icons.speed_rounded,
                  color: AppColors.primarySoft,
                  label: 'Fear & Greed',
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _FearGreedGauge(
                    value: stats.fearGreedIndex,
                    label: stats.fearGreedLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: VitCard(
            height: 183,
            padding: const EdgeInsets.all(16),
            child: _MarketBreadthCard(breadth: breadth),
          ),
        ),
      ],
    );
  }
}

class _MarketBreadthCard extends StatelessWidget {
  const _MarketBreadthCard({required this.breadth});

  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    final total = breadth.advancing + breadth.declining;
    final advancingPct = total == 0 ? 0.0 : breadth.advancing / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MiniHeader(
          icon: Icons.gps_fixed_rounded,
          color: _marketPrimary,
          label: 'Biến động thị trường',
        ),
        const SizedBox(height: 16),
        _BreadthLine(
          label: 'Tăng',
          value: breadth.advancing,
          color: AppColors.buy,
        ),
        const SizedBox(height: 9),
        _BreadthLine(
          label: 'Giảm',
          value: breadth.declining,
          color: AppColors.sell,
        ),
        const SizedBox(height: 13),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(
                  flex: (advancingPct * 1000).round(),
                  child: const ColoredBox(color: AppColors.buy),
                ),
                Expanded(
                  flex: ((1 - advancingPct) * 1000).round(),
                  child: const ColoredBox(color: AppColors.sell),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                '${breadth.newATH} ATH mới',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${breadth.dropping10Pct} giảm >10%',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.sell,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BreadthLine extends StatelessWidget {
  const _BreadthLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1,
            ),
          ),
        ),
        Text(
          _formatInt(value),
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _FearGreedGauge extends StatelessWidget {
  const _FearGreedGauge({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _fearGreedColor(value);
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 64,
          child: CustomPaint(painter: _FearGreedGaugePainter(value: value)),
        ),
        const Spacer(),
        Text(
          '$value',
          style: AppTextStyles.amountMd.copyWith(color: color, height: 1),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
