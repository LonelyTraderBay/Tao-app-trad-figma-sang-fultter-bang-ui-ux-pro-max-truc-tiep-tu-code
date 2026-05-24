import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

enum _MerchantProfileTab { ads, reviews }

class P2PMerchantProfilePage extends ConsumerStatefulWidget {
  const P2PMerchantProfilePage({
    super.key,
    required this.merchantId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc228_p2p_merchant_profile_content');
  static const followButtonKey = Key('sc228_p2p_merchant_follow');
  static const reportButtonKey = Key('sc228_p2p_merchant_report');
  static const blockButtonKey = Key('sc228_p2p_merchant_block');
  static const reviewsTabKey = Key('sc228_p2p_merchant_reviews_tab');

  static Key adKey(String adId) => Key('sc228_p2p_merchant_ad_$adId');

  final String merchantId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMerchantProfilePage> createState() =>
      _P2PMerchantProfilePageState();
}

class _P2PMerchantProfilePageState
    extends ConsumerState<P2PMerchantProfilePage> {
  _MerchantProfileTab _tab = _MerchantProfileTab.ads;
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getMerchantProfile(widget.merchantId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-228 P2PMerchantProfilePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Hồ sơ Merchant',
              subtitle: 'Merchant · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PMerchantProfilePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileHeader(
                        snapshot: snapshot,
                        following: _following,
                        onFollow: _toggleFollow,
                        onReport: () => context.go(snapshot.reportRoute),
                        onBlock: () => _confirmBlock(context, snapshot),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _StatsGrid(merchant: snapshot.merchant),
                      const SizedBox(height: AppSpacing.x5),
                      _ReputationCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      VitTabBar(
                        variant: VitTabBarVariant.segment,
                        activeKey: _tab.name,
                        onChanged: (key) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = _tabFromKey(key));
                        },
                        tabs: [
                          VitTabItem(
                            key: _MerchantProfileTab.ads.name,
                            label: 'Quảng cáo (${snapshot.ads.length})',
                          ),
                          VitTabItem(
                            key: _MerchantProfileTab.reviews.name,
                            label: 'Đánh giá (${snapshot.reviews.length})',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _tab == _MerchantProfileTab.ads
                            ? _AdsList(snapshot: snapshot)
                            : _ReviewsList(snapshot: snapshot),
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

  _MerchantProfileTab _tabFromKey(String key) {
    return _MerchantProfileTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _MerchantProfileTab.ads,
    );
  }

  void _toggleFollow() {
    HapticFeedback.selectionClick();
    setState(() => _following = !_following);
  }

  Future<void> _confirmBlock(
    BuildContext context,
    P2PMerchantProfileSnapshot snapshot,
  ) async {
    HapticFeedback.lightImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Chặn ${snapshot.merchant.name}?',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Text(
            'Bạn sẽ không thể giao dịch với người này. Có thể bỏ chặn trong danh sách chặn.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Hủy',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Chặn',
                style: AppTextStyles.caption.copyWith(color: AppColors.warn),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;
    HapticFeedback.mediumImpact();
    context.go(snapshot.blacklistAddRoute);
  }
}

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
                          padding: EdgeInsets.only(right: AppSpacing.x1),
                          child: Icon(
                            Icons.star_rounded,
                            color: AppColors.warn,
                            size: 13,
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
                        size: 10,
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
        Container(
          width: AppSpacing.buttonHero,
          height: AppSpacing.buttonHero,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            merchant.name.characters.first,
            style: AppTextStyles.pageTitle.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Positioned(
          right: AppSpacing.x1,
          bottom: AppSpacing.x1,
          child: Container(
            width: AppSpacing.x4,
            height: AppSpacing.x4,
            decoration: BoxDecoration(
              color: merchant.isOnline ? AppColors.buy : AppColors.text3,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bg, width: 2),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
        Icon(icon, color: AppColors.text3, size: 10),
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

class _AdsList extends StatelessWidget {
  const _AdsList({required this.snapshot});

  final P2PMerchantProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.ads.isEmpty) {
      return VitEmptyState(
        title: snapshot.emptyAdsTitle,
        message: 'Merchant chưa có offer đang hoạt động.',
      );
    }

    return Column(
      key: const ValueKey('merchant_ads'),
      children: [
        for (final ad in snapshot.ads) ...[
          _MerchantAdCard(ad: ad),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _MerchantAdCard extends StatelessWidget {
  const _MerchantAdCard({required this.ad});

  final P2PMerchantProfileAdDraft ad;

  @override
  Widget build(BuildContext context) {
    final isSellAd = ad.type == P2PTradeType.sell;
    final actionColor = isSellAd ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2PMerchantProfilePage.adKey(ad.id),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitStatusPill(
                label: isSellAd ? 'BÁN' : 'MUA',
                status: isSellAd
                    ? VitStatusPillStatus.error
                    : VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                ad.asset,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Khả dụng: ${_formatAmount(ad.available)} ${ad.asset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                flex: 5,
                child: Text(
                  'Giới hạn: ${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final method in ad.paymentMethods)
                Text(
                  method,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _OutlineActionButton(
            label: isSellAd ? 'Mua ngay' : 'Bán ngay',
            color: actionColor,
            onTap: () => context.go(AppRoutePaths.p2pAd(ad.id)),
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonCompact,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: color.withValues(alpha: .10),
            border: Border.all(color: color.withValues(alpha: .25)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.inputRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(Icons.chevron_right_rounded, color: color, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.snapshot});

  final P2PMerchantProfileSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.reviews.isEmpty) {
      return VitEmptyState(
        title: snapshot.emptyReviewsTitle,
        message: 'Merchant chưa có phản hồi từ giao dịch hoàn tất.',
      );
    }

    return Column(
      key: const ValueKey('merchant_reviews'),
      children: [
        for (final review in snapshot.reviews) ...[
          _ReviewCard(review: review),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final P2PMerchantProfileReviewDraft review;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  review.fromUser.characters.first,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.fromUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    Text(
                      review.createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < review.rating; i++)
                const Icon(Icons.star_rounded, color: AppColors.warn, size: 13),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            review.comment,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          VitStatusPill(
            label: review.positive ? 'Tích cực' : 'Tiêu cực',
            status: review.positive
                ? VitStatusPillStatus.success
                : VitStatusPillStatus.error,
            icon: review.positive
                ? Icons.thumb_up_alt_outlined
                : Icons.thumb_down_alt_outlined,
            size: VitStatusPillSize.sm,
          ),
        ],
      ),
    );
  }
}

String _formatInt(int value) {
  final chars = value.toString().split('');
  final buffer = StringBuffer();
  for (var i = 0; i < chars.length; i++) {
    final fromRight = chars.length - i;
    buffer.write(chars[i]);
    if (fromRight > 1 && fromRight % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _formatVnd(int value) {
  return _formatInt(value).replaceAll(',', '.');
}

String _formatCompactUsd(int value) {
  if (value >= 1000000) {
    final compact = value / 1000000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}K';
  }
  return value.toString();
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(4);
  }
  return value.toStringAsFixed(4);
}
