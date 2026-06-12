part of 'staking_liquid_staking_page.dart';

class _StakingLiquidStakingPageState
    extends ConsumerState<StakingLiquidStakingPage> {
  final _swapAmountController = TextEditingController();
  _LiquidTab _tab = _LiquidTab.stake;
  String _swapFrom = 'stETH';
  String _swapTo = 'ETH';

  @override
  void dispose() {
    _swapAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingLiquidStakingRepositoryProvider)
        .getLiquidStaking();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-364 StakingLiquidStakingPage',
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _InfoBanner(snapshot: snapshot),
                      _LiquidTabs(
                        active: _tab,
                        onChanged: (tab) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _LiquidTab.stake)
                        _StakeTab(
                          snapshot: snapshot,
                          onDetail: _showTokenDetail,
                          onStake: (token) {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã chọn stake ${token.symbol}'),
                              ),
                            );
                          },
                        ),
                      if (_tab == _LiquidTab.swap)
                        _SwapTab(
                          snapshot: snapshot,
                          swapFrom: _swapFrom,
                          swapTo: _swapTo,
                          amountController: _swapAmountController,
                          onFromChanged: (value) =>
                              setState(() => _swapFrom = value),
                          onToChanged: (value) =>
                              setState(() => _swapTo = value),
                          onAmountChanged: (_) => setState(() {}),
                          onReverse: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              final oldFrom = _swapFrom;
                              _swapFrom = _swapTo;
                              _swapTo = oldFrom;
                            });
                          },
                        ),
                      if (_tab == _LiquidTab.holdings)
                        _HoldingsTab(
                          snapshot: snapshot,
                          onStakeNow: () {
                            HapticFeedback.selectionClick();
                            setState(() => _tab = _LiquidTab.stake);
                          },
                        ),
                      _BenefitsGrid(snapshot: snapshot),
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

  Future<void> _showTokenDetail(StakingLiquidTokenDraft token) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(child: _TokenDetailSheet(token: token));
      },
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingLiquidStakingPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.water_drop_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidTabs extends StatelessWidget {
  const _LiquidTabs({required this.active, required this.onChanged});

  final _LiquidTab active;
  final ValueChanged<_LiquidTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingLiquidStakingPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _LiquidTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                selected: active == tab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _LiquidTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: StakingLiquidStakingPage.tabKey(tab.name),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x4),
          child: Column(
            children: [
              Text(
                _tabLabel(tab),
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primary : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: selected ? AppSpacing.buttonHero : 0,
                height: AppSpacing.stakingProductTabIndicatorHeight,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.transparent,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StakeTab extends StatelessWidget {
  const _StakeTab({
    required this.snapshot,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final ValueChanged<StakingLiquidTokenDraft> onDetail;
  final ValueChanged<StakingLiquidTokenDraft> onStake;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Chọn Liquid Token',
          accentColor: AppColors.primary,
          children: [
            for (final token in snapshot.tokens)
              _LiquidTokenCard(
                token: token,
                onDetail: () => onDetail(token),
                onStake: () => onStake(token),
              ),
          ],
        ),
        _RiskNote(snapshot: snapshot),
      ],
    );
  }
}

class _LiquidTokenCard extends StatelessWidget {
  const _LiquidTokenCard({
    required this.token,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidTokenDraft token;
  final VoidCallback onDetail;
  final VoidCallback onStake;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingLiquidStakingPage.tokenKey(token.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.ctaHeight,
                height: AppSpacing.ctaHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  borderRadius: AppRadii.xlRadius,
                  border: Border.all(color: AppColors.primary30),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.primarySoft,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            token.symbol,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        _ProtocolPill(label: token.protocol),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '1 ${token.symbol} = ${token.exchangeRate.toStringAsFixed(3)} ${token.underlyingAsset}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${token.apy.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TokenMetric(
                  label: 'TVL',
                  value: _formatBillions(token.tvl),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TokenMetric(
                  label: 'Supply',
                  value: _formatMillions(token.totalSupply),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.detailButtonKey(token.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  onPressed: onDetail,
                  child: const Text('Chi tiết'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.stakeButtonKey(token.id),
                  height: AppSpacing.buttonCompact,
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onPressed: onStake,
                  child: const Text('Stake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProtocolPill extends StatelessWidget {
  const _ProtocolPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary15,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.primarySoft,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TokenMetric extends StatelessWidget {
  const _TokenMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _RiskNote extends StatelessWidget {
  const _RiskNote({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Lưu ý: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: snapshot.riskNote,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
