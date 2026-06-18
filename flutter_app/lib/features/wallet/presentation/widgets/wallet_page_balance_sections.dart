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
    const primaryIds = ['deposit', 'withdraw', 'transfer'];
    final actionsById = {
      for (final action in snapshot.actions) action.id: action,
    };
    final primaryActions = [
      for (final id in primaryIds)
        if (actionsById[id] != null) actionsById[id]!,
    ];
    final secondaryActions = snapshot.actions
        .where((action) => !primaryIds.contains(action.id))
        .toList();

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      clip: true,
      padding: AppSpacing.homePortfolioCardPadding,
      borderColor: _walletPrimary.withValues(alpha: .20),
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tài sản ước tính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              VitInlineIconAction(
                key: const Key('sc135_wallet_balance_toggle'),
                tooltip: hidden ? 'Show balance' : 'Hide balance',
                onPressed: onToggle,
                icon: hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.portfolioTextDim,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.homeSectionInnerGap),
          Text(
            hidden ? '••••••' : _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.onAccent,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            hidden
                ? '••••• BTC'
                : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC',
            style: AppTextStyles.numericMicro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          _BreakdownRow(snapshot: snapshot, hidden: hidden),
          const SizedBox(height: AppSpacing.homeActionRowGap),
          Row(
            children: [
              for (var i = 0; i < primaryActions.length; i++) ...[
                Expanded(
                  child: _HeroActionButton(
                    action: primaryActions[i],
                    primary: i == 0,
                    onTap: () => onNavigate(primaryActions[i].route),
                  ),
                ),
                if (i != primaryActions.length - 1)
                  const SizedBox(width: AppSpacing.homePortfolioActionSpacing),
              ],
            ],
          ),
          if (secondaryActions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x3),
            _CompactActionRow(
              actions: secondaryActions,
              onNavigate: onNavigate,
            ),
          ],
        ],
      ),
    );
  }
}

class WalletPendingDepositStatusCard extends StatelessWidget {
  const WalletPendingDepositStatusCard({
    super.key,
    required this.pendingDeposits,
    required this.onNavigate,
  });

  final WalletPendingDepositsSnapshot pendingDeposits;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final count = pendingDeposits.pendingCount;
    return VitNextActionCard(
      icon: Icons.access_time_rounded,
      title: '$count giao d\u1ECBch n\u1EA1p \u0111ang ch\u1EDD',
      subtitle:
          'Theo d\u00F5i x\u00E1c nh\u1EADn blockchain v\u00E0 b\u01B0\u1EDBc ti\u1EBFp theo',
      statusLabel: '\u0110ang x\u1EED l\u00FD',
      ctaLabel: 'Xem',
      accentColor: _walletAmber,
      onTap: () => onNavigate('/wallet/pending-deposits'),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.action,
    required this.primary,
    required this.onTap,
  });

  final WalletAction action;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: Key('sc135_wallet_action_${action.id}'),
      height: AppSpacing.homeHeroActionHeight,
      density: VitDensity.compact,
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      onPressed: onTap,
      leading: Icon(_actionIcon(action.iconKey)),
      child: Text(action.label),
    );
  }
}

class _CompactActionRow extends StatelessWidget {
  const _CompactActionRow({required this.actions, required this.onNavigate});

  final List<WalletAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(
            child: _CompactActionChip(
              action: actions[i],
              onTap: () => onNavigate(actions[i].route),
            ),
          ),
          if (i != actions.length - 1)
            const SizedBox(width: AppSpacing.gridGap),
        ],
      ],
    );
  }
}

class _CompactActionChip extends StatelessWidget {
  const _CompactActionChip({required this.action, required this.onTap});

  final WalletAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(action.colorHex);
    return VitCtaButton(
      key: Key('sc135_wallet_action_${action.id}'),
      height: AppSpacing.searchBarCompactHeight,
      density: VitDensity.compact,
      variant: VitCtaButtonVariant.ghost,
      onPressed: onTap,
      padding: AppSpacing.walletAddressFilterPadding,
      leading: Icon(_actionIcon(action.iconKey), color: color),
      child: Text(action.label),
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
      borderColor: AppColors.onAccent.withValues(alpha: .08),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: VitStatusPill(
                      label: items[i].$1,
                      status: _breakdownStatus(items[i].$3),
                      icon: items[i].$4,
                      size: VitStatusPillSize.sm,
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

VitStatusPillStatus _breakdownStatus(Color color) {
  if (color == _walletGreen) return VitStatusPillStatus.success;
  if (color == _walletAmber) return VitStatusPillStatus.warning;
  if (color == _walletRed) return VitStatusPillStatus.error;
  return VitStatusPillStatus.neutral;
}
