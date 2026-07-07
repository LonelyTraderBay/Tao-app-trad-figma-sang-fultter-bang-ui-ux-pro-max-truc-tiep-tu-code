import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';

/// Default bottom scroll clearance for P2P L2 flow pages (nav + safe area).
double p2pFlowScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
  double visualNavClearance =
      DeviceMetrics.safeBottom + DeviceMetrics.tabBar,
  double nativeNavClearanceOffset = AppSpacing.x4,
  double visualClearance = AppSpacing.x3,
  double nativeClearance = AppSpacing.x2,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final bottomSafe = MediaQuery.paddingOf(context).bottom;
  if (mode.usesVisualQaFrame) {
    return visualNavClearance + visualClearance + bottomSafe;
  }
  return (visualNavClearance - nativeNavClearanceOffset) +
      nativeClearance +
      bottomSafe;
}

/// L2 detail scaffold for P2P flow pages — owns a single [VitPageContent].
class VitP2PFlowScaffold extends StatelessWidget {
  const VitP2PFlowScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.headerActions = const [],
    this.bottomInset,
    this.shellRenderMode,
    this.backgroundColor = AppColors.bg,
    this.rhythm = VitPageRhythm.standard,
    this.contentGap = VitContentGap.defaultGap,
    this.scrollChild,
    this.onRefresh,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final List<VitHeaderActionItem> headerActions;
  final double? bottomInset;
  final ShellRenderMode? shellRenderMode;
  final Color backgroundColor;
  final VitPageRhythm rhythm;
  final VitContentGap contentGap;
  final Widget? scrollChild;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final resolvedInset = bottomInset ??
        p2pFlowScrollBottomInset(context, shellRenderMode: shellRenderMode);
    final scrollBody = VitInsetScrollView(
      key: contentKey,
      bottomInset: resolvedInset,
      physics: onRefresh != null
          ? const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            )
          : null,
      child: scrollChild ??
          VitPageContent(
            rhythm: rhythm,
            padding: VitContentPadding.compact,
            density: VitDensity.compact,
            gap: contentGap,
            children: children,
          ),
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        color: backgroundColor,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
            backKey: backKey,
            actions: headerActions,
          ),
          child: onRefresh == null
              ? scrollBody
              : RefreshIndicator(
                  color: AppModuleAccents.p2p,
                  backgroundColor: AppColors.surface2,
                  onRefresh: onRefresh!,
                  child: scrollBody,
                ),
        ),
      ),
    );
  }
}
