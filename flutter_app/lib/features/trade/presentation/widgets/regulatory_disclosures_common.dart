part of '../pages/regulatory_disclosures_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}
