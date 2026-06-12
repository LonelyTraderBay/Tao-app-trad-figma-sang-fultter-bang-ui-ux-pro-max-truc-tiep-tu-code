part of '../pages/dca_portfolio_optimizer_page.dart';

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(icon: icon, color: color),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.x2,
              height: AppSpacing.x2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.inputRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: AppSpacing.dcaPortfolioOptimizerBodyLineHeight,
          ),
        ),
      ],
    );
  }
}
