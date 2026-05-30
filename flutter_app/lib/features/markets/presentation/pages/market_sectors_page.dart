import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

const _marketPrimary = AppColors.primary;
const _sectorPurple = AppColors.accent;

class MarketSectorsPage extends ConsumerStatefulWidget {
  const MarketSectorsPage({
    super.key,
    this.shellRenderMode,
    this.selectedSectorId,
  });

  static const contentKey = Key('sc011_market_sectors_scroll_content');
  static const detailContentKey = Key('sc011_market_sector_detail_content');
  static const timeframe24hKey = Key('sc011_timeframe_24h');
  static const timeframe7dKey = Key('sc011_timeframe_7d');
  static const timeframe30dKey = Key('sc011_timeframe_30d');
  static const sortPerformanceKey = Key('sc011_sort_performance');
  static const sortMarketCapKey = Key('sc011_sort_market_cap');
  static const sortCoinCountKey = Key('sc011_sort_coin_count');
  static const comparisonKey = Key('sc011_sector_comparison');

  static Key sectorKey(String id) => Key('sc011_sector_$id');

  final ShellRenderMode? shellRenderMode;
  final String? selectedSectorId;

  @override
  ConsumerState<MarketSectorsPage> createState() => _MarketSectorsPageState();
}

class _MarketSectorsPageState extends ConsumerState<MarketSectorsPage> {
  String _timeframe = '24h';
  String _sort = 'performance';

  List<MarketSector> _visibleSectors(MarketSectorsSnapshot snapshot) {
    final sorted = snapshot.sectors.toList();
    switch (_sort) {
      case 'market_cap':
        sorted.sort((a, b) => b.totalMarketCap.compareTo(a.totalMarketCap));
      case 'coin_count':
        sorted.sort((a, b) => b.coinCount.compareTo(a.coinCount));
      case 'performance':
      default:
        sorted.sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
    }
    return sorted;
  }

