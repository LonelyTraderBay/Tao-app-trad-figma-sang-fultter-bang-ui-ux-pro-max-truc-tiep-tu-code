part of '../pages/p2p_transaction_limits_page.dart';

class _LimitDetailRow extends StatelessWidget {
  const _LimitDetailRow({required this.item});

  final P2PTransactionLimitDetailDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);
    return Padding(
      key: P2PTransactionLimitsPage.detailItemKey(item.id),
      padding: _p2pLimitsCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.p2pTransactionLimitsIconBox,
            child: Material(
              type: MaterialType.transparency,
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
              child: Icon(
                _detailIcon(item.iconKey),
                color: color,
                size: AppSpacing.p2pTransactionLimitsDetailIcon,
              ),
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
        const SizedBox(height: _p2pLimitsSectionGap),
        VitCard(
          radius: VitCardRadius.lg,
          padding: _p2pLimitsCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: AppSpacing.p2pTransactionLimitsIconBox,
                    child: Material(
                      type: MaterialType.transparency,
                      color: AppModuleAccents.p2p.withValues(alpha: .14),
                      borderRadius: AppRadii.lgRadius,
                      child: const Icon(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _p2pLimitsMajorGap),
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
                      size: AppSpacing.p2pTransactionLimitsRequirementIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        requirement,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
              ],
              const SizedBox(height: _p2pLimitsSectionGap),
              Material(
                key: P2PTransactionLimitsPage.upgradeCtaKey,
                color: AppModuleAccents.p2p,
                borderRadius: AppRadii.inputRadius,
                child: VitCard(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.kycRequirementsRoute);
                  },
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.sm,
                  padding: AppSpacing.zeroInsets,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppSpacing.ctaHeight,
                    ),
                    child: Padding(
                      padding: AppSpacing.p2pTransactionLimitsCtaPadding,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Bắt đầu nâng cấp',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.onAccent,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.onAccent,
                              size: AppSpacing.iconMd,
                            ),
                          ],
                        ),
                      ),
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
    return Material(
      key: P2PTransactionLimitsPage.infoKey,
      type: MaterialType.transparency,
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppModuleAccents.p2p.withValues(alpha: .28)),
      ),
      child: Padding(
        padding: _p2pLimitsInnerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppModuleAccents.p2p,
              size: AppSpacing.p2pTransactionLimitsInfoIcon,
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
                    ),
                  ),
                  const SizedBox(height: _p2pLimitsSectionGap),
                  for (final item in items) ...[
                    Text(
                      '• $item',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: _p2pLimitsInfoLineHeight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
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
