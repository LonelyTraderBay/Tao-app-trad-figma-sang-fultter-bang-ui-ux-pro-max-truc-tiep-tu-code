part of '../pages/copy_settings_page.dart';

class _CircuitBreakerCard extends StatelessWidget {
  const _CircuitBreakerCard({
    required this.enabled,
    required this.threshold,
    required this.onToggle,
    required this.onThresholdChanged,
  });

  final bool enabled;
  final double threshold;
  final VoidCallback onToggle;
  final ValueChanged<double> onThresholdChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: enabled
          ? AppSpacing.copySettingsCircuitBreakerExpandedHeight
          : AppSpacing.copySettingsCircuitBreakerCollapsedHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _settingsPrimary, size: 16),
              const SizedBox(width: AppSpacing.walletAssetSmallGap),
              Expanded(
                child: Text('Circuit Breaker', style: _cardTitleStyle()),
              ),
              _ToggleSwitch(
                key: CopySettingsPage.circuitBreakerKey,
                value: enabled,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAssetSmallGap),
          Text(
            'Tự động dừng TẤT CẢ copy khi tổng portfolio lỗ quá X%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          if (enabled) ...[
            const Spacer(),
            Row(
              children: [
                Text(
                  'Ngưỡng kích hoạt',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.copySettingsLineHeightCompact,
                  ),
                ),
                const Spacer(),
                Text(
                  '-${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.copySettingsLineHeightCompact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            _CompactSlider(
              value: threshold,
              min: 10,
              max: 50,
              divisions: 8,
              color: AppColors.sell,
              onChanged: onThresholdChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactSlider extends StatelessWidget {
  const _CompactSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.ctaLoadingIcon,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: AppSpacing.formFieldLabelGap,
          activeTrackColor: color,
          inactiveTrackColor: _sliderInactive,
          thumbColor: color,
          overlayColor: AppColors.transparent,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: AppSpacing.walletAssetSmallGap,
          ),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.id,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String id;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      height: AppSpacing.copySettingsNotificationRowHeight,
      padding: AppSpacing.copySettingsNotificationPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _cardTitleStyle()),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.copySettingsLineHeightLoose,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.cardGap),
          _ToggleSwitch(
            key: CopySettingsPage.notificationKey(id),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: AppRadii.xlRadius,
      child: VitTogglePill(
        enabled: value,
        height: AppSpacing.statusPillHeightMd,
        knobSize: AppSpacing.homeNextActionIconSize,
        knobMargin: AppSpacing.copySettingsToggleKnobMargin,
        activeColor: _settingsPrimary,
        inactiveColor: AppColors.surface3,
        inactiveBorderColor: AppColors.surface3,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AppSpacing.dividerHairline,
      thickness: AppSpacing.dividerHairline,
      color: AppColors.cardBorder,
    );
  }
}

class _ChannelButton extends StatelessWidget {
  const _ChannelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      height: AppSpacing.walletDepositCopyButtonHeight,
      padding: AppSpacing.copySettingsChannelPadding,
      borderColor: active ? _settingsPrimary : AppColors.cardBorder,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: active ? _settingsPrimary : AppColors.text3,
            size: AppSpacing.walletTokenApprovalActionIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? _settingsPrimary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.copySettingsLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
