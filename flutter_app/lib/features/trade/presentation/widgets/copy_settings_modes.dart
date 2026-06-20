part of '../pages/copy_settings_page.dart';

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.label,
    required this.accent,
    required this.children,
    this.showAccent = true,
  });

  final String label;
  final Color accent;
  final List<Widget> children;
  final bool showAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitSectionHeader(
            title: label,
            variant: showAccent
                ? VitSectionHeaderVariant.accentBar
                : VitSectionHeaderVariant.plain,
            accentColor: accent,
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final child in children) ...[
            child,
            if (child != children.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.selected, required this.onChanged});

  final TradeCopySettingsMode selected;
  final ValueChanged<TradeCopySettingsMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Copy Mode mặc định', style: _cardTitleStyle()),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final mode in TradeCopySettingsMode.values) ...[
                Expanded(
                  child: _ModeButton(
                    mode: mode,
                    active: selected == mode,
                    onTap: () => onChanged(mode),
                  ),
                ),
                if (mode != TradeCopySettingsMode.values.last)
                  const SizedBox(width: AppSpacing.walletAssetPillGap),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.mode,
    required this.active,
    required this.onTap,
  });

  final TradeCopySettingsMode mode;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: CopySettingsPage.modeKey(mode),
      onPressed: onTap,
      variant: active ? VitCtaButtonVariant.primary : VitCtaButtonVariant.ghost,
      density: VitDensity.compact,
      child: Text(
        _modeLabel(mode),
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  const _SliderCard({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.onChanged,
    this.subtitle,
    this.caption,
  });

  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;
  final String? subtitle;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _cardTitleStyle()),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.walletAssetPillGap),
              Text(
                valueLabel,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _CompactSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            color: color,
            onChanged: onChanged,
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}
