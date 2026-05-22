import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/profile_repository.dart';

const _settingsBg = AppColors.bg;
const _settingsSurface = AppColors.surface;
const _settingsSurface2 = AppColors.surface2;
const _settingsSelected = AppColors.surface2;
const _settingsBorder = AppColors.cardBorder;
const _settingsDivider = AppColors.divider;
const _settingsBlue = AppColors.primary;
const _settingsGreen = AppColors.buy;
const _settingsMuted = AppColors.text3;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc160_settings_content');
  static const appInfoKey = Key('sc160_settings_app_info');
  static Key currencyKey(String currency) =>
      Key('sc160_settings_currency_$currency');
  static Key languageKey(String id) => Key('sc160_settings_language_$id');
  static Key toggleKey(String id) => Key('sc160_settings_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _initialized = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguageId = 'vi';
  Map<String, bool> _toggles = const {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileRepositoryProvider).getSettings();
    _initializeFrom(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 124
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-160 SettingsPage',
      child: Material(
        color: _settingsBg,
        child: Column(
          children: [
            VitHeader(
              title: 'C\u00E0i \u0111\u1EB7t',
              subtitle: 'C\u00E0i \u0111\u1EB7t \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: SettingsPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionTitle(label: 'GIAO DI\u1EC6N'),
                    const SizedBox(height: 8),
                    _CurrencyCard(
                      currencies: snapshot.currencyOptions,
                      selectedCurrency: _selectedCurrency,
                      onChanged: _setCurrency,
                    ),
                    const SizedBox(height: 27),
                    _SectionTitle(label: 'NG\u00D4N NG\u1EEE'),
                    const SizedBox(height: 8),
                    _LanguageCard(
                      languages: snapshot.languages,
                      selectedId: _selectedLanguageId,
                      onChanged: _setLanguage,
                    ),
                    const SizedBox(height: 28),
                    _SectionTitle(label: 'B\u1EA2O M\u1EACT GIAO D\u1ECACH'),
                    const SizedBox(height: 8),
                    _SettingsListCard(
                      rows: snapshot.tradeSecurity,
                      toggles: _toggles,
                      onToggle: _setToggle,
                      rowHeight: 72,
                    ),
                    const SizedBox(height: 28),
                    _SectionTitle(label: 'TH\u00D4NG B\u00C1O'),
                    const SizedBox(height: 8),
                    _SettingsListCard(
                      rows: snapshot.notifications,
                      toggles: _toggles,
                      onToggle: _setToggle,
                      rowHeight: 68,
                    ),
                    const SizedBox(height: 26),
                    _AppInfoCard(rows: snapshot.appInfo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeFrom(ProfileSettingsSnapshot snapshot) {
    if (_initialized) return;
    _selectedCurrency = snapshot.selectedCurrency;
    _selectedLanguageId = snapshot.selectedLanguageId;
    _toggles = {
      for (final item in [...snapshot.tradeSecurity, ...snapshot.notifications])
        if (item.enabled != null) item.id: item.enabled!,
    };
    _initialized = true;
  }

  void _setCurrency(String currency) {
    HapticFeedback.selectionClick();
    setState(() => _selectedCurrency = currency);
  }

  void _setLanguage(String id) {
    HapticFeedback.selectionClick();
    setState(() => _selectedLanguageId = id);
  }

  void _setToggle(String id, bool value) {
    HapticFeedback.selectionClick();
    setState(() => _toggles = {..._toggles, id: value});
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

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
    return Container(
      height: 86,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 15),
      decoration: _cardDecoration(radius: 16),
      child: Row(
        children: [
          const Icon(Icons.language_rounded, color: _settingsBlue, size: 21),
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
          color: selected ? _settingsBlue : _settingsSurface2,
          borderRadius: BorderRadius.circular(13),
        ),
        alignment: Alignment.center,
        child: Text(
          currency,
          style: AppTextStyles.micro.copyWith(
            color: selected ? Colors.white : AppColors.text2,
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
    return Container(
      decoration: _cardDecoration(radius: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
        color: selected ? _settingsSelected : Colors.transparent,
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
                  color: _settingsBlue,
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
    return Container(
      decoration: _cardDecoration(radius: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
            Icon(_iconFor(row.iconKey), color: _settingsBlue, size: 20),
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
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
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

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: SettingsPage.appInfoKey,
      height: 164,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TH\u00D4NG TIN \u1EE8NG D\u1EE4NG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 13,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    row.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration({required double radius}) {
  return BoxDecoration(
    color: _settingsSurface,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: _settingsBorder),
  );
}

IconData _iconFor(String key) {
  return switch (key) {
    'bell' => Icons.notifications_none_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.circle_outlined,
  };
}
