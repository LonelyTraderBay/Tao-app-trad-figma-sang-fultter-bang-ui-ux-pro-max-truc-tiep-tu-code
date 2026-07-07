import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../widgets/predictions_home_filters.dart';
part '../widgets/predictions_home_highlights.dart';
part '../widgets/predictions_home_events.dart';

const _marketPrimary = AppColors.primary;

class PredictionsHomePage extends ConsumerStatefulWidget {
  const PredictionsHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc027_predictions_home_scroll_content');
  static const searchActionKey = Key('sc027_search_action');
  static const searchFieldKey = Key('sc027_search_field');
  static const trendingFilterKey = Key('sc027_filter_trending');
  static const newFilterKey = Key('sc027_filter_new');
  static const categoryAllKey = Key('sc027_category_all');
  static const categoryLiveCryptoKey = Key('sc027_category_live_crypto');
  static const myPredictionsKey = Key('sc027_my_predictions');
  static const breakingMoversKey = Key('sc027_breaking_movers');
  static const arenaBridgeKey = Key('sc027_arena_bridge');

  static Key eventCardKey(String id) => Key('sc027_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsHomePage> createState() =>
      _PredictionsHomePageState();
}

class _PredictionsHomePageState extends ConsumerState<PredictionsHomePage> {
  final _searchController = TextEditingController();
  PredictionFilterTab _filter = PredictionFilterTab.trending;
  String? _category;
  String _searchQuery = '';

  bool get _hasActiveFilters =>
      _filter != PredictionFilterTab.trending ||
      _category != null ||
      _searchQuery.isNotEmpty;

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _category = null;
      _filter = PredictionFilterTab.trending;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(predictionsReadModelControllerProvider);
    final snapshot = controller.getHome(
      filter: _filter,
      category: _category,
      searchQuery: _searchQuery,
    );
    final hubTotals = controller.getHome();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);
    final showDiscoveryExtras = _searchQuery.isEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-027 PredictionsHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Prediction Markets',
            subtitle: 'Xác suất và sự kiện đang mở',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.markets,
              mode: BackNavigationMode.historyThenFallback,
            ),
            actions: [
              VitHeaderActionItem(
                key: PredictionsHomePage.searchActionKey,
                type: VitHeaderActionType.search,
                onPressed: () =>
                    context.go(AppRoutePaths.marketsPredictionsSearch),
              ),
            ],
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
                    key: PredictionsHomePage.contentKey,
                    padding: AppSpacing.predictionHomeScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: [
                        _PredictionsHero(
                          openEventCount: hubTotals.events.length,
                          openPositionCount: snapshot.openPositionCount,
                          onPositionsTap: () =>
                              context.go(AppRoutePaths.profilePredictions),
                        ),
                        _SearchField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {
                            _searchQuery = value;
                          }),
                          onClear: () => setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          }),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: VitTabBar(
                            variant: VitTabBarVariant.pill,
                            activeKey: _filter.name,
                            onChanged: (key) => setState(
                              () => _filter =
                                  PredictionFilterTab.values.byName(key),
                            ),
                            tabs: const [
                              VitTabItem(
                                key: 'trending',
                                label: 'Xu hướng',
                                icon: Icons.trending_up_outlined,
                                widgetKey: PredictionsHomePage.trendingFilterKey,
                              ),
                              VitTabItem(
                                key: 'newEvents',
                                label: 'Mới',
                                icon: Icons.fiber_new_outlined,
                                widgetKey: PredictionsHomePage.newFilterKey,
                              ),
                              VitTabItem(
                                key: 'popular',
                                label: 'Phổ biến',
                                icon: Icons.group_outlined,
                                widgetKey: Key('sc027_filter_popular'),
                              ),
                              VitTabItem(
                                key: 'liquid',
                                label: 'Thanh khoản',
                                icon: Icons.bar_chart_outlined,
                                widgetKey: Key('sc027_filter_liquid'),
                              ),
                              VitTabItem(
                                key: 'ending',
                                label: 'Sắp đóng',
                                icon: Icons.schedule_outlined,
                                widgetKey: Key('sc027_filter_ending'),
                              ),
                            ],
                          ),
                        ),
                        _CategoryChips(
                          categories: snapshot.categories,
                          activeCategory: _category,
                          onSelected: (value) => setState(() {
                            _category = _category == value ? null : value;
                          }),
                        ),
                        if (showDiscoveryExtras) ...[
                          _BreakingMoversStrip(
                            snapshot: snapshot,
                            onTap: () => context.go(
                              AppRoutePaths.marketsPredictionsBreaking,
                            ),
                          ),
                          _ArenaBridgeCard(
                            onTap: () => context.go(AppRoutePaths.arena),
                          ),
                        ],
                        if (snapshot.highRiskContractId != null)
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Trạng thái thị trường dự đoán',
                            message:
                                'Thiết lập sự kiện, xem trước rủi ro, xác nhận, biên lai, danh mục và hỗ trợ dùng luồng high-risk chung.',
                            contractId: snapshot.highRiskContractId,
                          ),
                        if (snapshot.events.isEmpty)
                          _PredictionsEmptyState(
                            hasActiveFilters: _hasActiveFilters,
                            onClearFilters: _clearFilters,
                            onBreaking: () => context.go(
                              AppRoutePaths.marketsPredictionsBreaking,
                            ),
                          )
                        else
                          for (final event in snapshot.events)
                            _PredictionEventCard(
                              key: PredictionsHomePage.eventCardKey(event.id),
                              event: event,
                              onTap: () => context.go(
                                AppRoutePaths.marketsPredictionEvent(event.id),
                              ),
                            ),
                        const _RiskDisclaimer(),
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
