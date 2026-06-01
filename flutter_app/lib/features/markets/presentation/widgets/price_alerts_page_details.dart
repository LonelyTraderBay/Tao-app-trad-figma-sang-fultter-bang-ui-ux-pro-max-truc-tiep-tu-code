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

    return VitCard(
      key: PriceAlertsPage.cardKey(alert.id),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      borderColor: _isTriggered
          ? AppColors.buy.withValues(alpha: .24)
          : AppColors.cardBorder,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _isTriggered
              ? AppColors.buy.withValues(alpha: .04)
              : AppColors.transparent,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          children: [
            Row(
              children: [
                _AssetAvatar(alert: alert, pair: pair),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.symbol,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontSize: 15,
                          fontWeight: AppTextStyles.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            _isAbove
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: conditionColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${_isAbove ? 'Trên' : 'Dưới'} ${_formatUsd(alert.targetPrice)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: conditionColor,
                                fontSize: 12,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isTriggered)
                  const _TriggeredPill()
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
                      size: 34,
                    ),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  key: PriceAlertsPage.deleteKey(alert.id),
                  onTap: onDelete,
                  borderRadius: AppRadii.smRadius,
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.sell10,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.sell,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Giá hiện tại',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatUsd(alert.currentPrice),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontSize: 12,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 7,
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
                const SizedBox(width: 17),
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Mục tiêu',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatUsd(alert.targetPrice),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: conditionColor,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isTriggered) ...[
              const SizedBox(height: 13),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 11),
              Row(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.buy,
                    size: 15,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Kích hoạt lúc 11:30:00 17/2/2024',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.alert, required this.pair});

  final MarketPriceAlert alert;
  final MarketPair? pair;

  @override
  Widget build(BuildContext context) {
    final color = pair?.logoColor ?? _marketPrimary;
    final symbol = alert.symbol.split('/').first;
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Text(
        symbol.length <= 3 ? symbol : symbol.substring(0, 3),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _TriggeredPill extends StatelessWidget {
  const _TriggeredPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        'Đã kích hoạt',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.buy,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyAlertsCard extends StatelessWidget {
  const _EmptyAlertsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 18),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text3,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            'Chưa có cảnh báo nào',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
