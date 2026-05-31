part of 'wallet_page_sections.dart';

class WalletBalanceHero extends StatelessWidget {
  const WalletBalanceHero({
    super.key,
    required this.snapshot,
    required this.hidden,
    required this.onToggle,
    required this.onNavigate,
  });

  final WalletSnapshot snapshot;
  final bool hidden;
  final VoidCallback onToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 324,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 17),
      decoration: BoxDecoration(
        color: _walletHero,
        border: Border.all(color: _walletPrimary.withValues(alpha: .20)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tài sản ước tính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              GestureDetector(
                key: const Key('sc135_wallet_balance_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: onToggle,
                child: Icon(
                  hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.text2,
                  size: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hidden ? '••••••' : _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 31,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hidden
                ? '•••••• BTC'
                : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 19),
          _BreakdownRow(snapshot: snapshot, hidden: hidden),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < snapshot.actions.length; i++) ...[
                Expanded(
                  child: _ActionTile(
                    action: snapshot.actions[i],
                    onTap: () => onNavigate(snapshot.actions[i].route),
                  ),
                ),
                if (i != snapshot.actions.length - 1) const SizedBox(width: 12),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.snapshot, required this.hidden});

  final WalletSnapshot snapshot;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Khả dụng',
        snapshot.availableUsd,
        _walletGreen,
        Icons.visibility_outlined,
      ),
      ('Trong lệnh', snapshot.inOrderUsd, _walletAmber, Icons.flag_rounded),
      ('Đóng băng', snapshot.frozenUsd, _walletRed, Icons.lock_outline_rounded),
    ];
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(items[i].$4, color: items[i].$3, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          items[i].$1,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hidden ? '••••' : _formatUsd(items[i].$2),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'Roboto',
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1) const SizedBox(width: 2),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final WalletAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(action.colorHex);
    return GestureDetector(
      key: Key('sc135_wallet_action_${action.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.onAccent.withValues(alpha: .10),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Icon(_actionIcon(action.iconKey), color: color, size: 22),
            ),
            const SizedBox(height: 7),
            Text(
              action.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
