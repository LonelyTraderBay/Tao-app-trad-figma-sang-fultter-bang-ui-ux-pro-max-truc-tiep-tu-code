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
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class MarketCorrelationsPage extends ConsumerStatefulWidget {
  const MarketCorrelationsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc026_correlations_scroll_content');
  static const matrixTabKey = Key('sc026_tab_matrix');
  static const pairsTabKey = Key('sc026_tab_pairs');
  static const diversifyTabKey = Key('sc026_tab_diversify');
  static const timeframe7dKey = Key('sc026_timeframe_7d');
  static const timeframe30dKey = Key('sc026_timeframe_30d');
  static const timeframe90dKey = Key('sc026_timeframe_90d');
  static const sortHighKey = Key('sc026_sort_high');
  static const sortLowKey = Key('sc026_sort_low');

  static Key pairKey(String pair) => Key('sc026_pair_$pair');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketCorrelationsPage> createState() =>
      _MarketCorrelationsPageState();
}

class _MarketCorrelationsPageState
    extends ConsumerState<MarketCorrelationsPage> {
  String _tab = 'matrix';
  MarketCorrelationTimeframe _timeframe = MarketCorrelationTimeframe.d7;
  CorrelationSortOrder _sortOrder = CorrelationSortOrder.high;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(marketRepositoryProvider);
    final snapshot = repo.getMarketCorrelations(
      timeframe: _timeframe,
      sortOrder: _sortOrder,
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
      semanticLabel: 'SC-026 MarketCorrelationsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Tương quan thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            _CorrelationTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketCorrelationsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 14,
                    children: [
                      _TimeframeChips(
                        timeframe: _timeframe,
                        onSelected: (value) =>
                            setState(() => _timeframe = value),
                      ),
                      if (_tab == 'matrix') ...[
                        _MatrixCard(snapshot: snapshot),
                        const _CorrelationLegend(),
                        const _MatrixInfoCard(),
                        _QuickInsights(score: snapshot.diversificationScore),
                        _RecommendationCard(
                          recommendation:
                              snapshot.diversificationScore.recommendation,
                        ),
                      ] else if (_tab == 'pairs') ...[
                        _SortChips(
                          sortOrder: _sortOrder,
                          onSelected: (value) =>
                              setState(() => _sortOrder = value),
                        ),
                        for (
                          var index = 0;
                          index < snapshot.pairs.length;
                          index += 1
                        )
                          _PairCorrelationRow(
                            key: MarketCorrelationsPage.pairKey(
                              '${snapshot.pairs[index].assetA}-${snapshot.pairs[index].assetB}',
                            ),
                            rank: index + 1,
                            pair: snapshot.pairs[index],
                            timeframe: _timeframe,
                            maxValue: _maxCorrelation(snapshot),
                          ),
                      ] else ...[
                        _DiversificationHero(
                          score: snapshot.diversificationScore,
                        ),
                        _DiversificationMetrics(
                          score: snapshot.diversificationScore,
                        ),
                        const _SectionHeader(
                          label: 'So sánh theo thời gian',
                          accentColor: AppColors.accent,
                        ),
                        _TimeframeScoreCard(repo: repo),
                        const _CorrelationDisclaimer(),
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

  double _maxCorrelation(MarketCorrelationsSnapshot snapshot) {
    return snapshot.pairs
        .map((pair) => _correlationValueFor(pair, _timeframe))
        .reduce((a, b) => a > b ? a : b);
  }
}

class _CorrelationTabs extends StatelessWidget {
  const _CorrelationTabs({required this.activeTab, required this.onChanged});

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
              key: MarketCorrelationsPage.matrixTabKey,
              label: 'Ma trận',
              value: 'matrix',
              active: activeTab == 'matrix',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketCorrelationsPage.pairsTabKey,
              label: 'Cặp tương quan',
              value: 'pairs',
              active: activeTab == 'pairs',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketCorrelationsPage.diversifyTabKey,
              label: 'Đa dạng hóa',
              value: 'diversify',
              active: activeTab == 'diversify',
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
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeframeChips extends StatelessWidget {
  const _TimeframeChips({required this.timeframe, required this.onSelected});

  final MarketCorrelationTimeframe timeframe;
  final ValueChanged<MarketCorrelationTimeframe> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe7dKey,
          label: '7d',
          active: timeframe == MarketCorrelationTimeframe.d7,
          onTap: () => onSelected(MarketCorrelationTimeframe.d7),
        ),
        const SizedBox(width: 8),
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe30dKey,
          label: '30d',
          active: timeframe == MarketCorrelationTimeframe.d30,
          onTap: () => onSelected(MarketCorrelationTimeframe.d30),
        ),
        const SizedBox(width: 8),
        _TimeframeChip(
          key: MarketCorrelationsPage.timeframe90dKey,
          label: '90d',
          active: timeframe == MarketCorrelationTimeframe.d90,
          onTap: () => onSelected(MarketCorrelationTimeframe.d90),
        ),
      ],
    );
  }
}

