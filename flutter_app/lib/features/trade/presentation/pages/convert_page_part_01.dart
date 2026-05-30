part of 'convert_page.dart';

class _ConvertHeader extends StatelessWidget {
  const _ConvertHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          InkWell(
            key: ConvertPage.backKey,
            onTap: onBack,
            borderRadius: AppRadii.cardRadius,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 27,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Convert / Swap',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _chipBackground,
              border: Border.all(
                color: AppColors.onAccent.withValues(alpha: .06),
              ),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.text1,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});

  final _ConvertMode mode;
  final ValueChanged<_ConvertMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _chipBackground,
        border: Border.all(color: _tradePrimary.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _ModeTab(
            key: ConvertPage.modeKey('market'),
            label: 'Market',
            icon: Icons.bolt_rounded,
            active: mode == _ConvertMode.market,
            onTap: () => onChanged(_ConvertMode.market),
          ),
          _ModeTab(
            key: ConvertPage.modeKey('limit'),
            label: 'Limit',
            icon: Icons.gps_fixed_rounded,
            active: mode == _ConvertMode.limit,
            onTap: () => onChanged(_ConvertMode.limit),
          ),
          _ModeTab(
            key: ConvertPage.modeKey('schedule'),
            label: 'Tự động',
            icon: Icons.calendar_today_rounded,
            active: mode == _ConvertMode.schedule,
            onTap: () => onChanged(_ConvertMode.schedule),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: active
                ? AppColors.bg.withValues(alpha: .52)
                : AppColors.transparent,
            borderRadius: AppRadii.inputRadius,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? AppColors.text1 : AppColors.text3,
                size: 15,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.text1 : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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

class _FavoriteHeader extends StatelessWidget {
  const _FavoriteHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Cặp thường dùng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const Spacer(),
        const Icon(Icons.star_rounded, color: AppColors.primary, size: 15),
        const SizedBox(width: 4),
        Text(
          'Đã lưu',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _FavoritePairs extends StatelessWidget {
  const _FavoritePairs({
    required this.pairs,
    required this.activeFrom,
    required this.activeTo,
    required this.onSelected,
  });

  final List<TradeConvertFavoritePair> pairs;
  final String activeFrom;
  final String activeTo;
  final ValueChanged<TradeConvertFavoritePair> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pairs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          final active =
              pair.fromSymbol == activeFrom && pair.toSymbol == activeTo;
          return InkWell(
            key: ConvertPage.favoriteKey(pair.label),
            onTap: () => onSelected(pair),
            borderRadius: AppRadii.cardRadius,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.transparent : _chipBackground,
                border: Border.all(
                  color: active
                      ? _tradePrimary
                      : _tradePrimary.withValues(alpha: .20),
                ),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Text(
                pair.label,
                style: AppTextStyles.micro.copyWith(
                  color: active ? _tradePrimary : AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RateBar extends StatelessWidget {
  const _RateBar({required this.label, required this.countdown});

  final String label;
  final String countdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _rateBackground,
        border: Border.all(color: _tradePrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_rounded, color: _tradePrimary, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.swap_vert_rounded, color: AppColors.text3, size: 16),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 13,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            countdown,
            style: AppTextStyles.micro.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.refresh_rounded, color: _tradePrimary, size: 15),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.asset,
    required this.onAssetTap,
    this.amountController,
    this.quoteAmount,
    this.input = false,
    this.onChanged,
    this.onPercent,
  });

  final String label;
  final TradeConvertAsset asset;
  final VoidCallback onAssetTap;
  final TextEditingController? amountController;
  final double? quoteAmount;
  final bool input;
  final VoidCallback? onChanged;
  final ValueChanged<int>? onPercent;

  @override
  Widget build(BuildContext context) {
    final height = input ? 176.0 : 108.0;
    final balanceLabel =
        'Số dư: ${formatConvertBalance(asset.balance, asset.symbol)} ${asset.symbol}';
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _panelBackground,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .07)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const Spacer(),
              Text(
                balanceLabel,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _AssetButton(
                key: input ? ConvertPage.fromAssetKey : ConvertPage.toAssetKey,
                asset: asset,
                onTap: onAssetTap,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: input
                    ? TextField(
                        key: ConvertPage.amountFieldKey,
                        controller: amountController,
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,8}'),
                          ),
                        ],
                        onChanged: (_) => onChanged?.call(),
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                          fontSize: 22,
                          fontFamily: 'monospace',
                          fontWeight: AppTextStyles.bold,
                        ),
                        cursorColor: _tradePrimary,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text3,
                            fontSize: 22,
                            fontFamily: 'monospace',
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      )
                    : Text(
                        formatConvertQuoteAmount(
                          quoteAmount ?? 0,
                          asset.symbol,
                        ),
                        textAlign: TextAlign.right,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text3,
                          fontSize: 22,
                          fontFamily: 'monospace',
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
              ),
            ],
          ),
          if (input) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                for (final pct in const [25, 50, 75, 100]) ...[
                  _PercentChip(
                    key: ConvertPage.pctKey(pct),
                    label: '$pct%',
                    onTap: () => onPercent?.call(pct),
                  ),
                  if (pct != 100) const SizedBox(width: 8),
                ],
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Min: \$10',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: 16),
                Text(
                  'Max: \$500,000',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetButton extends StatelessWidget {
  const _AssetButton({super.key, required this.asset, required this.onTap});

  final TradeConvertAsset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .22)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Text(
                asset.symbol.substring(0, math.min(3, asset.symbol.length)),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 8,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              asset.symbol,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _PercentChip extends StatelessWidget {
  const _PercentChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        width: 50,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _chipBackground,
          border: Border.all(color: _tradePrimary.withValues(alpha: .16)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
