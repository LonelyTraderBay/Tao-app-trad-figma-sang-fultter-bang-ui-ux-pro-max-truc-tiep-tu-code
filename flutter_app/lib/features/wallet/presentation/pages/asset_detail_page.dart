import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';

const _assetBackground = AppColors.bg;
const _assetPanel = AppColors.surface;
const _assetGreen = Color(0xFF10B981);
const _assetRed = Color(0xFFEF4444);
const _assetPrimary = AppColors.primary;

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({
    super.key,
    required this.assetId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc147_asset_detail_content');
  static Key actionKey(String id) => Key('sc147_asset_action_$id');
  static Key periodKey(String id) => Key('sc147_asset_period_$id');
  static Key transactionKey(String id) => Key('sc147_asset_tx_$id');

  final String assetId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(walletRepositoryProvider)
        .getAssetDetail(widget.assetId);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-147 AssetDetailPage',
      child: Material(
        color: _assetBackground,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.symbol,
              subtitle: 'Chi tiết · Wallet',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: AssetDetailPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AssetHero(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _AssetActionGrid(
                      actions: snapshot.actions,
                      onNavigate: (route) => context.go(route),
                    ),
                    const SizedBox(height: 16),
                    _PriceChartCard(
                      snapshot: snapshot,
                      activePeriod: _period,
                      onPeriod: (period) => setState(() => _period = period),
                    ),
                    const SizedBox(height: 19),
                    _AssetTransactions(
                      transactions: snapshot.transactions,
                      onNavigate: (route) => context.go(route),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetHero extends StatelessWidget {
  const _AssetHero({required this.snapshot});

  final WalletAssetDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    final positive = snapshot.change24h >= 0;

    return Container(
      height: 238,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .13), color.withValues(alpha: .045)],
        ),
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetLogo(snapshot: snapshot, size: 52),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.name,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    snapshot.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 13,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            _formatUsd(snapshot.usdValue),
            style: AppTextStyles.heroNumber.copyWith(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                '${_formatFixed(snapshot.balance, 6)} ${snapshot.symbol}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                _formatPct(snapshot.change24h),
                style: AppTextStyles.caption.copyWith(
                  color: positive ? _assetGreen : _assetRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  label: 'Khả dụng',
                  value: _formatFixed(snapshot.available, 6),
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Trong lệnh',
                  value: _formatFixed(snapshot.inOrder, 6),
                  valueColor: _assetPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Đóng băng',
                  value: _formatFixed(snapshot.frozen, 2),
                  valueColor: Color(0xFFFFC107),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Giá hiện tại',
                  value: _withCommas(snapshot.currentPrice.toStringAsFixed(2)),
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.snapshot, required this.size});

  final WalletAssetDetailSnapshot snapshot;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: color.withValues(alpha: .35), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        snapshot.symbol.substring(
          0,
          snapshot.symbol.length < 3 ? snapshot.symbol.length : 3,
        ),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: size >= 50 ? 14 : 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(10, 9, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetActionGrid extends StatelessWidget {
  const _AssetActionGrid({required this.actions, required this.onNavigate});

  final List<WalletAssetDetailAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(
            child: _ActionTile(
              action: actions[i],
              onTap: () => onNavigate(actions[i].route),
            ),
          ),
          if (i != actions.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final WalletAssetDetailAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(action.colorHex);
    final icon = switch (action.iconKey) {
      'deposit' => Icons.south_west_rounded,
      'withdraw' => Icons.north_east_rounded,
      'transfer' => Icons.swap_vert_rounded,
      _ => Icons.repeat_rounded,
    };
    return GestureDetector(
      key: AssetDetailPage.actionKey(action.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _assetPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .15),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              action.label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChartCard extends StatelessWidget {
  const _PriceChartCard({
    required this.snapshot,
    required this.activePeriod,
    required this.onPeriod,
  });

  final WalletAssetDetailSnapshot snapshot;
  final String activePeriod;
  final ValueChanged<String> onPeriod;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    return Container(
      height: 209,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _assetPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ giá',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              for (final period in const ['1W', '1M', '3M'])
                GestureDetector(
                  key: AssetDetailPage.periodKey(period),
                  onTap: () => onPeriod(period),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 27,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activePeriod == period
                          ? _assetPrimary.withValues(alpha: .18)
                          : Colors.transparent,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      period,
                      style: AppTextStyles.micro.copyWith(
                        color: activePeriod == period
                            ? _assetPrimary
                            : AppColors.text2,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomPaint(
              painter: _AssetChartPainter(points: snapshot.chart, color: color),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetChartPainter extends CustomPainter {
  const _AssetChartPainter({required this.points, required this.color});

  final List<WalletAssetChartPoint> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minPrice = points.map((p) => p.price).reduce(math.min);
    final maxPrice = points.map((p) => p.price).reduce(math.max);
    final range = math.max(1, maxPrice - minPrice);
    final dx = size.width / (points.length - 1);
    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final x = i * dx;
      final normalized = (points[i].price - minPrice) / range;
      final y =
          size.height - normalized * (size.height * .82) - size.height * .08;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: .22), color.withValues(alpha: .02)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _AssetChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

class _AssetTransactions extends StatelessWidget {
  const _AssetTransactions({
    required this.transactions,
    required this.onNavigate,
  });

  final List<WalletAssetDetailTransaction> transactions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lịch sử giao dịch',
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        for (final tx in transactions)
          _AssetTransactionRow(tx: tx, onTap: () => onNavigate(tx.route)),
      ],
    );
  }
}

class _AssetTransactionRow extends StatelessWidget {
  const _AssetTransactionRow({required this.tx, required this.onTap});

  final WalletAssetDetailTransaction tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = tx.isIncoming ? _assetGreen : _assetRed;
    return GestureDetector(
      key: AssetDetailPage.transactionKey(tx.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              alignment: Alignment.center,
              child: Icon(
                tx.isIncoming
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.label,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    tx.createdAt,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tx.isIncoming ? '+' : '-'}${_formatFixed(tx.amount, 6)} ${tx.asset}',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  tx.status,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _formatUsd(double value) => '\$${_withCommas(value.toStringAsFixed(2))}';

String _formatFixed(double value, int decimals) {
  return _withCommas(value.toStringAsFixed(decimals));
}

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
