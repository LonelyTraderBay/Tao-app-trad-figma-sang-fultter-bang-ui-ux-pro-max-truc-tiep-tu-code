import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_manager_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class WalletManagerDistributionCard extends StatelessWidget {
  const WalletManagerDistributionCard({super.key, required this.snapshot});

  final WalletMultiManagerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.walletManagerDistributionHeight,
      padding: AppSpacing.walletManagerDistributionPadding,
      variant: VitCardVariant.ghost,
      borderColor: walletManagerBorder,
      background: const ColoredBox(color: walletManagerPanel),
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Portfolio Distribution',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.walletManagerDistributionTitleGap),
          Expanded(
            child: CustomPaint(
              painter: _DistributionPainter(wallets: _chartWallets(snapshot)),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionPainter extends CustomPainter {
  const _DistributionPainter({required this.wallets});

  final List<WalletManagerItem> wallets;

  @override
  void paint(Canvas canvas, Size size) {
    if (wallets.isEmpty) return;
    final total = wallets.fold<double>(
      0,
      (sum, wallet) => sum + wallet.balanceUsd,
    );
    if (total <= 0) return;

    final center = Offset(
      size.width / 2,
      size.height * AppSpacing.walletManagerDistributionCenterY,
    );
    final radius =
        math.min(size.width, size.height) *
        AppSpacing.walletManagerDistributionRadiusFactor;
    const strokeWidth = AppSpacing.walletManagerDistributionStroke;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final gapPaint = Paint()
      ..color = AppColors.onAccent.withValues(alpha: .92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(center, radius, gapPaint);

    var start = -math.pi / 2;
    const gap = AppSpacing.walletManagerDistributionArcGap;
    for (final wallet in wallets) {
      final sweep = (wallet.balanceUsd / total) * math.pi * 2;
      final paint = Paint()
        ..color = Color(wallet.distributionColorHex)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        start + gap / 2,
        math.max(0, sweep - gap),
        false,
        paint,
      );
      start += sweep;
    }

    final centerPaint = Paint()..color = walletManagerPanel;
    canvas.drawCircle(center, radius - strokeWidth / 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _DistributionPainter oldDelegate) {
    return oldDelegate.wallets != wallets;
  }
}

List<WalletManagerItem> _chartWallets(WalletMultiManagerSnapshot snapshot) {
  WalletManagerItem byId(String id) =>
      snapshot.wallets.firstWhere((wallet) => wallet.id == id);
  return [byId('w2'), byId('w1'), byId('w4'), byId('w3')];
}
