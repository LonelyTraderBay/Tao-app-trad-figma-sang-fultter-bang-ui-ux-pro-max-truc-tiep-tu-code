part of '../pages/margin_trading_hub_page.dart';

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final TradeMarginHubFeature feature;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return _HubCard(
      key: MarginTradingHubPage.featureKey(feature.phase),
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.ctaLoadingIcon,
        top: AppSpacing.ctaLoadingIcon,
        right: AppSpacing.ctaLoadingIcon,
        bottom: AppSpacing.ctaLoadingIcon,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitCard(
                variant: VitCardVariant.inner,
                width:
                    AppSpacing.walletAddressActionSize +
                    AppSpacing.formFieldLabelGap,
                height:
                    AppSpacing.walletAddressActionSize +
                    AppSpacing.formFieldLabelGap,
                borderColor: color.withValues(alpha: .18),
                child: Icon(
                  _featureIcon(feature.phase),
                  color: color,
                  size: AppSpacing.x5,
                ),
              ),
              const SizedBox(width: AppSpacing.walletAssetHeroTopGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.marginTradingHubLineHeightTitle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    MarginHubPhaseBadge(label: feature.phase, color: color),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.ctaLoadingIcon),
          for (final item in feature.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: color,
                  size: AppSpacing.marginTradingHubFeatureCheckIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.marginTradingHubLineHeightBody,
                    ),
                  ),
                ),
              ],
            ),
            if (item != feature.items.last)
              const SizedBox(height: AppSpacing.x3),
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
      padding: AppSpacing.cardPadding,
      borderColor: _hubGreen.withValues(alpha: .24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _hubGreen,
                size:
                    AppSpacing.walletAddressActionSize +
                    AppSpacing.formFieldLabelGap,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compliance.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _hubGreen,
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.marginTradingHubLineHeightCaption,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.transferTileGap),
                    Text(
                      compliance.description,
                      style: AppTextStyles.captionSm.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.marginTradingHubLineHeightBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAssetSectionGap),
          GridView.builder(
            itemCount: compliance.regulations.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppSpacing.marginTradingHubComplianceGridColumns,
              mainAxisExtent: AppSpacing.marginTradingHubComplianceGridExtent,
              crossAxisSpacing:
                  AppSpacing.marginTradingHubComplianceGridCrossGap,
              mainAxisSpacing: AppSpacing.marginTradingHubComplianceGridMainGap,
            ),
            itemBuilder: (context, index) {
              return VitCard(
                variant: VitCardVariant.inner,
                alignment: Alignment.center,
                borderColor: _hubGreen.withValues(alpha: .24),
                child: Text(
                  '${compliance.regulations[index]} v',
                  style: AppTextStyles.captionSm.copyWith(
                    color: _hubGreen,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.marginTradingHubLineHeightTight,
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
