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
              padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                scrollEndClearance,
              ),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
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
                  _CategoryProgress(
                    categories: snapshot.categories,
                    completionLabel: snapshot.summary.completionLabel,
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
      density: VitDensity.compact,
      padding: ArenaSpacingTokens.arenaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Arena Points',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontWeight: AppTextStyles.heavy,
                  ),
                ),
              ),
              VitStatusPill(
                label: summary.tierLabel,
                icon: Icons.workspace_premium_outlined,
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Hoàn thành nhiệm vụ · nhận điểm Arena',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _RewardHeroKpi(
                  label: 'Số dư',
                  value: '${formatArenaPoints(summary.currentBalance)} pts',
                  valueStyle: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    letterSpacing: 0,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: AppSpacing.x6,
                color: AppColors.border,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _RewardHeroKpi(
                    label: 'Đã nhận',
                    value: '${summary.bonusPointsClaimed} pts',
                    valueStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.accent,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
                  value: formatArenaPoints(summary.lockedBalance),
                  color: AppColors.warn,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _PendingClaimBanner(
            summary: summary,
            claimedAll: claimedAll,
            onTap: onClaimAll,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ExpiringBanner(count: summary.expiringCount),
        ],
      ),
    );
  }
}

class _RewardHeroKpi extends StatelessWidget {
  const _RewardHeroKpi({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: valueStyle,
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
      padding: ArenaSpacingTokens.arenaPaddingX3,
      child: Row(
        children: [
          VitAccentIconBox(
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
                      : '${summary.pendingCount} phần thưởng đang chờ',
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
      padding: ArenaSpacingTokens.arenaPointsExpiringPadding,
      child: Row(
        children: [
          const Icon(
            Icons.timer_outlined,
            color: AppColors.sell,
            size: ArenaSpacingTokens.arenaPointsSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '$count nhiệm vụ sắp hết hạn · Hoàn thành thêm để giữ điểm',
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
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final category in categories) ...[
          _CategoryRow(category: category),
          if (category != categories.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
