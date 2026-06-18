part of 'savings_goal_page.dart';

class _SavingsGoalPageState extends ConsumerState<SavingsGoalPage> {
  String? _selectedTemplateId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsGoalsRepositoryProvider).getGoals();
    final activeGoals = snapshot.goals
        .where((goal) => goal.status == SavingsGoalStatus.active)
        .toList();
    final completedGoals = snapshot.goals
        .where((goal) => goal.status == SavingsGoalStatus.completed)
        .toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-342 SavingsGoalPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
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
                      _GoalSummaryCard(goals: snapshot.goals),
                      VitCtaButton(
                        key: SavingsGoalPage.createButtonKey,
                        leading: const Icon(Icons.add_rounded),
                        onPressed: () => _openCreateSheet(snapshot),
                        child: const Text('Tạo mục tiêu mới'),
                      ),
                      VitPageSection(
                        label: 'Đang thực hiện',
                        accentColor: AppColors.primary,
                        children: [
                          for (final goal in activeGoals) ...[
                            _GoalCard(
                              goal: goal,
                              onTap: () => _openGoalDetail(goal),
                            ),
                            if (goal != activeGoals.last)
                              const SizedBox(height: AppSpacing.x3),
                          ],
                        ],
                      ),
                      VitPageSection(
                        label: 'Đã hoàn thành',
                        accentColor: AppColors.buy,
                        children: [
                          for (final goal in completedGoals)
                            _GoalCard(
                              goal: goal,
                              onTap: () => _openGoalDetail(goal),
                            ),
                        ],
                      ),
                      VitPageSection(
                        label: 'Mẹo tiết kiệm',
                        accentColor: AppColors.accent,
                        children: [
                          for (final tip in snapshot.tips) ...[
                            _TipCard(tip: tip),
                            if (tip != snapshot.tips.last)
                              const SizedBox(height: AppSpacing.x3),
                          ],
                        ],
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

  Future<void> _openCreateSheet(SavingsGoalsSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        final selected = _selectedTemplateId ?? snapshot.templates.first.id;
        return _SheetFrame(
          heightFactor: 0.82,
          child: _CreateGoalSheet(
            snapshot: snapshot,
            selectedTemplateId: selected,
            onTemplate: (id) {
              HapticFeedback.selectionClick();
              setState(() => _selectedTemplateId = id);
              Navigator.of(context).pop();
              _openCreateSheet(snapshot);
            },
          ),
        );
      },
    );
  }

  Future<void> _openGoalDetail(SavingsGoalDraft goal) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(
          heightFactor: 0.9,
          child: _GoalDetailSheet(goal: goal),
        );
      },
    );
  }
}

class _GoalSummaryCard extends StatelessWidget {
  const _GoalSummaryCard({required this.goals});

  final List<SavingsGoalDraft> goals;

  @override
  Widget build(BuildContext context) {
    final activeGoals = goals
        .where((goal) => goal.status == SavingsGoalStatus.active)
        .toList();
    final completedGoals = goals
        .where((goal) => goal.status == SavingsGoalStatus.completed)
        .length;
    final totalCurrent = activeGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
    final totalTarget = activeGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final milestones = goals.fold<int>(
      0,
      (sum, goal) => sum + goal.milestones.length,
    );
    final unlocked = goals.fold<int>(
      0,
      (sum, goal) =>
          sum + goal.milestones.where((milestone) => milestone.unlocked).length,
    );
    final progress = totalTarget == 0 ? 0.0 : totalCurrent / totalTarget;

    return VitCard(
      key: SavingsGoalPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX5,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tiến độ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatUsd(totalCurrent),
                      style: AppTextStyles.pageTitle.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'mục tiêu ${_formatUsd(totalTarget)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressRing(
                progress: progress,
                color: AppColors.primary,
                size: AppSpacing.savingsGoalHeroProgressRing,
                strokeWidth: AppSpacing.savingsGoalHeroProgressStroke,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  value: '${activeGoals.length}',
                  label: 'Đang thực hiện',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  value: '$completedGoals',
                  label: 'Hoàn thành',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  value: '$unlocked/$milestones',
                  label: 'Milestone',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
      padding: AppSpacing.earnCardPaddingX3,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.onTap});

  final SavingsGoalDraft goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final accent = _goalColor(goal);
    final unlocked = goal.milestones
        .where((milestone) => milestone.unlocked)
        .length;
    final next = goal.milestones.where((milestone) => !milestone.unlocked);
    final daysRemaining = _daysRemaining(goal.targetDate);
    final completed = goal.status == SavingsGoalStatus.completed;

    return VitCard(
      key: SavingsGoalPage.goalKey(goal.id),
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _GoalIcon(iconKey: goal.iconKey, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            goal.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (completed) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const _TinyPill(
                            label: 'Hoàn thành',
                            color: AppColors.buy,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${goal.linkedProduct} - APY ${goal.linkedProductApy.toStringAsFixed(1)}%',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _ProgressRing(
                progress: progress,
                color: accent,
                size: AppSpacing.savingsGoalCardProgressRing,
                strokeWidth: AppSpacing.savingsGoalCardProgressStroke,
                centerLabel: '${(progress * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _formatUsd(goal.currentAmount),
                  style: AppTextStyles.baseMedium.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                '/ ${_formatUsd(goal.targetAmount)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ProgressBar(progress: progress, color: accent),
          const SizedBox(height: AppSpacing.x4),
          _MilestoneRail(goal: goal, color: accent, unlocked: unlocked),
          const SizedBox(height: AppSpacing.x3),
          if (completed)
            Row(
              children: [
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Tất cả milestone đã hoàn thành',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            )
          else
            Wrap(
              spacing: AppSpacing.x4,
              runSpacing: AppSpacing.x2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _MetaItem(
                  icon: Icons.calendar_today_outlined,
                  label: '$daysRemaining ngày',
                  color: AppColors.text3,
                ),
                if (goal.autoContribute)
                  _MetaItem(
                    icon: Icons.flash_on_rounded,
                    label: '${_formatUsd(goal.monthlyContribution)}/tháng',
                    color: accent,
                  ),
                _MetaItem(
                  icon: Icons.emoji_events_outlined,
                  label: 'Tiếp: ${next.isEmpty ? 100 : next.first.percentage}%',
                  color: AppColors.warn,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MilestoneRail extends StatelessWidget {
  const _MilestoneRail({
    required this.goal,
    required this.color,
    required this.unlocked,
  });

  final SavingsGoalDraft goal;
  final Color color;
  final int unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final milestone in goal.milestones) ...[
          _MilestoneDot(milestone: milestone, color: color),
          if (milestone != goal.milestones.last)
            Expanded(
              child: Padding(
                padding: AppSpacing.earnInlineMarginX1,
                child: SizedBox(
                  height: AppSpacing.savingsGoalTimelineDividerHeight,
                  child: ColoredBox(
                    color: milestone.unlocked ? color : AppColors.borderSolid,
                  ),
                ),
              ),
            ),
        ],
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$unlocked/${goal.milestones.length}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
