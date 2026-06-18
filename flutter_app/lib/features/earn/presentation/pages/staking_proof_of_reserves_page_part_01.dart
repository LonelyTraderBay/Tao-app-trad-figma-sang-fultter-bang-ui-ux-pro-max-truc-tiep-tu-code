part of 'staking_proof_of_reserves_page.dart';

class _StakingProofOfReservesPageState
    extends ConsumerState<StakingProofOfReservesPage> {
  _ReserveTab _tab = _ReserveTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingProofOfReservesRepositoryProvider)
        .getProofOfReserves();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-380 StakingProofOfReservesPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _ReserveTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _ReserveTab.overview)
                        _OverviewTab(snapshot: snapshot)
                      else if (_tab == _ReserveTab.assets)
                        _AssetsTab(snapshot: snapshot)
                      else
                        _VerifyTab(
                          snapshot: snapshot,
                          onVerify: () => _openVerifySheet(snapshot),
                        ),
                      _FooterNote(note: snapshot.footerNote),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openVerifySheet(StakingProofOfReservesSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _VerifySheet(snapshot: snapshot),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: AppSpacing.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingProofInfoLineHeight,
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

class _ReserveTabs extends StatelessWidget {
  const _ReserveTabs({required this.active, required this.onChanged});

  final _ReserveTab active;
  final ValueChanged<_ReserveTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: StakingProofOfReservesPage.tabsKey,
      color: AppColors.surface,
      child: Row(
        children: [
          for (final tab in _ReserveTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingProofOfReservesPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: AppSpacing.earnTopPaddingX4,
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 160),
                          child: SizedBox(
                            width: active == tab ? AppSpacing.buttonHero : 0,
                            height: AppSpacing.stakingProofTabIndicatorHeight,
                            child: Material(
                              color: active == tab
                                  ? AppColors.primarySoft
                                  : AppColors.transparent,
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final overall = snapshot.overall;
    final surplus = overall.totalAssetsUsd - overall.totalLiabilitiesUsd;
    return Column(
      key: StakingProofOfReservesPage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingProofOfReservesPage.reserveStatusKey,
          label: 'Overall Reserve Status',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: AppSpacing.earnPaddingX5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SmallMetric(
                          label: 'Total Assets (USD)',
                          value: _formatUsd(overall.totalAssetsUsd),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: _SmallMetric(
                          label: 'Reserve Ratio',
                          value: '${overall.reserveRatio.toStringAsFixed(1)}%',
                          color: AppColors.buy,
                          alignEnd: true,
                          suffix: '>= 100%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Center(child: _ReserveProgress(ratio: overall.reserveRatio)),
                  const SizedBox(height: AppSpacing.x5),
                  Row(
                    children: [
                      Expanded(
                        child: _InnerMetric(
                          label: 'User Liabilities',
                          value: _formatUsd(overall.totalLiabilitiesUsd),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InnerMetric(
                          label: 'Surplus',
                          value: _formatUsd(surplus),
                          valueColor: AppColors.buy,
                          subtleBuy: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Last updated: ${overall.lastUpdated} - Live data',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingProofOfReservesPage.trendKey,
          label: 'Reserve Ratio Trend (12 Months)',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: AppSpacing.earnPaddingX4,
              child: Column(
                children: [
                  SizedBox(
                    height: AppSpacing.stakingProofTrendChartHeight,
                    child: CustomPaint(
                      painter: _ReserveTrendPainter(snapshot.history),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        '+1.7% YoY',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      const SizedBox(
                        width: AppSpacing.x1,
                        height: AppSpacing.x1,
                        child: Material(
                          color: AppColors.borderSolid,
                          shape: CircleBorder(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Text(
                        'Always >= 100%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingProofOfReservesPage.auditsKey,
          label: 'Third-Party Audit Reports',
          accentColor: AppColors.primarySoft,
          children: [
            for (final report in snapshot.auditReports)
              _AuditReportCard(report: report),
          ],
        ),
      ],
    );
  }
}

class _AssetsTab extends StatelessWidget {
  const _AssetsTab({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingProofOfReservesPage.assetsKey,
      label: 'Reserve Ratio by Asset',
      accentColor: AppColors.primarySoft,
      children: [
        for (final asset in snapshot.assets) _AssetReserveCard(asset: asset),
      ],
    );
  }
}

class _VerifyTab extends StatelessWidget {
  const _VerifyTab({required this.snapshot, required this.onVerify});

  final StakingProofOfReservesSnapshot snapshot;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingProofOfReservesPage.verifyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Verify Your Balance',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: AppSpacing.earnPaddingX4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: AppSpacing.ctaHeight,
                        height: AppSpacing.ctaHeight,
                        child: const Material(
                          color: AppColors.primary12,
                          borderRadius: AppRadii.lgRadius,
                          child: Icon(
                            Icons.visibility_outlined,
                            color: AppColors.primarySoft,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Merkle Tree Verification',
                              style: AppTextStyles.baseMedium,
                            ),
                            const Padding(padding: AppSpacing.earnTopPaddingX2),
                            Text(
                              'Prove your staked balance is included in our Proof of Reserves using cryptographic Merkle tree proofs.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: AppSpacing.stakingProofBodyLineHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  SizedBox(
                    height: AppSpacing.ctaHeight,
                    child: FilledButton(
                      onPressed: onVerify,
                      child: const Text('Verify My Balance'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'How Verification Works',
          accentColor: AppColors.primarySoft,
          children: [
            for (final step in snapshot.verifySteps)
              _VerificationStepCard(step: step),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: AppSpacing.earnPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.privacyNote,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.stakingProofInfoLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReserveProgress extends StatelessWidget {
  const _ReserveProgress({required this.ratio});

  final double ratio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.stakingProofProgressRing,
      height: AppSpacing.stakingProofProgressRing,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _ReserveProgressPainter(ratio),
            child: const SizedBox.expand(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: const Material(
                  color: AppColors.transparent,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: AppColors.buy,
                      width: AppSpacing.stakingProofProgressBorderWidth,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                '${ratio.toStringAsFixed(1)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'Covered',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
