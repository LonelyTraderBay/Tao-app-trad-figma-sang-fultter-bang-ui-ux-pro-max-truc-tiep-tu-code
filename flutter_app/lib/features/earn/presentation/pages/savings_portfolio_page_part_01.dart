part of 'savings_portfolio_page.dart';

class _SavingsPortfolioPageState extends ConsumerState<SavingsPortfolioPage> {
  _PortfolioTab _tab = _PortfolioTab.overview;
  _PositionFilter _filter = _PositionFilter.all;
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsPortfolioRepositoryProvider)
        .getPortfolio();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-333 SavingsPortfolioPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                color: AppColors.surface,
                child: Padding(
                  padding: AppSpacing.earnHorizontalPaddingX4,
                  child: VitTabBar(
                    variant: VitTabBarVariant.underline,
                    activeKey: _tab.name,
                    onChanged: (key) {
                      HapticFeedback.selectionClick();
                      setState(() => _tab = _PortfolioTab.values.byName(key));
                    },
                    tabs: [
                      const VitTabItem(key: 'overview', label: 'Tổng quan'),
                      const VitTabItem(key: 'positions', label: 'Vị thế'),
                      const VitTabItem(key: 'earnings', label: 'Thu nhập'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      if (_tab == _PortfolioTab.overview)
                        _OverviewTab(
                          snapshot: snapshot,
                          hideBalance: _hideBalance,
                          onToggleBalance: () {
                            HapticFeedback.selectionClick();
                            setState(() => _hideBalance = !_hideBalance);
                          },
                        )
                      else if (_tab == _PortfolioTab.positions)
                        _PositionsTab(
                          snapshot: snapshot,
                          activeFilter: _filter,
                          onFilterChanged: (filter) {
                            HapticFeedback.selectionClick();
                            setState(() => _filter = filter);
                          },
                        )
                      else
                        _EarningsTab(
                          snapshot: snapshot,
                          hideBalance: _hideBalance,
                        ),
                    ],
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.snapshot,
    required this.hideBalance,
    required this.onToggleBalance,
  });

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      customGap: AppSpacing.x3,
      children: [
        _PortfolioHero(
          snapshot: snapshot,
          hideBalance: hideBalance,
          onToggleBalance: onToggleBalance,
        ),
        _SectionLabel(label: 'Phân bổ tài sản', color: AppColors.primary),
        _AllocationCard(
          positions: snapshot.positions,
          total: snapshot.totalDepositedUsd,
        ),
        _SectionLabel(label: 'Dự phóng thu nhập', color: AppColors.buy),
        _IncomeProjectionRow(items: snapshot.incomeProjections),
        _InfoBanner(
          text:
              'Ước tính dựa trên APY hiện tại. Lãi suất có thể thay đổi theo điều kiện thị trường.',
        ),
        _SectionLabel(label: 'Lịch đáo hạn', color: AppColors.warn),
        _MaturitySummary(events: snapshot.maturityEvents),
        for (final event in snapshot.maturityEvents) ...[
          _MaturityCard(event: event),
          if (event != snapshot.maturityEvents.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        _WarningBanner(
          text:
              'Khi đáo hạn, bạn có thể gia hạn để tiếp tục nhận lãi hoặc rút về ví. Rút trước hạn có thể mất lãi tích lũy.',
        ),
      ],
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({
    required this.snapshot,
    required this.hideBalance,
    required this.onToggleBalance,
  });

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final balance = hideBalance ? '••••••' : snapshot.totalDepositedUsd;
    final gain = hideBalance ? '••••' : snapshot.gainLabel;

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tiết kiệm (USD)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _HeroIconButton(
                icon: hideBalance
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onPressed: onToggleBalance,
              ),
              const SizedBox(width: AppSpacing.x2),
              _HeroIconButton(
                icon: Icons.refresh_rounded,
                onPressed: () => HapticFeedback.selectionClick(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            balance,
            style: AppTextStyles.numericDisplayLg.copyWith(
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.buy15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                  ),
                ),
                child: Padding(
                  padding: AppSpacing.earnPillPadding,
                  child: Text(
                    gain,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'lãi tích lũy',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Linh hoạt',
                  value: hideBalance ? '••••' : snapshot.flexibleTotalUsd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Cố định',
                  value: hideBalance ? '••••' : snapshot.lockedTotalUsd,
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(child: _HeroPositionStat(snapshot: snapshot)),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  label: 'Gửi thêm',
                  icon: Icons.arrow_downward_rounded,
                  primary: true,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Rút',
                  icon: Icons.arrow_upward_rounded,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  key: SavingsPortfolioPage.historyButtonKey,
                  label: 'Lịch sử',
                  icon: Icons.schedule_rounded,
                  onTap: () => context.go(snapshot.historyRoute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.savingsPortfolioHeroIconButton,
      height: AppSpacing.savingsPortfolioHeroIconButton,
      child: IconButton(
        onPressed: onPressed,
        padding: AppSpacing.zeroInsets,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.portfolioBtnGhost,
          side: const BorderSide(color: AppColors.portfolioBtnGhostBorder),
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: const BorderSide(color: AppColors.portfolioBtnGhostBorder),
        ),
      ),
      child: Padding(
        padding: AppSpacing.earnPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPositionStat extends StatelessWidget {
  const _HeroPositionStat({required this.snapshot});

  final SavingsPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: const BorderSide(color: AppColors.portfolioBtnGhostBorder),
        ),
      ),
      child: Padding(
        padding: AppSpacing.earnPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vị thế',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                const _TinyDot(color: AppColors.buy),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  '${snapshot.activePositions}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const _TinyDot(color: AppColors.warn),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  '${snapshot.maturingPositions}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      variant: primary
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.savingsPortfolioActionHeight,
      padding: AppSpacing.earnHorizontalPaddingX2,
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      leading: Icon(icon),
      child: Text(label),
    );
  }
}
