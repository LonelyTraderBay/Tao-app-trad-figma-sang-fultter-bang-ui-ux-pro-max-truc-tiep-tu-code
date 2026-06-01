part of '../pages/p2p_wallet_page.dart';

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({
    required this.snapshot,
    required this.expandedAsset,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final String? expandedAsset;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PWalletPage.balancesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tài sản',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (var index = 0; index < snapshot.balances.length; index++) ...[
          _BalanceCard(
            snapshot: snapshot,
            balance: snapshot.balances[index],
            expanded: expandedAsset == snapshot.balances[index].asset,
            onToggle: () => onToggle(snapshot.balances[index].asset),
          ),
          if (index != snapshot.balances.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.snapshot,
    required this.balance,
    required this.expanded,
    required this.onToggle,
  });

  final P2PWalletSnapshot snapshot;
  final P2PWalletBalanceDraft balance;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PWalletPage.balanceKey(balance.asset),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.cardLargeRadius,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  _AssetMark(symbol: balance.asset),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              balance.asset,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Flexible(
                              child: Text(
                                '≈ \$${_formatComma(balance.usdValue, 2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          _formatAssetTotal(balance),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, color: AppColors.borderSolid),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  _BalanceBreakdown(balance: balance),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.depositKey(balance.asset),
                          label: 'Chuyển vào',
                          icon: Icons.add_rounded,
                          color: AppColors.buy,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=deposit',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InlineActionButton(
                          key: P2PWalletPage.withdrawKey(balance.asset),
                          label: 'Chuyển ra',
                          icon: Icons.remove_rounded,
                          color: AppModuleAccents.p2p,
                          onTap: () => context.go(
                            '${snapshot.transferRoute}?asset=${balance.asset}&type=withdraw',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (balance.inEscrow > 0) ...[
                    const SizedBox(height: AppSpacing.x3),
                    _EscrowDetailButton(
                      asset: balance.asset,
                      onTap: () => context.go(
                        '${snapshot.escrowBalanceRoute}?asset=${balance.asset}',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetMark extends StatelessWidget {
  const _AssetMark({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _assetColor(symbol).withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
      ),
      child: SizedBox(
        width: AppSpacing.inputHeight,
        height: AppSpacing.inputHeight,
        child: Icon(
          _assetIcon(symbol),
          color: _assetColor(symbol),
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _BalanceBreakdown extends StatelessWidget {
  const _BalanceBreakdown({required this.balance});

  final P2PWalletBalanceDraft balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BreakdownItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Khả dụng',
            value: _formatBalancePart(balance.available, balance.asset),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.lock_outline_rounded,
            label: 'Escrow',
            value: _formatBalancePart(balance.inEscrow, balance.asset),
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _BreakdownItem(
            icon: Icons.shield_outlined,
            label: 'Locked',
            value: _formatBalancePart(balance.locked, balance.asset),
            color: AppColors.text2,
          ),
        ),
      ],
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.text3, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
