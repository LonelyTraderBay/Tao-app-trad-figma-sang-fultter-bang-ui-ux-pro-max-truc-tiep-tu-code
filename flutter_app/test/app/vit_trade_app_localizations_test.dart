import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

/// I18N-2 (A-Plus GĐ2, DEC-i18n Nhánh A): VitTradeApp khai báo
/// flutter_localizations với locale vi — widget hệ thống Material
/// (date picker, time picker, tooltip, menu paste...) phải nói tiếng Việt,
/// không rơi về tiếng Anh mặc định. Test bơm qua ĐÚNG cấu hình
/// _VitTradeMaterialApp thật (không dựng MaterialApp riêng).
///
/// Test thứ hai mở showDatePicker THẬT — vừa chốt nhãn dialog tiếng Việt,
/// vừa là regression test cho fix text-scaler: builder A11Y-2/3 từng đặt
/// minScaleFactor 1.0 làm clamp lồng nhau với _DatePickerHeader
/// (maxScaleFactor <= 1.0) gộp thành min == max → nổ assert
/// `maxScale > minScale` trong debug. Giữ trần 1.3x, bỏ sàn — dialog phải
/// mở được sạch sẽ.
void main() {
  Future<GoRouter> pumpLocaleHost(WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _DatePickerHost(),
        ),
      ],
    );
    await tester.pumpWidget(VitTradeApp(routerConfig: router));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets(
    'widget hệ thống Material dưới VitTradeApp dùng nhãn tiếng Việt',
    (tester) async {
      await pumpLocaleHost(tester);

      final context = tester.element(find.byType(Scaffold).first);
      expect(Localizations.localeOf(context), const Locale('vi'));

      // Delegates đã nạp cho locale vi: nhãn chuẩn của date/time picker và
      // các nút hệ thống là tiếng Việt (chính tả theo bản dịch Flutter:
      // "Huỷ").
      final materialLoc = MaterialLocalizations.of(context);
      expect(materialLoc.cancelButtonLabel, 'Huỷ');
      expect(materialLoc.okButtonLabel, 'OK');
      expect(materialLoc.datePickerHelpText, 'Chọn ngày');
      expect(materialLoc.timePickerDialHelpText, 'Chọn thời gian');
      expect(materialLoc.pasteButtonLabel, 'Dán');
      expect(materialLoc.searchFieldLabel, 'Tìm kiếm');
    },
  );

  testWidgets(
    'showDatePicker mở được dưới clamp A11Y và hiển thị nhãn tiếng Việt',
    (tester) async {
      await pumpLocaleHost(tester);

      await tester.tap(find.text('Mở lịch'));
      await tester.pumpAndSettle();

      // Dialog thật render không nổ assert text-scaler, nhãn tiếng Việt.
      expect(find.text('Chọn ngày'), findsOneWidget);
      expect(find.text('Huỷ'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Đóng bằng nút Huỷ — dialog biến mất, không exception treo lại.
      await tester.tap(find.text('Huỷ'));
      await tester.pumpAndSettle();
      expect(find.text('Chọn ngày'), findsNothing);
    },
  );
}

class _DatePickerHost extends StatelessWidget {
  const _DatePickerHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            unawaited(
              showDatePicker(
                context: context,
                initialDate: DateTime(2026, 7, 17),
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
              ),
            );
          },
          child: const Text('Mở lịch'),
        ),
      ),
    );
  }
}
