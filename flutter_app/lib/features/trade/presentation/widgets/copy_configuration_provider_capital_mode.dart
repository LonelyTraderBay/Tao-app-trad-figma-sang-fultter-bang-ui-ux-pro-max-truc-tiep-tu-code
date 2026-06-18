part of '../pages/copy_configuration_page.dart';

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.copyConfigurationCardPadding,
      child: Row(
        children: [
          VitAssetAvatar(
            label: provider.avatar,
            accentColor: _configurationPrimary,
            size: AppSpacing.copyConfigurationAvatarSize,
            radius: AppRadii.avatarRadius,
            border: true,
          ),
          const SizedBox(width: AppSpacing.copyConfigurationInlineGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đang cấu hình copy cho',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.copyConfigurationTinyGap),
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.copyConfigurationTinyGap),
                Text(
                  'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          _RiskPill(level: provider.riskLevel),
        ],
      ),
    );
  }
}

class _CapitalSection extends StatelessWidget {
  const _CapitalSection({
    required this.controller,
    required this.allocationPercent,
    required this.availableCapital,
    required this.totalPortfolio,
    required this.onChanged,
    required this.onPreset,
  });

  final TextEditingController controller;
  final double allocationPercent;
  final double availableCapital;
  final double totalPortfolio;
  final ValueChanged<String> onChanged;
  final ValueChanged<double> onPreset;

  @override
  Widget build(BuildContext context) {
    final allocationColor = allocationPercent > 20
        ? _configurationRed
        : allocationPercent > 15
        ? AppColors.warn
        : _configurationPrimary;

    return VitPageSection(
      label: 'Vốn copy',
      accentColor: _configurationPrimary,
      children: [
        VitInput(
          fieldKey: CopyConfigurationPage.capitalFieldKey,
          controller: controller,
          label: 'Số tiền copy (USD)',
          keyboardType: TextInputType.number,
          prefix: const Icon(Icons.attach_money_rounded),
          onChanged: onChanged,
        ),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.copyConfigurationInnerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phân bổ portfolio',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    '${allocationPercent.toStringAsFixed(1)}%',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: allocationColor,
                      fontWeight: AppTextStyles.extraBold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.copyConfigurationSmallGap),
              ClipRRect(
                borderRadius: AppRadii.smRadius,
                child: LinearProgressIndicator(
                  minHeight: AppSpacing.copyConfigurationProgressHeight,
                  value: (allocationPercent / 100).clamp(0, 1),
                  backgroundColor: AppColors.borderSolid,
                  valueColor: AlwaysStoppedAnimation<Color>(allocationColor),
                ),
              ),
              const SizedBox(height: AppSpacing.copyConfigurationSmallGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Khả dụng \$${availableCapital.toStringAsFixed(0)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    'Portfolio \$${totalPortfolio.toStringAsFixed(0)}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            for (final percent in const [5.0, 10.0, 15.0, 20.0]) ...[
              Expanded(
                child: _PresetButton(
                  label: '${percent.toStringAsFixed(0)}%',
                  onPressed: () => onPreset(percent),
                ),
              ),
              if (percent != 20)
                const SizedBox(width: AppSpacing.copyConfigurationSmallGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _ModeSection extends StatelessWidget {
  const _ModeSection({
    required this.selected,
    required this.copyRatio,
    required this.onModeChanged,
    required this.onRatioChanged,
  });

  final TradeCopyConfigurationMode selected;
  final double copyRatio;
  final ValueChanged<TradeCopyConfigurationMode> onModeChanged;
  final ValueChanged<double> onRatioChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chế độ copy',
      accentColor: _configurationPrimary,
      children: [
        for (final mode in TradeCopyConfigurationMode.values)
          _ModeTile(
            mode: mode,
            selected: selected == mode,
            onTap: () => onModeChanged(mode),
          ),
        if (selected == TradeCopyConfigurationMode.fixed)
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.copyConfigurationInnerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tỷ lệ sao chép',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 10,
                        max: 100,
                        divisions: 18,
                        value: copyRatio,
                        activeColor: _configurationPrimary,
                        onChanged: onRatioChanged,
                      ),
                    ),
                    SizedBox(
                      width: AppSpacing.copyConfigurationRatioWidth,
                      child: Text(
                        '${copyRatio.toStringAsFixed(0)}%',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.extraBold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Provider mở \$1000 -> bạn mở \$${(1000 * copyRatio / 100).toStringAsFixed(0)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
