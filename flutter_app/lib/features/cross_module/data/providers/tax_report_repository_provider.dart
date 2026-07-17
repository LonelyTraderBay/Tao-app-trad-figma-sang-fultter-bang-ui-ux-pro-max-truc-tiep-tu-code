import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/fail_closed_tax_report_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_tax_report_repository.dart';

final taxReportRepositoryProvider = Provider<TaxReportRepository>((ref) {
  return guardedRepository(
    ref,
    featureName: 'TaxReport',
    mock: () => const MockTaxReportRepository(),
    failClosed: () => const FailClosedTaxReportRepository(),
  );
});
