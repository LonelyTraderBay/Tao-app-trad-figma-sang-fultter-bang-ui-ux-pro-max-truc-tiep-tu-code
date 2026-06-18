part of 'launchpad_staking_page.dart';

class _LaunchpadStakingPageState extends ConsumerState<LaunchpadStakingPage> {
  var _activeTab = _StakingTab.pools;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getStaking();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-298 LaunchpadStakingPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: bottomInset,
          semanticLabel: 'SC-298 LaunchpadStakingPage scroll surface',
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            children: [
              _StakingTabs(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: LaunchpadStakingPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        _StakingHero(snapshot: snapshot),
                        switch (_activeTab) {
                          _StakingTab.pools => _PoolsTab(snapshot: snapshot),
                          _StakingTab.positions => _PositionsTab(
                            snapshot: snapshot,
                          ),
                          _StakingTab.calculator => _ApyCalculator(
                            pools: snapshot.pools,
                          ),
                        },
                        const _RiskDisclosure(),
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
}

class _StakingTabs extends StatelessWidget {
  const _StakingTabs({required this.activeTab, required this.onChanged});

  final _StakingTab activeTab;
  final ValueChanged<_StakingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            key: LaunchpadStakingPage.tabsKey,
            children: [
              for (final tab in _StakingTab.values)
                Expanded(
                  child: InkWell(
                    key: LaunchpadStakingPage.tabKey(tab.id),
                    onTap: () => onChanged(tab),
                    child: Padding(
                      padding: AppSpacing.launchpadTopPaddingX4,
                      child: Column(
                        children: [
                          Text(
                            tab.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: tab == activeTab
                                  ? AppColors.primary
                                  : AppColors.text3,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 160),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: AppSpacing.launchpadGapXxs,
                              width: tab == activeTab
                                  ? AppSpacing.launchpadTabIndicatorWidth
                                  : 0,
                              child: const DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadii.xsRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(
            height: AppSpacing.launchpadDividerHeight,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _StakingHero extends StatelessWidget {
  const _StakingHero({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: AppSpacing.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.buy15,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.buy20),
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.currency_exchange_rounded,
                      color: AppColors.buy,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá trị stake',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _formatUsd(snapshot.totalStaked),
                      style: AppTextStyles.numericDisplayXl.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Pools hoạt động',
                  value: '${snapshot.activePoolCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Phần thưởng chờ',
                  value: _formatToken(snapshot.totalPendingRewards),
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Vị trí',
                  value: '${snapshot.positions.length}',
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoolsTab extends StatelessWidget {
  const _PoolsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pool in snapshot.pools) ...[
          _PoolCard(pool: pool, detailRoute: snapshot.detailRoute),
          if (pool != snapshot.pools.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _PoolCard extends StatelessWidget {
  const _PoolCard({required this.pool, required this.detailRoute});

  final LaunchpoolPoolDraft pool;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final currentTier = _currentTier(pool.tiers, pool.userStaked);
    return VitCard(
      key: LaunchpadStakingPage.poolKey(pool.id),
      radius: VitCardRadius.lg,
      padding: AppSpacing.launchpadPaddingX5,
      onTap: () => context.go(detailRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: pool.projectLogo,
                color: pool.accent,
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pool.projectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.extraBold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        const VitStatusPill(
                          label: 'Launchpool',
                          status: VitStatusPillStatus.success,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    Text(
                      'Stake ${pool.stakeToken} · Earn ${pool.rewardToken}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatApy(pool.effectiveApy)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: pool.accent,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Tổng stake',
                  value: pool.totalStakedDisplay,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Lock',
                  value: '${pool.lockPeriodDays} ngày',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(label: 'Chain', value: pool.chain),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _CapacityBar(pool: pool),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final tier in pool.tiers) ...[
                Expanded(
                  child: _TierChip(
                    tier: tier,
                    selected: currentTier?.label == tier.label,
                  ),
                ),
                if (tier != pool.tiers.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (pool.userStaked > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            _UserStakeSummary(pool: pool),
          ],
          const SizedBox(height: AppSpacing.x4),
          _TimelineStatus(status: pool.status),
          const SizedBox(height: AppSpacing.x4),
          _PoolAction(pool: pool),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.positions.isEmpty) {
      return VitCard(
        padding: AppSpacing.launchpadPaddingX6,
        child: Column(
          children: [
            const Icon(
              Icons.currency_exchange_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Chưa có vị trí nào',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Bắt đầu stake vào pool để nhận phần thưởng token mới.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        VitCard(
          key: LaunchpadStakingPage.batchClaimKey,
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          padding: AppSpacing.launchpadPaddingX4,
          onTap: () => context.go(snapshot.batchClaimRoute),
          child: Row(
            children: [
              const SizedBox(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.buy15,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.bolt_rounded,
                      color: AppColors.buy,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch Claim',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Nhận phần thưởng từ tất cả vị trí cùng lúc',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final position in snapshot.positions) ...[
          _PositionCard(
            position: position,
            claimReceiptRoute: snapshot.claimReceiptRoute,
          ),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}
