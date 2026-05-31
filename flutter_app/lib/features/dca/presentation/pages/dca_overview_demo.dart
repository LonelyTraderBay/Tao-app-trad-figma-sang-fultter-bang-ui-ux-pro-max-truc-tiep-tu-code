import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';

part '../widgets/dca_overview_demo_shell.dart';
part '../widgets/dca_overview_demo_metrics.dart';
part '../widgets/dca_overview_demo_actions.dart';

class DCAOverviewDemo extends ConsumerStatefulWidget {
  const DCAOverviewDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc400_dca_overview_content');
  static const loadingToggleKey = Key('sc400_loading_toggle');
  static const loadingSectionKey = Key('sc400_loading_section');
  static const mobilePreviewKey = Key('sc400_mobile_preview');
  static const footerKey = Key('sc400_footer');

  static Key scenarioKey(String id) => Key('sc400_scenario_$id');
  static Key cardKey(String id) => Key('sc400_card_$id');
  static Key actionKey(String id, String action) => Key('sc400_${id}_$action');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAOverviewDemo> createState() => _DCAOverviewDemoState();
}

class _DCAOverviewDemoState extends ConsumerState<DCAOverviewDemo> {
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(dcaOverviewDemoProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-400 DCAOverviewDemo',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
              trailing: _LoadingToggle(
                active: _showLoading,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _showLoading = !_showLoading);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: DCAOverviewDemo.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.loose,
                  children: [
                    if (_showLoading)
                      _DemoSection(
                        key: DCAOverviewDemo.loadingSectionKey,
                        title: 'Loading State (Skeleton Shimmer)',
                        description: 'Hiệu ứng shimmer khi data đang tải.',
                        child: _DcaOverviewCardPreview(
                          scenario: snapshot.scenarios.first,
                          isLoading: true,
                        ),
                      ),
                    for (final scenario in snapshot.scenarios)
                      _DemoSection(
                        key: DCAOverviewDemo.scenarioKey(scenario.id),
                        title: scenario.title,
                        description: scenario.description,
                        child: _DcaOverviewCardPreview(scenario: scenario),
                      ),
                    _DemoSection(
                      key: DCAOverviewDemo.mobilePreviewKey,
                      title: snapshot.mobilePreview.title,
                      description: snapshot.mobilePreview.description,
                      child: Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderSolid),
                              borderRadius: AppRadii.cardLargeRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.x2),
                              child: _DcaOverviewCardPreview(
                                scenario: snapshot.mobilePreview,
                                compact: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _DemoFooter(snapshot: snapshot),
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
