import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _guideBackground = AppColors.bg;
const _guidePanel = AppColors.surface;
const _guidePanel2 = AppColors.surface2;
const _guidePrimary = AppColors.primary;
const _guideGreen = Color(0xFF10B981);
const _guideAmber = Color(0xFFF59E0B);
const _guidePurple = Color(0xFF8B5CF6);
const _guideRed = Color(0xFFEF4444);

class BotGuidePage extends ConsumerStatefulWidget {
  const BotGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc131_bot_guide_content');
  static Key tabKey(String id) => Key('sc131_bot_guide_tab_$id');
  static Key strategyKey(String id) => Key('sc131_bot_guide_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotGuidePage> createState() => _BotGuidePageState();
}

class _BotGuidePageState extends ConsumerState<BotGuidePage> {
  String _view = 'strategies';
  String? _expandedStrategyId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotGuide();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-131 BotGuidePage',
      child: Material(
        color: _guideBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Trading Bots Guide',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotGuidePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _IntroBanner(),
                    const SizedBox(height: 28),
                    _Tabs(active: _view, onChanged: _setView),
                    const SizedBox(height: 17),
                    if (_view == 'strategies')
                      _StrategiesView(
                        strategies: snapshot.strategies,
                        expandedStrategyId: _expandedStrategyId,
                        onToggle: _toggleStrategy,
                      )
                    else if (_view == 'best-practices')
                      _BestPracticesView(items: snapshot.bestPractices)
                    else
                      _MistakesView(items: snapshot.mistakes),
                    const SizedBox(height: 16),
                    const _VideoTutorialsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setView(String view) {
    setState(() {
      _view = view;
      _expandedStrategyId = null;
    });
  }

  void _toggleStrategy(String strategyId) {
    setState(() {
      _expandedStrategyId = _expandedStrategyId == strategyId
          ? null
          : strategyId;
    });
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _guidePrimary.withValues(alpha: .08),
        border: Border.all(
          color: _guidePrimary.withValues(alpha: .35),
          width: 1,
        ),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_outlined, color: _guidePrimary, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Guide to Trading Bots',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontSize: 17,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Learn how each bot strategy works, when to use it, and '
                  'how to avoid common mistakes. Perfect for beginners and '
                  'experienced traders.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('strategies', 93.0),
      ('best-practices', 116.0),
      ('mistakes', 86.0),
    ];
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          GestureDetector(
            key: BotGuidePage.tabKey(tabs[i].$1),
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(tabs[i].$1),
            child: Container(
              width: tabs[i].$2,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active == tabs[i].$1
                    ? _guidePrimary.withValues(alpha: .13)
                    : _guidePanel2,
                border: Border.all(
                  color: active == tabs[i].$1
                      ? _guidePrimary.withValues(alpha: .42)
                      : Colors.transparent,
                ),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                tabs[i].$1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: active == tabs[i].$1 ? _guidePrimary : AppColors.text3,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          if (i != tabs.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

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

class _StepsBlock extends StatelessWidget {
  const _StepsBlock({required this.color, required this.steps});

  final Color color;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '${i + 1}.',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  steps[i],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (i != steps.length - 1) const SizedBox(height: 7),
        ],
      ],
    );
  }
}

class _BulletsBlock extends StatelessWidget {
  const _BulletsBlock({
    required this.title,
    required this.titleColor,
    required this.background,
    required this.items,
  });

  final String title;
  final Color titleColor;
  final Color background;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: titleColor,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: titleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _BestForBlock extends StatelessWidget {
  const _BestForBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _guidePanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BEST FOR:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  const _ExampleBlock({required this.color, required this.example});

  final Color color;
  final TradeBotGuideExample example;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Setup:', example.setup, AppColors.text1),
      ('Duration:', example.duration, AppColors.text1),
      ('Result:', example.result, AppColors.text1),
      ('Profit:', example.profit, _guideGreen),
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .30)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Example',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            if (i == 3)
              const Divider(height: 13, thickness: 1, color: AppColors.divider),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 62,
                  child: Text(
                    rows[i].$1,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: rows[i].$3,
                      fontSize: i == 3 ? 13 : 11,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'Roboto',
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i != rows.length - 1 && i != 2) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _BestPracticesView extends StatelessWidget {
  const _BestPracticesView({required this.items});

  final List<TradeBotGuidePractice> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Best Practices'),
        const SizedBox(height: 10),
        for (final item in items) ...[
          _InfoCard(
            icon: _practiceIcon(item.iconKey),
            iconColor: _guidePrimary,
            title: item.title,
            description: item.description,
          ),
          if (item != items.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MistakesView extends StatelessWidget {
  const _MistakesView({required this.items});

  final List<TradeBotGuideMistake> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Common Mistakes to Avoid'),
        const SizedBox(height: 10),
        for (final item in items) ...[
          _MistakeCard(item: item),
          if (item != items.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.item});

  final TradeBotGuideMistake item;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cancel_outlined, color: _guideRed, size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.mistake,
                  style: AppTextStyles.caption.copyWith(
                    color: _guideRed,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "WHY IT'S BAD:",
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.why,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: _guideGreen.withValues(alpha: .08),
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOW TO FIX:',
                        style: AppTextStyles.micro.copyWith(
                          color: _guideGreen,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.fix,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoTutorialsCard extends StatelessWidget {
  const _VideoTutorialsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
      decoration: BoxDecoration(
        color: _guidePanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_outlined,
                color: _guidePrimary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Video Tutorials',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Watch our step-by-step video guides to master each bot strategy.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _guidePrimary,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Text(
              'View All Tutorials',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
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
