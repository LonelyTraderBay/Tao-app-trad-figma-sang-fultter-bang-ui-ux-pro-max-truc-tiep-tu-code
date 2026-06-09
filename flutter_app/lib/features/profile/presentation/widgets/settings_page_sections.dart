part of '../pages/settings_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.sectionLabel,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 86,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      radius: VitCardRadius.lg,
      borderColor: _settingsBorder,
      child: Row(
        children: [
          const Icon(Icons.language_rounded, color: _settingsPrimary, size: 21),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0110\u01A1n v\u1ECB ti\u1EC1n t\u1EC7 hi\u1EC3n th\u1ECB',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (final currency in currencies) ...[
                      _CurrencyChip(
                        currency: currency,
                        selected: currency == selectedCurrency,
                        onTap: () => onChanged(currency),
                      ),
                      if (currency != currencies.last) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({
    required this.currency,
    required this.selected,
    required this.onTap,
  });

  final String currency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: SettingsPage.currencyKey(currency),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 24,
        constraints: const BoxConstraints(minWidth: 48),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: selected ? _settingsPrimary : _settingsPanel2,
          borderRadius: AppRadii.mdRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          currency,
          style: AppTextStyles.micro.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.languages,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ProfileLanguageOption> languages;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: _settingsBorder,
      clip: true,
      child: Column(
        children: [
          for (final language in languages) ...[
            _LanguageRow(
              language: language,
              selected: language.id == selectedId,
              onTap: () => onChanged(language.id),
            ),
            if (language != languages.last)
              const Divider(height: 1, color: _settingsDivider),
          ],
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final ProfileLanguageOption language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: SettingsPage.languageKey(language.id),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: selected ? _settingsSelected : AppColors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                language.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            if (selected)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: _settingsPrimary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsListCard extends StatelessWidget {
  const _SettingsListCard({
    required this.rows,
    required this.toggles,
    required this.onToggle,
    required this.rowHeight,
  });

  final List<ProfileSettingsItem> rows;
  final Map<String, bool> toggles;
  final void Function(String id, bool value) onToggle;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: _settingsBorder,
      clip: true,
      child: Column(
        children: [
          for (final row in rows) ...[
            _SettingsRow(
              row: row,
              enabled: toggles[row.id] ?? false,
              onToggle: (value) => onToggle(row.id, value),
              height: rowHeight,
            ),
            if (row != rows.last)
              const Divider(height: 1, color: _settingsDivider),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.row,
    required this.enabled,
    required this.onToggle,
    required this.height,
  });

  final ProfileSettingsItem row;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasIcon = row.iconKey != 'none';

    return Container(
      height: height,
      padding: EdgeInsets.fromLTRB(hasIcon ? 16 : 20, 0, 16, 0),
      child: Row(
        children: [
          if (hasIcon) ...[
            Icon(_iconFor(row.iconKey), color: _settingsPrimary, size: 20),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  row.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _settingsMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (row.canToggle && row.enabled != null) ...[
            const SizedBox(width: 12),
            _SettingsSwitch(
              key: SettingsPage.toggleKey(row.id),
              value: enabled,
              label: row.title,
              onChanged: onToggle,
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: 48,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? _settingsGreen : AppColors.toggleTrackOff,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.onAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.overlayScrim,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.overlayScrimSoft,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
