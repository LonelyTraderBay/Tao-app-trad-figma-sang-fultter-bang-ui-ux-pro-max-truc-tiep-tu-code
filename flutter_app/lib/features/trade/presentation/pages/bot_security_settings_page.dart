import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 28
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

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
                  padding: EdgeInsets.fromLTRB(20, 13, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      const _SectionLabel('Two-Factor Authentication'),
                      const SizedBox(height: 10),
                      VitPageSection(
                        customGap: 0,
                        children: [
                          _TwoFaCard(
                            enabled: _twoFaEnabled,
                            onTap: () => _toggleTwoFa(snapshot),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Bot security review required',
                              message:
                                  '2FA, API key creation, IP whitelist, recent activity and destructive key changes require explicit review.',
                              contractId: 'bot-security-settings-review',
                            ),
                            SizedBox(height: 8),
                            VitStatusPill(
                              label: 'Sensitive settings',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('API Keys'),
                      const SizedBox(height: 10),
                      for (final key in snapshot.apiKeys) ...[
                        _ApiKeyCard(apiKey: key),
                        if (key != snapshot.apiKeys.last)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 10),
                      _DashedActionButton(
                        key: BotSecuritySettingsPage.createApiKeyKey,
                        label: 'Create New API Key',
                        icon: Icons.add_rounded,
                        onTap: () => _showApiKeySheet(context, snapshot),
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('IP Whitelist'),
                      const SizedBox(height: 10),
                      for (final entry in snapshot.ipWhitelist) ...[
                        _IpCard(entry: entry),
                        if (entry != snapshot.ipWhitelist.last)
                          const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 10),
                      _DashedActionButton(
                        key: BotSecuritySettingsPage.addIpKey,
                        label: 'Add IP Address',
                        icon: Icons.add_rounded,
                        onTap: () => _showIpSheet(context),
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('Recent Activity'),
                      const SizedBox(height: 10),
                      _ActivityCard(activities: snapshot.recentActivity),
                      const SizedBox(height: 18),
                      _SecurityTipsCard(tips: snapshot.securityTips),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ApiKeySheet(snapshot: snapshot),
    );
  }

  void _showIpSheet(BuildContext context) {
    showVitBottomSheet<void>(
      context: context,
      backgroundColor: _securityPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _IpSheet(),
    );
  }
}
