import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

class ArenaPointsPage extends ConsumerStatefulWidget {
  const ArenaPointsPage({
    super.key,
    this.shellRenderMode,
    this.snapshotOverride,
    this.semanticLabel = 'SC-196 ArenaPointsPage',
    this.backRoute = AppRoutePaths.arena,
    this.referralRoute = AppRoutePaths.referral,
    this.leaderboardRoute = AppRoutePaths.arenaLeaderboard,
  });

  static const contentKey = Key('sc196_arena_points_content');
  static const claimAllKey = Key('sc196_claim_all');
  static const referralKey = Key('sc196_referral');
  static const leaderboardKey = Key('sc196_leaderboard_all');

  static Key filterKey(String label) => Key('sc196_filter_$label');
  static Key taskKey(String id) => Key('sc196_task_$id');

  final ShellRenderMode? shellRenderMode;
  final ArenaPointsSnapshot? snapshotOverride;
  final String semanticLabel;
  final String backRoute;
  final String referralRoute;
  final String leaderboardRoute;

  @override
  ConsumerState<ArenaPointsPage> createState() => _ArenaPointsPageState();
}

class _ArenaPointsPageState extends ConsumerState<ArenaPointsPage> {
  String _activeFilter = 'Tất cả';
  bool _claimedAll = false;

