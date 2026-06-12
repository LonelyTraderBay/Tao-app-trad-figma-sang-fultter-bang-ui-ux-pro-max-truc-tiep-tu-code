part of '../pages/launchpad_limit_orders_page.dart';

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
                    fontSize: AppSpacing.launchpadFontSm,
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
          const Divider(
            height: AppSpacing.launchpadDividerHeight,
            color: AppColors.border,
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: AppSpacing.launchpadIconXs,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Expires: ${order.expiresAt}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: AppSpacing.launchpadFontSm,
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
      width: AppSpacing.launchpadBox40,
      height: AppSpacing.launchpadBox40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(
        isBuy ? Icons.south_rounded : Icons.north_rounded,
        color: color,
        size: AppSpacing.launchpadIcon3xl,
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
      width: AppSpacing.launchpadBox32,
      height: AppSpacing.launchpadBox32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: AppRadii.smRadius,
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: AppSpacing.launchpadIconXl),
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
      crossAxisCount: AppSpacing.launchpadGridColumns,
      mainAxisSpacing: AppSpacing.x3,
      crossAxisSpacing: AppSpacing.x3,
      childAspectRatio: AppSpacing.launchpadGridAspectAction,
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
            fontSize: AppSpacing.launchpadFontSm,
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
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: AppSpacing.launchpadDotSm,
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
            fontSize: AppSpacing.launchpadFontXxs,
            height: AppSpacing.launchpadLineHeightTight,
          ),
        ),
      ),
    );
  }
}
