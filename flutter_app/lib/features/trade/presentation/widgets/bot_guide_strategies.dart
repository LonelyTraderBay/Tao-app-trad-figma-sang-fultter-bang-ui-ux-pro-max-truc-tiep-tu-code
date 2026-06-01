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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Bot Strategies Explained'),
        const SizedBox(height: 8),
        for (final strategy in strategies) ...[
          _StrategyCard(
            strategy: strategy,
            expanded: expandedStrategyId == strategy.id,
            onTap: () => onToggle(strategy.id),
          ),
          if (strategy != strategies.last) const SizedBox(height: 13),
        ],
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
    return Container(
      key: BotGuidePage.strategyKey(strategy.id),
      decoration: BoxDecoration(
        color: _guidePanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: AppSpacing.inputHeight,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      borderRadius: AppRadii.cardRadius,
                    ),
                    child: Icon(_strategyIcon(strategy.iconKey), color: color),
                  ),
                  const SizedBox(width: 13),
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
                                  fontSize: 16,
                                  fontWeight: AppTextStyles.bold,
                                  height: 1.38,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _DifficultyBadge(difficulty: strategy.difficulty),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strategy.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
    final color = switch (difficulty) {
      'Beginner' => _guideGreen,
      'Intermediate' => _guideAmber,
      'Advanced' => _guidePurple,
      _ => _guideRed,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StrategyDetails extends StatelessWidget {
  const _StrategyDetails({required this.strategy});

  final TradeBotGuideStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepsBlock(color: color, steps: strategy.howItWorks),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _BulletsBlock(
                title: 'Pros',
                titleColor: _guideGreen,
                background: _guideGreen.withValues(alpha: .08),
                items: strategy.pros,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BulletsBlock(
                title: 'Cons',
                titleColor: _guideRed,
                background: _guideRed.withValues(alpha: .08),
                items: strategy.cons,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BestForBlock(text: strategy.bestFor),
        const SizedBox(height: 14),
        _ExampleBlock(color: color, example: strategy.example),
      ],
    );
  }
}
