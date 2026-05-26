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
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

enum _LimitOrderTab { active, history, create }

class LaunchpadLimitOrdersPage extends ConsumerStatefulWidget {
  const LaunchpadLimitOrdersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc315_launchpad_limit_orders_content');
  static const tabsKey = Key('sc315_launchpad_limit_orders_tabs');
  static const statsKey = Key('sc315_launchpad_limit_orders_stats');
  static const activeListKey = Key('sc315_launchpad_limit_orders_active_list');
  static const historyKey = Key('sc315_launchpad_limit_orders_history');
  static const createKey = Key('sc315_launchpad_limit_orders_create');
  static const headerCreateKey = Key(
    'sc315_launchpad_limit_orders_header_create',
  );
  static const tokenFieldKey = Key('sc315_launchpad_limit_orders_token_field');
  static const targetFieldKey = Key(
    'sc315_launchpad_limit_orders_target_field',
  );
  static const amountFieldKey = Key(
    'sc315_launchpad_limit_orders_amount_field',
  );
  static const partialFillKey = Key(
    'sc315_launchpad_limit_orders_partial_fill',
  );
  static const previewKey = Key('sc315_launchpad_limit_orders_preview');
  static const ctaKey = Key('sc315_launchpad_limit_orders_cta');

  static Key orderKey(String id) => Key('sc315_launchpad_limit_order_$id');
  static Key expiryKey(String days) =>
      Key('sc315_launchpad_limit_orders_expiry_$days');
  static Key sideKey(LaunchpadLimitOrderSide side) =>
      Key('sc315_launchpad_limit_orders_side_${side.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadLimitOrdersPage> createState() =>
      _LaunchpadLimitOrdersPageState();
}

class _LaunchpadLimitOrdersPageState
    extends ConsumerState<LaunchpadLimitOrdersPage> {
  late final TextEditingController _tokenController;
  late final TextEditingController _targetPriceController;
  late final TextEditingController _amountController;
  var _activeTab = _LimitOrderTab.active;
  var _orderSide = LaunchpadLimitOrderSide.buy;
  var _expiryDays = '7';
  var _partialFill = true;
  String? _submissionMessage;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: 'ARB');
    _targetPriceController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _targetPriceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getLimitOrders();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final showCta =
        _activeTab == _LimitOrderTab.create &&
        _targetPriceController.text.trim().isNotEmpty &&
        _amountController.text.trim().isNotEmpty;
    final ctaInset = showCta ? 118.0 : 0.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-315 LaunchpadLimitOrdersPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                  trailing: _HeaderCreateButton(
                    onTap: () => setState(() {
                      _activeTab = _LimitOrderTab.create;
                    }),
                  ),
                ),
                _Tabs(
                  activeTab: _activeTab,
                  onChanged: (tab) => setState(() => _activeTab = tab),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadLimitOrdersPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        if (_activeTab == _LimitOrderTab.active) ...[
                          _StatsCard(snapshot: snapshot),
                          _ActiveOrdersSection(orders: snapshot.activeOrders),
                        ] else if (_activeTab == _LimitOrderTab.history) ...[
                          _HistorySection(orders: snapshot.historyOrders),
                        ] else ...[
                          _CreateOrderSection(
                            orderSide: _orderSide,
                            tokenController: _tokenController,
                            targetPriceController: _targetPriceController,
                            amountController: _amountController,
                            expiryDays: _expiryDays,
                            partialFill: _partialFill,
                            submissionMessage: _submissionMessage,
                            onSideChanged: (side) =>
                                setState(() => _orderSide = side),
                            onExpiryChanged: (days) =>
                                setState(() => _expiryDays = days),
                            onPartialFillChanged: (value) =>
                                setState(() => _partialFill = value),
                            onInputChanged: () => setState(() {
                              _submissionMessage = null;
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showCta)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadLimitOrdersPage.ctaKey,
                    onPressed: _submitOrder,
                    leading: const Icon(Icons.add_rounded),
                    child: const Text('Tao Limit Order'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitOrder() {
    final side = _orderSide == LaunchpadLimitOrderSide.buy ? 'BUY' : 'SELL';
    setState(() {
      _submissionMessage =
          'Limit order queued: $side ${_amountController.text.trim()} ${_tokenController.text.trim()} @ \$${_targetPriceController.text.trim()}';
    });
  }
}

class _HeaderCreateButton extends StatelessWidget {
  const _HeaderCreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          key: LaunchpadLimitOrdersPage.headerCreateKey,
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.add_rounded, color: AppColors.text1, size: 20),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _LimitOrderTab activeTab;
  final ValueChanged<_LimitOrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadLimitOrdersPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'active', label: 'Hoat dong'),
          VitTabItem(key: 'history', label: 'Lich su'),
          VitTabItem(key: 'create', label: 'Tao lenh'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_LimitOrderTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final LaunchpadLimitOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadLimitOrdersPage.statsKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _StatCell(
            label: 'Active',
            value: '${snapshot.activeOrders.length}',
            color: AppColors.primary,
          ),
          _StatCell(
            label: 'Filled 24h',
            value: '${snapshot.filled24h}',
            color: AppColors.buy,
          ),
          _StatCell(
            label: 'Value',
            value: snapshot.totalValueLabel,
            color: AppColors.text1,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrdersSection extends StatelessWidget {
  const _ActiveOrdersSection({required this.orders});

  final List<LaunchpadLimitOrderDraft> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyOrders();
    }

    return Container(
      key: LaunchpadLimitOrdersPage.activeListKey,
      child: VitPageSection(
        label: 'Lenh hoat dong',
        accentColor: AppColors.primary,
        children: [for (final order in orders) _LimitOrderCard(order: order)],
      ),
    );
  }
}

class _LimitOrderCard extends StatelessWidget {
  const _LimitOrderCard({required this.order});

  final LaunchpadLimitOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final sideColor = order.side == LaunchpadLimitOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    final distanceColor = order.distancePercent.abs() < 8
        ? AppColors.buy
        : AppColors.warn;
    return VitCard(
      key: LaunchpadLimitOrdersPage.orderKey(order.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SideIcon(side: order.side),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${order.sideLabel} ${order.symbol}',
                          style: AppTextStyles.base.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusPill(status: order.status),
                      ],
                    ),
                    Text(
                      order.token,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _MiniIconButton(
                icon: Icons.edit_outlined,
                color: AppColors.text3,
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.x2),
              _MiniIconButton(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _OrderMetricsGrid(order: order),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Distance to target',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                '${order.distancePercent >= 0 ? '+' : ''}${order.distancePercent.toStringAsFixed(2)}%',
                style: AppTextStyles.micro.copyWith(
                  color: distanceColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          _ProgressBar(
            progress: order.progressToTarget,
            color: order.progressToTarget > 90
                ? sideColor
                : order.progressToTarget > 50
                ? AppColors.warn
                : AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Expires: ${order.expiresAt}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
              ),
              if (order.partialFill)
                _TinyPill(label: 'PARTIAL OK', color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideIcon extends StatelessWidget {
  const _SideIcon({required this.side});

  final LaunchpadLimitOrderSide side;

  @override
  Widget build(BuildContext context) {
    final isBuy = side == LaunchpadLimitOrderSide.buy;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(
        isBuy ? Icons.south_rounded : Icons.north_rounded,
        color: color,
        size: 20,
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}

class _OrderMetricsGrid extends StatelessWidget {
  const _OrderMetricsGrid({required this.order});

  final LaunchpadLimitOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.x3,
      crossAxisSpacing: AppSpacing.x3,
      childAspectRatio: 3.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _MetricBlock(
          label: 'Target Price',
          value: _formatPrice(order.targetPrice),
        ),
        _MetricBlock(
          label: 'Current Price',
          value: _formatPrice(order.currentPrice),
        ),
        _MetricBlock(
          label: 'Amount',
          value: '${_formatAmount(order.amount)} ${order.symbol}',
        ),
        _MetricBlock(
          label: 'Filled',
          value:
              '${_formatAmount(order.filled)} / ${_formatAmount(order.amount)}',
        ),
      ],
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final factor = (progress / 100).clamp(0, 1).toDouble();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                const Positioned.fill(child: ColoredBox(color: AppColors.bg)),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: constraints.maxWidth * factor,
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LaunchpadLimitOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      LaunchpadLimitOrderStatus.active => AppColors.primary,
      LaunchpadLimitOrderStatus.filled => AppColors.buy,
      LaunchpadLimitOrderStatus.cancelled => AppColors.text3,
      LaunchpadLimitOrderStatus.expired => AppColors.sell,
    };
    return _TinyPill(label: status.name.toUpperCase(), color: color);
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.orders});

  final List<LaunchpadLimitOrderDraft> orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadLimitOrdersPage.historyKey,
      child: VitPageSection(
        label: 'Lich su lenh',
        accentColor: AppColors.buy,
        children: [
          for (final order in orders)
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: AppSpacing.x2,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${order.sideLabel} ${order.symbol}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                                _StatusPill(status: order.status),
                              ],
                            ),
                            Text(
                              order.token,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatPrice(order.targetPrice),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${_formatAmount(order.amount)} ${order.symbol}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: AppSpacing.x3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.createdAt,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Icon(
                        order.status == LaunchpadLimitOrderStatus.filled
                            ? Icons.check_circle_rounded
                            : order.status == LaunchpadLimitOrderStatus.expired
                            ? Icons.warning_amber_rounded
                            : Icons.cancel_rounded,
                        size: 15,
                        color: order.status == LaunchpadLimitOrderStatus.filled
                            ? AppColors.buy
                            : order.status == LaunchpadLimitOrderStatus.expired
                            ? AppColors.sell
                            : AppColors.text3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CreateOrderSection extends StatelessWidget {
  const _CreateOrderSection({
    required this.orderSide,
    required this.tokenController,
    required this.targetPriceController,
    required this.amountController,
    required this.expiryDays,
    required this.partialFill,
    required this.submissionMessage,
    required this.onSideChanged,
    required this.onExpiryChanged,
    required this.onPartialFillChanged,
    required this.onInputChanged,
  });

  final LaunchpadLimitOrderSide orderSide;
  final TextEditingController tokenController;
  final TextEditingController targetPriceController;
  final TextEditingController amountController;
  final String expiryDays;
  final bool partialFill;
  final String? submissionMessage;
  final ValueChanged<LaunchpadLimitOrderSide> onSideChanged;
  final ValueChanged<String> onExpiryChanged;
  final ValueChanged<bool> onPartialFillChanged;
  final VoidCallback onInputChanged;

  @override
  Widget build(BuildContext context) {
    final hasPreview =
        targetPriceController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty;
    return Container(
      key: LaunchpadLimitOrdersPage.createKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Loai lenh',
            accentColor: AppColors.primary,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.buy,
                      active: orderSide == LaunchpadLimitOrderSide.buy,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.buy),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SideChoice(
                      side: LaunchpadLimitOrderSide.sell,
                      active: orderSide == LaunchpadLimitOrderSide.sell,
                      onTap: () => onSideChanged(LaunchpadLimitOrderSide.sell),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Chi tiet lenh',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  children: [
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.tokenFieldKey,
                      label: 'Token',
                      controller: tokenController,
                      hintText: 'ARB',
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.targetFieldKey,
                      label: 'Target Price (USD)',
                      controller: targetPriceController,
                      hintText: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _LabeledField(
                      fieldKey: LaunchpadLimitOrdersPage.amountFieldKey,
                      label: 'Amount',
                      controller: amountController,
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: onInputChanged,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Expiry (days)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        for (final value in ['1', '7', '14', '30']) ...[
                          Expanded(
                            child: _ExpiryButton(
                              value: value,
                              active: expiryDays == value,
                              onTap: () => onExpiryChanged(value),
                            ),
                          ),
                          if (value != '30')
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: AppSpacing.x3),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Allow Partial Fill',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Cho phep khop mot phan',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: LaunchpadLimitOrdersPage.partialFillKey,
                          value: partialFill,
                          activeThumbColor: AppColors.primary,
                          onChanged: onPartialFillChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPreview) ...[
            const SizedBox(height: AppSpacing.x4),
            _OrderPreview(
              side: orderSide,
              token: tokenController.text.trim(),
              targetPrice: targetPriceController.text.trim(),
              amount: amountController.text.trim(),
              expiryDays: expiryDays,
              partialFill: partialFill,
            ),
          ],
          if (submissionMessage != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x3),
              borderColor: AppColors.buy20,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      submissionMessage!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SideChoice extends StatelessWidget {
  const _SideChoice({
    required this.side,
    required this.active,
    required this.onTap,
  });

  final LaunchpadLimitOrderSide side;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBuy = side == LaunchpadLimitOrderSide.buy;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return InkWell(
      key: LaunchpadLimitOrdersPage.sideKey(side),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface,
          border: Border.all(color: active ? color : AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Icon(
              isBuy ? Icons.south_rounded : Icons.north_rounded,
              color: active ? color : AppColors.text3,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              isBuy ? 'Buy' : 'Sell',
              style: AppTextStyles.base.copyWith(
                color: active ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              isBuy ? 'Mua khi gia xuong' : 'Ban khi gia len',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? const []
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (_) => onChanged(),
          style: AppTextStyles.base.copyWith(color: AppColors.text1),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
            isDense: true,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.inputRadius,
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpiryButton extends StatelessWidget {
  const _ExpiryButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadLimitOrdersPage.expiryKey(value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.bg,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '${value}d',
          style: AppTextStyles.caption.copyWith(
            color: active ? Colors.white : AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _OrderPreview extends StatelessWidget {
  const _OrderPreview({
    required this.side,
    required this.token,
    required this.targetPrice,
    required this.amount,
    required this.expiryDays,
    required this.partialFill,
  });

  final LaunchpadLimitOrderSide side;
  final String token;
  final String targetPrice;
  final String amount;
  final String expiryDays;
  final bool partialFill;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(targetPrice) ?? 0;
    final size = double.tryParse(amount) ?? 0;
    final sideLabel = side == LaunchpadLimitOrderSide.buy ? 'BUY' : 'SELL';
    return Container(
      key: LaunchpadLimitOrdersPage.previewKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .10),
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Preview',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Type', value: '$sideLabel $token'),
              _PreviewMetric(
                label: 'Total Value',
                value: '\$${(price * size).toStringAsFixed(2)}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _PreviewMetric(label: 'Expires', value: '$expiryDays days'),
              _PreviewMetric(
                label: 'Partial',
                value: partialFill ? 'Yes' : 'No',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x6,
      ),
      child: Column(
        children: [
          const Icon(Icons.schedule_rounded, color: AppColors.text3, size: 42),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'No active orders',
            style: AppTextStyles.base.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Create a limit order to get started',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
