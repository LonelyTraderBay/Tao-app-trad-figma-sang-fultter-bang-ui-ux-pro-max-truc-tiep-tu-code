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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_contingency_plan_sections.dart';
part '../widgets/staking_contingency_plan_support_sections.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
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
      ),
    );
  }
}
