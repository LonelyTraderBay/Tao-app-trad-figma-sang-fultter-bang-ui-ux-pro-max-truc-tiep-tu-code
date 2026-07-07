import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-016 ComparisonToolPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'So sánh',
            subtitle: 'So sánh token · Markets',
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
                    padding: AppSpacing.comparisonToolScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
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
