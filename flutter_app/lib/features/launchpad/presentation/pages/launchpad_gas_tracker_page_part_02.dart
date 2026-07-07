part of 'launchpad_gas_tracker_page.dart';

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.estimate});

  final LaunchpadGasEstimateDraft estimate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.estimateKey(estimate.operation),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: AppColors.warn,
                size: LaunchpadSpacingTokens.launchpadIconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  estimate.operation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${estimate.gasUnits} gas',
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.text3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final cost in estimate.costs) _EstimateCostRow(cost: cost),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Legend(label: 'Slow', color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Standard', color: AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Fast', color: AppColors.warn),
            ],
          ),
        ],
      ),
    );
  }
}

class _EstimateCostRow extends StatelessWidget {
  const _EstimateCostRow({required this.cost});

  final LaunchpadGasEstimateCostDraft cost;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  cost.chain,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              _CostText(cost.slow, AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              _CostText(cost.standard, AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              _CostText(cost.fast, AppColors.warn),
            ],
          ),
        ),
        const Divider(height: AppSpacing.hairlineStroke),
      ],
    );
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab({
    required this.alerts,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  final List<LaunchpadGasAlertDraft> alerts;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AddAlertCard(onTap: onAdd),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        KeyedSubtree(
          key: LaunchpadGasTrackerPage.alertsKey,
          child: alerts.isEmpty
              ? const _EmptyAlerts()
              : VitPageSection(
                  label: 'Canh bao hien tai',
                  accentColor: AppColors.warn,
                  children: [
                    for (final alert in alerts)
                      _AlertCard(
                        alert: alert,
                        onToggle: () => onToggle(alert.id),
                        onDelete: () => onDelete(alert.id),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _AddAlertCard extends StatelessWidget {
  const _AddAlertCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.addAlertKey,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary30,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox40,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.primary15,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                ),
              ),
              child: Icon(Icons.add_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Them canh bao gas',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Thong bao khi gas dat nguong',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  final LaunchpadGasAlertDraft alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final trendIcon = alert.direction == LaunchpadGasAlertDirection.below
        ? Icons.trending_down_rounded
        : Icons.trending_up_rounded;

    return VitCard(
      key: LaunchpadGasTrackerPage.alertKey(alert.id),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox34,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: alert.accent.resolve().withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                trendIcon,
                color: alert.accent.resolve(),
                size:
                    LaunchpadSpacingTokens.launchpadIconXl +
                    AppSpacing.hairlineStroke,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.chain} ${alert.direction == LaunchpadGasAlertDirection.below ? '<' : '>'} ${_formatGasValue(alert.threshold)} ${alert.unit}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  '${alert.triggerCount} lan kich hoat${alert.lastTriggered == null ? '' : ' - ${alert.lastTriggered}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitIconButton(
            key: LaunchpadGasTrackerPage.alertToggleKey(alert.id),
            onPressed: onToggle,
            icon: alert.enabled
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            tooltip: alert.enabled ? 'Tat canh bao gas' : 'Bat canh bao gas',
            variant: alert.enabled
                ? VitIconButtonVariant.success
                : VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          VitIconButton(
            key: LaunchpadGasTrackerPage.alertDeleteKey(alert.id),
            onPressed: onDelete,
            icon: Icons.delete_outline_rounded,
            tooltip: 'Xoa canh bao gas',
            variant: VitIconButtonVariant.danger,
            size: VitIconButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

class _AddAlertSheet extends StatefulWidget {
  const _AddAlertSheet({
    required this.prices,
    required this.onClose,
    required this.onAdd,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadGasAlertDraft> onAdd;

  @override
  State<_AddAlertSheet> createState() => _AddAlertSheetState();
}

class _AddAlertSheetState extends State<_AddAlertSheet> {
  final _thresholdController = TextEditingController();
  late String _chain;
  var _direction = LaunchpadGasAlertDirection.below;

  @override
  void initState() {
    super.initState();
    _chain = widget.prices.first.chain;
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return double.tryParse(_thresholdController.text.trim()) != null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.prices.firstWhere(
      (price) => price.chain == _chain,
      orElse: () => widget.prices.first,
    );

    return Material(
      key: LaunchpadGasTrackerPage.addSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadCreateSheetPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox40,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: const ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Them canh bao gas',
                            style: AppTextStyles.base.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        VitIconButton(
                          key: LaunchpadGasTrackerPage.addCloseKey,
                          onPressed: widget.onClose,
                          icon: Icons.close_rounded,
                          tooltip: 'Dong them canh bao gas',
                          variant: VitIconButtonVariant.transparent,
                          size: VitIconButtonSize.md,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Chain',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        for (final price in widget.prices)
                          VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetChainKey(
                              price.chain,
                            ),
                            label: price.chain,
                            accentColor: price.accent.resolve(),
                            selected: _chain == price.chain,
                            onTap: () => setState(() => _chain = price.chain),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Dieu kien',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetDirectionKey(
                              'below',
                            ),
                            label: 'Thap hon',
                            accentColor: AppColors.buy,
                            selected:
                                _direction == LaunchpadGasAlertDirection.below,
                            onTap: () => setState(
                              () =>
                                  _direction = LaunchpadGasAlertDirection.below,
                            ),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                            fullWidth: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetDirectionKey(
                              'above',
                            ),
                            label: 'Cao hon',
                            accentColor: AppColors.sell,
                            selected:
                                _direction == LaunchpadGasAlertDirection.above,
                            onTap: () => setState(
                              () =>
                                  _direction = LaunchpadGasAlertDirection.above,
                            ),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                            fullWidth: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Nguong (${selected.unit})',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitInput(
                      controller: _thresholdController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setState(() {}),
                      semanticLabel: 'Gas alert threshold',
                      hintText: 'VD: 15',
                      textStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      key: LaunchpadGasTrackerPage.addSubmitKey,
                      onPressed: _canSubmit ? () => _submit(selected) : null,
                      child: const Text('Them canh bao'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(LaunchpadGasPriceDraft selected) {
    widget.onAdd(
      LaunchpadGasAlertDraft(
        id: 'ga_new_${DateTime.now().millisecondsSinceEpoch}',
        chain: selected.chain,
        accent: selected.accent,
        threshold: double.parse(_thresholdController.text.trim()),
        direction: _direction,
        unit: selected.unit,
        enabled: true,
        triggerCount: 0,
      ),
    );
  }
}
