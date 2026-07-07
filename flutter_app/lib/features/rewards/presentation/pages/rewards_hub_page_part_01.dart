part of 'rewards_hub_page.dart';

class _RewardsHubPageState extends ConsumerState<RewardsHubPage> {
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
    final snapshot = ref.watch(rewardsControllerProvider).getHub();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final visibleTasks = snapshot.tasks
        .where(
          (task) => _activeFilter == 'Tất cả' || task.filter == _activeFilter,
        )
        .toList(growable: false);
    final showOfflineBanner =
        snapshot.screenState == RewardsScreenState.offline &&
        snapshot.tasks.isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-319 RewardsHubPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => _close(context, snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showOfflineBanner)
                Padding(
                  key: RewardsHubPage.offlineKey,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: const VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị phần thưởng đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: RewardsHubPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      children: switch (snapshot.screenState) {
                        RewardsScreenState.loading => [
                          const VitSkeletonList(
                            key: RewardsHubPage.loadingKey,
                            rows: 4,
                          ),
                        ],
                        RewardsScreenState.error => [
                          VitErrorState(
                            key: RewardsHubPage.errorKey,
                            title: 'Không tải được phần thưởng',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () => context.go(snapshot.backRoute),
                          ),
                        ],
                        RewardsScreenState.empty => [
                          VitEmptyState(
                            key: RewardsHubPage.emptyKey,
                            icon: Icons.redeem_outlined,
                            title: 'Chưa có phần thưởng',
                            message:
                                'Hoàn thành nhiệm vụ để nhận Arena Points.',
                            actionLabel: 'Về trang chủ',
                            onAction: () => context.go(snapshot.backRoute),
                          ),
                        ],
                        RewardsScreenState.offline
                            when snapshot.tasks.isEmpty =>
                          [
                            VitEmptyState(
                              key: RewardsHubPage.offlineKey,
                              icon: Icons.wifi_off_rounded,
                              title: 'Đang ngoại tuyến',
                              message:
                                  'Kết nối lại để xem phần thưởng mới nhất.',
                            ),
                          ],
                        _ => [
                          _RewardsHero(
                            summary: snapshot.summary,
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
                              context.go(snapshot.referralRoute);
                            },
                          ),
                          _TaskSection(
                            completionLabel: snapshot.summary.completionLabel,
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
                              context.go(snapshot.leaderboardRoute);
                            },
                          ),
                          _RewardsDisclaimer(text: snapshot.disclaimer),
                        ],
                      },
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

  void _close(BuildContext context, String backRoute) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(backRoute);
  }
}

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({
    required this.summary,
    required this.claimedAll,
    required this.onClaimAll,
  });

  final RewardSummaryDraft summary;
  final bool claimedAll;
  final VoidCallback onClaimAll;

  @override
  Widget build(BuildContext context) {
    final available = summary.currentPoints - summary.lockedPoints;

    return VitModuleHeroCard(
      accentColor: AppModuleAccents.rewards,
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
                  value: '${_formatRewardPoints(summary.currentPoints)} pts',
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
                      color: AppModuleAccents.rewards,
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
                  value: _formatRewardPoints(available),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _TinyStat(
                  icon: Icons.lock_outline_rounded,
                  label: 'Đang khóa',
                  value: _formatRewardPoints(summary.lockedPoints),
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

  final RewardSummaryDraft summary;
  final bool claimedAll;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: RewardsHubPage.claimAllKey,
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
            const VitStatusPill(
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

  final List<RewardCategoryDraft> categories;
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
        const Row(
          children: [
            _Legend(label: 'Đã nhận', color: AppColors.buy),
            SizedBox(width: AppSpacing.x3),
            _Legend(label: 'Chờ nhận', color: AppColors.warn),
            SizedBox(width: AppSpacing.x3),
            _Legend(label: 'Đang làm', color: AppColors.text3),
          ],
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final RewardCategoryDraft category;

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
              SizedBox(
                width: AppSpacing.x2,
                height: AppSpacing.x2,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: const CircleBorder(),
                  ),
                ),
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
