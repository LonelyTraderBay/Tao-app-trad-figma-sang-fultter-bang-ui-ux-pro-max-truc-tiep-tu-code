part of 'referral_home_page.dart';

class _CampaignBanner extends StatelessWidget {
  const _CampaignBanner({required this.campaign});

  final ReferralCampaignDraft campaign;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: ReferralHomePage.campaignKey,
      decoration: ShapeDecoration(
        color: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.primary40),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: AppSpacing.referralCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const _IconBubble(
                  icon: Icons.bolt_rounded,
                  color: AppColors.primarySoft,
                  background: AppColors.primary20,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpacing.x2,
                        runSpacing: AppSpacing.x1,
                        children: [
                          Text(
                            campaign.title,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              height: AppSpacing.referralLineHeightShort,
                            ),
                          ),
                          _TinyPill(
                            label: campaign.bonusLabel,
                            color: AppColors.bg,
                            background: AppColors.primarySoft,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        campaign.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.portfolioTextDim,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Wrap(
                        spacing: AppSpacing.x4,
                        runSpacing: AppSpacing.x1,
                        children: [
                          _InlineIconText(
                            icon: Icons.timer_rounded,
                            text: 'Còn ${campaign.daysLeft} ngày',
                            color: AppColors.primarySoft,
                          ),
                          _InlineIconText(
                            icon: Icons.groups_rounded,
                            text:
                                '${_formatCompactInt(campaign.totalParticipants)} tham gia',
                            color: AppColors.portfolioTextMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.primary12,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.primary30),
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Padding(
                padding: AppSpacing.referralCompactPillPadding,
                child: _InlineIconText(
                  icon: Icons.emoji_events_rounded,
                  text: campaign.extraReward,
                  color: AppColors.portfolioTextDim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return const _NoticeCard(
      icon: Icons.shield_outlined,
      text:
          'Nghiêm cấm tự giới thiệu, tạo tài khoản ảo, hoặc gian lận hoa hồng. Vi phạm sẽ bị khóa tài khoản và thu hồi thưởng.',
      color: AppColors.warn,
      background: AppColors.warn08,
      border: AppColors.warningBorder,
    );
  }
}

class _PendingKycBanner extends StatelessWidget {
  const _PendingKycBanner({
    required this.count,
    required this.bonus,
    required this.onTap,
  });

  final int count;
  final double bonus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return VitCard(
      key: ReferralHomePage.pendingKycKey,
      onTap: onTap,
      borderColor: AppColors.primary30,
      padding: AppSpacing.referralCardPadding,
      child: Row(
        children: [
          const _IconBubble(
            icon: Icons.notifications_none_rounded,
            color: AppColors.primary,
            background: AppColors.primary12,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count bạn bè chưa hoàn tất KYC',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Nhắc họ để nhận thưởng ${_formatUsd(bonus)} USDT/người',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ReferralHero extends StatelessWidget {
  const _ReferralHero({
    required this.snapshot,
    required this.copied,
    required this.onCopyCode,
    required this.onCopyLink,
    required this.onShare,
  });

  final ReferralHomeSnapshot snapshot;
  final bool copied;
  final VoidCallback onCopyCode;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralHomePage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _IconBubble(
                icon: Icons.military_tech_rounded,
                color: AppColors.primarySoft,
                background: AppColors.primary20,
                size: AppSpacing.referralHeroIcon,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hạng ${snapshot.currentTier.name}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                    Text(
                      snapshot.currentTier.nameEn,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    Text(
                      'Hoa hồng ${snapshot.currentTier.commissionPercent}% + ${_formatUsd(snapshot.currentTier.kycBonus)}/KYC',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Bạn bè',
                  value: '${snapshot.stats.totalFriends}',
                  subtitle: '${snapshot.stats.activeFriends} hoạt động',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Hoa hồng',
                  value: _formatUsd(snapshot.stats.totalCommission),
                  subtitle: 'Tổng tích luỹ',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Khối lượng',
                  value:
                      '\$${(snapshot.stats.totalVolume / 1000).toStringAsFixed(1)}K',
                  subtitle: 'Từ giới thiệu',
                  color: AppColors.primarySoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _NoticeCard(
            icon: Icons.schedule_rounded,
            text:
                '${_formatUsd(snapshot.stats.pendingCommission)} đang chờ xử lý',
            color: AppColors.warn,
            background: AppColors.warn08,
            border: AppColors.warningBorder,
            dense: true,
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.referralInnerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mã giới thiệu',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.portfolioTextMuted,
                        ),
                      ),
                    ),
                    _CompactAction(
                      onTap: onCopyCode,
                      icon: copied
                          ? Icons.check_circle_rounded
                          : Icons.copy_rounded,
                      label: copied ? 'Đã sao chép' : 'Sao chép',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  snapshot.referralCode,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.buy20,
            padding: AppSpacing.referralInnerPadding,
            child: Row(
              children: [
                Expanded(
                  child: _SplitReward(
                    label: 'Bạn nhận',
                    value:
                        '${_formatUsd(snapshot.currentTier.kycBonus)} + ${snapshot.currentTier.commissionPercent}%',
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.referralSplitDividerWidth,
                  height: AppSpacing.referralSplitDividerHeight,
                  child: ColoredBox(color: AppColors.buy20),
                ),
                const Expanded(
                  child: _SplitReward(
                    label: 'Bạn bè nhận',
                    value: '5 USDT + giảm phí',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ReferralHomePage.copyLinkKey,
                  onPressed: onCopyLink,
                  height: AppSpacing.referralCtaHeight,
                  leading: Icon(
                    copied ? Icons.check_circle_rounded : Icons.copy_rounded,
                  ),
                  child: Text(copied ? 'Đã sao chép link' : 'Sao chép link'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitCtaButton(
                key: ReferralHomePage.shareKey,
                onPressed: onShare,
                fullWidth: false,
                height: AppSpacing.referralCtaHeight,
                variant: VitCtaButtonVariant.secondary,
                padding: AppSpacing.referralFilterChipPadding,
                child: const Icon(Icons.share_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialProofRail extends StatelessWidget {
  const _SocialProofRail({required this.items});

  final List<ReferralSocialProofDraft> items;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.buy,
      AppColors.accent,
      AppColors.primarySoft,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _SocialProofPill(item: items[i], color: colors[i % colors.length]),
            if (i < items.length - 1) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _MilestoneSection extends StatelessWidget {
  const _MilestoneSection({required this.stats, required this.milestones});

  final ReferralHomeStatsDraft stats;
  final List<ReferralMilestoneDraft> milestones;

  @override
  Widget build(BuildContext context) {
    ReferralMilestoneDraft? next;
    for (final item in milestones) {
      if (!item.claimed) {
        next = item;
        break;
      }
    }
    final remaining = next == null ? 0 : (next.friends - stats.totalFriends);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: 'Mốc thành tích',
          trailing: next == null ? null : 'Còn ${remaining.clamp(0, 999)} bạn',
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (final item in milestones) ...[
                _MilestoneCard(item: item, totalFriends: stats.totalFriends),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TierProgress extends StatelessWidget {
  const _TierProgress({
    required this.stats,
    required this.currentTier,
    required this.nextTier,
  });

  final ReferralHomeStatsDraft stats;
  final ReferralTierRuleDraft currentTier;
  final ReferralTierRuleDraft? nextTier;

  @override
  Widget build(BuildContext context) {
    final next = nextTier;
    if (next == null) return const SizedBox.shrink();
    final progress = (stats.totalFriends / next.minFriends).clamp(0.0, 1.0);
    return VitCard(
      padding: AppSpacing.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiến độ hạng tiếp theo',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                '${next.name} (${next.nameEn})',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primarySoft,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ProgressBar(progress: progress, color: AppColors.primarySoft),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${stats.totalFriends} / ${next.minFriends} bạn bè',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Hoa hồng ${next.commissionPercent}% + ${_formatUsd(next.kycBonus)}/KYC',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
