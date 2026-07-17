import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  for (final viewport in _responsiveViewports) {
    testWidgets(
      'UI-05 priority routes render without layout errors at ${viewport.label}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(
          viewport.width.toDouble(),
          viewport.height.toDouble(),
        );
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        final failures = <String>[];
        for (final route in _filteredPriorityRoutes) {
          await _scanRoute(tester, viewport, route, failures);
        }

        if (failures.isNotEmpty) {
          fail(
            'Responsive visual QA failures for ${viewport.label}:\n'
            '${failures.join('\n')}',
          );
        }
      },
    );
  }
}

Future<void> _scanRoute(
  WidgetTester tester,
  _ResponsiveViewport viewport,
  _PriorityRoute route,
  List<String> failures,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;

  try {
    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(initialLocation: route.location),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );

    final semantics = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == route.semanticLabel,
      description: route.semanticLabel,
    );
    if (semantics.evaluate().isEmpty) {
      failures.add(
        '- ${route.name} ${viewport.label}: missing ${route.semanticLabel}',
      );
    }

    final bottomNav = find.byType(VitBottomNav);
    if (bottomNav.evaluate().length != 1) {
      failures.add(
        '- ${route.name} ${viewport.label}: expected one bottom nav, found '
        '${bottomNav.evaluate().length}',
      );
    } else {
      final navRect = tester.getRect(bottomNav);
      if (navRect.left < -0.5 ||
          navRect.right > viewport.width + 0.5 ||
          navRect.bottom > viewport.height + 0.5) {
        failures.add(
          '- ${route.name} ${viewport.label}: bottom nav clipped '
          '(${navRect.left.toStringAsFixed(1)}, '
          '${navRect.top.toStringAsFixed(1)}, '
          '${navRect.right.toStringAsFixed(1)}, '
          '${navRect.bottom.toStringAsFixed(1)})',
        );
      }
    }
  } catch (error) {
    failures.add('- ${route.name} ${viewport.label}: threw $error');
  } finally {
    FlutterError.onError = previousOnError;
  }

  Object? exception = tester.takeException();
  while (exception != null) {
    failures.add('- ${route.name} ${viewport.label}: exception $exception');
    exception = tester.takeException();
  }

  if (errors.isNotEmpty) {
    failures.addAll(
      errors.map(
        (details) =>
            '- ${route.name} ${viewport.label}: '
            '${_describeFlutterError(details)}',
      ),
    );
  }

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

const _responsiveViewports = [
  _ResponsiveViewport('360x800 minimum phone', 360, 800),
  _ResponsiveViewport('440x956 QA phone', 440, 956),
  _ResponsiveViewport('480x1040 large phone', 480, 1040),
];

