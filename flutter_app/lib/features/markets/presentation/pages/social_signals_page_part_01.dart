part of 'social_signals_page.dart';

class _SocialSignalsPageState extends ConsumerState<SocialSignalsPage> {
  String _tab = 'signals';
  TradingSignalStatus? _statusFilter;
  TradingSignalCategory? _categoryFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(marketControllerProvider);
    final snapshot = repo.getSocialSignals(
      statusFilter: _statusFilter,
      categoryFilter: _categoryFilter,
    );
    final allSnapshot = repo.getSocialSignals();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-025 SocialSignalsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tín hiệu giao dịch',
            subtitle: 'Tín hiệu · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SocialSignalsTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: SocialSignalsPage.contentKey,
                    padding: AppSpacing.marketScrollPadding(bottomInset),
                    child: VitPageContent(
                      density: VitDensity.compact,
                      children: [
                        const _RiskDisclaimerCard(),
                        if (_tab == 'signals') ...[
                          _StatusFilterChips(
                            statusFilter: _statusFilter,
                            statusConfigs: snapshot.statusConfigs,
                            onSelected: (value) => setState(() {
                              _statusFilter = value;
                            }),
                          ),
                          _CategoryFilterChips(
                            categoryFilter: _categoryFilter,
                            onSelected: (value) => setState(() {
                              _categoryFilter = value;
                            }),
                          ),
                          if (snapshot.signals.isEmpty)
                            const _SignalsEmptyState()
                          else
                            for (final signal in snapshot.signals)
                              _SignalCard(
                                key: SocialSignalsPage.signalCardKey(signal.id),
                                signal: signal,
                                tierConfig:
                                    snapshot.tierConfigs[signal.providerTier]!,
                                statusConfig:
                                    snapshot.statusConfigs[signal.status]!,
                                expanded: _expandedId == signal.id,
                                onTap: () => setState(() {
                                  _expandedId = _expandedId == signal.id
                                      ? null
                                      : signal.id;
                                }),
                              ),
                        ] else if (_tab == 'providers') ...[
                          for (
                            var index = 0;
                            index < allSnapshot.providers.length;
                            index += 1
                          )
                            _ProviderCard(
                              key: SocialSignalsPage.providerCardKey(
                                allSnapshot.providers[index].name,
                              ),
                              rank: index + 1,
                              provider: allSnapshot.providers[index],
                              tierConfig:
                                  allSnapshot.tierConfigs[allSnapshot
                                      .providers[index]
                                      .tier]!,
                            ),
                        ] else ...[
                          _PerformanceSummary(snapshot: allSnapshot),
                          _StatusBreakdown(snapshot: allSnapshot),
                          const _SectionHeader(
                            label: 'Kết quả tín hiệu',
                            accentColor: _marketPrimary,
                          ),
                          for (final signal
                              in allSnapshot.signals
                                  .where(
                                    (signal) =>
                                        signal.status !=
                                        TradingSignalStatus.active,
                                  )
                                  .toList()
                                ..sort((a, b) => b.pnlPct.compareTo(a.pnlPct)))
                            _SignalResultRow(
                              signal: signal,
                              statusConfig:
                                  allSnapshot.statusConfigs[signal.status]!,
                            ),
                        ],
                      ],
                    ),
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

class _SocialSignalsTabs extends StatelessWidget {
  const _SocialSignalsTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _UnderlinedTab(
                    key: SocialSignalsPage.signalsTabKey,
                    label: 'Tín hiệu',
                    value: 'signals',
                    active: activeTab == 'signals',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: SocialSignalsPage.providersTabKey,
                    label: 'Nhà cung cấp',
                    value: 'providers',
                    active: activeTab == 'providers',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: SocialSignalsPage.performanceTabKey,
                    label: 'Hiệu suất',
                    value: 'performance',
                    active: activeTab == 'performance',
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        onTap: () => onChanged(value),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        borderColor: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSpacing.dividerHairline,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskDisclaimerCard extends StatelessWidget {
  const _RiskDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: AppSpacing.marketSocialDisclaimerIconPadding,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.warn,
              size: AppSpacing.x4,
            ),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          Expanded(
            child: Text(
              'Tín hiệu từ cộng đồng chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư. Luôn tự nghiên cứu và quản lý rủi ro.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.statusFilter,
    required this.statusConfigs,
    required this.onSelected,
  });

  final TradingSignalStatus? statusFilter;
  final Map<TradingSignalStatus, SignalStatusConfig> statusConfigs;
  final ValueChanged<TradingSignalStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipButton(
            key: SocialSignalsPage.statusAllKey,
            label: 'Tất cả',
            active: statusFilter == null,
            color: AppAssetColors.neutralChain,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _FilterChipButton(
            key: SocialSignalsPage.statusActiveKey,
            label: statusConfigs[TradingSignalStatus.active]!.label,
            active: statusFilter == TradingSignalStatus.active,
            color: statusConfigs[TradingSignalStatus.active]!.color,
            onTap: () => onSelected(TradingSignalStatus.active),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _FilterChipButton(
            key: SocialSignalsPage.statusTargetHitKey,
            label: statusConfigs[TradingSignalStatus.targetHit]!.label,
            active: statusFilter == TradingSignalStatus.targetHit,
            color: statusConfigs[TradingSignalStatus.targetHit]!.color,
            onTap: () => onSelected(TradingSignalStatus.targetHit),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _FilterChipButton(
            key: SocialSignalsPage.statusStoppedKey,
            label: statusConfigs[TradingSignalStatus.stopped]!.label,
            active: statusFilter == TradingSignalStatus.stopped,
            color: statusConfigs[TradingSignalStatus.stopped]!.color,
            onTap: () => onSelected(TradingSignalStatus.stopped),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.categoryFilter,
    required this.onSelected,
  });

  final TradingSignalCategory? categoryFilter;
  final ValueChanged<TradingSignalCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            key: SocialSignalsPage.categoryAllKey,
            label: 'Tất cả',
            active: categoryFilter == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _CategoryChip(
            key: SocialSignalsPage.categoryScalpKey,
            label: 'Scalp',
            active: categoryFilter == TradingSignalCategory.scalp,
            onTap: () => onSelected(TradingSignalCategory.scalp),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _CategoryChip(
            key: SocialSignalsPage.categorySwingKey,
            label: 'Swing',
            active: categoryFilter == TradingSignalCategory.swing,
            onTap: () => onSelected(TradingSignalCategory.swing),
          ),
          const SizedBox(width: AppSpacing.marketSocialGap),
          _CategoryChip(
            key: SocialSignalsPage.categoryPositionKey,
            label: 'Position',
            active: categoryFilter == TradingSignalCategory.position,
            onTap: () => onSelected(TradingSignalCategory.position),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: active ? color.withValues(alpha: .12) : AppColors.surface2,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.mdRadius,
            side: BorderSide(
              color: active
                  ? color.withValues(alpha: .30)
                  : AppColors.transparent,
            ),
          ),
        ),
        child: Padding(
          padding: AppSpacing.marketSocialFilterPadding.add(
            const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x2),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.captionSm.copyWith(
                color: active ? color : AppColors.text3,
                fontWeight: AppTextStyles.medium,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .12)
              : AppColors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Padding(
          padding: AppSpacing.marketSocialFilterPadding.add(
            const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x2),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? _marketPrimary : AppColors.text3,
                fontWeight: AppTextStyles.medium,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
