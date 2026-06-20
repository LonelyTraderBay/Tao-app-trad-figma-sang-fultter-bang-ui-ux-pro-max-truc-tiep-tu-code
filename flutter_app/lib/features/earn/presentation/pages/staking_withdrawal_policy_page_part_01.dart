part of 'staking_withdrawal_policy_page.dart';

class _StakingWithdrawalPolicyPageState
    extends ConsumerState<StakingWithdrawalPolicyPage> {
  String? _activeTab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingWithdrawalPolicyRepositoryProvider)
        .getPolicy();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _stakingWithdrawalVisualNavClearance
        : _stakingWithdrawalNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-355 StakingWithdrawalPolicyPage',
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
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    scrollEndPadding,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      const VitHighRiskStatePanel(
                        density: VitDensity.compact,
                        state: VitHighRiskUiState.riskReview,
                        title: 'Withdrawal policy review required',
                        message:
                            'Timeline, early fee, emergency limits, preview, confirm and support next steps are reviewed before withdrawal.',
                        contractId: 'staking-withdrawal-policy',
                      ),
                      _PolicyTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeTab = tab);
                        },
                      ),
                      if (activeTab == 'timeline')
                        _TimelineTab(snapshot: snapshot)
                      else if (activeTab == 'penalties')
                        _PenaltiesTab(
                          snapshot: snapshot,
                          onOpenCalculator: () => _openCalculator(snapshot),
                        )
                      else
                        _EmergencyTab(snapshot: snapshot),
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

  Future<void> _openCalculator(StakingWithdrawalPolicySnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _PenaltyCalculatorSheet(snapshot: snapshot),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: StakingWithdrawalPolicyPage.infoKey,
      constraints: const BoxConstraints(
        minHeight: _stakingWithdrawalInfoMinHeight,
      ),
      child: Material(
        color: AppColors.primary08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardLargeRadius,
          side: const BorderSide(
            color: AppColors.primary20,
            width: _stakingWithdrawalBorderWidth,
          ),
        ),
        child: Padding(
          padding: AppSpacing.earnPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: _stakingWithdrawalInfoIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.infoTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      snapshot.infoBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _stakingWithdrawalInfoLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyTabs extends StatelessWidget {
  const _PolicyTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: _stakingWithdrawalTabMinHeight,
      ),
      child: Material(
        color: AppColors.surface2,
        child: Padding(
          padding: AppSpacing.earnHorizontalPaddingX4,
          child: Align(
            alignment: Alignment.center,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active,
              onChanged: onChanged,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label, icon: null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.processTitle,
          density: VitDensity.compact,
          children: [_ProcessCard(steps: snapshot.processSteps)],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitPageSection(
          label: snapshot.timelineTitle,
          density: VitDensity.compact,
          children: [
            for (final timeline in snapshot.timelines)
              _TimelineCard(timeline: timeline),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _NoteCard(text: snapshot.timelineNote),
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({required this.steps});

  final List<StakingWithdrawalStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWithdrawalPolicyPage.processKey,
      radius: VitCardRadius.lg,
      padding: _stakingWithdrawalCardPadding,
      child: Column(
        children: [
          for (final step in steps) ...[
            _ProcessStepRow(step: step),
            if (step != steps.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ProcessStepRow extends StatelessWidget {
  const _ProcessStepRow({required this.step});

  final StakingWithdrawalStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _stakingWithdrawalProcessIconBox,
          height: _stakingWithdrawalProcessIconBox,
          child: Material(
            color: _toneTint(step.tone),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
              side: BorderSide(
                color: color.withValues(alpha: .28),
                width: _stakingWithdrawalBorderWidth,
              ),
            ),
            child: Icon(
              _stepIcon(step.step),
              color: color,
              size: _stakingWithdrawalProcessIcon,
            ),
          ),
        ),
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
                  _SmallBadge(label: 'Bước ${step.step}', color: color),
                  Text(
                    step.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingWithdrawalProcessLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final StakingWithdrawalTimelineDraft timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWithdrawalPolicyPage.timelineKey(timeline.product),
      radius: VitCardRadius.lg,
      constraints: BoxConstraints(
        minHeight: timeline.penalty.contains('\n')
            ? _stakingWithdrawalTimelineMinHeightTall
            : _stakingWithdrawalTimelineMinHeight,
      ),
      padding: _stakingWithdrawalCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeline.product,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Có thể rút',
                  value: timeline.initiate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Unbonding',
                  value: timeline.unbonding,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Nhận tiền',
                  value: timeline.receive,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Phí rút sớm',
                  value: timeline.penalty,
                  color: timeline.penalty == 'Không'
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineMetric extends StatelessWidget {
  const _TimelineMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: _stakingWithdrawalTimelineValueLineHeight,
          ),
        ),
      ],
    );
  }
}

class _PenaltiesTab extends StatelessWidget {
  const _PenaltiesTab({required this.snapshot, required this.onOpenCalculator});

  final StakingWithdrawalPolicySnapshot snapshot;
  final VoidCallback onOpenCalculator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.penaltyTitle,
          density: VitDensity.compact,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: _stakingWithdrawalCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.penaltyBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _stakingWithdrawalPenaltyBodyLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Material(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.lgRadius,
                    child: Padding(
                      padding: _stakingWithdrawalCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.cancel_outlined,
                                color: AppColors.sell,
                                size: _stakingWithdrawalFormulaIcon,
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Expanded(
                                child: Text(
                                  'Công thức Phí rút sớm:',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: AppSpacing.earnTopPaddingX3),
                          for (final rule in snapshot.penaltyRules) ...[
                            _BulletLine(
                              text: rule.label,
                              color: _toneColor(rule.tone),
                            ),
                            if (rule != snapshot.penaltyRules.last)
                              const Padding(
                                padding: AppSpacing.earnTopPaddingX2,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitPageSection(
          label: 'Ví dụ Tính toán',
          children: [
            for (final example in snapshot.penaltyExamples)
              _PenaltyExampleCard(example: example),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCtaButton(
          key: StakingWithdrawalPolicyPage.calculatorCtaKey,
          onPressed: onOpenCalculator,
          leading: const Icon(Icons.calculate_rounded),
          child: Text(snapshot.calculatorCta),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _NoteCard(
          text:
              'Số lượng gốc không bị ảnh hưởng. Chỉ phần thưởng staking bị phạt; bạn luôn nhận lại 100% số tiền gốc đã stake.',
        ),
      ],
    );
  }
}
