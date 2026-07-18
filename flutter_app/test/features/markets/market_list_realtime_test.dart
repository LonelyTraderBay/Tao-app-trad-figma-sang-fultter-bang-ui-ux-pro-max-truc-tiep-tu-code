// GD4 Cụm F7 (REALTIME): UI test cho lớp cập-nhật-đè trên hàng BTC của
// SC-008 (Danh sách thị trường) — override `marketTickerStreamProvider`
// bằng `StreamController` thủ công (bẫy GD4 mock stream #30: gọi trực tiếp
// mock có `tickInterval` thật trong `testWidgets()` có thể treo vô thời
// hạn nếu không đẩy đúng fake clock) để kiểm soát chính xác thời điểm phát
// tick, không phụ thuộc `Stream.periodic` thật.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

void main() {
  testWidgets(
    'SC-008 hàng BTC cập nhật giá khi marketTickerStreamProvider phát tick',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = StreamController<List<MarketPair>>();
      addTearDown(controller.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            marketTickerStreamProvider.overrideWith((ref) => controller.stream),
          ],
          child: VitTradeApp(
            routerConfig: createAppRouter(
              initialLocation: AppRoutePaths.markets,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trước tick đầu: giá tĩnh từ marketListSnapshotProvider (fixture gốc).
      expect(find.text('67,543.21'), findsOneWidget);
      expect(find.text('68,000.50'), findsNothing);

      controller.add(const [
        MarketPair(
          id: 'btcusdt',
          symbol: 'BTC/USDT',
          baseAsset: 'BTC',
          quoteAsset: 'USDT',
          price: 68000.5,
          prevPrice: 67543.21,
          change24h: 2.34,
          high24h: 68100,
          low24h: 65800,
          volume24h: 23456789000,
          marketCap: 1324567890000,
          sparklineData: [],
          isFavorite: true,
          category: 'Layer 1',
        ),
      ]);
      // StreamController.add() giao event qua microtask (frame 1 xử lý
      // microtask + markNeedsBuild, frame 2 mới thật sự rebuild widget) —
      // 2 lần pump() không-duration, không phải pumpAndSettle (tránh phụ
      // thuộc hasScheduledFrame với 1 sự kiện thủ công duy nhất).
      await tester.pump();
      await tester.pump();

      // Sau tick: hàng BTC đè bằng giá sống, giá tĩnh cũ không còn hiển thị.
      expect(find.text('68,000.50'), findsOneWidget);
      expect(find.text('67,543.21'), findsNothing);
    },
  );
}
