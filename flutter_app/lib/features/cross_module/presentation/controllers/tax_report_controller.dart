import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';

export 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';
export 'package:vit_trade_flutter/features/cross_module/domain/repositories/tax_report_repository.dart';

final class TaxReportViewState {
  const TaxReportViewState({required this.snapshot});

  final TaxReportSnapshot snapshot;
}

final class TaxReportController {
  const TaxReportController({required this.state});

  final TaxReportViewState state;

  bool supportsFormat(TaxExportFormat format) {
    return TaxExportFormat.values.contains(format);
  }
}
