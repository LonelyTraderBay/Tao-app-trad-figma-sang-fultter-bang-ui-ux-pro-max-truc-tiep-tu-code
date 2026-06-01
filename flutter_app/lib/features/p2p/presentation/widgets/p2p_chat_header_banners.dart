part of '../pages/p2p_chat_page.dart';

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.snapshot});

  final P2PChatSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        MediaQuery.paddingOf(context).top + AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () =>
                context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
          ),
          const SizedBox(width: AppSpacing.x3),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
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
                right: -1,
                bottom: -1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.buy,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
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
            label: 'Chi tiết',
            onPressed: () =>
                context.go(AppRoutePaths.p2pOrder(snapshot.orderId)),
          ),
          const SizedBox(width: AppSpacing.x2),
          _RoundIconButton(
            key: P2PChatPage.e2eKey,
            icon: Icons.lock_outline_rounded,
            color: AppColors.buy,
            onPressed: () => context.go(AppRoutePaths.p2pE2EInfo),
          ),
        ],
      ),
    );
  }
}

class _RiskBanner extends StatelessWidget {
  const _RiskBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x3,
      ),
      color: AppColors.sell10,
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
    return Material(
      color: AppColors.buy10,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.contentPad,
            vertical: AppSpacing.x3,
          ),
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
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.buy,
                    size: 10,
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
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.buy,
                iconSize: 13,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
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
      child: Material(
        color: AppColors.buy10,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.buy,
                  size: 10,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
