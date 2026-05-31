part of 'wallet_page_sections.dart';

class WalletSegmentedTabs extends StatelessWidget {
  const WalletSegmentedTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [('assets', 'Danh sách'), ('chart', 'Phân bổ')];
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _walletPanel2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: GestureDetector(
                key: Key('sc135_wallet_tab_${tab.$1}'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(tab.$1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == tab.$1
                        ? _walletPrimary
                        : AppColors.transparent,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    tab.$2,
                    style: AppTextStyles.caption.copyWith(
                      color: active == tab.$1
                          ? AppColors.onAccent
                          : AppColors.text3,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WalletSearchAndFilter extends StatelessWidget {
  const WalletSearchAndFilter({
    super.key,
    required this.controller,
    required this.filterActive,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool filterActive;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: _walletPanel2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: const Key('sc135_wallet_search'),
                    controller: controller,
                    onChanged: onChanged,
                    cursorColor: _walletPrimary,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Tìm tài sản...',
                      hintStyle: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 9),
        GestureDetector(
          key: const Key('sc135_wallet_filter'),
          behavior: HitTestBehavior.opaque,
          onTap: onFilter,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filterActive ? _walletPrimary : _walletPanel2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: filterActive ? AppColors.onAccent : AppColors.text3,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}

class WalletAssetHeader extends StatelessWidget {
  const WalletAssetHeader({
    super.key,
    required this.count,
    required this.onNavigate,
  });

  final int count;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count tài sản',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _HeaderButton(
          label: 'Sổ địa chỉ',
          foreground: AppColors.text2,
          background: _walletPanel2,
          onTap: () => onNavigate('/wallet/address-book'),
        ),
        const SizedBox(width: 8),
        _HeaderButton(
          label: 'Phân tích',
          foreground: _walletPrimary,
          background: _walletPrimary.withValues(alpha: .12),
          onTap: () => onNavigate('/wallet/portfolio-analytics'),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: foreground.withValues(alpha: .22)),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: foreground,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class WalletAssetList extends StatelessWidget {
  const WalletAssetList({
    super.key,
    required this.assets,
    required this.hidden,
    required this.onNavigate,
  });

  final List<WalletAsset> assets;
  final bool hidden;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _walletPanel,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          'Không tìm thấy tài sản',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _walletPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              hidden: hidden,
              last: i == assets.length - 1,
              onTap: () => onNavigate('/wallet/asset/${assets[i].id}'),
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.hidden,
    required this.last,
    required this.onTap,
  });

  final WalletAsset asset;
  final bool hidden;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    final changeColor = asset.change24h >= 0 ? _walletGreen : _walletRed;
    return GestureDetector(
      key: Key('sc135_wallet_asset_${asset.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: last
                ? BorderSide.none
                : const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: .45)),
              ),
              child: Text(
                asset.symbol.length > 3
                    ? asset.symbol.substring(0, 3)
                    : asset.symbol,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          asset.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 14,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _formatPct(asset.change24h),
                          style: AppTextStyles.micro.copyWith(
                            color: changeColor,
                            fontSize: 10,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset.name,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hidden ? '••••' : _formatAssetAmount(asset.balance),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hidden ? '••••' : '≈ ${_formatUsd(asset.usdValue)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 13),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
