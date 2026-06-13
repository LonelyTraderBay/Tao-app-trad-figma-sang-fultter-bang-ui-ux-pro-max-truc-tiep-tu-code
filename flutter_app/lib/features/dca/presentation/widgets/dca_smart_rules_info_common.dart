part of '../pages/dca_smart_rules_page.dart';

class _ImpactCard extends StatelessWidget {
  const _ImpactCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Impact',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          const Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Avg Entry Price',
                  value: '-8.2%',
                  color: AppColors.buy,
                  caption: 'vs standard DCA',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Total Saved',
                  value: r'$987',
                  color: AppColors.buy,
                  caption: 'from optimizations',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppSpacing.dcaSmartInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.dcaSmartInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DcaSmartRuleStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return _TinyBadge(
      label: status.name.toUpperCase(),
      color: color,
      background: color.withValues(alpha: 0.15),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final DcaSmartRuleType type;

  @override
  Widget build(BuildContext context) {
    return _TinyBadge(
      label: type.name.toUpperCase(),
      color: AppColors.text2,
      background: AppColors.surface2,
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final DcaSmartRuleResult result;

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(result);
    return _TinyBadge(
      label: result.name.toUpperCase(),
      color: color,
      background: color.withValues(alpha: 0.15),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.dcaSmartBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.sell10,
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: AppSpacing.dcaSmartInlineIcon,
            color: AppColors.sell,
          ),
        ),
      ),
    );
  }
}

class _RuleText extends StatelessWidget {
  const _RuleText({required this.label, required this.value});

  final String label;
  final String value;

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
          style: AppTextStyles.caption.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _CodeRow extends StatelessWidget {
  const _CodeRow({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.monoCode.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _typeIcon(DcaSmartRuleType type) {
  switch (type) {
    case DcaSmartRuleType.entry:
      return Icons.trending_down_rounded;
    case DcaSmartRuleType.exit:
      return Icons.adjust_rounded;
    case DcaSmartRuleType.adjust:
      return Icons.settings_outlined;
  }
}

Color _statusColor(DcaSmartRuleStatus status) {
  switch (status) {
    case DcaSmartRuleStatus.active:
      return AppColors.buy;
    case DcaSmartRuleStatus.paused:
      return AppColors.warn;
    case DcaSmartRuleStatus.triggered:
      return AppColors.primary;
  }
}

Color _resultColor(DcaSmartRuleResult result) {
  switch (result) {
    case DcaSmartRuleResult.executed:
      return AppColors.buy;
    case DcaSmartRuleResult.failed:
      return AppColors.sell;
    case DcaSmartRuleResult.pending:
      return AppColors.warn;
  }
}
