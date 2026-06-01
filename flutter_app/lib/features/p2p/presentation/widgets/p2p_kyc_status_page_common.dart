part of '../pages/p2p_kyc_status_page.dart';

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.snapshot});

  final P2PKycStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycStatusPage.supportKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.supportRoute);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mở Support Chat',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppModuleAccents.p2p,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.open_in_new_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconSm,
                      ),
                    ],
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

VitStatusPillStatus _verificationPill(P2PKycVerificationStatus status) {
  return switch (status) {
    P2PKycVerificationStatus.approved => VitStatusPillStatus.success,
    P2PKycVerificationStatus.pending => VitStatusPillStatus.warning,
    P2PKycVerificationStatus.rejected => VitStatusPillStatus.error,
    P2PKycVerificationStatus.incomplete => VitStatusPillStatus.neutral,
  };
}

VitStatusPillStatus _stepPill(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => VitStatusPillStatus.success,
    P2PKycStepStatus.processing => VitStatusPillStatus.info,
    P2PKycStepStatus.pending => VitStatusPillStatus.warning,
    P2PKycStepStatus.rejected => VitStatusPillStatus.error,
    P2PKycStepStatus.waiting => VitStatusPillStatus.neutral,
  };
}

Color _stepColor(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => AppColors.buy,
    P2PKycStepStatus.processing => AppModuleAccents.p2p,
    P2PKycStepStatus.pending => AppColors.warn,
    P2PKycStepStatus.rejected => AppColors.sell,
    P2PKycStepStatus.waiting => AppColors.text3,
  };
}

Color _stepBackground(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => AppColors.buy10,
    P2PKycStepStatus.processing => AppColors.primary12,
    P2PKycStepStatus.pending => AppColors.warn10,
    P2PKycStepStatus.rejected => AppColors.sell10,
    P2PKycStepStatus.waiting => AppColors.surface2,
  };
}

IconData _stepIcon(String iconKey) {
  return switch (iconKey) {
    'camera' => Icons.photo_camera_outlined,
    'face' => Icons.center_focus_strong_rounded,
    'shield' => Icons.shield_outlined,
    'upload' => Icons.upload_rounded,
    _ => Icons.description_outlined,
  };
}

IconData _stepStatusIcon(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => Icons.check_circle_outline_rounded,
    P2PKycStepStatus.processing => Icons.sync_rounded,
    P2PKycStepStatus.pending => Icons.schedule_rounded,
    P2PKycStepStatus.rejected => Icons.cancel_outlined,
    P2PKycStepStatus.waiting => Icons.schedule_rounded,
  };
}
