part of 'arena_points_page.dart';

class _ArenaPointsPageState extends ConsumerState<ArenaPointsPage> {
  String _activeFilter = 'Tất cả';
  bool _claimedAll = false;

  @override
  void initState() {
    super.initState();
    final initialFilter = widget.initialFilter;
    if (initialFilter != null) {
      _activeFilter = initialFilter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot =
        widget.snapshotOverride ??
        ref.watch(arenaReadModelControllerProvider).getArenaPoints();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
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
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Trung tâm Phần thưởng',
            subtitle: 'Phần thưởng · Rewards',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: ArenaPointsPage.contentKey,
              physics: const ClampingScrollPhysics(),
              padding: AppSpacing.arenaBottomScrollPadding(scrollEndClearance),
              child: VitPageContent(
                padding: VitContentPadding.compact,
                gap: VitContentGap.tight,
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
      padding: AppSpacing.arenaPaddingX5,
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
                      'Hoàn thành nhiệm vụ - nhận Arena Points',
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
                  label: 'Points đã nhận',
                  value: '${summary.bonusPointsClaimed} pts',
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.arenaPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.arenaPointsMicroIcon),
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
      radius: VitCardRadius.standard,
      borderColor: claimedAll ? AppColors.buy20 : AppColors.warningBorder,
      onTap: claimedAll ? null : onTap,
      padding: AppSpacing.arenaPaddingX3,
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
                      ? 'All pending rewards claimed'
                      : '${summary.pendingCount} rewards waiting',
                  style: AppTextStyles.caption.copyWith(
                    color: claimedAll ? AppColors.buy : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '+${summary.pendingBonusPoints} bonus pts · +${summary.pendingPoints} pts',
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
      radius: VitCardRadius.standard,
      borderColor: AppColors.sell20,
      padding: AppSpacing.arenaPointsExpiringPadding,
      child: Row(
        children: [
          const Icon(
            Icons.timer_outlined,
            color: AppColors.sell,
            size: AppSpacing.arenaPointsSmallIcon,
          ),
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
