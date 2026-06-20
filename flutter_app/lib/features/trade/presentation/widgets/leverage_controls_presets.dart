part of '../pages/leverage_page.dart';

class _LeverageSlider extends StatelessWidget {
  const _LeverageSlider({
    required this.leverage,
    required this.stops,
    required this.riskColor,
    required this.onChanged,
  });

  final int leverage;
  final List<int> stops;
  final Color riskColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _leverageCardSpace,
        top: _leverageCardSpace,
        right: _leverageCardSpace,
        bottom: _leverageCardSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kéo để điều chỉnh',
            style: AppTextStyles.captionSm.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _leverageSpace),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: AppSpacing.hairlineStroke * 2,
              activeTrackColor: riskColor,
              inactiveTrackColor: AppColors.medalSilverMuted,
              thumbColor: riskColor,
              overlayColor: riskColor.withValues(alpha: .12),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: AppSpacing.x3,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: AppSpacing.ctaLoadingIcon,
              ),
            ),
            child: Slider(
              key: LeveragePage.sliderKey,
              min: 1,
              max: 100,
              divisions: 99,
              value: leverage.toDouble(),
              onChanged: (value) => onChanged(value.round()),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              for (final stop in stops) ...[
                Expanded(
                  child: _StopButton(
                    leverage: stop,
                    active: leverage == stop,
                    onTap: () => onChanged(stop),
                  ),
                ),
                if (stop != stops.last)
                  const SizedBox(width: AppSpacing.transferCardGap),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    required this.leverage,
    required this.active,
    required this.onTap,
  });

  final int leverage;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: LeveragePage.stopKey(leverage),
      onPressed: onTap,
      height: _leverageControlHeight,
      variant: active ? VitCtaButtonVariant.primary : VitCtaButtonVariant.ghost,
      padding: AppSpacing.zeroInsets,
      child: Text(
        '${leverage}x',
        style: AppTextStyles.numericCode.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          height: _leverageControlLineHeight,
        ),
      ),
    );
  }
}

class _PresetGrid extends StatelessWidget {
  const _PresetGrid({
    required this.presets,
    required this.active,
    required this.onChanged,
  });

  final List<int> presets;
  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _leverageCardSpace,
        top: _leverageCardSpace,
        right: _leverageCardSpace,
        bottom: _leverageCardSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chọn nhanh',
            style: AppTextStyles.captionSm.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _leverageSpace),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppSpacing.zeroInsets,
            itemCount: presets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSpacing.leveragePresetGridColumns,
              crossAxisSpacing: AppSpacing.transferCardGap,
              mainAxisSpacing: _leverageSpace,
              childAspectRatio: AppSpacing.leveragePresetGridAspectRatio,
            ),
            itemBuilder: (context, index) {
              final leverage = presets[index];
              return _PresetButton(
                leverage: leverage,
                active: leverage == active,
                onTap: () => onChanged(leverage),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.leverage,
    required this.active,
    required this.onTap,
  });

  final int leverage;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: LeveragePage.presetKey(leverage),
      onPressed: onTap,
      height: _leverageControlHeight,
      variant: active ? VitCtaButtonVariant.primary : VitCtaButtonVariant.ghost,
      padding: AppSpacing.zeroInsets,
      child: Text(
        '${leverage}x',
        style: AppTextStyles.numericCode.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: _leverageControlLineHeight,
        ),
      ),
    );
  }
}
