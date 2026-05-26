import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PAdDetailPage extends ConsumerStatefulWidget {
  const P2PAdDetailPage({super.key, required this.adId, this.shellRenderMode});

  static const contentKey = Key('sc224_p2p_ad_detail_content');
  static const buyButtonKey = Key('sc224_p2p_ad_detail_buy');
  static Key percentKey(int percent) => Key('sc224_percent_$percent');

  final String adId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAdDetailPage> createState() => _P2PAdDetailPageState();
}

class _P2PAdDetailPageState extends ConsumerState<P2PAdDetailPage> {
  int? _selectedPercent;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getAdDetail(widget.adId);
    final ad = snapshot.ad;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x4
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;
    final footerInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;
    final fiatAmount = _selectedPercent == null
        ? 0
        : (ad.maxLimit * _selectedPercent! / 100).round();
    final cryptoAmount = fiatAmount == 0 ? 0.0 : fiatAmount / ad.price;
    final isValid =
        fiatAmount >= ad.minLimit &&
        fiatAmount <= ad.maxLimit &&
        cryptoAmount <= snapshot.availableAmount;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-224 P2PAdDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Chi tiết quảng cáo',
              subtitle: 'Quảng cáo · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PAdDetailPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MerchantCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _TrustMarketRow(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _SignalChips(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _PriceCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _AmountCard(
                        snapshot: snapshot,
                        selectedPercent: _selectedPercent,
                        fiatAmount: fiatAmount,
                        cryptoAmount: cryptoAmount,
                        onPercent: (percent) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedPercent = percent);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _RequirementCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _TermsCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _EscrowCard(snapshot: snapshot, amount: cryptoAmount),
                    ],
                  ),
                ),
              ),
            ),
            VitStickyFooter(
              backgroundColor: AppColors.surface.withValues(alpha: .96),
              child: Padding(
                padding: EdgeInsets.only(bottom: footerInset),
                child: VitCtaButton(
                  key: P2PAdDetailPage.buyButtonKey,
                  onPressed: isValid
                      ? () => context.go(
                          AppRoutePaths.p2pOrder(snapshot.targetOrderId),
                        )
                      : null,
                  variant: VitCtaButtonVariant.success,
                  child: Text('Mua ${ad.asset}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(AppRoutePaths.p2pMerchant(ad.merchantId));
      },
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  ad.merchant.characters.first,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: AppSpacing.x4,
                  height: AppSpacing.x4,
                  decoration: BoxDecoration(
                    color: ad.isOnline ? AppColors.buy : AppColors.text3,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ad.merchant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.accent,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    const _Badge(label: 'Elite'),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      '${ad.completedOrders} đơn',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${_fixed(ad.completionRate)}% hoàn thành',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      ad.isOnline ? 'Online' : 'Offline',
                      style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _TrustMarketRow extends StatelessWidget {
  const _TrustMarketRow({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.shield_outlined,
            title: 'Độ tin cậy',
            value: '${snapshot.trustScore}',
            unit: '/100',
            subtitle: snapshot.trustLabel,
            color: AppColors.buy,
            progress: snapshot.trustScore / 100,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _InfoCard(
            icon: Icons.trending_up_rounded,
            title: 'So với thị trường',
            value: '+${snapshot.priceDiffPct.toStringAsFixed(2)}%',
            subtitle: 'Giá hợp lý',
            footnote: 'Thị trường: ${_formatVnd(snapshot.marketPriceVnd)}',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.unit,
    this.footnote,
    this.progress,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final String? unit;
  final String? footnote;
  final double? progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.buttonHero + AppSpacing.x4,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontSize: 21,
                  fontFamily: 'Roboto',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  unit!,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ],
          ),
          if (footnote != null)
            Text(
              footnote!,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
              ),
            ),
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.smRadius,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: AppSpacing.x2,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalChips extends StatelessWidget {
  const _SignalChips({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SignalChip(
          icon: Icons.visibility_outlined,
          label: '${snapshot.viewerCount} đang xem',
          color: AppColors.accent,
        ),
        const SizedBox(width: AppSpacing.x3),
        _SignalChip(
          icon: Icons.bar_chart_rounded,
          label: 'KL 30d: \$${_formatCompactUsd(snapshot.totalVolume30dUsd)}',
          color: AppColors.buy,
        ),
        const SizedBox(width: AppSpacing.x3),
        _SignalChip(
          icon: Icons.star_rounded,
          label: _fixed(snapshot.ad.merchantRating ?? 4.8),
          color: AppColors.warn,
        ),
      ],
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          border: Border.all(color: color.withValues(alpha: .16)),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontFamily: 'Roboto',
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '${ad.asset == 'USDT' ? 'VND' : 'VND'}/${ad.asset}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceMeta(
                  label: 'Khả dụng',
                  value:
                      '${_formatAmount(snapshot.availableAmount)} ${ad.asset}',
                ),
              ),
              Expanded(
                child: _PriceMeta(
                  label: 'Giới hạn',
                  value:
                      '${_formatVnd(ad.minLimit)} -\n${_formatVnd(ad.maxLimit)}',
                ),
              ),
              Expanded(
                child: _PriceMeta(label: 'Phản hồi', value: ad.avgResponseTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceMeta extends StatelessWidget {
  const _PriceMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.snapshot,
    required this.selectedPercent,
    required this.fiatAmount,
    required this.cryptoAmount,
    required this.onPercent,
  });

  final P2PAdDetailSnapshot snapshot;
  final int? selectedPercent;
  final int fiatAmount;
  final double cryptoAmount;
  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    final ad = snapshot.ad;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhập số lượng',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Số tiền (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _InputShell(
            value: fiatAmount == 0
                ? '${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}'
                : _formatVnd(fiatAmount),
            suffix: 'VND',
            muted: fiatAmount == 0,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Số lượng (${ad.asset})',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _InputShell(
            value: cryptoAmount == 0 ? '0.00' : cryptoAmount.toStringAsFixed(6),
            suffix: ad.asset,
            muted: cryptoAmount == 0,
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final percent in const [25, 50, 75, 100]) ...[
                Expanded(
                  child: _PercentButton(
                    percent: percent,
                    selected: selectedPercent == percent,
                    onTap: () => onPercent(percent),
                  ),
                ),
                if (percent != 100) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  const _InputShell({
    required this.value,
    required this.suffix,
    required this.muted,
  });

  final String value;
  final String suffix;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.base.copyWith(
                color: muted ? AppColors.text3 : AppColors.text1,
                fontFamily: 'Roboto',
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Text(
            suffix,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PercentButton extends StatelessWidget {
  const _PercentButton({
    required this.percent,
    required this.selected,
    required this.onTap,
  });

  final int percent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: P2PAdDetailPage.percentKey(percent),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary12 : Colors.transparent,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          '$percent%',
          style: AppTextStyles.micro.copyWith(
            color: selected ? AppModuleAccents.p2p : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent08,
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Yêu cầu đối tác',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                _RequirementPill(label: 'KYC cấp ${snapshot.minKycLevel}+'),
                _RequirementPill(
                  label: '${snapshot.minCompletedTrades}+ giao dịch',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementPill extends StatelessWidget {
  const _RequirementPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent12,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot});

  final P2PAdDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Điều kiện giao dịch',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EscrowCard extends StatelessWidget {
  const _EscrowCard({required this.snapshot, required this.amount});

  final P2PAdDetailSnapshot snapshot;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Tài sản được bảo vệ bởi hệ thống Escrow VitTrade. ${amount.toStringAsFixed(2)} ${snapshot.ad.asset} sẽ được khóa cho đến khi xác nhận thanh toán thành công.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(num value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

String _formatAmount(num value) {
  final parts = value.toStringAsFixed(2).split('.');
  return '${_formatCount(parts.first)}.${parts.last}';
}

String _formatCount(String raw) {
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatCompactUsd(int value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).round()}K';
  return value.toString();
}

String _fixed(double value) => value.toStringAsFixed(1);
