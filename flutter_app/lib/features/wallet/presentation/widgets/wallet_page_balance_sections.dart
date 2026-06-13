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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.homeAnnouncementCardHorizontalPadding,
        AppSpacing.homePortfolioBadgeVerticalPadding + AppSpacing.x1,
        AppSpacing.homeAnnouncementCardHorizontalPadding,
        AppSpacing.homePortfolioBadgeVerticalPadding,
      ),
      borderColor: _walletPrimary.withValues(alpha: .20),
      child: Stack(
        children: [
          const Positioned.fill(child: _WalletHeroGlow()),
          Column(
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
                  InkWell(
                    key: const Key('sc135_wallet_balance_toggle'),
                    onTap: onToggle,
                    borderRadius: AppRadii.smRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppSpacing.homePortfolioHeaderActionPadding,
                      ),
                      child: Icon(
                        hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.portfolioTextDim,
                        size: AppSpacing.homePortfolioHeaderIcon,
                      ),
                    ),
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
                      const SizedBox(
                        width: AppSpacing.homePortfolioActionSpacing,
                      ),
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
        ],
      ),
    );
  }
}

class _WalletHeroGlow extends StatelessWidget {
  const _WalletHeroGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(.58, -.68),
          radius: .82,
          colors: [
            AppColors.primary12,
            AppColors.primary08.withValues(alpha: .08),
            AppColors.transparent,
          ],
          stops: const [0, .36, 1],
        ),
      ),
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
    return VitCard(
      key: Key('sc135_wallet_action_${action.id}'),
      onTap: onTap,
      height: AppSpacing.searchBarCompactHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.searchBarHorizontalPadding,
      ),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _actionIcon(action.iconKey),
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Flexible(
            child: Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
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