  @override
  Widget build(BuildContext context) {
    final snapshot =
        widget.snapshotOverride ??
        ref.watch(arenaRepositoryProvider).getArenaPoints();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final visibleTasks = snapshot.tasks
        .where(
          (task) => _activeFilter == 'Tất cả' || task.filter == _activeFilter,
        )
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Trung tâm Phần thưởng',
              subtitle: 'Phần thưởng · Rewards',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaPointsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _RewardsHero(
                        snapshot: snapshot,
                        claimedAll: _claimedAll,
                        onClaimAll: () {
                          HapticFeedback.selectionClick();
                          setState(() => _claimedAll = true);
                        },
                      ),
                      _CheckInSection(checkIns: snapshot.checkIns),
                      _ReferralBanner(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(widget.referralRoute);
                        },
                      ),
                      _TaskSection(
                        filters: snapshot.filters,
                        activeFilter: _activeFilter,
                        tasks: visibleTasks,
                        onFilter: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeFilter = filter);
                        },
                      ),
                      _BonusSection(rows: snapshot.bonusRows),
                      _ProgressSection(
                        summary: snapshot.summary,
                        leaderboard: snapshot.leaderboard,
                        onLeaderboardTap: () {
                          HapticFeedback.selectionClick();
                          context.go(widget.leaderboardRoute);
                        },
                      ),
                      _RewardsDisclaimer(text: snapshot.disclaimer),
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

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(widget.backRoute);
  }
}

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({
    required this.snapshot,
    required this.claimedAll,
    required this.onClaimAll,
  });

  final ArenaPointsSnapshot snapshot;
  final bool claimedAll;
  final VoidCallback onClaimAll;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    final available = summary.currentBalance - summary.lockedBalance;

    return VitModuleHeroCard(
      accentColor: AppColors.accent,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Row(
            children: [
              _AccentIcon(
                icon: Icons.emoji_events_outlined,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phần thưởng',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Hoàn thành nhiệm vụ — nhận USDT + Points',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: summary.tierLabel,
                icon: Icons.workspace_premium_outlined,
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _RewardMetricCard(
                  label: 'USDT đã nhận',
                  value: '${summary.usdtClaimed} USDT',
                  helper:
                      '${summary.claimedCount} xong · ${summary.pendingCount} chờ',
                  icon: Icons.redeem_outlined,
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _RewardMetricCard(
                  label: 'Arena Points',
                  value: '${formatArenaPoints(summary.currentBalance)} pts',
                  helper: 'Hạng #${summary.rank} · Top ${summary.topPercent}%',
                  icon: Icons.bolt_outlined,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _BalanceBreakdown(
            available: available,
            locked: summary.lockedBalance,
          ),
          const SizedBox(height: AppSpacing.x4),
          _PendingClaimBanner(
            summary: summary,
            claimedAll: claimedAll,
            onTap: onClaimAll,
          ),
          const SizedBox(height: AppSpacing.x3),
          _ExpiringBanner(count: summary.expiringCount),
          const SizedBox(height: AppSpacing.x4),
          _CategoryProgress(
            categories: snapshot.categories,
            completionLabel: summary.completionLabel,
          ),
        ],
      ),
    );
  }
}

class _RewardMetricCard extends StatelessWidget {
  const _RewardMetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            helper,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceBreakdown extends StatelessWidget {
  const _BalanceBreakdown({required this.available, required this.locked});

  final int available;
  final int locked;

  @override
  Widget build(BuildContext context) {
    final total = available + locked;
    final ratio = total == 0 ? 0.0 : available / total;

    return Column(
      children: [
        _ProgressBar(
          value: ratio,
          color: AppColors.buy,
          trackColor: AppColors.warn15,
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _TinyStat(
                icon: Icons.lock_open_outlined,
                label: 'Khả dụng',
                value: formatArenaPoints(available),
                color: AppColors.buy,
              ),
            ),
            Expanded(
              child: _TinyStat(
                icon: Icons.lock_outline_rounded,
                label: 'Đang khóa',
                value: formatArenaPoints(locked),
                color: AppColors.warn,
                alignEnd: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PendingClaimBanner extends StatelessWidget {
  const _PendingClaimBanner({
    required this.summary,
    required this.claimedAll,
    required this.onTap,
  });

  final ArenaPointsSummaryDraft summary;
  final bool claimedAll;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaPointsPage.claimAllKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: claimedAll ? AppColors.buy20 : AppColors.warningBorder,
      onTap: claimedAll ? null : onTap,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _AccentIcon(
            icon: claimedAll
                ? Icons.check_circle_outline
                : Icons.inventory_2_outlined,
            color: claimedAll ? AppColors.buy : AppColors.warn,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  claimedAll
                      ? 'Đã nhận hết phần thưởng chờ'
                      : '${summary.pendingCount} phần thưởng chờ nhận',
                  style: AppTextStyles.caption.copyWith(
                    color: claimedAll ? AppColors.buy : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '+${summary.pendingUsdt} USDT · +${summary.pendingPoints} pts',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          if (!claimedAll)
            VitStatusPill(
              label: 'Nhận tất cả',
              status: VitStatusPillStatus.orange,
              size: VitStatusPillSize.md,
            ),
        ],
      ),
    );
  }
}

class _ExpiringBanner extends StatelessWidget {
  const _ExpiringBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.sell20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.sell, size: 14),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '$count nhiệm vụ sắp hết hạn · Giao dịch 5 lệnh Spot',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Xem',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({
    required this.categories,
    required this.completionLabel,
  });

  final List<ArenaPointsCategoryDraft> categories;
  final String completionLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tiến độ theo danh mục',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              completionLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final category in categories) ...[
          _CategoryRow(category: category),
          if (category != categories.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            _Legend(label: 'Đã nhận', color: AppColors.buy),
            const SizedBox(width: AppSpacing.x3),
            _Legend(label: 'Chờ nhận', color: AppColors.warn),
            const SizedBox(width: AppSpacing.x3),
            _Legend(label: 'Đang làm', color: AppColors.text3),
          ],
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final ArenaPointsCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(category.kind);
    final value = category.total == 0 ? 0.0 : category.done / category.total;

    return Row(
      children: [
        SizedBox(
          width: AppSpacing.buttonHero,
          child: Row(
            children: [
              Container(
                width: AppSpacing.x2,
                height: AppSpacing.x2,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _ProgressBar(value: value, color: color),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '${category.done}/${category.total}',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (category.pending > 0) ...[
          const SizedBox(width: AppSpacing.x1),
          _MiniBadge(label: '${category.pending}', color: AppColors.warn),
        ],
      ],
    );
  }
}

class _CheckInSection extends StatelessWidget {
  const _CheckInSection({required this.checkIns});

  final List<ArenaDailyCheckInDraft> checkIns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(
          title: 'Check-in hằng ngày',
          icon: Icons.calendar_month_outlined,
          trailing: '4/7',
          color: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            children: [
              Row(
                children: [
                  for (final item in checkIns) ...[
                    Expanded(child: _CheckInTile(item: item)),
                    if (item != checkIns.last)
                      const SizedBox(width: AppSpacing.x2),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text3,
                    size: 13,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      '7 ngày liên tiếp: 100 pts + 0.5 USDT',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckInTile extends StatelessWidget {
  const _CheckInTile({required this.item});

  final ArenaDailyCheckInDraft item;

  @override
  Widget build(BuildContext context) {
    final active = item.claimed || item.today;
    final color = item.today ? AppColors.accent : AppColors.buy;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x1,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: .13) : AppColors.surface2,
        border: Border.all(
          color: active ? color.withValues(alpha: .30) : AppColors.cardBorder,
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: item.today ? AppColors.accent : AppColors.text3,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Icon(
            item.claimed ? Icons.check_circle_outline : Icons.circle_outlined,
            color: color,
            size: 17,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.reward,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralBanner extends StatelessWidget {
  const _ReferralBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: ArenaPointsPage.referralKey,
      accentColor: AppColors.buy,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AccentIcon(icon: Icons.group_add_outlined, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mời bạn bè, cùng nhận thưởng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '15 USDT + 200 pts mỗi lượt mời',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.buy,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.filters,
    required this.activeFilter,
    required this.tasks,
    required this.onFilter,
  });

  final List<String> filters;
  final String activeFilter;
  final List<ArenaRewardTaskDraft> tasks;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'Nhiệm vụ',
          trailing: '5/24 hoàn thành',
          icon: Icons.task_alt_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.x2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final filter in filters) ...[
                _FilterButton(
                  label: filter,
                  active: filter == activeFilter,
                  onTap: () => onFilter(filter),
                ),
                if (filter != filters.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        if (tasks.isEmpty)
          const VitEmptyState(
            icon: Icons.redeem_outlined,
            title: 'Không có nhiệm vụ nào',
            message: 'Chọn danh mục khác hoặc quay lại sau.',
          )
        else
          Column(
            children: [
              for (final task in tasks) ...[
                _TaskCard(task: task),
                if (task != tasks.last) const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaPointsPage.filterKey(label),
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: active ? AppColors.primary30 : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final ArenaRewardTaskDraft task;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(task.kind);

    return VitCard(
      key: ArenaPointsPage.taskKey(task.id),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x5,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AccentIcon(icon: _accentIcon(task.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TaskStatusPill(status: task.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  task.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x5),
                _ProgressBar(value: task.progress, color: color),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.rewardLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: task.status == ArenaRewardTaskStatus.claimed
                              ? AppColors.buy
                              : AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${(task.progress * 100).round()}%',
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BonusSection extends StatelessWidget {
  const _BonusSection({required this.rows});

  final List<ArenaBonusRowDraft> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'Khu vực Bonus',
          trailing: '1 lượt quay',
          icon: Icons.auto_awesome_outlined,
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            children: [
              for (final row in rows) ...[
                _BonusRow(row: row),
                if (row != rows.last)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.row});

  final ArenaBonusRowDraft row;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(row.kind);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AccentIcon(icon: _accentIcon(row.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  row.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            row.rewardLabel,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.summary,
    required this.leaderboard,
    required this.onLeaderboardTap,
  });

  final ArenaPointsSummaryDraft summary;
  final List<ArenaPointsLeaderboardDraft> leaderboard;
  final VoidCallback onLeaderboardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'Tiến trình & Phần thưởng',
          trailing: 'Bạc',
          icon: Icons.workspace_premium_outlined,
          color: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _AccentIcon(
                    icon: Icons.workspace_premium_outlined,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bạc',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Cần thêm points để lên hạng Vàng',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${formatArenaPoints(summary.currentBalance)} pts',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _ProgressBar(value: .56, color: AppColors.accent),
              const SizedBox(height: AppSpacing.x5),
              Text(
                'Bảng xếp hạng',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: VitStatusPill(
                  key: ArenaPointsPage.leaderboardKey,
                  label: 'Tất cả',
                  icon: Icons.chevron_right_rounded,
                  status: VitStatusPillStatus.purple,
                  size: VitStatusPillSize.sm,
                  onTap: onLeaderboardTap,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (final entry in leaderboard) ...[
                _LeaderboardRow(entry: entry),
                if (entry != leaderboard.last)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final ArenaPointsLeaderboardDraft entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x6,
            child: Text(
              '#${entry.rank}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.name,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
          Text(
            entry.pointsLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsDisclaimer extends StatelessWidget {
  const _RewardsDisclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 17),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.35,
              ),
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
    required this.icon,
    required this.color,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
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

class _TaskStatusPill extends StatelessWidget {
  const _TaskStatusPill({required this.status});

  final ArenaRewardTaskStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ArenaRewardTaskStatus.completed => const VitStatusPill(
        label: 'Nhận',
        status: VitStatusPillStatus.orange,
        size: VitStatusPillSize.sm,
      ),
      ArenaRewardTaskStatus.claimed => const VitStatusPill(
        label: 'Đã nhận',
        status: VitStatusPillStatus.success,
        size: VitStatusPillSize.sm,
      ),
      ArenaRewardTaskStatus.active => const VitStatusPill(
        label: 'Đang làm',
        status: VitStatusPillStatus.neutral,
        size: VitStatusPillSize.sm,
      ),
    };
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.color,
    this.trackColor = AppColors.surface3,
  });

  final double value;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: Container(
        height: AppSpacing.x3,
        color: trackColor,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: safeValue,
          child: Container(color: color),
        ),
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            value,
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

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.x2,
          height: AppSpacing.x2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      decoration: BoxDecoration(color: color, borderRadius: AppRadii.xsRadius),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.bg,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

Color _accentColor(ArenaRewardAccentKind kind) {
  return switch (kind) {
    ArenaRewardAccentKind.daily => AppColors.primary,
    ArenaRewardAccentKind.weekly => AppColors.accent,
    ArenaRewardAccentKind.flash => AppColors.sell,
    ArenaRewardAccentKind.learn => AppColors.buy,
    ArenaRewardAccentKind.achievement => AppColors.warn,
    ArenaRewardAccentKind.arena => AppColors.buy,
    ArenaRewardAccentKind.p2p => AppColors.primarySoft,
    ArenaRewardAccentKind.referral => AppColors.buy,
    ArenaRewardAccentKind.neutral => AppColors.text2,
  };
}

IconData _accentIcon(ArenaRewardAccentKind kind) {
  return switch (kind) {
    ArenaRewardAccentKind.daily => Icons.local_fire_department_outlined,
    ArenaRewardAccentKind.weekly => Icons.calendar_view_week_outlined,
    ArenaRewardAccentKind.flash => Icons.bolt_outlined,
    ArenaRewardAccentKind.learn => Icons.school_outlined,
    ArenaRewardAccentKind.achievement => Icons.emoji_events_outlined,
    ArenaRewardAccentKind.arena => Icons.shield_outlined,
    ArenaRewardAccentKind.p2p => Icons.handshake_outlined,
    ArenaRewardAccentKind.referral => Icons.group_add_outlined,
    ArenaRewardAccentKind.neutral => Icons.task_alt_outlined,
  };
}
