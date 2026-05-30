import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part 'my_arena_page_part_01.dart';
part 'my_arena_page_part_02.dart';
part 'my_arena_page_part_03.dart';
part 'my_arena_page_part_04.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _MyArenaTab { myRooms, joined, savedModes, drafts, history }

enum MyArenaContractScope { profile, arena }

class MyArenaPage extends ConsumerStatefulWidget {
  const MyArenaPage({
    super.key,
    this.shellRenderMode,
    this.contractScope = MyArenaContractScope.profile,
  });

  static const contentKey = Key('sc168_my_arena_content');
  static const createChallengeKey = Key('sc168_create_challenge');
  static const pointsDetailKey = Key('sc168_points_detail');
  static const leaderboardKey = Key('sc168_leaderboard');
  static const discoverKey = Key('sc168_discover');
  static const reportsKey = Key('sc168_reports');
  static const blockedKey = Key('sc168_blocked');
  static const safetyKey = Key('sc168_safety');
  static const tabsScrollKey = Key('sc168_tabs_scroll');

  static Key tabKey(String id) => Key('sc168_tab_$id');
  static Key challengeKey(String id) => Key('sc168_challenge_$id');
  static Key modeKey(String id) => Key('sc168_mode_$id');

  final ShellRenderMode? shellRenderMode;
  final MyArenaContractScope contractScope;

  @override
  ConsumerState<MyArenaPage> createState() => _MyArenaPageState();
}

class _MyArenaPageState extends ConsumerState<MyArenaPage> {
  _MyArenaTab _activeTab = _MyArenaTab.myRooms;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(arenaReadModelControllerProvider);
    final snapshot = switch (widget.contractScope) {
      MyArenaContractScope.profile => repository.getMyArena(),
      MyArenaContractScope.arena => repository.getArenaMy(),
    };
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 78
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.contractScope == MyArenaContractScope.arena
          ? 'SC-205 MyArenaPage'
          : 'SC-168 MyArenaPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Sân chơi của tôi',
              subtitle: 'Quản lý · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MyArenaPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: AppSpacing.x5,
                    children: [
                      _PointsHero(
                        stats: snapshot.stats,
                        onDetails: () => _go(AppRoutePaths.arenaPoints),
                        onEarn: () => _go('/rewards'),
                      ),
                      _StatsGrid(stats: snapshot.stats),
                      VitCtaButton(
                        key: MyArenaPage.createChallengeKey,
                        onPressed: () => _go(AppRoutePaths.arenaStudio),
                        leading: const Icon(Icons.auto_awesome_rounded),
                        child: const Text('Tạo challenge mới'),
                      ),
                      _QuickLinks(
                        onLeaderboard: () =>
                            _go(AppRoutePaths.arenaLeaderboard),
                        onDiscover: () => _go(AppRoutePaths.arena),
                      ),
                      _ArenaTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      _TabContent(
                        tab: _activeTab,
                        snapshot: snapshot,
                        onChallenge: (id) =>
                            _go(AppRoutePaths.arenaChallenge(id)),
                        onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                        onStudio: () => _go(AppRoutePaths.arenaStudio),
                        onDiscover: () => _go(AppRoutePaths.arena),
                      ),
                      _CreatedModesSection(
                        snapshot: snapshot,
                        onTap: () => _go(AppRoutePaths.arenaStudio),
                      ),
                      _RewardAnalyticsSection(
                        history: snapshot.rewardHistory,
                        onViewChallenge: () =>
                            _go(AppRoutePaths.arenaChallenge('sample')),
                      ),
                      _SafetySection(
                        onReports: () => _go(AppRoutePaths.arenaMyReports),
                        onBlocked: () => _go(AppRoutePaths.arenaBlocked),
                        onSafety: () => _go(AppRoutePaths.arenaSafety),
                      ),
                      _ArenaFooter(
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
    context.go(
      widget.contractScope == MyArenaContractScope.arena
          ? AppRoutePaths.arena
          : AppRoutePaths.profile,
    );
  }
}