  double _changeFor(MarketSector sector) {
    return switch (_timeframe) {
      '7d' => sector.change7d,
      '30d' => sector.change30d,
      _ => sector.change24h,
    };
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketControllerProvider).getMarketSectors();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 52 : 22);
    final selectedSector = _findSector(
      snapshot.sectors,
      widget.selectedSectorId,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: selectedSector == null
          ? 'SC-011 MarketSectorsPage'
          : 'SC-011 MarketSectorDetail',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: selectedSector?.nameVi ?? 'Ngành thị trường',
              showBack: true,
              onBack: () {
                if (selectedSector != null) {
                  context.go(AppRoutePaths.marketsSectors);
                  return;
                }
                context.go(AppRoutePaths.markets);
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: selectedSector == null
                      ? MarketSectorsPage.contentKey
                      : MarketSectorsPage.detailContentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    gap: VitContentGap.defaultGap,
                    children: selectedSector == null
                        ? [
                            _SectorDistributionCard(sectors: snapshot.sectors),
                            _SectorControls(
                              timeframes: snapshot.timeframes,
                              activeTimeframe: _timeframe,
                              sortOptions: snapshot.screenFilters.sortOptions,
                              activeSort: _sort,
                              onTimeframeSelected: (value) {
                                setState(() => _timeframe = value);
                              },
                              onSortSelected: (value) {
                                setState(() => _sort = value);
                              },
                            ),
                            for (final sector in _visibleSectors(snapshot))
                              _SectorCard(
                                sector: sector,
                                change: _changeFor(sector),
                                onTap: () => context.go(
                                  '${AppRoutePaths.marketsSectors}?id=${sector.id}',
                                ),
                              ),
                            _SectorComparisonTable(
                              key: MarketSectorsPage.comparisonKey,
                              sectors: _visibleSectors(snapshot),
                            ),
                            _DataRefreshFooter(
                              count: snapshot.sectors.length,
                              label: snapshot.lastUpdatedLabel,
                            ),
                          ]
                        : [
                            _SectorDetailSummary(sector: selectedSector),
                            _TopCoinsSection(
                              sector: selectedSector,
                              coins: _coinsFor(selectedSector, snapshot),
                              onTap: (coin) =>
                                  context.go('/pair/${coin.id}usdt'),
                            ),
                            _SectorComparisonTable(
                              sectors: _visibleSectors(snapshot),
                              highlightedSectorId: selectedSector.id,
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

class _SectorDistributionCard extends StatelessWidget {
  const _SectorDistributionCard({required this.sectors});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final total = sectors.fold<double>(
      0,
      (sum, sector) => sum + sector.totalMarketCap,
    );
    final visible = sectors
        .where((sector) => _allocation(sector, total) >= 1)
        .toList();

    return VitCard(
      height: 132,
      padding: const EdgeInsets.all(16),
      borderColor: _sectorPurple.withValues(alpha: 0.20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _sectorPurple.withValues(alpha: 0.16),
                  borderRadius: AppRadii.smRadius,
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: _sectorPurple,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Phân bổ vốn hóa theo ngành',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 12,
              color: AppColors.surface3,
              child: Row(
                children: [
                  for (final sector in visible)
                    Expanded(
                      flex: math.max(
                        1,
                        (_allocation(sector, total) * 10).round(),
                      ),
                      child: Container(color: sector.color),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final sector in visible)
                  _LegendItem(
                    color: sector.color,
                    label:
                        '${sector.nameVi} ${_allocation(sector, total).toStringAsFixed(1)}%',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _allocation(MarketSector sector, double total) {
    if (total <= 0) return 0;
    return sector.totalMarketCap / total * 100;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _SectorControls extends StatelessWidget {
  const _SectorControls({
    required this.timeframes,
    required this.activeTimeframe,
    required this.sortOptions,
    required this.activeSort,
    required this.onTimeframeSelected,
    required this.onSortSelected,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final List<MarketSortOption> sortOptions;
  final String activeSort;
  final ValueChanged<String> onTimeframeSelected;
  final ValueChanged<String> onSortSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            for (final timeframe in timeframes) ...[
              _ChipButton(
                key: _timeframeKey(timeframe),
                label: timeframe,
                active: timeframe == activeTimeframe,
                onTap: () => onTimeframeSelected(timeframe),
              ),
              if (timeframe != timeframes.last) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              reverse: true,
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: sortOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final option = sortOptions[sortOptions.length - 1 - index];
                return _ChipButton(
                  key: _sortKey(option.id),
                  label: option.label,
                  active: option.id == activeSort,
                  onTap: () => onSortSelected(option.id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Key _timeframeKey(String value) {
    return switch (value) {
      '7d' => MarketSectorsPage.timeframe7dKey,
      '30d' => MarketSectorsPage.timeframe30dKey,
      _ => MarketSectorsPage.timeframe24hKey,
    };
  }

  Key _sortKey(String id) {
    return switch (id) {
      'market_cap' => MarketSectorsPage.sortMarketCapKey,
      'coin_count' => MarketSectorsPage.sortCoinCountKey,
      _ => MarketSectorsPage.sortPerformanceKey,
    };
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
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
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: 0.16)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: 0.38)
                : AppColors.borderSolid,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? _marketPrimary : AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SectorCard extends StatelessWidget {
  const _SectorCard({
    required this.sector,
    required this.change,
    required this.onTap,
  });

  final MarketSector sector;
  final double change;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarketSectorsPage.sectorKey(sector.id),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: sector.color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(sector.icon, color: sector.color, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.nameVi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sector.coinCount} coins',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              _ChangePill(value: change),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SectorMetric(
                  label: 'Vốn hóa',
                  value: _formatBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SectorMetric(
                  label: 'KL 24h',
                  value: _formatBillions(sector.volume24h),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DominanceBar(sector: sector),
          const SizedBox(height: 12),
          _TopCoinChips(symbols: sector.topCoins),
        ],
      ),
    );
  }
}

class _SectorMetric extends StatelessWidget {
  const _SectorMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.right : TextAlign.left,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _DominanceBar extends StatelessWidget {
  const _DominanceBar({required this.sector});

  final MarketSector sector;

  @override
  Widget build(BuildContext context) {
    final widthFactor = math.min(1.0, sector.dominance * 3 / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: widthFactor,
                  child: ColoredBox(color: sector.color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${_formatDominance(sector.dominance)}% dominance',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TopCoinChips extends StatelessWidget {
  const _TopCoinChips({required this.symbols});

  final List<String> symbols;

  @override
  Widget build(BuildContext context) {
    final visible = symbols.take(4).toList();
    final remaining = math.max(0, symbols.length - visible.length);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final symbol in visible) _CoinChip(label: symbol),
        if (remaining > 0) _CoinChip(label: '+$remaining'),
      ],
    );
  }
}

class _CoinChip extends StatelessWidget {
  const _CoinChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            _formatPercent(value),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorComparisonTable extends StatelessWidget {
  const _SectorComparisonTable({
    super.key,
    required this.sectors,
    this.highlightedSectorId,
  });

  final List<MarketSector> sectors;
  final String? highlightedSectorId;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'So sánh nhanh',
      accentColor: _marketPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              const _ComparisonHeader(),
              const SizedBox(height: 10),
              for (final sector in sectors) ...[
                _ComparisonRow(
                  sector: sector,
                  highlighted: sector.id == highlightedSectorId,
                ),
                if (sector != sectors.last) const _TableDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  const _ComparisonHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ngành',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        for (final label in const ['24h', '7d', '30d'])
          SizedBox(
            width: 54,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.sector, required this.highlighted});

  final MarketSector sector;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: highlighted
            ? sector.color.withValues(alpha: 0.10)
            : AppColors.transparent,
        borderRadius: AppRadii.smRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: sector.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sector.nameVi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: highlighted
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _PercentCell(value: sector.change24h),
          _PercentCell(value: sector.change7d),
          _PercentCell(value: sector.change30d),
        ],
      ),
    );
  }
}

class _PercentCell extends StatelessWidget {
  const _PercentCell({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return SizedBox(
      width: 54,
      child: Text(
        _formatPercent(value),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _TableDivider extends StatelessWidget {
  const _TableDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.divider);
  }
}

class _DataRefreshFooter extends StatelessWidget {
  const _DataRefreshFooter({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        '$count ngành · $label',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SectorDetailSummary extends StatelessWidget {
  const _SectorDetailSummary({required this.sector});

  final MarketSector sector;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      borderColor: sector.color.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: sector.color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(sector.icon, color: sector.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.nameVi,
                      style: AppTextStyles.baseMedium.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sector.coinCount} coins · ${_formatDominance(sector.dominance)}% dominance',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              _ChangePill(value: sector.change24h),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _DetailMetric(
                  label: 'Vốn hóa',
                  value: _formatBillions(sector.totalMarketCap),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailMetric(
                  label: 'KL 24h',
                  value: _formatBillions(sector.volume24h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DominanceBar(sector: sector),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCoinsSection extends StatelessWidget {
  const _TopCoinsSection({
    required this.sector,
    required this.coins,
    required this.onTap,
  });

  final MarketSector sector;
  final List<_SectorCoin> coins;
  final ValueChanged<_SectorCoin> onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Coin nổi bật',
      accentColor: sector.color,
      children: [
        VitCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              for (final coin in coins) ...[
                _TopCoinRow(coin: coin, onTap: () => onTap(coin)),
                if (coin != coins.last) const _TableDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TopCoinRow extends StatelessWidget {
  const _TopCoinRow({required this.coin, required this.onTap});

  final _SectorCoin coin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: coin.color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Text(
                coin.symbol.characters.first,
                style: AppTextStyles.micro.copyWith(
                  color: coin.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              coin.priceLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: 10),
            _ChangePill(value: coin.change24h),
          ],
        ),
      ),
    );
  }
}

final class _SectorCoin {
  const _SectorCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceLabel,
    required this.change24h,
    required this.color,
  });

  final String id;
  final String symbol;
  final String name;
  final String priceLabel;
  final double change24h;
  final Color color;
}

MarketSector? _findSector(List<MarketSector> sectors, String? id) {
  if (id == null || id.isEmpty) return null;
  for (final sector in sectors) {
    if (sector.id == id) return sector;
  }
  return null;
}

List<_SectorCoin> _coinsFor(
  MarketSector sector,
  MarketSectorsSnapshot snapshot,
) {
  return [
    for (final symbol in sector.topCoins)
      _coinForSymbol(symbol, sector, snapshot),
  ];
}

_SectorCoin _coinForSymbol(
  String symbol,
  MarketSector sector,
  MarketSectorsSnapshot snapshot,
) {
  for (final pair in snapshot.marketPairs) {
    if (pair.baseAsset == symbol) {
      return _SectorCoin(
        id: pair.baseAsset.toLowerCase(),
        symbol: symbol,
        name: pair.baseAsset,
        priceLabel: _formatPrice(pair.price),
        change24h: pair.change24h,
        color: pair.logoColor,
      );
    }
  }

  return _SectorCoin(
    id: symbol.toLowerCase(),
    symbol: symbol,
    name: sector.name,
    priceLabel: '--',
    change24h: sector.change24h,
    color: sector.color,
  );
}

String _formatBillions(double value) {
  final billions = value / 1000000000;
  return '\$${_formatNumber(billions, 2)}B';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatDominance(double value) {
  return value < 1 ? value.toStringAsFixed(2) : value.toStringAsFixed(1);
}

String _formatPrice(double value) {
  if (value <= 0) return '--';
  if (value >= 1000) return '\$${_formatNumber(value, 2)}';
  if (value < 1) return '\$${value.toStringAsFixed(4)}';
  return '\$${value.toStringAsFixed(2)}';
}

String _formatNumber(double value, int fractionDigits) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length == 1 || fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
