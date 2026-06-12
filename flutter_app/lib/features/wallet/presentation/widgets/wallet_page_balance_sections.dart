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
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.cardPaddingHero,
      borderColor: _walletPrimary.withValues(alpha: .20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tài sản ước tính',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
                  size: AppSpacing.iconSm,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            hidden ? '••••••' : _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.amountLg.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            hidden
                ? '••••• BTC'
                : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC',
            style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x5),
          _BreakdownRow(snapshot: snapshot, hidden: hidden),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              for (var i = 0; i < snapshot.actions.length; i++) ...[
                Expanded(
                  child: _ActionTile(
                    action: snapshot.actions[i],
                    onTap: () => onNavigate(snapshot.actions[i].route),
                  ),
                ),
                if (i != snapshot.actions.length - 1)
                  const SizedBox(width: AppSpacing.rowGapRegular),
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

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: AppSpacing.cardPaddingCompact,
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
                        Icon(
                          items[i].$4,
                          color: items[i].$3,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          items[i].$1,
                          style: AppTextStyles.numericMicro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    hidden ? '••••' : _formatUsd(items[i].$2),
                    style: AppTextStyles.amountSm.copyWith(
                      color: AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1) const SizedBox(width: AppSpacing.x1),
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
    return VitCard(
      key: Key('sc135_wallet_action_${action.id}'),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      borderColor: AppColors.portfolioBtnGhostBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSpacing.iconLg,
            height: AppSpacing.iconLg,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _actionIcon(action.iconKey),
              color: color,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            action.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
