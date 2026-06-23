part of '../pages/p2p_settings_page.dart';

class _TradeOptionsCard extends StatelessWidget {
  const _TradeOptionsCard({
    required this.snapshot,
    required this.asset,
    required this.currency,
    required this.paymentWindow,
    required this.autoConfirm,
    required this.onAsset,
    required this.onCurrency,
    required this.onPaymentWindow,
    required this.onToggleAutoConfirm,
  });

  final P2PSettingsSnapshot snapshot;
  final String asset;
  final String currency;
  final String paymentWindow;
  final bool autoConfirm;
  final ValueChanged<String> onAsset;
  final ValueChanged<String> onCurrency;
  final ValueChanged<String> onPaymentWindow;
  final VoidCallback onToggleAutoConfirm;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSettingsPage.tradeOptionsKey,
      radius: VitCardRadius.lg,
      padding: _p2pSettingsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OptionGroup(
            group: 'asset',
            label: 'Tài sản mặc định',
            values: snapshot.assetOptions,
            selected: asset,
            onChanged: onAsset,
          ),
          const SizedBox(height: AppSpacing.x4),
          _OptionGroup(
            group: 'currency',
            label: 'Tiền tệ mặc định',
            values: snapshot.currencyOptions,
            selected: currency,
            onChanged: onCurrency,
          ),
          const SizedBox(height: AppSpacing.x4),
          _OptionGroup(
            group: 'window',
            label: 'Thời gian thanh toán mặc định',
            values: snapshot.paymentWindows,
            selected: paymentWindow,
            suffix: ' phút',
            expanded: true,
            onChanged: onPaymentWindow,
          ),
          const SizedBox(height: AppSpacing.x4),
          _SettingToggleRow(
            toggle: const P2PSettingsToggleDraft(
              id: 'auto_confirm',
              label: 'Tự động xác nhận',
              description: 'Tắt - xác nhận thủ công',
              iconKey: 'wallet',
              toneKey: 'success',
              enabled: false,
            ),
            value: autoConfirm,
            onToggle: onToggleAutoConfirm,
            last: true,
          ),
        ],
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({
    required this.group,
    required this.label,
    required this.values,
    required this.selected,
    required this.onChanged,
    this.suffix = '',
    this.expanded = false,
  });

  final String group;
  final String label;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;
  final String suffix;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final children = values.map((value) {
      final isSelected = value == selected;
      final chip = _OptionChip(
        group: group,
        value: value,
        label: '$value$suffix',
        selected: isSelected,
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(value);
        },
      );
      return expanded ? Expanded(child: chip) : chip;
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index != children.length - 1)
                const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.group,
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String group;
  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2PSettingsPage.optionKey(group, value),
      label: label,
      selected: selected,
      onTap: onTap,
      padding: AppSpacing.p2pSettingsOptionChipPadding,
      semanticLabel: '$group $label',
    );
  }
}

class _ToggleSection extends StatelessWidget {
  const _ToggleSection({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.toggles,
    required this.values,
    required this.onToggle,
  });

  final IconData icon;
  final String label;
  final Color color;
  final List<P2PSettingsToggleDraft> toggles;
  final Map<String, bool> values;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(icon: icon, label: label, color: color),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: _p2pSettingsHorizontalCardPadding,
          child: Column(
            children: [
              for (var index = 0; index < toggles.length; index++)
                _SettingToggleRow(
                  toggle: toggles[index],
                  value: values[toggles[index].id] ?? false,
                  onToggle: () => onToggle(toggles[index].id),
                  last: index == toggles.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({
    required this.snapshot,
    required this.values,
    required this.onToggle,
  });

  final P2PSettingsSnapshot snapshot;
  final Map<String, bool> values;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel(
          icon: Icons.shield_outlined,
          label: 'Bảo mật giao dịch',
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          key: P2PSettingsPage.securityKey,
          radius: VitCardRadius.lg,
          padding: _p2pSettingsHorizontalCardPadding,
          child: Column(
            children: [
              for (final toggle in snapshot.securityToggles)
                _SettingToggleRow(
                  toggle: toggle,
                  value: values[toggle.id] ?? false,
                  onToggle: () => onToggle(toggle.id),
                ),
              _NavigationRow(
                key: P2PSettingsPage.trustedDevicesKey,
                icon: Icons.smartphone_rounded,
                label: 'Thiết bị tin cậy',
                description: '3 thiết bị đã xác minh',
                color: AppColors.buy,
                onTap: () => context.go(snapshot.trustedDevicesRoute),
              ),
              _NavigationRow(
                key: P2PSettingsPage.blacklistKey,
                icon: Icons.person_remove_alt_1_outlined,
                label: 'Danh sách chặn',
                description: 'Quản lý người dùng đã chặn',
                color: AppColors.sell,
                onTap: () => context.go(snapshot.blacklistRoute),
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingToggleRow extends StatelessWidget {
  const _SettingToggleRow({
    required this.toggle,
    required this.value,
    required this.onToggle,
    this.last = false,
  });

  final P2PSettingsToggleDraft toggle;
  final bool value;
  final VoidCallback onToggle;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(toggle.toneKey);
    return Column(
      children: [
        Padding(
          padding: _p2pSettingsRowPadding,
          child: Row(
            children: [
              _SettingIcon(icon: _settingsIcon(toggle.iconKey), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toggle.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      toggle.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SwitchButton(
                key: P2PSettingsPage.toggleKey(toggle.id),
                value: value,
                color: color,
                onTap: onToggle,
              ),
            ],
          ),
        ),
        if (!last)
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
      ],
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCard(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.sm,
          padding: _p2pSettingsRowPadding,
          child: Row(
            children: [
              _SettingIcon(icon: icon, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        if (!last)
          const SizedBox(
            height: AppSpacing.dividerHairline,
            child: ColoredBox(color: AppColors.divider),
          ),
      ],
    );
  }
}
