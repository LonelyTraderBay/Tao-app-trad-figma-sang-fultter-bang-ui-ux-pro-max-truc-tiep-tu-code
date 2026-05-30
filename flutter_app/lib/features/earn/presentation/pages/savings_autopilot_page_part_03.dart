part of 'savings_autopilot_page.dart';

class _RiskParameter extends StatelessWidget {
  const _RiskParameter({
    required this.label,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    required this.color,
  });

  final String label;
  final String value;
  final String minLabel;
  final String maxLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: _captionBold)),
              Text(value, style: _captionBold.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: .42,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(child: Text(minLabel, style: AppTextStyles.micro)),
              Text(maxLabel, style: AppTextStyles.micro),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionDetailSheet extends StatelessWidget {
  const _ActionDetailSheet({
    required this.action,
    required this.status,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotActionDraft action;
  final SavingsAutoPilotActionStatus status;
  final VoidCallback? onApprove;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final typeColor = _actionTypeColor(action.type);
    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _IconBadge(
                    icon: _actionTypeIcon(action.type),
                    color: typeColor,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(action.title, style: _captionBold),
                        Text(
                          action.timestamp,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SmallPill(
                    label: _actionStatusLabel(status),
                    color: _actionStatusColor(status),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                action.description,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Column(
                  children: [
                    for (final entry in action.details.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x1,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            Text(entry.value, style: _captionBold),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (onApprove != null && onSkip != null) ...[
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onSkip,
                        variant: VitCtaButtonVariant.secondary,
                        child: const Text('Bỏ qua'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: VitCtaButton(
                        onPressed: onApprove,
                        variant: VitCtaButtonVariant.success,
                        child: const Text('Phê duyệt'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(label, style: _microBold.copyWith(color: color)),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        foregroundColor: selected ? AppColors.primary : AppColors.text2,
        side: BorderSide(
          color: selected ? AppColors.primary40 : AppColors.borderSolid,
        ),
        backgroundColor: selected ? AppColors.primary12 : AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, style: _microBold),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: _captionBold.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({required this.text, required this.tone});

  final String text;
  final EarnRiskLevel tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
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

SavingsAutoPilotModeDraft _modeById(
  SavingsAutoPilotSnapshot snapshot,
  SavingsAutoPilotMode id,
) {
  return snapshot.modes.firstWhere((mode) => mode.id == id);
}

String _money(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    final left = raw.length - i;
    buffer.write(raw[i]);
    if (left > 1 && left % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.00';
}

IconData _iconFor(String key) {
  return switch (key) {
    'shield' => Icons.shield_outlined,
    'target' => Icons.track_changes_rounded,
    'bolt' => Icons.bolt_rounded,
    'repeat' => Icons.repeat_rounded,
    'rebalance' => Icons.sync_rounded,
    'spark' => Icons.auto_awesome_rounded,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.tune_rounded,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.accent,
  };
}

Color _statusColor(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => AppColors.buy,
    SavingsAutoPilotStatus.paused => AppColors.warn,
    SavingsAutoPilotStatus.inactive => AppColors.text3,
  };
}

IconData _statusIcon(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => Icons.play_arrow_rounded,
    SavingsAutoPilotStatus.paused => Icons.pause_rounded,
    SavingsAutoPilotStatus.inactive => Icons.power_settings_new_rounded,
  };
}

String _statusLabel(SavingsAutoPilotStatus status) {
  return switch (status) {
    SavingsAutoPilotStatus.active => 'Đang chạy',
    SavingsAutoPilotStatus.paused => 'Tạm dừng',
    SavingsAutoPilotStatus.inactive => 'Kích hoạt',
  };
}

IconData _actionTypeIcon(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => Icons.repeat_rounded,
    SavingsAutoPilotActionType.rebalanced => Icons.sync_rounded,
    SavingsAutoPilotActionType.switchProduct => Icons.swap_horiz_rounded,
    SavingsAutoPilotActionType.compoundActivated => Icons.bolt_rounded,
    SavingsAutoPilotActionType.apyOptimized => Icons.trending_up_rounded,
    SavingsAutoPilotActionType.riskAdjusted => Icons.shield_outlined,
  };
}

Color _actionTypeColor(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => AppColors.buy,
    SavingsAutoPilotActionType.rebalanced => AppColors.primary,
    SavingsAutoPilotActionType.switchProduct => AppColors.accent,
    SavingsAutoPilotActionType.compoundActivated => AppColors.buy,
    SavingsAutoPilotActionType.apyOptimized => AppColors.warn,
    SavingsAutoPilotActionType.riskAdjusted => AppColors.sell,
  };
}

String _actionTypeLabel(SavingsAutoPilotActionType type) {
  return switch (type) {
    SavingsAutoPilotActionType.dcaExecuted => 'DCA',
    SavingsAutoPilotActionType.rebalanced => 'Rebalance',
    SavingsAutoPilotActionType.switchProduct => 'Chuyển SP',
    SavingsAutoPilotActionType.compoundActivated => 'Lãi kép',
    SavingsAutoPilotActionType.apyOptimized => 'Tối ưu APY',
    SavingsAutoPilotActionType.riskAdjusted => 'Rủi ro',
  };
}

Color _actionStatusColor(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => AppColors.buy,
    SavingsAutoPilotActionStatus.pending => AppColors.warn,
    SavingsAutoPilotActionStatus.skipped => AppColors.text3,
    SavingsAutoPilotActionStatus.needsApproval => AppColors.primary,
  };
}

String _actionStatusLabel(SavingsAutoPilotActionStatus status) {
  return switch (status) {
    SavingsAutoPilotActionStatus.executed => 'Đã thực hiện',
    SavingsAutoPilotActionStatus.pending => 'Đang xử lý',
    SavingsAutoPilotActionStatus.skipped => 'Bỏ qua',
    SavingsAutoPilotActionStatus.needsApproval => 'Cần duyệt',
  };
}
