import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

/// Direct smoke test for [MockHomeRepository]: exercises the single method
/// on [HomeRepository] (fetchHome) and pins the literal fixture values from
/// lib/features/home/data/home_mock_data.dart.
///
/// [MockHomeRepository] is the reference shape for async repository test
/// doubles across the app: a `loadDelay` knob (default 300ms, see
/// lib/features/home/data/repositories/mock_home_repository.dart:8-16) and a
/// `simulateError` knob. Tests always pass `Duration.zero` to keep this file
/// fast and deterministic.
///
/// Complements test/features/home/mock_home_repository_test.dart, which
/// asserts shape via isNotEmpty/greaterThan checks. This file pins the exact
/// fixture literals instead, so a silent copy/data regression fails loudly.
void main() {
  const repository = MockHomeRepository(loadDelay: Duration.zero);

  group('MockHomeRepository smoke test', () {
    test('fetchHome pins the portfolio balance fixture literals', () async {
      final snapshot = await repository.fetchHome();

      expect(snapshot, isA<HomeSnapshot>());
      expect(snapshot.totalBalance, 54276.79);
      expect(snapshot.totalBtc, 0.57133463);
      expect(snapshot.spotBalance, 37993.75);
      expect(snapshot.earnBalance, 10855.36);
      expect(snapshot.fundingBalance, 5427.68);
      expect(snapshot.dailyPnl, 1842.31);
      expect(snapshot.dailyPct, 3.52);
      expect(snapshot.notifications, 3);
      expect(snapshot.portfolioTrend7d, hasLength(7));
      expect(snapshot.portfolioTrend7d.last, snapshot.totalBalance);
    });

    test(
      'fetchHome pins the first announcement, quick action and next action',
      () async {
        final snapshot = await repository.fetchHome();

        expect(snapshot.announcements, hasLength(3));
        final announcement = snapshot.announcements.first;
        expect(announcement.id, 'btc-fee-campaign');
        expect(announcement.type, HomeAnnouncementType.campaign);
        expect(announcement.routePath, '/trade/btcusdt');

        expect(snapshot.quickActions, hasLength(9));
        expect(snapshot.productGroups, hasLength(4));
        final quickAction = snapshot.quickActions.first;
        expect(quickAction.icon, 'quickBuy');
        expect(quickAction.label, 'Mua nhanh');
        expect(quickAction.routePath, '/trade/btcusdt');

        final nextAction = snapshot.nextAction;
        expect(nextAction, isNotNull);
        expect(nextAction!.routePath, '/wallet/withdraw/USDT');
        expect(nextAction.ctaLabel, 'Tiếp tục');
      },
    );

    test('fetchHome pins recent products and the crypto pair list', () async {
      final snapshot = await repository.fetchHome();

      expect(snapshot.recentProducts, hasLength(4));
      expect(snapshot.recentProducts.first.id, 'spot-btc');
      expect(snapshot.recentProducts.first.routePath, '/trade/btcusdt');

      expect(snapshot.pairs, hasLength(10));
      final pair = snapshot.pairs.first;
      expect(pair.id, 'btcusdt');
      expect(pair.symbol, 'BTC/USDT');
      expect(pair.price, 67543.21);
      expect(pair.isFavorite, isTrue);
    });

    test('fetchHome throws a StateError when simulateError is set', () {
      const errorRepository = MockHomeRepository(
        simulateError: true,
        loadDelay: Duration.zero,
      );

      expect(errorRepository.fetchHome(), throwsA(isA<StateError>()));
    });
  });
}
