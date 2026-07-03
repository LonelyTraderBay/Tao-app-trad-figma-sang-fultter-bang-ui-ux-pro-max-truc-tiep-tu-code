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
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _savingsPortfolioVisualNavClearance
            : _savingsPortfolioNativeNavClearance) +
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: VitInsetScrollView(
              physics: const ClampingScrollPhysics(),
              bottomInset: scrollEndPadding,
              child: VitPageContent(
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                  VitSegmentedTabBar(
                    activeKey: _tab.name,
                    onChanged: (key) {
                      HapticFeedback.selectionClick();
                      setState(() => _tab = _PortfolioTab.values.byName(key));
                    },
                    tabs: const [
                      VitTabItem(key: 'overview', label: 'Tổng quan'),
                      VitTabItem(
                        key: 'positions',
                        label: 'Vị thế',
                        widgetKey: SavingsPortfolioPage.positionsTabKey,
                      ),
                      VitTabItem(key: 'earnings', label: 'Thu nhập'),
                    ],
                  ),
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
                    _EarningsTab(snapshot: snapshot, hideBalance: _hideBalance),
                ],
              ),
            ),
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
      density: VitDensity.compact,
      fullBleed: true,
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
        EarnInfoBanner(
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
        EarnWarningBanner(
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
      radius: VitCardRadius.large,
      padding: _savingsPortfolioCardPadding,
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
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
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
              Text(
                'lãi tích lũy',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
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
          const SizedBox(height: AppSpacing.x3),
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
    return VitIconButton(
      icon: icon,
      tooltip: 'Thao tác danh mục',
      onPressed: onPressed,
      variant: VitIconButtonVariant.ghost,
      size: VitIconButtonSize.sm,
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
      density: VitDensity.compact,
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


class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.positions, required this.total});

  final List<SavingsPortfolioPositionDraft> positions;
  final String total;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _savingsPortfolioCardPadding,
      child: Column(
        children: [
          SizedBox(
            height: _savingsPortfolioDonutExtent,
            child: CustomPaint(
              painter: _DonutPainter(
                segments: [
                  for (final position in positions)
                    _DonutSegment(
                      value: _allocationValue(position.allocationLabel),
                      color: _assetColor(position.asset),
                    ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tổng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      total,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final position in positions) ...[
            _AllocationRow(position: position),
            if (position != positions.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.asset);
    return Column(
      children: [
        Row(
          children: [
            _TinyDot(
              color: color,
              size: AppSpacing.savingsPortfolioAllocationDot,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                position.asset,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              position.usdValue,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            SizedBox(
              width: AppSpacing.savingsPortfolioAllocationPercentWidth,
              child: Text(
                position.allocationLabel,
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        _ProgressBar(
          progress: _allocationValue(position.allocationLabel),
          color: color,
        ),
      ],
    );
  }
}

class _IncomeProjectionRow extends StatelessWidget {
  const _IncomeProjectionRow({required this.items});

  final List<SavingsIncomeProjectionDraft> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _IncomeProjectionCard(item: item)),
          if (item != items.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _IncomeProjectionCard extends StatelessWidget {
  const _IncomeProjectionCard({required this.item});

  final SavingsIncomeProjectionDraft item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.icon) {
      'month' => Icons.calendar_month_outlined,
      'year' => Icons.bar_chart_rounded,
      _ => Icons.wb_sunny_outlined,
    };
    return VitCard(
      radius: VitCardRadius.large,
      padding: _savingsPortfolioCardPadding,
      child: Column(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.primary12,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            item.label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaturitySummary extends StatelessWidget {
  const _MaturitySummary({required this.events});

  final List<SavingsMaturityEventDraft> events;

  @override
  Widget build(BuildContext context) {
    final total = events.length;
    return VitCard(
      radius: VitCardRadius.large,
      padding: _savingsPortfolioCardPadding,
      child: Row(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.warn10,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: const SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sắp đáo hạn',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '$total khoản',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng giá trị',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                '\$6,000.86',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaturityCard extends StatelessWidget {
  const _MaturityCard({required this.event});

  final SavingsMaturityEventDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(event.tone);
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: 0.45),
      padding: _savingsPortfolioCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: event.asset, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: _StatusPill(
                            label: _statusLabel(event.tone),
                            color: color,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          event.apy,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _DaysPill(days: event.daysLeft, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface3,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
            ),
            child: Padding(
              padding: _savingsPortfolioCardPadding,
              child: Row(
                children: [
                  Expanded(
                    child: _MiniMetric(label: 'Số lượng', value: event.amount),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: 'Giá trị',
                      value: event.usdValue,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Text(
                'Hoàn thành ${(event.progress * 100).round()}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Expanded(
                child: Text(
                  event.elapsedLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(progress: event.progress, color: color),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Đáo hạn: ${event.date}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Gia hạn',
                  icon: Icons.refresh_rounded,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SecondaryButton(
                  label: 'Rút khi đáo hạn',
                  icon: Icons.arrow_upward_rounded,
                  color: color,
                  onTap: () => HapticFeedback.selectionClick(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final SavingsPortfolioSnapshot snapshot;
  final _PositionFilter activeFilter;
  final ValueChanged<_PositionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final positions = snapshot.positions.where((position) {
      return switch (activeFilter) {
        _PositionFilter.all => true,
        _PositionFilter.flexible =>
          position.type == SavingsProductType.flexible,
        _PositionFilter.locked => position.type == SavingsProductType.locked,
      };
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          activeKey: activeFilter.name,
          onChanged: (key) =>
              onFilterChanged(_PositionFilter.values.byName(key)),
          tabs: const [
            VitTabItem(key: 'all', label: 'Tất cả'),
            VitTabItem(key: 'flexible', label: 'Linh hoạt'),
            VitTabItem(key: 'locked', label: 'Cố định'),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final position in positions) ...[
          _PositionCard(position: position),
          if (position != positions.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final SavingsPortfolioPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(position.asset);
    return VitCard(
      radius: VitCardRadius.large,
      padding: _savingsPortfolioCardPadding,
      child: Row(
        children: [
          _AssetBadge(asset: position.asset, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.product,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${position.amount} - ${position.apy} APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                position.earned,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                position.usdValue,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _EarningsTab extends StatelessWidget {
  const _EarningsTab({required this.snapshot, required this.hideBalance});

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: _savingsPortfolioCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Tổng lãi nhận được',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _StatusPill(
                        label: '+0.752%',
                        color: AppColors.buy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                hideBalance ? '••••••' : '+\$77.72',
                style: AppTextStyles.numericDisplayXl.copyWith(
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'APY ${snapshot.weightedApy} - Lãi tiết kiệm',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        _SectionLabel(label: 'Lãi theo tài sản', color: AppColors.accent),
        const SizedBox(height: AppSpacing.x2),
        VitCard(
          radius: VitCardRadius.large,
          padding: _savingsPortfolioCardPadding,
          child: Column(
            children: [
              for (final position in snapshot.positions) ...[
                _AllocationRow(position: position),
                if (position != snapshot.positions.last)
                  const SizedBox(height: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.hairlineRadius,
            ),
          ),
          child: const SizedBox(
            width: AppSpacing.savingsPortfolioSectionMarkerWidth,
            height: _savingsPortfolioSectionMarkerExtent,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot({required this.color, this.size = 6});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
      child: SizedBox(width: size, height: size),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.substring(0, math.min(asset.length, 2)),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.24)),
        ),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _DaysPill extends StatelessWidget {
  const _DaysPill({required this.days, required this.color});

  final int days;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.16),
        shape: CircleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            '$days\nngày',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: color,
              height: _savingsPortfolioDaysLineHeight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text1,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final variant = color == AppColors.sell
        ? VitCtaButtonVariant.danger
        : color == AppColors.warn
        ? VitCtaButtonVariant.warning
        : VitCtaButtonVariant.secondary;

    return VitCtaButton(
      onPressed: onTap,
      variant: variant,
      height: _savingsPortfolioSecondaryButtonExtent,
      leading: Icon(icon),
      child: Text(label),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

final class _DonutSegment {
  const _DonutSegment({required this.value, required this.color});

  final double value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.segments});

  final List<_DonutSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = AppSpacing.savingsPortfolioDonutStrokeWidth;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: AppSpacing.savingsPortfolioDonutDiameter,
      height: AppSpacing.savingsPortfolioDonutDiameter,
    );
    var start = -math.pi / 2;
    for (final segment in segments) {
      final sweep = math.pi * 2 * segment.value;
      paint.color = segment.color;
      canvas.drawArc(rect, start, sweep - 0.035, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

double _allocationValue(String allocationLabel) {
  final value = double.tryParse(allocationLabel.replaceAll('%', '')) ?? 0;
  return (value / 100).clamp(0, 1);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primarySoft,
    _ => AppColors.primary,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.primary,
  };
}

String _statusLabel(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => 'Còn lâu',
    EarnRiskLevel.medium => 'Gần đáo hạn',
    EarnRiskLevel.high => 'Sắp tới',
  };
}

