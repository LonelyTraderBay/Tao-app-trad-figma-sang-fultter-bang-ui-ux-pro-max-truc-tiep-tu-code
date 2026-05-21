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

const _marketBlue = Color(0xFF3B82F6);

class PredictionsHomePage extends ConsumerStatefulWidget {
  const PredictionsHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc027_predictions_home_scroll_content');
  static const searchActionKey = Key('sc027_search_action');
  static const searchFieldKey = Key('sc027_search_field');
  static const trendingFilterKey = Key('sc027_filter_trending');
  static const newFilterKey = Key('sc027_filter_new');
  static const categoryAllKey = Key('sc027_category_all');
  static const categoryLiveCryptoKey = Key('sc027_category_live_crypto');
  static const myPredictionsKey = Key('sc027_my_predictions');
  static const breakingMoversKey = Key('sc027_breaking_movers');
  static const arenaBridgeKey = Key('sc027_arena_bridge');

  static Key eventCardKey(String id) => Key('sc027_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsHomePage> createState() =>
      _PredictionsHomePageState();
}

class _PredictionsHomePageState extends ConsumerState<PredictionsHomePage> {
  PredictionFilterTab _filter = PredictionFilterTab.trending;
  String? _category;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsRepositoryProvider)
        .getHome(
          filter: _filter,
          category: _category,
          searchQuery: _searchQuery,
        );
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
      semanticLabel: 'SC-027 PredictionsHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Prediction Markets',
              subtitle: 'Thị trường dự đoán',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
              trailing: SizedBox(
                key: PredictionsHomePage.searchActionKey,
                width: 36,
                height: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.searchBg,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () =>
                        context.go(AppRoutePaths.marketsPredictionsSearch),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.text1,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsHomePage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 13,
                    children: [
                      _SearchField(
                        value: _searchQuery,
                        onChanged: (value) => setState(() {
                          _searchQuery = value;
                        }),
                        onClear: () => setState(() {
                          _searchQuery = '';
                        }),
                      ),
                      _FilterTabs(
                        active: _filter,
                        onSelected: (value) => setState(() {
                          _filter = value;
                        }),
                      ),
                      _CategoryChips(
                        categories: snapshot.categories,
                        activeCategory: _category,
                        onSelected: (value) => setState(() {
                          _category = value;
                        }),
                      ),
                      if (_searchQuery.isEmpty) ...[
                        _PredictionCtaCard(
                          key: PredictionsHomePage.myPredictionsKey,
                          title: 'My Predictions',
                          subtitle:
                              '${snapshot.openPositionCount} open positions',
                          color: AppColors.accent,
                          icon: Icons.work_outline_rounded,
                          onTap: () =>
                              context.go(AppRoutePaths.profilePredictions),
                        ),
                        _BreakingMoversCard(
                          snapshot: snapshot,
                          onTap: () => context.go(
                            AppRoutePaths.marketsPredictionsBreaking,
                          ),
                        ),
                        _ArenaBridgeCard(
                          onTap: () => context.go(AppRoutePaths.arena),
                        ),
                      ],
                      if (snapshot.events.isEmpty)
                        const _PredictionsEmptyState()
                      else
                        for (final event in snapshot.events)
                          _PredictionEventCard(
                            key: PredictionsHomePage.eventCardKey(event.id),
                            event: event,
                            onTap: () => context.go(
                              AppRoutePaths.marketsPredictionEvent(event.id),
                            ),
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: PredictionsHomePage.searchFieldKey,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder, width: 1.5),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.searchPlaceholder,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value)
                ..selection = TextSelection.collapsed(offset: value.length),
              onChanged: onChanged,
              style: AppTextStyles.base.copyWith(fontSize: 15),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search events...',
                hintStyle: AppTextStyles.base.copyWith(
                  color: AppColors.searchPlaceholder,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (value.isNotEmpty)
            InkWell(
              onTap: onClear,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.text3,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.active, required this.onSelected});

  final PredictionFilterTab active;
  final ValueChanged<PredictionFilterTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _FilterTabMeta(
        PredictionFilterTab.trending,
        'Trending',
        Icons.local_fire_department_outlined,
        PredictionsHomePage.trendingFilterKey,
      ),
      _FilterTabMeta(
        PredictionFilterTab.newEvents,
        'New',
        Icons.auto_awesome_rounded,
        PredictionsHomePage.newFilterKey,
      ),
      _FilterTabMeta(
        PredictionFilterTab.popular,
        'Popular',
        Icons.group_outlined,
        const Key('sc027_filter_popular'),
      ),
      _FilterTabMeta(
        PredictionFilterTab.liquid,
        'Liquid',
        Icons.bar_chart_rounded,
        const Key('sc027_filter_liquid'),
      ),
      _FilterTabMeta(
        PredictionFilterTab.ending,
        'Ending Soon',
        Icons.schedule_rounded,
        const Key('sc027_filter_ending'),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _FilterTabButton(
              key: tabs[index].key,
              meta: tabs[index],
              active: active == tabs[index].filter,
              onTap: () => onSelected(tabs[index].filter),
            ),
            if (index != tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

final class _FilterTabMeta {
  const _FilterTabMeta(this.filter, this.label, this.icon, this.key);

  final PredictionFilterTab filter;
  final String label;
  final IconData icon;
  final Key key;
}

class _FilterTabButton extends StatelessWidget {
  const _FilterTabButton({
    super.key,
    required this.meta,
    required this.active,
    required this.onTap,
  });

  final _FilterTabMeta meta;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: active
              ? _marketBlue.withValues(alpha: .12)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketBlue.withValues(alpha: .34)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          children: [
            Icon(
              meta.icon,
              size: 12,
              color: active ? _marketBlue : AppColors.text3,
            ),
            const SizedBox(width: 6),
            Text(
              meta.label,
              style: AppTextStyles.caption.copyWith(
                color: active ? _marketBlue : AppColors.text3,
                fontSize: 12,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            key: PredictionsHomePage.categoryAllKey,
            label: 'All',
            active: activeCategory == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          for (var index = 0; index < categories.length; index += 1) ...[
            _CategoryChip(
              key: categories[index] == 'Live Crypto'
                  ? PredictionsHomePage.categoryLiveCryptoKey
                  : Key('sc027_category_${categories[index]}'),
              label: categories[index],
              active: activeCategory == categories[index],
              onTap: () => onSelected(
                activeCategory == categories[index] ? null : categories[index],
              ),
            ),
            if (index != categories.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
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
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketBlue.withValues(alpha: .12)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketBlue.withValues(alpha: .30)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _marketBlue : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _PredictionCtaCard extends StatelessWidget {
  const _PredictionCtaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: .20),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _BreakingMoversCard extends StatelessWidget {
  const _BreakingMoversCard({required this.snapshot, required this.onTap});

  final PredictionHomeSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomePage.breakingMoversKey,
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breaking movers (24h)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    for (final mover in snapshot.breakingMovers.take(2)) ...[
                      Text(
                        _formatPercent(mover.change24h),
                        style: AppTextStyles.micro.copyWith(
                          color: mover.change24h >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '& ${snapshot.breakingMovers.length - 2}+ more',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ArenaBridgeCard extends StatelessWidget {
  const _ArenaBridgeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomePage.arenaBridgeKey,
      onTap: onTap,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.warn,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Thử thách cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallBadge(
                      label: 'Arena Points only',
                      color: AppColors.warn,
                      background: AppColors.warn10,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Khám phá các room social points-only trong Open Arena',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 3),
                Text(
                  'Xem Arena',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warn,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    final isMulti = event.outcomes.length > 2;
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: [
              _SmallBadge(
                label: event.category,
                color: _marketBlue,
                background: _marketBlue.withValues(alpha: .12),
              ),
              for (final tag in event.tags)
                _SmallBadge(
                  label: tag,
                  color: AppColors.text3,
                  background: AppColors.surface2,
                ),
              if (event.isNew)
                _SmallBadge(
                  label: 'NEW',
                  color: AppColors.accent,
                  background: AppColors.accent12,
                ),
              if (event.isTrending)
                _SmallBadge(
                  label: 'HOT',
                  color: AppColors.warn,
                  background: AppColors.warn10,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          if (isMulti)
            _MultiOutcomeRow(event: event)
          else
            _BinaryOutcomeBar(outcomes: outcomes),
          const SizedBox(height: 12),
          _EventStatsRow(event: event),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _OutcomeActionButton(outcome: outcomes.first)),
              const SizedBox(width: 8),
              Expanded(child: _OutcomeActionButton(outcome: outcomes.last)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BinaryOutcomeBar extends StatelessWidget {
  const _BinaryOutcomeBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${yes.label} ${yes.chance}%',
              style: AppTextStyles.caption.copyWith(
                color: yes.color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              '${no.label} ${no.chance}%',
              style: AppTextStyles.caption.copyWith(
                color: no.color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Expanded(
                  flex: yes.chance,
                  child: ColoredBox(color: yes.color),
                ),
                Expanded(
                  flex: no.chance,
                  child: ColoredBox(color: no.color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiOutcomeRow extends StatelessWidget {
  const _MultiOutcomeRow({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final outcome in event.outcomes.take(3))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: outcome.color.withValues(alpha: .12),
              border: Border.all(color: outcome.color.withValues(alpha: .25)),
              borderRadius: AppRadii.smRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: outcome.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  outcome.label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${outcome.chance}%',
                  style: AppTextStyles.micro.copyWith(
                    color: outcome.color,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        if (event.outcomes.length > 3)
          Text(
            '+${event.outcomes.length - 3} more',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _EventStatsRow extends StatelessWidget {
  const _EventStatsRow({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final changeColor = event.change24h >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        _StatText(
          icon: Icons.bar_chart_rounded,
          label: 'Vol: ${_formatVolume(event.volume24h)}',
        ),
        const SizedBox(width: 12),
        _StatText(
          icon: Icons.group_outlined,
          label: _formatInt(event.participants),
        ),
        const SizedBox(width: 12),
        _StatText(
          icon: Icons.schedule_rounded,
          label: _timeRemaining(event.endDate),
        ),
        const Spacer(),
        Icon(
          event.change24h >= 0
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          size: 12,
          color: changeColor,
        ),
        Text(
          _formatPercent(event.change24h),
          style: AppTextStyles.micro.copyWith(
            color: changeColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.text3),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeActionButton extends StatelessWidget {
  const _OutcomeActionButton({required this.outcome});

  final PredictionOutcomeDraft outcome;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: outcome.color.withValues(alpha: .12),
        border: Border.all(color: outcome.color.withValues(alpha: .25)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        '${outcome.label} ${outcome.chance}%',
        style: AppTextStyles.caption.copyWith(
          color: outcome.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _PredictionsEmptyState extends StatelessWidget {
  const _PredictionsEmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.text3.withValues(alpha: .40),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No events found',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your filters or search terms',
              textAlign: TextAlign.center,
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

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index += 1) {
    if (index > 0 && (text.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[index]);
  }
  return buffer.toString();
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