class _TimeframeChip extends StatelessWidget {
  const _TimeframeChip({
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
              ? _marketPrimary.withValues(alpha: .12)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .34)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _MatrixCard extends StatelessWidget {
  const _MatrixCard({required this.snapshot});

  final MarketCorrelationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ma trận tương quan (${_timeframeLabel(snapshot.timeframe)})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          _CorrelationHeatmap(assets: snapshot.assets, matrix: snapshot.matrix),
        ],
      ),
    );
  }
}

class _CorrelationHeatmap extends StatelessWidget {
  const _CorrelationHeatmap({required this.assets, required this.matrix});

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labelSize = 28.0;
        final n = assets.length;
        final cellSize = (constraints.maxWidth - labelSize) / n;
        final height = labelSize + cellSize * n;
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: CustomPaint(
            painter: _CorrelationHeatmapPainter(
              assets: assets,
              matrix: matrix,
              labelSize: labelSize,
              cellSize: cellSize,
            ),
          ),
        );
      },
    );
  }
}

class _CorrelationHeatmapPainter extends CustomPainter {
  const _CorrelationHeatmapPainter({
    required this.assets,
    required this.matrix,
    required this.labelSize,
    required this.cellSize,
  });

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;
  final double labelSize;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var col = 0; col < assets.length; col += 1) {
      final asset = assets[col];
      textPainter.text = TextSpan(
        text: asset.symbol,
        style: AppTextStyles.micro.copyWith(
          color: asset.color,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
        ),
      );
      textPainter.layout();
      final x =
          labelSize + col * cellSize + cellSize / 2 - textPainter.width / 2;
      textPainter.paint(canvas, Offset(x, labelSize - 18));
    }

    for (var row = 0; row < assets.length; row += 1) {
      final asset = assets[row];
      final y = labelSize + row * cellSize + cellSize / 2;
      textPainter.text = TextSpan(
        text: asset.symbol,
        style: AppTextStyles.micro.copyWith(
          color: asset.color,
          fontSize: 8,
          fontWeight: AppTextStyles.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelSize - 4 - textPainter.width, y - 6),
      );

      for (var col = 0; col < assets.length; col += 1) {
        final value = matrix[row][col];
        final x = labelSize + col * cellSize;
        final cellY = labelSize + row * cellSize;
        final color = _correlationColor(value);
        final opacity = row == col ? .60 : .12 + value * .35;
        final rect = Rect.fromLTWH(
          x + 1,
          cellY + 1,
          cellSize - 2,
          cellSize - 2,
        );
        canvas.drawRect(
          rect,
          Paint()..color = color.withValues(alpha: opacity),
        );
        canvas.drawRect(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = .5
            ..color = AppColors.borderSolid,
        );

        textPainter.text = TextSpan(
          text: row == col ? '1.0' : value.toStringAsFixed(2),
          style: AppTextStyles.micro.copyWith(
            color: value >= .7 ? Colors.white : AppColors.text1,
            fontSize: row == col ? 8 : 7,
            fontWeight: row == col ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            x + cellSize / 2 - textPainter.width / 2,
            cellY + cellSize / 2 - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CorrelationHeatmapPainter oldDelegate) {
    return oldDelegate.matrix != matrix || oldDelegate.assets != assets;
  }
}

class _CorrelationLegend extends StatelessWidget {
  const _CorrelationLegend();

  @override
  Widget build(BuildContext context) {
    const items = [
      _LegendEntry('Rất cao (>0.85)', Color(0xFFDC2626)),
      _LegendEntry('Cao (0.7-0.85)', AppColors.sell),
      _LegendEntry('TB (0.5-0.7)', AppColors.warn),
      _LegendEntry('Thấp (0.3-0.5)', AppColors.buy),
      _LegendEntry('Rất thấp (<0.3)', Color(0xFF06B6D4)),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 8,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

final class _LegendEntry {
  const _LegendEntry(this.label, this.color);

  final String label;
  final Color color;
}

class _MatrixInfoCard extends StatelessWidget {
  const _MatrixInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .20),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: _marketPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cách đọc ma trận',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Giá trị 1.0 = hoàn toàn cùng chiều. Giá trị 0 = không liên quan. Tương quan cao có nghĩa 2 tài sản thường di chuyển cùng hướng. Để giảm rủi ro, nên giữ tài sản có tương quan thấp.',
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

class _QuickInsights extends StatelessWidget {
  const _QuickInsights({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InsightCard(
            label: 'Cao nhất',
            value: score.highestCorr.value.toStringAsFixed(2),
            sub: score.highestCorr.pair,
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InsightCard(
            label: 'Thấp nhất',
            value: score.lowestCorr.value.toStringAsFixed(2),
            sub: score.lowestCorr.pair,
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final String recommendation;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .20),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, size: 16, color: _marketPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khuyến nghị',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  recommendation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
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

class _SortChips extends StatelessWidget {
  const _SortChips({required this.sortOrder, required this.onSelected});

  final CorrelationSortOrder sortOrder;
  final ValueChanged<CorrelationSortOrder> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _SortChip(
            key: MarketCorrelationsPage.sortHighKey,
            label: 'Tương quan cao',
            active: sortOrder == CorrelationSortOrder.high,
            color: AppColors.sell,
            onTap: () => onSelected(CorrelationSortOrder.high),
          ),
          const SizedBox(width: 8),
          _SortChip(
            key: MarketCorrelationsPage.sortLowKey,
            label: 'Tương quan thấp',
            active: sortOrder == CorrelationSortOrder.low,
            color: AppColors.buy,
            onTap: () => onSelected(CorrelationSortOrder.low),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
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
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .10) : AppColors.surface2,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? color : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _PairCorrelationRow extends StatelessWidget {
  const _PairCorrelationRow({
    super.key,
    required this.rank,
    required this.pair,
    required this.timeframe,
    required this.maxValue,
  });

  final int rank;
  final CorrelationPairDraft pair;
  final MarketCorrelationTimeframe timeframe;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final value = _correlationValueFor(pair, timeframe);
    final color = _correlationColor(value);
    return Stack(
      children: [
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: maxValue == 0 ? 0 : value / maxValue,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: .06),
                borderRadius: AppRadii.mdRadius,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: .92),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                child: Text(
                  '$rank',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: 10),
              _AssetDot(symbol: pair.assetA, color: pair.colorA),
              const SizedBox(width: 5),
              Text(
                '↔',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: 5),
              _AssetDot(symbol: pair.assetB, color: pair.colorB),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${pair.assetA}/${pair.assetB}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(2),
                    style: AppTextStyles.body.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    _correlationLabel(value),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetDot extends StatelessWidget {
  const _AssetDot({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol.substring(0, 2),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 7,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _DiversificationHero extends StatelessWidget {
  const _DiversificationHero({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score.score);
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ số đa dạng hóa',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${score.score}',
                style: AppTextStyles.heroNumber.copyWith(color: color),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SmallPill(label: score.label, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: score.score / 100,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kém',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              Text(
                'TB',
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
              Text(
                'Tốt',
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
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

class _DiversificationMetrics extends StatelessWidget {
  const _DiversificationMetrics({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tương quan TB',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 5),
                Text(
                  score.avgCorrelation.toStringAsFixed(2),
                  style: AppTextStyles.base.copyWith(
                    color: score.avgCorrelation > .7
                        ? AppColors.sell
                        : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cặp ít tương quan nhất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 5),
                Text(
                  score.lowestCorr.pair,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  score.lowestCorr.value.toStringAsFixed(2),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeframeScoreCard extends StatelessWidget {
  const _TimeframeScoreCard({required this.repo});

  final MarketRepository repo;

  @override
  Widget build(BuildContext context) {
    const timeframes = [
      MarketCorrelationTimeframe.d7,
      MarketCorrelationTimeframe.d30,
      MarketCorrelationTimeframe.d90,
    ];
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final timeframe in timeframes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TimeframeScoreRow(
                label: _timeframeLabel(timeframe),
                score: repo
                    .getMarketCorrelations(timeframe: timeframe)
                    .diversificationScore,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeframeScoreRow extends StatelessWidget {
  const _TimeframeScoreRow({required this.label, required this.score});

  final String label;
  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score.score);
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: score.score / 100,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 30,
          child: Text(
            '${score.score}',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CorrelationDisclaimer extends StatelessWidget {
  const _CorrelationDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 12,
            color: AppColors.warn,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tương quan quá khứ không đảm bảo tương lai. Trong giai đoạn biến động mạnh, tương quan giữa crypto thường tăng cao (risk-on/risk-off). Chỉ mang tính tham khảo.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
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
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
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

double _correlationValueFor(
  CorrelationPairDraft pair,
  MarketCorrelationTimeframe timeframe,
) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => pair.correlation7d,
    MarketCorrelationTimeframe.d30 => pair.correlation30d,
    MarketCorrelationTimeframe.d90 => pair.correlation90d,
  };
}

Color _correlationColor(double value) {
  if (value >= .85) return const Color(0xFFDC2626);
  if (value >= .70) return AppColors.sell;
  if (value >= .50) return AppColors.warn;
  if (value >= .30) return AppColors.buy;
  if (value >= .0) return const Color(0xFF06B6D4);
  return _marketPrimary;
}

String _correlationLabel(double value) {
  if (value >= .85) return 'Rất cao';
  if (value >= .70) return 'Cao';
  if (value >= .50) return 'Trung bình';
  if (value >= .30) return 'Thấp';
  return 'Rất thấp';
}

String _timeframeLabel(MarketCorrelationTimeframe timeframe) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => '7d',
    MarketCorrelationTimeframe.d30 => '30d',
    MarketCorrelationTimeframe.d90 => '90d',
  };
}

Color _scoreColor(int score) {
  if (score >= 50) return AppColors.buy;
  if (score >= 30) return AppColors.warn;
  return AppColors.sell;
}
