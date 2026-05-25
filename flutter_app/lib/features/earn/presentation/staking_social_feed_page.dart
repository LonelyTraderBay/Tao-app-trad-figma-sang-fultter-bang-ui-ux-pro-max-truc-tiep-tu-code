import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingSocialFeedPage extends ConsumerStatefulWidget {
  const StakingSocialFeedPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc387_info');
  static const composerKey = Key('sc387_composer');
  static const tabsKey = Key('sc387_tabs');
  static const feedKey = Key('sc387_feed');
  static const statsKey = Key('sc387_stats');
  static const footerKey = Key('sc387_footer');

  static Key postKey(String id) => Key('sc387_post_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSocialFeedPage> createState() =>
      _StakingSocialFeedPageState();
}

class _StakingSocialFeedPageState extends ConsumerState<StakingSocialFeedPage> {
  String? _activeTabId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingSocialFeedRepositoryProvider).getFeed();
    final activeTab = snapshot.tabs.firstWhere(
      (tab) => tab.id == (_activeTabId ?? snapshot.defaultTabId),
      orElse: () => snapshot.tabs.first,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-387 StakingSocialFeedPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _Composer(placeholder: snapshot.composerPlaceholder),
                    _FeedTabs(
                      tabs: snapshot.tabs,
                      activeTabId: activeTab.id,
                      onChanged: (id) => setState(() => _activeTabId = id),
                    ),
                    _PostsSection(
                      title: activeTab.sectionTitle,
                      posts: snapshot.posts,
                    ),
                    _CommunityStats(stats: snapshot.stats),
                    _FooterNote(note: snapshot.footerNote),
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingSocialFeedSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.composerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const _Avatar(label: 'Me', icon: Icons.person_rounded),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedTabs extends StatelessWidget {
  const _FeedTabs({
    required this.tabs,
    required this.activeTabId,
    required this.onChanged,
  });

  final List<StakingSocialFeedTabDraft> tabs;
  final String activeTabId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.tabsKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTabId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
      ),
    );
  }
}

class _PostsSection extends StatelessWidget {
  const _PostsSection({required this.title, required this.posts});

  final String title;
  final List<StakingSocialFeedPostDraft> posts;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingSocialFeedPage.feedKey,
      label: title,
      accentColor: AppColors.primarySoft,
      children: [for (final post in posts) _PostCard(post: post)],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final StakingSocialFeedPostDraft post;

  @override
  Widget build(BuildContext context) {
    final typeMeta = _PostTypeMeta.fromType(post.type);
    return VitCard(
      key: StakingSocialFeedPage.postKey(post.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(label: post.avatarLabel, icon: typeMeta.avatarIcon),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(post.author, style: AppTextStyles.baseMedium),
                        if (post.badge != null)
                          _Pill(
                            label: post.badge!,
                            color: AppColors.primarySoft,
                            emphasis: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          post.timestamp,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _TypeChip(meta: typeMeta),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            post.content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          if (post.asset != null || post.apy != null) ...[
            const SizedBox(height: AppSpacing.x4),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                if (post.asset != null)
                  _Pill(label: post.asset!, color: AppColors.primary),
                if (post.apy != null)
                  _Pill(label: post.apy!, color: AppColors.buy, emphasis: true),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _ActionMetric(
                icon: Icons.thumb_up_alt_outlined,
                value: post.likes,
              ),
              const SizedBox(width: AppSpacing.x4),
              _ActionMetric(
                icon: Icons.chat_bubble_outline_rounded,
                value: post.comments,
              ),
              const Spacer(),
              const Icon(
                Icons.share_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: const BoxDecoration(
        color: AppColors.primary12,
        borderRadius: AppRadii.lgRadius,
      ),
      alignment: Alignment.center,
      child: Semantics(
        label: label,
        child: Icon(
          icon,
          color: AppColors.primarySoft,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.meta});

  final _PostTypeMeta meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: meta.background,
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: meta.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, color: meta.color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x1),
          Text(
            meta.label,
            style: AppTextStyles.micro.copyWith(color: meta.color, height: 1),
          ),
        ],
      ),
    );
  }
}

class _ActionMetric extends StatelessWidget {
  const _ActionMetric({required this.icon, required this.value});

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$value',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _CommunityStats extends StatelessWidget {
  const _CommunityStats({required this.stats});

  final List<StakingSocialFeedStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Community Stats', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.x3),
                Expanded(child: _StatTile(stat: stats[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingSocialFeedStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: stat.tone == 'success' ? AppColors.buy20 : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.tone == 'success' ? color : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.emphasis = false,
  });

  final String label;
  final Color color;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: _softBackground(color),
        borderRadius: AppRadii.smRadius,
        border: emphasis ? Border.all(color: _softBorder(color)) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

final class _PostTypeMeta {
  const _PostTypeMeta({
    required this.label,
    required this.icon,
    required this.avatarIcon,
    required this.color,
    required this.background,
    required this.border,
  });

  final String label;
  final IconData icon;
  final IconData avatarIcon;
  final Color color;
  final Color background;
  final Color border;

  factory _PostTypeMeta.fromType(String type) {
    switch (type) {
      case 'tip':
        return const _PostTypeMeta(
          label: 'Pro Tip',
          icon: Icons.trending_up_rounded,
          avatarIcon: Icons.insert_chart_outlined_rounded,
          color: AppColors.accent,
          background: AppColors.accent12,
          border: AppColors.accent20,
        );
      case 'achievement':
        return const _PostTypeMeta(
          label: 'Achievement',
          icon: Icons.workspace_premium_outlined,
          avatarIcon: Icons.shield_outlined,
          color: AppColors.primarySoft,
          background: AppColors.warningBg,
          border: AppColors.warningBorder,
        );
      case 'discussion':
        return const _PostTypeMeta(
          label: 'Discussion',
          icon: Icons.chat_bubble_outline_rounded,
          avatarIcon: Icons.construction_rounded,
          color: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.buy20,
        );
      case 'milestone':
      default:
        return const _PostTypeMeta(
          label: 'Milestone',
          icon: Icons.chat_bubble_outline_rounded,
          avatarIcon: Icons.savings_outlined,
          color: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.buy20,
        );
    }
  }
}

Color _toneColor(String tone) {
  switch (tone) {
    case 'success':
      return AppColors.buy;
    case 'warning':
      return AppColors.warn;
    case 'danger':
      return AppColors.sell;
    default:
      return AppColors.text2;
  }
}

Color _softBackground(Color color) {
  if (color == AppColors.buy) return AppColors.buy10;
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return AppColors.primary12;
  }
  if (color == AppColors.sell) return AppColors.sell10;
  if (color == AppColors.accent) return AppColors.accent12;
  return AppColors.surface2;
}

Color _softBorder(Color color) {
  if (color == AppColors.buy) return AppColors.buy20;
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return AppColors.primary20;
  }
  if (color == AppColors.sell) return AppColors.sell20;
  if (color == AppColors.accent) return AppColors.accent20;
  return AppColors.cardBorder;
}
