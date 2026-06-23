part of 'auto_compound_settings_page.dart';

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({required this.snapshot});

  final AutoCompoundSettingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: AutoCompoundSettingsPage.infoSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Lãi kép là gì?', style: AppTextStyles.sectionTitle),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.earnCardPaddingX3,
          child: Column(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text('Auto-Compound', style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Lãi kép tự động cộng phần lãi kiếm được vào số gốc, giúp bạn kiếm lãi trên cả lãi theo thời gian.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final item in snapshot.infoItems) ...[
          _InfoItem(item: item),
          if (item != snapshot.infoItems.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x4),
        _NoteCard(text: snapshot.note),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.item});

  final AutoCompoundInfoDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(item.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppRadii.mdRadius,
          child: SizedBox(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            child: Icon(
              Icons.check_rounded,
              color: color,
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
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                item.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AutoCompoundSettingsPage.successToastKey,
      borderColor: AppColors.buy,
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đã lưu cài đặt!', style: AppTextStyles.baseMedium),
                Text(
                  'Compound sẽ áp dụng từ kỳ tiếp theo.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          VitIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Đóng thông báo',
            onPressed: onDismiss,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.md,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.md,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: VitTogglePill(
          enabled: on,
          width: AppSpacing.autoCompoundSettingsSwitchWidth,
          height: AppSpacing.buttonCompact - AppSpacing.x2,
          knobSize: AppSpacing.x4,
          knobMargin: AppSpacing.zeroInsets.copyWith(
            left: AppSpacing.x1,
            top: AppSpacing.x1,
            right: AppSpacing.x1,
            bottom: AppSpacing.x1,
          ),
          activeColor: AppColors.buy,
          inactiveColor: AppColors.borderSolid,
          inactiveKnobColor: AppColors.onAccent,
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.xlRadius,
        side: BorderSide(color: color.withValues(alpha: 0.25)),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.stakingEarnHeroTabLabelLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

List<double> _thresholdPresets(String asset) {
  return switch (asset) {
    'BTC' => const [0.00001, 0.0001, 0.001, 0.01],
    'ETH' => const [0.001, 0.005, 0.01, 0.05],
    _ => const [0.1, 0.5, 1, 5],
  };
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

double _usdValue(String asset, double amount) {
  return switch (asset) {
    'BTC' => amount * 67543,
    'ETH' => amount * 2800,
    'SOL' => amount * 130,
    _ => amount,
  };
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  if (value < 0.01) return value.toStringAsFixed(6);
  if (value < 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(2);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    _ => AppColors.accent,
  };
}

Color _riskColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}
