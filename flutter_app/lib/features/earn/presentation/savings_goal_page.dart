import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class SavingsGoalPage extends ConsumerStatefulWidget {
  const SavingsGoalPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc342_summary');
  static const createButtonKey = Key('sc342_create_goal_button');
  static const createSheetKey = Key('sc342_create_goal_sheet');
  static const detailSheetKey = Key('sc342_goal_detail_sheet');

  static Key goalKey(String id) => Key('sc342_goal_$id');
  static Key templateKey(String id) => Key('sc342_template_$id');
  static Key tipKey(String title) => Key('sc342_tip_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsGoalPage> createState() => _SavingsGoalPageState();
}

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
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
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
    );
  }

  Future<void> _openCreateSheet(SavingsGoalsSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
      padding: const EdgeInsets.all(AppSpacing.x5),
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
                size: 76,
                strokeWidth: 5,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                size: 52,
                strokeWidth: 4,
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
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
                color: milestone.unlocked ? color : AppColors.borderSolid,
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

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({required this.milestone, required this.color});

  final SavingsGoalMilestoneDraft milestone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final unlocked = milestone.unlocked;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: unlocked ? color : AppColors.surface3,
        shape: BoxShape.circle,
        border: Border.all(
          color: unlocked ? color : AppColors.borderSolid,
          width: 1.5,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x4,
        height: AppSpacing.x4,
        child: unlocked
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: AppSpacing.x3,
              )
            : Center(
                child: Text(
                  '${milestone.percentage}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 7,
                    height: 1,
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
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
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
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
          padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: [
            _ProgressRing(
              progress: progress,
              color: accent,
              size: 84,
              strokeWidth: 6,
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
          padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
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
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeading extends StatelessWidget {
  const _SheetHeading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warn, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.color,
    required this.size,
    required this.strokeWidth,
    this.centerLabel,
  });

  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _ProgressRingPainter(
              progress: progress,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerLabel != null)
            Text(
              centerLabel!,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..color = AppColors.surface3
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final active = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalIcon extends StatelessWidget {
  const _GoalIcon({required this.iconKey, required this.color});

  final String iconKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(_iconFor(iconKey), color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'house' => Icons.savings_outlined,
    'car' => Icons.paid_outlined,
    'vacation' => Icons.star_border_rounded,
    'education' => Icons.workspace_premium_outlined,
    'emergency' => Icons.error_outline_rounded,
    'sparkles' => Icons.auto_awesome_outlined,
    'trophy' => Icons.emoji_events_outlined,
    _ => Icons.track_changes_rounded,
  };
}

Color _goalColor(SavingsGoalDraft goal) {
  return switch (goal.iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ =>
      goal.status == SavingsGoalStatus.completed
          ? AppColors.primary
          : AppColors.accent,
  };
}

Color _templateColor(String iconKey) {
  return switch (iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ => AppColors.accent,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.accent,
    EarnRiskLevel.high => AppColors.warn,
  };
}

int _daysRemaining(String targetDate) {
  final now = DateTime(2026, 3, 9);
  final target = DateTime.parse(targetDate);
  return math.max(0, target.difference(now).inDays);
}

String _formatDate(String value) {
  final date = DateTime.parse(value);
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
