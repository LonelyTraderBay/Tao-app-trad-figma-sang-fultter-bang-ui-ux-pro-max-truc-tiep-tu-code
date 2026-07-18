/// UI state the tax report screen supports rendering.
enum TaxReportScreenState { loading, empty, error, offline }

/// The active tab on the tax report screen.
enum TaxReportTab { generate, reports, settings }

/// A product module whose activity can be included in a tax report.
enum TaxActivityModuleId { trading, p2p, predictions, dca, wallet, arena }

/// File format a generated tax report can be exported as.
enum TaxExportFormat { pdf, csv, excel }

/// Generation status of a [GeneratedTaxReportDraft].
enum TaxReportStatus { ready, generating, error }

/// Data for the tax report screen: taxable [activities] across modules,
/// previously generated [reports], and supported [jurisdictions].
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

/// One selectable [TaxReportTab] entry with its display label.
final class TaxReportTabDraft {
  const TaxReportTabDraft({required this.tab, required this.label});

  final TaxReportTab tab;
  final String label;
}

/// One module's taxable-activity summary (count, gain/loss, taxable flag)
/// shown on the tax report screen.
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

/// One previously generated tax report (period, format, totals, status).
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

/// One selectable tax jurisdiction option on the tax report screen.
final class TaxJurisdictionDraft {
  const TaxJurisdictionDraft({required this.id, required this.label});

  final String id;
  final String label;
}
