import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

part '../widgets/savings_history_page_sections.dart';
part '../widgets/savings_history_page_common.dart';

enum _HistoryTypeFilter { all, subscribe, redeem, interest, compound, early }

enum _HistoryDateFilter { d7, d30, d90, all }

class SavingsHistoryPage extends ConsumerStatefulWidget {
  const SavingsHistoryPage({super.key, this.shellRenderMode});

  static const firstTransactionKey = Key('sc334_first_transaction');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsHistoryPage> createState() => _SavingsHistoryPageState();
}

class _SavingsHistoryPageState extends ConsumerState<SavingsHistoryPage> {
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryDateFilter _dateFilter = _HistoryDateFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsHistoryRepositoryProvider).getHistory();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;
    final transactions = _filteredTransactions(
      snapshot.transactions,
      _typeFilter,
    );
    final grouped = _groupTransactions(transactions);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-334 SavingsHistoryPage',
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
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollTailReserve,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: [
                      VitCard(
                        variant: VitCardVariant.standard,
                        radius: VitCardRadius.standard,
                        padding: AppSpacing.zeroInsets,
                        child: _SummaryPills(snapshot: snapshot),
                      ),
                      _SearchField(placeholder: snapshot.searchPlaceholder),
                      _TypeFilterRow(
                        active: _typeFilter,
                        onChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _typeFilter = filter);
                        },
                      ),
                      _DateFilterRow(
                        active: _dateFilter,
                        onChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _dateFilter = filter);
                        },
                      ),
                      _ResultsHeader(count: transactions.length),
                      for (final group in grouped) ...[
                        _DateHeader(date: group.date),
                        for (final tx in group.transactions)
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              bottom: tx == group.transactions.last
                                  ? AppSpacing.x3
                                  : AppSpacing.x2,
                            ),
                            child: _TransactionCard(
                              key: tx == transactions.first
                                  ? SavingsHistoryPage.firstTransactionKey
                                  : null,
                              tx: tx,
                              receiptRoute: snapshot.receiptRoute,
                            ),
                          ),
                      ],
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
