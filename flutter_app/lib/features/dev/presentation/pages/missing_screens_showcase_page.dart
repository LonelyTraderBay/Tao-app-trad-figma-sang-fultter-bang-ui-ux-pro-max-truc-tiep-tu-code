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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/missing_screens_showcase_page_sections.dart';
part '../widgets/missing_screens_showcase_page_common.dart';

class MissingScreensShowcasePage extends ConsumerStatefulWidget {
  const MissingScreensShowcasePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc398_missing_screens_content');
  static const tabsKey = Key('sc398_missing_screens_tabs');
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
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            variant: VitHeaderVariant.custom,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x4,
                AppSpacing.contentPad,
                AppSpacing.x3,
              ),
              child: _ShowcaseTitle(snapshot: snapshot),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: MissingScreensShowcasePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.defaultGap,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
