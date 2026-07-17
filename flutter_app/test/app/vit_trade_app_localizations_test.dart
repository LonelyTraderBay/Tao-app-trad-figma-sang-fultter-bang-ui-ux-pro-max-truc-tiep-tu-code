import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

/// I18N-2 (A-Plus GĐ2, DEC-i18n Nhánh A): VitTradeApp khai báo
/// flutter_localizations với locale vi — widget hệ thống Material
/// (date picker, time picker, tooltip, menu paste...) phải nói tiếng Việt,
/// không rơi về tiếng Anh mặc định. Test bơm qua ĐÚNG cấu hình
/// _VitTradeMaterialApp thật (không dựng MaterialApp riêng) và assert nhãn
/// chuẩn Material qua MaterialLocalizations.
///
/// Ghi chú: không mở showDatePicker thật ở đây — clamp text-scaling A11Y-2/3
/// của app (minScaleFactor 1.0) va assert `maxScale > minScale` với clamp
/// nội bộ của _DatePickerHeader trong chế độ debug (bug interplay riêng,
/// đã tách thành task xử lý độc lập; release không ảnh hưởng).
void main() {
  testWidgets(
    'widget hệ thống Material dưới VitTradeApp dùng nhãn tiếng Việt',
    (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Trang thử locale'))),
          ),
        ],
      );

      await tester.pumpWidget(VitTradeApp(routerConfig: router));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold).first);
      expect(Localizations.localeOf(context), const Locale('vi'));

      // Delegates đã nạp cho locale vi: nhãn chuẩn của date/time picker và
      // các nút hệ thống là tiếng Việt (chính tả theo bản dịch Flutter: "Huỷ").
      final materialLoc = MaterialLocalizations.of(context);
      expect(materialLoc.cancelButtonLabel, 'Huỷ');
      expect(materialLoc.okButtonLabel, 'OK');
      expect(materialLoc.datePickerHelpText, 'Chọn ngày');
      expect(materialLoc.timePickerDialHelpText, 'Chọn thời gian');
      expect(materialLoc.pasteButtonLabel, 'Dán');
      expect(materialLoc.searchFieldLabel, 'Tìm kiếm');
    },
  );
}
