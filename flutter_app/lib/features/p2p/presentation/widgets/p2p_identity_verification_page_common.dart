part of '../pages/p2p_identity_verification_page.dart';

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.securityKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            icon: Icons.verified_user_outlined,
            title: 'Bảo mật & Quyền riêng tư',
            color: AppColors.buy,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final note in snapshot.securityNotes) ...[
            _ChecklistRow(text: note, color: AppColors.buy),
            if (note != snapshot.securityNotes.last)
              const SizedBox(height: AppSpacing.x2),
          ],
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
            Icons.check_circle_outline_rounded,
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

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'badge' => Icons.badge_outlined,
    'passport' => Icons.contact_page_outlined,
    _ => Icons.credit_card_rounded,
  };
}
