import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/advanced_tools_overview.dart';
part '../widgets/advanced_tools_tabs_sheets.dart';
part '../widgets/advanced_tools_common.dart';

const _toolsPrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;

enum _ToolsTab { ladder, bulk, shortcuts }

class AdvancedToolsDemoPage extends ConsumerStatefulWidget {
  const AdvancedToolsDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc062_advanced_tools_scroll_content');
  static const ladderButtonKey = Key('sc062_open_ladder');
  static const bulkButtonKey = Key('sc062_open_bulk');
  static const shortcutsButtonKey = Key('sc062_open_shortcuts');
  static const ladderSubmitKey = Key('sc062_submit_ladder');
  static const bulkCancelKey = Key('sc062_bulk_cancel');
  static const shortcutTriggerKey = Key('sc062_shortcut_trigger');

  static Key tabKey(String id) => Key('sc062_tab_$id');
  static Key featureKey(String id) => Key('sc062_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedToolsDemoPage> createState() =>
      _AdvancedToolsDemoPageState();
}

class _AdvancedToolsDemoPageState extends ConsumerState<AdvancedToolsDemoPage> {
  _ToolsTab _tab = _ToolsTab.ladder;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeAdvancedToolsControllerProvider)
        .state
        .snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-062 AdvancedToolsDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Advanced Trading Tools',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: AdvancedToolsDemoPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _IntroCard(),
                        const SizedBox(height: 12),
                        for (final feature in snapshot.features) ...[
                          _FeatureCard(
                            feature: feature,
                            onTap: () => _onFeatureTap(feature),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const _SpeedCard(),
                        const SizedBox(height: 12),
                        const _BenefitsCard(),
                        const SizedBox(height: 12),
                        _ProgressCard(items: snapshot.statusItems),
                        const SizedBox(height: 18),
                        _ToolsTabs(
                          active: _tab,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 14),
                        if (_tab == _ToolsTab.ladder)
                          _ActionTab(
                            description:
                                'Click any price level on the order book to place instant orders',
                            buttonKey: AdvancedToolsDemoPage.ladderButtonKey,
                            label: 'Open Ladder Trading',
                            icon: Icons.track_changes_rounded,
                            colors: const [AppColors.buy, AppColors.buyDark],
                            onOpen: _openLadderSheet,
                          )
                        else if (_tab == _ToolsTab.bulk)
                          _ActionTab(
                            description:
                                'Select multiple orders and perform batch actions',
                            buttonKey: AdvancedToolsDemoPage.bulkButtonKey,
                            label: 'Open Bulk Operations',
                            icon: Icons.check_box_rounded,
                            colors: const [
                              AppColors.caution,
                              AppColors.medalBronzeMuted,
                            ],
                            onOpen: _openBulkSheet,
                          )
                        else
                          _ActionTab(
                            description:
                                'View all keyboard shortcuts and customize key bindings',
                            buttonKey: AdvancedToolsDemoPage.shortcutsButtonKey,
                            label: 'View Shortcuts Reference',
                            icon: Icons.keyboard_rounded,
                            colors: const [
                              AppColors.accent,
                              AppColors.accentDark,
                            ],
                            onOpen: _openShortcutsSheet,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_successMessage != null)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: _SuccessToast(
                message: _successMessage!,
                onClose: () => setState(() => _successMessage = null),
              ),
            ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeAdvancedToolFeature feature) {
    if (feature.id == 'bulk') {
      setState(() => _tab = _ToolsTab.bulk);
      _openBulkSheet();
      return;
    }
    if (feature.id == 'shortcuts') {
      setState(() => _tab = _ToolsTab.shortcuts);
      _openShortcutsSheet();
      return;
    }
    setState(() => _tab = _ToolsTab.ladder);
    _openLadderSheet();
  }

  Future<void> _openLadderSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider);
    final placed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _LadderSheet(orders: controller.state.snapshot.ladderOrders),
    );
    if (placed != true || !mounted) return;
    controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'ladder',
        action: 'place-order',
      ),
    );
    setState(() => _successMessage = 'Buy Order Placed · 0.5 BTC');
  }

  Future<void> _openBulkSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider);
    final orderIds = controller.state.snapshot.bulkOrders
        .map((order) => order.id)
        .toList(growable: false);
    final cancelled = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _BulkSheet(orders: controller.state.snapshot.bulkOrders),
    );
    if (cancelled != true || !mounted) return;
    final result = controller.submitAction(
      TradeAdvancedToolActionRequest(
        toolId: 'bulk',
        action: 'cancel',
        orderIds: orderIds,
      ),
    );
    setState(
      () => _successMessage = '${result.affectedCount} orders cancelled',
    );
  }

  Future<void> _openShortcutsSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider);
    final triggered = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _ShortcutsSheet(shortcuts: controller.state.snapshot.shortcuts),
    );
    if (triggered != true || !mounted) return;
    controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'shortcuts',
        action: 'trigger',
      ),
    );
    setState(() => _successMessage = 'Shortcut triggered · Quick Buy');
  }
}
