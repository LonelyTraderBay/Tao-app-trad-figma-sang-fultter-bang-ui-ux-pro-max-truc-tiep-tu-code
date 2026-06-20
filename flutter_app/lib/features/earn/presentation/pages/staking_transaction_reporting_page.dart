import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_transaction_reporting_summary_widgets.dart';
part '../widgets/staking_transaction_reporting_transaction_widgets.dart';
part '../widgets/staking_transaction_reporting_sheet_widgets.dart';

enum _ReportingTab { summary, transactions, export }

const double _transactionReportingVisualNavClearance = 112;
const double _transactionReportingNativeNavClearance = 88;
const double _transactionReportingControlExtent = 46;
const double _transactionReportingIconBox = 42;
const double _transactionReportingIndicatorExtent = 3;
const double _transactionReportingDividerExtent = 1;
const double _transactionReportingBodyLineHeight = 1.22;
const double _transactionReportingMetricLineHeight = 1.18;
const double _transactionReportingNoticeLineHeight = 1.2;
const double _transactionReportingMethodLineHeight = 1.2;
const EdgeInsets _transactionReportingCardPadding = EdgeInsets.all(
  AppSpacing.x3,
);

class StakingTransactionReportingPage extends ConsumerStatefulWidget {
  const StakingTransactionReportingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc378_info');
  static const selectorsKey = Key('sc378_selectors');
  static const tabsKey = Key('sc378_tabs');
  static const summaryKey = Key('sc378_summary');
  static const rewardsKey = Key('sc378_rewards');
  static const transactionsKey = Key('sc378_transactions');
  static const exportKey = Key('sc378_export');
  static const methodSheetKey = Key('sc378_method_sheet');
  static const exportSheetKey = Key('sc378_export_sheet');
  static const footerKey = Key('sc378_footer');

  static Key tabKey(String id) => Key('sc378_tab_$id');

  static Key methodKey(String id) => Key('sc378_method_$id');

  static Key exportOptionKey(String id) => Key('sc378_export_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTransactionReportingPage> createState() =>
      _StakingTransactionReportingPageState();
}

class _StakingTransactionReportingPageState
    extends ConsumerState<StakingTransactionReportingPage> {
  _ReportingTab _tab = _ReportingTab.summary;
  late String _year;
  late String _costBasis;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(stakingTransactionReportingRepositoryProvider)
        .getReporting();
    _year = snapshot.defaultYear;
    _costBasis = snapshot.defaultCostBasis;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingTransactionReportingRepositoryProvider)
        .getReporting();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _transactionReportingVisualNavClearance
            : _transactionReportingNativeNavClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-378 StakingTransactionReportingPage',
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    scrollEndPadding,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _Selectors(
                        snapshot: snapshot,
                        year: _year,
                        costBasis: _costBasis,
                        onYearChanged: (year) {
                          HapticFeedback.selectionClick();
                          setState(() => _year = year);
                        },
                        onOpenCostBasis: () => _openMethodSheet(snapshot),
                      ),
                      _ReportingTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _ReportingTab.summary)
                        _SummaryTab(snapshot: snapshot, costBasis: _costBasis)
                      else if (_tab == _ReportingTab.transactions)
                        _TransactionsTab(snapshot: snapshot)
                      else
                        _ExportTab(
                          snapshot: snapshot,
                          onOpenExport: () => _openExportSheet(snapshot),
                        ),
                      _FooterNote(note: snapshot.footerNote),
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

  Future<void> _openMethodSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(
        child: _MethodSheet(
          methods: snapshot.costBasisMethods,
          selected: _costBasis,
          onChanged: (method) {
            setState(() => _costBasis = method);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openExportSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _ExportSheet(snapshot: snapshot)),
    );
  }
}
