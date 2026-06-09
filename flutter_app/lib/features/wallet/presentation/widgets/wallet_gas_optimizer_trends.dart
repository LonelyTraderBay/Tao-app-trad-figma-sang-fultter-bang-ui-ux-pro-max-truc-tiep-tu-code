part of '../pages/wallet_gas_optimizer_page.dart';

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: '24h Gas Price Trends',
          height: 254,
          child: CustomPaint(
            painter: _GasLineChartPainter(points: snapshot.history),
          ),
        ),
        const SizedBox(height: 14),
        _ChartCard(
          title: 'Network Activity',
          height: 194,
          child: CustomPaint(
            painter: _NetworkBarChartPainter(points: snapshot.networkActivity),
          ),
        ),
        const SizedBox(height: 14),
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
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
      padding: const EdgeInsets.all(16),
      borderColor: _gasGreen.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.schedule_rounded, color: _gasGreen, size: 17),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best Time to Transact',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gas fees are typically lowest between 2 AM - 6 AM UTC.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _BestTimeMetric(
                  label: 'Avg Low Price',
                  value: '12 Gwei',
                ),
              ),
              SizedBox(width: 12),
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
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _gasGreen,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: 'Roboto',
            height: 1,
          ),
        ),
      ],
    );
  }
}
