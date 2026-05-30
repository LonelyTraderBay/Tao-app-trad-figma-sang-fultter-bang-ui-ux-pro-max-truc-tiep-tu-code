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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-355 StakingWithdrawalPolicyPage',
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
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
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
    );
  }

  Future<void> _openCalculator(StakingWithdrawalPolicySnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
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
    return Container(
      key: StakingWithdrawalPolicyPage.infoKey,
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 24,
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
                    height: 1.6,
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
    return Container(
      color: AppColors.surface2,
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(key: tab.id, label: tab.label, icon: null),
        ],
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
          children: [_ProcessCard(steps: snapshot.processSteps)],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: snapshot.timelineTitle,
          children: [
            for (final timeline in snapshot.timelines)
              _TimelineCard(timeline: timeline),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final step in steps) ...[
            _ProcessStepRow(step: step),
            if (step != steps.last) const SizedBox(height: AppSpacing.x4),
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
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _toneTint(step.tone),
            border: Border.all(color: color.withValues(alpha: .28), width: 1.5),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Icon(_stepIcon(step.step), color: color, size: 21),
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
                  fontSize: 12,
                  height: 1.5,
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
        minHeight: timeline.penalty.contains('\n') ? 152 : 122,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            height: 1.45,
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
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.penaltyBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.x4),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: AppRadii.lgRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: AppColors.sell,
                              size: 20,
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
                        const SizedBox(height: AppSpacing.x3),
                        for (final rule in snapshot.penaltyRules) ...[
                          _BulletLine(
                            text: rule.label,
                            color: _toneColor(rule.tone),
                          ),
                          if (rule != snapshot.penaltyRules.last)
                            const SizedBox(height: AppSpacing.x2),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Ví dụ Tính toán',
          children: [
            for (final example in snapshot.penaltyExamples)
              _PenaltyExampleCard(example: example),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
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
