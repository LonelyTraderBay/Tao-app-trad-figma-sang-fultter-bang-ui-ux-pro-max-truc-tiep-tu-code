import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/bot_security_settings_cards.dart';
part '../widgets/bot_security_settings_common.dart';
part '../widgets/bot_security_settings_sheets.dart';

const _securityBackground = AppColors.bg;
const _securityPanel = AppColors.surface;
const _securityPanel2 = AppColors.surface2;
const _securityPrimary = AppColors.primary;
const _securityGreen = AppColors.buy;
const _securityAmber = AppColors.caution;
const _securityRed = AppColors.sell;

class BotSecuritySettingsPage extends ConsumerStatefulWidget {
  const BotSecuritySettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc122_bot_security_settings_content');
  static const twoFaToggleKey = Key('sc122_bot_security_settings_2fa_toggle');
  static const createApiKeyKey = Key(
    'sc122_bot_security_settings_create_api_key',
  );
  static const addIpKey = Key('sc122_bot_security_settings_add_ip');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotSecuritySettingsPage> createState() =>
      _BotSecuritySettingsPageState();
}

class _BotSecuritySettingsPageState
    extends ConsumerState<BotSecuritySettingsPage> {
  late bool _twoFaEnabled;

  @override
  void initState() {
    super.initState();
    _twoFaEnabled = ref
        .read(tradeBotSecuritySettingsControllerProvider)
        .state
        .snapshot
        .twoFaEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeBotSecuritySettingsControllerProvider)
        .state
        .snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-122 BotSecuritySettingsPage',
      child: Material(
        color: _securityBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Security Settings',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotSecuritySettingsPage.contentKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.tradeBotCardGap,
                    AppSpacing.contentPad,
                    scrollClearance,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.compact,
                    children: [
                      VitPageSection(
                        label: 'Two-Factor Authentication',
                        density: VitDensity.compact,
                        children: [
                          _TwoFaCard(
                            enabled: _twoFaEnabled,
                            onTap: () => _toggleTwoFa(snapshot),
                          ),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            density: VitDensity.compact,
                            child: VitPageContent(
                              padding: VitContentPadding.none,
                              fullBleed: true,
                              density: VitDensity.compact,
                              children: [
                                VitHighRiskStatePanel(
                                  state: VitHighRiskUiState.riskReview,
                                  density: VitDensity.compact,
                                  title: 'Bot security review required',
                                  message:
                                      '2FA, API key creation, IP whitelist, recent activity and destructive key changes require explicit review.',
                                  contractId: 'bot-security-settings-review',
                                ),
                                VitStatusPill(
                                  label: 'Sensitive settings',
                                  status: VitStatusPillStatus.warning,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: 'API Keys',
                        density: VitDensity.compact,
                        children: [
                          VitPageContent(
                            padding: VitContentPadding.none,
                            fullBleed: true,
                            density: VitDensity.compact,
                            children: [
                              for (final key in snapshot.apiKeys)
                                _ApiKeyCard(apiKey: key),
                            ],
                          ),
                          _DashedActionButton(
                            key: BotSecuritySettingsPage.createApiKeyKey,
                            label: 'Create New API Key',
                            icon: Icons.add_rounded,
                            onTap: () => _showApiKeySheet(context, snapshot),
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: 'IP Whitelist',
                        density: VitDensity.compact,
                        children: [
                          VitPageContent(
                            padding: VitContentPadding.none,
                            fullBleed: true,
                            density: VitDensity.compact,
                            children: [
                              for (final entry in snapshot.ipWhitelist)
                                _IpCard(entry: entry),
                            ],
                          ),
                          _DashedActionButton(
                            key: BotSecuritySettingsPage.addIpKey,
                            label: 'Add IP Address',
                            icon: Icons.add_rounded,
                            onTap: () => _showIpSheet(context),
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: 'Recent Activity',
                        density: VitDensity.compact,
                        children: [
                          _ActivityCard(activities: snapshot.recentActivity),
                        ],
                      ),
                      VitPageSection(
                        label: 'Security Tips',
                        density: VitDensity.compact,
                        children: [
                          _SecurityTipsCard(tips: snapshot.securityTips),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleTwoFa(TradeBotSecuritySettingsSnapshot snapshot) {
    setState(() => _twoFaEnabled = !_twoFaEnabled);
    ref
        .read(tradeBotSecuritySettingsControllerProvider)
        .saveTwoFa(_twoFaEnabled);
  }

  void _showApiKeySheet(
    BuildContext context,
    TradeBotSecuritySettingsSnapshot snapshot,
  ) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _securityPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopLargeRadius,
      ),
      builder: (context) => _ApiKeySheet(snapshot: snapshot),
    );
  }

  void _showIpSheet(BuildContext context) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _securityPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.sheetTopLargeRadius,
      ),
      builder: (context) => const _IpSheet(),
    );
  }
}
