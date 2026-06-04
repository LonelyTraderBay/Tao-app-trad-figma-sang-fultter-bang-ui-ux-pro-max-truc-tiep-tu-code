part of '../pages/p2p_transaction_limits_page.dart';

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
                color: AppColors.onAccent,
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
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Giới hạn hiện tại của bạn',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .90),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.onAccent.withValues(alpha: .20),
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
                      color: AppColors.onAccent,
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
        color: AppColors.onAccent.withValues(alpha: .18),
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
                color: AppColors.onAccent.withValues(alpha: .82),
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.onAccent,
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
