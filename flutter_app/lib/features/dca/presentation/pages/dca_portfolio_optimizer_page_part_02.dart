part of 'dca_portfolio_optimizer_page.dart';

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
        const SizedBox(height: AppSpacing.x4),
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
              const SizedBox(height: AppSpacing.x4),
              SizedBox(
                height: 220,
                width: double.infinity,
                child: CustomPaint(
                  painter: _FrontierChartPainter(snapshot.frontier),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        SizedBox(
          height: 64,
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
        const SizedBox(height: AppSpacing.x4),
        _SelectedPortfolioCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
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
                    const SizedBox(height: AppSpacing.x1),
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
          const SizedBox(height: AppSpacing.x4),
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
                  width: 1,
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
          const SizedBox(height: AppSpacing.x4),
          for (final allocation in optimalAllocations) ...[
            _SimpleAllocationBar(allocation: allocation),
            if (allocation != optimalAllocations.last)
              const SizedBox(height: AppSpacing.x3),
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
            const SizedBox(height: AppSpacing.x4),
            for (final suggestion in suggestions) ...[
              _SuggestionRow(suggestion: suggestion),
              if (suggestion != suggestions.last)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ],
      ),
    );
  }
}

class _CorrelationContent extends StatelessWidget {
  const _CorrelationContent();

  @override
  Widget build(BuildContext context) {
    const assets = ['BTC', 'ETH', 'SOL', 'BNB', 'ADA'];
    final correlations = [
      [1.00, .82, .71, .68, .65],
      [.82, 1.00, .78, .73, .70],
      [.71, .78, 1.00, .58, .62],
      [.68, .73, .58, 1.00, .55],
      [.65, .70, .62, .55, 1.00],
    ];

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.hub_outlined,
            title: 'Ma trận tương quan',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tương quan càng thấp = diversification tốt. Càng cao = di chuyển cùng hướng.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              const SizedBox(width: AppSpacing.x7),
              for (final asset in assets)
                Expanded(
                  child: Text(
                    asset,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (var row = 0; row < assets.length; row++) ...[
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.x7,
                  child: Text(
                    assets[row],
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (var col = 0; col < assets.length; col++)
                  Expanded(
                    child: _CorrelationCell(value: correlations[row][col]),
                  ),
              ],
            ),
            if (row != assets.length - 1) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _BacktestContent extends StatelessWidget {
  const _BacktestContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.bar_chart_rounded,
                title: 'DCA vs HODL (12 tháng)',
                color: AppColors.buy,
              ),
              const SizedBox(height: AppSpacing.x4),
              SizedBox(
                height: 210,
                width: double.infinity,
                child: CustomPaint(painter: _BacktestChartPainter()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          children: const [
            Expanded(
              child: _MiniStatCard(
                label: 'DCA Final',
                value: '12.9M',
                color: AppColors.buy,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'HODL Final',
                value: '11.2M',
                color: AppColors.warn,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'DCA trội hơn',
                value: '+14.7%',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        const _DisclaimerCard(
          text:
              'Kết quả dựa trên dữ liệu lịch sử, không đảm bảo hiệu suất tương lai.',
        ),
      ],
    );
  }
}

class _RiskContent extends StatelessWidget {
  const _RiskContent({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Biến động/năm',
        '${snapshot.optimalRiskPercent.toStringAsFixed(1)}%',
        AppColors.warn,
      ),
      ('Max Drawdown', '-27.8%', AppColors.sell),
      (
        'Sharpe Ratio',
        snapshot.optimalSharpe.toStringAsFixed(2),
        AppColors.accent,
      ),
      ('Sortino Ratio', '1.78', AppColors.primary),
      ('VaR 95%', '-7.5%', AppColors.sell),
      ('Beta', '1.20', AppColors.buy),
    ];

    return Column(
      children: [
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.shield_outlined,
                title: 'Đánh giá rủi ro',
                color: AppColors.sell,
              ),
              const SizedBox(height: AppSpacing.x4),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metrics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x3,
                ),
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  return _MiniStatCard(
                    label: metric.$1,
                    value: metric.$2,
                    color: metric.$3,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _DisclaimerCard(
          text:
              'Các chỉ số dựa trên dữ liệu lịch sử. Hãy đa dạng hóa và chỉ đầu tư số tiền bạn chấp nhận mất.',
        ),
      ],
    );
  }
}

class _FloatingActions extends StatelessWidget {
  const _FloatingActions({
    required this.onShare,
    required this.onSettings,
    required this.onApply,
  });

  final VoidCallback onShare;
  final VoidCallback onSettings;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FloatingIconButton(icon: Icons.share_outlined, onTap: onShare),
        const SizedBox(width: AppSpacing.x3),
        _FloatingIconButton(
          key: DCAPortfolioOptimizer.driftSettingsKey,
          icon: Icons.notifications_none_rounded,
          iconColor: AppColors.warn,
          onTap: onSettings,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: DCAPortfolioOptimizer.applyKey,
            onPressed: onApply,
            leading: const Icon(Icons.arrow_outward_rounded),
            child: const Text('Áp dụng phân bổ'),
          ),
        ),
      ],
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.navCenterIcon,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      child: VitCtaButton(
        onPressed: onTap,
        fullWidth: false,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: iconColor, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: color.withValues(alpha: .16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
