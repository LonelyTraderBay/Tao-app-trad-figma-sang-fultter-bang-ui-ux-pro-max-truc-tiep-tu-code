part of 'arena_governance_gate_page.dart';

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Mô tả ngắn',
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        maxLines: 2,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration(
          'Mô tả bối cảnh nếu cần. Không cần lặp lại luật chơi.',
        ),
      ),
    );
  }
}

class _ResolutionSourceField extends StatelessWidget {
  const _ResolutionSourceField({
    required this.publicRoom,
    required this.value,
    required this.options,
    required this.onTap,
  });

  final bool publicRoom;
  final String value;
  final List<String> options;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Cách chốt kết quả',
      required: publicRoom,
      child: _DropdownCard(
        value: value,
        placeholder: 'Chọn resolution source...',
        onTap: onTap,
      ),
    );
  }
}

class _TimingRulesCard extends StatelessWidget {
  const _TimingRulesCard({
    required this.snapshot,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.rematchEnabled,
    required this.saveAsMode,
    required this.publicRoom,
    required this.onDate,
    required this.onTieRule,
    required this.onVoidRule,
    required this.onResultDeadline,
    required this.onRematch,
    required this.onSaveAsMode,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final bool publicRoom;
  final ValueChanged<String> onDate;
  final VoidCallback onTieRule;
  final VoidCallback onVoidRule;
  final VoidCallback onResultDeadline;
  final VoidCallback onRematch;
  final VoidCallback onSaveAsMode;

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
                Icons.schedule_outlined,
                color: AppColors.buy,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Timing & Edge Rules',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _FieldBlock(
            label: 'Thời hạn kết thúc',
            child: TextFormField(
              initialValue: _formatArenaDateInput(endDate),
              onChanged: (value) => onDate(_normalizeArenaDateInput(value)),
              style: AppTextStyles.base.copyWith(color: AppColors.text1),
              decoration: _inputDecoration('03/15/2026').copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.text3,
                  size: 16,
                ),
              ),
            ),
          ),
          _EdgeField(
            label: 'Luật hòa',
            publicRoom: publicRoom,
            value: tieRule,
            placeholder: 'Chọn tie rule...',
            onTap: onTieRule,
          ),
          _EdgeField(
            label: 'Luật hủy bỏ',
            publicRoom: publicRoom,
            value: voidRule,
            placeholder: 'Chọn void rule...',
            onTap: onVoidRule,
          ),
          _EdgeField(
            label: 'Hạn chốt kết quả',
            publicRoom: publicRoom,
            value: resultDeadline,
            placeholder: 'Chọn result deadline...',
            onTap: onResultDeadline,
          ),
          const SizedBox(height: AppSpacing.x2),
          _SwitchRow(
            label: 'Cho phép rematch',
            description: 'Người chơi có thể yêu cầu chơi lại',
            value: rematchEnabled,
            onTap: onRematch,
          ),
          _SwitchRow(
            label: 'Lưu thành reusable mode',
            description: 'Người khác có thể clone luật chơi',
            value: saveAsMode,
            onTap: onSaveAsMode,
          ),
        ],
      ),
    );
  }
}

class _WarningStack extends StatelessWidget {
  const _WarningStack({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    if (result.warnings.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final warning in result.warnings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.warningBorder,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warn,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      warning,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SuggestedFallbackCard extends StatelessWidget {
  const _SuggestedFallbackCard({
    required this.suggestions,
    required this.onTap,
  });

  final List<ArenaGovernanceSuggestionDraft> suggestions;
  final ValueChanged<ArenaGovernanceSuggestionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.lightbulb_outline_rounded,
            label: 'Gợi ý cải thiện',
            pill: 'SMART',
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in suggestions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                onTap: () => onTap(item),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high_rounded,
                      color: _arenaAccent,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            item.description,
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
                      color: AppColors.text3,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EligibilityPanel extends StatelessWidget {
  const _EligibilityPanel({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return VitCard(
      borderColor: _tierBorder(result.tier),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_tierIcon(result.tier), color: color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _tierLabel(result.tier),
                  style: AppTextStyles.base.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusPill(label: 'Clarity: ${result.clarity}', color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final check in result.checks)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                children: [
                  Icon(
                    check.passed
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: check.passed ? AppColors.buy : AppColors.text3,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      check.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: check.passed
                            ? AppTextStyles.bold
                            : AppTextStyles.medium,
                      ),
                    ),
                  ),
                  if (!check.passed)
                    const _RequiredPill(text: 'PUBLIC', compact: true),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GovernanceSummary extends StatelessWidget {
  const _GovernanceSummary({
    required this.result,
    required this.privacy,
    required this.resolutionSource,
  });

  final _GovernanceResult result;
  final String privacy;
  final String resolutionSource;

  @override
  Widget build(BuildContext context) {
    final privacyLabel = privacy == 'public'
        ? 'Công khai'
        : privacy == 'private'
        ? 'Riêng tư'
        : 'Unlisted';
    return VitCard(
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.summarize_outlined,
            label: 'Governance Summary',
            pill: 'TỰ SINH',
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryRow(label: 'Rule clarity', value: '${result.clarity} / 100'),
          _SummaryRow(
            label: 'Publish eligibility',
            value: _tierLabel(result.tier),
          ),
          _SummaryRow(label: 'Risk tier', value: result.risk),
          _SummaryRow(
            label: 'Resolution method',
            value: resolutionSource.isEmpty ? '-' : resolutionSource,
          ),
          _SummaryRow(label: 'Privacy', value: privacyLabel),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    result.tier == _EligibilityTier.green
                        ? 'Rule đủ rõ để tiếp tục.'
                        : 'Nên chuyển sang Private hoặc Unlisted cho đến khi rule rõ ràng hơn.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _NextActionChip(text: result.nextAction),
        ],
      ),
    );
  }
}

class _GovernanceFooter extends StatelessWidget {
  const _GovernanceFooter({
    required this.canContinue,
    required this.result,
    required this.statusLabel,
    required this.onBack,
    required this.onSave,
    required this.onContinue,
  });

  final bool canContinue;
  final _GovernanceResult result;
  final String? statusLabel;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x4,
          AppSpacing.x5,
          AppSpacing.x2,
        ),
        child: Column(
          children: [
            Row(
              children: [
                VitCard(
                  variant: VitCardVariant.inner,
                  width: AppSpacing.ctaHeight,
                  height: AppSpacing.ctaHeight,
                  onTap: onBack,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.text2,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitCtaButton(
                    key: ArenaGovernanceGatePage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tiếp tục'),
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: canContinue
                              ? AppColors.onAccent
                              : AppColors.text3,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                VitCard(
                  key: ArenaGovernanceGatePage.saveKey,
                  variant: VitCardVariant.ghost,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x1,
                    vertical: AppSpacing.x2,
                  ),
                  onTap: onSave,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        color: AppColors.text3,
                        size: 14,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Lưu nháp',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    statusLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                _StatusPill(label: _tierLabel(result.tier), color: color),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Bước 3 / 6',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
