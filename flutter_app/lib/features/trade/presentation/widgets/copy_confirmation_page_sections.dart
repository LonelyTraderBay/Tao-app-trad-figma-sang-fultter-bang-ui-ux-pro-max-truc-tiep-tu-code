part of '../pages/copy_confirmation_page.dart';

class _CriticalWarning extends StatelessWidget {
  const _CriticalWarning({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationRed,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _confirmationRed,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro quan trọng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _confirmationRed,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Copy Trading có rủi ro cao. Bạn có thể mất toàn bộ số tiền \$${snapshot.configuration.copyCapital.toStringAsFixed(0)} đã cam kết.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sellSoft,

                    height: 1.45,
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

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _confirmationPrimary.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _confirmationPrimary,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn sắp copy',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigurationSummary extends StatelessWidget {
  const _ConfigurationSummary({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final config = snapshot.configuration;
    return VitPageSection(
      label: 'Cấu hình',
      accentColor: _confirmationPrimary,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Số vốn copy',
                value: '\$${config.copyCapital.toStringAsFixed(0)}',
              ),
              _SummaryRow(
                label: 'Chế độ copy',
                value: _copyModeLabel(config.copyMode),
              ),
              _SummaryRow(
                label: 'Stop-Loss',
                value: config.useCustomStopLoss
                    ? '-${config.customStopLoss.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              _SummaryRow(
                label: 'Take-Profit',
                value: config.useCustomTakeProfit
                    ? '+${config.customTakeProfit.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              _SummaryRow(
                label: 'Trailing Stop',
                value: config.useTrailingStop
                    ? '${config.trailingStopPercent.toStringAsFixed(0)}%'
                    : 'Không',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuitabilityReviewCard extends StatelessWidget {
  const _SuitabilityReviewCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final provider = snapshot.provider!;
    final config = snapshot.configuration;
    return VitPageSection(
      key: CopyConfirmationPage.suitabilityKey,
      label: 'Suitability & limits review',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(
                label: 'Risk suitability',
                value:
                    '${_riskLabel(provider.riskLevel)} risk · DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                valueColor: AppColors.warn,
              ),
              _SummaryRow(
                label: 'Copy amount review',
                value: '\$${config.copyCapital.toStringAsFixed(0)} at risk',
                valueColor: _confirmationRed,
              ),
              const _SummaryRow(
                label: 'Provider limit',
                value: 'Max 20% portfolio per provider',
              ),
              const SizedBox(height: 6),
              Text(
                'Confirm this amount fits your risk tolerance, provider drawdown, and portfolio limit before cooling-off starts.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,

                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeeBreakdown extends StatelessWidget {
  const _FeeBreakdown({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final fee = snapshot.feePreview;
    return VitPageSection(
      label: 'Chi phí & Phí',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Platform fee (0.1%)',
                value: '\$${fee.platformFee.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Trading fees ước tính',
                value: '\$${fee.estimatedTradingFees.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Performance fee',
                value: fee.performanceFeeNote,
              ),
              const Divider(color: AppColors.divider, height: 22),
              _SummaryRow(
                label: 'Tổng phí cố định tháng đầu',
                value: '\$${fee.totalFixedFees.toStringAsFixed(2)}',
                valueColor: _confirmationRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  const _ScenarioSection({required this.scenarios});

  final List<TradeCopyScenarioProjection> scenarios;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Kịch bản dự kiến (30 ngày)',
      accentColor: _confirmationGreen,
      children: [
        for (final scenario in scenarios) _ScenarioCard(scenario: scenario),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final TradeCopyScenarioProjection scenario;

  @override
  Widget build(BuildContext context) {
    final color = switch (scenario.id) {
      'optimistic' => _confirmationGreen,
      'realistic' => AppColors.warn,
      _ => _confirmationRed,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _SummaryRow(
            label:
                '${scenario.title} (${scenario.returnPct.toStringAsFixed(0)}%)',
            value:
                '${scenario.netPnl >= 0 ? '+' : ''}\$${scenario.netPnl.toStringAsFixed(0)}',
            valueColor: color,
          ),
          _SummaryRow(
            label: 'Net return',
            value:
                '${scenario.netReturnPct >= 0 ? '+' : ''}${scenario.netReturnPct.toStringAsFixed(1)}%',
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _MaxLossCard extends StatelessWidget {
  const _MaxLossCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationRed,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kịch bản mất vốn tối đa',
            style: AppTextStyles.caption.copyWith(
              color: _confirmationRed,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bạn có thể mất tối đa \$${snapshot.maxLossAmount.toStringAsFixed(0)} nếu provider gặp drawdown nghiêm trọng.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.sellSoft,

              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.items,
    required this.acceptedIds,
    required this.onToggle,
  });

  final List<TradeCopyConsentItem> items;
  final Set<String> acceptedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xác nhận & Đồng ý',
      accentColor: _confirmationRed,
      children: [
        for (final item in items)
          _ConsentTile(
            item: item,
            checked: acceptedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
      ],
    );
  }
}
