import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/regulatory_inspection_ready_page_sections.dart';
part '../widgets/regulatory_inspection_ready_page_common.dart';

const _inspectionPanel2 = AppColors.surface2;
const _inspectionBorder = AppColors.borderSolid;
const _inspectionGreen = AppColors.buy;
const _inspectionPrimary = AppColors.primary;
const _inspectionAmber = AppColors.caution;

class RegulatoryInspectionReadyPage extends ConsumerWidget {
  const RegulatoryInspectionReadyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc116_regulatory_inspection_content');
  static const reportKey = Key('sc116_regulatory_inspection_report');
  static const portalKey = Key('sc116_regulatory_inspection_portal');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getRegulatoryInspectionReady();
    return VitTradeHubScaffold(
      title: 'Regulatory Compliance',
      subtitle: 'Inspection Ready Dashboard',
      semanticLabel: 'SC-116 RegulatoryInspectionReadyPage',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      headerActions: [
        VitHeaderActionItem(type: VitHeaderActionType.export, onPressed: null),
      ],
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.compact,
            title: 'Review inspection readiness evidence',
            message:
                'Confirm report scope, access limits, retained records, and next steps before sharing compliance material.',
          ),
        ),
        VitTradeComplianceSection(
          title: 'Inspection status',
          statusPill: VitStatusPill(
            label: 'Score ${snapshot.complianceScore}',
            status: VitStatusPillStatus.success,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Frameworks',
              value: '${snapshot.frameworks.length} covered',
            ),
            VitTradeComplianceItem(
              label: 'Documents',
              value: '${snapshot.documents.length} retained',
            ),
          ],
        ),
        VitTradeSection(
          title: 'Readiness',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ComplianceScoreCard(snapshot: snapshot),
              _QuickStats(stats: snapshot.stats),
              const _SectionLabel('Regulatory Framework Coverage'),
              for (final framework in snapshot.frameworks)
                _FrameworkCard(framework: framework),
              const _SectionLabel('Document Repository'),
              for (final document in snapshot.documents)
                _DocumentCard(document: document),
              const _SectionLabel('Regulatory Inspector Access'),
              _InspectorPortalCard(snapshot: snapshot),
              _ReportButton(snapshot: snapshot),
            ],
          ),
        ),
      ],
    );
  }
}
