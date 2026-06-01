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
        fontWeight: FontWeight.w800,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        border: Border.all(color: color.withValues(alpha: .55)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: color,
                height: 1.45,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
