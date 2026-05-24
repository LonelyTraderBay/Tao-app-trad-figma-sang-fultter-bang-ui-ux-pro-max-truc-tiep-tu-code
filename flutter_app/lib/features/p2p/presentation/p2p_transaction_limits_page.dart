import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PTransactionLimitsPage extends ConsumerWidget {
  const P2PTransactionLimitsPage({super.key, this.shellRenderMode});

  static const tierHeroKey = Key('sc266_p2p_limits_tier_hero');
  static const usageKey = Key('sc266_p2p_limits_usage');
  static const trackerLinkKey = Key('sc266_p2p_limits_tracker_link');
  static const detailsKey = Key('sc266_p2p_limits_details');
  static const upgradeKey = Key('sc266_p2p_limits_upgrade');
  static const upgradeCtaKey = Key('sc266_p2p_limits_upgrade_cta');
  static const infoKey = Key('sc266_p2p_limits_info');

  static Key usageItemKey(String id) => Key('sc266_p2p_limits_usage_$id');

  static Key detailItemKey(String id) => Key('sc266_p2p_limits_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRepositoryProvider).getTransactionLimits();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-266 P2PTransactionLimitsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: const _HeaderChartButton(),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
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
                      _TierHero(tier: snapshot.currentTier),
                      const SizedBox(height: AppSpacing.x5),
                      _CurrentUsage(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      _LimitDetails(items: snapshot.detailItems),
                      const SizedBox(height: AppSpacing.x6),
                      _UpgradeCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x6),
                      _LimitInfoNotice(items: snapshot.infoBullets),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChartButton extends StatelessWidget {
  const _HeaderChartButton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const SizedBox(
        width: AppSpacing.inputHeight,
        height: AppSpacing.inputHeight,
        child: Icon(
          Icons.bar_chart_rounded,
          color: AppColors.text1,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _TierHero extends StatelessWidget {
  const _TierHero({required this.tier});

  final P2PTransactionLimitTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PTransactionLimitsPage.tierHeroKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.buy,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.buy),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Colors.white,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tier ${tier.tier} - ${tier.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Giới hạn hiện tại của bạn',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: .90),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .20),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Text(
                    tier.statusLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: Colors.white,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _TierMetric(
                  label: 'Mua/ngày',
                  value: '${_formatMillions(tier.dailyBuy)} VND',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TierMetric(
                  label: 'Bán/ngày',
                  value: '${_formatMillions(tier.dailySell)} VND',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierMetric extends StatelessWidget {
  const _TierMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: Colors.white.withValues(alpha: .82),
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentUsage extends StatelessWidget {
  const _CurrentUsage({required this.snapshot});

  final P2PTransactionLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTransactionLimitsPage.usageKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Sử dụng hiện tại',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            TextButton(
              key: P2PTransactionLimitsPage.trackerLinkKey,
              onPressed: () {
                HapticFeedback.selectionClick();
                context.go(snapshot.trackerRoute);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppModuleAccents.p2p,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Xem chi tiết'),
                  SizedBox(width: AppSpacing.x1),
                  Icon(Icons.chevron_right_rounded, size: 15),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            children: [
              for (var index = 0; index < snapshot.usageItems.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index == snapshot.usageItems.length - 1
                        ? 0
                        : AppSpacing.x4,
                  ),
                  child: _UsageLimitRow(item: snapshot.usageItems[index]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UsageLimitRow extends StatelessWidget {
  const _UsageLimitRow({required this.item});

  final P2PTransactionLimitUsageDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);
    final nearLimit = item.percentage >= 80;

    return Column(
      key: P2PTransactionLimitsPage.usageItemKey(item.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              '${_formatComma(item.current, 0)} / ${_formatComma(item.max, 0)} VND',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: ColoredBox(
            color: AppColors.surface2,
            child: SizedBox(
              height: AppSpacing.x2,
              child: FractionallySizedBox(
                widthFactor: item.percentage.clamp(0, 100) / 100,
                alignment: Alignment.centerLeft,
                child: ColoredBox(color: nearLimit ? AppColors.sell : color),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Expanded(
              child: Text(
                '${item.percentage.toStringAsFixed(1)}% đã dùng',
                style: AppTextStyles.micro.copyWith(
                  color: nearLimit ? AppColors.sell : color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              'Còn lại: ${_formatComma(item.remaining, 0)} VND',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _LimitDetails extends StatelessWidget {
  const _LimitDetails({required this.items});

  final List<P2PTransactionLimitDetailDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTransactionLimitsPage.detailsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chi tiết giới hạn',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                _LimitDetailRow(item: items[index]),
                if (index != items.length - 1)
                  const Divider(height: 1, color: AppColors.borderSolid),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LimitDetailRow extends StatelessWidget {
  const _LimitDetailRow({required this.item});

  final P2PTransactionLimitDetailDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);
    return Padding(
      key: P2PTransactionLimitsPage.detailItemKey(item.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(_detailIcon(item.iconKey), color: color, size: 20),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatComma(item.value, 0)} VND',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({required this.snapshot});

  final P2PTransactionLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tier = snapshot.nextTier;
    return Column(
      key: P2PTransactionLimitsPage.upgradeKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nâng cấp giới hạn',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppModuleAccents.p2p.withValues(alpha: .14),
                      borderRadius: AppRadii.lgRadius,
                    ),
                    child: const SizedBox(
                      width: AppSpacing.inputHeight,
                      height: AppSpacing.inputHeight,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nâng lên Tier ${tier.tier} - ${tier.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Tăng giới hạn lên đến ${_formatMillions(tier.monthlyTotal)} VND/tháng',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x5),
              Text(
                'Yêu cầu:',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              for (final requirement in tier.requirements) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.text3,
                      size: 13,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        requirement,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
              ],
              const SizedBox(height: AppSpacing.x3),
              Material(
                key: P2PTransactionLimitsPage.upgradeCtaKey,
                color: AppModuleAccents.p2p,
                borderRadius: AppRadii.inputRadius,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.kycRequirementsRoute);
                  },
                  borderRadius: AppRadii.inputRadius,
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: AppSpacing.ctaHeight,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Bắt đầu nâng cấp',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: Colors.white,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: AppSpacing.iconMd,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LimitInfoNotice extends StatelessWidget {
  const _LimitInfoNotice({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PTransactionLimitsPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lưu ý về giới hạn',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final item in items) ...[
                  Text(
                    '• $item',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _detailIcon(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_today_outlined,
    'amount' => Icons.attach_money_rounded,
    _ => Icons.trending_up_rounded,
  };
}

Color _toneColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'sell' || 'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

String _formatMillions(double value) {
  return '${_formatComma(value / 1000000, 0)}M';
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
