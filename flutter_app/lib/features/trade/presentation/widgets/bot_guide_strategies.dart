part of '../pages/bot_guide_page.dart';

class _StrategiesView extends StatelessWidget {
  const _StrategiesView({
    required this.strategies,
    required this.expandedStrategyId,
    required this.onToggle,
  });

  final List<TradeBotGuideStrategy> strategies;
  final String? expandedStrategyId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Bot Strategies Explained',
      customGap: AppSpacing.tradeBotCardIconGap,
      children: [
        for (final strategy in strategies)
          _StrategyCard(
            strategy: strategy,
            expanded: expandedStrategyId == strategy.id,
            onTap: () => onToggle(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.expanded,
    required this.onTap,
  });

  final TradeBotGuideStrategy strategy;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      key: BotGuidePage.strategyKey(strategy.id),
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.tradeBotCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitCard(
                  variant: VitCardVariant.inner,
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  alignment: Alignment.center,
                  borderColor: color.withValues(alpha: .30),
                  child: SizedBox(
                    child: Icon(_strategyIcon(strategy.iconKey), color: color),
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotCardIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              strategy.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                color: color,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.tradeBotSmallGap),
                          _DifficultyBadge(difficulty: strategy.difficulty),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.tradeBotSmallGap),
                      Text(
                        strategy.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotRowGap),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: AppSpacing.tradeBotCardPadding,
              child: _StrategyDetails(strategy: strategy),
            ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final status = switch (difficulty) {
      'Beginner' => VitStatusPillStatus.success,
      'Intermediate' => VitStatusPillStatus.warning,
      'Advanced' => VitStatusPillStatus.purple,
      _ => VitStatusPillStatus.error,
    };
    return VitStatusPill(
      label: difficulty,
      status: status,
      size: VitStatusPillSize.sm,
    );
  }
}

class _StrategyDetails extends StatelessWidget {
  const _StrategyDetails({required this.strategy});

  final TradeBotGuideStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: AppSpacing.tradeBotPageTopGap,
      children: [
        _StepsBlock(color: color, steps: strategy.howItWorks),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _BulletsBlock(
                title: 'Pros',
                titleColor: _guideGreen,
                items: strategy.pros,
              ),
            ),
            const SizedBox(width: AppSpacing.tradeBotCardIconGap),
            Expanded(
              child: _BulletsBlock(
                title: 'Cons',
                titleColor: _guideRed,
                items: strategy.cons,
              ),
            ),
          ],
        ),
        _BestForBlock(text: strategy.bestFor),
        _ExampleBlock(color: color, example: strategy.example),
      ],
    );
  }
}
