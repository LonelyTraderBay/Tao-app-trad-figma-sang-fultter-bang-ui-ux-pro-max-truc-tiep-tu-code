import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_actions.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_filters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_notice.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_reports.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/transaction_reporting_stats.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-093 TransactionReportingPage',
      child: Material(
        color: transactionReportBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Transaction Reporting',
                subtitle: 'MiFID II - EMIR Compliance',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: TransactionReportingPage.contentKey,
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TransactionReportingComplianceNotice(),
                          const SizedBox(height: 14),
                          TransactionReportingStatsGrid(stats: snapshot.stats),
                          const SizedBox(height: 14),
                          TransactionReportingSearchField(
                            query: _query,
                            onChanged: (value) =>
                                setState(() => _query = value),
                          ),
                          const SizedBox(height: 14),
                          TransactionReportingTabs(
                            activeId: _tab,
                            stats: snapshot.stats,
                            onChanged: (id) => setState(() => _tab = id),
                          ),
                          const SizedBox(height: 16),
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
                                Clipboard.setData(
                                  ClipboardData(text: messageId),
                                );
                                setState(() => _notice = 'Message ID copied');
                              },
                            ),
                          const SizedBox(height: 14),
                          TransactionReportingQuickActions(
                            onDashboard: () => context.go(
                              AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
                            ),
                            onArmStatus: () => context.go(
                              AppRoutePaths.tradeCopyArmIntegrationStatus,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_notice != null)
              TransactionReportingNoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}
