part of '../pages/trade_settings_page.dart';

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.height,
    required this.onTap,
  });

  final String label;
  final bool active;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = height < 32
        ? AppTextStyles.badge
        : AppTextStyles.captionSm;
    return VitCard(
      onTap: onTap,
      height: height,
      alignment: Alignment.center,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      density: VitDensity.compact,
      borderColor: active ? _tradePrimary : AppColors.surface3,
      clip: true,
      background: ColoredBox(
        color: active ? _tradePrimary.withValues(alpha: .14) : _chipBackground,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: labelStyle.copyWith(
          color: active ? _tradePrimary : AppColors.textMutedLight,
          fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          height: _settingsLineTight,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.description,
    required this.trailing,
  });

  final String label;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: _settingsLineTight,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: _settingsTinySpace),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    height: _settingsLineBody,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: _settingsSpace),
        trailing,
      ],
    );
  }
}

class _VitToggle extends StatelessWidget {
  const _VitToggle({super.key, required this.on, required this.onToggle});

  final bool on;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onToggle,
        child: VitTogglePill(
          enabled: on,
          width: _settingsToggleWidth,
          height: _settingsToggleHeight,
          knobSize: _settingsToggleKnob,
          knobMargin: _settingsToggleKnobMargin,
          inactiveColor: AppColors.surface3,
          inactiveKnobColor: AppColors.onAccent,
          inactiveBorderColor: AppColors.surface3,
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: TradeSettingsPage.resetKey,
      onPressed: onReset,
      variant: VitCtaButtonVariant.danger,
      height: _settingsButtonHeight,
      leading: const Icon(Icons.restart_alt_rounded),
      child: const Text('Đặt lại mặc định'),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'Settings apply locally',
      message:
          'Settings are saved on this device and apply immediately. Other devices keep default settings until changed there.',
      contractId: 'SC-052 local settings result',
      density: VitDensity.compact,
    );
  }
}
