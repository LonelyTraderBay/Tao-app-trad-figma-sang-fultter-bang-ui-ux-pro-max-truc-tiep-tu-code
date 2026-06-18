part of '../pages/asset_detail_page.dart';

class _AssetHero extends StatelessWidget {
  const _AssetHero({required this.snapshot});

  final WalletAssetDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    final positive = snapshot.change24h >= 0;

    return VitCard(
      variant: VitCardVariant.hero,
      height: AppSpacing.walletAssetHeroHeight,
      padding: AppSpacing.walletAssetHeroPadding,
      borderColor: color.withValues(alpha: .25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetLogo(
                snapshot: snapshot,
                size: AppSpacing.walletAssetLogoSize,
              ),
              const SizedBox(width: AppSpacing.sectionGapCompact),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.name,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.walletAssetSmallGap),
                  Text(
                    snapshot.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAssetHeroTopGap),
          Text(
            _formatUsd(snapshot.usdValue),
            style: AppTextStyles.amountMd.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.walletAssetHeroValueGap),
          Row(
            children: [
              Text(
                '${_formatFixed(snapshot.balance, 6)} ${snapshot.symbol}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.walletAssetPillGap),
              Text(
                _formatPct(snapshot.change24h),
                style: AppTextStyles.caption.copyWith(
                  color: positive ? _assetGreen : _assetRed,
                  fontWeight: AppTextStyles.bold,
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
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatPill(
                  label: 'Trong lệnh',
                  value: _formatFixed(snapshot.inOrder, 6),
                  valueColor: _assetPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _StatPill(
                  label: 'Đóng băng',
                  value: _formatFixed(snapshot.frozen, 2),
                  valueColor: AppColors.caution,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
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
    return VitAssetAvatar(
      label: snapshot.symbol,
      accentColor: color,
      size: size,
      radius: AppRadii.pillRadius,
      border: true,
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
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: AppSpacing.walletAssetStatHeight,
      padding: AppSpacing.walletAssetStatPillPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
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
          if (i != actions.length - 1)
            const SizedBox(width: AppSpacing.walletAssetActionGap),
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
    return VitCard(
      key: AssetDetailPage.actionKey(action.id),
      height: AppSpacing.walletAssetActionHeight,
      padding: AppSpacing.walletAssetActionTilePadding,
      borderColor: AppColors.overlayStroke,
      onTap: onTap,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            width: AppSpacing.walletAssetActionIcon,
            height: AppSpacing.walletAssetActionIcon,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .22),
            child: Icon(
              icon,
              color: color,
              size: AppSpacing.walletAssetActionIconInner,
            ),
          ),
          const Spacer(),
          Text(
            action.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
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
    return VitCard(
      height: AppSpacing.walletAssetChartHeight,
      padding: AppSpacing.cardPadding.copyWith(
        bottom: AppSpacing.walletAssetChartBottomPad,
      ),
      borderColor: AppColors.overlayStroke,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ giá',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              for (final period in const ['1W', '1M', '3M'])
                VitStatusPill(
                  key: AssetDetailPage.periodKey(period),
                  label: period,
                  status: activePeriod == period
                      ? VitStatusPillStatus.info
                      : VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.md,
                  outline: activePeriod != period,
                  onTap: () => onPeriod(period),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.walletAssetChartBottomGap),
          Expanded(
            child: VitSparkline(
              values: [for (final point in snapshot.chart) point.price],
              color: color,
              strokeWidth: AppSpacing.borderWidth,
            ),
          ),
        ],
      ),
    );
  }
}
