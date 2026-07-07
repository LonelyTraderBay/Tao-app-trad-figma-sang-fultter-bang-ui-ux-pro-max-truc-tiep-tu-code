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
    final scrollClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-089 MarketDataAnalyticsPage',
      child: Material(
        color: _analyticsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích thị trường',
            subtitle: 'Dữ liệu · Thanh khoản',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeMargin),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: MarketDataAnalyticsPage.contentKey,
                  bottomInset: scrollClearance,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: tradeShellWithProductTabs(
                      context: context,
                      children: [
                        VitTradeInstrumentHero(
                          symbol: snapshot.selectedPair,
                          priceLabel: '\$${_formatMoney(snapshot.markPrice)}',
                          changePct: snapshot.fundingRate.currentRatePct,
                          highLabel: _formatCompactUsd(
                            snapshot.openInterest.high24h,
                          ),
                          lowLabel: _formatCompactUsd(
                            snapshot.openInterest.low24h,
                          ),
                          volumeLabel: _formatCompactUsd(
                            snapshot.openInterest.current,
                          ),
                        ),
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
              ),
            ],
          ),
        ),
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
      density: VitDensity.compact,
      title: 'Xem lại dữ liệu thị trường',
      message:
          'Phân tích ${snapshot.selectedPair} chỉ mang tính tham khảo. Xác nhận ký quỹ, rủi ro thanh lý, phí funding và giới hạn vị thế trước khi đặt lệnh.',
      contractId: 'SC-089 analytics review',
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
    return VitSegmentedTabBar(
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: MarketDataAnalyticsPage.tabKey(tab.$1),
          ),
      ],
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
      fullBleed: true,
      density: VitDensity.compact,
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
        fullBleed: true,
        density: VitDensity.compact,
        children: [
          _CardHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _analyticsPrimary,
            title: 'Open Interest',
            trailing: '$pair >',
          ),
          Text(
            'Total Open Interest',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
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
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: 'High 24h',
                  value: _formatMillions(data.high24h),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
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
        fullBleed: true,
        density: VitDensity.compact,
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
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _analyticsGreen,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
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
              const SizedBox(width: AppSpacing.x2),
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
