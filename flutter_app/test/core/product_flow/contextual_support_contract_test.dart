import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';

void main() {
  test('contextual support registry covers required recovery flows', () {
    final flows = ContextualSupportContracts.contracts
        .map((contract) => contract.flow)
        .toSet();

    expect(flows, containsAll(ContextualSupportContracts.requiredFlows));
  });

  test('support route builder carries flow, reference, and source context', () {
    final route = ContextualSupportContracts.supportRouteFor(
      ContextualSupportFlow.p2pOrder,
      referenceId: 'order001',
      sourceRoute: '/p2p/order/order001',
      issueLabel: 'Escrow release delayed',
    );

    final uri = Uri.parse(route);

    expect(uri.path, '/support');
    expect(uri.queryParameters['flow'], 'p2p_order');
    expect(uri.queryParameters['ref'], 'order001');
    expect(uri.queryParameters['source'], '/p2p/order/order001');
    expect(uri.queryParameters['issue'], 'Escrow release delayed');
  });

  test('query parsing restores a safe product support context', () {
    final context = ProductSupportContext.fromQuery({
      'flow': 'staking',
      'ref': 'pos001',
      'source': '/earn/history',
    });

    expect(context, isNotNull);
    expect(context!.flow, ContextualSupportFlow.staking);
    expect(context.productArea, 'Earn and Savings');
    expect(context.referenceId, 'pos001');
    expect(context.sourceRoute, '/earn/history');
    expect(context.timelineLabels, hasLength(3));
  });

  test('query parsing rejects unknown flows and unsafe source routes', () {
    expect(ProductSupportContext.fromQuery({'flow': 'unknown'}), isNull);

    final context = ProductSupportContext.fromQuery({
      'flow': 'security',
      'source': 'https://example.test/phishing',
    });

    expect(context, isNotNull);
    expect(context!.sourceRoute, isNull);
  });
}
