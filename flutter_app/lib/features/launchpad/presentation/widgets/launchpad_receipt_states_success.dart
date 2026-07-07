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
      iconContainerSize: LaunchpadSpacingTokens.launchpadBox48,
      iconSize: AppSpacing.iconMd,
      iconShape: BoxShape.circle,
      verticalPadding: LaunchpadSpacingTokens.launchpadBox48,
      horizontalPadding: AppSpacing.x6,
      titleStyle: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text3,
        height: LaunchpadSpacingTokens.launchpadLineHeightShort,
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
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ProjectReceiptCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ReceiptDetailsCard(subscription: subscription, status: status),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.success,
          title: 'Đã rà soát biên lai',
          message:
              'Phí, giới hạn, rủi ro phân bổ, bước tiếp theo và hoàn tiền vẫn gắn với biên lai này.',
          contractId: subscription.id,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ReceiptNextSteps(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ReceiptDisclosure(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          key: LaunchpadReceiptPage.portfolioButtonKey,
          onPressed: () => context.go(snapshot.portfolioRoute),
          leading: const Icon(Icons.business_center_outlined),
          child: const Text('Xem portfolio'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
      padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX4,
      child: Column(
        children: [
          SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox64,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.buy15,
                shape: CircleBorder(
                  side: BorderSide(color: AppColors.buy.withValues(alpha: .30)),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: LaunchpadSpacingTokens.launchpadIconHuge,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Đăng ký thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Đơn đăng ký ${subscription.projectSymbol} đã được ghi nhận. Token sẽ được phân bổ sau khi kết thúc.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: LaunchpadSpacingTokens.launchpadLineHeightShort,
            ),
          ),
        ],
      ),
    );
  }
}
