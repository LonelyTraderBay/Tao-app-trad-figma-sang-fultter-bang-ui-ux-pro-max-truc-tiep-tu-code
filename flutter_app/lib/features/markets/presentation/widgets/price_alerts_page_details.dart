part of '../pages/price_alerts_page.dart';

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.pair,
    required this.onToggle,
    required this.onDelete,
  });

  final MarketPriceAlert alert;
  final MarketPair? pair;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  bool get _isAbove => alert.condition == MarketAlertCondition.above;

  bool get _isTriggered => !alert.isActive && alert.triggeredAt != null;

  @override
  Widget build(BuildContext context) {
    final progress = (alert.currentPrice / alert.targetPrice).clamp(0.0, 1.0);
    final conditionColor = _isAbove ? AppColors.buy : AppColors.sell;
    final avatarColor = pair?.logoColor ?? _marketPrimary;
    final avatarLabel = alert.symbol.split('/').first;

    return VitCard(
      key: PriceAlertsPage.cardKey(alert.id),
      padding: AppSpacing.priceAlertsCardPadding,
      borderColor: _isTriggered
          ? AppColors.buy.withValues(alpha: .24)
          : AppColors.cardBorder,
      clip: _isTriggered,
      background: _isTriggered
          ? ColoredBox(color: AppColors.buy.withValues(alpha: .04))
          : null,
      child: Column(
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: avatarLabel,
                accentColor: avatarColor,
                size: AppSpacing.priceAlertsAvatar,
                radius: AppRadii.pillRadius,
              ),
              const SizedBox(width: AppSpacing.priceAlertsHeaderGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: AppSpacing.marketLineHeightShort,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.marketPairPriceGap),
                    Row(
                      children: [
                        Icon(
                          _isAbove
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: conditionColor,
                          size: AppSpacing.priceAlertsTrendIcon,
                        ),
                        const SizedBox(width: AppSpacing.priceAlertsTrendGap),
                        Flexible(
                          child: Text(
                            '${_isAbove ? 'Tr\u00EAn' : 'D\u01B0\u1EDBi'} ${_formatUsd(alert.targetPrice)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: conditionColor,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: AppSpacing.marketLineHeightTight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isTriggered)
                const VitAccentPill(
                  label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
                  accentColor: AppColors.buy,
                  size: VitStatusPillSize.md,
                  semanticStatus: VitStatusPillStatus.success,
                )
              else
                InkWell(
                  key: PriceAlertsPage.toggleKey(alert.id),
                  onTap: onToggle,
                  borderRadius: AppRadii.cardRadius,
                  child: Icon(
                    alert.isActive
                        ? Icons.toggle_on_rounded
                        : Icons.toggle_off_rounded,
                    color: alert.isActive ? AppColors.buy : AppColors.text3,
                    size: AppSpacing.priceAlertsToggleIcon,
                  ),
                ),
              const SizedBox(width: AppSpacing.priceAlertsActionGap),
              VitIconButton(
                key: PriceAlertsPage.deleteKey(alert.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Delete price alert',
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.sm,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.marketSocialLargeGap),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Gi\u00E1 hi\u1EC7n t\u1EA1i',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: AppSpacing.marketLineHeightTight,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.marketPairMicroGap),
                        Flexible(
                          child: Text(
                            _formatUsd(alert.currentPrice),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: AppSpacing.marketLineHeightTight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.priceAlertsProgressGap),
                    ClipRRect(
                      borderRadius: AppRadii.pillRadius,
                      child: SizedBox(
                        height: AppSpacing.priceAlertsProgressHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const ColoredBox(color: AppColors.surface3),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: ColoredBox(
                                color: _progressColor(alert, progress),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.priceAlertsTargetGap),
              SizedBox(
                width: AppSpacing.priceAlertsTargetWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'M\u1EE5c ti\u00EAu',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppSpacing.marketLineHeightTight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.priceAlertsActionGap),
                    Text(
                      _formatUsd(alert.targetPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: conditionColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: AppSpacing.marketLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isTriggered) ...[
            const SizedBox(height: AppSpacing.priceAlertsTriggeredGap),
            const Divider(
              height: AppSpacing.hairlineStroke,
              thickness: AppSpacing.hairlineStroke,
              color: AppColors.divider,
            ),
            const SizedBox(height: AppSpacing.priceAlertsTriggeredDividerGap),
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.priceAlertsTriggeredIcon,
                ),
                const SizedBox(width: AppSpacing.priceAlertsTriggeredIconGap),
                Expanded(
                  child: Text(
                    'K\u00EDch ho\u1EA1t l\u00FAc 11:30:00 17/2/2024',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: AppSpacing.marketLineHeightTight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyAlertsCard extends StatelessWidget {
  const _EmptyAlertsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.priceAlertsEmptyPadding,
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: AppSpacing.priceAlertsEmptyIcon,
          ),
          const SizedBox(height: AppSpacing.priceAlertsEmptyGap),
          Text(
            'Ch\u01B0a c\u00F3 c\u1EA3nh b\u00E1o n\u00E0o',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
