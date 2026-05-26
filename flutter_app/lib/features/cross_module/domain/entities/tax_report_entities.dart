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
