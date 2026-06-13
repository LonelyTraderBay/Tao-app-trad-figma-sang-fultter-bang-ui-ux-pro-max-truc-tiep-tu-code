part of '../pages/launchpad_limit_orders_page.dart';

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
                  const Divider(
                    height: AppSpacing.launchpadDividerHeight,
                    color: AppColors.border,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.createdAt,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Icon(
                        order.status == LaunchpadLimitOrderStatus.filled
                            ? Icons.check_circle_rounded
                            : order.status == LaunchpadLimitOrderStatus.expired
                            ? Icons.warning_amber_rounded
                            : Icons.cancel_rounded,
                        size: AppSpacing.launchpadIconLg,
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
