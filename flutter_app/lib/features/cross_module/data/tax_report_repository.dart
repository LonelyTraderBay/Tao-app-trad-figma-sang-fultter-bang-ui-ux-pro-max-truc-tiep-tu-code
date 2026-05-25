import 'package:flutter_riverpod/flutter_riverpod.dart';

final taxReportRepositoryProvider = Provider<TaxReportRepository>((ref) {
  return const MockTaxReportRepository();
});

abstract interface class TaxReportRepository {
  TaxReportSnapshot getCenter();
}

enum TaxReportScreenState { loading, empty, error, offline }

enum TaxReportTab { generate, reports, settings }

enum TaxActivityModuleId { trading, p2p, predictions, dca, wallet, arena }

enum TaxExportFormat { pdf, csv, excel }

enum TaxReportStatus { ready, generating, error }

final class TaxReportSnapshot {
  const TaxReportSnapshot({
    required this.endpoint,
    required this.exportEndpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.activities,
    required this.reports,
    required this.jurisdictions,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String exportEndpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<TaxReportTabDraft> tabs;
  final List<TaxableActivityDraft> activities;
  final List<GeneratedTaxReportDraft> reports;
  final List<TaxJurisdictionDraft> jurisdictions;
  final String contractNotes;
  final Set<TaxReportScreenState> supportedStates;

  Iterable<TaxableActivityDraft> get taxableActivities =>
      activities.where((activity) => activity.taxable);

  int get totalGainLoss =>
      taxableActivities.fold(0, (sum, activity) => sum + activity.gainLoss);

  int get totalTransactions =>
      activities.fold(0, (sum, activity) => sum + activity.count);

  int get taxableModules => taxableActivities.length;
}

final class TaxReportTabDraft {
  const TaxReportTabDraft({required this.tab, required this.label});

  final TaxReportTab tab;
  final String label;
}

final class TaxableActivityDraft {
  const TaxableActivityDraft({
    required this.module,
    required this.moduleName,
    required this.count,
    required this.gainLoss,
    required this.taxable,
    this.note,
  });

  final TaxActivityModuleId module;
  final String moduleName;
  final int count;
  final int gainLoss;
  final bool taxable;
  final String? note;
}

final class GeneratedTaxReportDraft {
  const GeneratedTaxReportDraft({
    required this.id,
    required this.period,
    required this.dateRange,
    required this.format,
    required this.totalGainLoss,
    required this.transactionCount,
    required this.generatedAtLabel,
    required this.status,
  });

  final String id;
  final String period;
  final String dateRange;
  final TaxExportFormat format;
  final int totalGainLoss;
  final int transactionCount;
  final String generatedAtLabel;
  final TaxReportStatus status;
}

final class TaxJurisdictionDraft {
  const TaxJurisdictionDraft({required this.id, required this.label});

  final String id;
  final String label;
}

final class MockTaxReportRepository implements TaxReportRepository {
  const MockTaxReportRepository();

  @override
  TaxReportSnapshot getCenter() {
    return const TaxReportSnapshot(
      endpoint: '/api/mobile/cross-module/tax-reports',
      exportEndpoint: '/api/mobile/cross-module/tax-reports/exports',
      actionDraft: 'POST /exports',
      title: 'Tax Report Center',
      backRoute: '/home',
      tabs: [
        TaxReportTabDraft(tab: TaxReportTab.generate, label: 'Tao bao cao'),
        TaxReportTabDraft(tab: TaxReportTab.reports, label: 'Bao cao'),
        TaxReportTabDraft(tab: TaxReportTab.settings, label: 'Cai dat'),
      ],
      activities: [
        TaxableActivityDraft(
          module: TaxActivityModuleId.trading,
          moduleName: 'Spot Trading',
          count: 245,
          gainLoss: 3850,
          taxable: true,
        ),
        TaxableActivityDraft(
          module: TaxActivityModuleId.p2p,
          moduleName: 'P2P Transactions',
          count: 28,
          gainLoss: 125,
          taxable: true,
        ),
        TaxableActivityDraft(
          module: TaxActivityModuleId.predictions,
          moduleName: 'Prediction Markets',
          count: 87,
          gainLoss: 780,
          taxable: true,
        ),
        TaxableActivityDraft(
          module: TaxActivityModuleId.dca,
          moduleName: 'DCA Purchases',
          count: 12,
          gainLoss: 1200,
          taxable: true,
        ),
        TaxableActivityDraft(
          module: TaxActivityModuleId.wallet,
          moduleName: 'Wallet Deposits/Withdrawals',
          count: 45,
          gainLoss: 0,
          taxable: false,
        ),
        TaxableActivityDraft(
          module: TaxActivityModuleId.arena,
          moduleName: 'Arena Points (Non-taxable)',
          count: 32,
          gainLoss: 0,
          taxable: false,
          note:
              'Arena Points are not financial assets and typically not taxable',
        ),
      ],
      reports: [
        GeneratedTaxReportDraft(
          id: 'r1',
          period: '2024 Tax Year',
          dateRange: 'Jan 1, 2024 - Dec 31, 2024',
          format: TaxExportFormat.pdf,
          totalGainLoss: 5955,
          transactionCount: 372,
          generatedAtLabel: 'Generated 20 thg 5',
          status: TaxReportStatus.ready,
        ),
        GeneratedTaxReportDraft(
          id: 'r2',
          period: 'Q4 2024',
          dateRange: 'Oct 1, 2024 - Dec 31, 2024',
          format: TaxExportFormat.csv,
          totalGainLoss: 1850,
          transactionCount: 128,
          generatedAtLabel: 'Generated 10 thg 5',
          status: TaxReportStatus.ready,
        ),
        GeneratedTaxReportDraft(
          id: 'r3',
          period: 'Q3 2024',
          dateRange: 'Jul 1, 2024 - Sep 30, 2024',
          format: TaxExportFormat.excel,
          totalGainLoss: 1420,
          transactionCount: 95,
          generatedAtLabel: 'Generated 25 thg 4',
          status: TaxReportStatus.ready,
        ),
      ],
      jurisdictions: [
        TaxJurisdictionDraft(id: 'us', label: 'United States (IRS)'),
        TaxJurisdictionDraft(id: 'uk', label: 'United Kingdom (HMRC)'),
        TaxJurisdictionDraft(id: 'ca', label: 'Canada (CRA)'),
        TaxJurisdictionDraft(id: 'au', label: 'Australia (ATO)'),
        TaxJurisdictionDraft(id: 'sg', label: 'Singapore (IRAS)'),
        TaxJurisdictionDraft(id: 'other', label: 'Other'),
      ],
      contractNotes:
          'Tax reports aggregate value-based modules only. Arena Points stay non-taxable/points-only and must not be presented as wallet value, payout, profit, or stake return.',
      supportedStates: {
        TaxReportScreenState.loading,
        TaxReportScreenState.empty,
        TaxReportScreenState.error,
        TaxReportScreenState.offline,
      },
    );
  }
}
