part of '../pages/p2p_selfie_verification_page.dart';

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '$completed/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.lgRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: pct,
            backgroundColor: AppColors.surface2,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppModuleAccents.p2p,
            ),
          ),
        ),
      ],
    );
  }
}

class _LivenessActionTile extends StatelessWidget {
  const _LivenessActionTile({required this.action, required this.completed});

  final P2PSelfieLivenessActionDraft action;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      variant: completed ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: completed ? AppColors.buy20 : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _livenessIcon(action.iconKey),
            color: completed ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: completed ? AppColors.buy : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (completed) ...[
            const SizedBox(height: AppSpacing.x1),
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({
    required this.snapshot,
    required this.onComplete,
    required this.onSupport,
  });

  final P2PSelfieVerificationSnapshot snapshot;
  final VoidCallback onComplete;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSelfieVerificationPage.resultKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: AppSpacing.buttonHero,
          height: AppSpacing.buttonHero,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          decoration: const BoxDecoration(
            color: AppColors.buy10,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconLg,
          ),
        ),
        Text(
          'Xác minh thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Khuôn mặt của bạn đã được xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              _ScoreRow(label: 'Face Match Score', value: snapshot.matchScore),
              Container(height: 1, color: AppColors.cardBorder),
              _ScoreRow(label: 'Liveness Score', value: snapshot.livenessScore),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          radius: VitCardRadius.md,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Dữ liệu biometric được mã hóa và xóa sau khi xác minh. Chúng tôi không lưu trữ ảnh selfie của bạn.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: P2PSelfieVerificationPage.completeKey,
          onPressed: onComplete,
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Hoàn tất'),
        ),
        const SizedBox(height: AppSpacing.x3),
        TextButton(
          onPressed: onSupport,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.text2,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Liên hệ hỗ trợ'),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            color == AppColors.warn
                ? Icons.auto_awesome_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 13,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _livenessIcon(String iconKey) {
  return switch (iconKey) {
    'smile' => Icons.sentiment_satisfied_alt_rounded,
    'blink' => Icons.visibility_outlined,
    'turn_left' => Icons.keyboard_arrow_left_rounded,
    'turn_right' => Icons.keyboard_arrow_right_rounded,
    _ => Icons.face_retouching_natural_outlined,
  };
}
