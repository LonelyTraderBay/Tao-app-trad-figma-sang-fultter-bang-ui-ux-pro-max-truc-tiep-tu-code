part of '../pages/savings_page.dart';

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.snapshot});

  final SavingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnCardPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tiền gửi (USD)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.totalDepositedUsd,
                      style: AppTextStyles.numericDisplayMd,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: const ShapeDecoration(
                            color: AppColors.buy10,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xlRadius,
                            ),
                          ),
                          child: Padding(
                            padding: AppSpacing.earnPillPadding,
                            child: Text(
                              snapshot.gainLabel,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.buy,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          'lãi tích lũy',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                key: SavingsPage.portfolioButtonKey,
                onPressed: () => context.go(snapshot.portfolioRoute),
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.text2,
                  size: AppSpacing.iconMd,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.wallet_outlined,
                  primary: true,
                  onTap: () => context.go(snapshot.portfolioRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Gửi',
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Rút',
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    this.primary = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.primary : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: AppSpacing.earnVerticalPaddingX3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary ? AppColors.navCenterIcon : AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: primary ? AppColors.navCenterIcon : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightList extends StatelessWidget {
  const _InsightList({required this.insights});

  final List<SavingsInsightDraft> insights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final insight in insights) ...[
          VitCard(
            key: _insightKey(insight.route),
            radius: VitCardRadius.lg,
            padding: AppSpacing.earnCardPaddingX4,
            onTap: insight.route == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    context.go(insight.route!);
                  },
            child: Row(
              children: [
                _RoundIcon(tone: insight.tone),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        insight.subtitle,
                        style: AppTextStyles.captionSm.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (insight != insights.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }

  Key? _insightKey(String? route) {
    return switch (route) {
      '/earn/savings/dca' => SavingsPage.dcaInsightKey,
      '/earn/savings/export' => SavingsPage.exportInsightKey,
      '/earn/savings/backtest' => SavingsPage.backtestInsightKey,
      '/earn/savings/autopilot' => SavingsPage.autopilotInsightKey,
      '/earn/savings/ladder' => SavingsPage.ladderInsightKey,
      '/earn/savings/whatif' => SavingsPage.whatIfInsightKey,
      '/earn/savings/smart-suggestions' =>
        SavingsPage.smartSuggestionsInsightKey,
      _ => null,
    };
  }
}

class _ToolboxButton extends StatelessWidget {
  const _ToolboxButton({required this.guideRoute, required this.exportRoute});

  final String guideRoute;
  final String exportRoute;

  @override
  Widget build(BuildContext context) {
    assert(exportRoute.isNotEmpty);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnVerticalPaddingX3,
      child: InkWell(
        key: SavingsPage.guideButtonKey,
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(guideRoute);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Công cụ nâng cao',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
