import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/providers/p2p_repository_provider.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/repositories/mock_p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_entities.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('sibling repository providers alias the composite P2PRepository', () {
    final composite = container.read(p2pRepositoryProvider);
    expect(composite, isA<MockP2PRepository>());
    expect(composite, same(container.read(p2pMarketplaceRepositoryProvider)));
    expect(composite, same(container.read(p2pOrdersRepositoryProvider)));
    expect(composite, same(container.read(p2pAccountRepositoryProvider)));
    expect(composite, same(container.read(p2pTrustRepositoryProvider)));
  });

  test('each sibling provider exposes its slice methods', () async {
    final marketplace = container.read(p2pMarketplaceRepositoryProvider);
    final orders = container.read(p2pOrdersRepositoryProvider);
    final account = container.read(p2pAccountRepositoryProvider);
    final trust = container.read(p2pTrustRepositoryProvider);

    expect(await marketplace.getGuide(), isA<P2PGuideSnapshot>());
    expect(await orders.getMyOrders(), isA<P2PMyOrdersSnapshot>());
    expect(await account.getKycStatus(), isA<P2PKycStatusSnapshot>());
    expect(await trust.getDisputes(), isA<P2PDisputesSnapshot>());
  });
}
