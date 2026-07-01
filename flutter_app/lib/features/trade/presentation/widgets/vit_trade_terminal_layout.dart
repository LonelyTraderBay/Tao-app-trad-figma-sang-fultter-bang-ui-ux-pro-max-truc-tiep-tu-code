import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_module_components.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_segmented_choice.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_tab_bar.dart';

/// Charts-focused vs trade-focused terminal modes (Bybit-style).
enum VitTradeViewMode { charts, trade }

/// Product tab descriptor for horizontal product switcher.
final class VitTradeProductTab {
  const VitTradeProductTab({
    required this.id,
    required this.label,
    required this.onTap,
    this.tabKey,
  });

  final String id;
  final String label;
  final VoidCallback onTap;
  final Key? tabKey;
}

/// Overflow hub tile for the "more products" sheet.
final class VitTradeProductOverflowItem {
  const VitTradeProductOverflowItem({
    required this.id,
    required this.label,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.tileKey,
  });

  final String id;
  final String label;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final Key? tileKey;
}

/// Bybit-style horizontal product tabs: Spot / Futures / Margin / Convert.
class VitTradeProductTabs extends StatelessWidget {
  const VitTradeProductTabs({
    super.key,
    required this.tabs,
    required this.activeId,
    this.overflowItems = const [],
    this.moreSheetTitle = 'Thêm sản phẩm',
  });

  final List<VitTradeProductTab> tabs;
  final String activeId;
  final List<VitTradeProductOverflowItem> overflowItems;
  final String moreSheetTitle;

  void _openMoreSheet(BuildContext context) {
    if (overflowItems.isEmpty) return;
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      builder: (sheetContext) {
        return VitSheetPanel(
          title: moreSheetTitle,
          child: Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x3,
            children: [
              for (final item in overflowItems)
                SizedBox(
                  width: (MediaQuery.sizeOf(sheetContext).width -
                          AppSpacing.contentPad * 2 -
                          AppSpacing.x3) /
                      2,
                  child: VitServiceTile(
                    key: item.tileKey,
                    density: VitServiceTileDensity.compact,
                    icon: item.icon,
                    label: item.label,
                    accentColor: item.accentColor,
                    badgeLabel: item.badge,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      item.onTap();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.x2),
                  _ProductTabChip(
                    key: tabs[i].tabKey,
                    label: tabs[i].label,
                    active: tabs[i].id == activeId,
                    onTap: tabs[i].onTap,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (overflowItems.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.x2),
          VitCard(
            onTap: () => _openMoreSheet(context),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.x3,
              right: AppSpacing.x3,
              top: AppSpacing.x2,
              bottom: AppSpacing.x2,
            ),
            borderColor: AppColors.borderSolid,
            child: Text(
              'Thêm',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductTabChip extends StatelessWidget {
  const _ProductTabChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x4,
        right: AppSpacing.x4,
        top: AppSpacing.x2,
        bottom: AppSpacing.x2,
      ),
      borderColor: active ? AppColors.primary.withValues(alpha: .45) : AppColors.borderSolid,
      background: active
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .10),
              ),
            )
          : null,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.primary : AppColors.text2,
          fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
        ),
      ),
    );
  }
}

/// Charts / Trade mode toggle.
class VitTradeViewModeToggle extends StatelessWidget {
  const VitTradeViewModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
    this.chartsKey,
    this.tradeKey,
  });

  final VitTradeViewMode mode;
  final ValueChanged<VitTradeViewMode> onChanged;
  final Key? chartsKey;
  final Key? tradeKey;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice.withPrimaryAccent<VitTradeViewMode>(
      selected: mode,
      onChanged: onChanged,
      options: [
        VitSegmentedChoiceOption(
          key: chartsKey,
          value: VitTradeViewMode.charts,
          label: 'Charts',
        ),
        VitSegmentedChoiceOption(
          key: tradeKey,
          value: VitTradeViewMode.trade,
          label: 'Trade',
        ),
      ],
    );
  }
}

/// Side-by-side order form + order book (Trade mode).
class VitTradeSplitPanel extends StatelessWidget {
  const VitTradeSplitPanel({
    super.key,
    required this.form,
    required this.marketPanel,
    this.formFlex = 58,
    this.marketFlex = 42,
  });

  final Widget form;
  final Widget marketPanel;
  final int formFlex;
  final int marketFlex;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: formFlex, child: form),
          const SizedBox(width: AppSpacing.x2),
          Expanded(flex: marketFlex, child: marketPanel),
        ],
      ),
    );
  }
}

