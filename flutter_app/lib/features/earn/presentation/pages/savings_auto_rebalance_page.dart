import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part 'savings_auto_rebalance_page_part_01.dart';
part 'savings_auto_rebalance_page_part_02.dart';
part 'savings_auto_rebalance_page_part_03.dart';

TextStyle get _captionMedium =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.medium);
TextStyle get _baseBold =>
    AppTextStyles.base.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _smBold =>
    AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold);

class SavingsAutoRebalancePage extends ConsumerStatefulWidget {
  const SavingsAutoRebalancePage({super.key, this.shellRenderMode});

  static const allocationKey = Key('sc344_allocation');
  static const driftStatusKey = Key('sc344_drift_status');
  static const driftChartKey = Key('sc344_drift_chart');
  static const autoStatusKey = Key('sc344_auto_status');
  static const statsKey = Key('sc344_stats');
  static const previewButtonKey = Key('sc344_preview_button');
  static const previewSheetKey = Key('sc344_preview_sheet');

  static Key tabKey(String tab) => Key('sc344_tab_$tab');
  static Key strategyKey(String id) => Key('sc344_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAutoRebalancePage> createState() =>
      _SavingsAutoRebalancePageState();
}

class _SavingsAutoRebalancePageState
    extends ConsumerState<SavingsAutoRebalancePage> {
  String? _tab;
  String? _strategyId;
  bool? _autoEnabled;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsAutoRebalanceRepositoryProvider)
        .getRebalance();
    final activeTab = _tab ?? snapshot.defaultTab;
    final strategy = _activeStrategy(snapshot);
    final drift = _totalDrift(snapshot.positions, strategy);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const footerHeight = 92.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final showFooter = activeTab == snapshot.defaultTab && drift >= 3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-344 SavingsAutoRebalancePage',
      child: Material(
        color: AppColors.bg,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        bottom: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.contentPad,
                      ),
                      child: VitTabBar(
                        variant: VitTabBarVariant.underline,
                        activeKey: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                        tabs: [
                          for (final tab in snapshot.tabs)
                            VitTabItem(key: tab, label: tab),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          if (activeTab == 'Tổng quan') ...[
                            _AllocationComparisonCard(
                              snapshot: snapshot,
                              strategy: strategy,
                            ),
                            _DriftStatusCard(
                              drift: drift,
                              threshold: snapshot.settings.driftThreshold,
                              onPreview: _openPreview,
                            ),
                            _DriftHistoryCard(points: snapshot.driftHistory),
                            _AutoStatusCard(
                              autoEnabled:
                                  _autoEnabled ?? snapshot.settings.autoEnabled,
                              settings: snapshot.settings,
                              onChanged: (value) =>
                                  setState(() => _autoEnabled = value),
                            ),
                            _StatsRow(snapshot: snapshot, strategy: strategy),
                          ] else if (activeTab == 'Chiến lược') ...[
                            _StrategyList(
                              snapshot: snapshot,
                              activeId: strategy.id,
                              onChanged: (id) {
                                HapticFeedback.selectionClick();
                                setState(() => _strategyId = id);
                              },
                            ),
                            _StrategyComparison(
                              strategies: snapshot.strategies,
                            ),
                          ] else if (activeTab == 'Lịch sử')
                            _HistoryList(history: snapshot.history)
                          else
                            _SettingsPanel(
                              settings: snapshot.settings,
                              autoEnabled:
                                  _autoEnabled ?? snapshot.settings.autoEnabled,
                              onAutoChanged: (value) =>
                                  setState(() => _autoEnabled = value),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showFooter)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: SavingsAutoRebalancePage.previewButtonKey,
                    onPressed: _openPreview,
                    leading: const Icon(Icons.sync_rounded),
                    child: const Text('Tái cân bằng ngay'),
                  ),
                ),
              ),
            if (_showPreview)
              Positioned.fill(
                child: _PreviewSheet(
                  snapshot: snapshot,
                  strategy: strategy,
                  drift: drift,
                  onClose: () => setState(() => _showPreview = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SavingsRebalanceStrategyDraft _activeStrategy(
    SavingsAutoRebalanceSnapshot snapshot,
  ) {
    final id = _strategyId ?? snapshot.defaultStrategyId;
    return snapshot.strategies.firstWhere(
      (item) => item.id == id,
      orElse: () => snapshot.strategies.first,
    );
  }

  void _openPreview() {
    HapticFeedback.selectionClick();
    setState(() => _showPreview = true);
  }
}
