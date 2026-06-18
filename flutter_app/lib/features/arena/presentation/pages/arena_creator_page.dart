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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part '../widgets/arena_creator_hero_trust.dart';
part '../widgets/arena_creator_tabs.dart';
part '../widgets/arena_creator_common.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _CreatorTab { modes, live, history, about }

class ArenaCreatorPage extends ConsumerStatefulWidget {
  const ArenaCreatorPage({
    super.key,
    required this.creatorId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc193_creator_content');
  static const trustDetailKey = Key('sc193_trust_detail');
  static const viewModeKey = Key('sc193_view_mode');
  static const useModeKey = Key('sc193_use_mode');
  static const policyKey = Key('sc193_policy');

  static Key modeKey(String id) => Key('sc193_mode_$id');

  final String creatorId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaCreatorPage> createState() => _ArenaCreatorPageState();
}

class _ArenaCreatorPageState extends ConsumerState<ArenaCreatorPage> {
  _CreatorTab _activeTab = _CreatorTab.modes;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaCreator(widget.creatorId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-193 ArenaCreatorPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Creator Profile',
            subtitle: 'Nhà sáng tạo · Open Arena',
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
                    key: ArenaCreatorPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.arenaBottomScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      customGap: AppSpacing.x3,
                      children: [
                        _CreatorHero(
                          creator: snapshot.creator,
                          onTrust: () => _go(
                            AppRoutePaths.arenaTrust(snapshot.creator.id),
                          ),
                        ),
                        _TrustSection(
                          metrics: snapshot.trustMetrics,
                          onDetails: () => _go(
                            AppRoutePaths.arenaTrust(snapshot.creator.id),
                          ),
                        ),
                        VitTabBar(
                          tabs: const [
                            VitTabItem(key: 'modes', label: 'Modes'),
                            VitTabItem(key: 'live', label: 'Live Rooms'),
                            VitTabItem(key: 'history', label: 'Lịch sử'),
                            VitTabItem(key: 'about', label: 'Giới thiệu'),
                          ],
                          activeKey: _activeTab.name,
                          variant: VitTabBarVariant.segment,
                          onChanged: (key) {
                            HapticFeedback.selectionClick();
                            setState(() => _activeTab = _tabFromKey(key));
                          },
                        ),
                        _TabContent(
                          activeTab: _activeTab,
                          snapshot: snapshot,
                          onMode: (id) => _go(AppRoutePaths.arenaMode(id)),
                          onUseMode: () => _go(AppRoutePaths.arenaStudio),
                        ),
                        _PolicyLink(
                          label: snapshot.policyLabel,
                          onTap: () => _go(AppRoutePaths.arenaSafety),
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

  _CreatorTab _tabFromKey(String key) {
    return _CreatorTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _CreatorTab.modes,
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
