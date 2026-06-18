part of '../pages/network_status_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final WalletNetworkStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summaryColor = snapshot.downCount > 0
        ? _networkRed
        : snapshot.issueCount > 0
        ? _networkAmber
        : _networkGreen;
    final summaryMessage = snapshot.downCount > 0
        ? '${snapshot.downCount} m\u1EA1ng \u0111ang b\u1EA3o tr\u00EC'
        : snapshot.issueCount > 0
        ? '${snapshot.issueCount} m\u1EA1ng \u0111ang ch\u1EADm'
        : 'T\u1EA5t c\u1EA3 m\u1EA1ng ho\u1EA1t \u0111\u1ED9ng t\u1ED1t';

    return VitCard(
      padding: AppSpacing.walletNetworkSummaryPadding,
      radius: VitCardRadius.lg,
      borderColor: summaryColor.withValues(alpha: .34),
      child: Column(
        children: [
          Row(
            children: [
              VitCard(
                width: AppSpacing.walletNetworkSummaryIcon,
                height: AppSpacing.walletNetworkSummaryIcon,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.md,
                borderColor: summaryColor.withValues(alpha: .42),
                background: ColoredBox(
                  color: summaryColor.withValues(alpha: .08),
                ),
                clip: true,
                alignment: Alignment.center,
                child: Icon(
                  snapshot.downCount > 0
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  color: summaryColor,
                  size: AppSpacing.walletNetworkSummaryIconGlyph,
                ),
              ),
              const SizedBox(width: AppSpacing.walletTokenHeroGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summaryMessage,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.rowGap),
                    Text(
                      'C\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng m\u1ED7i ${snapshot.refreshIntervalSeconds} gi\u00E2y',
                      style: AppTextStyles.micro.copyWith(color: _networkMuted),
                    ),
                  ],
                ),
              ),
              VitIconButton(
                key: NetworkStatusPage.refreshKey,
                icon: Icons.refresh_rounded,
                tooltip: 'Refresh network status',
                onPressed: () {},
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletTokenCardGap),
          Row(
            children: [
              _SummaryStat(
                value: snapshot.operationalCount.toString(),
                label: 'Ho\u1EA1t \u0111\u1ED9ng',
                color: _networkGreen,
              ),
              const SizedBox(width: AppSpacing.rowGap),
              _SummaryStat(
                value: snapshot.issueCount.toString(),
                label: 'Ch\u1EADm / T\u1EAFc',
                color: _networkAmber,
              ),
              const SizedBox(width: AppSpacing.rowGap),
              _SummaryStat(
                value: snapshot.downCount.toString(),
                label: 'B\u1EA3o tr\u00EC',
                color: _networkRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        variant: VitCardVariant.inner,
        height: AppSpacing.walletNetworkSummaryStatHeight,
        alignment: Alignment.center,
        borderColor: color.withValues(alpha: .32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.walletAddressStatsValueGap),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: _networkMuted),
            ),
          ],
        ),
      ),
    );
  }
}
