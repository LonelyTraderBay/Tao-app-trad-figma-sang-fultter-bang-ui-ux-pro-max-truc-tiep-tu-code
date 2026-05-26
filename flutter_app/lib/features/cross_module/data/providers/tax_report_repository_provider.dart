import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_tax_report_repository.dart';

final taxReportRepositoryProvider = Provider<TaxReportRepository>((ref) {
  return const MockTaxReportRepository();
});
