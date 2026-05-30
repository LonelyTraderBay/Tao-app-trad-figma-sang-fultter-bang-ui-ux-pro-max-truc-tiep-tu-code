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
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-041 PredictionAdvancedChartPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Advanced Chart',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
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
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
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
                        if (_showVolume) _VolumeChartCard(snapshot: snapshot),
                        _ChartLayerControls(
                          showMA7: _showMA7,
                          showMA25: _showMA25,
                          showBB: _showBB,
                          showVolume: _showVolume,
                          onMA7: () => setState(() => _showMA7 = !_showMA7),
                          onMA25: () => setState(() => _showMA25 = !_showMA25),
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
                  ),
                ),
              ),
            ),
          ],
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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
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
          if (index != timeframes.length - 1) const SizedBox(width: 10),
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
    return SizedBox(
      height: 36,
      child: Material(
        color: active ? _predictionPrimary : AppColors.bg,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: active ? AppColors.transparent : AppColors.border,
              ),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.onAccent : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProbabilitySummaryCard extends StatelessWidget {
  const _ProbabilitySummaryCard({required this.snapshot});

  final PredictionAdvancedChartSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Probability',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(snapshot.currentProbability * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.heroNumber.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 9),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      color: AppColors.buy,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Probability Chart',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 286,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading Volume',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 122,
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
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.9,
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
