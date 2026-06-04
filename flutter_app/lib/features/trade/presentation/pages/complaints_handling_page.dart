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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/complaints_handling_overview_header_tabs.dart';
part '../widgets/complaints_handling_overview_complaints.dart';
part '../widgets/complaints_handling_process_common.dart';

const _complaintsBackground = AppColors.bg;
const _complaintsPanel = AppColors.surface;
const _complaintsPanel2 = AppColors.surface2;
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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-111 ComplaintsHandlingPage',
      child: Material(
        color: _complaintsBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Complaints Handling',
            subtitle: 'FCA Regulated Process',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ComplaintsHandlingPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _RightsNotice(),
                      const SizedBox(height: 36),
                      _StatsRow(snapshot: snapshot),
                      const SizedBox(height: 25),
                      const _SubmitComplaintButton(),
                      const SizedBox(height: 25),
                      _Tabs(
                        active: _tab,
                        onChanged: (tab) => setState(() => _tab = tab),
                      ),
                      const SizedBox(height: 26),
                      if (_tab == _ComplaintsTab.overview)
                        _OverviewContent(snapshot: snapshot),
                      if (_tab == _ComplaintsTab.myComplaints)
                        _MyComplaintsContent(complaints: snapshot.complaints),
                      if (_tab == _ComplaintsTab.process)
                        _ProcessContent(snapshot: snapshot),
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
