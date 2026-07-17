import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_errors.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/tax_report_repository.dart';

final class FailClosedTaxReportRepository implements TaxReportRepository {
  const FailClosedTaxReportRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const TaxReportBackendContractMissingException();
  }
}
