part of '../pages/asset_detail_page.dart';

class _AssetHero extends StatelessWidget {
  const _AssetHero({required this.snapshot});

  final WalletAssetDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    final positive = snapshot.change24h >= 0;

    return Container(
      height: 238,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .13), color.withValues(alpha: .045)],
        ),
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetLogo(snapshot: snapshot, size: 52),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.name,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    snapshot.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 13,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            _formatUsd(snapshot.usdValue),
            style: AppTextStyles.heroNumber.copyWith(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                '${_formatFixed(snapshot.balance, 6)} ${snapshot.symbol}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                _formatPct(snapshot.change24h),
                style: AppTextStyles.caption.copyWith(
                  color: positive ? _assetGreen : _assetRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1,
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
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Trong lệnh',
                  value: _formatFixed(snapshot.inOrder, 6),
                  valueColor: _assetPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  label: 'Đóng băng',
                  value: _formatFixed(snapshot.frozen, 2),
                  valueColor: AppColors.caution,
                ),
              ),
              const SizedBox(width: 8),
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: color.withValues(alpha: .35), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        snapshot.symbol.substring(
          0,
          snapshot.symbol.length < 3 ? snapshot.symbol.length : 3,
        ),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: size >= 50 ? 14 : 10,
          fontWeight: FontWeight.w900,
        ),
      ),
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
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(10, 9, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .05),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
                height: 1,
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
          if (i != actions.length - 1) const SizedBox(width: 12),
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
    return GestureDetector(
      key: AssetDetailPage.actionKey(action.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _assetPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.overlayStroke),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .15),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(
              action.label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
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
      height: 209,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      borderColor: AppColors.overlayStroke,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ giá',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              for (final period in const ['1W', '1M', '3M'])
                GestureDetector(
                  key: AssetDetailPage.periodKey(period),
                  onTap: () => onPeriod(period),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 27,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activePeriod == period
                          ? _assetPrimary.withValues(alpha: .18)
                          : AppColors.transparent,
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Text(
                      period,
                      style: AppTextStyles.micro.copyWith(
                        color: activePeriod == period
                            ? _assetPrimary
                            : AppColors.text2,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomPaint(
              painter: _AssetChartPainter(points: snapshot.chart, color: color),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
