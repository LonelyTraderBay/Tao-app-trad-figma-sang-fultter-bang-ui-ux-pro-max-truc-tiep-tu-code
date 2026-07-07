import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../widgets/arena_leaderboard_controls.dart';
part '../widgets/arena_leaderboard_body.dart';
part '../widgets/arena_leaderboard_rows_footer.dart';

enum _LeaderboardTab { creators, players, teams }

const _arenaAccent = AppModuleAccents.arena;
const double _leaderboardVisualScrollClearance = 108;
const double _leaderboardNativeScrollClearance = 72;
const double _leaderboardPodiumSideSize =
    AppSpacing.buttonCompact + AppSpacing.x2;
const double _leaderboardPodiumWinnerSize = AppSpacing.ctaHeight;
const double _leaderboardPodiumBorderWidth = AppSpacing.hairlineStroke;
const double _leaderboardPodiumShadowBlur = AppSpacing.ctaElevationBlur;
const double _leaderboardPodiumShadowSpread = AppSpacing.ctaElevationSpread;
const double _leaderboardPodiumIcon = AppSpacing.iconMd;
const double _leaderboardLineHeight = 1.0;
const double _leaderboardDividerHeight = AppSpacing.dividerHairline;
const double _leaderboardSectionMarkerWidth = AppSpacing.pageSectionAccentWidth;
const double _leaderboardSectionMarkerHeight = AppSpacing.rowPy + AppSpacing.x1;
const double _leaderboardMyRankIconBox = AppSpacing.buttonCompact;
const double _leaderboardMyRankIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _leaderboardFilterIcon = AppSpacing.iconSm;
const double _leaderboardRowRankWidth = AppSpacing.iconLg;
const double _leaderboardRowAvatar = AppSpacing.buttonCompact;
const double _leaderboardRowIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _leaderboardFairPlayIcon = AppSpacing.x3 + AppSpacing.x1;
const double _leaderboardRisingIcon = AppSpacing.iconSm;
const double _leaderboardCompactIcon = AppSpacing.iconMd + AppSpacing.x2;
const double _leaderboardFooterShieldIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _leaderboardFooterLineHeight = 1.25;
const EdgeInsetsDirectional _leaderboardFilterPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsDirectional _leaderboardRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x3,
    );
const EdgeInsetsDirectional _leaderboardPodiumPadding =
    EdgeInsetsDirectional.only(top: AppSpacing.x1, bottom: AppSpacing.x3);

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
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _leaderboardVisualScrollClearance
            : _leaderboardNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-194 ArenaLeaderboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bảng xếp hạng',
            subtitle: 'Fair play · Open Arena',
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
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
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
                          onRules: () => _go(AppRoutePaths.arenaSafety),
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
