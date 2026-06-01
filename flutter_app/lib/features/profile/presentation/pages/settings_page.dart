import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/settings_page_sections.dart';
part '../widgets/settings_page_common.dart';

const _settingsBackground = AppColors.bg;
const _settingsPanel = AppColors.surface;
const _settingsPanel2 = AppColors.surface2;
const _settingsSelected = AppColors.surface2;
const _settingsBorder = AppColors.cardBorder;
const _settingsDivider = AppColors.divider;
const _settingsPrimary = AppColors.primary;
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
    final snapshot = ref.watch(profileControllerProvider).getSettings();
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
        color: _settingsBackground,
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