/// Collapsible positions / orders / history panel — inline in scroll, hidden by default.
class VitTradePortfolioPanel extends StatefulWidget {
  const VitTradePortfolioPanel({
    super.key,
    required this.tabs,
    required this.activeKey,
    required this.onChanged,
    required this.child,
    this.title = 'Vị thế & lệnh',
    this.expandKey,
    this.initiallyExpanded = false,
  });

  final List<VitTabItem> tabs;
  final String activeKey;
  final ValueChanged<String> onChanged;
  final Widget child;
  final String title;
  final Key? expandKey;
  final bool initiallyExpanded;

  @override
  State<VitTradePortfolioPanel> createState() => _VitTradePortfolioPanelState();
}

class _VitTradePortfolioPanelState extends State<VitTradePortfolioPanel> {
  late bool _expanded = widget.initiallyExpanded;

  String get _summary => widget.tabs.map((tab) => tab.label).join(' · ');

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      padding: AppSpacing.zeroInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            key: widget.expandKey,
            onTap: () => setState(() => _expanded = !_expanded),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.x4,
              right: AppSpacing.x3,
              top: AppSpacing.x3,
              bottom: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: _expanded ? AppColors.primary : AppColors.text2,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.control.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      if (!_expanded) ...[
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          _summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.tradeHeaderChevron,
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(height: 1, color: AppColors.divider),
                      Padding(
                        padding: AppSpacing.zeroInsets.copyWith(
                          left: AppSpacing.contentPad,
                          right: AppSpacing.contentPad,
                          top: AppSpacing.x2,
                        ),
                        child: VitTabBar(
                          variant: VitTabBarVariant.underline,
                          tabs: widget.tabs,
                          activeKey: widget.activeKey,
                          onChanged: widget.onChanged,
                        ),
                      ),
                      Padding(
                        padding: AppSpacing.zeroInsets.copyWith(
                          left: AppSpacing.contentPad,
                          right: AppSpacing.contentPad,
                          top: AppSpacing.x2,
                          bottom: AppSpacing.x3,
                        ),
                        child: widget.child,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Main Bybit-style trade terminal scaffold.
class VitTradeTerminalLayout extends StatelessWidget {
  const VitTradeTerminalLayout({
    super.key,
    required this.semanticLabel,
    required this.scrollKey,
    required this.header,
    required this.bodyChildren,
    required this.scrollBottomInset,
    this.ticker,
    this.productTabs,
    this.viewModeToggle,
    this.portfolioPanel,
    this.footer,
  });

  final String semanticLabel;
  final Key scrollKey;
  final Widget header;
  final List<Widget> bodyChildren;
  final double scrollBottomInset;
  final Widget? ticker;
  final Widget? productTabs;
  final Widget? viewModeToggle;
  final Widget? portfolioPanel;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(
              child: VitInsetScrollView(
                key: scrollKey,
                bottomInset: scrollBottomInset,
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  children: [
                    if (ticker != null) ticker!,
                    if (productTabs != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      productTabs!,
                    ],
                    if (viewModeToggle != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      viewModeToggle!,
                    ],
                    const SizedBox(height: AppSpacing.x3),
                    ...bodyChildren,
                    if (portfolioPanel != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      portfolioPanel!,
                    ],
                    if (footer != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      footer!,
                    ],
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

/// Reusable instrument header for trade terminals.
class VitTradeTerminalHeader extends StatelessWidget {
  const VitTradeTerminalHeader({
    super.key,
    required this.symbol,
    required this.onPairTap,
    this.showBack = false,
    this.onBack,
    this.backKey,
    this.leading,
    this.trailing,
    this.subtitle,
  });

  final String symbol;
  final VoidCallback onPairTap;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.instrument,
      showBack: showBack,
      onBack: onBack,
      backKey: backKey,
      leading: leading,
      body: Semantics(
        button: true,
        label: 'Chọn cặp giao dịch $symbol',
        child: VitCard(
          onTap: onPairTap,
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.standard,
          padding: AppSpacing.tradeHeaderBodyPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      symbol,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle,
                    ),
                    if (subtitle != null) subtitle!,
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.tradeHeaderChevronGap),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text2,
                size: AppSpacing.tradeHeaderChevron,
              ),
            ],
          ),
        ),
      ),
      trailing: trailing,
    );
  }
}
