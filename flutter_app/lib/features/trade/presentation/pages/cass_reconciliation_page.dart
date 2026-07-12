import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

part '../widgets/cass_reconciliation_summary_tabs.dart';
part '../widgets/cass_reconciliation_records_common.dart';

const _cassPanel2 = AppColors.surface2;
const _cassBorder = AppColors.borderSolid;
const _cassPrimary = AppColors.primary;
const _cassGreen = AppColors.buy;
const _cassAmber = AppColors.caution;
const _cassRed = AppColors.sell;
const _cassSpace = AppSpacing.x2;
const _cassTinySpace = AppSpacing.x1;
const _recordIconTile = 34.0;
const _exportButtonHeight = 44.0;
const _cassLineTight = 1.2;

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
    return VitTradeHubScaffold(
      title: 'CASS Reconciliation',
      subtitle: 'Daily Client Money Matching',
      semanticLabel: 'SC-103 CASSReconciliationPage',
      contentKey: CassReconciliationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyClientMoneyProtection),
      useCopyTradingInset: true,
      children: [
        VitTradeComplianceSection(
          title: 'CASS status',
          statusPill: VitStatusPill(
            label: '${snapshot.outstandingCount} outstanding',
            status: snapshot.outstandingCount == 0
                ? VitStatusPillStatus.success
                : VitStatusPillStatus.warning,
            size: VitStatusPillSize.sm,
          ),
          items: [
            VitTradeComplianceItem(
              label: 'Reconciled',
              value: '${snapshot.reconciledCount}',
            ),
            VitTradeComplianceItem(
              label: 'Records',
              value: '${snapshot.records.length}',
            ),
          ],
        ),
        VitTradeSection(
          title: 'Reconciliation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Review CASS reconciliation evidence',
                message:
                    'Confirm client-money balances, discrepancy status, limits, and next steps before export or escalation.',
                density: VitDensity.compact,
              ),
              _SummaryGrid(snapshot: snapshot),
              _Tabs(activeId: _tab, onChanged: _setTab),
              const _SectionLabel('Reconciliation Records'),
              for (final record in snapshot.records)
                _RecordCard(record: record),
              const _ExportButton(),
            ],
          ),
        ),
      ],
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
