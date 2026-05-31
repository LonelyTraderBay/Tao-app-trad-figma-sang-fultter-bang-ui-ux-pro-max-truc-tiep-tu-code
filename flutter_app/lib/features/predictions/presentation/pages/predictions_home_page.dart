import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
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
  PredictionFilterTab _filter = PredictionFilterTab.trending;
  String? _category;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getHome(
          filter: _filter,
          category: _category,
          searchQuery: _searchQuery,
        );
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
      semanticLabel: 'SC-027 PredictionsHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Prediction Markets',
              subtitle: 'Thị trường dự đoán',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
              trailing: SizedBox(
                key: PredictionsHomePage.searchActionKey,
                width: 36,
                height: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.searchBg,
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: IconButton(
                    onPressed: () =>
                        context.go(AppRoutePaths.marketsPredictionsSearch),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.text1,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsHomePage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 13,
                    children: [
                      _SearchField(
                        value: _searchQuery,
                        onChanged: (value) => setState(() {
                          _searchQuery = value;
                        }),
                        onClear: () => setState(() {
                          _searchQuery = '';
                        }),
                      ),
                      _FilterTabs(
                        active: _filter,
                        onSelected: (value) => setState(() {
                          _filter = value;
                        }),
                      ),
                      _CategoryChips(
                        categories: snapshot.categories,
                        activeCategory: _category,
                        onSelected: (value) => setState(() {
                          _category = value;
                        }),
                      ),
                      if (_searchQuery.isEmpty) ...[
                        _PredictionCtaCard(
                          key: PredictionsHomePage.myPredictionsKey,
                          title: 'My Predictions',
                          subtitle:
                              '${snapshot.openPositionCount} open positions',
                          color: AppColors.accent,
                          icon: Icons.work_outline_rounded,
                          onTap: () =>
                              context.go(AppRoutePaths.profilePredictions),
                        ),
                        _BreakingMoversCard(
                          snapshot: snapshot,
                          onTap: () => context.go(
                            AppRoutePaths.marketsPredictionsBreaking,
                          ),
                        ),
                        _ArenaBridgeCard(
                          onTap: () => context.go(AppRoutePaths.arena),
                        ),
                      ],
                      if (snapshot.events.isEmpty)
                        const _PredictionsEmptyState()
                      else
                        for (final event in snapshot.events)
                          _PredictionEventCard(
                            key: PredictionsHomePage.eventCardKey(event.id),
                            event: event,
                            onTap: () => context.go(
                              AppRoutePaths.marketsPredictionEvent(event.id),
                            ),
                          ),
                    ],
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