final _priorityRoutes = [
  _PriorityRoute('Home', AppRoutePaths.home, 'Trang chủ'),
  _PriorityRoute('Markets', AppRoutePaths.markets, 'Thị trường'),
  _PriorityRoute(
    'Pair Detail',
    AppRoutePaths.pairDetail('btcusdt'),
    'Chi tiết cặp giao dịch',
  ),
  _PriorityRoute('Trade', AppRoutePaths.trade, 'Giao dịch Spot'),
  _PriorityRoute(
    'Orders History',
    AppRoutePaths.tradeOrdersHistory,
    'Lịch sử lệnh giao dịch',
  ),
  _PriorityRoute(
    'Order Receipt',
    AppRoutePaths.tradeOrderReceipt,
    'Chi tiết lệnh giao dịch',
  ),
  _PriorityRoute(
    'Wallet',
    AppRoutePaths.wallet,
    'Ví - số dư minh bạch, bảo mật đa lớp',
  ),
  _PriorityRoute(
    'Asset Detail',
    AppRoutePaths.walletAsset('btc'),
    'Chi tiết tài sản - số dư minh bạch',
  ),
  _PriorityRoute(
    'Transaction Detail',
    AppRoutePaths.walletTransaction('tx001'),
    'Chi tiết giao dịch',
  ),
  _PriorityRoute('Deposit', AppRoutePaths.walletDeposit, 'Nạp tiền'),
  _PriorityRoute(
    'Pending Deposits',
    AppRoutePaths.walletPendingDeposits,
    'Nạp tiền đang chờ xác nhận',
  ),
  _PriorityRoute(
    'Portfolio Analytics',
    AppRoutePaths.walletPortfolioAnalytics,
    'Phân tích danh mục - tổng quan tài sản',
  ),
  _PriorityRoute(
    'Wallet Health',
    AppRoutePaths.walletHealthScore,
    'Điểm sức khỏe ví - tổng quan, bảo mật và đa dạng hóa',
  ),
  _PriorityRoute(
    'Dust Converter',
    AppRoutePaths.walletDustConverter,
    'Chuyển đổi số dư nhỏ',
  ),
  _PriorityRoute('Withdraw', AppRoutePaths.walletWithdraw, 'Rút tiền'),
  _PriorityRoute('Transfer', AppRoutePaths.walletTransfer, 'Chuyển nội bộ'),
  _PriorityRoute(
    'Address Book',
    AppRoutePaths.walletAddressBook,
    'Sổ địa chỉ - quản lý địa chỉ ví đã lưu',
  ),
  _PriorityRoute(
    'Address Add',
    AppRoutePaths.walletAddressBookAdd,
    'Thêm địa chỉ mới vào sổ địa chỉ ví',
  ),
  _PriorityRoute(
    'Profile',
    AppRoutePaths.profile,
    'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
  ),
  _PriorityRoute(
    'Prediction Home',
    AppRoutePaths.marketsPredictions,
    'Trang chủ thị trường dự đoán: xác suất và sự kiện đang mở',
  ),
  _PriorityRoute(
    'Prediction Event',
    AppRoutePaths.marketsPredictionEvent('pred-1'),
    'Chi tiết sự kiện dự đoán: xác suất, vị thế và quy tắc',
  ),
  _PriorityRoute(
    'Prediction Risk',
    AppRoutePaths.marketsPredictionsRiskCalculator,
    'Máy tính rủi ro dự đoán',
  ),
  _PriorityRoute(
    'Prediction Receipt',
    AppRoutePaths.marketsPredictionReceipt('po-1'),
    'Chi tiết lệnh dự đoán: biên lai, phí và tiến trình',
  ),
  _PriorityRoute(
    'Prediction Portfolio',
    AppRoutePaths.marketsPredictionsPortfolio,
    'Danh mục dự đoán',
  ),
  _PriorityRoute(
    'Arena Home',
    AppRoutePaths.arena,
    'Trang chủ Open Arena - khám phá và tham gia thử thách công bằng',
  ),
  _PriorityRoute(
    'Arena Challenge',
    AppRoutePaths.arenaChallenge('ch003'),
    'Chi tiết thử thách trong Open Arena',
  ),
  _PriorityRoute(
    'Arena Join',
    AppRoutePaths.arenaJoin('ch003'),
    'Xác nhận tham gia thử thách trong Open Arena',
  ),
  _PriorityRoute(
    'Token Approval',
    AppRoutePaths.walletTokenApproval,
    'Phê duyệt token - xem và thu hồi quyền truy cập',
  ),
  _PriorityRoute('P2P Dashboard', AppRoutePaths.p2pDashboard, 'Tổng quan P2P'),
  _PriorityRoute(
    'P2P Payment Methods',
    AppRoutePaths.p2pPaymentMethods,
    'Phương thức thanh toán',
  ),
  _PriorityRoute(
    'P2P Payment Add',
    AppRoutePaths.p2pPaymentMethodAdd,
    'Thêm phương thức thanh toán',
  ),
  _PriorityRoute(
    'P2P Order',
    AppRoutePaths.p2pOrder('p2p001'),
    'Chi tiết đơn hàng P2P',
  ),
  _PriorityRoute(
    'P2P Dispute',
    AppRoutePaths.p2pDispute('p2p001'),
    'Mở tranh chấp P2P',
  ),
  _PriorityRoute('Admin Home', AppRoutePaths.admin, 'Trang tổng quan quản trị'),
  _PriorityRoute(
    'Analytics Dashboard',
    AppRoutePaths.adminAnalytics,
    'Bảng phân tích dữ liệu',
  ),
  _PriorityRoute(
    'Funnel Dashboard',
    AppRoutePaths.adminFunnels,
    'Bảng phân tích phễu chuyển đổi',
  ),
  _PriorityRoute(
    'A/B Test Dashboard',
    AppRoutePaths.adminAbtests,
    'Bảng điều khiển thử nghiệm A/B',
  ),
];

final _filteredPriorityRoutes = _routeFilter.isEmpty
    ? _priorityRoutes
    : _priorityRoutes
          .where(
            (route) =>
                route.name.toLowerCase().contains(_routeFilter) ||
                route.location.toLowerCase().contains(_routeFilter),
          )
          .toList(growable: false);

String _describeFlutterError(FlutterErrorDetails details) {
  if (_includeDiagnostics) {
    return details.toString();
  }
  return details.exceptionAsString();
}

final _routeFilter = const String.fromEnvironment(
  'RESPONSIVE_QA_ROUTE',
).toLowerCase();
const _includeDiagnostics = bool.fromEnvironment('RESPONSIVE_QA_DIAGNOSTICS');

class _ResponsiveViewport {
  const _ResponsiveViewport(this.label, this.width, this.height);

  final String label;
  final int width;
  final int height;
}

class _PriorityRoute {
  const _PriorityRoute(this.name, this.location, this.semanticLabel);

  final String name;
  final String location;
  final String semanticLabel;
}
