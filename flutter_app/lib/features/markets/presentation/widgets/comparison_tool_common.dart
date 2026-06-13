import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';

const comparisonToolPrimary = AppColors.primary;
const comparisonToolAccent = AppColors.accent;
const comparisonToolMaxCompare = 4;

final class ComparisonToolKeys {
  const ComparisonToolKeys._();

  static const content = Key('sc016_compare_scroll_content');
  static const addToken = Key('sc016_add_token');
  static const picker = Key('sc016_token_picker');
  static const pickerSearch = Key('sc016_picker_search');

  static Key token(String id) => Key('sc016_token_$id');

  static Key removeToken(String id) => Key('sc016_remove_$id');

  static Key pickerToken(String id) => Key('sc016_picker_token_$id');

  static Key pickerQuickToken(String id) => Key('sc016_picker_quick_token_$id');
}

class ComparisonAvatar extends StatelessWidget {
  const ComparisonAvatar({super.key, required this.pair, required this.size});

  final MarketPair pair;
  final double size;

  @override
  Widget build(BuildContext context) {
    final labelStyle = size <= 26 ? AppTextStyles.micro : AppTextStyles.badge;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: pair.logoColor.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        pair.baseAsset.substring(0, pair.baseAsset.length < 2 ? 1 : 2),
        style: labelStyle.copyWith(
          color: pair.logoColor,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class ComparisonSparklinePainter extends CustomPainter {
  const ComparisonSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final span = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final normalized = (values[i] - minValue) / span;
      final y = size.height - normalized * (size.height - 10) - 5;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .22), color.withValues(alpha: .02)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant ComparisonSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

MarketPair? comparisonFindPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

double comparisonMetricValue(MarketPair pair, String key) {
  return switch (key) {
    'price' => pair.price,
    'mcap' => pair.marketCap,
    'vol' => pair.volume24h,
    'chg' => pair.change24h,
    'high' => pair.high24h,
    'low' => pair.low24h,
    'range' => ((pair.high24h - pair.low24h) / pair.low24h) * 100,
    'volmcap' => (pair.volume24h / pair.marketCap) * 100,
    _ => 0,
  };
}

int comparisonBestIndex(
  List<double> values,
  MarketComparisonHighlight? highlight,
) {
  if (highlight == null || values.length < 2) return -1;
  final target = highlight == MarketComparisonHighlight.high
      ? values.reduce((a, b) => a > b ? a : b)
      : values.reduce((a, b) => a < b ? a : b);
  return values.indexOf(target);
}

String comparisonFormatMetric(
  double value,
  MarketComparisonMetricFormat format,
) {
  return switch (format) {
    MarketComparisonMetricFormat.price => '\$${comparisonFormatPrice(value)}',
    MarketComparisonMetricFormat.compact => comparisonFormatCompactUsd(value),
    MarketComparisonMetricFormat.percent => comparisonFormatPercent(value),
    MarketComparisonMetricFormat.raw => value.toStringAsFixed(2),
  };
}

String comparisonFormatPercent(double value) {
  return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
}

String comparisonFormatCompactUsd(double value) {
  if (value >= 1000000000000) {
    return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
  }
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String comparisonFormatPrice(double value) {
  final fractionDigits = value >= 100
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
