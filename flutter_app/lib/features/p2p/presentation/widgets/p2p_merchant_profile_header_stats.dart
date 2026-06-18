part of '../pages/p2p_merchant_profile_page.dart';

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.snapshot,
    required this.following,
    required this.onFollow,
    required this.onReport,
    required this.onBlock,
  });

  final P2PMerchantProfileSnapshot snapshot;
  final bool following;
  final VoidCallback onFollow;
  final VoidCallback onReport;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final merchant = snapshot.merchant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MerchantAvatar(merchant: merchant),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          merchant.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (merchant.kycVerified) ...[
                        const SizedBox(width: AppSpacing.x2),
                        const Icon(
                          Icons.verified_user_outlined,
                          color: AppModuleAccents.p2p,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      for (var i = 0; i < merchant.level; i++)
                        const Padding(
                          padding: AppSpacing.p2pMerchantCommerceStarPadding,
                          child: Icon(
                            Icons.star_rounded,
                            color: AppColors.warn,
                            size: AppSpacing.p2pMerchantCommerceSmallIcon,
                          ),
                        ),
                      const SizedBox(width: AppSpacing.x2),
                      VitStatusPill(
                        label: 'Lv.${merchant.level}',
                        status: VitStatusPillStatus.info,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    merchant.isOnline ? 'Đang hoạt động' : merchant.lastActive,
                    style: AppTextStyles.caption.copyWith(
                      color: merchant.isOnline
                          ? AppColors.buy
                          : AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.text3,
                        size: AppSpacing.p2pMerchantCommerceTinyIcon,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Tham gia: ${merchant.joinDate}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: P2PMerchantProfilePage.followButtonKey,
                onPressed: onFollow,
                height: AppSpacing.buttonCompact + AppSpacing.x3,
                variant: following
                    ? VitCtaButtonVariant.secondary
                    : VitCtaButtonVariant.primary,
                leading: Icon(
                  following
                      ? Icons.person_remove_alt_1_outlined
                      : Icons.person_add_alt_1_outlined,
                ),
                child: Text(following ? 'Đã theo dõi' : 'Theo dõi'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            VitCtaButton(
              key: P2PMerchantProfilePage.reportButtonKey,
              onPressed: onReport,
              fullWidth: false,
              height: AppSpacing.buttonCompact + AppSpacing.x3,
              variant: VitCtaButtonVariant.danger,
              leading: const Icon(Icons.flag_outlined),
              child: const Text('Báo cáo'),
            ),
            const SizedBox(width: AppSpacing.x3),
            VitIconButton(
              key: P2PMerchantProfilePage.blockButtonKey,
              icon: Icons.block_rounded,
              tooltip: 'Chặn merchant',
              variant: VitIconButtonVariant.ghost,
              onPressed: onBlock,
            ),
          ],
        ),
      ],
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.merchant});

  final P2PMerchantProfileDraft merchant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        VitAssetAvatar(
          label: merchant.name,
          accentColor: AppColors.accent,
          size: AppSpacing.p2pMerchantCommerceMerchantAvatarSize,
          radius: AppRadii.pillRadius,
        ),
        Positioned(
          right: AppSpacing.x1,
          bottom: AppSpacing.x1,
          child: Material(
            color: merchant.isOnline ? AppColors.buy : AppColors.text3,
            shape: const CircleBorder(
              side: BorderSide(
                color: AppColors.bg,
                width: AppSpacing.p2pMerchantCommerceOnlineBorderWidth,
              ),
            ),
            child: const SizedBox.square(
              dimension: AppSpacing.p2pMerchantCommerceOnlineDot,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.merchant});

  final P2PMerchantProfileDraft merchant;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _MerchantStat(
        label: 'Tỷ lệ hoàn thành',
        value: '${merchant.completionRate.toStringAsFixed(1)}%',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.buy,
      ),
      _MerchantStat(
        label: 'Tổng GD',
        value: _formatInt(merchant.totalTrades),
        icon: Icons.trending_up_rounded,
        color: AppModuleAccents.p2p,
      ),
      _MerchantStat(
        label: 'KL 30 ngày',
        value: '\$${_formatCompactUsd(merchant.totalVolume30dUsd)}',
        icon: Icons.bolt_rounded,
        color: AppColors.accent,
      ),
      _MerchantStat(
        label: 'Thời gian trả',
        value: merchant.avgReleaseTime,
        icon: Icons.schedule_rounded,
        color: AppColors.warn,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(stat: stats[0])),
            const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatCard(stat: stats[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(child: _StatCard(stat: stats[2])),
            const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatCard(stat: stats[3])),
          ],
        ),
      ],
    );
  }
}

class _MerchantStat {
  const _MerchantStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _MerchantStat stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pMerchantCommerceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stat.icon, color: stat.color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            stat.value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReputationCard extends StatelessWidget {
  const _ReputationCard({required this.snapshot});

  final P2PMerchantProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final merchant = snapshot.merchant;
    return VitCard(
      radius: VitCardRadius.sm,
      padding: AppSpacing.p2pMerchantCommerceCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đánh giá tích cực',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                '${merchant.positiveRate.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x3,
              value: merchant.positiveRate / 100,
              backgroundColor: AppColors.surface2,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _TinyIconText(
                  icon: Icons.thumb_up_alt_outlined,
                  text: '${snapshot.positiveReviewCount} tích cực',
                ),
              ),
              _TinyIconText(
                icon: Icons.thumb_down_alt_outlined,
                text: '${merchant.negativeCount} tiêu cực',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyIconText extends StatelessWidget {
  const _TinyIconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: AppSpacing.p2pMerchantCommerceTinyIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}
