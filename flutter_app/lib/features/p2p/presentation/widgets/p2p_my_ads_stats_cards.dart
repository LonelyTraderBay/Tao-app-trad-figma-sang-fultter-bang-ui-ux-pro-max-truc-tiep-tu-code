part of '../pages/p2p_my_ads_page.dart';

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
        padding: const EdgeInsets.all(AppSpacing.x3),
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
            const SizedBox(height: AppSpacing.x3),
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
            const SizedBox(height: AppSpacing.x3),
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
            const SizedBox(height: AppSpacing.x3),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: AppSpacing.x2),
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
