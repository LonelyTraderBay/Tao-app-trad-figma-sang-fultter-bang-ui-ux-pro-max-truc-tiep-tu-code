part of '../pages/convert_page.dart';

class _ConvertHeader extends StatelessWidget {
  const _ConvertHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.detail,
      title: 'Convert / Swap',
      showBack: true,
      backKey: ConvertPage.backKey,
      onBack: onBack,
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.notifications,
          tooltip: 'Thông báo Convert',
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});

  final _ConvertMode mode;
  final ValueChanged<_ConvertMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: _convertModeHeight,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x2,
        top: AppSpacing.x2,
        right: AppSpacing.x2,
        bottom: AppSpacing.x2,
      ),
      borderColor: _tradePrimary.withValues(alpha: .18),
      child: VitTabBar(
        variant: VitTabBarVariant.segment,
        activeKey: mode.name,
        onChanged: (key) => onChanged(
          _ConvertMode.values.firstWhere((mode) => mode.name == key),
        ),
        tabs: [
          VitTabItem(
            key: _ConvertMode.market.name,
            label: 'Market',
            icon: Icons.bolt_rounded,
            widgetKey: ConvertPage.modeKey('market'),
          ),
          VitTabItem(
            key: _ConvertMode.limit.name,
            label: 'Limit',
            icon: Icons.gps_fixed_rounded,
            widgetKey: ConvertPage.modeKey('limit'),
          ),
          VitTabItem(
            key: _ConvertMode.schedule.name,
            label: 'Tự động',
            icon: Icons.calendar_today_rounded,
            widgetKey: ConvertPage.modeKey('schedule'),
          ),
        ],
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
        const SizedBox(width: _convertSpace),
        const Icon(
          Icons.star_rounded,
          color: AppColors.primary,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x1),
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
      height: _convertChipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pairs.length,
        separatorBuilder: (_, _) => const SizedBox(width: _convertSpace),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          final active =
              pair.fromSymbol == activeFrom && pair.toSymbol == activeTo;
          return VitCard(
            key: ConvertPage.favoriteKey(pair.label),
            onTap: () => onSelected(pair),
            variant: active ? VitCardVariant.ghost : VitCardVariant.inner,
            height: _convertChipHeight,
            density: VitDensity.compact,
            padding: AppSpacing.zeroInsets.copyWith(
              left: AppSpacing.rowPy,
              right: AppSpacing.rowPy,
            ),
            alignment: Alignment.center,
            borderColor: active
                ? _tradePrimary
                : _tradePrimary.withValues(alpha: .20),
            child: Text(
              pair.label,
              style: AppTextStyles.micro.copyWith(
                color: active ? _tradePrimary : AppColors.text1,
                fontWeight: AppTextStyles.bold,
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
    return VitCard(
      height: _convertControlHeight,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
      ),
      borderColor: _tradePrimary.withValues(alpha: .22),
      child: Row(
        children: [
          const Icon(
            Icons.sync_rounded,
            color: _tradePrimary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: _convertSpace),
          const Icon(
            Icons.swap_vert_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const SizedBox(width: _convertSpace),
          Text(
            countdown,
            style: AppTextStyles.micro.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: _convertSpace),
          const Icon(
            Icons.refresh_rounded,
            color: _tradePrimary,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}
