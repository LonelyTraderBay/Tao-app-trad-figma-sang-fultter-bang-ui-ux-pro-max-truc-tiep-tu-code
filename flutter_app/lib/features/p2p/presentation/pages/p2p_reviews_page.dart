import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

enum _P2PReviewTab { received, given }

class P2PReviewsPage extends ConsumerStatefulWidget {
  const P2PReviewsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc231_p2p_reviews_content');
  static const receivedTabKey = Key('sc231_p2p_reviews_received_tab');
  static const givenTabKey = Key('sc231_p2p_reviews_given_tab');

  static Key reviewKey(String id) => Key('sc231_p2p_review_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PReviewsPage> createState() => _P2PReviewsPageState();
}

class _P2PReviewsPageState extends ConsumerState<P2PReviewsPage> {
  _P2PReviewTab _tab = _P2PReviewTab.received;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pReviewsProvider);
    final reviews = _tab == _P2PReviewTab.received
        ? snapshot.receivedReviews
        : snapshot.givenReviews;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-231 P2PReviewsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Đánh giá P2P',
            subtitle: 'Đánh giá · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PReviewsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pMerchantCommerceScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        _ReviewSummaryCard(reviews: reviews),
                        VitTabBar(
                          variant: VitTabBarVariant.segment,
                          activeKey: _tab.name,
                          onChanged: (key) {
                            HapticFeedback.selectionClick();
                            setState(() => _tab = _tabFromKey(key));
                          },
                          tabs: const [
                            VitTabItem(key: 'received', label: 'Nhận được'),
                            VitTabItem(key: 'given', label: 'Đã viết'),
                          ],
                        ),
                        _ReviewList(
                          reviews: reviews,
                          emptyTitle: snapshot.emptyTitle,
                          tab: _tab,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _P2PReviewTab _tabFromKey(String key) {
    return _P2PReviewTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _P2PReviewTab.received,
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  const _ReviewSummaryCard({required this.reviews});

  final List<P2PReviewDraft> reviews;

  @override
  Widget build(BuildContext context) {
    final avgRating = _avgRating(reviews);
    final roundedRating = avgRating.round();
    final positiveCount = reviews.where((review) => review.positive).length;
    final negativeCount = reviews.length - positiveCount;

    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSpacing.x7 + AppSpacing.x5,
                child: Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    _StarStrip(rating: roundedRating, size: 12),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${reviews.length} đánh giá',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  children: [
                    for (final star in const [5, 4, 3, 2, 1]) ...[
                      _RatingDistributionRow(
                        star: star,
                        count: reviews
                            .where((review) => review.rating == star)
                            .length,
                        total: reviews.length,
                      ),
                      if (star != 1) const SizedBox(height: AppSpacing.x1),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          const Divider(color: AppColors.divider, height: AppSpacing.x2),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              _ToneCount(
                icon: Icons.thumb_up_alt_outlined,
                count: positiveCount,
                label: 'tích cực',
                color: AppColors.buy,
              ),
              const SizedBox(width: AppSpacing.x2),
              _ToneCount(
                icon: Icons.thumb_down_alt_outlined,
                count: negativeCount,
                label: 'tiêu cực',
                color: AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingDistributionRow extends StatelessWidget {
  const _RatingDistributionRow({
    required this.star,
    required this.count,
    required this.total,
  });

  final int star;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : count / total;
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.x4,
          child: Text(
            '$star',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const Icon(
          Icons.star_rounded,
          color: AppColors.warn,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(child: _ProgressTrack(value: progress)),
        const SizedBox(width: AppSpacing.x2),
        SizedBox(
          width: AppSpacing.x4,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: LinearProgressIndicator(
        minHeight: AppSpacing.x2,
        value: value.clamp(0, 1),
        backgroundColor: AppColors.surface2,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warn),
      ),
    );
  }
}

class _ToneCount extends StatelessWidget {
  const _ToneCount({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList({
    required this.reviews,
    required this.emptyTitle,
    required this.tab,
  });

  final List<P2PReviewDraft> reviews;
  final String emptyTitle;
  final _P2PReviewTab tab;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return VitEmptyState(
        title: emptyTitle,
        message: 'Lịch sử giao dịch P2P hoàn tất sẽ hiển thị tại đây.',
      );
    }

    return Column(
      key: ValueKey('p2p_reviews_${tab.name}'),
      children: [
        for (final review in reviews) ...[
          _ReviewCard(review: review, tab: tab),
          const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.tab});

  final P2PReviewDraft review;
  final _P2PReviewTab tab;

  @override
  Widget build(BuildContext context) {
    final displayUser = tab == _P2PReviewTab.received
        ? review.fromUser
        : review.toUser;
    final avatarLetter = displayUser.characters.first.toUpperCase();

    return VitCard(
      key: P2PReviewsPage.reviewKey(review.id),
      radius: VitCardRadius.standard,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ReviewAvatar(letter: avatarLetter),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Đơn #${review.orderId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                review.positive
                    ? Icons.thumb_up_alt_outlined
                    : Icons.thumb_down_alt_outlined,
                color: review.positive ? AppColors.buy : AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              _StarStrip(rating: review.rating, size: AppSpacing.iconSm),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            review.comment,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.25,
            ),
          ),
          if (review.reply != null) ...[
            const SizedBox(height: AppSpacing.x2),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: AppSpacing.dividerHairline,
                    child: ColoredBox(color: AppColors.warningBorder),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Phản hồi: ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppModuleAccents.p2p,
                          fontWeight: AppTextStyles.bold,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(
                            text: review.reply,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x2),
          Text(
            review.createdAt,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ReviewAvatar extends StatelessWidget {
  const _ReviewAvatar({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: letter,
      accentColor: AppColors.accent,
      size: AppSpacing.x6,
      radius: AppRadii.pillRadius,
    );
  }
}

class _StarStrip extends StatelessWidget {
  const _StarStrip({required this.rating, required this.size});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            Icons.star_rounded,
            color: i < rating ? AppColors.warn : AppColors.surface2,
            size: size,
          ),
      ],
    );
  }
}

double _avgRating(List<P2PReviewDraft> reviews) {
  if (reviews.isEmpty) return 0;
  final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
  return total / reviews.length;
}
