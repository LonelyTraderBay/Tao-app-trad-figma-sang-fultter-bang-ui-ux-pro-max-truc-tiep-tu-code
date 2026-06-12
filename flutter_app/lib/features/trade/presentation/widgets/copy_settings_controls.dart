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
      height: enabled ? 122 : 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _settingsPrimary, size: 16),
              const SizedBox(width: 7),
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
          const SizedBox(height: 7),
          Text(
            'Tự động dừng TẤT CẢ copy khi tổng portfolio lỗ quá X%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          if (enabled) ...[
            const Spacer(),
            Row(
              children: [
                Text(
                  'Ngưỡng kích hoạt',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '-${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
      height: 18,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          activeTrackColor: color,
          inactiveTrackColor: _sliderInactive,
          thumbColor: color,
          overlayColor: AppColors.transparent,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
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
      height: 56,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _cardTitleStyle()),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
      child: Container(
        width: 48,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? _settingsPrimary : AppColors.surface3,
          borderRadius: AppRadii.xlRadius,
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.onAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.cardBorder);
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? _settingsPrimary.withValues(alpha: .08)
              : AppColors.transparent,
          border: Border.all(
            color: active ? _settingsPrimary : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? _settingsPrimary : AppColors.text3,
              size: 15,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? _settingsPrimary : AppColors.text2,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
