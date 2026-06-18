part of '../pages/dca_portfolio_optimizer_page.dart';

class _OptimizerTabs extends StatelessWidget {
  const _OptimizerTabs({required this.activeTab, required this.onChanged});

  final _OptimizerTab activeTab;
  final ValueChanged<_OptimizerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: AppSpacing.dcaPaddingX2,
      child: Row(
        children: [
          for (final tab in _OptimizerTab.values)
            Expanded(
              child: _OptimizerTabButton(
                key: DCAPortfolioOptimizer.tabKey(tab.name),
                tab: tab,
                active: tab == activeTab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptimizerTabButton extends StatelessWidget {
  const _OptimizerTabButton({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final _OptimizerTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: active ? AppColors.surface : AppColors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Padding(
          padding: AppSpacing.dcaVerticalPaddingX3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _tabIcon(tab),
                color: active ? AppColors.accent : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const Padding(padding: AppSpacing.dcaTopPaddingX1),
              Text(
                _tabLabel(tab),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: active ? AppColors.text1 : AppColors.text3,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.activeTab,
    required this.snapshot,
    required this.showSuggestions,
    required this.onToggleSuggestions,
  });

  final _OptimizerTab activeTab;
  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final VoidCallback onToggleSuggestions;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      _OptimizerTab.frontier => _FrontierContent(
        snapshot: snapshot,
        showSuggestions: showSuggestions,
        onToggleSuggestions: onToggleSuggestions,
      ),
      _OptimizerTab.correlation => const _CorrelationContent(),
      _OptimizerTab.backtest => const _BacktestContent(),
      _OptimizerTab.risk => _RiskContent(snapshot: snapshot),
    };
  }
}
