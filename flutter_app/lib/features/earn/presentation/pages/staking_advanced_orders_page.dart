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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_advanced_orders_overview_orders.dart';
part '../widgets/staking_advanced_orders_guidance.dart';
part '../widgets/staking_advanced_orders_sheet_fields.dart';

enum _AdvancedOrderTab { active, history }

class StakingAdvancedOrdersPage extends ConsumerStatefulWidget {
  const StakingAdvancedOrdersPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc366_info_banner');
  static const statsKey = Key('sc366_stats');
  static const createButtonKey = Key('sc366_create_order');
  static const tabsKey = Key('sc366_tabs');
  static const createSheetKey = Key('sc366_create_sheet');
  static const howItWorksKey = Key('sc366_how_it_works');
  static const riskKey = Key('sc366_risk');

  static Key tabKey(String id) => Key('sc366_tab_$id');

  static Key orderKey(String id) => Key('sc366_order_$id');

  static Key typeKey(StakingAdvancedOrderType type) =>
      Key('sc366_order_type_${type.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAdvancedOrdersPage> createState() =>
      _StakingAdvancedOrdersPageState();
}

class _StakingAdvancedOrdersPageState
    extends ConsumerState<StakingAdvancedOrdersPage> {
  _AdvancedOrderTab _tab = _AdvancedOrderTab.active;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAdvancedOrdersRepositoryProvider)
        .getAdvancedOrders();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final orders = _tab == _AdvancedOrderTab.active
        ? snapshot.activeOrders
        : snapshot.orderHistory;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-366 StakingAdvancedOrdersPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _StatsCard(snapshot: snapshot),
                    VitCtaButton(
                      key: StakingAdvancedOrdersPage.createButtonKey,
                      leading: const Icon(Icons.add_rounded),
                      onPressed: () => _showCreateOrder(snapshot),
                      child: const Text('Create Order'),
                    ),
                    _OrderTabs(
                      active: _tab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    VitPageSection(
                      label: _tab == _AdvancedOrderTab.active
                          ? 'Active Orders'
                          : 'Order History',
                      accentColor: AppColors.primarySoft,
                      children: [
                        for (final order in orders) _OrderCard(order: order),
                      ],
                    ),
                    _HowItWorks(snapshot: snapshot),
                    _RiskDisclosure(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateOrder(StakingAdvancedOrdersSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateOrderSheet(snapshot: snapshot)),
    );
  }
}
