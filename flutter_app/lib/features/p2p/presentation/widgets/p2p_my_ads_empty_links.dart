part of '../pages/p2p_my_ads_page.dart';

class _EmptyMyAds extends StatelessWidget {
  const _EmptyMyAds({required this.snapshot});

  final P2PMyAdsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.p2pMerchantCommerceLargePadding,
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
      padding: AppSpacing.p2pMerchantCommerceCardPadding,
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
          padding: AppSpacing.p2pMerchantCommerceQuickLinkPadding,
          child: Row(
            children: [
              VitCard(
                width: AppSpacing.p2pMerchantCommerceQuickLinkIconBox,
                height: AppSpacing.p2pMerchantCommerceQuickLinkIconBox,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.sm,
                background: ColoredBox(color: color.withValues(alpha: .10)),
                clip: true,
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
