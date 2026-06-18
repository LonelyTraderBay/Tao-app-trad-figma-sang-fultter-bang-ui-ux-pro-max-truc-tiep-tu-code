import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/cass_reconciliation_summary_tabs.dart';
part '../widgets/cass_reconciliation_records_common.dart';

const _cassBackground = AppColors.bg;
const _cassPanel2 = AppColors.surface2;
const _cassBorder = AppColors.borderSolid;
const _cassPrimary = AppColors.primary;
const _cassGreen = AppColors.buy;
const _cassAmber = AppColors.caution;
const _cassRed = AppColors.sell;

class CassReconciliationPage extends ConsumerStatefulWidget {
  const CassReconciliationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc103_cass_content');
  static const exportKey = Key('sc103_cass_export');
  static Key tabKey(String id) => Key('sc103_cass_tab_$id');
  static Key recordKey(String id) => Key('sc103_cass_record_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CassReconciliationPage> createState() =>
      _CassReconciliationPageState();
}

class _CassReconciliationPageState
    extends ConsumerState<CassReconciliationPage> {
  String _tab = 'recent';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCassReconciliation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-103 CASSReconciliationPage',
      child: Material(
        color: _cassBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'CASS Reconciliation',
            subtitle: 'Daily Client Money Matching',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.tradeCopyClientMoneyProtection),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CassReconciliationPage.contentKey,
                  padding: AppSpacing.tradeBotScrollPaddingWithBottom(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: AppSpacing.tradeBotPageTopGap,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review CASS reconciliation evidence',
                        message:
                            'Confirm client-money balances, discrepancy status, limits, and next steps before export or escalation.',
                      ),
                      _SummaryGrid(snapshot: snapshot),
                      _Tabs(activeId: _tab, onChanged: _setTab),
                      const _SectionLabel('Reconciliation Records'),
                      for (final record in snapshot.records)
                        _RecordCard(record: record),
                      const _ExportButton(),
                      const TradeBodyReviewSection(
                        title: 'CASS body review',
                        message: 'CASS reconciliation body reviewed',
                        detail:
                            'Summary, tabs, records, export, discrepancy, empty, and result states stay visible.',
                        primary:
                            'Client-money evidence remains above reconciliation records.',
                        secondary:
                            'Record status and discrepancy context stay visible before export.',
                        tertiary:
                            'Export remains framed as compliance evidence, not execution.',
                      ),
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

  void _setTab(String id) => setState(() => _tab = id);
}
