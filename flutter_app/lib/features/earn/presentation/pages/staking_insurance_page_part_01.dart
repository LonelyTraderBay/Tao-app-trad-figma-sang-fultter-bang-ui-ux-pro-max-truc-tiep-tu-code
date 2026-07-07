part of 'staking_insurance_page.dart';

class _StakingInsurancePageState extends ConsumerState<StakingInsurancePage> {
  _InsuranceTab _tab = _InsuranceTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingInsuranceRepositoryProvider)
        .getInsurance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-365 StakingInsurancePage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: snapshot.title,
            subtitle: snapshot.infoTitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EarnSpacingTokens.earnBottomInsetPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _InsuranceTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _InsuranceTab.overview)
                        _OverviewTab(snapshot: snapshot),
                      if (_tab == _InsuranceTab.plans)
                        _PlansTab(snapshot: snapshot, onOpenPlan: _showPlan),
                      if (_tab == _InsuranceTab.positions)
                        _PositionsTab(
                          snapshot: snapshot,
                          onAddInsurance: (position) {
                            HapticFeedback.lightImpact();
                            setState(() => _tab = _InsuranceTab.plans);
                          },
                        ),
                      if (_tab == _InsuranceTab.claims)
                        _ClaimsTab(
                          snapshot: snapshot,
                          onFileClaim: () => _showClaimForm(snapshot),
                        ),
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

  Future<void> _showPlan(StakingInsurancePlanDraft plan) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(child: _PlanSheet(plan: plan)),
    );
  }

  Future<void> _showClaimForm(StakingInsuranceSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(child: _ClaimSheet(snapshot: snapshot)),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.earn.withValues(alpha: 0.2),
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.infoBody,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsuranceTabs extends StatelessWidget {
  const _InsuranceTabs({required this.active, required this.onChanged});

  final _InsuranceTab active;
  final ValueChanged<_InsuranceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: StakingInsurancePage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_InsuranceTab.values.byName(key)),
      tabs: [
        for (final tab in _InsuranceTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            widgetKey: StakingInsurancePage.tabKey(tab.name),
          ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final insuredPositions = snapshot.positions.where((p) => p.insured).length;
    final totalInsured = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, p) => sum + p.usdValue);
    final totalPremium = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, position) {
          final plan = snapshot.planById(position.insurancePlanId);
          return sum +
              (plan == null ? 0 : position.usdValue * plan.premium / 100);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingInsurancePage.overviewSummaryKey,
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá trị được bảo hiểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const Padding(
                          padding: EarnSpacingTokens.earnTopPaddingX3,
                        ),
                        Text(
                          _formatUsd(totalInsured),
                          style: AppTextStyles.heroNumber.copyWith(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: EarnSpacingTokens.stakingInsuranceShieldIconBox,
                    height: EarnSpacingTokens.stakingInsuranceShieldIconBox,
                    child: Material(
                      color: AppColors.buy10,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: AppColors.buy,
                          width: EarnSpacingTokens
                              .stakingInsuranceShieldBorderWidth,
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.buy,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Vị thế có BH',
                      value: '$insuredPositions/${snapshot.positions.length}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Phí/năm',
                      value: _formatUsd(totalPremium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BenefitsGrid(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _WarningNote(snapshot: snapshot),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInsurancePage.benefitsKey,
      label: 'Lợi ích Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                EarnSpacingTokens.stakingInsuranceBenefitGridColumns,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio:
                EarnSpacingTokens.stakingInsuranceBenefitGridAspect,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return _BenefitCard(benefit: benefit);
          },
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final StakingInsuranceBenefitDraft benefit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            child: Material(
              color: _iconFillColor(benefit.icon),
              shape: CircleBorder(
                side: BorderSide(color: _iconBorder(benefit.icon)),
              ),
              child: Icon(
                _benefitIcon(benefit.icon),
                color: _iconColor(benefit.icon),
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const Spacer(),
          Text(
            benefit.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            benefit.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.warningKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.warningTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final bullet in snapshot.warningBullets)
                  Padding(
                    padding: EarnSpacingTokens.earnBottomPaddingX1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EarnSpacingTokens.earnBulletTopMarginX3,
                          child: const SizedBox(
                            width: AppSpacing.x1,
                            height: AppSpacing.x1,
                            child: Material(
                              color: AppColors.warn,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            bullet,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                      ],
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

class _PlansTab extends StatelessWidget {
  const _PlansTab({required this.snapshot, required this.onOpenPlan});

  final StakingInsuranceSnapshot snapshot;
  final ValueChanged<StakingInsurancePlanDraft> onOpenPlan;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chọn Plan Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        for (final plan in snapshot.plans)
          _PlanCard(plan: plan, onTap: () => onOpenPlan(plan)),
      ],
    );
  }
}
