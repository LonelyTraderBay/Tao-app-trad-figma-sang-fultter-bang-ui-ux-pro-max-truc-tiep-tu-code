part of '../pages/bot_risk_dashboard_page.dart';

class _SafetyControlsCard extends StatelessWidget {
  const _SafetyControlsCard({required this.controls});

  final List<TradeBotSafetyControl> controls;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _riskGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _riskGreen.withValues(alpha: .7),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Circuit Breaker',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Auto-stop at limit breach',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Active',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          for (final control in controls) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              decoration: BoxDecoration(
                color: _riskPanel2,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      control.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ),
                  Text(
                    control.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _riskGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            if (control != controls.last) const SizedBox(height: 8),
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
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
        decoration: BoxDecoration(
          color: _riskRed.withValues(alpha: .08),
          border: Border.all(color: _riskRed.withValues(alpha: .48), width: 2),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: _riskRed, size: 24),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Emergency Stop All Bots',
                    style: AppTextStyles.caption.copyWith(
                      color: _riskRed,
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stop all $runningBots running bots immediately',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Text('->', style: TextStyle(color: AppColors.text3)),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      decoration: BoxDecoration(
        color: _riskPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Risk Score is Calculated',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          for (final item in _items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            if (item != _items.last) const SizedBox(height: 16),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _riskPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _riskPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}
