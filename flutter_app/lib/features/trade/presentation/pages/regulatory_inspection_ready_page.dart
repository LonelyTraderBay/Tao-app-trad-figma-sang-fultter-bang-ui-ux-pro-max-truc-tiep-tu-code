import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/regulatory_inspection_ready_page_sections.dart';
part '../widgets/regulatory_inspection_ready_page_common.dart';

const _inspectionBackground = AppColors.bg;
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
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-116 RegulatoryInspectionReadyPage',
      child: Material(
        color: _inspectionBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Regulatory Compliance',
            subtitle: 'Inspection Ready Dashboard',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            actions: const [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: null,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.rowPy,
                    right: AppSpacing.contentPad,
                    bottom: scrollClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        density: VitDensity.compact,
                        title: 'Review inspection readiness evidence',
                        message:
                            'Confirm report scope, access limits, retained records, and next steps before sharing compliance material.',
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
