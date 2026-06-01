part of '../pages/margin_trading_page.dart';

class _SideToggle extends StatelessWidget {
  const _SideToggle({required this.side, required this.onChanged});

  final String side;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _marginPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _SideButton(
            id: 'long',
            label: 'Long',
            icon: Icons.trending_up_rounded,
            color: _marginGreen,
            active: side == 'long',
            onTap: () => onChanged('long'),
          ),
          const SizedBox(width: 8),
          _SideButton(
            id: 'short',
            label: 'Short',
            icon: Icons.trending_down_rounded,
            color: AppColors.text3,
            active: side == 'short',
            onTap: () => onChanged('short'),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = active ? color : AppColors.text3;
    return Expanded(
      child: InkWell(
        key: MarginTradingPage.sideKey(id),
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: .13)
                : AppColors.transparent,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              color: active
                  ? color.withValues(alpha: .35)
                  : AppColors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: resolvedColor, size: 17),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: resolvedColor,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSelector extends StatelessWidget {
  const _LeverageSelector({
    required this.leverage,
    required this.expanded,
    required this.onTap,
  });

  final int leverage;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: InkWell(
        key: MarginTradingPage.leverageKey,
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _marginAmber.withValues(alpha: .13),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: _marginAmber,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đòn bẩy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhân ${leverage}x giá trị vị thế',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              _MiniBadge(
                label: '${leverage}x',
                color: _marginAmber,
                large: true,
              ),
              const SizedBox(width: 10),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeverageSheet extends StatelessWidget {
  const _LeverageSheet({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [2, 3, 5, 10, 20, 50];
    return _Panel(
      color: AppColors.surface2,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in options)
            InkWell(
              onTap: () => onChanged(option),
              borderRadius: AppRadii.mdRadius,
              child: Container(
                width: 55,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == option ? _marginPrimary : _marginCard,
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  '${option}x',
                  style: AppTextStyles.caption.copyWith(
                    color: selected == option
                        ? AppColors.onAccent
                        : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
