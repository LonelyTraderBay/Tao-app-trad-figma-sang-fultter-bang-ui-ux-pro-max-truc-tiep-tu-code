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
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding),
      decoration: BoxDecoration(
        color: _stopBackground.withValues(alpha: .94),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder.withValues(alpha: .7)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
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
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 44,
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
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onAccent,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.pause_rounded,
                        size: 16,
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
                    height: 1,
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _stopPrimary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
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
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class _CheckboxMark extends StatelessWidget {
  const _CheckboxMark({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(top: 1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? color : AppColors.transparent,
        border: Border.all(
          color: selected ? color : _stopOptionBorder,
          width: 2,
        ),
        borderRadius: AppRadii.mdRadius,
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: AppColors.onAccent, size: 16)
          : null,
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
