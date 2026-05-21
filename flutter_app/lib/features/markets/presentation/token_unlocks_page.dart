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
import '../data/market_repository.dart';

const _marketBlue = Color(0xFF3B82F6);

class TokenUnlocksPage extends ConsumerStatefulWidget {
  const TokenUnlocksPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc024_token_unlocks_scroll_content');
  static const upcomingTabKey = Key('sc024_tab_upcoming');
  static const analysisTabKey = Key('sc024_tab_analysis');
  static const scheduleTabKey = Key('sc024_tab_schedule');
  static const sortValueKey = Key('sc024_sort_value');
  static const impactHighKey = Key('sc024_impact_high');

  static Key unlockCardKey(String id) => Key('sc024_unlock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TokenUnlocksPage> createState() => _TokenUnlocksPageState();
}

class _TokenUnlocksPageState extends ConsumerState<TokenUnlocksPage> {
  String _tab = 'upcoming';
  MarketUnlockSort _sortBy = MarketUnlockSort.nearest;
  MarketUnlockImpact? _impactFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(marketRepositoryProvider);
    final snapshot = repo.getTokenUnlocks(
      sortBy: _sortBy,
      impactFilter: _impactFilter,
    );
    final allSnapshot = repo.getTokenUnlocks();
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
      semanticLabel: 'SC-024 TokenUnlocksPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Token Unlock',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _UnlockTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: TokenUnlocksPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 12,
                    children: [
                      if (_tab == 'upcoming') ...[
                        _UnlockHero(snapshot: allSnapshot),
                        _UnlockFilters(
                          sortBy: _sortBy,
                          impactFilter: _impactFilter,
                          impactConfigs: snapshot.impactConfigs,
                          onSortSelected: (value) =>
                              setState(() => _sortBy = value),
                          onImpactSelected: (value) => setState(() {
                            _impactFilter = _impactFilter == value
                                ? null
                                : value;
                          }),
                          onAllImpacts: () => setState(() {
                            _impactFilter = null;
                          }),
                        ),
                        if (snapshot.unlocks.isEmpty)
                          const _UnlockEmptyState()
                        else
                          _UnlockList(
                            unlocks: snapshot.unlocks,
                            impactConfigs: snapshot.impactConfigs,
                            categoryConfigs: snapshot.categoryConfigs,
                            expandedId: _expandedId,
                            onToggleExpanded: (unlock) => setState(() {
                              _expandedId = _expandedId == unlock.id
                                  ? null
                                  : unlock.id;
                            }),
                          ),
                      ] else if (_tab == 'analysis') ...[
                        _ImpactOverview(snapshot: allSnapshot),
                        const _SectionHeader(
                          label: 'Theo loại',
                          accentColor: AppColors.accent,
                        ),
                        _CategoryBreakdown(snapshot: allSnapshot),
                        const _SectionHeader(
                          label: 'Rủi ro pha loãng cao nhất',
                          accentColor: AppColors.sell,
                        ),
                        _DilutionRanking(snapshot: allSnapshot),
                        const _UnlockWarningCard(),
                      ] else ...[
                        _ScheduleList(snapshot: allSnapshot),
                      ],
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

class _UnlockTabs extends StatelessWidget {
  const _UnlockTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: TokenUnlocksPage.upcomingTabKey,
              label: 'Sắp mở khóa',
              value: 'upcoming',
              active: activeTab == 'upcoming',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: TokenUnlocksPage.analysisTabKey,
              label: 'Phân tích',
              value: 'analysis',
              active: activeTab == 'analysis',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: TokenUnlocksPage.scheduleTabKey,
              label: 'Lịch trình',
              value: 'schedule',
              active: activeTab == 'schedule',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketBlue : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnlockHero extends StatelessWidget {
  const _UnlockHero({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1635),
        border: Border.all(color: _marketBlue.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng giá trị mở khóa sắp tới',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatCompactUsd(snapshot.totalValueNext30d),
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.text1,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                '${snapshot.highImpactCount} tác động cao',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              const SizedBox(width: 18),
              Text(
                'TB dilution: ${snapshot.avgDilution.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockFilters extends StatelessWidget {
  const _UnlockFilters({
    required this.sortBy,
    required this.impactFilter,
    required this.impactConfigs,
    required this.onSortSelected,
    required this.onImpactSelected,
    required this.onAllImpacts,
  });

  final MarketUnlockSort sortBy;
  final MarketUnlockImpact? impactFilter;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final ValueChanged<MarketUnlockSort> onSortSelected;
  final ValueChanged<MarketUnlockImpact> onImpactSelected;
  final VoidCallback onAllImpacts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'Gần nhất',
            active: sortBy == MarketUnlockSort.nearest,
            color: _marketBlue,
            onTap: () => onSortSelected(MarketUnlockSort.nearest),
          ),
          const SizedBox(width: 4),
          _FilterChipButton(
            key: TokenUnlocksPage.sortValueKey,
            label: 'Giá trị cao',
            active: sortBy == MarketUnlockSort.value,
            color: _marketBlue,
            onTap: () => onSortSelected(MarketUnlockSort.value),
          ),
          const SizedBox(width: 4),
          _FilterChipButton(
            label: 'Tác động',
            active: sortBy == MarketUnlockSort.impact,
            color: _marketBlue,
            onTap: () => onSortSelected(MarketUnlockSort.impact),
          ),
          const SizedBox(width: 4),
          _FilterChipButton(
            label: 'Tất cả',
            active: impactFilter == null,
            color: AppColors.text3,
            onTap: onAllImpacts,
          ),
          const SizedBox(width: 4),
          for (final entry in impactConfigs.entries) ...[
            _FilterChipButton(
              key: entry.key == MarketUnlockImpact.high
                  ? TokenUnlocksPage.impactHighKey
                  : null,
              label: entry.value.label,
              active: impactFilter == entry.key,
              color: entry.value.color,
              onTap: () => onImpactSelected(entry.key),
            ),
            if (entry.key != impactConfigs.keys.last) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: color == AppColors.text3 ? .06 : .12)
              : AppColors.surface2,
          border: Border.all(
            color: active ? color.withValues(alpha: .26) : Colors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? color : AppColors.text3,
            fontSize: 9,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _UnlockList extends StatelessWidget {
  const _UnlockList({
    required this.unlocks,
    required this.impactConfigs,
    required this.categoryConfigs,
    required this.expandedId,
    required this.onToggleExpanded,
  });

  final List<TokenUnlockDraft> unlocks;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final Map<MarketUnlockCategory, UnlockCategoryConfig> categoryConfigs;
  final String? expandedId;
  final ValueChanged<TokenUnlockDraft> onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _UnlockCard(
            key: TokenUnlocksPage.unlockCardKey(unlock.id),
            unlock: unlock,
            impactConfig: impactConfigs[unlock.impactLevel]!,
            categoryConfig: categoryConfigs[unlock.category]!,
            expanded: expandedId == unlock.id,
            onToggle: () => onToggleExpanded(unlock),
          ),
          if (unlock != unlocks.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _UnlockCard extends StatelessWidget {
  const _UnlockCard({
    super.key,
    required this.unlock,
    required this.impactConfig,
    required this.categoryConfig,
    required this.expanded,
    required this.onToggle,
  });

  final TokenUnlockDraft unlock;
  final UnlockImpactConfig impactConfig;
  final UnlockCategoryConfig categoryConfig;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: unlock.impactLevel == MarketUnlockImpact.high
          ? AppColors.sell.withValues(alpha: .16)
          : null,
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  _TokenAvatar(unlock: unlock, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              unlock.symbol,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _TinyBadge(
                              label: impactConfig.label,
                              color: impactConfig.color,
                              bold: true,
                            ),
                            _TinyBadge(
                              label: categoryConfig.label,
                              color: categoryConfig.color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 12,
                              color: AppColors.text3,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                unlock.unlockDateLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _countdownLabel(unlock),
                              style: AppTextStyles.micro.copyWith(
                                color: _countdownColor(unlock.daysUntil),
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCompactUsd(unlock.unlockValueUsd),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${unlock.unlockPctCirculating.toStringAsFixed(1)}% supply',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _UnlockExpandedDetails(
              unlock: unlock,
              categoryConfig: categoryConfig,
            ),
        ],
      ),
    );
  }
}

class _UnlockExpandedDetails extends StatelessWidget {
  const _UnlockExpandedDetails({
    required this.unlock,
    required this.categoryConfig,
  });

  final TokenUnlockDraft unlock;
  final UnlockCategoryConfig categoryConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Số token mở khóa',
                  value:
                      '${_formatCompactNumber(unlock.unlockAmount)} '
                      '${unlock.symbol}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailMetric(
                  label: 'Giá hiện tại',
                  value: _formatPriceUsd(unlock.currentPrice),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Tổng đang khóa',
                  value: _formatCompactUsd(unlock.totalLockedValueUsd),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailMetric(
                  label: 'Loại vesting',
                  value: _vestingTypeLabel(unlock.vestingType),
                ),
              ),
            ],
          ),
          if (unlock.priceChange7d < -3) ...[
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.sell.withValues(alpha: .06),
                borderRadius: AppRadii.smRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_down_rounded,
                      color: AppColors.sell,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Giá giảm ${_formatPct(unlock.priceChange7d)} '
                        'trong 7 ngày - có thể liên quan đến unlock sắp tới',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ImpactOverview extends StatelessWidget {
  const _ImpactOverview({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ theo tác động',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final entry in snapshot.impactConfigs.entries) ...[
                Expanded(
                  child: _ImpactStat(
                    config: entry.value,
                    count: snapshot.unlocks
                        .where((unlock) => unlock.impactLevel == entry.key)
                        .length,
                    value: snapshot.unlocks
                        .where((unlock) => unlock.impactLevel == entry.key)
                        .fold<double>(
                          0,
                          (sum, unlock) => sum + unlock.unlockValueUsd,
                        ),
                  ),
                ),
                if (entry.key != snapshot.impactConfigs.keys.last)
                  const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  const _ImpactStat({
    required this.config,
    required this.count,
    required this.value,
  });

  final UnlockImpactConfig config;
  final int count;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: .04),
        border: Border.all(color: config.color.withValues(alpha: .10)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: AppTextStyles.sectionTitle.copyWith(color: config.color),
          ),
          Text(
            config.label,
            style: AppTextStyles.micro.copyWith(
              color: config.color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCompactUsd(value),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final totals = {
      for (final category in snapshot.categoryConfigs.keys)
        category: snapshot.unlocks
            .where((unlock) => unlock.category == category)
            .fold<double>(0, (sum, unlock) => sum + unlock.unlockValueUsd),
    };
    final maxTotal = totals.values.fold<double>(
      1,
      (max, value) => value > max ? value : max,
    );

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final entry in snapshot.categoryConfigs.entries) ...[
            _CategoryBar(
              label: entry.value.label,
              color: entry.value.color,
              value: totals[entry.key] ?? 0,
              maxValue: maxTotal,
            ),
            if (entry.key != snapshot.categoryConfigs.keys.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.color,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final Color color;
  final double value;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              _formatCompactUsd(value),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: 5,
            child: LinearProgressIndicator(
              value: maxValue == 0 ? 0 : value / maxValue,
              minHeight: 5,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _DilutionRanking extends StatelessWidget {
  const _DilutionRanking({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final unlocks = [
      ...snapshot.unlocks,
    ]..sort((a, b) => b.unlockPctCirculating.compareTo(a.unlockPctCirculating));
    return Column(
      children: [
        for (var index = 0; index < unlocks.length; index += 1) ...[
          _DilutionRow(index: index, unlock: unlocks[index]),
          if (index != unlocks.length - 1) const SizedBox(height: 2),
        ],
      ],
    );
  }
}

class _DilutionRow extends StatelessWidget {
  const _DilutionRow({required this.index, required this.unlock});

  final int index;
  final TokenUnlockDraft unlock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: 10),
          _TokenAvatar(unlock: unlock, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unlock.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${unlock.daysUntil} ngày nữa',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${unlock.unlockPctCirculating.toStringAsFixed(1)}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'lưu thông',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockWarningCard extends StatelessWidget {
  const _UnlockWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn.withValues(alpha: .16),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý quan trọng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Token unlock không đồng nghĩa token sẽ bị bán. Tuy nhiên, unlock lớn thường tạo áp lực bán tiềm ẩn. Dữ liệu chỉ mang tính tham khảo.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final unlocks = [...snapshot.unlocks]
      ..sort((a, b) => a.daysUntil.compareTo(b.daysUntil));

    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _ScheduleCard(
            unlock: unlock,
            categoryConfig: snapshot.categoryConfigs[unlock.category]!,
          ),
          if (unlock != unlocks.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.unlock, required this.categoryConfig});

  final TokenUnlockDraft unlock;
  final UnlockCategoryConfig categoryConfig;

  @override
  Widget build(BuildContext context) {
    final supplyPct = unlock.circulatingSupply / unlock.totalSupply;

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TokenAvatar(unlock: unlock, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          unlock.symbol,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TinyBadge(
                          label: _shortVestingTypeLabel(unlock.vestingType),
                          color: categoryConfig.color,
                        ),
                      ],
                    ),
                    Text(
                      unlock.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPriceUsd(unlock.currentPrice),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${_formatPct(unlock.priceChange7d)} 7d',
                    style: AppTextStyles.micro.copyWith(
                      color: unlock.priceChange7d >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lưu thông / Tổng cung',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${(supplyPct * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: supplyPct,
              minHeight: 6,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(unlock.color),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Lịch mở khóa',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < unlock.vestingSchedule.length; index += 1)
            _VestingEventRow(
              event: unlock.vestingSchedule[index],
              color: unlock.color,
              isFirst: index == 0,
              isLast: index == unlock.vestingSchedule.length - 1,
            ),
        ],
      ),
    );
  }
}

class _VestingEventRow extends StatelessWidget {
  const _VestingEventRow({
    required this.event,
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  final TokenVestingEventDraft event;
  final Color color;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFirst ? color : color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                  border: isFirst
                      ? null
                      : Border.all(
                          color: color.withValues(alpha: .25),
                          width: 2,
                        ),
                ),
                child: Icon(
                  isFirst ? Icons.lock_open_rounded : Icons.lock_rounded,
                  size: isFirst ? 12 : 9,
                  color: isFirst ? AppColors.text1 : color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withValues(alpha: .12),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${event.pct.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: event.pct > 5
                              ? AppColors.sell
                              : event.pct > 2
                              ? AppColors.warn
                              : AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    event.label,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.unlock, required this.size});

  final TokenUnlockDraft unlock;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: unlock.color.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      child: Text(
        unlock.symbol.substring(0, 2),
        style: AppTextStyles.caption.copyWith(
          color: unlock.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    this.bold = false,
  });

  final String label;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 8,
          height: 1.2,
          fontWeight: bold ? AppTextStyles.bold : AppTextStyles.medium,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _UnlockEmptyState extends StatelessWidget {
  const _UnlockEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 34,
            color: AppColors.text3.withValues(alpha: .4),
          ),
          const SizedBox(height: 12),
          Text(
            'Không có unlock phù hợp',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

String _countdownLabel(TokenUnlockDraft unlock) {
  if (unlock.daysUntil == 0) return '(Hôm nay)';
  return '(${unlock.daysUntil} ngày)';
}

Color _countdownColor(int daysUntil) {
  if (daysUntil <= 3) return AppColors.sell;
  if (daysUntil <= 7) return AppColors.warn;
  return AppColors.text2;
}

String _formatCompactUsd(double value) {
  final roundedMillions = (value / 10000).round() / 100;
  final fixed = roundedMillions.toStringAsFixed(2);
  final text = fixed.endsWith('.00')
      ? fixed.substring(0, fixed.length - 3)
      : fixed;
  return '\$${text}M';
}

String _formatCompactNumber(double value) {
  if (value >= 1000000) {
    final text = (value / 1000000).toStringAsFixed(2);
    return '${_trimTrailingZeros(text)}M';
  }
  if (value >= 1000) {
    final text = (value / 1000).toStringAsFixed(2);
    return '${_trimTrailingZeros(text)}K';
  }
  return value.toStringAsFixed(0);
}

String _formatPriceUsd(double value) {
  final text = value >= 10
      ? value.toStringAsFixed(2)
      : value.toStringAsFixed(2);
  return '\$$text';
}

String _formatPct(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _trimTrailingZeros(String value) {
  return value
      .replaceFirst(RegExp(r'\.00$'), '')
      .replaceFirst(RegExp(r'0$'), '');
}

String _vestingTypeLabel(MarketUnlockVestingType type) {
  return switch (type) {
    MarketUnlockVestingType.cliff => 'Cliff (gộp)',
    MarketUnlockVestingType.linear => 'Linear (dần)',
    MarketUnlockVestingType.milestone => 'Milestone',
  };
}

String _shortVestingTypeLabel(MarketUnlockVestingType type) {
  return switch (type) {
    MarketUnlockVestingType.cliff => 'Cliff',
    MarketUnlockVestingType.linear => 'Linear',
    MarketUnlockVestingType.milestone => 'Milestone',
  };
}
