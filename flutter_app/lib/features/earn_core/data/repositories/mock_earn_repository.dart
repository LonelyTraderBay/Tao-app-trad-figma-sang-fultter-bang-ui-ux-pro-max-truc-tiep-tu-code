/// DEBT-87 (A-Plus GĐ3): lớp fixture mock "god-family chấp nhận được" —
/// 26 part-file / ~11k dòng data tĩnh phục vụ giai đoạn mock-UI, SẼ ĐƯỢC
/// THAY bằng repository backend thật khi có DEC-backend. Quy ước:
/// - KHÔNG refactor cấu trúc family này (tách/gộp part) — công sức đổ vào
///   lớp sẽ bị thay thế là lãng phí;
/// - KHÔNG thêm logic hiển thị vào đây — mock chỉ trả data, mọi logic
///   trình bày thuộc presentation/controller;
/// - Kích thước family bị đóng băng bởi
///   test/quality/mock_fixture_baseline_guardrail_test.dart (chỉ được
///   giảm hoặc tăng trong dung sai) — phình thêm là tín hiệu logic đang
///   chảy nhầm tầng. Xem thêm docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md.
library;

import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/repositories/earn_repository.dart';

part '../fixtures/mock_staking_earn_repository.dart';
part '../fixtures/mock_savings_portfolio_repository.dart';
part '../fixtures/mock_savings_guide_repository.dart';
part '../fixtures/mock_savings_notifications_repository.dart';
part '../fixtures/mock_savings_risk_assessment_repository.dart';
part '../fixtures/mock_staking_risk_assessment_repository.dart';
part '../fixtures/mock_staking_analytics_repository.dart';
part '../fixtures/mock_staking_validator_selection_repository.dart';
part '../fixtures/mock_staking_insurance_fund_transparency_repository.dart';
part '../fixtures/mock_staking_api_documentation_repository.dart';
part '../fixtures/mock_staking_risk_dashboard_repository.dart';
part '../fixtures/mock_staking_emergency_actions_repository.dart';
part '../fixtures/mock_staking_voting_repository.dart';
part '../fixtures/mock_staking_advanced_orders_repository.dart';
part '../fixtures/mock_staking_guide_repository.dart';
part '../fixtures/mock_staking_recommendations_repository.dart';
part '../fixtures/mock_staking_custody_repository.dart';
part '../fixtures/mock_auto_compound_settings_repository.dart';
part '../fixtures/mock_savings_auto_rebalance_repository.dart';
part '../fixtures/mock_savings_dca_repository.dart';
part '../fixtures/mock_savings_export_repository.dart';
part '../fixtures/mock_savings_backtest_repository.dart';
part '../fixtures/mock_savings_auto_pilot_repository.dart';
part '../fixtures/mock_savings_what_if_repository.dart';
part '../fixtures/mock_staking_risk_disclosure_repository.dart';
part '../fixtures/mock_staking_tax_guide_repository.dart';

/// Shared base for every mock Earn repository (GD4 async playbook mục 2/12):
/// carries `simulateError`/`loadDelay` and the network-simulation helper so
/// all 68 standalone mock classes across `../fixtures/*.dart` (part files of
/// this library) can extend it without repeating the boilerplate.
abstract class _MockEarnRepositoryBase {
  const _MockEarnRepositoryBase({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) throw StateError('earn_mock_fetch_failed');
  }
}
