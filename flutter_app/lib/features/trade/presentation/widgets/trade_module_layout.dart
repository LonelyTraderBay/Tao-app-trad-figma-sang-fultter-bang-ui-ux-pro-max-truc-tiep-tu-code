import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';

/// Home-aligned bottom scroll clearance for L2 trade detail/hub pages.
double tradeScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final base = mode.usesVisualQaFrame
      ? AppSpacing.buttonStandard + AppSpacing.x7
      : AppSpacing.buttonStandard + AppSpacing.x5;
  return base + MediaQuery.paddingOf(context).bottom;
}

/// Copy-trading hub uses dedicated inset tokens (taller hero/footer).
double copyTradingScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final base = mode.usesVisualQaFrame
      ? AppSpacing.copyTradingBottomInsetVisual
      : AppSpacing.copyTradingBottomInsetNative;
  return base + MediaQuery.paddingOf(context).bottom;
}

/// L1 instrument terminals (Trade/Futures/Margin) with portfolio dock.
double tradeTerminalScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final chromeInset = mode.usesVisualQaFrame
      ? DeviceMetrics.bottomChrome
      : DeviceMetrics.nativeBottomChrome;
  final extra = mode.usesVisualQaFrame
      ? AppSpacing.tradeBottomInsetVisual
      : AppSpacing.tradeBottomInsetNative;
  return chromeInset + MediaQuery.paddingOf(context).bottom + extra;
}

/// Section rhythm wrapper: VitSectionHeader + x3 gap + child.
class VitTradeSection extends StatelessWidget {
  const VitTradeSection({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.headerTrailing,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: VitSectionHeader(
                title: title,
                actionLabel: actionLabel,
                onAction: onAction,
              ),
            ),
            if (headerTrailing != null) ...[
              const SizedBox(width: AppSpacing.x2),
              headerTrailing!,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.tradePageContentGap),
        child,
      ],
    );
  }
}

/// L2 detail scaffold for trade sub-flows (margin, bots, copy, regulatory).
class VitTradeDetailScaffold extends StatelessWidget {
  const VitTradeDetailScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.bottomInset,
    this.shellRenderMode,
    this.headerActions = const [],
    this.trailing,
    this.useCopyTradingInset = false,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final double? bottomInset;
  final ShellRenderMode? shellRenderMode;
  final List<VitHeaderActionItem> headerActions;
  final Widget? trailing;
  final bool useCopyTradingInset;

  @override
  Widget build(BuildContext context) {
    final resolvedInset = bottomInset ??
        (useCopyTradingInset
            ? copyTradingScrollBottomInset(
                context,
                shellRenderMode: shellRenderMode,
              )
            : tradeScrollBottomInset(
                context,
                shellRenderMode: shellRenderMode,
              ));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHeader(
              title: title,
              subtitle: subtitle,
              showBack: showBack,
              onBack: onBack,
              backKey: backKey,
              actions: headerActions,
              trailing: trailing,
            ),
            Expanded(
              child: VitInsetScrollView(
                key: contentKey,
                bottomInset: resolvedInset,
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// L2 hub with auto-hide header — matches Home scroll shell grammar.
class VitTradeHubScaffold extends StatelessWidget {
  const VitTradeHubScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.shellRenderMode,
    this.useCopyTradingInset = false,
    this.headerActions = const [],
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final ShellRenderMode? shellRenderMode;
  final bool useCopyTradingInset;
  final List<VitHeaderActionItem> headerActions;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scrollEndClearance = useCopyTradingInset
        ? copyTradingScrollBottomInset(
            context,
            shellRenderMode: shellRenderMode,
          )
        : tradeScrollBottomInset(
            context,
            shellRenderMode: shellRenderMode,
          );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
            backKey: backKey,
            actions: headerActions,
            trailing: trailing,
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

/// L1 instrument workspace scroll shell (spot-like surfaces).
class VitTradeWorkspaceScaffold extends StatelessWidget {
  const VitTradeWorkspaceScaffold({
    super.key,
    required this.semanticLabel,
    required this.children,
    this.contentKey,
    this.shellRenderMode,
    this.bottomInset,
  });

  final String semanticLabel;
  final List<Widget> children;
  final Key? contentKey;
  final ShellRenderMode? shellRenderMode;
  final double? bottomInset;

  @override
  Widget build(BuildContext context) {
    final resolvedInset = bottomInset ??
        tradeTerminalScrollBottomInset(
          context,
          shellRenderMode: shellRenderMode,
        );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: VitInsetScrollView(
          key: contentKey,
          bottomInset: resolvedInset,
          child: VitPageContent(
            padding: VitContentPadding.compact,
            density: VitDensity.compact,
            children: children,
          ),
        ),
      ),
    );
  }
}
