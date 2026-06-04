import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part '../widgets/arena_leaderboard_controls.dart';
part '../widgets/arena_leaderboard_body.dart';
part '../widgets/arena_leaderboard_rows_footer.dart';

enum _LeaderboardTab { creators, players, teams }

class ArenaLeaderboardPage extends ConsumerStatefulWidget {
  const ArenaLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc194_leaderboard_content');
  static const creatorRowKey = Key('sc194_creator_row');
  static const risingCreatorKey = Key('sc194_rising_creator');
  static const rulesKey = Key('sc194_rules');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaLeaderboardPage> createState() =>
      _ArenaLeaderboardPageState();
}

class _ArenaLeaderboardPageState extends ConsumerState<ArenaLeaderboardPage> {
  _LeaderboardTab _activeTab = _LeaderboardTab.creators;
  String _activeMetric = 'fair_play';
  String _activeSeason = 'monthly';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaLeaderboard();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-194 ArenaLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Arena Leaderboard',
            subtitle: 'Bảng xếp hạng · Open Arena',
            showBack: true,
            onBack: _close,
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
                    key: ArenaLeaderboardPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x5,
                      children: [
                        _MyRankCard(myRank: snapshot.myRank),
                        _MainTabs(
                          activeTab: _activeTab,
                          onChanged: (tab) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeTab = tab);
                          },
                        ),
                        _MetricChips(
                          chips: snapshot.metricChips,
                          activeMetric: _activeMetric,
                          onChanged: (metric) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeMetric = metric);
                          },
                        ),
                        _SeasonFilters(
                          filters: snapshot.seasonFilters,
                          activeSeason: _activeSeason,
                          onChanged: (season) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeSeason = season);
                          },
                        ),
                        _LeaderboardBody(
                          activeTab: _activeTab,
                          snapshot: snapshot,
                          onCreator: (id) =>
                              _go(AppRoutePaths.arenaCreator(id)),
                        ),
                        _ArenaFooter(
                          disclaimer: snapshot.disclaimer,
                          onRules: () => _go(AppRoutePaths.arenaGuide),
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

  void _go(String route) {
    HapticFeedback.selectionClick();
    context.go(route);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}
