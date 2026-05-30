import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/prediction_social_support_widgets.dart';

const _predictionPrimary = AppColors.primary;

enum _SocialTab { comments, analysis, share }

class PredictionSocialPage extends ConsumerStatefulWidget {
  const PredictionSocialPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc040_social_content');
  static const commentsTabKey = Key('sc040_tab_comments');
  static const analysisTabKey = Key('sc040_tab_analysis');
  static const shareTabKey = Key('sc040_tab_share');
  static const commentFieldKey = Key('sc040_comment_field');
  static const copyLinkKey = Key('sc040_copy_link');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionSocialPage> createState() =>
      _PredictionSocialPageState();
}

class _PredictionSocialPageState extends ConsumerState<PredictionSocialPage> {
  _SocialTab _activeTab = _SocialTab.comments;
  PredictionSocialStance _selectedStance = PredictionSocialStance.neutral;
  late final TextEditingController _commentController;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController()..addListener(_refresh);
  }

  @override
  void dispose() {
    _commentController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getSocial();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-040 PredictionSocialPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Social & Discussion',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            _SocialTabBar(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionSocialPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: switch (_activeTab) {
                      _SocialTab.comments => [
                        _EventInfoCard(snapshot: snapshot),
                        _NewCommentCard(
                          controller: _commentController,
                          selectedStance: _selectedStance,
                          onStanceChanged: (stance) =>
                              setState(() => _selectedStance = stance),
                        ),
                        _CommentsSection(snapshot: snapshot),
                        const _CommentDisclaimer(),
                      ],
                      _SocialTab.analysis => [
                        _SentimentCard(snapshot: snapshot),
                        _ContributorsSection(snapshot: snapshot),
                        const _SentimentTrendCard(),
                      ],
                      _SocialTab.share => [
                        _SocialShareButtons(snapshot: snapshot),
                        _CopyLinkCard(
                          snapshot: snapshot,
                          copied: _copied,
                          onCopy: () {
                            Clipboard.setData(
                              ClipboardData(text: snapshot.shareUrl),
                            );
                            setState(() => _copied = true);
                          },
                        ),
                        const _ShareStatsCard(),
                        _SharePreviewCard(snapshot: snapshot),
                      ],
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialTabBar extends StatelessWidget {
  const _SocialTabBar({required this.activeTab, required this.onChanged});

  final _SocialTab activeTab;
  final ValueChanged<_SocialTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        key: PredictionSocialPage.commentsTabKey,
        tab: _SocialTab.comments,
        label: 'Binh luan',
      ),
      (
        key: PredictionSocialPage.analysisTabKey,
        tab: _SocialTab.analysis,
        label: 'Phan tich',
      ),
      (
        key: PredictionSocialPage.shareTabKey,
        tab: _SocialTab.share,
        label: 'Chia se',
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            for (final item in tabs)
              Expanded(
                child: InkWell(
                  key: item.key,
                  onTap: () => onChanged(item.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: activeTab == item.tab
                                  ? _predictionPrimary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: activeTab == item.tab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: _predictionPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EventInfoCard extends StatelessWidget {
  const _EventInfoCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.eventTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.mode_comment_outlined,
                color: AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 7),
              Text(
                '${snapshot.totalComments} comments',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: 22),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                '${snapshot.bullishPercent}% Bullish',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewCommentCard extends StatelessWidget {
  const _NewCommentCard({
    required this.controller,
    required this.selectedStance,
    required this.onStanceChanged,
  });

  final TextEditingController controller;
  final PredictionSocialStance selectedStance;
  final ValueChanged<PredictionSocialStance> onStanceChanged;

  @override
  Widget build(BuildContext context) {
    final hasComment = controller.text.trim().isNotEmpty;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Them binh luan',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final stance in PredictionSocialStance.values) ...[
                Expanded(
                  child: _StanceButton(
                    stance: stance,
                    selected: selectedStance == stance,
                    onTap: () => onStanceChanged(stance),
                  ),
                ),
                if (stance != PredictionSocialStance.neutral)
                  const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 78,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: AppRadii.lgRadius,
            ),
            child: TextField(
              key: PredictionSocialPage.commentFieldKey,
              controller: controller,
              maxLines: 3,
              cursorColor: _predictionPrimary,
              style: AppTextStyles.body.copyWith(fontSize: 13),
              decoration: InputDecoration.collapsed(
                hintText: 'Chia se y kien cua ban...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text3,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _predictionPrimary.withValues(
                  alpha: hasComment ? 1 : .65,
                ),
                borderRadius: AppRadii.lgRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_outlined,
                    color: AppColors.onAccent.withValues(
                      alpha: hasComment ? 1 : .5,
                    ),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dang binh luan',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(
                        alpha: hasComment ? 1 : .55,
                      ),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StanceButton extends StatelessWidget {
  const _StanceButton({
    required this.stance,
    required this.selected,
    required this.onTap,
  });

  final PredictionSocialStance stance;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _stanceColor(stance);
    return SizedBox(
      height: 29,
      child: Material(
        color: selected ? color : AppColors.bg,
        borderRadius: AppRadii.inputRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.inputRadius,
          child: Center(
            child: Text(
              _stanceLabel(stance).toUpperCase(),
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.onAccent : AppColors.text2,
                fontWeight: AppTextStyles.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${snapshot.totalComments} binh luan',
      accentColor: _predictionPrimary,
      children: [
        for (final comment in snapshot.comments) _CommentCard(comment: comment),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, this.reply = false});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: reply ? 48 : 0),
      child: VitCard(
        borderColor: comment.isPinned ? AppColors.primary15 : AppColors.border,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TierAvatar(tier: comment.userTier),
                const SizedBox(width: 10),
                Expanded(child: _CommentUser(comment: comment)),
                const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.content,
              style: AppTextStyles.caption.copyWith(
                height: 1.55,
                color: AppColors.text1,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            _CommentActions(comment: comment, reply: reply),
            if (comment.replies.isNotEmpty) ...[
              const SizedBox(height: 14),
              for (final child in comment.replies)
                _CommentCard(comment: child, reply: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentUser extends StatelessWidget {
  const _CommentUser({required this.comment});

  final PredictionSocialCommentDraft comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              comment.userName,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontSize: 13,
              ),
            ),
            _SmallBadge(
              label: _tierLabel(comment.userTier),
              color: _tierColor(comment.userTier),
            ),
            if (comment.isPinned)
              const _SmallBadge(label: 'PINNED', color: _predictionPrimary),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.text3,
              size: 11,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                comment.createdAtLabel,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const SizedBox(width: 7),
            _SmallBadge(
              label: _stanceLabel(comment.stance).toUpperCase(),
              color: _stanceColor(comment.stance),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentActions extends StatelessWidget {
  const _CommentActions({required this.comment, required this.reply});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionPill(
          icon: Icons.thumb_up_alt_outlined,
          label: '${comment.upvotes}',
          color: AppColors.buy,
        ),
        const SizedBox(width: 8),
        _ActionPill(
          icon: Icons.thumb_down_alt_outlined,
          label: '${comment.downvotes}',
          color: AppColors.sell,
        ),
        if (!reply) ...[
          const SizedBox(width: 8),
          const _ActionPill(
            icon: Icons.mode_comment_outlined,
            label: 'Tra loi',
          ),
        ],
        const SizedBox(width: 10),
        const _ActionPill(
          icon: Icons.flag_outlined,
          label: 'Bao cao',
          flat: true,
        ),
      ],
    );
  }
}

class _TierAvatar extends StatelessWidget {
  const _TierAvatar({required this.tier});

  final PredictionSocialTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _tierColor(tier),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppColors.onAccent,
        size: 17,
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    this.color = AppColors.text3,
    this.flat = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: flat ? AppColors.transparent : AppColors.bg,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: flat ? AppColors.text3 : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentDisclaimer extends StatelessWidget {
  const _CommentDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Y kien nguoi dung chi mang tinh tham khao. Khong phai loi khuyen dau tu. Tu chiu trach nhiem quyet dinh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentCard extends StatelessWidget {
  const _SentimentCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Sentiment',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: CustomPaint(
              painter: PredictionSocialSentimentPiePainter(snapshot.sentiment),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final item in snapshot.sentiment)
                Expanded(child: PredictionSocialSentimentLegend(item: item)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributorsSection extends StatelessWidget {
  const _ContributorsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Nguoi dong gop hang dau',
      accentColor: _predictionPrimary,
      children: [
        for (var i = 0; i < snapshot.contributors.length; i += 1)
          _ContributorCard(rank: i, contributor: snapshot.contributors[i]),
      ],
    );
  }
}

class _SocialShareButtons extends StatelessWidget {
  const _SocialShareButtons({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chia se qua mang xa hoi',
      accentColor: _predictionPrimary,
      children: [
        Row(
          children: const [
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Twitter',
                color: AppColors.brandTwitter,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Facebook',
                color: AppColors.brandFacebook,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CopyLinkCard extends StatelessWidget {
  const _CopyLinkCard({
    required this.snapshot,
    required this.copied,
    required this.onCopy,
  });

  final PredictionSocialSnapshot snapshot;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sao chep lien ket',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    snapshot.shareUrl,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                key: PredictionSocialPage.copyLinkKey,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: onCopy,
                  icon: Icon(
                    copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 14,
                  ),
                  label: Text(copied ? 'Copied' : 'Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: copied
                        ? AppColors.buy
                        : _predictionPrimary,
                    foregroundColor: AppColors.onAccent,
                    textStyle: AppTextStyles.micro.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareStatsCard extends StatelessWidget {
  const _ShareStatsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: PredictionSocialMetric(
              label: 'Total Shares',
              value: '1,247',
            ),
          ),
          Expanded(
            child: PredictionSocialMetric(
              label: 'Views from Shares',
              value: '4,892',
              valueColor: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharePreviewCard extends StatelessWidget {
  const _SharePreviewCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Preview',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_predictionPrimary, AppColors.accent],
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.onAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.eventTitle,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Join the prediction market and share your insights with the community.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'app.example.com',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContributorCard extends StatelessWidget {
  const _ContributorCard({required this.rank, required this.contributor});

  final int rank;
  final PredictionContributorDraft contributor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: _rankColor(rank),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contributor.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _SmallBadge(
                      label: _tierLabel(contributor.tier),
                      color: _tierColor(contributor.tier),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${contributor.comments} comments - ${contributor.upvotes} upvotes',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentTrendCard extends StatelessWidget {
  const _SentimentTrendCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentiment Trend',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bullish sentiment tang 12% trong 24h qua. Cho thay su lac quan tang len.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

Color _stanceColor(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => AppColors.buy,
    PredictionSocialStance.bearish => AppColors.sell,
    PredictionSocialStance.neutral => AppColors.text3,
  };
}

String _stanceLabel(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => 'Bullish',
    PredictionSocialStance.bearish => 'Bearish',
    PredictionSocialStance.neutral => 'Neutral',
  };
}

Color _tierColor(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => AppColors.tierPlatinum,
    PredictionSocialTier.gold => AppColors.warn,
    PredictionSocialTier.silver => AppColors.medalSilverMuted,
    PredictionSocialTier.bronze => AppColors.medalBronzeMuted,
  };
}

String _tierLabel(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => 'PLATINUM',
    PredictionSocialTier.gold => 'GOLD',
    PredictionSocialTier.silver => 'SILVER',
    PredictionSocialTier.bronze => 'BRONZE',
  };
}

Color _rankColor(int rank) {
  return switch (rank) {
    0 => AppColors.warn,
    1 => AppColors.medalSilverMuted,
    _ => AppColors.medalBronzeMuted,
  };
}
