import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/complaints_handling_overview_header_tabs.dart';
part '../widgets/complaints_handling_overview_complaints.dart';
part '../widgets/complaints_handling_process_common.dart';

const _complaintsBorder = AppColors.borderSolid;
const _complaintsPrimary = AppColors.primary;
const _complaintsGreen = AppColors.buy;
const _complaintsAmber = AppColors.caution;
const _complaintsRed = AppColors.sell;

enum _ComplaintsTab { overview, myComplaints, process }

class ComplaintsHandlingPage extends ConsumerStatefulWidget {
  const ComplaintsHandlingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc111_complaints_content');
  static const submitKey = Key('sc111_submit_complaint');
  static Key tabKey(String tab) => Key('sc111_tab_$tab');
  static Key complaintKey(String id) => Key('sc111_complaint_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComplaintsHandlingPage> createState() =>
      _ComplaintsHandlingPageState();
}

class _ComplaintsHandlingPageState
    extends ConsumerState<ComplaintsHandlingPage> {
  _ComplaintsTab _tab = _ComplaintsTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getComplaintsHandling();
    return VitTradeHubScaffold(
      title: 'Complaints Handling',
      subtitle: 'FCA Regulated Process',
      semanticLabel: 'SC-111 ComplaintsHandlingPage',
      contentKey: ComplaintsHandlingPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Review',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.compact,
            title: 'Complaint process review',
            message:
                'Complaint status, evidence, escalation, response deadline and next steps are reviewed before submission.',
            contractId: 'complaints-handling-review',
          ),
        ),
        VitTradeComplianceSection(
          title: 'Complaint process',
          statusPill: const VitStatusPill(
            label: 'Regulated process',
            status: VitStatusPillStatus.warning,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Open cases',
              value: '${snapshot.complaints.length}',
            ),
            VitTradeComplianceItem(
              label: 'Response SLA',
              value: '${snapshot.averageResolutionDays} days avg',
            ),
          ],
        ),
        VitTradeSection(title: 'Rights', child: const _RightsNotice()),
        VitTradeSection(
          title: 'Complaints',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatsRow(snapshot: snapshot),
              const _SubmitComplaintButton(),
              _Tabs(
                active: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              VitPageSection(
                density: VitDensity.compact,
                children: [
                  if (_tab == _ComplaintsTab.overview)
                    _OverviewContent(snapshot: snapshot),
                  if (_tab == _ComplaintsTab.myComplaints)
                    _MyComplaintsContent(complaints: snapshot.complaints),
                  if (_tab == _ComplaintsTab.process)
                    _ProcessContent(snapshot: snapshot),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
