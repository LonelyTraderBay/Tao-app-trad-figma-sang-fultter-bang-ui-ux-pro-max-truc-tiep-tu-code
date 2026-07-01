part of '../pages/bot_emergency_stop_page.dart';

class _StickyActions extends StatelessWidget {
  const _StickyActions({
    required this.bottomPadding,
    required this.canSubmit,
    required this.stopping,
    required this.onCancel,
    required this.onSubmit,
  });

  final double bottomPadding;
  final bool canSubmit;
  final bool stopping;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.tradeBotFooterPadding.copyWith(bottom: bottomPadding),
      child: Row(
        children: [
          Expanded(
            child: VitCtaButton(
              key: BotEmergencyStopPage.cancelKey,
              height: AppSpacing.tradeBotFooterButtonHeight,
              variant: VitCtaButtonVariant.secondary,
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotCardGap),
          Expanded(
            child: VitCtaButton(
              key: BotEmergencyStopPage.submitKey,
              height: AppSpacing.tradeBotFooterButtonHeight,
              variant: VitCtaButtonVariant.destructive,
              loading: stopping,
              onPressed: canSubmit ? onSubmit : null,
              leading: const Icon(Icons.pause_rounded),
              child: Text(
                stopping ? 'Stopping...' : 'Stop All Bots Now',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _stopPrimary,
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected, required this.danger});

  final bool selected;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? _stopRed : _stopOptionBorder;
    return Icon(
      selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded,
      color: color,
      size: AppSpacing.contentPad,
    );
  }
}

class _CheckboxMark extends StatelessWidget {
  const _CheckboxMark({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.check_box_rounded
          : Icons.check_box_outline_blank_rounded,
      color: selected ? color : _stopOptionBorder,
      size: AppSpacing.tradeBotCheckbox,
    );
  }
}

IconData _reasonIcon(String iconName) {
  return switch (iconName) {
    'crash' => Icons.show_chart_rounded,
    'bug' => Icons.settings_suggest_rounded,
    'unauthorized' => Icons.warning_amber_rounded,
    'drawdown' => Icons.error_outline_rounded,
    _ => Icons.help_outline_rounded,
  };
}

Color _reasonColor(TradeBotEmergencyReason reason) {
  return switch (reason.iconName) {
    'crash' => AppColors.crashAccent,
    'bug' => AppColors.statusBattery,
    'unauthorized' => AppColors.sell,
    'drawdown' => AppColors.caution,
    _ => AppColors.text2,
  };
}
