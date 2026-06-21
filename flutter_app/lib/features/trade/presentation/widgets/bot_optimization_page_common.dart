part of '../pages/bot_optimization_page.dart';

class _StartFooter extends StatelessWidget {
  const _StartFooter({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _optimizationBackground.withValues(alpha: .96),
      child: Padding(
        padding: AppSpacing.tradeBotFooterPadding.copyWith(
          top: AppSpacing.tradeBotSmallGap,
          bottom: AppSpacing.tradeBotSmallGap,
        ),
        child: VitCtaButton(
          key: BotOptimizationPage.startKey,
          onPressed: onStart,
          height: AppSpacing.tradeBotSheetActionHeight,
          leading: const Icon(Icons.play_arrow_outlined),
          child: const Text('Start Optimization'),
        ),
      ),
    );
  }
}
