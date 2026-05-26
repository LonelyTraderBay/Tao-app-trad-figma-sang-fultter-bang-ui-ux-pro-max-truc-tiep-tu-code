import 'package:vit_trade_flutter/features/cross_module/domain/entities/tax_report_entities.dart';

abstract interface class TaxReportRepository {
  TaxReportSnapshot getCenter();
}
