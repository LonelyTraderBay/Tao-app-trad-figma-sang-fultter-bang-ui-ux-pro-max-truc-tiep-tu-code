import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/regulatory_inspection_ready_page_sections.dart';
part '../widgets/regulatory_inspection_ready_page_common.dart';

const _inspectionBackground = AppColors.bg;
const _inspectionPanel = AppColors.surface;
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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-116 RegulatoryInspectionReadyPage',
      child: Material(
        color: _inspectionBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Regulatory Compliance',
              subtitle: 'Inspection Ready Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              trailing: const _HeaderDownloadButton(),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ComplianceScoreCard(snapshot: snapshot),
                    const SizedBox(height: 25),
                    _QuickStats(stats: snapshot.stats),
                    const SizedBox(height: 25),
                    const _SectionLabel('Regulatory Framework Coverage'),
                    const SizedBox(height: 12),
                    for (final framework in snapshot.frameworks) ...[
                      _FrameworkCard(framework: framework),
                      if (framework != snapshot.frameworks.last)
                        const SizedBox(height: 14),
                    ],
                    const SizedBox(height: 25),
                    const _SectionLabel('Document Repository'),
                    const SizedBox(height: 12),
                    for (final document in snapshot.documents) ...[
                      _DocumentCard(document: document),
                      if (document != snapshot.documents.last)
                        const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 25),
                    const _SectionLabel('Regulatory Inspector Access'),
                    const SizedBox(height: 12),
                    _InspectorPortalCard(snapshot: snapshot),
                    const SizedBox(height: 26),
                    _ReportButton(snapshot: snapshot),
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
