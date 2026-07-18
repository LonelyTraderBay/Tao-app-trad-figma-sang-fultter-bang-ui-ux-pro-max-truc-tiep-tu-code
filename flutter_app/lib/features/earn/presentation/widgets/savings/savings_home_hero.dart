part of '../../pages/savings/savings_page.dart';

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.snapshot});

  final SavingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _HeroKpi(
                  label: 'Tổng tiền gửi (USD)',
                  value: snapshot.totalDepositedUsd,
                  caption: snapshot.gainLabel.isEmpty
                      ? 'Chưa có vị thế'
                      : '${snapshot.gainLabel} lãi tích lũy',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: EarnSpacingTokens.earnHeroSecondaryPadding,
                  child: _HeroKpi(
                    label: 'APY ước tính',
                    value: _savingsApyEstimateRange(snapshot.products),
                    caption: 'Tham khảo, có thể thay đổi',
                    valueColor: AppModuleAccents.earn,
                  ),
                ),
              ),
              VitIconButton(
                key: SavingsPage.portfolioButtonKey,
                icon: Icons.account_balance_wallet_outlined,
                tooltip: 'Mở danh mục tiết kiệm',
                onPressed: () => context.go(snapshot.portfolioRoute),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
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

class _HeroKpi extends StatelessWidget {
  const _HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
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
    return VitCtaButton(
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.buttonCompact,
      fullWidth: true,
      leading: Icon(icon),
      onPressed: onTap,
      child: Text(label),
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
            radius: VitCardRadius.large,
            padding: EarnSpacingTokens.earnCardPaddingX4,
            onTap: insight.route == null
                ? null
                : () {
                    unawaited(HapticFeedback.selectionClick());
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
                        style: AppTextStyles.caption.copyWith(
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
          if (insight != insights.last)
            const SizedBox(height: AppSpacing.rowGap),
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
      key: SavingsPage.guideButtonKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnVerticalPaddingX3,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
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
    );
  }
}

class _YieldDisclaimer extends StatelessWidget {
  const _YieldDisclaimer();

  @override
  Widget build(BuildContext context) {
    return const VitRiskDisclaimerNote(
      message:
          'APY là ước tính tham khảo và có thể thay đổi. Giá tài sản và APY có thể biến động; rút trước hạn có thể mất lãi tích lũy.',
    );
  }
}
