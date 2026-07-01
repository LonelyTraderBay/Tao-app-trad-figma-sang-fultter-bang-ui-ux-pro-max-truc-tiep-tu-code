part of '../pages/dca_portfolio_optimizer_page.dart';

class _FrontierContent extends StatelessWidget {
  const _FrontierContent({
    required this.snapshot,
    required this.showSuggestions,
    required this.showCompareHint,
    required this.onToggleSuggestions,
    required this.onCompare,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final bool showCompareHint;
  final VoidCallback onToggleSuggestions;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(
          icon: Icons.adjust_rounded,
          title: 'Efficient Frontier',
          color: AppColors.accent,
          trailing: _MiniButton(
            label: 'So sánh',
            icon: Icons.compare_arrows_rounded,
            color: AppColors.text3,
            onTap: onCompare,
          ),
        ),
        if (showCompareHint) ...[
          const Padding(padding: AppSpacing.dcaTopPaddingX3),
          const _CompareHintCard(),
        ],
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        VitCard(
          padding: _dcaPortfolioCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardLabel(
                color: AppColors.accent,
                title: 'Risk-Return Scatter',
                subtitle:
                    'Mỗi điểm đại diện một phân bổ tối ưu. Điểm càng cao = lợi nhuận lớn hơn.',
              ),
              const Padding(padding: AppSpacing.dcaTopPaddingX3),
              SizedBox(
                height: _dcaPortfolioFrontierChartHeight,
                width: double.infinity,
                child: Semantics(
                  container: true,
                  label:
                      'Efficient frontier chart. Optimal portfolio return ${snapshot.optimalReturnPercent.toStringAsFixed(0)} percent, risk ${snapshot.optimalRiskPercent.toStringAsFixed(0)} percent, Sharpe ${snapshot.optimalSharpe.toStringAsFixed(2)}.',
                  child: CustomPaint(
                    painter: _FrontierChartPainter(snapshot.frontier),
                  ),
                ),
              ),
              const Padding(padding: AppSpacing.dcaTopPaddingX2),
              _FrontierChartLegend(snapshot: snapshot),
            ],
          ),
        ),
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        SizedBox(
          height: _dcaPortfolioFrontierChipListHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.frontier.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
            itemBuilder: (context, index) {
              final point = snapshot.frontier[index];
              final active = point.label == 'Optimal (Max Sharpe)';
              return _FrontierChip(point: point, active: active);
            },
          ),
        ),
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        _SelectedPortfolioCard(snapshot: snapshot),
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        _AllocationDeltaCard(snapshot: snapshot),
        const Padding(padding: AppSpacing.dcaTopPaddingX3),
        _SuggestionsCard(
          suggestions: snapshot.suggestions,
          expanded: showSuggestions,
          onToggle: onToggleSuggestions,
        ),
      ],
    );
  }
}

class _CompareHintCard extends StatelessWidget {
  const _CompareHintCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.dcaPaddingX3,
      child: Row(
        children: [
          const _IconBubble(
            icon: Icons.compare_arrows_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Đang so sánh phân bổ hiện tại và tối ưu',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _dcaPortfolioBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPortfolioCard extends StatelessWidget {
  const _SelectedPortfolioCard({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final optimalAllocations = snapshot.currentAllocations
        .where((allocation) => allocation.optimalPercent > 0)
        .toList(growable: false);

    return VitCard(
      padding: _dcaPortfolioCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: _dcaPortfolioHeroIconExtent,
                height: _dcaPortfolioHeroIconExtent,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.accent10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                  child: const Icon(
                    Icons.pie_chart_outline_rounded,
                    color: AppColors.accent,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh mục đề xuất',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Padding(padding: AppSpacing.dcaTopPaddingX1),
                    Text(
                      'Optimal (Max Sharpe)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SmallPill(
                label: 'Sharpe ${snapshot.optimalSharpe.toStringAsFixed(2)}',
                color: AppColors.accent,
              ),
            ],
          ),
          const Padding(padding: AppSpacing.dcaTopPaddingX3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: _dcaPortfolioCardPadding,
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(
                    label: 'Lợi nhuận/năm',
                    value:
                        '+${snapshot.optimalReturnPercent.toStringAsFixed(0)}%',
                    color: AppColors.buy,
                  ),
                ),
                const SizedBox(
                  width: _dcaPortfolioDividerWidth,
                  height: AppSpacing.x7,
                  child: ColoredBox(color: AppColors.border),
                ),
                Expanded(
                  child: _StatCell(
                    label: 'Biến động (Vol)',
                    value: '${snapshot.optimalRiskPercent.toStringAsFixed(0)}%',
                    color: AppColors.warn,
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: AppSpacing.dcaTopPaddingX3),
          for (final allocation in optimalAllocations) ...[
            _SimpleAllocationBar(allocation: allocation),
            if (allocation != optimalAllocations.last)
              const Padding(padding: AppSpacing.dcaTopPaddingX3),
          ],
        ],
      ),
    );
  }
}

class _FrontierChartLegend extends StatelessWidget {
  const _FrontierChartLegend({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        _FrontierLegendPill(
          label:
              'Tối ưu: +${snapshot.optimalReturnPercent.toStringAsFixed(0)}% · Risk ${snapshot.optimalRiskPercent.toStringAsFixed(0)}%',
          color: AppColors.accent,
        ),
        _FrontierLegendPill(
          label: '${snapshot.frontier.length} điểm frontier',
          color: AppColors.text3,
        ),
      ],
    );
  }
}

class _FrontierLegendPill extends StatelessWidget {
  const _FrontierLegendPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .10),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: AppSpacing.dcaChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ),
    );
  }
}

class _SuggestionsCard extends StatelessWidget {
  const _SuggestionsCard({
    required this.suggestions,
    required this.expanded,
    required this.onToggle,
  });

  final List<DcaPortfolioSuggestion> suggestions;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _dcaPortfolioHeroPadding,
      child: Column(
        children: [
          VitCard(
            onTap: onToggle,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: EdgeInsets.zero,
            borderColor: AppColors.transparent,
            child: Row(
              children: [
                const _IconBubble(
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.warn,
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    'Gợi ý tối ưu (${suggestions.length})',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
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
          if (expanded) ...[
            const Padding(padding: AppSpacing.dcaTopPaddingX3),
            for (final suggestion in suggestions) ...[
              _SuggestionRow(suggestion: suggestion),
              if (suggestion != suggestions.last)
                const Padding(padding: AppSpacing.dcaTopPaddingX3),
            ],
          ],
        ],
      ),
    );
  }
}
