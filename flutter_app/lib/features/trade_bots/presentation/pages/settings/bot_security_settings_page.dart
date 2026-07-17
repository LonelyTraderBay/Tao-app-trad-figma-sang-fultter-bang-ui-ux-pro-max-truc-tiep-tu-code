import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../widgets/settings/bot_security_settings_cards.dart';
part '../../widgets/settings/bot_security_settings_common.dart';
part '../../widgets/settings/bot_security_settings_sheets.dart';

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
    return VitTradeHubScaffold(
      title: 'Security Settings',
      subtitle: 'Bảo mật API key và quyền truy cập bot',
      semanticLabel: 'Cài đặt bảo mật bot giao dịch',
      semanticIdentifier: 'SC-122',
      contentKey: BotSecuritySettingsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        VitBotSubpageHero(
          primaryLabel: '2FA',
          primaryValue: _twoFaEnabled ? 'Bật' : 'Tắt',
          primaryColor: _twoFaEnabled ? _securityGreen : _securityAmber,
          secondaryLabel: 'API keys',
          secondaryValue: '${snapshot.apiKeys.length}',
        ),
        VitTradeSection(
          title: 'Two-Factor Authentication',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TwoFaCard(
                enabled: _twoFaEnabled,
                onTap: () => _toggleTwoFa(snapshot),
              ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'API Keys',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final key in snapshot.apiKeys) _ApiKeyCard(apiKey: key),
              _DashedActionButton(
                key: BotSecuritySettingsPage.createApiKeyKey,
                label: 'Create New API Key',
                icon: Icons.add_rounded,
                onTap: () => _showApiKeySheet(context, snapshot),
              ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'IP Whitelist',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final entry in snapshot.ipWhitelist) _IpCard(entry: entry),
              _DashedActionButton(
                key: BotSecuritySettingsPage.addIpKey,
                label: 'Add IP Address',
                icon: Icons.add_rounded,
                onTap: () => _showIpSheet(context),
              ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Recent Activity',
          child: _ActivityCard(activities: snapshot.recentActivity),
        ),
        VitTradeSection(
          title: 'Security Tips',
          child: _SecurityTipsCard(tips: snapshot.securityTips),
        ),
        const VitBotRiskReviewFooter(
          title: 'Bot security review required',
          message:
              '2FA, API key creation, IP whitelist, recent activity and destructive key changes require explicit review.',
          contractId: 'bot-security-settings-review',
          statusLabel: 'Sensitive settings',
          status: VitStatusPillStatus.warning,
        ),
      ],
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
