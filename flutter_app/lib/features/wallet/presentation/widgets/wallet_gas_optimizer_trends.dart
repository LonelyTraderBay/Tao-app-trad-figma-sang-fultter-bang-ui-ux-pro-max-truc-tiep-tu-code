part of '../pages/wallet_gas_optimizer_page.dart';

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.walletGasSecondaryContentGap,
      children: [
        _ChartCard(
          title: '24h Gas Price Trends',
          height: AppSpacing.walletGasChartLargeHeight,
          child: CustomPaint(
            painter: _GasLineChartPainter(points: snapshot.history),
          ),
        ),
        _ChartCard(
          title: 'Network Activity',
          height: AppSpacing.walletGasChartSmallHeight,
          child: CustomPaint(
            painter: _NetworkBarChartPainter(points: snapshot.networkActivity),
          ),
        ),
        const _BestTimeCard(),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.height,
    required this.child,
  });

  final String title;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: height,
      padding: AppSpacing.walletGasChartPadding,
      borderColor: _gasBorder,
      child: VitPageContent(
        padding: VitContentPadding.none,
        fullBleed: true,
        customGap: AppSpacing.walletGasChartGap,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BestTimeCard extends StatelessWidget {
  const _BestTimeCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.walletGasBestTimePadding,
      borderColor: _gasGreen.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: _gasGreen,
                size: AppSpacing.walletGasIcon,
              ),
              const SizedBox(width: AppSpacing.walletGasQuickActionIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best Time to Transact',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.walletGasBestTimeTextGap),
                    Text(
                      'Gas fees are typically lowest between 2 AM - 6 AM UTC.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletGasBestTimeMetricGap),
          Row(
            children: const [
              Expanded(
                child: _BestTimeMetric(
                  label: 'Avg Low Price',
                  value: '12 Gwei',
                ),
              ),
              SizedBox(width: AppSpacing.walletGasBestTimeColumnGap),
              Expanded(
                child: _BestTimeMetric(
                  label: 'Potential Saving',
                  value: '~52%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestTimeMetric extends StatelessWidget {
  const _BestTimeMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.walletGasBestTimeValueGap),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _gasGreen,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
