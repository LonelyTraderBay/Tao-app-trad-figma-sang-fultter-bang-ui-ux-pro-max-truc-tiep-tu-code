part of 'auto_compound_settings_page.dart';

class _AutoCompoundSettingsPageState
    extends ConsumerState<AutoCompoundSettingsPage> {
  final Map<String, bool> _enabled = {};
  final Map<String, String> _frequencies = {};
  final Map<String, double> _thresholds = {};
  String? _editingId;
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(autoCompoundSettingsRepositoryProvider)
        .getSettings();
    final positions = [
      for (final position in snapshot.positions) _resolved(position),
    ];
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-341 AutoCompoundSettingsPage',
      child: Material(
        color: AppColors.bg,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
                actions: [
                  VitHeaderActionItem(
                    key: AutoCompoundSettingsPage.infoButtonKey,
                    type: VitHeaderActionType.help,
                    onPressed: () => _openInfo(snapshot),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: AppSpacing.zeroInsets.copyWith(
                        bottom: bottomInset,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _SummaryCard(positions: positions),
                          VitPageSection(
                            label: 'Vị thế tiết kiệm',
                            accentColor: AppColors.buy,
                            children: [
                              for (final position in positions)
                                _PositionCard(
                                  position: position,
                                  onToggle: () => _toggle(position),
                                  onSettings: () =>
                                      _openSettings(snapshot, position),
                                ),
                            ],
                          ),
                          _CalculatorPreview(),
                          _NoteCard(text: snapshot.note),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Auto-compound settings review',
                            message:
                                'Position toggles, compound frequency, threshold changes, yield impact, save confirmation, and success feedback are reviewed before automation is updated.',
                            contractId: 'SC-341',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showSuccess)
              Positioned(
                left: AppSpacing.contentPad,
                right: AppSpacing.contentPad,
                top: MediaQuery.paddingOf(context).top + AppSpacing.x7,
                child: _SuccessToast(
                  onDismiss: () {
                    setState(() => _showSuccess = false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  AutoCompoundPositionDraft _resolved(AutoCompoundPositionDraft position) {
    return AutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      earned: position.earned,
      apy: position.apy,
      type: position.type,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
      compoundFrequency:
          _frequencies[position.id] ?? position.compoundFrequency,
      compoundThreshold: _thresholds[position.id] ?? position.compoundThreshold,
      lastCompounded: position.lastCompounded,
      totalCompounded: position.totalCompounded,
      compoundCount: position.compoundCount,
      estimatedBoost: position.estimatedBoost,
    );
  }

  void _toggle(AutoCompoundPositionDraft position) {
    HapticFeedback.selectionClick();
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  Future<void> _openInfo(AutoCompoundSettingsSnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(child: _InfoSheet(snapshot: snapshot));
      },
    );
  }

  Future<void> _openSettings(
    AutoCompoundSettingsSnapshot snapshot,
    AutoCompoundPositionDraft position,
  ) async {
    HapticFeedback.selectionClick();
    setState(() => _editingId = position.id);
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(
          child: _SettingsSheet(
            snapshot: snapshot,
            position: _resolved(position),
            onToggle: () {
              _toggle(_resolved(position));
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onFrequency: (frequency) {
              HapticFeedback.selectionClick();
              setState(() => _frequencies[position.id] = frequency);
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onThreshold: (threshold) {
              HapticFeedback.selectionClick();
              setState(() => _thresholds[position.id] = threshold);
              Navigator.of(context).pop();
              _openSettings(snapshot, position);
            },
            onSave: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              setState(() {
                _editingId = null;
                _showSuccess = true;
              });
            },
          ),
        );
      },
    );
    if (mounted && _editingId == position.id) {
      setState(() => _editingId = null);
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<AutoCompoundPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    final totalCompounded = positions.fold<double>(
      0,
      (sum, position) =>
          sum + _usdValue(position.asset, position.totalCompounded),
    );
    final totalEvents = positions.fold<int>(
      0,
      (sum, position) => sum + position.compoundCount,
    );

    return VitCard(
      key: AutoCompoundSettingsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: AppSpacing.cardPaddingHero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Auto-Compound Overview',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Đang bật',
                  value: '$active/${positions.length}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Đã compound (USD)',
                  value: _formatUsd(totalCompounded),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Tổng lần',
                  value: '$totalEvents',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.onToggle,
    required this.onSettings,
  });

  final AutoCompoundPositionDraft position;
  final VoidCallback onToggle;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final effectiveApy = position.autoCompound
        ? position.apy + position.estimatedBoost / 100
        : position.apy;
    final accent = _assetColor(position.asset);

    return VitCard(
      key: AutoCompoundSettingsPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          '${_formatAmount(position.amount)} ${position.asset}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        Text(
                          '${effectiveApy.toStringAsFixed(2)}% APY',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: AutoCompoundSettingsPage.toggleKey(position.id),
                on: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          if (position.autoCompound)
            _CompoundDetails(position: position)
          else
            _DisabledWarning(),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: position.autoCompound ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  position.autoCompound
                      ? '+${(position.estimatedBoost / 100).toStringAsFixed(2)}% APY từ compound'
                      : 'Bật compound để tăng APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              TextButton.icon(
                key: AutoCompoundSettingsPage.settingsButtonKey(position.id),
                onPressed: onSettings,
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Cài đặt'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompoundDetails extends StatelessWidget {
  const _CompoundDetails({required this.position});

  final AutoCompoundPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _frequencyLabel(position.compoundFrequency),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Ngưỡng: ${_formatAmount(position.compoundThreshold)} ${position.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã compound: ${_formatAmount(position.totalCompounded)} ${position.asset}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                '${position.compoundCount} lần',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (position.lastCompounded != '—') ...[
            const SizedBox(height: AppSpacing.x1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gần nhất: ${position.lastCompounded}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DisabledWarning extends StatelessWidget {
  const _DisabledWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Auto-compound đang tắt — lãi sẽ tích luỹ riêng, không cộng vào gốc',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: AppSpacing.autoCompoundSettingsWarningLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
