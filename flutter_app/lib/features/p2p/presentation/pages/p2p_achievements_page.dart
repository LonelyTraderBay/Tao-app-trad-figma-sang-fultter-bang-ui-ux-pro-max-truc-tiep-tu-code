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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PAchievementsPage extends ConsumerWidget {
  const P2PAchievementsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc275_p2p_achievements_summary');
  static const tradingLevelKey = Key('sc275_p2p_achievements_trading_level');

  static Key categoryKey(String id) => Key('sc275_p2p_achievements_cat_$id');

  static Key achievementKey(String id) =>
      Key('sc275_p2p_achievements_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRepositoryProvider).getAchievements();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-275 P2PAchievementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
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
                      _SummaryCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      for (final category in snapshot.categories) ...[
                        _AchievementCategory(
                          snapshot: snapshot,
                          category: category,
                        ),
                        const SizedBox(height: AppSpacing.x5),
                      ],
                      _TradingLevelLink(snapshot: snapshot),
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
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final P2PAchievementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progressPct = (snapshot.overallProgress * 100).round();

    return VitCard(
      key: P2PAchievementsPage.summaryKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _AchievementIconBubble(
                icon: Icons.emoji_events_outlined,
                color: AppModuleAccents.p2p,
                large: true,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thành tích đạt được',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.unlockedCount}/${snapshot.achievements.length}',
                      style: AppTextStyles.pageTitle.copyWith(
                        fontSize: 29,
                        height: 1.05,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _ProgressLine(
            label: 'Tiến trình tổng',
            value: '$progressPct%',
            progress: snapshot.overallProgress,
            color: AppModuleAccents.p2p,
            minHeight: 8,
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  value: '+${snapshot.totalReputationPoints}',
                  label: 'Điểm uy tín',
                  color: AppModuleAccents.p2p,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryMetric(
                  value: '${snapshot.unlockedBadgeCount}',
                  label: 'Huy hiệu',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryMetric(
                  value: 'Lv.${snapshot.currentLevel}',
                  label: 'Cấp hiện tại',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _AchievementCategory extends StatelessWidget {
  const _AchievementCategory({required this.snapshot, required this.category});

  final P2PAchievementsSnapshot snapshot;
  final P2PAchievementCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final achievements = snapshot.achievementsFor(category.id);
    final unlocked = achievements.where((item) => item.unlocked).length;
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      key: P2PAchievementsPage.categoryKey(category.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              category.label,
              style: AppTextStyles.sectionTitle.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            VitStatusPill(
              label: '$unlocked/${achievements.length}',
              status: VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < achievements.length; index++) ...[
          _AchievementCard(achievement: achievements[index]),
          if (index != achievements.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final P2PAchievementDraft achievement;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(achievement.toneKey);
    final textColor = achievement.unlocked ? AppColors.text1 : AppColors.text3;

    return VitCard(
      key: P2PAchievementsPage.achievementKey(achievement.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AchievementIconBubble(
            icon: achievement.unlocked
                ? _achievementIcon(achievement.iconKey)
                : Icons.lock_outline_rounded,
            color: achievement.unlocked ? color : AppColors.surface3,
            locked: !achievement.unlocked,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: textColor,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (achievement.unlockedAt != null) ...[
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        achievement.unlockedAt!,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  achievement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (!achievement.unlocked) ...[
                  const SizedBox(height: AppSpacing.x3),
                  _ProgressLine(
                    label: achievement.currentValueLabel,
                    value: achievement.progressLabel,
                    progress: achievement.progress,
                    color: color,
                    minHeight: 6,
                  ),
                ],
                const SizedBox(height: AppSpacing.x3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _RewardPill(
                    reward: achievement.reward,
                    color: achievement.unlocked
                        ? AppColors.buy
                        : AppColors.text3,
                    unlocked: achievement.unlocked,
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

class _AchievementIconBubble extends StatelessWidget {
  const _AchievementIconBubble({
    required this.icon,
    required this.color,
    this.large = false,
    this.locked = false,
    this.showBadge = true,
  });

  final IconData icon;
  final Color color;
  final bool large;
  final bool locked;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final size = large ? 56.0 : 44.0;
    final iconSize = large ? 28.0 : 21.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: locked ? .34 : .22),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Icon(
            icon,
            color: locked ? AppColors.text3 : color,
            size: iconSize,
          ),
        ),
        if (!large && !locked && showBadge)
          Positioned(
            right: -3,
            bottom: -3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.buy,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.minHeight,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: minHeight,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({
    required this.reward,
    required this.color,
    required this.unlocked,
  });

  final String reward;
  final Color color;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.buy10 : AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded, color: color, size: 11),
          const SizedBox(width: AppSpacing.x1),
          Flexible(
            child: Text(
              reward,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradingLevelLink extends StatelessWidget {
  const _TradingLevelLink({required this.snapshot});

  final P2PAchievementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAchievementsPage.tradingLevelKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(snapshot.tradingLevelRoute);
      },
      child: Row(
        children: [
          const _AchievementIconBubble(
            icon: Icons.trending_up_rounded,
            color: AppColors.primary,
            showBadge: false,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem cấp bậc giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Nâng cấp để mở thêm quyền lợi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

IconData _achievementIcon(String iconKey) {
  return switch (iconKey) {
    'bolt' => Icons.bolt_rounded,
    'target' => Icons.track_changes_rounded,
    'medal' => Icons.workspace_premium_outlined,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'star' => Icons.star_border_rounded,
    'users' => Icons.groups_2_outlined,
    _ => Icons.emoji_events_outlined,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'warning' => AppModuleAccents.p2p,
    'accent' => AppColors.accent,
    'highlight' => AppColors.sell,
    'orange' => AppColors.primary,
    _ => AppColors.primary,
  };
}
