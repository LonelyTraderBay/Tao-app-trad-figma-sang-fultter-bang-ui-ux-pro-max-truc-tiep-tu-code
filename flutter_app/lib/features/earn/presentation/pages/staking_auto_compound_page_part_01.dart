part of 'staking_auto_compound_page.dart';

class _StakingAutoCompoundPageState
    extends ConsumerState<StakingAutoCompoundPage> {
  late final TextEditingController _thresholdController;
  late final TextEditingController _principalController;
  late final TextEditingController _apyController;
  late final TextEditingController _monthsController;
  final Map<String, bool> _enabled = {};

  String _frequency = 'daily';
  bool _gasOptimization = true;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController(text: '10');
    _principalController = TextEditingController(text: '1000');
    _apyController = TextEditingController(text: '7.5');
    _monthsController = TextEditingController(text: '12');
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _principalController.dispose();
    _apyController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAutoCompoundRepositoryProvider)
        .getAutoCompound();
    final positions = [
      for (final position in snapshot.positions) _resolved(position),
    ];
    final threshold = _parseDouble(_thresholdController.text, 10);
    final simulation = _buildSimulation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-363 StakingAutoCompoundPage',
      child: Material(
        color: AppColors.bg,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
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
                          _SummaryCard(
                            positions: positions,
                            frequency: _frequency,
                            threshold: threshold,
                          ),
                          VitPageSection(
                            label: 'Cài đặt Auto-Compound',
                            accentColor: AppColors.primary,
                            children: [
                              _SettingsCard(
                                key: StakingAutoCompoundPage.settingsKey,
                                snapshot: snapshot,
                                frequency: _frequency,
                                thresholdController: _thresholdController,
                                gasOptimization: _gasOptimization,
                                onFrequencyChanged: (frequency) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _frequency = frequency);
                                },
                                onThresholdChanged: (_) => setState(() {}),
                                onGasOptimizationChanged: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _gasOptimization = !_gasOptimization;
                                  });
                                },
                              ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Vị thế Auto-Compound',
                            accentColor: AppColors.primary,
                            children: [
                              for (final position in positions)
                                _PositionCard(
                                  position: position,
                                  frequency: _frequency,
                                  onToggle: () => _toggle(position),
                                ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Mô phỏng Lợi nhuận Kép',
                            accentColor: AppColors.primary,
                            children: [
                              _SimulationCard(
                                controllerPrincipal: _principalController,
                                controllerApy: _apyController,
                                controllerMonths: _monthsController,
                                simulation: simulation,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          VitCtaButton(
                            key: StakingAutoCompoundPage.saveButtonKey,
                            variant: VitCtaButtonVariant.primary,
                            leading: const Icon(Icons.settings_outlined),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() => _showSuccess = true);
                            },
                            child: const Text('Lưu cài đặt'),
                          ),
                          _FooterNote(snapshot: snapshot),
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
                  onDismiss: () => setState(() => _showSuccess = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  StakingAutoCompoundPositionDraft _resolved(
    StakingAutoCompoundPositionDraft position,
  ) {
    return StakingAutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
    );
  }

  void _toggle(StakingAutoCompoundPositionDraft position) {
    HapticFeedback.selectionClick();
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  _CompoundSimulation _buildSimulation() {
    final principal = _parseDouble(_principalController.text, 1000);
    final apy = _parseDouble(_apyController.text, 7.5);
    final months = _parseInt(_monthsController.text, 12).clamp(1, 36);
    final monthlyRate = apy / 100 / 12;
    final points = <StakingAutoCompoundPointDraft>[];

    for (var month = 0; month <= months; month++) {
      points.add(
        StakingAutoCompoundPointDraft(
          month: month,
          withCompound: principal * math.pow(1 + monthlyRate, month),
          withoutCompound: principal * (1 + monthlyRate * month),
        ),
      );
    }

    final last = points.last;
    final difference = last.withCompound - last.withoutCompound;
    final percentageGain = last.withoutCompound == 0
        ? 0.0
        : difference / last.withoutCompound * 100;

    return _CompoundSimulation(
      points: points,
      withCompound: last.withCompound,
      withoutCompound: last.withoutCompound,
      difference: difference,
      percentageGain: percentageGain,
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingAutoCompoundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.autorenew_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.positions,
    required this.frequency,
    required this.threshold,
  });

  final List<StakingAutoCompoundPositionDraft> positions;
  final String frequency;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    return VitCard(
      key: StakingAutoCompoundPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-compound đang bật',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
                    Text(
                      '$active/${positions.length}',
                      style: AppTextStyles.heroNumber.copyWith(
                        fontSize:
                            AppSpacing.stakingAutoCompoundHeroStatFontSize,
                      ),
                    ),
                    Text(
                      'positions',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSpacing.buttonHero,
                height: AppSpacing.buttonHero,
                decoration: BoxDecoration(
                  color: AppColors.buy10,
                  borderRadius: AppRadii.xlRadius,
                  border: Border.all(
                    color: AppColors.buy20,
                    width: AppSpacing.stakingAutoCompoundHeroIconBorderWidth,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.autorenew_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconLg,
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Tần suất',
                  value: _frequencyLabel(frequency),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SummaryTile(
                  label: 'Ngưỡng tối thiểu',
                  value: _formatCurrency(threshold, compact: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x1)),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    super.key,
    required this.snapshot,
    required this.frequency,
    required this.thresholdController,
    required this.gasOptimization,
    required this.onFrequencyChanged,
    required this.onThresholdChanged,
    required this.onGasOptimizationChanged,
  });

  final StakingAutoCompoundSnapshot snapshot;
  final String frequency;
  final TextEditingController thresholdController;
  final bool gasOptimization;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<String> onThresholdChanged;
  final VoidCallback onGasOptimizationChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tần suất tái đầu tư',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
          Row(
            children: [
              for (var i = 0; i < snapshot.frequencies.length; i++) ...[
                Expanded(
                  child: _FrequencyTile(
                    frequency: snapshot.frequencies[i],
                    selected: frequency == snapshot.frequencies[i].id,
                    onTap: () => onFrequencyChanged(snapshot.frequencies[i].id),
                  ),
                ),
                if (i != snapshot.frequencies.length - 1)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
          VitInput(
            fieldKey: StakingAutoCompoundPage.thresholdKey,
            controller: thresholdController,
            label: 'Ngưỡng tối thiểu (USD)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onThresholdChanged,
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x2)),
          Text(
            'Chỉ tái đầu tư khi phần thưởng >= ${_formatCurrency(_parseDouble(thresholdController.text, 10), compact: true)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x5)),
          _GasOptimizationTile(
            enabled: gasOptimization,
            onTap: onGasOptimizationChanged,
          ),
          const Padding(padding: EdgeInsets.only(top: AppSpacing.x4)),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gợi ý: ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        TextSpan(
                          text: snapshot.suggestion,
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
          ),
        ],
      ),
    );
  }
}
