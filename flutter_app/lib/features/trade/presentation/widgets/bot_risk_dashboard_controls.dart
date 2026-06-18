part of '../pages/bot_risk_dashboard_page.dart';

class _SafetyControlsCard extends StatelessWidget {
  const _SafetyControlsCard({required this.controls});

  final List<TradeBotSafetyControl> controls;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: _riskGreen,
                size: AppSpacing.tradeBotCardGap,
              ),
              const SizedBox(width: AppSpacing.tradeBotCardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Circuit Breaker',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tradeBotTinyGap),
                    Text(
                      'Auto-stop at limit breach',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Active',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotContentGap),
          for (final control in controls) ...[
            VitCard(
              variant: VitCardVariant.inner,
              padding: AppSpacing.tradeBotControlPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      control.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    control.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.tradeBotRowGap),
                  const Icon(
                    Icons.circle,
                    color: _riskGreen,
                    size: AppSpacing.tradeBotSmallGap,
                  ),
                ],
              ),
            ),
            if (control != controls.last)
              const SizedBox(height: AppSpacing.tradeBotSmallGap),
          ],
        ],
      ),
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  const _EmergencyActionCard({required this.runningBots, required this.onTap});

  final int runningBots;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotRiskDashboardPage.emergencyButtonKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        variant: VitCardVariant.ghost,
        constraints: const BoxConstraints(
          minHeight: AppSpacing.tradeBotSecurityCardMinHeight,
        ),
        padding: AppSpacing.tradeBotCardPadding,
        borderColor: _riskRed.withValues(alpha: .48),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: _riskRed, size: 24),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Emergency Stop All Bots',
                    style: AppTextStyles.caption.copyWith(
                      color: _riskRed,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.tradeBotSmallGap),
                  Text(
                    'Stop all $runningBots running bots immediately',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '->',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskExplanationCard extends StatelessWidget {
  const _RiskExplanationCard();

  static const _items = [
    'Current drawdown (30%)',
    'Daily loss vs limit (25%)',
    'Portfolio exposure (20%)',
    'VaR trend (15%)',
    'Diversification (10%)',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.tradeBotCardPaddingTall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Risk Score is Calculated',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          for (final item in _items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: AppSpacing.tradeBotRowGap),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
              ],
            ),
            if (item != _items.last)
              const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: label,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _riskPrimary,
    );
  }
}
