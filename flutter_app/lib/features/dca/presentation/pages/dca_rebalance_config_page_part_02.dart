part of 'dca_rebalance_config_page.dart';

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(icon: Icons.tune_rounded, title: 'Ngưỡng drift'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(0)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: _driftLabel(value),
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Trigger khi drift > ${value.toStringAsFixed(0)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _TokenSlider(
            value: value,
            min: 1,
            max: 50,
            divisions: 49,
            accent: AppColors.accent,
            onChanged: onChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_FinePrint('1% Chặt chẽ'), _FinePrint('50% Linh hoạt')],
          ),
        ],
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<DcaRebalanceFrequencyOption> options;
  final DcaRebalanceFrequency active;
  final ValueChanged<DcaRebalanceFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.calendar_month_rounded,
            title: 'Tần suất',
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: options
                .map(
                  (option) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x1,
                      ),
                      child: _FrequencyOptionTile(
                        option: option,
                        selected: active == option.frequency,
                        onTap: () => onChanged(option.frequency),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FrequencyOptionTile extends StatelessWidget {
  const _FrequencyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaRebalanceFrequencyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent10 : AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x4,
          ),
          child: Column(
            children: [
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.accent : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                option.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({
    required this.expanded,
    required this.minTradeAmountUsd,
    required this.autoExecute,
    required this.onToggleExpanded,
    required this.onMinTradeChanged,
    required this.onAutoExecuteChanged,
  });

  final bool expanded;
  final double minTradeAmountUsd;
  final bool autoExecute;
  final VoidCallback onToggleExpanded;
  final ValueChanged<double> onMinTradeChanged;
  final ValueChanged<bool> onAutoExecuteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: AppColors.transparent,
          child: InkWell(
            key: DCARebalanceConfig.advancedToggleKey,
            onTap: onToggleExpanded,
            borderRadius: AppRadii.inputRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_suggest_outlined,
                    color: AppColors.text3,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Cài đặt nâng cao',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 160),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              VitCard(
                radius: VitCardRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.contentPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Giao dịch tối thiểu',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: AppRadii.smRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x4,
                            vertical: AppSpacing.x2,
                          ),
                          child: Text(
                            '\$${minTradeAmountUsd.toStringAsFixed(0)}',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _TokenSlider(
                      value: minTradeAmountUsd,
                      min: 10,
                      max: 500,
                      divisions: 49,
                      accent: AppModuleAccents.trade,
                      onChanged: onMinTradeChanged,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_FinePrint('\$10'), _FinePrint('\$500')],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                radius: VitCardRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.contentPad),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _AccentIcon(
                          icon: Icons.flash_on_rounded,
                          color: autoExecute ? AppColors.buy : AppColors.text3,
                          muted: !autoExecute,
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tự động thực thi',
                                style: AppTextStyles.base.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.x1),
                              Text(
                                'Rebalance tự động không cần duyệt',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _TogglePill(
                          value: autoExecute,
                          onChanged: onAutoExecuteChanged,
                        ),
                      ],
                    ),
                    if (autoExecute) ...[
                      const SizedBox(height: AppSpacing.x4),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: AppRadii.inputRadius,
                          border: Border.all(color: AppColors.warningBorder),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.x4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.warn,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.x3),
                            Expanded(
                              child: Text(
                                'Hệ thống sẽ tự động thực hiện giao dịch khi danh mục lệch. Bạn có thể tắt bất kỳ lúc nào.',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.warningText,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StickyActions extends StatelessWidget {
  const _StickyActions({
    required this.valid,
    required this.onPreview,
    required this.onSave,
  });

  final bool valid;
  final VoidCallback onPreview;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: DCARebalanceConfig.previewKey,
            onPressed: valid ? onPreview : null,
            fullWidth: true,
            leading: const Icon(Icons.visibility_outlined),
            child: const Text('Xem trước'),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitCtaButton(
            key: DCARebalanceConfig.saveKey,
            onPressed: valid ? onSave : null,
            fullWidth: true,
            leading: const Icon(Icons.save_outlined),
            child: const Text('Lưu cấu hình'),
          ),
        ),
      ],
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.previews,
    required this.totalFeesUsd,
    required this.onClose,
    required this.onConfirm,
  });

  final List<DcaRebalanceTradePreview> previews;
  final double totalFeesUsd;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.bg.withValues(alpha: .86),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              0,
              AppSpacing.contentPad,
              DeviceMetrics.nativeBottomChrome + AppSpacing.x5,
            ),
            child: VitCard(
              key: DCARebalanceConfig.previewSheetKey,
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.contentPad),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const _AccentIcon(icon: Icons.preview_outlined),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Text(
                            'Preview Simulation',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        _IconBadgeButton(
                          icon: Icons.close_rounded,
                          onTap: onClose,
                          color: AppColors.text2,
                          neutral: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    ...previews.map(
                      (preview) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.x3),
                        child: _PreviewRow(preview: preview),
                      ),
                    ),
                    const Divider(color: AppColors.borderSolid),
                    Row(
                      children: [
                        Text(
                          'Phí ước tính',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${totalFeesUsd.toStringAsFixed(2)}',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    VitCtaButton(
                      key: DCARebalanceConfig.confirmSaveKey,
                      onPressed: onConfirm,
                      leading: const Icon(Icons.check_rounded),
                      child: const Text('Xác nhận lưu'),
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
}
