part of '../pages/performance_attribution_page.dart';

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

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color.withValues(alpha: .55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
