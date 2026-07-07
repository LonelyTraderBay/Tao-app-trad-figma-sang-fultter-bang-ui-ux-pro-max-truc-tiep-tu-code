import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

part '../widgets/route_checker_page_sections.dart';
part '../widgets/route_checker_page_common.dart';

enum _DevUiMode { live, loading, empty, error, offline }

class RouteChecker extends ConsumerStatefulWidget {
  const RouteChecker({super.key, this.shellRenderMode});

  static const contentKey = Key('sc325_route_checker_content');
  static const resetButtonKey = Key('sc325_route_checker_reset');
  static const statesKey = Key('sc325_route_checker_states');
  static Key phaseKey(int? phase) => Key('sc325_phase_${phase ?? 'all'}');
  static Key routeKey(String path) => Key('sc325_route_$path');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RouteChecker> createState() => _RouteCheckerState();
}

class _RouteCheckerState extends ConsumerState<RouteChecker> {
  final Set<String> _testedRoutes = {};
  int? _activePhase;
  _DevUiMode _uiMode = _DevUiMode.live;

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
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: RouteChecker.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.devScrollPadding(bottomInset),
                  child: VitPageContent(
 rhythm: VitPageRhythm.flush,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _DevStateBar(
                        key: RouteChecker.statesKey,
                        supportedStates: snapshot.supportedStates,
                        active: _uiMode,
                        onChanged: (mode) {
                          HapticFeedback.selectionClick();
                          setState(() => _uiMode = mode);
                        },
                      ),
                      switch (_uiMode) {
                        _DevUiMode.loading => const _RouteCheckerLoading(),
                        _DevUiMode.empty => VitEmptyState(
                          title: 'No routes in this phase',
                          message:
                              'Switch phase filter or return to live data.',
                          actionLabel: 'Show all routes',
                          onAction: () => setState(() {
                            _uiMode = _DevUiMode.live;
                            _activePhase = null;
                          }),
                        ),
                        _DevUiMode.error => VitErrorState(
                          title: 'Route checker unavailable',
                          message:
                              'Could not load the route registry. Retry when back online.',
                          onAction: () =>
                              setState(() => _uiMode = _DevUiMode.live),
                        ),
                        _DevUiMode.offline => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VitOfflineBanner(
                              detail: 'Local route checks still work offline.',
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            ..._liveSections(
                              snapshot: snapshot,
                              filteredRoutes: filteredRoutes,
                            ),
                          ],
                        ),
                        _DevUiMode.live => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: filteredRoutes.isEmpty
                              ? [
                                  VitEmptyState(
                                    title: 'No routes in this phase',
                                    message:
                                        'Pick another phase or reset the filter.',
                                    actionLabel: 'Show all routes',
                                    onAction: () => setState(
                                      () => _activePhase = null,
                                    ),
                                  ),
                                ]
                              : _liveSections(
                                  snapshot: snapshot,
                                  filteredRoutes: filteredRoutes,
                                ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _liveSections({
    required RouteCheckerSnapshot snapshot,
    required List<DevRouteDraft> filteredRoutes,
  }) {
    return [
      _IntroBlock(snapshot: snapshot),
      _ProgressCard(
        testedCount: _testedRoutes.length,
        totalCount: snapshot.totalRoutes,
      ),
      VitPageSection(
        label: 'Phase filter',
        children: [
          _PhaseFilters(
            snapshot: snapshot,
            activePhase: _activePhase,
            onChanged: (phase) {
              HapticFeedback.selectionClick();
              setState(() => _activePhase = phase);
            },
          ),
        ],
      ),
      VitPageSection(
        label: 'Routes',
        children: [
          _RouteList(
            routes: filteredRoutes,
            testedRoutes: _testedRoutes,
            onTapRoute: (route) {
              HapticFeedback.selectionClick();
              setState(() => _testedRoutes.add(route.path));
            },
          ),
        ],
      ),
      _ActionsRow(
        testedCount: _testedRoutes.length,
        totalCount: snapshot.totalRoutes,
        onReset: () {
          HapticFeedback.selectionClick();
          setState(_testedRoutes.clear);
        },
      ),
      _PhaseStats(snapshot: snapshot, testedRoutes: _testedRoutes),
      _InternalNotice(text: snapshot.contractNotes),
    ];
  }
}

class _DevStateBar extends StatelessWidget {
  const _DevStateBar({
    super.key,
    required this.supportedStates,
    required this.active,
    required this.onChanged,
  });

  final Set<DevScreenState> supportedStates;
  final _DevUiMode active;
  final ValueChanged<_DevUiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <VitPresetChipItem<_DevUiMode>>[
      const VitPresetChipItem(value: _DevUiMode.live, label: 'Live'),
      if (supportedStates.contains(DevScreenState.loading))
        const VitPresetChipItem(value: _DevUiMode.loading, label: 'Loading'),
      if (supportedStates.contains(DevScreenState.empty))
        const VitPresetChipItem(value: _DevUiMode.empty, label: 'Empty'),
      if (supportedStates.contains(DevScreenState.error))
        const VitPresetChipItem(value: _DevUiMode.error, label: 'Error'),
      if (supportedStates.contains(DevScreenState.offline))
        const VitPresetChipItem(value: _DevUiMode.offline, label: 'Offline'),
    ];

    return VitPageSection(
      label: 'Screen states',
      children: [
        VitPresetChipRow<_DevUiMode>(
          items: items,
          selectedValue: active,
          onTap: onChanged,
          accentColor: AppModuleAccents.dev,
        ),
      ],
    );
  }
}

class _RouteCheckerLoading extends StatelessWidget {
  const _RouteCheckerLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 4);
  }
}
