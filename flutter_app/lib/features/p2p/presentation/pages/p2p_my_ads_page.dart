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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

enum _MyAdsFilter { all, active, paused }

class P2PMyAdsPage extends ConsumerStatefulWidget {
  const P2PMyAdsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc225_p2p_my_ads_content');
  static const createButtonKey = Key('sc225_p2p_my_ads_create');
  static Key analyticsKey(String adId) => Key('sc225_analytics_$adId');
  static Key toggleKey(String adId) => Key('sc225_toggle_$adId');
  static Key editKey(String adId) => Key('sc225_edit_$adId');
  static Key deleteKey(String adId) => Key('sc225_delete_$adId');
  static Key quickLinkKey(String id) => Key('sc225_quick_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMyAdsPage> createState() => _P2PMyAdsPageState();
}

class _P2PMyAdsPageState extends ConsumerState<P2PMyAdsPage> {
  _MyAdsFilter _filter = _MyAdsFilter.all;
  final Map<String, P2PMyAdStatus> _statusOverrides = {};
  final Set<String> _deletedAds = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pMyAdsProvider);
    final ads = _resolveAds(snapshot.ads);
    final activeCount = ads
        .where((ad) => ad.status == P2PMyAdStatus.active)
        .length;
    final pausedCount = ads
        .where((ad) => ad.status == P2PMyAdStatus.paused)
        .length;
    final totalVolume = ads.fold<int>(
      0,
      (sum, ad) => sum + ad.totalVolume30dUsd,
    );
    final filtered = ads
        .where((ad) {
          return switch (_filter) {
            _MyAdsFilter.all => true,
            _MyAdsFilter.active => ad.status == P2PMyAdStatus.active,
            _MyAdsFilter.paused => ad.status == P2PMyAdStatus.paused,
          };
        })
        .toList(growable: false);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-225 P2PMyAdsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Quảng cáo của tôi',
              subtitle: 'Quảng cáo · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
              trailing: VitIconButton(
                key: P2PMyAdsPage.createButtonKey,
                icon: Icons.add_rounded,
                tooltip: 'Tạo quảng cáo',
                variant: VitIconButtonVariant.primary,
                onPressed: () => context.go(AppRoutePaths.p2pCreate),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PMyAdsPage.contentKey,
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
                      _StatsRow(
                        activeCount: activeCount,
                        pausedCount: pausedCount,
                        totalVolume: totalVolume,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      VitTabBar(
                        variant: VitTabBarVariant.segment,
                        activeKey: _filter.name,
                        onChanged: (key) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = _filterFromKey(key));
                        },
                        tabs: [
                          VitTabItem(
                            key: _MyAdsFilter.all.name,
                            label: 'Tất cả (${ads.length})',
                          ),
                          VitTabItem(
                            key: _MyAdsFilter.active.name,
                            label: 'Hoạt động ($activeCount)',
                          ),
                          VitTabItem(
                            key: _MyAdsFilter.paused.name,
                            label: 'Tạm dừng ($pausedCount)',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      if (filtered.isEmpty)
                        _EmptyMyAds(snapshot: snapshot)
                      else
                        for (final ad in filtered) ...[
                          _MyAdCard(
                            ad: ad,
                            onAnalytics: () => context.go(
                              AppRoutePaths.p2pAdAnalytics('sample'),
                            ),
                            onToggle: () => _toggleStatus(ad),
                            onEdit: () => context.go(AppRoutePaths.p2pCreate),
                            onDelete: () => _confirmDelete(context, ad),
                          ),
                          const SizedBox(height: AppSpacing.x3),
                        ],
                      const SizedBox(height: AppSpacing.x3),
                      _QuickLinksCard(links: snapshot.quickLinks),
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

  List<P2PMyAdDraft> _resolveAds(List<P2PMyAdDraft> ads) {
    return [
      for (final ad in ads)
        if (!_deletedAds.contains(ad.id))
          ad.copyWith(status: _statusOverrides[ad.id]),
    ];
  }

  void _toggleStatus(P2PMyAdDraft ad) {
    HapticFeedback.selectionClick();
    final nextStatus = ad.status == P2PMyAdStatus.active
        ? P2PMyAdStatus.paused
        : P2PMyAdStatus.active;
    setState(() => _statusOverrides[ad.id] = nextStatus);
  }

  Future<void> _confirmDelete(BuildContext context, P2PMyAdDraft ad) async {
    HapticFeedback.lightImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Xóa quảng cáo này?',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Text(
            'Quảng cáo sẽ bị xóa vĩnh viễn. Các đơn hàng đang xử lý sẽ không bị ảnh hưởng.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Hủy',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Xóa',
                style: AppTextStyles.caption.copyWith(color: AppColors.sell),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _deletedAds.add(ad.id);
      _statusOverrides.remove(ad.id);
    });
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.activeCount,
    required this.pausedCount,
    required this.totalVolume,
  });

