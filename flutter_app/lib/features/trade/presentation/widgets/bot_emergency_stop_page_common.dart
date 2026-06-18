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
      radius: VitCardRadius.sm,
      padding: AppSpacing.tradeBotFooterPadding.copyWith(bottom: bottomPadding),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: AppSpacing.tradeBotFooterButtonHeight,
              child: FilledButton(
                key: BotEmergencyStopPage.cancelKey,
                onPressed: onCancel,
                style: FilledButton.styleFrom(
                  backgroundColor: _stopPanel2,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.tradeBotCardGap),
          Expanded(
            child: SizedBox(
              height: AppSpacing.tradeBotFooterButtonHeight,
              child: FilledButton.icon(
                key: BotEmergencyStopPage.submitKey,
                onPressed: canSubmit ? onSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: canSubmit ? _stopRed : _stopPanel,
                  disabledBackgroundColor: _stopPanel,
                  foregroundColor: AppColors.onAccent,
                  disabledForegroundColor: AppColors.text3.withValues(
                    alpha: .4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                icon: stopping
                    ? const SizedBox(
                        width: AppSpacing.iconSm,
                        height: AppSpacing.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onAccent,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.pause_rounded,
                        size: AppSpacing.iconSm,
                        color: canSubmit
                            ? AppColors.onAccent
                            : AppColors.text3.withValues(alpha: .32),
                      ),
                label: Text(
                  stopping ? 'Stopping...' : 'Stop All Bots Now',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: canSubmit
                        ? AppColors.onAccent
                        : AppColors.text3.withValues(alpha: .32),
                    fontWeight: AppTextStyles.bold,
                  ),
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
