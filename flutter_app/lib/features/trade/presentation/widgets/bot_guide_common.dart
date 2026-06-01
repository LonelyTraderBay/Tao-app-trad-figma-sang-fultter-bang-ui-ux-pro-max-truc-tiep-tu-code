part of '../pages/bot_guide_page.dart';

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
            color: _guidePrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _guidePanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

IconData _strategyIcon(String key) => switch (key) {
  'grid' => Icons.grid_view_rounded,
  'bolt' => Icons.bolt_rounded,
  'alert' => Icons.warning_amber_rounded,
  _ => Icons.trending_up_rounded,
};

IconData _practiceIcon(String key) => switch (key) {
  'chart' => Icons.bar_chart_rounded,
  'shield' => Icons.shield_outlined,
  'eye' => Icons.visibility_outlined,
  'target' => Icons.track_changes_rounded,
  'warning' => Icons.warning_amber_rounded,
  _ => Icons.lightbulb_outline_rounded,
};
