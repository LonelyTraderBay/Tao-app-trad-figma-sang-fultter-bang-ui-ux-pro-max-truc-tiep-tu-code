import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_allocation.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_calculations.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_deviation.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_hero.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_strategy.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_suggestions.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class LaunchpadRebalancePage extends ConsumerStatefulWidget {
  const LaunchpadRebalancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc312_launchpad_rebalance_content');
  static const heroKey = Key('sc312_launchpad_rebalance_hero');
  static const strategyKey = Key('sc312_launchpad_rebalance_strategies');
  static const allocationKey = Key('sc312_launchpad_rebalance_allocation');
  static const deviationKey = Key('sc312_launchpad_rebalance_deviation');
  static const suggestionsKey = Key('sc312_launchpad_rebalance_suggestions');
  static const summaryKey = Key('sc312_launchpad_rebalance_summary');
  static const warningKey = Key('sc312_launchpad_rebalance_warning');
  static const previewKey = Key('sc312_launchpad_rebalance_preview');
  static const confirmSheetKey = Key('sc312_launchpad_rebalance_confirm_sheet');
  static const confirmKey = Key('sc312_launchpad_rebalance_confirm');
  static const cancelKey = Key('sc312_launchpad_rebalance_cancel');

  static Key strategyButtonKey(String id) =>
      Key('sc312_launchpad_rebalance_strategy_$id');
  static Key suggestionKey(String id) =>
      Key('sc312_launchpad_rebalance_suggestion_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadRebalancePage> createState() =>
      _LaunchpadRebalancePageState();
}

class _LaunchpadRebalancePageState
    extends ConsumerState<LaunchpadRebalancePage> {
  late String _strategyId;
  var _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _strategyId = ref
        .read(launchpadControllerProvider)
        .getRebalance()
        .defaultStrategyId;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getRebalance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const footerHeight = 92.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final strategy = snapshot.strategies.firstWhere(
      (item) => item.id == _strategyId,
      orElse: () => snapshot.strategies.first,
    );
    final assets = launchpadRebalanceAssetsWithTargets(
      snapshot.assets,
      strategy,
    );
    final suggestions = launchpadRebalanceSuggestionsFor(assets);
    final totalValue = assets.fold<double>(
      0,
      (sum, asset) => sum + asset.currentValue,
    );
    final totalDeviation = suggestions.fold<double>(
      0,
      (sum, item) => sum + item.deviation.abs(),
    );
    final txCount = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .length;
    final totalGas = txCount * 1.5;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-312 LaunchpadRebalancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: bottomInset,
              semanticLabel: 'SC-312 LaunchpadRebalancePage scroll surface',
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadRebalancePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      LaunchpadRebalanceHero(
                        key: LaunchpadRebalancePage.heroKey,
                        totalValue: totalValue,
                        assetCount: assets.length,
                        totalDeviation: totalDeviation,
                      ),
                      LaunchpadRebalanceStrategySection(
                        sectionKey: LaunchpadRebalancePage.strategyKey,
                        strategies: snapshot.strategies,
                        activeId: _strategyId,
                        strategyButtonKey:
                            LaunchpadRebalancePage.strategyButtonKey,
                        onChanged: (id) => setState(() => _strategyId = id),
                      ),
                      LaunchpadRebalanceAllocationCard(
                        key: LaunchpadRebalancePage.allocationKey,
                        assets: assets,
                      ),
                      LaunchpadRebalanceDeviationCard(
                        key: LaunchpadRebalancePage.deviationKey,
                        assets: assets,
                      ),
                      LaunchpadRebalanceSuggestionsSection(
                        sectionKey: LaunchpadRebalancePage.suggestionsKey,
                        suggestionKey: LaunchpadRebalancePage.suggestionKey,
                        suggestions: suggestions,
                      ),
                      LaunchpadRebalanceSummaryCard(
                        key: LaunchpadRebalancePage.summaryKey,
                        txCount: txCount,
                        totalGas: totalGas,
                        strategy: strategy,
                      ),
                      const LaunchpadRebalanceWarningBanner(
                        key: LaunchpadRebalancePage.warningKey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: navInset + safeBottom,
              child: VitStickyFooter(
                backgroundColor: AppColors.surface.withValues(alpha: .94),
                child: VitCtaButton(
                  key: LaunchpadRebalancePage.previewKey,
                  onPressed: () => setState(() => _showConfirm = true),
                  child: const Text('Xem lai & Thuc hien Rebalance'),
                ),
              ),
            ),
            if (_showConfirm)
              Positioned.fill(
                child: LaunchpadRebalanceConfirmSheet(
                  sheetKey: LaunchpadRebalancePage.confirmSheetKey,
                  confirmKey: LaunchpadRebalancePage.confirmKey,
                  cancelKey: LaunchpadRebalancePage.cancelKey,
                  suggestions: suggestions,
                  totalGas: totalGas,
                  bottomInset: navInset,
                  onClose: () => setState(() => _showConfirm = false),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
