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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Market Analytics',
            subtitle: 'Data & Intelligence',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: MarketDataAnalyticsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 16,
                    children: [
                      _PairSelector(snapshot: snapshot),
                      _MarketAnalyticsRiskPanel(snapshot: snapshot),
                      _UnderlineTabs(
                        activeId: _tab,
                        onChanged: (id) => setState(() => _tab = id),
                      ),
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
      ),
    );
  }
}

class _PairSelector extends StatelessWidget {
  const _PairSelector({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 82,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
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

class _MarketAnalyticsRiskPanel extends StatelessWidget {
  const _MarketAnalyticsRiskPanel({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: 'Market data risk review',
      message:
          'Use ${snapshot.selectedPair} analytics as a preview input only. Confirm margin, liquidation risk, funding fee, position limits, and next steps before placing a trade.',
      contractId: 'SC-089 analytics review',
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
            height: 1.2,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
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
    return VitCard(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (final tab in _tabs) ...[
            Expanded(
              child: VitStatusPill(
                key: MarketDataAnalyticsPage.tabKey(tab.$1),
                label: tab.$2,
                status: activeId == tab.$1
                    ? VitStatusPillStatus.info
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.lg,
                onTap: () => onChanged(tab.$1),
              ),
            ),
            if (tab != _tabs.last) const SizedBox(width: 8),
          ],
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
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: 12,
      children: [
        _OpenInterestCard(
          pair: snapshot.selectedPair,
          data: snapshot.openInterest,
        ),
        _LongShortRatioCard(data: snapshot.longShortRatio),
        _TopTradersCard(data: snapshot.topTraders),
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
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 14,
        children: [
          _CardHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _analyticsPrimary,
            title: 'Open Interest',
            trailing: '$pair >',
          ),
          Text(
            'Total Open Interest',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatMillions(data.current),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _SmallBadge(
                label: '+${data.change24hPct.toStringAsFixed(2)}%',
                color: _analyticsGreen,
              ),
            ],
          ),
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
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: 12,
        children: [
          _CardHeader(
            icon: Icons.groups_2_outlined,
            iconColor: _analyticsPurple,
            title: 'Long/Short Ratio',
            badge: 'Long',
          ),
          _ToggleBar(left: 'By Accounts', right: 'By Volume'),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _PctLabel(
                      label: 'Long ${data.longPct.toStringAsFixed(1)}%',
                      color: _analyticsGreen,
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _PctLabel(
                      label: 'Short ${data.shortPct.toStringAsFixed(1)}%',
                      color: _analyticsRed,
                      icon: Icons.trending_down_rounded,
                      iconAfter: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _RatioBar(longPct: data.longPct),
          Text(
            'Long/Short Ratio',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _analyticsGreen,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
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
