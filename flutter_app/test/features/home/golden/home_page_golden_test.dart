// Pixel baseline for lib/features/home/presentation/pages/home_page.dart —
// the canonical UI reference ("SC-007 HomePage", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md). Pinned at
// 360x800 (minimum supported phone size, matches the convention used by
// test/quality/page_rhythm_phone_visual_qa_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with the same Flutter version used
// in CI: `flutter test --update-goldens test/features/home/golden/`.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

void main() {
  Future<void> setViewport(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget appWith(HomeRepository repository) {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
      child: VitTradeApp(
        routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
      ),
    );
  }

  testWidgets('golden: Home data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(const MockHomeRepository(loadDelay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_data.png'),
    );
  });

  testWidgets('golden: Home loading state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(const MockHomeRepository(loadDelay: Duration(milliseconds: 500))),
    );
    await tester.pump();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_loading.png'),
    );

    await tester.pumpAndSettle();
  });

  testWidgets('golden: Home error state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(
        const MockHomeRepository(simulateError: true, loadDelay: Duration.zero),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_error.png'),
    );
  });
}
