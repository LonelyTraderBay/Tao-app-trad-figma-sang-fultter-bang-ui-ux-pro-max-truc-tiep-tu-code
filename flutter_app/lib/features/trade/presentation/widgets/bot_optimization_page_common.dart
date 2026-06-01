part of '../pages/bot_optimization_page.dart';

class _StartFooter extends StatelessWidget {
  const _StartFooter({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 17, 20, 18),
      color: _optimizationBackground.withValues(alpha: .96),
      child: SizedBox(
        height: 44,
        child: ElevatedButton.icon(
          key: BotOptimizationPage.startKey,
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_outlined, size: 18),
          label: Text(
            'Start Optimization',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontSize: 14,
              height: 1,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _optimizationPrimary,
            foregroundColor: AppColors.onAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
        ),
      ),
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
        color: _optimizationPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

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
            color: _optimizationPrimary,
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
