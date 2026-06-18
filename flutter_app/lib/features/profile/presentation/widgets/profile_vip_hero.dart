part of '../pages/vip_page.dart';

class _VipHero extends StatelessWidget {
  const _VipHero({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currentTier = snapshot.currentTier;
    return VitModuleHeroCard(
      accentColor: _vipGold,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadii.cardLargeRadius,
        child: SizedBox(
          height: AppSpacing.profileVipHeroHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: VitHeroGlow(
                  center: const Alignment(.75, -.75),
                  radius: 1.2,
                  colors: [
                    _vipGold.withValues(alpha: .18),
                    AppColors.primary08,
                    AppColors.transparent,
                  ],
                  stops: const [0, .38, 1],
                ),
              ),
              Padding(
                padding: AppSpacing.profileVipHeroPadding,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _TierIcon(tier: currentTier, large: true),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: _vipGold,
                                    size: AppSpacing.profileVipHeroBadgeIcon,
                                  ),
                                  const SizedBox(
                                    width: AppSpacing.profileVipHeroTitleGap,
                                  ),
                                  Flexible(
                                    child: Text(
                                      currentTier.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.sectionTitle
                                          .copyWith(
                                            color: _vipGold,
                                            fontWeight: AppTextStyles.heavy,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppSpacing.profileVipHeroMemberGap,
                              ),
                              Text(
                                'Th\u00E0nh vi\u00EAn t\u1EEB ${snapshot.memberSince}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.portfolioTextDim,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: AppSpacing.profileVipHeroStatusGap,
                        ),
                        VitStatusPill(
                          label: currentTier.badge,
                          status: VitStatusPillStatus.orange,
                          outline: true,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _HeroFeeBox(
                            label: 'Maker fee',
                            value: _formatFee(currentTier.makerFee),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: _HeroFeeBox(
                            label: 'Taker fee',
                            value: _formatFee(currentTier.takerFee),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroFeeBox extends StatelessWidget {
  const _HeroFeeBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: AppSpacing.profileVipFeePadding,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.profileVipFeeValueGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _vipSuccess,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _VipTabs extends StatelessWidget {
  const _VipTabs({required this.active, required this.onChanged});

  final _VipTab active;
  final ValueChanged<_VipTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: AppSpacing.profileVipTabsPadding,
      child: VitTabBar(
        variant: VitTabBarVariant.pill,
        activeKey: active.name,
        onChanged: (key) => onChanged(_VipTab.values.byName(key)),
        tabs: const [
          VitTabItem(key: 'overview', label: 'T\u1ED5ng quan'),
          VitTabItem(key: 'benefits', label: '\u0110\u1EB7c quy\u1EC1n'),
          VitTabItem(key: 'history', label: 'L\u1ECBch s\u1EED'),
        ],
      ),
    );
  }
}
