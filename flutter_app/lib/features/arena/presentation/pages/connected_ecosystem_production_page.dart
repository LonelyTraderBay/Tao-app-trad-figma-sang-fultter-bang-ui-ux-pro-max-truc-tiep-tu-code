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

part 'connected_ecosystem_production_page_part_01.dart';
part 'connected_ecosystem_production_page_part_02.dart';
part 'connected_ecosystem_production_page_part_03.dart';

enum _EcosystemSection { canonical, states, flows, registry, handoff }

class ConnectedEcosystemProductionPage extends ConsumerStatefulWidget {
  const ConnectedEcosystemProductionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc208_ecosystem_content');
  static const tabsKey = Key('sc208_ecosystem_tabs');

  static Key tabKey(String id) => Key('sc208_tab_$id');
  static Key screenKey(String name) => Key('sc208_screen_$name');
  static Key flowStepKey(String flowId, String label) =>
      Key('sc208_flow_${flowId}_$label');
  static Key handoffKey(String id) => Key('sc208_handoff_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ConnectedEcosystemProductionPage> createState() =>
      _ConnectedEcosystemProductionPageState();
}

class _ConnectedEcosystemProductionPageState
    extends ConsumerState<ConnectedEcosystemProductionPage> {
  _EcosystemSection _activeSection = _EcosystemSection.canonical;
  String _activeHandoffBoard = 'routes';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getConnectedEcosystemProduction();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-208 ConnectedEcosystemProductionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: '09E - Connected Ecosystem',
              subtitle: 'Release Readiness',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ConnectedEcosystemProductionPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      const _EcosystemHero(),
                      _SectionTabs(
                        active: _activeSection,
                        onChanged: (section) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeSection = section);
                        },
                      ),
                      _ActiveSection(
                        section: _activeSection,
                        snapshot: snapshot,
                        activeHandoffBoard: _activeHandoffBoard,
                        onHandoffBoardChanged: (board) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeHandoffBoard = board);
                        },
                        onRoute: (route) => _go(context, route),
                      ),
                      _EcosystemFooter(text: snapshot.footerDisclosure),
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

  void _go(BuildContext context, String route) {
    HapticFeedback.selectionClick();
    context.go(_resolveConnectedRoute(route));
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}
