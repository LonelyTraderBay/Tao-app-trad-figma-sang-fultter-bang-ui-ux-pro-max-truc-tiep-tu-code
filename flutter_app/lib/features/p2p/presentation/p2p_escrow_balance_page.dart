import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PEscrowBalancePage extends ConsumerStatefulWidget {
  const P2PEscrowBalancePage({
    super.key,
    this.initialAsset = 'USDT',
    this.shellRenderMode,
  });

  static const heroKey = Key('sc245_p2p_escrow_hero');
  static const infoKey = Key('sc245_p2p_escrow_info');
  static const tabsKey = Key('sc245_p2p_escrow_tabs');
  static const ordersKey = Key('sc245_p2p_escrow_orders');
  static const helpKey = Key('sc245_p2p_escrow_help');
  static const emptyKey = Key('sc245_p2p_escrow_empty');

  final String initialAsset;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowBalancePage> createState() =>
      _P2PEscrowBalancePageState();
}

class _P2PEscrowBalancePageState extends ConsumerState<P2PEscrowBalancePage> {
  late String _asset;

  @override
  void initState() {
    super.initState();
    _asset = widget.initialAsset;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getEscrowBalance(asset: _asset);
    final selectedAsset = snapshot.selectedAsset;
    final selectedBalance = snapshot.assetBalance(selectedAsset);
    final orders = snapshot.ordersFor(selectedAsset);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    if (_asset != selectedAsset) {
      _asset = selectedAsset;
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-245 P2PEscrowBalancePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _EscrowHeroCard(balance: selectedBalance),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowInfoCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _AssetTabs(
                        assets: snapshot.assets,
                        selectedAsset: selectedAsset,
                        onChanged: (asset) {
                          HapticFeedback.selectionClick();
                          setState(() => _asset = asset);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      if (orders.isEmpty)
                        _EscrowEmptyState(snapshot: snapshot)
                      else
                        _OrdersList(orders: orders),
                      if (orders.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.x5),
                        _EscrowHelpCard(snapshot: snapshot),
                      ],
                    ],
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

class _EscrowHeroCard extends StatelessWidget {
  const _EscrowHeroCard({required this.balance});

  final P2PEscrowAssetBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.inputHeight,
                height: AppSpacing.inputHeight,
                decoration: BoxDecoration(
                  color: AppColors.warn15,
                  borderRadius: AppRadii.lgRadius,
                  border: Border.all(color: AppColors.warningBorder),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng đang escrow',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatAssetAmount(
                        balance.totalAmount,
                        balance.asset,
                        compactVnd: false,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppModuleAccents.p2p,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '${balance.orderCount} đơn hàng đang giữ tiền',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EscrowInfoCard extends StatelessWidget {
  const _EscrowInfoCard({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.infoKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetTabs extends StatelessWidget {
  const _AssetTabs({
    required this.assets,
    required this.selectedAsset,
    required this.onChanged,
  });

  final List<P2PEscrowAssetBalanceDraft> assets;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: P2PEscrowBalancePage.tabsKey,
      activeKey: selectedAsset,
      onChanged: onChanged,
      tabs: [
        for (final asset in assets)
          VitTabItem(
            key: asset.asset,
            label: '${asset.asset} ${asset.orderCount}',
            icon: Icons.lock_outline_rounded,
          ),
      ],
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<P2PEscrowOrderDraft> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PEscrowBalancePage.ordersKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < orders.length; i++) ...[
          _EscrowOrderCard(order: orders[i]),
          if (i != orders.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EscrowOrderCard extends StatelessWidget {
  const _EscrowOrderCard({required this.order});

  final P2PEscrowOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final status = _statusPill(order.status);
    final statusColor = _statusColor(order.status);
    final typeColor = order.type == P2PEscrowOrderType.buy
        ? AppColors.buy
        : AppColors.sell;

    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pOrder(order.canonicalOrderId));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      runSpacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          order.orderId,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        VitStatusPill(
                          label: order.typeLabel,
                          status: order.type == P2PEscrowOrderType.buy
                              ? VitStatusPillStatus.success
                              : VitStatusPillStatus.error,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.text3,
                          size: 12,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Flexible(
                          child: Text(
                            order.counterparty,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: order.statusLabel,
                status: status,
                icon: _statusIcon(order.status),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _OrderMetric(
                  label: 'Số tiền escrow',
                  value: _formatAssetAmount(order.amount, order.asset),
                  valueColor: AppModuleAccents.p2p,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _OrderMetric(
                  label: 'Giá trị',
                  value:
                      '${_formatVnd(order.fiatAmount)} ${order.fiatCurrency}',
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: 12,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Khóa lúc: ${order.lockedAt}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
          if (order.warning != null) ...[
            const SizedBox(height: AppSpacing.x3),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              borderColor: AppColors.sell20,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: statusColor,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      order.warning!,
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
          const SizedBox(height: AppSpacing.x2),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: AppSpacing.x5,
              height: 2,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EscrowHelpCard extends StatelessWidget {
  const _EscrowHelpCard({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.helpKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.article_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.helpTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final bullet in snapshot.helpBullets) ...[
            _HelpBullet(text: bullet),
            if (bullet != snapshot.helpBullets.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _HelpBullet extends StatelessWidget {
  const _HelpBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: AppModuleAccents.p2p,
            size: 12,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _EscrowEmptyState extends StatelessWidget {
  const _EscrowEmptyState({required this.snapshot});

  final P2PEscrowBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PEscrowBalancePage.emptyKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.emptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.emptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

VitStatusPillStatus _statusPill(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => VitStatusPillStatus.warning,
    P2PEscrowOrderStatus.paid => VitStatusPillStatus.info,
    P2PEscrowOrderStatus.pendingRelease => VitStatusPillStatus.success,
    P2PEscrowOrderStatus.dispute => VitStatusPillStatus.error,
  };
}

IconData _statusIcon(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => Icons.schedule_rounded,
    P2PEscrowOrderStatus.paid => Icons.verified_user_outlined,
    P2PEscrowOrderStatus.pendingRelease => Icons.lock_outline_rounded,
    P2PEscrowOrderStatus.dispute => Icons.error_outline_rounded,
  };
}

Color _statusColor(P2PEscrowOrderStatus status) {
  return switch (status) {
    P2PEscrowOrderStatus.pendingPayment => AppColors.warn,
    P2PEscrowOrderStatus.paid => AppColors.primary,
    P2PEscrowOrderStatus.pendingRelease => AppColors.buy,
    P2PEscrowOrderStatus.dispute => AppColors.sell,
  };
}

String _formatAssetAmount(
  double value,
  String asset, {
  bool compactVnd = true,
}) {
  if (asset == 'BTC') {
    return '${value.toStringAsFixed(8)} BTC';
  }
  if (asset == 'VND') {
    return '${_formatVnd(value.round())}${compactVnd ? '' : ' VND'}';
  }
  return '${value.toStringAsFixed(2)} $asset';
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
