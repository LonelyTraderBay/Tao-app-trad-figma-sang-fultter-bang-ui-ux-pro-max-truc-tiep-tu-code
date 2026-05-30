part of 'arena_smart_rule_builder_page.dart';

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({
    required this.domain,
    required this.challengeType,
    required this.winCondition,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
  });

  final String? domain;
  final String? challengeType;
  final String winCondition;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summarize_outlined,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tóm tắt luật chơi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const VitStatusPill(
                label: 'Tự sinh',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryRow(label: 'Lĩnh vực', value: domain ?? '-'),
          _SummaryRow(label: 'Loại challenge', value: challengeType ?? '-'),
          _SummaryRow(label: 'Điều kiện thắng', value: winCondition),
          _SummaryRow(label: 'Kết thúc', value: endDate),
          _SummaryRow(
            label: 'Luật hòa',
            value: tieRule.isEmpty ? '-' : tieRule,
          ),
          _SummaryRow(
            label: 'Luật hủy bỏ',
            value: voidRule.isEmpty ? '-' : voidRule,
          ),
          _SummaryRow(
            label: 'Hạn chốt kết quả',
            value: resultDeadline.isEmpty ? '-' : resultDeadline,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: value == '-' ? AppColors.text3 : AppColors.text1,
                fontWeight: value == '-'
                    ? AppTextStyles.normal
                    : AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationNote extends StatelessWidget {
  const _ModerationNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Challenge sẽ được kiểm duyệt tự động. Nội dung vi phạm sẽ bị ẩn. Arena Points không phải tài sản tài chính.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.canProceed,
    required this.clarityScore,
    required this.onBack,
    required this.onContinue,
    required this.onSave,
    this.statusLabel,
  });

  final bool canProceed;
  final int clarityScore;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: AppSpacing.ctaHeight,
              height: AppSpacing.ctaHeight,
              child: VitCtaButton(
                onPressed: onBack,
                variant: VitCtaButtonVariant.secondary,
                fullWidth: false,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.chevron_left_rounded),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaSmartRuleBuilderPage.continueKey,
                onPressed: canProceed ? onContinue : null,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: const Text('Tiếp tục'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            TextButton.icon(
              key: ArenaSmartRuleBuilderPage.saveKey,
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined, size: 15),
              label: const Text('Lưu nháp'),
            ),
            if (statusLabel != null)
              Expanded(
                child: Text(
                  statusLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
              )
            else
              const Spacer(),
            VitStatusPill(
              label: 'Clarity: $clarityScore',
              status: clarityScore >= 35
                  ? VitStatusPillStatus.orange
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Bước 3 / 6',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
    this.hint,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.x1,
          runSpacing: AppSpacing.x1,
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
            if (hint != null) ...[
              Text(
                hint!,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: AppColors.searchBg,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x4,
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.searchBorder, width: 1.5),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.5),
    ),
  );
}
