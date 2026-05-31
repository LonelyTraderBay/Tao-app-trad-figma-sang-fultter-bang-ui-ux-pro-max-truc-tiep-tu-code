part of '../pages/copy_safety_center_page.dart';

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final TradeCopySafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 95),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: _safetyPrimary.withValues(alpha: .11),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _safetyPrimary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _safetyPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.onAccent,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.body.copyWith(
                    color: _safetyPrimary,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.heroDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _safetyPrimary,
                    fontSize: 10.5,
                    height: 1.25,
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
    return Container(
      height: 53,
      color: _safetyTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CopySafetyCenterPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _safetyPrimary
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 65 : 0,
                      height: 2,
                      color: _safetyPrimary,
                    ),
                  ],
                ),
              ),
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
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 19),
        for (final tier in snapshot.verificationTiers) ...[
          _VerificationTierCard(tier: tier),
          if (tier != snapshot.verificationTiers.last)
            const SizedBox(height: 18),
        ],
        const SizedBox(height: 29),
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
    return Container(
      constraints: BoxConstraints(
        minHeight: tier.tier == 'Basic'
            ? 207
            : tier.tier == 'Verified'
            ? 260
            : 296,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _safetyCard,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: color, size: 20),
              const SizedBox(width: 9),
              Text(
                tier.tier,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _ListBlock(label: 'Requirements:', items: tier.requirements),
          const SizedBox(height: 17),
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
      padding: const EdgeInsets.only(left: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                '${check ? '/' : '*'} $item',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ),
            if (item != items.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}
