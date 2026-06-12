part of '../pages/margin_trading_hub_page.dart';

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final TradeMarginHubFeature feature;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return _HubCard(
      key: MarginTradingHubPage.featureKey(feature.phase),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _featureIcon(feature.phase),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MarginHubPhaseBadge(label: feature.phase, color: color),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (final item in feature.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != feature.items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.compliance});

  final TradeMarginHubCompliance compliance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(16),
      borderColor: _hubGreen.withValues(alpha: .24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: _hubGreen, size: 42),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compliance.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _hubGreen,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      compliance.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: compliance.regulations.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 36,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _hubGreen.withValues(alpha: .16),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  '${compliance.regulations[index]} v',
                  style: AppTextStyles.caption.copyWith(
                    color: _hubGreen,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _hubBorder.withValues(alpha: .68),
      child: child,
    );
  }
}

IconData _menuIcon(String id) {
  return switch (id) {
    'margin' => Icons.trending_up_rounded,
    'advanced-controls' => Icons.settings_outlined,
    'market-analytics' => Icons.show_chart_rounded,
    'ai-advanced' => Icons.school_outlined,
    _ => Icons.layers_outlined,
  };
}

IconData _featureIcon(String phase) {
  return switch (phase) {
    'P0' => Icons.shield_outlined,
    'P1' => Icons.settings_outlined,
    'P2' => Icons.show_chart_rounded,
    _ => Icons.layers_outlined,
  };
}
