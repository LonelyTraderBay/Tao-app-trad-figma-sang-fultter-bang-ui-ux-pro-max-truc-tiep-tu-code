part of 'prediction_advanced_chart_page.dart';

enum _ChartTab { chart, indicators, analysis }

class PredictionAdvancedChartPage extends ConsumerStatefulWidget {
  const PredictionAdvancedChartPage({
    super.key,
    required this.eventId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc041_advanced_chart_content');
  static const chartTabKey = Key('sc041_tab_chart');
  static const indicatorsTabKey = Key('sc041_tab_indicators');
  static const analysisTabKey = Key('sc041_tab_analysis');
  static const timeframe4hKey = Key('sc041_timeframe_4h');
  static const ma7ToggleKey = Key('sc041_toggle_ma7');
  static const ma25ToggleKey = Key('sc041_toggle_ma25');
  static const bbToggleKey = Key('sc041_toggle_bb');
  static const volumeToggleKey = Key('sc041_toggle_volume');

  final String eventId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionAdvancedChartPage> createState() =>
      _PredictionAdvancedChartPageState();
}

class _PredictionAdvancedChartPageState
    extends ConsumerState<PredictionAdvancedChartPage> {
  _ChartTab _activeTab = _ChartTab.chart;
  String _timeframe = '1H';
  bool _showMA7 = true;
  bool _showMA25 = true;
  bool _showBB = true;
  bool _showVolume = true;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getAdvancedChart(widget.eventId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerPadding =
        footerChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-041 PredictionAdvancedChartPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Advanced Chart',
            subtitle: 'Biểu đồ · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AdvancedChartTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionAdvancedChartPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionAdvancedScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.flush,
                      density: VitDensity.compact,
                      children: [
                        ...switch (_activeTab) {
                          _ChartTab.chart => [
                            _TimeframeSelector(
                              active: _timeframe,
                              onChanged: (value) =>
                                  setState(() => _timeframe = value),
                            ),
                            _ProbabilitySummaryCard(snapshot: snapshot),
                            _ProbabilityChartCard(
                              snapshot: snapshot,
                              showMA7: _showMA7,
                              showMA25: _showMA25,
                              showBB: _showBB,
                            ),
                            if (_showVolume)
                              _VolumeChartCard(snapshot: snapshot),
                            _ChartLayerControls(
                              showMA7: _showMA7,
                              showMA25: _showMA25,
                              showBB: _showBB,
                              showVolume: _showVolume,
                              onMA7: () => setState(() => _showMA7 = !_showMA7),
                              onMA25: () =>
                                  setState(() => _showMA25 = !_showMA25),
                              onBB: () => setState(() => _showBB = !_showBB),
                              onVolume: () =>
                                  setState(() => _showVolume = !_showVolume),
                            ),
                          ],
                          _ChartTab.indicators => [
                            _RsiCard(snapshot: snapshot),
                            _IndicatorSummarySection(snapshot: snapshot),
                            const _OverallSignalCard(),
                          ],
                          _ChartTab.analysis => [
                            _OrderFlowCard(snapshot: snapshot),
                            _SupportResistanceSection(snapshot: snapshot),
                            _PatternRecognitionCard(snapshot: snapshot),
                            const _AnalysisDisclaimer(),
                          ],
                        },
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Prediction advanced-chart review',
                          message:
                              'Timeframe, probability movement, volume, indicators, support/resistance, order flow, pattern signals, and disclaimer states are reviewed before acting on chart analysis.',
                          contractId: 'SC-041',
                          density: VitDensity.compact,
                        ),
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

class _AdvancedChartTabBar extends StatelessWidget {
  const _AdvancedChartTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _ChartTab activeTab;
  final ValueChanged<_ChartTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionAdvancedChartPage.chartTabKey,
        tab: _ChartTab.chart,
        label: 'Bieu do',
      ),
      (
        key: PredictionAdvancedChartPage.indicatorsTabKey,
        tab: _ChartTab.indicators,
        label: 'Chi bao',
      ),
      (
        key: PredictionAdvancedChartPage.analysisTabKey,
        tab: _ChartTab.analysis,
        label: 'Phan tich',
      ),
    ];

    return Material(
      color: AppColors.surface,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_ChartTab.values.byName(key)),
        tabs: [
          for (final item in tabs)
            VitTabItem(
              key: item.tab.name,
              label: item.label,
              widgetKey: item.key,
            ),
        ],
      ),
    );
  }
}

