import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';

class UnifiedSearchPage extends ConsumerStatefulWidget {
  const UnifiedSearchPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc283_unified_search_content');
  static const searchKey = Key('sc283_unified_search_field');
  static const offlineKey = Key('sc283_unified_search_offline');
  static const trendingKey = Key('sc283_unified_search_trending');
  static const emptyKey = Key('sc283_unified_search_empty');
  static const disclosureKey = Key('sc283_unified_search_disclosure');

  static Key moduleKey(String id) => Key('sc283_module_$id');
  static Key trendingQueryKey(String label) => Key('sc283_trending_$label');
  static Key resultKey(String kind, String id) =>
      Key('sc283_result_${kind}_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<UnifiedSearchPage> createState() => _UnifiedSearchPageState();
}

class _UnifiedSearchPageState extends ConsumerState<UnifiedSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(discoveryRepositoryProvider)
        .getUnifiedSearch(query: _searchController.text);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-283 UnifiedSearchPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            _SearchBand(
              controller: _searchController,
              hint: snapshot.searchHint,
              onChanged: () => setState(() {}),
            ),
            Padding(
              key: UnifiedSearchPage.offlineKey,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x4,
                AppSpacing.contentPad,
                AppSpacing.x2,
              ),
              child: VitOfflineBanner(
                message: snapshot.staleMessage,
                detail: snapshot.staleDetail,
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: UnifiedSearchPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x2,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: snapshot.hasQuery
                      ? _ResultsState(snapshot: snapshot)
                      : _NoQueryState(
                          snapshot: snapshot,
                          onQuerySelected: (value) => setState(() {
                            _searchController.text = value;
                          }),
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

class _SearchBand extends StatelessWidget {
  const _SearchBand({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.contentPad,
          AppSpacing.x4,
          AppSpacing.contentPad,
          AppSpacing.x4,
        ),
        child: VitSearchBar(
          key: UnifiedSearchPage.searchKey,
          controller: controller,
          placeholder: hint,
          autofocus: true,
          variant: VitSearchBarVariant.defaultSearch,
          onChanged: (_) => onChanged(),
        ),
      ),
    );
  }
}

class _NoQueryState extends StatelessWidget {
  const _NoQueryState({required this.snapshot, required this.onQuerySelected});

