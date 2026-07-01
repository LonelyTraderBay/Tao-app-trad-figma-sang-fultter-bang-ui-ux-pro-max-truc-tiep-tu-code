import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_accent_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

enum VitTradeChartVariant { defaultRoute, pairRoute }

class VitTradeChartPanel extends StatelessWidget {
  const VitTradeChartPanel({
    super.key,
    this.variant = VitTradeChartVariant.defaultRoute,
    this.height = AppSpacing.tradeChartPanelHeight,
    this.borderColor,
  });

  final VitTradeChartVariant variant;
  final double height;
  final Color? borderColor;

  static const _primary = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final pairRoute = variant == VitTradeChartVariant.pairRoute;
    return VitCard(
      height: height,
      borderColor: (borderColor ?? _primary).withValues(alpha: .35),
      clip: true,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: pairRoute
                  ? const _VitPairRouteChartPainter()
                  : const _VitCandlestickChartPainter(),
            ),
          ),
          Positioned(
            left: AppSpacing.tradeChartOverlayInset,
            top: AppSpacing.tradeChartOverlayTop,
            child: pairRoute
                ? const VitStatusPill(
                    label: '24H',
                    status: VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  )
                : VitCard(
                    width: AppSpacing.tradeChartLogoSize,
                    height: AppSpacing.tradeChartLogoSize,
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.large,
                    borderColor: AppColors.sell.withValues(alpha: .30),
                    child: const SizedBox.shrink(),
                  ),
          ),
          Positioned(
            left: AppSpacing.tradeChartTvLeft,
            bottom: AppSpacing.tradeChartTvBottom,
            child: Text(
              'TV',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onAccent,
              ),
            ),
          ),
          if (pairRoute) ...[
            Positioned(
              right: AppSpacing.tradeChartOverlayInset,
              top: AppSpacing.tradeChartPriceRightTop,
              child: Text(
                '70000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.tradeChartOverlayInset,
              bottom: AppSpacing.tradeChartPriceRightBottom,
              child: Text(
                '68000.00',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3.withValues(alpha: .85),
                ),
              ),
            ),
          ],
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            top: pairRoute
                ? AppSpacing.tradeChartPriceTopPair
                : AppSpacing.tradeChartPriceTopDefault,
            child: VitAccentPill(
              label: pairRoute ? '70821.46' : '67545.13',
              accentColor: AppColors.sell,
            ),
          ),
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            top: pairRoute
                ? AppSpacing.tradeChartPriceTopPairSecond
                : AppSpacing.tradeChartPriceTopDefaultSecond,
            child: VitAccentPill(
              label: pairRoute ? '70821.46' : '67254.13',
              accentColor: AppColors.buy,
            ),
          ),
          Positioned(
            right: AppSpacing.tradeChartPriceRight,
            bottom: AppSpacing.tradeChartTvBottom,
            child: VitAccentPill(
              label: pairRoute ? '70.39K' : '252.58K',
              accentColor: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _VitPairRouteChartPainter extends CustomPainter {
  const _VitPairRouteChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.onAccent.withValues(alpha: .07)
      ..strokeWidth = 1;
    for (final y in [size.height * .35, size.height * .55, size.height * .75]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final dash = Paint()
      ..color = VitTradeChartPanel._primary.withValues(alpha: .35)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .36),
        Offset(x + 5, size.height * .36),
        dash,
      );
    }

    final points = <Offset>[
      Offset(size.width * .02, size.height * .66),
      Offset(size.width * .10, size.height * .60),
      Offset(size.width * .18, size.height * .56),
      Offset(size.width * .27, size.height * .48),
      Offset(size.width * .36, size.height * .34),
      Offset(size.width * .46, size.height * .38),
      Offset(size.width * .56, size.height * .22),
      Offset(size.width * .66, size.height * .26),
      Offset(size.width * .76, size.height * .39),
      Offset(size.width * .86, size.height * .47),
      Offset(size.width * .96, size.height * .39),
    ];
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.buy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final candlePaint = Paint();
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final green = i == 0 || i == 1 || i == 2 || i == 3 || i == 5 || i == 10;
      candlePaint.color = green ? AppColors.buy : AppColors.sell;
      canvas.drawRect(
        Rect.fromCenter(center: point, width: 9, height: green ? 10 : 12),
        candlePaint,
      );
    }

    for (var i = 0; i < 28; i++) {
      final h = 5.0 + ((i * 5) % 10) * 2.4;
      candlePaint.color = i % 4 == 0
          ? AppColors.sell.withValues(alpha: .55)
          : AppColors.buy.withValues(alpha: .58);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 13, size.height - 10 - h, 9, h),
        candlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VitCandlestickChartPainter extends CustomPainter {
  const _VitCandlestickChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = VitTradeChartPanel._primary.withValues(alpha: .22)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(
        Offset(x, size.height * .57),
        Offset(x + 5, size.height * .57),
        grid,
      );
    }

    final candles = <(double, double, double, double, bool)>[
      (.18, .13, .31, .24, false),
      (.12, .11, .42, .34, false),
      (.32, .30, .48, .38, false),
      (.39, .38, .47, .42, false),
      (.42, .36, .50, .44, true),
      (.35, .28, .45, .36, true),
      (.26, .24, .38, .33, false),
      (.31, .30, .45, .37, false),
      (.39, .37, .48, .42, false),
      (.44, .43, .55, .48, false),
      (.48, .40, .56, .44, true),
      (.43, .39, .51, .47, false),
      (.48, .43, .57, .50, true),
      (.41, .38, .50, .46, true),
      (.39, .35, .53, .48, false),
      (.43, .37, .55, .47, true),
      (.45, .37, .61, .52, false),
      (.51, .47, .62, .55, false),
      (.55, .49, .64, .58, true),
      (.49, .43, .61, .54, true),
      (.45, .40, .58, .52, false),
    ];
    const bodyWidth = 10.0;
    final step = (size.width - 88) / (candles.length - 1);
    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = 18.0 + i * step;
      final color = c.$5 ? AppColors.buy : AppColors.sell;
      final paint = Paint()..color = color;
      canvas.drawLine(
        Offset(x + bodyWidth / 2, size.height * c.$1),
        Offset(x + bodyWidth / 2, size.height * c.$3),
        paint..strokeWidth = 2,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * c.$2,
          bodyWidth,
          size.height * (c.$4 - c.$2).abs().clamp(.05, .18),
        ),
        paint,
      );
    }

    final volumePaint = Paint()..color = AppColors.buy.withValues(alpha: .65);
    for (var i = 0; i < 22; i++) {
      final h = 7.0 + ((i * 3) % 7) * 3;
      volumePaint.color = i.isEven
          ? AppColors.buy.withValues(alpha: .55)
          : AppColors.sell.withValues(alpha: .55);
      canvas.drawRect(
        Rect.fromLTWH(18 + i * 16, size.height - 10 - h, 12, h),
        volumePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
