import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingForumPage extends ConsumerWidget {
  const StakingForumPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc392_forum_hero');
  static const categoriesKey = Key('sc392_forum_categories');
  static const threadsKey = Key('sc392_forum_threads');
  static const createKey = Key('sc392_create_thread');

  static Key categoryKey(String name) => Key('sc392_category_$name');

  static Key threadKey(int index) => Key('sc392_thread_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(stakingForumRepositoryProvider).getForum();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-392 StakingForumPage',
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
                  padding: VitContentPadding.defaultPadding,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _ForumHero(snapshot: snapshot),
                    _CategoryGrid(
                      title: snapshot.categoriesTitle,
                      categories: snapshot.categories,
                    ),
                    _TrendingThreads(
                      title: snapshot.threadsTitle,
                      threads: snapshot.threads,
                    ),
                    VitCtaButton(
                      key: StakingForumPage.createKey,
                      onPressed: () {},
                      child: Text(snapshot.createLabel),
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

class _ForumHero extends StatelessWidget {
  const _ForumHero({required this.snapshot});

  final StakingForumSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.title, required this.categories});

  final String title;
  final List<StakingForumCategoryDraft> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingForumPage.categoriesKey,
      label: title,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: 2.9,
          ),
          itemBuilder: (context, index) =>
              _CategoryCard(category: categories[index]),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final StakingForumCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.categoryKey(category.name),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '${category.threads} threads - ${category.posts} posts',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TrendingThreads extends StatelessWidget {
  const _TrendingThreads({required this.title, required this.threads});

  final String title;
  final List<StakingForumThreadDraft> threads;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingForumPage.threadsKey,
      label: title,
      children: [
        for (var index = 0; index < threads.length; index++)
          _ThreadCard(thread: threads[index], index: index),
      ],
    );
  }
}

class _ThreadCard extends StatelessWidget {
  const _ThreadCard({required this.thread, required this.index});

  final StakingForumThreadDraft thread;
  final int index;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.threadKey(index),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (thread.pinned) ...[
                const Icon(
                  Icons.push_pin_outlined,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
              Expanded(
                child: Text(
                  thread.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                thread.author,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              _ThreadMetric(
                icon: Icons.mode_comment_outlined,
                value: thread.replies.toString(),
              ),
              _ThreadMetric(
                icon: Icons.trending_up_rounded,
                value: thread.views.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThreadMetric extends StatelessWidget {
  const _ThreadMetric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.iconSm, color: AppColors.text3),
        const SizedBox(width: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
