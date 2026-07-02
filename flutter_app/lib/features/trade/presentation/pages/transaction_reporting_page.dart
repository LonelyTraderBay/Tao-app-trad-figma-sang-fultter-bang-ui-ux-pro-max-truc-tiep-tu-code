import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_actions.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_filters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_notice.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_reports.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_stats.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../widgets/trade_body_review_widgets.dart';

class TransactionReportingPage extends ConsumerStatefulWidget {
  const TransactionReportingPage({super.key, this.shellRenderMode});

  static const contentKey = transactionReportingContentKey;
  static const searchKey = transactionReportingSearchKey;

  static Key tabKey(String id) => transactionReportingTabKey(id);
  static Key actionKey(String id) => transactionReportingActionKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransactionReportingPage> createState() =>
      _TransactionReportingPageState();
}

class _TransactionReportingPageState
    extends ConsumerState<TransactionReportingPage> {
  String _tab = 'queue';
  String _query = '';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTransactionReporting();
    final reports = filterTransactionReports(
      snapshot: snapshot,
      tab: _tab,
      query: _query,
    );
    return Material(
      color: transactionReportBackground,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Transaction Reporting',
            subtitle: 'MiFID II - EMIR Compliance',
            semanticLabel: 'SC-093 TransactionReportingPage',
            contentKey: TransactionReportingPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            useCopyTradingInset: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            children: [
              VitTradeSection(
                title: 'Review',
                child: const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Review regulatory reporting queue',
                  message:
                      'Confirm report status, retry impact, and next steps before resubmitting transaction records.',
                ),
              ),
              VitTradeComplianceSection(
                title: 'Reporting status',
                statusPill: VitStatusPill(
                  label: 'Queue: ${snapshot.stats.pending}',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Confirmed',
                    value: '${snapshot.stats.confirmed}',
                  ),
                  VitTradeComplianceItem(
                    label: 'Failed',
                    value: '${snapshot.stats.failed}',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Queue',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TransactionReportingComplianceNotice(),
                    TransactionReportingStatsGrid(stats: snapshot.stats),
                    TransactionReportingSearchField(
                      query: _query,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    TransactionReportingTabs(
                      activeId: _tab,
                      stats: snapshot.stats,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    if (_tab == 'stats')
                      TransactionReportingStatsTab(stats: snapshot.stats)
                    else
                      TransactionReportsSection(
                        reports: reports,
                        query: _query,
                        onViewXml: (report) => setState(() {
                          _notice = 'ISO 20022 XML: ${report.id}';
                        }),
                        onRetry: (report) => setState(() {
                          _notice = 'Retry queued: ${report.id}';
                        }),
                        onCopy: (report) {
                          final messageId = report.messageId;
                          if (messageId == null) return;
                          Clipboard.setData(ClipboardData(text: messageId));
                          setState(() => _notice = 'Message ID copied');
                        },
                      ),
                    TransactionReportingQuickActions(
                      onDashboard: () => context.go(
                        AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
                      ),
                      onArmStatus: () => context.go(
                        AppRoutePaths.tradeCopyArmIntegrationStatus,
                      ),
                    ),
                    const TradeBodyReviewSection(
                      title: 'Reporting queue review',
                      message: 'Transaction reporting body reviewed',
                      detail:
                          'Queue, search, retry, copy, XML, notice, empty, and result states stay visible.',
                      primary:
                          'Compliance notice remains above queue and retry controls.',
                      secondary:
                          'Report actions keep message ID and status context visible.',
                      tertiary:
                          'Quick actions stay after queue state, not before required review.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_notice != null)
            TransactionReportingNoticePanel(
              text: _notice!,
              onClose: () => setState(() => _notice = null),
            ),
        ],
      ),
    );
  }
}
