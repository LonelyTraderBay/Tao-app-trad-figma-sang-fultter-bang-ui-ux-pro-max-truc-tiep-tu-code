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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kéo để điều chỉnh',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: riskColor,
              inactiveTrackColor: AppColors.medalSilverMuted,
              thumbColor: riskColor,
              overlayColor: riskColor.withValues(alpha: .12),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
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
          const SizedBox(height: 4),
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
                if (stop != stops.last) const SizedBox(width: 9),
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
    return InkWell(
      key: LeveragePage.stopKey(leverage),
      onTap: onTap,
      borderRadius: AppRadii.xlRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradePrimary : _chipBackground,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: active ? _tradePrimary : AppColors.borderSolid,
          ),
        ),
        child: Text(
          '${leverage}x',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 12,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chọn nhanh',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: presets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 9,
              mainAxisSpacing: 10,
              childAspectRatio: 1.78,
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
    return InkWell(
      key: LeveragePage.presetKey(leverage),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? null : _chipBackground,
          gradient: active
              ? const LinearGradient(
                  colors: [_tradePrimary, _tradePrimaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: active ? AppColors.transparent : AppColors.borderSolid,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _tradePrimary.withValues(alpha: .26),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          '${leverage}x',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.onAccent : AppColors.text2,
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
