part of '../pages/dca_portfolio_optimizer_page.dart';

class _FrontierContent extends StatelessWidget {
  const _FrontierContent({
    required this.snapshot,
    required this.showSuggestions,
    required this.onToggleSuggestions,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final VoidCallback onToggleSuggestions;

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
            onTap: () {},
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardLabel(
                color: AppColors.accent,
                title: 'Risk-Return Scatter',
                subtitle:
                    'Mỗi điểm đại diện một phân bổ tối ưu. Điểm càng cao = lợi nhuận lớn hơn.',
              ),
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
              SizedBox(
                height: AppSpacing.dcaPortfolioOptimizerFrontierChartHeight,
                width: double.infinity,
                child: CustomPaint(
                  painter: _FrontierChartPainter(snapshot.frontier),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        SizedBox(
          height: AppSpacing.dcaPortfolioOptimizerFrontierChipListHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.frontier.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
            itemBuilder: (context, index) {
              final point = snapshot.frontier[index];
              final active = point.label == 'Optimal (Max Sharpe)';
              return _FrontierChip(point: point, active: active);
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        _SelectedPortfolioCard(snapshot: snapshot),
        const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
        _SuggestionsCard(
          suggestions: snapshot.suggestions,
          expanded: showSuggestions,
          onToggle: onToggleSuggestions,
        ),
      ],
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
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: BoxDecoration(
                  color: AppColors.accent10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optimal (Max Sharpe)',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
                    Text(
                      'Phân bổ đề xuất',
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
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
                Container(
                  width: AppSpacing.dcaPortfolioOptimizerDividerWidth,
                  height: AppSpacing.x7,
                  color: AppColors.border,
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
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          for (final allocation in optimalAllocations) ...[
            _SimpleAllocationBar(allocation: allocation),
            if (allocation != optimalAllocations.last)
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          ],
        ],
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
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.mdRadius,
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
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
            for (final suggestion in suggestions) ...[
              _SuggestionRow(suggestion: suggestion),
              if (suggestion != suggestions.last)
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
            ],
          ],
        ],
      ),
    );
  }
}
