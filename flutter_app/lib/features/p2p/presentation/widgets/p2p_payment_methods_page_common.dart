part of '../pages/p2p_payment_methods_page.dart';

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods({required this.snapshot});

  final P2PPaymentMethodsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _p2pMethodsEmptyPadding,
      child: VitEmptyState(
        icon: Icons.credit_card_off_rounded,
        title: snapshot.emptyTitle,
        message: 'Thêm tài khoản ngân hàng hoặc ví điện tử để giao dịch P2P.',
      ),
    );
  }
}

class _DeleteConfirmation extends StatelessWidget {
  const _DeleteConfirmation({
    required this.method,
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
  });

  final P2PPaymentListMethodDraft method;
  final String title;
  final String message;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: AppColors.bg.withValues(alpha: .78),
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: _p2pMethodsDialogPadding,
              child: VitCard(
                key: P2PPaymentMethodsPage.deleteConfirmKey,
                radius: VitCardRadius.lg,
                borderColor: AppColors.sell20,
                padding: _p2pMethodsCardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Material(
                          color: AppColors.sell15,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.mdRadius,
                          ),
                          child: SizedBox(
                            width: AppSpacing.buttonCompact,
                            height: AppSpacing.buttonCompact,
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.sell,
                              size: AppSpacing.iconMd,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      method.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: _p2pMethodsMajorGap),
                    Row(
                      children: [
                        Expanded(
                          child: VitCtaButton(
                            variant: VitCtaButtonVariant.secondary,
                            onPressed: onCancel,
                            child: const Text('Hủy'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: VitCtaButton(
                            variant: VitCtaButtonVariant.danger,
                            onPressed: onConfirm,
                            child: const Text('Xóa'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