class _TimeframeSelector extends StatelessWidget {
  const _TimeframeSelector({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const timeframes = ['1H', '4H', '1D', '1W'];
    return Row(
      children: [
        for (var index = 0; index < timeframes.length; index += 1) ...[
          Expanded(
            child: _TimeframeButton(
              key: timeframes[index] == '4H'
                  ? PredictionAdvancedChartPage.timeframe4hKey
                  : null,
              label: timeframes[index],
              active: active == timeframes[index],
              onTap: () => onChanged(timeframes[index]),
            ),
          ),
          if (index != timeframes.length - 1)
            const SizedBox(
              width: PredictionsSpacingTokens.predictionAdvancedTimeframeGap,
            ),
        ],
      ],
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      fullWidth: true,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
    );
  }
}

class _ProbabilitySummaryCard extends StatelessWidget {
  const _ProbabilitySummaryCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        gap: VitContentGap.tight,
        children: [
          Text(
            'Current Probability',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(snapshot.currentProbability * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.amountMd,
              ),
              const SizedBox(
                width:
                    PredictionsSpacingTokens.predictionAdvancedSummaryValueGap,
              ),
              Padding(
                padding: PredictionsSpacingTokens
                    .predictionAdvancedSummaryChangePadding,
                child: Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      color: AppColors.buy,
                      size:
                          PredictionsSpacingTokens.predictionAdvancedTrendIcon,
                    ),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionAdvancedTrendIconGap,
                    ),
                    Text(
                      '+${snapshot.priceChangePercent.toStringAsFixed(2)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProbabilityChartCard extends StatelessWidget {
  const _ProbabilityChartCard({
    required this.snapshot,
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
  });

  final PredictionAdvancedChartSnapshot snapshot;
  final bool showMA7;
  final bool showMA25;
  final bool showBB;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        gap: VitContentGap.tight,
        children: [
          Text(
            'Probability Chart',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          SizedBox(
            height: AppSpacing.x7 * 6,
            child: CustomPaint(
              painter: _ProbabilityPainter(
                points: snapshot.priceHistory,
                support: snapshot.supportLevel,
                resistance: snapshot.resistanceLevel,
                showMA7: showMA7,
                showMA25: showMA25,
                showBB: showBB,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeChartCard extends StatelessWidget {
  const _VolumeChartCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        gap: VitContentGap.tight,
        children: [
          Text(
            'Trading Volume',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          SizedBox(
            height: AppSpacing.x7 * 3,
            child: CustomPaint(
              painter: _VolumePainter(points: snapshot.priceHistory),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLayerControls extends StatelessWidget {
  const _ChartLayerControls({
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
    required this.showVolume,
    required this.onMA7,
    required this.onMA25,
    required this.onBB,
    required this.onVolume,
  });

  final bool showMA7;
  final bool showMA25;
  final bool showBB;
  final bool showVolume;
  final VoidCallback onMA7;
  final VoidCallback onMA25;
  final VoidCallback onBB;
  final VoidCallback onVolume;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lop hien thi',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        GridView.count(
          crossAxisCount:
              PredictionsSpacingTokens.predictionAdvancedLayerColumns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: PredictionsSpacingTokens.predictionAdvancedLayerGap,
          crossAxisSpacing: PredictionsSpacingTokens.predictionAdvancedLayerGap,
          childAspectRatio:
              PredictionsSpacingTokens.predictionAdvancedLayerAspect,
          children: [
            _LayerButton(
              key: PredictionAdvancedChartPage.ma7ToggleKey,
              label: 'MA(7)',
              color: AppColors.buy,
              active: showMA7,
              onTap: onMA7,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.ma25ToggleKey,
              label: 'MA(25)',
              color: _purple,
              active: showMA25,
              onTap: onMA25,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.bbToggleKey,
              label: 'Bollinger Bands',
              color: AppColors.warn,
              active: showBB,
              onTap: onBB,
            ),
            _LayerButton(
              key: PredictionAdvancedChartPage.volumeToggleKey,
              label: 'Volume',
              color: _predictionPrimary,
              active: showVolume,
              onTap: onVolume,
            ),
          ],
        ),
      ],
    );
  }
}
