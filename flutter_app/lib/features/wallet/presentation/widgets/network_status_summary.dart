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

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
      decoration: BoxDecoration(
        color: _networkPanel,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.onAccent.withValues(alpha: .05),
            summaryColor.withValues(alpha: .04),
            _networkPanel2,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: summaryColor.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(
                    color: summaryColor.withValues(alpha: .42),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  snapshot.downCount > 0
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  color: summaryColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summaryMessage,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'C\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng m\u1ED7i ${snapshot.refreshIntervalSeconds} gi\u00E2y',
                      style: AppTextStyles.micro.copyWith(
                        color: _networkMuted,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: NetworkStatusPage.refreshKey,
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _networkPanel,
                    borderRadius: AppRadii.cardRadius,
                    border: Border.all(color: _networkBorder),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.text2,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SummaryStat(
                value: snapshot.operationalCount.toString(),
                label: 'Ho\u1EA1t \u0111\u1ED9ng',
                color: _networkGreen,
              ),
              const SizedBox(width: 8),
              _SummaryStat(
                value: snapshot.issueCount.toString(),
                label: 'Ch\u1EADm / T\u1EAFc',
                color: _networkAmber,
              ),
              const SizedBox(width: 8),
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
      child: Container(
        height: 59,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _networkPanel.withValues(alpha: .75),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: color.withValues(alpha: .32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: _networkMuted,
                fontSize: 9,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
