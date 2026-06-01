import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/route_checker_page_sections.dart';
part '../widgets/route_checker_page_common.dart';

class RouteChecker extends ConsumerStatefulWidget {
  const RouteChecker({super.key, this.shellRenderMode});

  static const contentKey = Key('sc325_route_checker_content');
  static const resetButtonKey = Key('sc325_route_checker_reset');
  static Key phaseKey(int? phase) => Key('sc325_phase_${phase ?? 'all'}');
  static Key routeKey(String path) => Key('sc325_route_$path');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RouteChecker> createState() => _RouteCheckerState();
}

class _RouteCheckerState extends ConsumerState<RouteChecker> {
  final Set<String> _testedRoutes = {};
  int? _activePhase;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(routeCheckerControllerProvider).snapshot();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final filteredRoutes = _activePhase == null
        ? snapshot.routes
        : snapshot.routes
              .where((route) => route.phase == _activePhase)
              .toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-325 RouteChecker',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: RouteChecker.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    _IntroBlock(snapshot: snapshot),
                    _ProgressCard(
                      testedCount: _testedRoutes.length,
                      totalCount: snapshot.totalRoutes,
                    ),
                    _PhaseFilters(
                      snapshot: snapshot,
                      activePhase: _activePhase,
                      onChanged: (phase) {
                        HapticFeedback.selectionClick();
                        setState(() => _activePhase = phase);
                      },
                    ),
                    _RouteList(
                      routes: filteredRoutes,
                      testedRoutes: _testedRoutes,
                      onTapRoute: (route) {
                        HapticFeedback.selectionClick();
                        setState(() => _testedRoutes.add(route.path));
                      },
                    ),
                    _ActionsRow(
                      testedCount: _testedRoutes.length,
                      totalCount: snapshot.totalRoutes,
                      onReset: () {
                        HapticFeedback.selectionClick();
                        setState(_testedRoutes.clear);
                      },
                    ),
                    _PhaseStats(
                      snapshot: snapshot,
                      testedRoutes: _testedRoutes,
                    ),
                    _InternalNotice(text: snapshot.contractNotes),
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
