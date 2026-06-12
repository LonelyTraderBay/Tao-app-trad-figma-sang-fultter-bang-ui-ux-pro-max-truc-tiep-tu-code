part of '../pages/dca_schedule_config_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lịch trình thông minh',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Smart Scheduling tự động điều chỉnh thời gian DCA dựa trên điều kiện thị trường, giúp tối ưu chi phí và giảm rủi ro.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: AppSpacing.dcaScheduleInfoFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategySection extends StatelessWidget {
  const _StrategySection({
    required this.strategies,
    required this.active,
    required this.onChanged,
  });

  final List<DcaScheduleStrategyOption> strategies;
  final DcaScheduleStrategy active;
  final ValueChanged<DcaScheduleStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(icon: Icons.flash_on_outlined, title: 'Chiến lược'),
        const SizedBox(height: AppSpacing.x4),
        for (final option in strategies)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x3),
            child: _StrategyTile(
              option: option,
              selected: option.strategy == active,
              onTap: () => onChanged(option.strategy),
            ),
          ),
      ],
    );
  }
}

class _StrategyTile extends StatelessWidget {
  const _StrategyTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaScheduleStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForStrategy(option.strategy);
    return VitCard(
      key: DCAScheduleConfig.strategyKey(option.strategy),
      borderColor: selected
          ? accent.withValues(alpha: .72)
          : AppColors.cardBorder,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _AccentIcon(icon: _iconForOption(option.icon), accent: accent),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  option.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (selected) _SelectedDot(accent: accent),
        ],
      ),
    );
  }
}

class _TimePreferenceSection extends StatelessWidget {
  const _TimePreferenceSection({
    required this.preferences,
    required this.active,
    required this.activeAccent,
    required this.onChanged,
  });

  final List<DcaScheduleTimePreferenceOption> preferences;
  final DcaScheduleTimePreference active;
  final Color activeAccent;
  final ValueChanged<DcaScheduleTimePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(
          icon: Icons.schedule_outlined,
          title: 'Khung giờ ưu tiên',
        ),
        const SizedBox(height: AppSpacing.x4),
        LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
            return Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final option in preferences)
                  SizedBox(
                    width: tileWidth,
                    child: _TimeTile(
                      option: option,
                      selected: option.preference == active,
                      accent: activeAccent,
                      onTap: () => onChanged(option.preference),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final DcaScheduleTimePreferenceOption option;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAScheduleConfig.timeKey(option.preference),
      variant: VitCardVariant.inner,
      borderColor: selected ? accent.withValues(alpha: .72) : null,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            option.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
