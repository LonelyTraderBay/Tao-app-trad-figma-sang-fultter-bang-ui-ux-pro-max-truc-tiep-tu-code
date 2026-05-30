part of 'arena_governance_gate_page.dart';

enum _EligibilityTier { green, amber, red }

final class _GovernanceCheck {
  const _GovernanceCheck(this.label, this.passed);

  final String label;
  final bool passed;
}

final class _GovernanceResult {
  const _GovernanceResult({
    required this.clarity,
    required this.level,
    required this.tier,
    required this.checks,
    required this.warnings,
    required this.risk,
    required this.nextAction,
    required this.canProceed,
  });

  final int clarity;
  final String level;
  final _EligibilityTier tier;
  final List<_GovernanceCheck> checks;
  final List<String> warnings;
  final String risk;
  final String nextAction;
  final bool canProceed;
}

class _GovernanceStepper extends StatelessWidget {
  const _GovernanceStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _StepMarker(item: steps[i], activeStep: step),
          ),
          if (i != steps.length - 1)
            Container(
              width: AppSpacing.x5,
              height: 2,
              margin: const EdgeInsets.only(bottom: AppSpacing.x5),
              decoration: BoxDecoration(
                color: steps[i].index < step
                    ? AppColors.buy
                    : AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final done = item.index < activeStep;
    final active = item.index == activeStep;
    return Column(
      children: [
        Container(
          width: active ? 31 : 28,
          height: active ? 31 : 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.surface3,
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.onAccent,
                  size: 16,
                )
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.onAccent : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _GovernanceTitle extends StatelessWidget {
  const _GovernanceTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Governed Mode',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Governance Gate tự động kiểm tra rule trước khi publish',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.options,
    required this.privacy,
    required this.onSelected,
    required this.onCompare,
  });

  final List<ArenaPrivacyOptionDraft> options;
  final String privacy;
  final ValueChanged<String> onSelected;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quyền riêng tư',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitCard(
                key: ArenaGovernanceGatePage.compareKey,
                variant: VitCardVariant.ghost,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x2,
                  vertical: AppSpacing.x1,
                ),
                onTap: onCompare,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      'So sánh',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final option in options) ...[
                Expanded(
                  child: _PrivacyChip(
                    option: option,
                    active: privacy == option.id,
                    onTap: () => onSelected(option.id),
                  ),
                ),
                if (option != options.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (privacy == 'public') ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Public room yêu cầu tất cả mục rule bắt buộc. Governance Gate sẽ kiểm tra tự động.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ArenaPrivacyOptionDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaGovernanceGatePage.privacyKey(option.id),
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.accent20 : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            _privacyIcon(option.id),
            color: active ? AppColors.accent : AppColors.text3,
            size: 16,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.accent : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClarityScoreCard extends StatelessWidget {
  const _ClarityScoreCard({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = result.clarity >= 60 ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Rule Clarity Score',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${result.clarity}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _StatusPill(label: result.level, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 7,
              value: result.clarity / 100,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.title, required this.onChanged});

  final String title;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Tên challenge',
      required: true,
      child: TextFormField(
        key: ArenaGovernanceGatePage.titleKey,
        initialValue: title,
        onChanged: onChanged,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration('VD: BTC Weekly Predict — Tuần 10'),
      ),
    );
  }
}

class _DomainGrid extends StatelessWidget {
  const _DomainGrid({
    required this.domains,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> domains;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Lĩnh vực',
      required: publicRoom,
      child: Wrap(
        spacing: AppSpacing.x2,
        runSpacing: AppSpacing.x3,
        children: [
          for (final domain in domains)
            _MiniOptionChip(
              key: ArenaGovernanceGatePage.domainKey(domain.id),
              icon: _domainIcon(domain.id),
              label: domain.label,
              selected: selectedId == domain.id,
              onTap: () => onSelected(domain.id),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTypeGrid extends StatelessWidget {
  const _ChallengeTypeGrid({
    required this.types,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> types;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Loại challenge',
      required: publicRoom,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: AppSpacing.x2,
          mainAxisSpacing: AppSpacing.x2,
        ),
        itemBuilder: (context, index) {
          final type = types[index];
          return _MiniOptionChip(
            key: ArenaGovernanceGatePage.challengeTypeKey(type.id),
            icon: _challengeIcon(type.id),
            label: type.label,
            selected: selectedId == type.id,
            onTap: () => onSelected(type.id),
          );
        },
      ),
    );
  }
}

class _WinConditionCard extends StatelessWidget {
  const _WinConditionCard({
    required this.snapshot,
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinCondition,
    required this.publicRoom,
    required this.onSubject,
    required this.onAction,
    required this.onMetric,
    required this.onWinType,
    required this.onDeadlineContext,
    required this.onCustomWinChanged,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final String customWinCondition;
  final bool publicRoom;
  final VoidCallback onSubject;
  final VoidCallback onAction;
  final VoidCallback onMetric;
  final VoidCallback onWinType;
  final VoidCallback onDeadlineContext;
  final ValueChanged<String> onCustomWinChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.adjust_rounded,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Điều kiện thắng',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (publicRoom) const _RequiredPill(text: 'BẮT BUỘC'),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            childAspectRatio: 2.45,
            children: [
              _BuilderField(
                label: 'A. Chủ thể',
                value: subject,
                onTap: onSubject,
              ),
              _BuilderField(
                label: 'B. Hành động',
                value: action,
                onTap: onAction,
              ),
              _BuilderField(label: 'C. Chỉ số', value: metric, onTap: onMetric),
              _BuilderField(
                label: 'D. Kiểu thắng',
                value: winType,
                onTap: onWinType,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _BuilderField(
            label: 'E. Thời điểm',
            value: deadlineContext,
            onTap: onDeadlineContext,
          ),
          const SizedBox(height: AppSpacing.x3),
          TextFormField(
            initialValue: customWinCondition,
            onChanged: onCustomWinChanged,
            maxLines: 2,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            decoration: _inputDecoration(
              'VD: Người đoán gần nhất với giá ETH vào 25/03 lúc 10:00 sẽ thắng.',
            ),
          ),
        ],
      ),
    );
  }
}
