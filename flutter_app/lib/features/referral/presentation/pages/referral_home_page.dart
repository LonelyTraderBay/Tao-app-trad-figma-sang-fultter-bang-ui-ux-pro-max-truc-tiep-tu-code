import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';

class ReferralHomePage extends ConsumerStatefulWidget {
  const ReferralHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc290_referral_home_content');
  static const campaignKey = Key('sc290_referral_campaign');
  static const heroKey = Key('sc290_referral_hero');
  static const copyLinkKey = Key('sc290_copy_link');
  static const shareKey = Key('sc290_share_sheet');
  static const pendingKycKey = Key('sc290_pending_kyc');
  static const calculatorKey = Key('sc290_calculator');
  static const detailHistoryKey = Key('sc290_detail_history');
  static const detailRewardsKey = Key('sc290_detail_rewards');
  static const detailRulesKey = Key('sc290_detail_rules');
  static const inviteKey = Key('sc290_invite_cta');

  static Key milestoneKey(String id) => Key('sc290_milestone_$id');
  static Key campaignHistoryKey(String id) => Key('sc290_campaign_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralHomePage> createState() => _ReferralHomePageState();
}

class _ReferralHomePageState extends ConsumerState<ReferralHomePage> {
  bool _copiedLink = false;
  double _calculatorFriends = 4;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(referralRepositoryProvider).getHome();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-290 ReferralHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ReferralHomePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    children: [
                      _CampaignBanner(campaign: snapshot.campaign),
                      const _SafetyNotice(),
                      _PendingKycBanner(
                        count:
                            snapshot.stats.totalFriends -
                            snapshot.stats.kycCompleted,
                        bonus: snapshot.currentTier.kycBonus,
                        onTap: () => context.go('/referral/history'),
                      ),
                      _ReferralHero(
                        snapshot: snapshot,
                        copied: _copiedLink,
                        onCopyCode: () => _copy(snapshot.referralCode),
                        onCopyLink: () => _copy(snapshot.referralLink),
                        onShare: () => _showShareSheet(context, snapshot),
                      ),
                      _SocialProofRail(items: snapshot.socialProof),
                      _MilestoneSection(
                        stats: snapshot.stats,
                        milestones: snapshot.milestones,
                      ),
                      _TierProgress(
                        stats: snapshot.stats,
                        currentTier: snapshot.currentTier,
                        nextTier: snapshot.nextTier,
                      ),
                      _EarningCalculator(
                        friends: _calculatorFriends,
                        currentTier: snapshot.currentTier,
                        onChanged: (value) =>
                            setState(() => _calculatorFriends = value),
                      ),
                      if (snapshot.pendingCommissions.isNotEmpty)
                        _PendingCommissionSection(
                          items: snapshot.pendingCommissions,
                        ),
                      _RewardHighlights(
                        currentTier: snapshot.currentTier,
                        campaign: snapshot.campaign,
                      ),
                      _LeaderboardSection(items: snapshot.leaderboard),
                      _TransparencyNote(
                        commissionPercent:
                            snapshot.currentTier.commissionPercent,
                      ),
                      _DetailLinks(
                        links: snapshot.detailLinks,
                        onOpen: (route) => context.go(route),
                      ),
                      _HowItWorksSection(steps: snapshot.howItWorks),
                      _MonthStats(stats: snapshot.stats),
                      _CampaignHistorySection(items: snapshot.campaignHistory),
                      VitCtaButton(
                        key: ReferralHomePage.inviteKey,
                        onPressed: () => _showShareSheet(context, snapshot),
                        leading: const Icon(Icons.group_add_rounded),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        child: const Text('Mời bạn bè ngay'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copy(String value) {
    HapticFeedback.selectionClick();
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedLink = true);
  }

  void _showShareSheet(BuildContext context, ReferralHomeSnapshot snapshot) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chia sẻ lời mời',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'Mã ${snapshot.referralCode} · Bạn nhận ${_formatUsd(snapshot.currentTier.kycBonus)} + ${snapshot.currentTier.commissionPercent}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x4),
                _SharePreview(link: snapshot.referralLink),
                const SizedBox(height: AppSpacing.x5),
                VitCtaButton(
                  onPressed: () {
                    _copy(snapshot.referralLink);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.copy_rounded),
                  child: const Text('Sao chép lời mời'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CampaignBanner extends StatelessWidget {
  const _CampaignBanner({required this.campaign});

  final ReferralCampaignDraft campaign;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ReferralHomePage.campaignKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        border: Border.all(color: AppColors.primary40),
        borderRadius: AppRadii.cardRadius,
      ),
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
                            height: 1.2,
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary12,
              border: Border.all(color: AppColors.primary30),
              borderRadius: AppRadii.smRadius,
            ),
            child: _InlineIconText(
              icon: Icons.emoji_events_rounded,
              text: campaign.extraReward,
              color: AppColors.portfolioTextDim,
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _IconBubble(
                icon: Icons.military_tech_rounded,
                color: AppColors.primarySoft,
                background: AppColors.primary20,
                size: 48,
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
            padding: const EdgeInsets.all(AppSpacing.x3),
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
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                Expanded(
                  child: _SplitReward(
                    label: 'Bạn nhận',
                    value:
                        '${_formatUsd(snapshot.currentTier.kycBonus)} + ${snapshot.currentTier.commissionPercent}%',
                  ),
                ),
                Container(width: 1, height: 32, color: AppColors.buy20),
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
                  height: 46,
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
                height: 46,
                variant: VitCtaButtonVariant.secondary,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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

class _EarningCalculator extends StatelessWidget {
  const _EarningCalculator({
    required this.friends,
    required this.currentTier,
    required this.onChanged,
  });

  final double friends;
  final ReferralTierRuleDraft currentTier;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final friendCount = friends.round();
    final monthly = friendCount * 42.0 * currentTier.commissionPercent / 100;
    final yearly = monthly * 12;

    return VitCard(
      key: ReferralHomePage.calculatorKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            title: 'Thu nhập nháp ước tính',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Kéo để ước tính thêm bạn mới trong tháng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Slider(
            value: friends,
            min: 0,
            max: 20,
            divisions: 20,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surface3,
            onChanged: onChanged,
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Bạn mới',
                  value: '+$friendCount',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Hoa hồng/tháng',
                  value: _formatUsd(monthly),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Hoa hồng/năm',
                  value: _formatUsd(yearly),
                  color: AppColors.primarySoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingCommissionSection extends StatelessWidget {
  const _PendingCommissionSection({required this.items});

  final List<ReferralPendingCommissionDraft> items;

  @override
  Widget build(BuildContext context) {
    final total = items.fold(0.0, (sum, item) => sum + item.amount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: 'Hoa hồng đang chờ',
          trailing: '~${_formatUsd(total)}',
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in items) ...[
          _PendingCommissionCard(item: item),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RewardHighlights extends StatelessWidget {
  const _RewardHighlights({required this.currentTier, required this.campaign});

  final ReferralTierRuleDraft currentTier;
  final ReferralCampaignDraft campaign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'Thưởng của bạn', color: AppColors.buy),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _RewardCard(
                icon: Icons.card_giftcard_rounded,
                title: 'Thưởng KYC',
                value: _formatUsd(currentTier.kycBonus),
                subtitle: 'Mỗi bạn hoàn tất KYC',
                color: AppColors.buy,
                chip: 'x${campaign.bonusMultiplier} đang áp dụng',
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _RewardCard(
                icon: Icons.trending_up_rounded,
                title: 'Hoa hồng',
                value: '${currentTier.commissionPercent}%',
                subtitle: 'Phí GD của bạn bè, vĩnh viễn',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection({required this.items});

  final List<ReferralLeaderboardDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            title: 'Bảng xếp hạng',
            trailing: 'Tháng 3/2026',
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in items) ...[
            _LeaderboardRow(item: item),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x4),
          const _NoticeCard(
            icon: Icons.info_outline_rounded,
            text:
                'Bảng xếp hạng tính theo số bạn mới đủ KYC. Công khai minh bạch để tránh spam.',
            color: AppColors.text3,
            background: AppColors.surface2,
            border: AppColors.cardBorder,
            dense: true,
          ),
        ],
      ),
    );
  }
}

class _TransparencyNote extends StatelessWidget {
  const _TransparencyNote({required this.commissionPercent});

  final int commissionPercent;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.warning_amber_rounded,
      text:
          'Hoa hồng = Phí GD thực tế của bạn bè x $commissionPercent%. Cộng real-time vào ví USDT, không giới hạn thời gian.',
      color: AppColors.text3,
      background: AppColors.surface2,
      border: AppColors.cardBorder,
    );
  }
}

class _DetailLinks extends StatelessWidget {
  const _DetailLinks({required this.links, required this.onOpen});

  final List<ReferralDetailLinkDraft> links;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < links.length; i++)
            _DetailLinkRow(
              item: links[i],
              showDivider: i < links.length - 1,
              onTap: () => onOpen(links[i].route),
            ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection({required this.steps});

  final List<ReferralStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            title: 'Cách thức hoạt động',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final step in steps) ...[
            _StepRow(step: step),
            if (step != steps.last) const Divider(color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _MonthStats extends StatelessWidget {
  const _MonthStats({required this.stats});

  final ReferralHomeStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'Tháng này', color: AppColors.warn),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _MetricBox(
                label: 'Hoa hồng tháng này',
                value: '+${_formatUsd(stats.thisMonthCommission)}',
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MetricBox(
                label: 'Bạn mới tháng này',
                value: '+${stats.thisMonthFriends}',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CampaignHistorySection extends StatelessWidget {
  const _CampaignHistorySection({required this.items});

  final List<ReferralCampaignHistoryDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: 'Lịch sử sự kiện',
          trailing: '${items.length} sự kiện',
          color: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final item in items) ...[
          _CampaignHistoryCard(item: item),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitReward extends StatelessWidget {
  const _SplitReward({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            fontSize: 9,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SocialProofPill extends StatelessWidget {
  const _SocialProofPill({required this.item, required this.color});

  final ReferralSocialProofDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .15)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.item, required this.totalFriends});

  final ReferralMilestoneDraft item;
  final int totalFriends;

  @override
  Widget build(BuildContext context) {
    final claimable = !item.claimed && totalFriends >= item.friends;
    final next = !item.claimed && totalFriends < item.friends;
    final color = item.claimed
        ? AppColors.buy
        : claimable
        ? AppColors.primary
        : next
        ? AppColors.warn
        : AppColors.text3;
    return SizedBox(
      key: ReferralHomePage.milestoneKey(item.id),
      width: 122,
      child: VitCard(
        borderColor: color.withValues(alpha: .24),
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  item.claimed
                      ? Icons.check_circle_rounded
                      : Icons.flag_rounded,
                  color: color,
                  size: AppSpacing.iconMd,
                ),
                const Spacer(),
                Text(
                  '${item.friends}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Text(
              '${item.friends} bạn bè',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              item.reward,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingCommissionCard extends StatelessWidget {
  const _PendingCommissionCard({required this.item});

  final ReferralPendingCommissionDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Avatar(initial: item.friendInitial, color: AppColors.warn),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.friendName,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _InlineIconText(
                      icon: Icons.schedule_rounded,
                      text: item.reason,
                      color: AppColors.warn,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '~${_formatUsd(item.amount)}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    item.currency,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ProgressBar(progress: item.progress / 100, color: AppColors.warn),
          const SizedBox(height: AppSpacing.x3),
          Text(
            item.reasonDetail,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Align(
            alignment: Alignment.centerLeft,
            child: _TinyPill(
              label: item.eta,
              color: AppColors.warn,
              background: AppColors.warn08,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.chip,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .20),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBubble(
                icon: icon,
                color: color,
                background: color.withValues(alpha: .10),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          if (chip != null) ...[
            const SizedBox(height: AppSpacing.x3),
            _TinyPill(
              label: chip!,
              color: AppColors.primarySoft,
              background: AppColors.warn08,
            ),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.item});

  final ReferralLeaderboardDraft item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '#${item.rank}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _Avatar(initial: item.name.characters.first, color: AppColors.primary),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '${item.friends} bạn mới · ${item.tier}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        Text(
          _formatUsd(item.totalEarned),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _DetailLinkRow extends StatelessWidget {
  const _DetailLinkRow({
    required this.item,
    required this.showDivider,
    required this.onTap,
  });

  final ReferralDetailLinkDraft item;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _detailStyle(item.id);
    return InkWell(
      key: switch (item.id) {
        'friends' => ReferralHomePage.detailHistoryKey,
        'rewards' => ReferralHomePage.detailRewardsKey,
        'rules' => ReferralHomePage.detailRulesKey,
        _ => null,
      },
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.divider))
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            _IconBubble(
              icon: style.icon,
              color: style.color,
              background: style.color.withValues(alpha: .10),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
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
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ReferralStepDraft step;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.warn,
      AppColors.buy,
    ];
    final color = colors[(step.step - 1).clamp(0, colors.length - 1)];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          _IconBubble(
            icon: Icons.check_rounded,
            color: color,
            background: color.withValues(alpha: .10),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.lgRadius,
            ),
            child: Text(
              '${step.step}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignHistoryCard extends StatelessWidget {
  const _CampaignHistoryCard({required this.item});

  final ReferralCampaignHistoryDraft item;

  @override
  Widget build(BuildContext context) {
    final active = item.statusLabel == 'Đang diễn ra';
    final progress = active ? .28 : 1.0;
    final color = active ? AppColors.buy : AppColors.primary;
    return VitCard(
      key: ReferralHomePage.campaignHistoryKey(item.id),
      borderColor: active ? AppColors.buy20 : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _TinyPill(
                label: item.statusLabel,
                color: active ? AppColors.buy : AppColors.text2,
                background: active ? AppColors.buy10 : AppColors.surface2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.dateRange,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            item.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _TinyPill(
                      label: item.bonusLabel,
                      color: AppColors.accent,
                      background: AppColors.accent10,
                    ),
                    const Spacer(),
                    Text(
                      '${_formatCompactInt(item.participants)} tham gia',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  item.result,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProgressBar(progress: progress, color: color),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _HistoryDatum(
                        label: 'Kết quả của bạn',
                        value: item.result,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _HistoryDatum(
                        label: 'Cộng đồng',
                        value:
                            '${_formatCompactInt(item.participants)} tham gia',
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                if (active) ...[
                  const SizedBox(height: AppSpacing.x3),
                  const _NoticeCard(
                    icon: Icons.campaign_rounded,
                    text: 'Đang diễn ra - mời thêm bạn bè để nhận x2.',
                    color: AppColors.buy,
                    background: AppColors.buy10,
                    border: AppColors.buy20,
                    dense: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryDatum extends StatelessWidget {
  const _HistoryDatum({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.trailing,
    this.color = AppModuleAccents.referral,
  });

  final String title;
  final String? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
    required this.border,
    this.dense = false,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color background;
  final Color border;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: dense ? AppSpacing.x2 : AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: dense ? color : AppColors.text2,
                fontWeight: dense ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.background,
    this.size = 40,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Icon(icon, color: color, size: size * .45),
    );
  }
}

class _CompactAction extends StatelessWidget {
  const _CompactAction({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary12,
          border: Border.all(color: AppColors.primary30),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

class _InlineIconText extends StatelessWidget {
  const _InlineIconText({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: SizedBox(
        height: 8,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial, required this.color});

  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        initial,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SharePreview extends StatelessWidget {
  const _SharePreview({required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        'Mình đang dùng VitTrade để giao dịch crypto. Đăng ký qua link của mình, cả hai nhận 5 USDT miễn phí.\n$link',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

final class _DetailStyle {
  const _DetailStyle({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

_DetailStyle _detailStyle(String id) {
  return switch (id) {
    'friends' => const _DetailStyle(
      icon: Icons.groups_rounded,
      color: AppColors.accent,
    ),
    'rewards' => const _DetailStyle(
      icon: Icons.card_giftcard_rounded,
      color: AppColors.buy,
    ),
    'rules' => const _DetailStyle(
      icon: Icons.workspace_premium_rounded,
      color: AppColors.warn,
    ),
    _ => const _DetailStyle(
      icon: Icons.chevron_right_rounded,
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatCompactInt(int value) {
  if (value < 1000) return '$value';
  final text = (value / 1000).toStringAsFixed(1);
  return '${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}K';
}
