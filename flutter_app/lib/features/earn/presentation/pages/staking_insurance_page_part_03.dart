part of 'staking_insurance_page.dart';

class _PlanSheet extends StatelessWidget {
  const _PlanSheet({required this.plan});

  final StakingInsurancePlanDraft plan;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingInsurancePage.planSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetTitle(title: plan.name),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                _SheetRow(
                  label: 'Coverage',
                  value: '${plan.coverage}%',
                  valueColor: AppColors.buy,
                ),
                _SheetRow(label: 'Premium', value: '${plan.premium}% APY'),
                _SheetRow(
                  label: 'Max Claim',
                  value: _formatUsd(plan.maxClaim),
                  valueColor: AppColors.primarySoft,
                ),
                _SheetRow(
                  label: 'Claim Processing',
                  value: '${plan.cooldownDays} ngày',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Tính năng',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final feature in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Text(
              'Ví dụ: Stake \$10,000 với plan này, phí bảo hiểm là \$${(10000 * plan.premium / 100).toStringAsFixed(0)}/năm. Nếu slashing mất \$1,000, khoản bồi thường dự kiến là \$${(1000 * plan.coverage / 100).toStringAsFixed(0)}.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chọn plan này'),
          ),
        ],
      ),
    );
  }
}

class _ClaimSheet extends StatelessWidget {
  const _ClaimSheet({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final insuredPositions = snapshot.positions
        .where((p) => p.insured)
        .toList();

    return SingleChildScrollView(
      key: StakingInsurancePage.claimSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'File Claim'),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Chọn vị thế',
            child: _StaticSelect(
              value: insuredPositions.isEmpty
                  ? 'Không có vị thế'
                  : insuredPositions.first.product,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Lý do claim',
            child: _StaticSelect(value: snapshot.claimReasons.first),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Số lượng bị mất (USD)',
            child: const _TextInput(hint: '0.00', numeric: true),
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldGroup(
            label: 'Mô tả chi tiết',
            child: const _TextInput(
              hint: 'Mô tả sự cố và cung cấp bằng chứng...',
              minLines: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Submit Claim'),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    snapshot.claimEvidenceNote,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
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

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.text2),
        ),
      ],
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

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
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
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

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x3),
        child,
      ],
    );
  }
}

class _StaticSelect extends StatelessWidget {
  const _StaticSelect({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          const Icon(
            Icons.expand_more_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    required this.hint,
    this.numeric = false,
    this.minLines = 1,
  });

  final String hint;
  final bool numeric;
  final int minLines;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: _controller,
      hintText: widget.hint,
      semanticLabel: widget.hint,
      keyboardType: widget.numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
    );
  }
}

String _tabLabel(_InsuranceTab tab) {
  return switch (tab) {
    _InsuranceTab.overview => 'Tổng quan',
    _InsuranceTab.plans => 'Plans',
    _InsuranceTab.positions => 'Vị thế',
    _InsuranceTab.claims => 'Claims',
  };
}

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    'cost' => Icons.attach_money_rounded,
    'audit' => Icons.check_circle_outline_rounded,
    _ => Icons.shield_outlined,
  };
}

Color _iconColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy,
    'clock' => AppColors.primarySoft,
    'cost' => AppColors.warn,
    'audit' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

Color _iconFillColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy10,
    'clock' => AppColors.primary12,
    'cost' => AppColors.warn10,
    'audit' => AppColors.accent12,
    _ => AppColors.primary12,
  };
}

Color _iconBorder(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy20,
    'clock' => AppColors.primary30,
    'cost' => AppColors.warningBorder,
    'audit' => AppColors.accent30,
    _ => AppColors.primary30,
  };
}

String _formatUsd(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  final parts = value.toStringAsFixed(2).split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
}

extension on StakingInsuranceSnapshot {
  StakingInsurancePlanDraft? planById(String? id) {
    if (id == null) return null;
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}
