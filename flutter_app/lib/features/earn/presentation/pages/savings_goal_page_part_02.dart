part of 'savings_goal_page.dart';

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({required this.milestone, required this.color});

  final SavingsGoalMilestoneDraft milestone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final unlocked = milestone.unlocked;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: unlocked ? color : AppColors.surface3,
        shape: CircleBorder(
          side: BorderSide(
            color: unlocked ? color : AppColors.borderSolid,
            width: AppSpacing.savingsGoalMilestoneBorderWidth,
          ),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x4,
        height: AppSpacing.x4,
        child: unlocked
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.x3,
              )
            : Center(
                child: Text(
                  '${milestone.percentage}',
                  style: AppTextStyles.microTiny.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.savingsGoalMilestoneLineHeight,
                  ),
                ),
              ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final SavingsGoalTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);
    return VitCard(
      key: SavingsGoalPage.tipKey(tip.title),
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX4,
      child: Row(
        children: [
          _GoalIcon(iconKey: tip.iconKey, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text3,
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

class _CreateGoalSheet extends StatelessWidget {
  const _CreateGoalSheet({
    required this.snapshot,
    required this.selectedTemplateId,
    required this.onTemplate,
  });

  final SavingsGoalsSnapshot snapshot;
  final String selectedTemplateId;
  final ValueChanged<String> onTemplate;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.templates.firstWhere(
      (template) => template.id == selectedTemplateId,
      orElse: () => snapshot.templates.first,
    );

    return Column(
      key: SavingsGoalPage.createSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tạo mục tiêu mới',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Chọn mẫu mục tiêu để thiết lập nhanh số tiền, thời hạn và milestone rewards.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final template in snapshot.templates) ...[
          _TemplateTile(
            template: template,
            selected: template.id == selected.id,
            onTap: () => onTemplate(template.id),
          ),
          if (template != snapshot.templates.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SheetMetric(label: 'Mẫu đã chọn', value: selected.name),
              _SheetMetric(
                label: 'Mục tiêu gợi ý',
                value: _formatUsd(selected.suggestedTarget),
              ),
              _SheetMetric(
                label: 'Thời gian',
                value: '${selected.suggestedMonths} tháng',
              ),
              _SheetMetric(label: 'Sản phẩm liên kết', value: 'USDT Linh hoạt'),
              _SheetMetric(
                label: 'Milestone rewards',
                value: '4 mốc',
                color: AppColors.warn,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          variant: VitCtaButtonVariant.success,
          leading: const Icon(Icons.flag_outlined),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tạo mục tiêu'),
        ),
      ],
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final SavingsGoalTemplateDraft template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _templateColor(template.iconKey);
    return VitCard(
      key: SavingsGoalPage.templateKey(template.id),
      variant: VitCardVariant.inner,
      borderColor: selected ? color : null,
      padding: AppSpacing.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          _GoalIcon(iconKey: template.iconKey, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  template.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatUsd(template.suggestedTarget),
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                '${template.suggestedMonths} tháng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalDetailSheet extends StatelessWidget {
  const _GoalDetailSheet({required this.goal});

  final SavingsGoalDraft goal;

  @override
  Widget build(BuildContext context) {
    final accent = _goalColor(goal);
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final remaining = math.max<double>(
      0,
      goal.targetAmount - goal.currentAmount,
    );

    return Column(
      key: SavingsGoalPage.detailSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(goal.name, style: AppTextStyles.sectionTitle)),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            _ProgressRing(
              progress: progress,
              color: accent,
              size: AppSpacing.savingsGoalDetailProgressRing,
              strokeWidth: AppSpacing.savingsGoalDetailProgressStroke,
              centerLabel: '${(progress * 100).round()}%',
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatUsd(goal.currentAmount),
                    style: AppTextStyles.pageTitle.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'Mục tiêu: ${_formatUsd(goal.targetAmount)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  if (remaining > 0)
                    Text(
                      'Còn thiếu: ${_formatUsd(remaining)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.earnCardPaddingX4,
          child: Column(
            children: [
              _SheetMetric(
                label: 'Ngày bắt đầu',
                value: _formatDate(goal.startDate),
              ),
              _SheetMetric(
                label: 'Ngày mục tiêu',
                value: _formatDate(goal.targetDate),
              ),
              _SheetMetric(label: 'Sản phẩm', value: goal.linkedProduct),
              _SheetMetric(
                label: 'APY',
                value: '${goal.linkedProductApy.toStringAsFixed(1)}%',
                color: AppColors.buy,
              ),
              if (goal.autoContribute)
                _SheetMetric(
                  label: 'Auto-contribute',
                  value: '${_formatUsd(goal.monthlyContribution)}/tháng',
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        _SheetHeading(
          icon: Icons.emoji_events_outlined,
          label: 'Milestone Rewards',
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final milestone in goal.milestones) ...[
          _MilestoneRow(milestone: milestone, color: accent),
          if (milestone != goal.milestones.last)
            const Divider(color: AppColors.divider, height: AppSpacing.x1),
        ],
        if (goal.contributions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x5),
          _SheetHeading(
            icon: Icons.arrow_upward_rounded,
            label: 'Đóng góp gần đây',
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final contribution in goal.contributions)
            _ContributionRow(contribution: contribution),
        ],
      ],
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.milestone, required this.color});

  final SavingsGoalMilestoneDraft milestone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX3,
      child: Row(
        children: [
          _MilestoneDot(milestone: milestone, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  milestone.reward,
                  style: AppTextStyles.micro.copyWith(
                    color: milestone.unlocked ? color : AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          _TinyPill(
            label: milestone.unlocked
                ? (milestone.claimedAt == null ? 'Nhận ngay' : 'Đã nhận')
                : '${milestone.percentage}%',
            color: milestone.unlocked ? color : AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _ContributionRow extends StatelessWidget {
  const _ContributionRow({required this.contribution});

  final SavingsGoalContributionDraft contribution;

  @override
  Widget build(BuildContext context) {
    final automatic = contribution.source == 'Tự động';
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+${_formatUsd(contribution.amount)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  _formatDate(contribution.date),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _TinyPill(
            label: contribution.source,
            color: automatic ? AppColors.primary : AppColors.buy,
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child, required this.heightFactor});

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.sheetTopLargeRadius,
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: AppSpacing.earnSheetContentPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
