import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/tax_report_repository.dart';

final class MockTaxReportRepository implements TaxReportRepository {
  const MockTaxReportRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('tax_report_mock_fetch_failed');
  }

  @override
  Future<TaxReportSnapshot> getCenter() async {
    await _simulateNetwork();
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
