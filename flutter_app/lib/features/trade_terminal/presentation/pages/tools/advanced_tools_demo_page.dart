import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/hub/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../widgets/tools/advanced_tools_overview.dart';
part '../../widgets/tools/advanced_tools_tabs_sheets.dart';
part '../../widgets/tools/advanced_tools_common.dart';

const _toolsPrimary = AppColors.primary;
const _toolsSpace = AppSpacing.x2;
const _toolsCardSpace = AppSpacing.x3;
const _toolsBodyLineHeight = 1.24;

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

    return Stack(
      children: [
        VitTradeHubScaffold(
          title: 'Công cụ nâng cao',
          subtitle: 'Thang giá · Hàng loạt · Phím tắt',
          semanticLabel: 'SC-062 AdvancedToolsDemoPage',
          contentKey: AdvancedToolsDemoPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.trade,
            mode: BackNavigationMode.historyThenFallback,
          ),
          showProductTabs: true,
          navigationBuilder: buildTradeProductNavigation,
          children: [
            const _IntroCard(),
            const VitCard(
              variant: VitCardVariant.inner,
              density: VitDensity.compact,
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem lại công cụ lệnh nâng cao',
                    message:
                        'Thang giá, hủy hàng loạt và phím tắt giữ xem trước lệnh, xác nhận, số lệnh bị ảnh hưởng và bước tiếp theo trước khi thực thi.',
                    contractId: 'advanced-tools-review',
                    density: VitDensity.compact,
                  ),
                  SizedBox(height: _toolsSpace),
                  VitStatusPill(
                    label: 'Xem trước khi gửi lệnh',
                    status: VitStatusPillStatus.info,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
            for (final feature in snapshot.features)
              _FeatureCard(
                feature: feature,
                onTap: () => _onFeatureTap(feature),
              ),
            const _SpeedCard(),
            const _BenefitsCard(),
            _ProgressCard(items: snapshot.statusItems),
            _ToolsTabs(
              active: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
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
                description: 'Select multiple orders and perform batch actions',
                buttonKey: AdvancedToolsDemoPage.bulkButtonKey,
                label: 'Open Bulk Operations',
                icon: Icons.check_box_rounded,
                colors: const [AppColors.caution, AppColors.medalBronzeMuted],
                onOpen: _openBulkSheet,
              )
            else
              _ActionTab(
                description:
                    'View all keyboard shortcuts and customize key bindings',
                buttonKey: AdvancedToolsDemoPage.shortcutsButtonKey,
                label: 'View Shortcuts Reference',
                icon: Icons.keyboard_rounded,
                colors: const [AppColors.accent, AppColors.accentDark],
                onOpen: _openShortcutsSheet,
              ),
          ],
        ),
        if (_successMessage != null)
          Positioned(
            left: AppSpacing.contentPad,
            right: AppSpacing.contentPad,
            top: mode.usesVisualQaFrame ? AppSpacing.buttonHero : AppSpacing.x5,
            child: VitBanner(
              variant: VitBannerVariant.success,
              message: _successMessage!,
              onDismiss: () => setState(() => _successMessage = null),
            ),
          ),
      ],
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
    final placed = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
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
    final cancelled = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
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
    final triggered = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
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
