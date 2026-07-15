part of '../../pages/analytics/performance_attribution_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.extraBold,
        letterSpacing: .2,
      ),
    );
  }
}