  final int activeCount;
  final int pausedCount;
  final int totalVolume;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: activeCount.toString(),
            label: 'Đang hoạt động',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatCard(
            value: pausedCount.toString(),
            label: 'Tạm dừng',
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatCard(
            value: '\$${_formatCompactUsd(totalVolume)}',
            label: 'KL 30 ngày',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      height: AppSpacing.buttonHero + AppSpacing.x5,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MyAdCard extends StatelessWidget {
  const _MyAdCard({
    required this.ad,
    required this.onAnalytics,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final P2PMyAdDraft ad;
  final VoidCallback onAnalytics;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final typeColor = ad.type == P2PTradeType.sell
        ? AppColors.sell
        : AppColors.buy;
    final active = ad.status == P2PMyAdStatus.active;
    final statusColor = active ? AppColors.buy : AppColors.warn;

    return Opacity(
      opacity: active ? 1 : .72,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _MiniBadge(
                  label:
                      '${ad.type == P2PTradeType.sell ? 'BÁN' : 'MUA'} ${ad.asset}',
                  color: typeColor,
                ),
                _MiniBadge(label: _statusLabel(ad.status), color: statusColor),
                if (ad.priceType == 'floating')
                  _MiniBadge(label: 'Thả nổi', color: AppModuleAccents.p2p),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    _formatVnd(ad.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                      fontFamily: 'Roboto',
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '${ad.currency}/${ad.asset}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                if (ad.priceMargin != null) ...[
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    '${ad.priceMargin! >= 0 ? '+' : ''}${ad.priceMargin!.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(
                      color: ad.priceMargin! >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DetailColumn(
                    label: 'Khả dụng',
                    value: '${_formatAmount(ad.available)} ${ad.asset}',
                  ),
                ),
                Expanded(
                  child: _DetailColumn(
                    label: 'Giới hạn',
                    value:
                        '${_formatVnd(ad.minLimit)}-\n${_formatVnd(ad.maxLimit)}',
                  ),
                ),
                Expanded(
                  child: _DetailColumn(
                    label: 'Thanh toán',
                    value: ad.paymentMethods.join(', '),
                  ),
                ),
              ],
            ),
            if (ad.tradingHours != null) ...[
              const SizedBox(height: AppSpacing.x3),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    ad.tradingHours!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.x4),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    key: P2PMyAdsPage.analyticsKey(ad.id),
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    color: AppModuleAccents.p2p,
                    onTap: onAnalytics,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: _ActionButton(
                    key: P2PMyAdsPage.toggleKey(ad.id),
                    icon: active
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    label: active ? 'Dừng' : 'Bật',
                    color: AppColors.text2,
                    onTap: onToggle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: _ActionButton(
                    key: P2PMyAdsPage.editKey(ad.id),
                    icon: Icons.edit_rounded,
                    label: 'Sửa',
                    color: AppColors.primary,
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                _DeleteButton(
                  key: P2PMyAdsPage.deleteKey(ad.id),
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
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
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
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
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Ink(
          height: AppSpacing.inputHeight - AppSpacing.x2,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            border: Border.all(color: color.withValues(alpha: .18)),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.inputHeight - AppSpacing.x2,
      child: _ActionButton(
        icon: Icons.delete_outline_rounded,
        label: '',
        color: AppColors.sell,
        onTap: onTap,
      ),
    );
  }
}

class _EmptyMyAds extends StatelessWidget {
  const _EmptyMyAds({required this.snapshot});

  final P2PMyAdsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () => context.go(AppRoutePaths.p2pCreate),
            variant: VitCtaButtonVariant.primary,
            child: Text(snapshot.emptyActionLabel),
          ),
        ],
      ),
    );
  }
}

class _QuickLinksCard extends StatelessWidget {
  const _QuickLinksCard({required this.links});

  final List<P2PQuickLinkDraft> links;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIÊN KẾT NHANH',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var i = 0; i < links.length; i++) ...[
            _QuickLinkTile(link: links[i]),
            if (i < links.length - 1)
              const Divider(color: AppColors.divider, height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({required this.link});

  final P2PQuickLinkDraft link;

  @override
  Widget build(BuildContext context) {
    final icon = switch (link.iconKey) {
      'settings' => Icons.settings_outlined,
      'block' => Icons.person_off_outlined,
      'guide' => Icons.menu_book_rounded,
      _ => Icons.chevron_right_rounded,
    };
    final color = switch (link.iconKey) {
      'block' => AppColors.sell,
      'guide' => AppModuleAccents.p2p,
      _ => AppColors.text2,
    };

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: P2PMyAdsPage.quickLinkKey(link.id),
        onTap: () => context.go(link.route),
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Icon(icon, color: color, size: AppSpacing.iconSm),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      link.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_MyAdsFilter _filterFromKey(String key) {
  return _MyAdsFilter.values.firstWhere(
    (filter) => filter.name == key,
    orElse: () => _MyAdsFilter.all,
  );
}

String _statusLabel(P2PMyAdStatus status) {
  return switch (status) {
    P2PMyAdStatus.active => 'Hoạt động',
    P2PMyAdStatus.paused => 'Tạm dừng',
    P2PMyAdStatus.expired => 'Hết hạn',
  };
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
