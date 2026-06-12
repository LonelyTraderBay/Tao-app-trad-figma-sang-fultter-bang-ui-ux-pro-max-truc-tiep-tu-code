part of '../pages/launchpad_receipt_page.dart';

class _ReceiptErrorState extends StatelessWidget {
  const _ReceiptErrorState();

  @override
  Widget build(BuildContext context) {
    return VitErrorState(
      key: LaunchpadReceiptPage.errorKey,
      title: 'Không tải được dữ liệu',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.error_outline_rounded,
      iconContainerSize: 48,
      iconSize: 24,
      iconShape: BoxShape.circle,
      verticalPadding: 48,
      horizontalPadding: 24,
      titleStyle: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text3,
        height: AppSpacing.launchpadLineHeightLong,
      ),
    );
  }
}

class _ReceiptSuccess extends StatelessWidget {
  const _ReceiptSuccess({required this.snapshot});

  final LaunchpadReceiptSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final subscription = snapshot.subscription!;
    final status = _statusStyle(subscription.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuccessHero(subscription: subscription),
        const SizedBox(height: AppSpacing.x4),
        _ProjectReceiptCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.x4),
        _ReceiptDetailsCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.x4),
        const _ReceiptNextSteps(),
        const SizedBox(height: AppSpacing.x4),
        const _ReceiptDisclosure(),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          key: LaunchpadReceiptPage.portfolioButtonKey,
          onPressed: () => context.go(snapshot.portfolioRoute),
          leading: const Icon(Icons.business_center_outlined),
          child: const Text('Xem portfolio'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: LaunchpadReceiptPage.launchpadButtonKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => context.go(snapshot.launchpadRoute),
          child: const Text('Quay lại Launchpad'),
        ),
      ],
    );
  }
}

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        children: [
          Container(
            width: AppSpacing.launchpadBox64,
            height: AppSpacing.launchpadBox64,
            decoration: BoxDecoration(
              color: AppColors.buy15,
              border: Border.all(color: AppColors.buy.withValues(alpha: .30)),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.launchpadIconHuge,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Đăng ký thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Đơn đăng ký ${subscription.projectSymbol} đã được ghi nhận. Token sẽ được phân bổ sau khi kết thúc.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.launchpadLineHeightReadable,
            ),
          ),
        ],
      ),
    );
  }
}
