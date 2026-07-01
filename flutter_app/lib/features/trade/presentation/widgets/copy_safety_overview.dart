part of '../pages/copy_safety_center_page.dart';

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      constraints: const BoxConstraints(minHeight: _safetyHeroMinHeight),
      padding: AppSpacing.copySafetyHeroPadding,
      borderColor: _safetyPrimary,
      child: Row(
        children: [
          const VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.large,
            width: AppSpacing.walletTokenHeroIcon,
            height: AppSpacing.walletTokenHeroIcon,
            borderColor: _safetyPrimary,
            alignment: Alignment.center,
            child: Icon(
              Icons.shield_outlined,
              color: _safetyPrimary,
              size: AppSpacing.walletTokenHeroIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.body.copyWith(
                    color: _safetyPrimary,
                    fontWeight: AppTextStyles.bold,
                    height: _safetyHeroLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _safetyPrimary,
                    height: _safetyBodyLineHeight,
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

class _SafetyTabs extends StatelessWidget {
  const _SafetyTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeCopySafetyCenterTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      height: _safetyTabsHeight,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.label,
              widgetKey: CopySafetyCenterPage.tabKey(tab.id),
            ),
        ],
      ),
    );
  }
}

class _SafetyTabBody extends StatelessWidget {
  const _SafetyTabBody({
    required this.activeTabId,
    required this.snapshot,
    required this.expandedMetric,
    required this.onMetricToggle,
    required this.onEmergency,
  });

  final String activeTabId;
  final TradeCopySafetyCenterSnapshot snapshot;
  final String? expandedMetric;
  final ValueChanged<String> onMetricToggle;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context) {
    return switch (activeTabId) {
      'metrics' => _MetricsTab(
        metrics: snapshot.trustMetrics,
        expandedMetric: expandedMetric,
        onMetricToggle: onMetricToggle,
      ),
      'guidelines' => _GuidelinesTab(snapshot: snapshot),
      'tools' => _ToolsTab(
        tools: snapshot.safetyTools,
        onEmergency: onEmergency,
      ),
      'enforcement' => _EnforcementTab(actions: snapshot.enforcementActions),
      _ => _VerificationTab(snapshot: snapshot),
    };
  }
}

class _VerificationTab extends StatelessWidget {
  const _VerificationTab({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.verificationIntro,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: _safetyReadableLineHeight,
          ),
        ),
        const SizedBox(height: _safetyCardSpace),
        for (final tier in snapshot.verificationTiers) ...[
          _VerificationTierCard(tier: tier),
          if (tier != snapshot.verificationTiers.last)
            const SizedBox(height: _safetyCardSpace),
        ],
        const SizedBox(height: _safetyCardSpace),
        _WarningCard(text: snapshot.warningText),
      ],
    );
  }
}

class _VerificationTierCard extends StatelessWidget {
  const _VerificationTierCard({required this.tier});

  final TradeCopyVerificationTier tier;

  @override
  Widget build(BuildContext context) {
    final color = Color(tier.colorHex);
    return VitCard(
      density: VitDensity.compact,
      constraints: BoxConstraints(minHeight: _safetyTierMinHeight),
      padding: AppSpacing.copySafetyTierPadding,
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: color,
                size: AppSpacing.copySafetyTierIcon,
              ),
              const SizedBox(width: _safetySpace),
              Text(
                tier.tier,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: _safetyHeroLineHeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: _safetySpace),
          _ListBlock(label: 'Requirements:', items: tier.requirements),
          const SizedBox(height: _safetySpace),
          _ListBlock(label: 'Benefits:', items: tier.benefits, check: true),
        ],
      ),
    );
  }
}

class _ListBlock extends StatelessWidget {
  const _ListBlock({
    required this.label,
    required this.items,
    this.check = false,
  });

  final String label;
  final List<String> items;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.copySafetyListIndentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: _safetyHeroLineHeight,
            ),
          ),
          const SizedBox(height: _safetySpace),
          for (final item in items) ...[
            Padding(
              padding: AppSpacing.copySafetyListItemPadding,
              child: Text(
                '${check ? '/' : '*'} $item',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: _safetyBodyLineHeight,
                ),
              ),
            ),
            if (item != items.last) const SizedBox(height: _safetySpace),
          ],
        ],
      ),
    );
  }
}
