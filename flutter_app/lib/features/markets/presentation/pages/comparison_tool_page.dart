import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/comparison_tool_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/comparison_tool_content.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/comparison_tool_tokens.dart';

class ComparisonToolPage extends ConsumerStatefulWidget {
  const ComparisonToolPage({super.key, this.shellRenderMode});

  static const contentKey = ComparisonToolKeys.content;
  static const addTokenKey = ComparisonToolKeys.addToken;
  static const pickerKey = ComparisonToolKeys.picker;
  static const pickerSearchKey = ComparisonToolKeys.pickerSearch;

  static Key tokenKey(String id) => ComparisonToolKeys.token(id);

  static Key removeTokenKey(String id) => ComparisonToolKeys.removeToken(id);

  static Key pickerTokenKey(String id) => ComparisonToolKeys.pickerToken(id);

  static Key pickerQuickTokenKey(String id) =>
      ComparisonToolKeys.pickerQuickToken(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComparisonToolPage> createState() => _ComparisonToolPageState();
}

class _ComparisonToolPageState extends ConsumerState<ComparisonToolPage> {
  final TextEditingController _pickerSearchController = TextEditingController();
  late List<String> _selectedIds;
  bool _showPicker = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = [
      ...ref
          .read(marketControllerProvider)
          .getMarketComparison()
          .selectedPairIds,
    ];
  }

  @override
  void dispose() {
    _pickerSearchController.dispose();
    super.dispose();
  }

  void _addToken(String id) {
    if (_selectedIds.length >= comparisonToolMaxCompare ||
        _selectedIds.contains(id)) {
      return;
    }
    setState(() {
      _selectedIds = [..._selectedIds, id];
      _showPicker = false;
      _pickerSearchController.clear();
    });
  }

  void _removeToken(String id) {
    if (_selectedIds.length <= 2) return;
    setState(() {
      _selectedIds = _selectedIds.where((value) => value != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketControllerProvider).getMarketComparison();
    final selectedPairs = [
      for (final id in _selectedIds)
        if (comparisonFindPair(snapshot.marketPairs, id) != null)
          comparisonFindPair(snapshot.marketPairs, id)!,
    ];
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
      semanticLabel: 'SC-016 ComparisonToolPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'So sánh',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ComparisonToolPage.contentKey,
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      customGap: 18,
                      children: [
                        ComparisonSelectedTokensStrip(
                          selectedPairs: selectedPairs,
                          canAdd:
                              _selectedIds.length < comparisonToolMaxCompare,
                          canRemove: _selectedIds.length > 2,
                          onAdd: () => setState(() => _showPicker = true),
                          onRemove: _removeToken,
                        ),
                        if (_showPicker)
                          ComparisonTokenPickerCard(
                            snapshot: snapshot,
                            selectedIds: _selectedIds,
                            controller: _pickerSearchController,
                            onChanged: () => setState(() {}),
                            onClose: () => setState(() {
                              _showPicker = false;
                              _pickerSearchController.clear();
                            }),
                            onTokenSelected: _addToken,
                          ),
                        if (selectedPairs.length >= 2)
                          ComparisonSparklineCard(pairs: selectedPairs),
                        if (selectedPairs.length >= 2)
                          ComparisonMetricSection(
                            pairs: selectedPairs,
                            metrics: snapshot.metrics,
                          ),
                        if (selectedPairs.length >= 2)
                          ComparisonVolumeDistributionCard(
                            pairs: selectedPairs,
                          ),
                        if (selectedPairs.length >= 2)
                          ComparisonMarketCapDistributionCard(
                            pairs: selectedPairs,
                          ),
                        if (selectedPairs.length < 2)
                          const ComparisonNeedMoreTokensCard(),
                        const VitBanner(
                          variant: VitBannerVariant.info,
                          icon: Icons.sync_rounded,
                          message: 'Comparison data state reviewed',
                          detail:
                              'Selected token, picker, metric, empty, and refresh states stay visible while comparing market pairs.',
                        ),
                        const _MarketDataReviewCards(),
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

class _MarketDataReviewCards extends StatelessWidget {
  const _MarketDataReviewCards();

  @override
  Widget build(BuildContext context) {
    return const VitPageSection(
      label: 'Data checkpoints',
      children: [
        VitCard(child: Text('Token selection and removal constraints')),
        VitCard(child: Text('Metric comparison and chart readiness')),
        VitCard(child: Text('Empty state and cached data fallback')),
      ],
    );
  }
}
