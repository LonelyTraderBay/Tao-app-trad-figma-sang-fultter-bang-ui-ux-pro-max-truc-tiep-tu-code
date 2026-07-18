import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';

/// A11Y-5 (A-Plus GĐ3): kiểm tương phản màu theo công thức WCAG 2.1 tính từ
/// luminance thực của [Color] — chặn hồi quy khi ai đó chỉnh token màu làm
/// chữ tụt dưới ngưỡng đọc được. Bảng tỉ lệ đầy đủ + ngoại lệ ghi tại
/// docs/02_FLUTTER_MIGRATION/VitTrade-Color-Contrast-Audit.md.
///
/// Ngưỡng WCAG: 4.5:1 cho body text thường; 3:1 cho text lớn/đậm và thành
/// phần UI (icon, viền). App một-theme (dark) nên chỉ kiểm nền tối hiện có.
double _linearize(double channel) {
  final c = channel / 255.0;
  return c <= 0.03928
      ? c / 12.92
      : math.pow((c + 0.055) / 1.055, 2.4) as double;
}

double _relativeLuminance(Color color) {
  final r = _linearize((color.r * 255.0).roundToDouble());
  final g = _linearize((color.g * 255.0).roundToDouble());
  final b = _linearize((color.b * 255.0).roundToDouble());
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const backgrounds = <String, Color>{
    'bg': AppColors.bg,
    'surface': AppColors.surface,
    'surface2': AppColors.surface2,
    'surface3': AppColors.surface3,
  };

  test('body text đạt WCAG AA 4.5:1 trên mọi nền tối', () {
    const bodyText = <String, Color>{
      'text1': AppColors.text1,
      'text2': AppColors.text2,
    };
    final failures = <String>[];
    for (final t in bodyText.entries) {
      for (final bg in backgrounds.entries) {
        final ratio = _contrastRatio(t.value, bg.value);
        if (ratio < 4.5) {
          failures.add(
            '${t.key} trên ${bg.key}: ${ratio.toStringAsFixed(2)} < 4.5',
          );
        }
      }
    }
    expect(
      failures,
      isEmpty,
      reason: 'Body text tụt dưới ngưỡng đọc AA (A11Y-5): $failures',
    );
  });

  test('text phụ (text3) + màu ngữ nghĩa đạt ngưỡng 3:1 cho text lớn/UI', () {
    // text3 = màu chú thích/hint, dùng cho label nhỏ phụ trợ — ngưỡng 3:1.
    // NGOẠI LỆ có ghi chép: text3 trên surface3 = 2.93 (hụt sát), text3 KHÔNG
    // đặt trực tiếp trên surface3 trong sản phẩm (surface3 là nền chip/badge
    // dùng text1/text2). textDisabled được WCAG 1.4.3 MIỄN TRỪ (trạng thái
    // disabled) nên không kiểm. Đổi màu token là việc design riêng — đợt này
    // chỉ khóa bất biến, không sửa màu.
    const allowlist = {'text3 trên surface3'};

    final failures = <String>[];
    for (final bg in backgrounds.entries) {
      final key = 'text3 trên ${bg.key}';
      final ratio = _contrastRatio(AppColors.text3, bg.value);
      if (ratio < 3.0 && !allowlist.contains(key)) {
        failures.add('$key: ${ratio.toStringAsFixed(2)} < 3.0');
      }
    }

    const semantic = <String, Color>{
      'primary': AppColors.primary,
      'buy': AppColors.buy,
      'sell': AppColors.sell,
      'accent': AppColors.accent,
    };
    for (final s in semantic.entries) {
      final ratio = _contrastRatio(s.value, AppColors.bg);
      if (ratio < 3.0) {
        failures.add('${s.key} trên bg: ${ratio.toStringAsFixed(2)} < 3.0');
      }
    }

    expect(
      failures,
      isEmpty,
      reason:
          'Text phụ/màu ngữ nghĩa tụt dưới 3:1 (A11Y-5); nếu là ngoại lệ có '
          'chủ đích, thêm vào allowlist kèm lý do + cập nhật doc: $failures',
    );
  });
}
