part of '../pages/staking_contingency_plan_page.dart';

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingContingencyPlanSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingContingencyPlanPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _RecoveryMetrics extends StatelessWidget {
  const _RecoveryMetrics({required this.metrics});

  final List<StakingContingencyMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingContingencyPlanPage.metricsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Recovery Metrics', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              childAspectRatio: 2.55,
            ),
            itemBuilder: (context, index) {
              return _MetricTile(metric: metrics[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final StakingContingencyMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(metric.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: metric.tone == 'success' ? AppColors.buy20 : null,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            metric.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: metric.tone == 'success' ? color : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenariosSection extends StatelessWidget {
  const _ScenariosSection({required this.scenarios});

  final List<StakingContingencyScenarioDraft> scenarios;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.scenariosKey,
      label: 'Contingency Scenarios',
      accentColor: AppColors.primarySoft,
      children: [
        for (final scenario in scenarios) _ScenarioCard(scenario: scenario),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final StakingContingencyScenarioDraft scenario;

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(scenario.impact);
    return VitCard(
      key: StakingContingencyPlanPage.scenarioKey(scenario.scenario),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(scenario.scenario, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _Pill(label: scenario.likelihood, color: AppColors.text3),
              _Pill(
                label: '${scenario.impact} Impact',
                color: impactColor,
                emphasis: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Immediate Response',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (var i = 0; i < scenario.response.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: AppSpacing.x5,
                          child: Text(
                            '${i + 1}.',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            scenario.response[i],
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Preventative Measures',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final measure in scenario.preventative)
                _Pill(label: measure, color: AppColors.buy, emphasis: true),
            ],
          ),
        ],
      ),
    );
  }
}
