part of '../pages/enterprise_states_page.dart';

class _ReferenceBanner extends StatelessWidget {
  const _ReferenceBanner({required this.banner});

  final EnterpriseBannerDraft banner;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: _bannerVariant(banner.kind),
      icon: _bannerIcon(banner.kind),
      message: banner.title,
      detail: banner.detail,
    );
  }
}

class _AppliedSection extends StatelessWidget {
  const _AppliedSection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.enterpriseStatesContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '6 màn dữ liệu × 4–5 states. Chọn page và state để preview.',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x5),
          _ReferenceTile(
            icon: Icons.bar_chart_rounded,
            title: 'MarketListPage',
            subtitle: 'Loading · Empty · Error · Offline',
            actionLabel: 'Mở Markets',
            onTap: () => context.go(snapshot.marketRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          const _ReferenceTile(
            icon: Icons.history_rounded,
            title: 'OrdersHistoryPage',
            subtitle: 'Gate state requires 2FA before risky actions',
            actionLabel: 'Preview only',
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.enterpriseStatesContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '4 security overlay chuẩn enterprise. Các CTA đi tới route đã migrate hoặc auth shell.',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x5),
          _ReferenceTile(
            icon: Icons.login_rounded,
            title: 'Session Expired Modal',
            subtitle: 'Phiên đăng nhập đã hết hạn',
            actionLabel: 'Đăng nhập lại',
            actionKey: EnterpriseStatesPage.loginCtaKey,
            onTap: () => context.go(snapshot.loginRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ReferenceTile(
            icon: Icons.verified_user_outlined,
            title: 'KYC Gate Panel',
            subtitle: 'Cần KYC để tiếp tục',
            actionLabel: 'Đi tới KYC',
            onTap: () => context.go(snapshot.kycRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ReferenceTile(
            icon: Icons.key_rounded,
            title: '2FA Gate Panel',
            subtitle: 'Bật 2FA để tiếp tục',
            actionLabel: 'Thiết lập 2FA',
            onTap: () => context.go(snapshot.securityRoute),
          ),
        ],
      ),
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    this.actionKey,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Key? actionKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.enterpriseStatesCardPadding,
      child: Row(
        children: [
          _IconBubble(icon: icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          VitStatusPill(
            key: actionKey,
            label: actionLabel,
            status: onTap == null
                ? VitStatusPillStatus.neutral
                : VitStatusPillStatus.orange,
            size: VitStatusPillSize.md,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.enterpriseStatesIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
            side: BorderSide(color: color.withValues(alpha: .22)),
          ),
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

String _previewLabel(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return 'Loading';
    case EnterprisePreviewState.empty:
      return 'Empty';
    case EnterprisePreviewState.error:
      return 'Error';
    case EnterprisePreviewState.offline:
      return 'Offline';
    case EnterprisePreviewState.gate:
      return 'Gate';
  }
}

EnterpriseStateSection _sectionFromKey(String key) {
  return EnterpriseStateSection.values.firstWhere(
    (section) => section.name == key,
    orElse: () => EnterpriseStateSection.stateKit,
  );
}

IconData _previewIcon(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return Icons.hourglass_top_rounded;
    case EnterprisePreviewState.empty:
      return Icons.inbox_outlined;
    case EnterprisePreviewState.error:
      return Icons.close_rounded;
    case EnterprisePreviewState.offline:
      return Icons.wifi_off_rounded;
    case EnterprisePreviewState.gate:
      return Icons.lock_outline_rounded;
  }
}

VitStatusPillStatus _pillStatus(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return VitStatusPillStatus.info;
    case EnterprisePreviewState.empty:
      return VitStatusPillStatus.neutral;
    case EnterprisePreviewState.error:
      return VitStatusPillStatus.error;
    case EnterprisePreviewState.offline:
      return VitStatusPillStatus.warning;
    case EnterprisePreviewState.gate:
      return VitStatusPillStatus.purple;
  }
}

VitBannerVariant _bannerVariant(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return VitBannerVariant.info;
    case EnterpriseBannerKind.warning:
      return VitBannerVariant.warning;
    case EnterpriseBannerKind.error:
      return VitBannerVariant.error;
  }
}

IconData _bannerIcon(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return Icons.bar_chart_rounded;
    case EnterpriseBannerKind.warning:
      return Icons.warning_amber_rounded;
    case EnterpriseBannerKind.error:
      return Icons.report_problem_outlined;
  }
}
