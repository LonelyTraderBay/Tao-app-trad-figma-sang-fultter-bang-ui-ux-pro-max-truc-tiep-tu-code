import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

export 'copy_trading_list.dart';

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

/// Prepends [VitTradeProductTabs] when [showProductTabs] is true.
List<Widget> tradeShellWithProductTabs({
  required BuildContext context,
  required List<Widget> children,
  bool showProductTabs = true,
  String? activeProductId,
  TradePair? productPair,
  Key Function(String id)? quickNavKey,
}) {
  if (!showProductTabs) {
    return children;
  }
  final pair = productPair ?? kTradeShellDefaultPair;
  final nav = buildTradeProductNavigation(
    context: context,
    pair: pair,
    activeId: activeProductId ?? '',
    quickNavKey: quickNavKey,
  );
  return [
    VitTradeProductTabs(
      activeId: activeProductId ?? '',
      tabs: nav.tabs,
      overflowItems: nav.overflow,
    ),
    ...children,
  ];
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
    this.useCopyTradingInset = false,
    this.showProductTabs = true,
    this.activeProductId,
    this.productPair,
    this.quickNavKey,
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
  final bool useCopyTradingInset;
  final bool showProductTabs;
  final String? activeProductId;
  final TradePair? productPair;
  final Key Function(String id)? quickNavKey;

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
            ),
            Expanded(
              child: VitInsetScrollView(
                key: contentKey,
                bottomInset: resolvedInset,
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  children: tradeShellWithProductTabs(
                    context: context,
                    children: children,
                    showProductTabs: showProductTabs,
                    activeProductId: activeProductId,
                    productPair: productPair,
                    quickNavKey: quickNavKey,
                  ),
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
    this.showProductTabs = true,
    this.activeProductId,
    this.productPair,
    this.quickNavKey,
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
  final bool showProductTabs;
  final String? activeProductId;
  final TradePair? productPair;
  final Key Function(String id)? quickNavKey;

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
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: tradeShellWithProductTabs(
                context: context,
                children: children,
                showProductTabs: showProductTabs,
                activeProductId: activeProductId,
                productPair: productPair,
                quickNavKey: quickNavKey,
              ),
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

/// Home-aligned 2-KPI hero strip for bot sub-pages (mirrors SC-059 hub).
class VitBotSubpageHero extends StatelessWidget {
  const VitBotSubpageHero({
    super.key,
    required this.primaryLabel,
    required this.primaryValue,
    required this.secondaryLabel,
    required this.secondaryValue,
    this.primaryColor,
    this.secondaryColor,
  });

  final String primaryLabel;
  final String primaryValue;
  final String secondaryLabel;
  final String secondaryValue;
  final Color? primaryColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  primaryValue,
                  style: AppTextStyles.heroNumber.copyWith(
                    color: primaryColor ?? AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: AppSpacing.x6,
            color: AppColors.border,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    secondaryLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    secondaryValue,
                    style: AppTextStyles.heroNumber.copyWith(
                      color: secondaryColor ?? AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat risk review footer — no card-in-card nesting.
class VitBotRiskReviewFooter extends StatelessWidget {
  const VitBotRiskReviewFooter({
    super.key,
    required this.title,
    required this.message,
    this.contractId,
    this.statusLabel,
    this.status = VitStatusPillStatus.info,
  });

  final String title;
  final String message;
  final String? contractId;
  final String? statusLabel;
  final VitStatusPillStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: title,
          message: message,
          contractId: contractId,
          density: VitDensity.compact,
        ),
        if (statusLabel != null) ...[
          const SizedBox(height: AppSpacing.x2),
          VitStatusPill(
            label: statusLabel!,
            status: status,
            size: VitStatusPillSize.sm,
          ),
        ],
        const SizedBox(height: AppSpacing.x3),
        const VitBotRiskDisclaimer(),
      ],
    );
  }
}

/// Hub-aligned risk micro-disclaimer.
class VitBotRiskDisclaimer extends StatelessWidget {
  const VitBotRiskDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bot không đảm bảo lợi nhuận. Hiệu suất quá khứ không đại diện kết quả tương lai.',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      textAlign: TextAlign.center,
    );
  }
}
