import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingContingencyPlanPage extends ConsumerWidget {
  const StakingContingencyPlanPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc386_info');
  static const metricsKey = Key('sc386_metrics');
  static const scenariosKey = Key('sc386_scenarios');
  static const validationKey = Key('sc386_validation');
  static const documentsKey = Key('sc386_documents');
  static const footerKey = Key('sc386_footer');

  static Key scenarioKey(String scenario) {
    return Key('sc386_scenario_${scenario.replaceAll(' ', '_')}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingContingencyPlanRepositoryProvider)
        .getContingencyPlan();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-386 StakingContingencyPlanPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _RecoveryMetrics(metrics: snapshot.metrics),
                    _ScenariosSection(scenarios: snapshot.scenarios),
                    _ValidationSection(
                      items: snapshot.validationItems,
                      body: snapshot.validationBody,
                    ),
                    _DocumentationSection(documents: snapshot.documents),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _ValidationSection extends StatelessWidget {
  const _ValidationSection({required this.items, required this.body});

  final List<StakingContingencyValidationDraft> items;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.validationKey,
      label: 'Testing & Validation',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items) _ValidationRow(item: item),
              Text(
                body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  const _ValidationRow({required this.item});

  final StakingContingencyValidationDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x3),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    item.dateLabel,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            Icon(
              item.tone == 'success'
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentationSection extends StatelessWidget {
  const _DocumentationSection({required this.documents});

  final List<StakingContingencyDocumentDraft> documents;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.documentsKey,
      label: 'Documentation',
      accentColor: AppColors.primarySoft,
      children: [
        for (final document in documents) _DocumentRow(document: document),
      ],
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final StakingContingencyDocumentDraft document;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${document.size} - Updated ${document.updatedLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingContingencyPlanPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.emphasis = false,
  });

  final String label;
  final Color color;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: emphasis ? 0.16 : 0.08),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: emphasis ? AppTextStyles.bold : AppTextStyles.normal,
        ),
      ),
    );
  }
}

Color _impactColor(String impact) {
  return switch (impact) {
    'Critical' => AppColors.sell,
    'High' => AppColors.warn,
    'Medium' => AppColors.primarySoft,
    _ => AppColors.text3,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppColors.text2,
  };
}
