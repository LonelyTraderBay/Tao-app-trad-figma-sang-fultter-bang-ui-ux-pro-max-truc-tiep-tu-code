import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';

/// Data source contract for the tax report (cross-module) center.
abstract interface class TaxReportRepository {
  TaxReportSnapshot getCenter();
}
