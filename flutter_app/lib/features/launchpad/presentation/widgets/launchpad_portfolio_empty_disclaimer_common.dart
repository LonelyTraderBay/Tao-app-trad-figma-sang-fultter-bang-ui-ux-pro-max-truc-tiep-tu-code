part of '../pages/launchpad_portfolio_page.dart';

class _EmptyPortfolio extends StatelessWidget {
  const _EmptyPortfolio({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.launchpadPaddingX5,
      child: Column(
        children: [
          const Icon(
            Icons.business_center_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa có dự án nào',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Bạn chưa tham gia dự án Launchpad nào. Khám phá ngay.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () => context.go(route),
            leading: const Icon(Icons.rocket_launch_outlined),
            child: const Text('Khám phá Launchpad'),
          ),
        ],
      ),
    );
  }
}

class _PortfolioDisclaimer extends StatelessWidget {
  const _PortfolioDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: LaunchpadPortfolioPage.disclaimerKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Phân bổ thực tế phụ thuộc vào tổng số đăng ký. Token mở khóa theo lịch vesting của từng dự án.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppSpacing.launchpadLineHeightReadable,
            ),
          ),
        ),
      ],
    );
  }
}

enum _PortfolioTab {
  all('all', 'Tất cả'),
  pending('pending', 'Đang chờ'),
  allocated('allocated', 'Đã phân bổ'),
  claimed('claimed', 'Đã nhận');

  const _PortfolioTab(this.id, this.label);

  final String id;
  final String label;
}

final class _StatusStyle {
  const _StatusStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

List<LaunchpadSubscriptionDraft> _subscriptionsFor(
  List<LaunchpadSubscriptionDraft> subscriptions,
  _PortfolioTab tab,
) {
  return switch (tab) {
    _PortfolioTab.all => subscriptions,
    _PortfolioTab.pending =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.pending,
          )
          .toList(),
    _PortfolioTab.allocated =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.allocated ||
                subscription.status ==
                    LaunchpadSubscriptionStatus.partiallyAllocated,
          )
          .toList(),
    _PortfolioTab.claimed =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.claimed ||
                subscription.status == LaunchpadSubscriptionStatus.refunded,
          )
          .toList(),
  };
}

_StatusStyle _statusStyle(LaunchpadSubscriptionStatus status) {
  return switch (status) {
    LaunchpadSubscriptionStatus.pending => const _StatusStyle(
      label: 'Chờ phân bổ',
      color: AppColors.warn,
    ),
    LaunchpadSubscriptionStatus.allocated => const _StatusStyle(
      label: 'Đã phân bổ',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.partiallyAllocated => const _StatusStyle(
      label: 'Phân bổ 1 phần',
      color: AppColors.primary,
    ),
    LaunchpadSubscriptionStatus.claimed => const _StatusStyle(
      label: 'Đã nhận',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.refunded => const _StatusStyle(
      label: 'Đã hoàn tiền',
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  return '\$${_withCommas(fixed)}';
}

String _formatInt(int value) => _withCommas(value.toString());

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}
