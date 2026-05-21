import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/predictions_repository.dart';

const _predictionBlue = Color(0xFF3B82F6);
const _emailPurple = Color(0xFF8B5CF6);

class PredictionsBreakingPage extends ConsumerStatefulWidget {
  const PredictionsBreakingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc029_predictions_breaking_content');
  static const allTabKey = Key('sc029_category_all');
  static const cryptoTabKey = Key('sc029_category_crypto');
  static const emailFieldKey = Key('sc029_email_field');
  static const subscribeKey = Key('sc029_subscribe');

  static Key moverKey(String id) => Key('sc029_mover_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsBreakingPage> createState() =>
      _PredictionsBreakingPageState();
}

class _PredictionsBreakingPageState
    extends ConsumerState<PredictionsBreakingPage> {
  final TextEditingController _emailController = TextEditingController();

  String? _category;
  bool _subscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getBreaking(category: _category);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-029 PredictionsBreakingPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Breaking Movers',
              subtitle: 'Biến động · Prediction',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.marketsPredictions),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsBreakingPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 14,
                    children: [
                      _MovementSummary(snapshot: snapshot),
                      _CategoryTabs(
                        categories: snapshot.categories,
                        activeCategory: _category,
                        onSelected: (value) => setState(() {
                          _category = value;
                        }),
                      ),
                      if (snapshot.movers.isEmpty)
                        const _BreakingEmptyState()
                      else
                        for (
                          var index = 0;
                          index < snapshot.movers.length;
                          index += 1
                        )
                          _MoverCard(
                            key: PredictionsBreakingPage.moverKey(
                              snapshot.movers[index].id,
                            ),
                            event: snapshot.movers[index],
                            rank: index + 1,
                            onTap: () => context.go(
                              AppRoutePaths.marketsPredictionEvent(
                                snapshot.movers[index].id,
                              ),
                            ),
                          ),
                      _EmailCta(
                        controller: _emailController,
                        subscribed: _subscribed,
                        onSubscribe: () => setState(() {
                          if (_emailController.text.contains('@')) {
                            _subscribed = true;
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementSummary extends StatelessWidget {
  const _MovementSummary({required this.snapshot});

  final PredictionBreakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.warn, size: 18),
          const SizedBox(width: 8),
          Text(
            '24h Movement',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Spacer(),
          _MovementCount(
            icon: Icons.trending_up_rounded,
            label: '${snapshot.upCount} up',
            color: AppColors.buy,
          ),
          const SizedBox(width: 12),
          _MovementCount(
            icon: Icons.trending_down_rounded,
            label: '${snapshot.downCount} down',
            color: AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _MovementCount extends StatelessWidget {
  const _MovementCount({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (id: null, label: 'All', key: PredictionsBreakingPage.allTabKey),
      for (final category in categories)
        (
          id: category,
          label: category == 'Live Crypto' ? 'Crypto' : category,
          key: category == 'Live Crypto'
              ? PredictionsBreakingPage.cryptoTabKey
              : Key('sc029_category_$category'),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _CategoryTabButton(
              key: tabs[index].key,
              label: tabs[index].label,
              active: activeCategory == tabs[index].id,
              onTap: () => onSelected(tabs[index].id),
            ),
            if (index != tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  const _CategoryTabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _predictionBlue.withValues(alpha: .14)
              : Colors.transparent,
          border: Border.all(
            color: active
                ? _predictionBlue.withValues(alpha: .36)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _predictionBlue : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    super.key,
    required this.event,
    required this.rank,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isUp = event.change24h > 0;
    final rankColor = switch (rank) {
      1 => AppColors.warn,
      2 => const Color(0xFF94A3B8),
      3 => const Color(0xFFCD7F32),
      _ => AppColors.text3,
    };
    final changeColor = isUp ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? rankColor.withValues(alpha: .12)
                  : AppColors.surface2,
              borderRadius: AppRadii.smRadius,
            ),
            child: Text(
              '$rank',
              style: AppTextStyles.caption.copyWith(
                color: rankColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Yes: ',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: '${topOutcome.chance}%',
                            style: TextStyle(
                              color: topOutcome.chance >= 50
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ChangeBadge(value: event.change24h, color: changeColor),
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(event.category),
                    _MetaIcon(
                      icon: Icons.bar_chart_rounded,
                      label: _formatVolume(event.volume24h),
                    ),
                    _MetaIcon(
                      icon: Icons.schedule_rounded,
                      label: _timeRemaining(event.endDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isUp = value > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            _formatPercent(value),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _predictionBlue.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: _predictionBlue,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: 10),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _EmailCta extends StatelessWidget {
  const _EmailCta({
    required this.controller,
    required this.subscribed,
    required this.onSubscribe,
  });

  final TextEditingController controller;
  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    if (subscribed) {
      return VitCard(
        borderColor: AppColors.buy.withValues(alpha: .24),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.buy.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.buy,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscribed!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    "You'll receive daily prediction updates",
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return VitCard(
      borderColor: _emailPurple.withValues(alpha: .24),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _emailPurple.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: _emailPurple,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get daily updates',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Top movers & trending markets in your inbox',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    border: Border.all(color: AppColors.borderSolid),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: TextField(
                    key: PredictionsBreakingPage.emailFieldKey,
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'your@email.com',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                key: PredictionsBreakingPage.subscribeKey,
                onTap: onSubscribe,
                borderRadius: AppRadii.mdRadius,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _emailPurple,
                    borderRadius: AppRadii.mdRadius,
                    boxShadow: [
                      BoxShadow(
                        color: _emailPurple.withValues(alpha: .26),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Subscribe',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakingEmptyState extends StatelessWidget {
  const _BreakingEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              color: AppColors.text3.withValues(alpha: .42),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No movers in this category',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try selecting a different category',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _timeRemaining(DateTime endDate) {
  final now = DateTime.utc(2026, 2, 27, 12);
  final diff = endDate.difference(now);
  if (diff.isNegative) return 'Ended';
  final days = diff.inDays;
  if (days > 30) return '${days ~/ 30} tháng';
  if (days > 0) return '$days ngày';
  return '${diff.inHours}h';
}
