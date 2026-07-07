part of 'staking_analytics_page.dart';

class _AssetEarningsGrid extends StatelessWidget {
  const _AssetEarningsGrid({required this.products});

  final List<StakingProductPerformanceDraft> products;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: StakingAnalyticsPage.assetGridKey,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppSpacing.earnAnalyticsGridColumns,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: AppSpacing.stakingAnalyticsMetricGridAspect,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          final color = _assetColor(product.colorIndex);
          return VitCard(
            key: StakingAnalyticsPage.assetKey(product.asset),
            padding: _stakingAnalyticsCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: color,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.swatchRadius,
                        ),
                      ),
                      child: const SizedBox(
                        width: AppSpacing.earnAnalyticsAssetDot,
                        height: AppSpacing.earnAnalyticsAssetDot,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        product.asset,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  '+${_formatUsd(product.earnedUsd)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ApyTab extends StatelessWidget {
  const _ApyTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xu hướng APY (6 tháng)',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        VitCard(
          key: StakingAnalyticsPage.apyChartKey,
          padding: _stakingAnalyticsCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _stakingAnalyticsChartHeight,
                child: Row(
                  children: [
                    const _YAxisLabels(
                      labels: ['25%', '20%', '15%', '10%', '5%'],
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomPaint(
                              painter: _ApyTrendPainter(
                                points: snapshot.apyTrends,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                          _DateLabels(
                            dates: snapshot.apyTrends
                                .map((p) => p.date)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Linh hoạt', color: AppColors.buy),
                  _LegendEntry(label: 'Cố định', color: AppColors.primarySoft),
                  _LegendEntry(label: 'DeFi', color: AppColors.warn),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const _InsightBox(
                text:
                    'APY DeFi biến động cao do thanh khoản pool thay đổi. APY Fixed và Flexible ổn định hơn trong cùng kỳ.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoiTab extends StatelessWidget {
  const _RoiTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'ROI: Staking vs Holding',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        VitCard(
          key: StakingAnalyticsPage.roiChartKey,
          padding: _stakingAnalyticsCardPadding,
          child: Column(
            children: [
              SizedBox(
                height: _stakingAnalyticsChartHeight,
                child: CustomPaint(
                  painter: _RoiBarPainter(points: snapshot.roiComparison),
                  size: Size.infinite,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const _LegendRow(
                entries: [
                  _LegendEntry(label: 'Staking', color: AppColors.buy),
                  _LegendEntry(label: 'Holding', color: AppColors.sell),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const _InsightBox(
                text:
                    'Staking cho ROI cao hơn holding sau 6 tháng nhờ phần thưởng hằng ngày, nhưng lợi nhuận vẫn phụ thuộc biến động tài sản.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.snapshot});

  final StakingAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final best = snapshot.productPerformance
        .map((product) => product.roi)
        .reduce(math.max);

    return VitPageSection(
      label: 'Hiệu suất theo Sản phẩm',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        KeyedSubtree(
          key: StakingAnalyticsPage.productListKey,
          child: Column(
            children: [
              for (final product in snapshot.productPerformance) ...[
                _ProductPerformanceCard(product: product, maxRoi: best),
                if (product != snapshot.productPerformance.last)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductPerformanceCard extends StatelessWidget {
  const _ProductPerformanceCard({required this.product, required this.maxRoi});

  final StakingProductPerformanceDraft product;
  final double maxRoi;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(product.colorIndex);
    final progress = maxRoi == 0 ? 0.0 : (product.roi / maxRoi).clamp(0.0, 1.0);

    return VitCard(
      key: StakingAnalyticsPage.productKey(product.asset),
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              _AssetAvatar(asset: product.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'APY: ${product.apy.toStringAsFixed(1)}%',
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
                    '+${product.roi.toStringAsFixed(2)}%',
                    style: AppTextStyles.sectionTitleSm.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'ROI',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SmallStat(
                  label: 'Đầu tư',
                  value: _formatUsd(product.investedUsd),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SmallStat(
                  label: 'Thu nhập',
                  value: '+${_formatUsd(product.earnedUsd)}',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.earnAnalyticsProgressMinHeight,
              value: progress,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingAnalyticsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: CircleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.earnAnalyticsAvatarBox,
        height: AppSpacing.earnAnalyticsAvatarBox,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: _stakingAnalyticsCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.earnAnalyticsInsightIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _stakingAnalyticsInsightLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: _stakingAnalyticsCardPadding,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: _stakingAnalyticsFooterLineHeight,
        ),
      ),
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.earnAnalyticsAxisWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final label in labels)
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _DateLabels extends StatelessWidget {
  const _DateLabels({required this.dates});

  final List<String> dates;

  @override
  Widget build(BuildContext context) {
    final indexes = <int>{0, 1, 2, 3, dates.length - 1}.toList()..sort();

    return Row(
      children: [
        for (final index in indexes)
          Expanded(
            child: Text(
              dates[index],
              textAlign: index == 0
                  ? TextAlign.left
                  : index == dates.length - 1
                  ? TextAlign.right
                  : TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
      ],
    );
  }
}
