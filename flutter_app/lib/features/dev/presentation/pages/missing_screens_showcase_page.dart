import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
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

part '../widgets/missing_screens_showcase_page_sections.dart';
part '../widgets/missing_screens_showcase_page_common.dart';

enum _DevUiMode { live, loading, empty, error, offline }

class MissingScreensShowcasePage extends ConsumerStatefulWidget {
  const MissingScreensShowcasePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc398_missing_screens_content');
  static const tabsKey = Key('sc398_missing_screens_tabs');
  static const statesKey = Key('sc398_missing_screens_states');
  static const newSectionKey = Key('sc398_missing_screens_new');
  static const v2SectionKey = Key('sc398_missing_screens_v2');
  static Key screenKey(String id) => Key('sc398_screen_$id');
  static Key v2PageKey(String id) => Key('sc398_v2_$id');
  static Key flowKey(String id) => Key('sc398_flow_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MissingScreensShowcasePage> createState() =>
      _MissingScreensShowcasePageState();
}

class _MissingScreensShowcasePageState
    extends ConsumerState<MissingScreensShowcasePage> {
  String _activeTab = 'new';
  _DevUiMode _uiMode = _DevUiMode.live;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(missingScreensShowcaseControllerProvider)
        .snapshot();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-398 MissingScreensShowcasePage',
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
                  key: MissingScreensShowcasePage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.devScrollPadding(bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.defaultGap,
                    children: [
                      _DevStateBar(
                        key: MissingScreensShowcasePage.statesKey,
                        supportedStates: snapshot.supportedStates,
                        active: _uiMode,
                        onChanged: (mode) {
                          HapticFeedback.selectionClick();
                          setState(() => _uiMode = mode);
                        },
                      ),
                      switch (_uiMode) {
                        _DevUiMode.loading => const _ShowcaseLoading(),
                        _DevUiMode.empty => const VitEmptyState(
                          title: 'No showcase entries',
                          message:
                              'Add missing screens to the dev registry to preview flows here.',
                        ),
                        _DevUiMode.error => VitErrorState(
                          title: 'Showcase unavailable',
                          message:
                              'Could not load screen catalog. Retry when back online.',
                          onAction: () =>
                              setState(() => _uiMode = _DevUiMode.live),
                        ),
                        _DevUiMode.offline => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const VitOfflineBanner(
                              detail: 'Cached routes remain navigable offline.',
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            ..._liveSections(snapshot),
                          ],
                        ),
                        _DevUiMode.live => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _liveSections(snapshot),
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

  List<Widget> _liveSections(MissingScreensShowcaseSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Catalog',
        children: [
          VitTabBar(
            key: MissingScreensShowcasePage.tabsKey,
            tabs: [
              for (final tab in snapshot.tabs)
                VitTabItem(key: tab.id, label: tab.label),
            ],
            activeKey: _activeTab,
            onChanged: (tab) {
              HapticFeedback.selectionClick();
              setState(() => _activeTab = tab);
            },
            variant: VitTabBarVariant.segment,
          ),
          if (_activeTab == 'new')
            _NewScreensSection(snapshot: snapshot)
          else
            _V2ScreensSection(snapshot: snapshot),
        ],
      ),
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

class _ShowcaseLoading extends StatelessWidget {
  const _ShowcaseLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 3);
  }
}
