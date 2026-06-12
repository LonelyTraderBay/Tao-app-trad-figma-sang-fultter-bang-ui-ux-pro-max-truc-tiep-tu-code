part of 'market_data_analytics_page.dart';

class _TopTradersCard extends StatelessWidget {
  const _TopTradersCard({required this.data});

  final TradeTopTraderPositions data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 14,
        children: [
          _CardHeader(
            icon: Icons.visibility_rounded,
            iconColor: _analyticsAmber,
            title: 'Top Traders',
            badge: 'Long',
          ),
          VitCard(
            height: 113,
            padding: const EdgeInsets.all(16),
            variant: VitCardVariant.inner,
            borderColor: _analyticsGreen.withValues(alpha: .2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Top traders dang Long',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
                Text(
                  '${data.longPct.toStringAsFixed(1)}%',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: _analyticsGreen,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
                Text(
                  'of top traders are long',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          _RatioBar(longPct: data.longPct),
          VitCard(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            variant: VitCardVariant.inner,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24h Change',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Shifted ${data.change24h.toStringAsFixed(1)}% to Long',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _analyticsGreen.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.trending_up_rounded,
                      color: _analyticsGreen,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _InfoStrip(
            iconColor: _analyticsAmber,
            bg: _analyticsAmber.withValues(alpha: .06),
            text:
                'Top traders = accounts voi volume cao nhat. Thuong la whales, institutions. Theo trend cua ho co the profitable.',
          ),
        ],
      ),
    );
  }
}

class _FundingRateCard extends StatelessWidget {
  const _FundingRateCard({required this.data});

  final TradeFundingRateHistory data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 12,
        children: [
          _CardHeader(
            icon: Icons.attach_money_rounded,
            iconColor: _analyticsPrimary,
            title: 'Funding Rate',
            badge: '+${data.currentRatePct.toStringAsFixed(3)}%',
            badgeColor: _analyticsRed,
          ),
          VitCard(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            variant: VitCardVariant.inner,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Next funding in',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    data.nextFundingLabel,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: _analyticsPrimary,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Current',
                  value: '+${data.currentRatePct.toStringAsFixed(3)}%',
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBubble(
                  label: '24h Avg',
                  value: '${data.avgRatePct.toStringAsFixed(3)}%',
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBubble(
                  label: 'Range',
                  value: '${data.rangePct.toStringAsFixed(3)}%',
                ),
              ),
            ],
          ),
          VitCard(
            height: 67,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
            variant: VitCardVariant.inner,
            child: CustomPaint(
              painter: _FundingLinePainter(values: data.historyPct),
            ),
          ),
          _InfoStrip(
            text:
                'Funding rate duong (do) = Long tra Short. Am (xanh) = Short tra Long. Thanh toan moi 8 gio.',
          ),
        ],
      ),
    );
  }
}

class _LiquidationsTab extends StatelessWidget {
  const _LiquidationsTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.liquidationStats;
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 12,
      children: [
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 10,
            children: [
              const _CardHeader(
                icon: Icons.flash_on_rounded,
                iconColor: _analyticsAmber,
                title: 'Liquidation Stats',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBubble(
                      label: '24h Total',
                      value: _formatCompactUsd(stats.total24h),
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBubble(
                      label: 'Long Liq',
                      value: _formatCompactUsd(stats.long24h),
                      color: _analyticsGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricBubble(
                      label: 'Short Liq',
                      value: _formatCompactUsd(stats.short24h),
                      color: _analyticsRed,
                    ),
                  ),
                ],
              ),
              _ValueRow(
                label: 'Largest liquidation',
                value: _formatCompactUsd(stats.largest24h),
              ),
              _ValueRow(
                label: 'Liquidation count',
                value: _formatInt(stats.count24h),
              ),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 8,
            children: [
              const _CardHeader(
                icon: Icons.grid_view_rounded,
                iconColor: _analyticsRed,
                title: 'Liquidation Heatmap',
              ),
              for (final cluster in snapshot.liquidationClusters)
                _HeatmapRow(cluster: cluster),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 8,
            children: [
              const _CardHeader(
                icon: Icons.history_rounded,
                iconColor: _analyticsPrimary,
                title: 'Recent Liquidations',
                badge: 'Live',
              ),
              for (final liquidation in snapshot.recentLiquidations)
                _LiquidationRow(liquidation: liquidation),
            ],
          ),
        ),
      ],
    );
  }
}

class _SentimentTab extends StatelessWidget {
  const _SentimentTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sentiment = snapshot.sentiment;
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 12,
      children: [
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 16,
            children: [
              const _CardHeader(
                icon: Icons.psychology_outlined,
                iconColor: _analyticsPurple,
                title: 'Market Sentiment',
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 118,
                      height: 118,
                      child: CircularProgressIndicator(
                        value: sentiment.score / 100,
                        strokeWidth: 12,
                        backgroundColor: _analyticsPanel2,
                        color: _analyticsAmber,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${sentiment.score}',
                          style: AppTextStyles.heroNumber.copyWith(
                            color: _analyticsAmber,
                            height: 1,
                          ),
                        ),
                        Text(
                          sentiment.overall.toUpperCase(),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 8,
            children: [
              Text(
                'How Sentiment is Calculated',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              for (final component in sentiment.components)
                _SentimentComponentRow(component: component),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            customGap: 8,
            children: [
              Text(
                'Trading Implications',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              for (final implication in sentiment.implications)
                _ImplicationRow(implication: implication),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.badge,
    this.badgeColor = _analyticsGreen,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? trailing;
  final String? badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          )
        else if (badge != null)
          _SmallBadge(label: badge!, color: badgeColor),
      ],
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: _analyticsBorder.withValues(alpha: .72),
      child: child,
    );
  }
}
