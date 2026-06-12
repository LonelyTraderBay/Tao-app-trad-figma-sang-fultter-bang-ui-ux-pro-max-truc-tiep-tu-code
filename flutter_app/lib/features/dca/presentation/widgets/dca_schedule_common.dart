part of '../pages/dca_schedule_config_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.text1,
          size: AppSpacing.dcaScheduleSectionIcon,
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: AppSpacing.dcaScheduleSectionTitleFontSize,
          ),
        ),
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.dcaScheduleAccentIconBox,
      height: AppSpacing.dcaScheduleAccentIconBox,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: accent, size: AppSpacing.iconMd),
    );
  }
}

class _SelectedDot extends StatelessWidget {
  const _SelectedDot({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.dcaScheduleSelectedDot,
      height: AppSpacing.dcaScheduleSelectedDot,
      decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Container(
        width: AppSpacing.dcaScheduleSelectedDotInner,
        height: AppSpacing.dcaScheduleSelectedDotInner,
        decoration: const BoxDecoration(
          color: AppColors.navCenterIcon,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

IconData _iconForOption(DcaScheduleOptionIcon icon) {
  switch (icon) {
    case DcaScheduleOptionIcon.clock:
      return Icons.schedule_outlined;
    case DcaScheduleOptionIcon.trend:
      return Icons.trending_down;
    case DcaScheduleOptionIcon.bolt:
      return Icons.bolt_outlined;
    case DcaScheduleOptionIcon.chart:
      return Icons.bar_chart;
  }
}

Color _accentForStrategy(DcaScheduleStrategy strategy) {
  switch (strategy) {
    case DcaScheduleStrategy.fixed:
      return AppColors.text3;
    case DcaScheduleStrategy.volatility:
      return AppColors.accent;
    case DcaScheduleStrategy.gasOptimized:
      return AppColors.warn;
    case DcaScheduleStrategy.volume:
      return AppColors.primarySoft;
    case DcaScheduleStrategy.hybrid:
      return AppColors.buy;
  }
}