  final UnifiedSearchSnapshot snapshot;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          icon: Icons.trending_up_rounded,
          iconColor: AppModuleAccents.predictions,
          label: 'Trending',
        ),
        const SizedBox(height: AppSpacing.x3),
        Wrap(
          key: UnifiedSearchPage.trendingKey,
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final query in snapshot.trendingQueries)
              _TrendingChip(
                query: query,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onQuerySelected(query.label);
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Khám phá theo module',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final module in snapshot.modules) ...[
          _ModuleCard(module: module),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TrendingChip extends StatelessWidget {
  const _TrendingChip({required this.query, required this.onTap});

  final DiscoveryTrendingQueryDraft query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: UnifiedSearchPage.trendingQueryKey(query.label),
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: AppSpacing.buttonCompact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.borderSolid),
          borderRadius: AppRadii.lgRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForKey(query.iconKey),
              color: _accentForKey(query.iconKey),
              size: 13,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              query.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final DiscoveryModuleDraft module;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForModule(module.kind);
    return VitCard(
      key: UnifiedSearchPage.moduleKey(module.id),
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(module.route);
      },
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: accent.withValues(alpha: .12),
      child: Row(
        children: [
          _AccentIcon(icon: _iconForKey(module.iconKey), color: accent),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  module.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.text3,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ResultsState extends StatelessWidget {
  const _ResultsState({required this.snapshot});

  final UnifiedSearchSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final results = snapshot.results;
    if (results.isEmpty) {
      return VitEmptyState(
        key: UnifiedSearchPage.emptyKey,
        icon: Icons.search_rounded,
        title: 'Không tìm thấy kết quả',
        message:
            'Không có kết quả cho "${snapshot.query}". Thử từ khóa khác hoặc xem gợi ý.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: 'Tìm thấy ',
            children: [
              TextSpan(
                text: '${results.totalCount}',
                style: const TextStyle(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              TextSpan(text: ' kết quả cho "${snapshot.query}"'),
            ],
          ),
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (results.predictions.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.track_changes_rounded,
            label: 'Prediction Events',
            count: results.predictions.length,
            color: AppModuleAccents.predictions,
            children: [
              for (final event in results.predictions)
                _PredictionResultCard(event: event),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.arenaModes.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.bolt_rounded,
            label: 'Arena Modes',
            count: results.arenaModes.length,
            color: AppModuleAccents.arena,
            children: [
              for (final mode in results.arenaModes)
                _ArenaModeResultCard(mode: mode),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.arenaRooms.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.groups_rounded,
            label: 'Arena Rooms',
            count: results.arenaRooms.length,
            color: AppModuleAccents.arena,
            children: [
              for (final room in results.arenaRooms)
                _ArenaRoomResultCard(room: room),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.creators.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.person_rounded,
            label: 'Creators',
            count: results.creators.length,
            color: AppColors.buy,
            children: [
              for (final creator in results.creators)
                _CreatorResultCard(creator: creator),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (results.tradingPairs.isNotEmpty) ...[
          _ResultSection(
            icon: Icons.bar_chart_rounded,
            label: 'Trading Pairs',
            count: results.tradingPairs.length,
            color: AppModuleAccents.markets,
            children: [
              for (final pair in results.tradingPairs)
                _TradingPairResultCard(pair: pair),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        _BoundaryDisclosure(notes: snapshot.contractNotes),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.children,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.buttonCompact,
              height: AppSpacing.buttonCompact,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            _CountBadge(count: count),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ...children.expand(
          (child) => [child, const SizedBox(height: AppSpacing.x3)],
        ),
      ],
    );
  }
}

class _PredictionResultCard extends StatelessWidget {
  const _PredictionResultCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('prediction', event.id),
      onTap: () => context.go(event.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.predictions.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ModuleBadge(
            label: 'Prediction Market',
            icon: Icons.track_changes_rounded,
            color: AppModuleAccents.predictions,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            event.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                '${event.topOutcome} ${event.chance}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                'Vol ${event.volumeLabel}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const Spacer(),
              _InlineCta(
                label: 'Xem thị trường',
                color: AppModuleAccents.predictions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaModeResultCard extends StatelessWidget {
  const _ArenaModeResultCard({required this.mode});

  final DiscoveryArenaModeDraft mode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaMode', mode.id),
      onTap: () => context.go(mode.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.arena.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ModuleBadge(
                label: 'Open Arena',
                icon: Icons.bolt_rounded,
                color: AppModuleAccents.arena,
              ),
              if (mode.fairPlay) ...[
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Fair Play',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            mode.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            mode.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${mode.activeChallenges} challenges · ${mode.cloneCount} clones',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const _InlineCta(
                label: 'Xem mode',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaRoomResultCard extends StatelessWidget {
  const _ArenaRoomResultCard({required this.room});

  final DiscoveryArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('arenaRoom', room.id),
      onTap: () => context.go(room.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.arena.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ModuleBadge(
                label: 'Arena Points only',
                icon: Icons.stars_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                room.format,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            room.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                '${room.entryPoints} pts entry',
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                '${room.slotsFilled}/${room.slotsTotal} slots (${room.fillPercent}%)',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                room.creatorName,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              const _InlineCta(
                label: 'Xem room',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorResultCard extends StatelessWidget {
  const _CreatorResultCard({required this.creator});

  final DiscoveryCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.resultKey('creator', creator.id),
      onTap: () => context.go(creator.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _InitialsAvatar(initials: creator.initials),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        creator.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.shield_rounded,
                        color: AppColors.buy,
                        size: 13,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Trust ${creator.trustScore}% · ${creator.modesCreated} modes',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const _InlineCta(label: 'Xem creator', color: AppColors.text2),
        ],
      ),
    );
  }
}

class _TradingPairResultCard extends StatelessWidget {
  const _TradingPairResultCard({required this.pair});

  final DiscoveryTradingPairDraft pair;

  @override
  Widget build(BuildContext context) {
    final changeColor = pair.change24h >= 0 ? AppColors.buy : AppColors.sell;
    final sign = pair.change24h >= 0 ? '+' : '';

    return VitCard(
      key: UnifiedSearchPage.resultKey('pair', pair.id),
      onTap: () => context.go(pair.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppModuleAccents.markets.withValues(alpha: .14),
      child: Row(
        children: [
          const _ModuleBadge(
            label: 'Spot Trading',
            icon: Icons.bar_chart_rounded,
            color: AppModuleAccents.markets,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${pair.baseAsset}/${pair.quoteAsset}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pair.priceLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$sign${pair.change24h.toStringAsFixed(2)}%',
                style: AppTextStyles.micro.copyWith(
                  color: changeColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoundaryDisclosure extends StatelessWidget {
  const _BoundaryDisclosure({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật. Arena Challenges chỉ dùng Arena Points (không liên quan ví). Đây là trang khám phá, không phải trang giao dịch.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 15),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

class _ModuleBadge extends StatelessWidget {
  const _ModuleBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '$count',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _InlineCta extends StatelessWidget {
  const _InlineCta({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Icon(Icons.arrow_forward_rounded, color: color, size: 11),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.ctaHeight,
      height: AppSpacing.ctaHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppModuleAccents.arena.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        initials,
        style: AppTextStyles.body.copyWith(
          color: AppModuleAccents.arena,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

IconData _iconForKey(String key) {
  return switch (key) {
    'coin' => Icons.currency_exchange_rounded,
    'price' => Icons.swap_vert_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'fire' => Icons.local_fire_department_rounded,
    'news' => Icons.article_rounded,
    'prediction' => Icons.track_changes_rounded,
    'topic' => Icons.auto_awesome_rounded,
    _ => Icons.search_rounded,
  };
}

Color _accentForKey(String key) {
  return switch (key) {
    'bank' || 'topic' => AppColors.buy,
    'arena' || 'fire' => AppModuleAccents.arena,
    'prediction' || 'coin' || 'price' => AppModuleAccents.predictions,
    'news' => AppColors.text2,
    _ => AppColors.primary,
  };
}

Color _accentForModule(DiscoveryModuleKind kind) {
  return switch (kind) {
    DiscoveryModuleKind.prediction => AppModuleAccents.predictions,
    DiscoveryModuleKind.arena => AppModuleAccents.arena,
    DiscoveryModuleKind.topic => AppColors.buy,
  };
}
