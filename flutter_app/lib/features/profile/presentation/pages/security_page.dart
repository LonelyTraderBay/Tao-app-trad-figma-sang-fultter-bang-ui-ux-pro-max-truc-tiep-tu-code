import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/security_page_sections.dart';
part '../widgets/security_page_common.dart';

const _securityBackground = AppColors.bg;
const _securityBorder = AppColors.cardBorder;
const _securityDivider = AppColors.divider;
const _securityPrimary = AppColors.primary;
const _securityGreen = AppColors.buy;
const _securityAmber = AppColors.warn;
const _securityRed = AppColors.sell;
const _securityMuted = AppColors.text3;

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc158_security_content');
  static const scoreCardKey = Key('sc158_security_score_card');
  static const antiPhishingFieldKey = Key('sc158_security_anti_phishing_field');
  static const antiPhishingSaveKey = Key('sc158_security_anti_phishing_save');
  static const supportKey = Key('sc158_security_support');

  static Key itemKey(String id) => Key('sc158_security_item_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> {
  final TextEditingController _antiPhishingController = TextEditingController();
  bool _showDevices = false;
  bool _saving = false;

  @override
  void dispose() {
    _antiPhishingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getSecurity();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-158 SecurityPage',
      child: Material(
        color: _securityBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'B\u1EA3o m\u1EADt',
            subtitle: 'B\u1EA3o m\u1EADt \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: SecurityPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 18,
                    fullBleed: true,
                    children: [
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review account security',
                        message:
                            'Confirm 2FA, anti-phishing code, device sessions, and password changes before sensitive account actions.',
                        contractId: 'Security score: ${snapshot.score}/4',
                      ),
                      _ScoreCard(snapshot: snapshot),
                      _SecurityList(
                        items: snapshot.items,
                        onItemTap: _handleItemTap,
                      ),
                      if (_showDevices) ...[
                        _DeviceList(devices: snapshot.devices),
                      ],
                      _AntiPhishingCard(
                        controller: _antiPhishingController,
                        saving: _saving,
                        onSave: _saveAntiPhishingCode,
                      ),
                      _SecuritySupportCard(supportRoute: snapshot.supportRoute),
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

  void _handleItemTap(ProfileSecurityItem item) {
    HapticFeedback.selectionClick();
    if (item.id == 'devices') {
      setState(() => _showDevices = !_showDevices);
      return;
    }
    if (item.route != null) {
      context.go(item.route!);
    }
  }

  Future<void> _saveAntiPhishingCode() async {
    HapticFeedback.selectionClick();
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _saving = false);
  }

  void _close() {
    goBackOrFallback(context, fallbackPath: AppRoutePaths.profile);
  }
}
