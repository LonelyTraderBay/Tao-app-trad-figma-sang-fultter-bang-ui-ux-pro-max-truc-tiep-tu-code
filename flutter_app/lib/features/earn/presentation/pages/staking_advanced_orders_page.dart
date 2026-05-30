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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.track_changes_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          for (var i = 0; i < snapshot.statCards.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatTile(stat: snapshot.statCards[i])),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingAdvancedOrderStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final isSuccess = stat.tone == 'success';
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      borderColor: isSuccess ? AppColors.buy20 : null,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: isSuccess ? AppColors.buy : AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({required this.active, required this.onChanged});

  final _AdvancedOrderTab active;
  final ValueChanged<_AdvancedOrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingAdvancedOrdersPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _AdvancedOrderTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingAdvancedOrdersPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final StakingAdvancedOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.orderKey(order.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _orderIcon(order.type),
                color: _orderTone(order.type),
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderTypeLabel(order.type),
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${order.asset} · Trigger: ${order.trigger.toStringAsFixed(order.trigger == 0.90 ? 1 : 2)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatAmount(order.amount)} ${order.asset}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _StatusPill(status: order.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.borderSolid),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Created: ${_formatDate(order.created)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (order.status == StakingAdvancedOrderStatus.active)
                Text(
                  'Cancel',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingAdvancedOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      StakingAdvancedOrderStatus.active => AppColors.buy,
      StakingAdvancedOrderStatus.triggered => AppColors.primarySoft,
      StakingAdvancedOrderStatus.cancelled => AppColors.text3,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: switch (status) {
          StakingAdvancedOrderStatus.active => AppColors.buy15,
          StakingAdvancedOrderStatus.triggered => AppColors.primary15,
          StakingAdvancedOrderStatus.cancelled => AppColors.surface3,
        },
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingAdvancedOrdersPage.howItWorksKey,
      label: 'How It Works',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < snapshot.howItWorks.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                Text(
                  snapshot.howItWorks[i].title,
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.howItWorks[i].description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.riskKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.riskTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.riskBody,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _CreateOrderSheet extends StatefulWidget {
  const _CreateOrderSheet({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  State<_CreateOrderSheet> createState() => _CreateOrderSheetState();
}

class _CreateOrderSheetState extends State<_CreateOrderSheet> {
  StakingAdvancedOrderType _selected = StakingAdvancedOrderType.takeProfit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingAdvancedOrdersPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Create Order', style: AppTextStyles.sectionTitle),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Order Type',
            child: Row(
              children: [
                for (
                  var i = 0;
                  i < widget.snapshot.orderTypeOptions.length;
                  i++
                )
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : AppSpacing.x2,
                      ),
                      child: _TypeButton(
                        type: widget.snapshot.orderTypeOptions[i],
                        selected:
                            _selected == widget.snapshot.orderTypeOptions[i],
                        onTap: () => setState(
                          () => _selected = widget.snapshot.orderTypeOptions[i],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Liquid Staking Token',
            child: _StaticField(
              value: widget.snapshot.assetOptions.first,
              trailing: Icons.expand_more_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: _triggerLabel(_selected),
            child: _InputPreview(
              hint: _selected == StakingAdvancedOrderType.trailingStop
                  ? '5'
                  : '1.10',
              suffix: _selected == StakingAdvancedOrderType.trailingStop
                  ? '%'
                  : 'ETH',
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            widget.snapshot.currentPriceLabel,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Amount',
            child: const _InputPreview(hint: '0.00', suffix: 'Max'),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            widget.snapshot.availableLabel,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    widget.snapshot.orderTypeWarnings[_selected] ?? '',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Create ${_orderTypeLabel(_selected)}'),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final StakingAdvancedOrderType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: StakingAdvancedOrdersPage.typeKey(type),
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          height: AppSpacing.inputHeight,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.primarySoft : AppColors.borderSolid,
            ),
          ),
          child: Center(
            child: Text(
              _orderTypeLabel(type),
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.onAccent : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _StaticField extends StatelessWidget {
  const _StaticField({required this.value, required this.trailing});

  final String value;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          Icon(trailing, color: AppColors.text2, size: AppSpacing.iconSm),
        ],
      ),
    );
  }
}

class _InputPreview extends StatelessWidget {
  const _InputPreview({required this.hint, required this.suffix});

  final String hint;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final isMax = suffix == 'Max';
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          ),
          if (isMax)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x1,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadii.smRadius,
              ),
              child: Text(
                suffix,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            )
          else
            Text(
              suffix,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

String _tabLabel(_AdvancedOrderTab tab) {
  return switch (tab) {
    _AdvancedOrderTab.active => 'Active',
    _AdvancedOrderTab.history => 'History',
  };
}

String _orderTypeLabel(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => 'Take Profit',
    StakingAdvancedOrderType.stopLoss => 'Stop Loss',
    StakingAdvancedOrderType.trailingStop => 'Trailing Stop',
  };
}

String _statusLabel(StakingAdvancedOrderStatus status) {
  return switch (status) {
    StakingAdvancedOrderStatus.active => 'Active',
    StakingAdvancedOrderStatus.triggered => 'Triggered',
    StakingAdvancedOrderStatus.cancelled => 'Cancelled',
  };
}

String _triggerLabel(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => 'Trigger Price (Take Profit At)',
    StakingAdvancedOrderType.stopLoss => 'Stop Price (Exit If Below)',
    StakingAdvancedOrderType.trailingStop => 'Trailing Distance (%)',
  };
}

IconData _orderIcon(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => Icons.trending_up_rounded,
    StakingAdvancedOrderType.stopLoss => Icons.trending_down_rounded,
    StakingAdvancedOrderType.trailingStop => Icons.track_changes_rounded,
  };
}

Color _orderTone(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => AppColors.buy,
    StakingAdvancedOrderType.stopLoss => AppColors.sell,
    StakingAdvancedOrderType.trailingStop => AppColors.warn,
  };
}

String _formatDate(String value) {
  final parts = value.split('-');
  if (parts.length != 3) return value;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
