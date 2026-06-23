part of '../pages/p2p_chat_page.dart';

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.snapshot});

  final P2PChatSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Padding(
        padding: AppSpacing.p2pChatHeaderPadding(
          MediaQuery.paddingOf(context).top,
        ),
        child: Row(
          children: [
            _RoundIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back to P2P order detail',
              onPressed: () =>
                  context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
            ),
            const SizedBox(width: AppSpacing.x3),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: AppSpacing.p2pChatHeaderAvatarRadius,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    snapshot.merchantInitial,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: AppSpacing.p2pChatOnlineBadgeOffset,
                  bottom: AppSpacing.p2pChatOnlineBadgeOffset,
                  child: SizedBox.square(
                    dimension: AppSpacing.p2pChatOnlineBadgeSize,
                    child: Material(
                      color: AppColors.buy,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: AppColors.surface,
                          width: AppSpacing.p2pChatOnlineBadgeBorder,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.merchant,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    snapshot.activeLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                  ),
                ],
              ),
            ),
            _SmallHeaderButton(
              key: P2PChatPage.detailKey,
              tooltip: 'Open P2P order detail',
              label: 'Chi tiết',
              onPressed: () =>
                  context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
            ),
            const SizedBox(width: AppSpacing.x2),
            _RoundIconButton(
              key: P2PChatPage.e2eKey,
              icon: Icons.lock_outline_rounded,
              tooltip: 'Open E2E encryption info',
              color: AppColors.buy,
              onPressed: () => context.go(AppRoutePaths.p2pE2EInfo),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskBanner extends StatelessWidget {
  const _RiskBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.sell10,
        child: Padding(
          padding: AppSpacing.p2pChatRiskBannerPadding,
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.micro.copyWith(color: AppColors.sell),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _E2EBanner extends StatelessWidget {
  const _E2EBanner({
    required this.title,
    required this.subtitle,
    required this.onOpen,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      background: const ColoredBox(color: AppColors.buy10),
      padding: AppSpacing.p2pChatBannerPadding,
      onTap: onOpen,
      clip: true,
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.p2pChatTinyIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'AES-256',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          VitInlineIconAction(
            icon: Icons.close_rounded,
            tooltip: 'Close E2E encryption banner',
            onPressed: onClose,
            color: AppColors.buy,
            size: AppSpacing.p2pChatCloseIcon,
            padding: AppSpacing.x1,
            borderRadius: AppRadii.pillRadius,
          ),
        ],
      ),
    );
  }
}

class _EncryptionPill extends StatelessWidget {
  const _EncryptionPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: VitStatusPill(
        label: label,
        status: VitStatusPillStatus.success,
        icon: Icons.lock_outline_rounded,
        size: VitStatusPillSize.sm,
        onTap: onTap,
      ),
    );
  }
}
