part of 'market_data_analytics_page.dart';

class _MarketDataAnalyticsPageState
    extends ConsumerState<MarketDataAnalyticsPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getMarketDataAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-089 MarketDataAnalyticsPage',
      child: Material(
        color: _analyticsBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Market Analytics',
              subtitle: 'Data & Intelligence',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeMargin),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: MarketDataAnalyticsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PairSelector(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _UnderlineTabs(
                      activeId: _tab,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    const SizedBox(height: 16),
                    if (_tab == 'market')
                      _MarketDataTab(snapshot: snapshot)
                    else if (_tab == 'liquidations')
                      _LiquidationsTab(snapshot: snapshot)
                    else
                      _SentimentTab(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PairSelector extends StatelessWidget {
  const _PairSelector({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
      decoration: BoxDecoration(
        color: _analyticsPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _HeaderValue(
              label: 'Analyzing',
              value: snapshot.selectedPair,
              alignRight: false,
            ),
          ),
          _HeaderValue(
            label: 'Mark Price',
            value: '\$${_formatMoney(snapshot.markPrice)}',
            valueColor: _analyticsGreen,
            alignRight: true,
            monospace: true,
          ),
        ],
      ),
    );
  }
}

class _HeaderValue extends StatelessWidget {
  const _HeaderValue({
    required this.label,
    required this.value,
    required this.alignRight,
    this.valueColor = AppColors.text1,
    this.monospace = false,
  });

  final String label;
  final String value;
  final bool alignRight;
  final Color valueColor;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontSize: 20,
            fontWeight: AppTextStyles.bold,
            fontFamily: monospace ? 'monospace' : null,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('market', 'Market Data'),
    ('liquidations', 'Liquidations'),
    ('sentiment', 'Sentiment'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: _analyticsPanel,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: MarketDataAnalyticsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: activeId == tab.$1
                            ? _analyticsPrimary
                            : AppColors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: activeId == tab.$1
                          ? _analyticsPrimary
                          : AppColors.text3,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MarketDataTab extends StatelessWidget {
  const _MarketDataTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OpenInterestCard(
          pair: snapshot.selectedPair,
          data: snapshot.openInterest,
        ),
        const SizedBox(height: 12),
        _LongShortRatioCard(data: snapshot.longShortRatio),
        const SizedBox(height: 12),
        _TopTradersCard(data: snapshot.topTraders),
        const SizedBox(height: 12),
        _FundingRateCard(data: snapshot.fundingRate),
      ],
    );
  }
}

class _OpenInterestCard extends StatelessWidget {
  const _OpenInterestCard({required this.pair, required this.data});

  final String pair;
  final TradeMarketOpenInterest data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _analyticsPrimary,
            title: 'Open Interest',
            trailing: '$pair >',
          ),
          const SizedBox(height: 18),
          Text(
            'Total Open Interest',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _formatMillions(data.current),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontSize: 26,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              _SmallBadge(
                label: '+${data.change24hPct.toStringAsFixed(2)}%',
                color: _analyticsGreen,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Change 24h',
                  value: '+${_formatMillions(data.change24h)}',
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBubble(
                  label: 'High 24h',
                  value: _formatMillions(data.high24h),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBubble(
                  label: 'Low 24h',
                  value: _formatMillions(data.low24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoStrip(
            text:
                'OI tang + gia tang = bullish strong. OI tang + gia giam = bearish momentum. OI giam = positions dong.',
          ),
        ],
      ),
    );
  }
}

class _LongShortRatioCard extends StatelessWidget {
  const _LongShortRatioCard({required this.data});

  final TradeMarketLongShortRatio data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            icon: Icons.groups_2_outlined,
            iconColor: _analyticsPurple,
            title: 'Long/Short Ratio',
            badge: 'Long',
          ),
          const SizedBox(height: 16),
          _ToggleBar(left: 'By Accounts', right: 'By Volume'),
          const SizedBox(height: 16),
          Row(
            children: [
              _PctLabel(
                label: 'Long ${data.longPct.toStringAsFixed(1)}%',
                color: _analyticsGreen,
                icon: Icons.trending_up_rounded,
              ),
              const Spacer(),
              _PctLabel(
                label: 'Short ${data.shortPct.toStringAsFixed(1)}%',
                color: _analyticsRed,
                icon: Icons.trending_down_rounded,
                iconAfter: true,
              ),
            ],
          ),
          const SizedBox(height: 9),
          _RatioBar(longPct: data.longPct),
          const SizedBox(height: 10),
          Text(
            'Long/Short Ratio',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _analyticsGreen,
              fontSize: 21,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Long Accounts',
                  value: _formatInt(data.longAccounts),
                  color: _analyticsGreen,
                  bg: _analyticsGreen.withValues(alpha: .09),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBubble(
                  label: 'Short Accounts',
                  value: _formatInt(data.shortAccounts),
                  color: _analyticsRed,
                  bg: _analyticsRed.withValues(alpha: .08),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
