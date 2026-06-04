import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

part '../widgets/kyc_status_levels.dart';
part '../widgets/kyc_details_privacy.dart';

const _kycBackground = AppColors.bg;
const _kycPanel = AppColors.surface;
const _kycGreen = AppColors.buy;
const _kycPrimary = AppColors.primary;
const _kycMuted = AppColors.text3;

class KYCPage extends ConsumerStatefulWidget {
  const KYCPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc159_kyc_content');
  static const statusCardKey = Key('sc159_kyc_status_card');
  static const privacyCardKey = Key('sc159_kyc_privacy_card');
  static Key levelKey(int level) => Key('sc159_kyc_level_$level');
  static Key startKey(int level) => Key('sc159_kyc_start_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends ConsumerState<KYCPage> {
  int? _expandedLevel;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getKyc();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 120
            : DeviceMetrics.nativeBottomChrome + 32) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-159 KYCPage',
      child: Material(
        color: _kycBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'X\u00E1c minh danh t\u00EDnh',
            subtitle: 'KYC \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: KYCPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 31, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _KycStatusCard(snapshot: snapshot),
                      const SizedBox(height: 33),
                      for (final level in snapshot.levels) ...[
                        _KycLevelCard(
                          level: level,
                          done: snapshot.currentLevel >= level.level,
                          expanded: _expandedLevel == level.level,
                          currentLevel: snapshot.currentLevel,
                          submitting: _submitting,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(
                              () =>
                                  _expandedLevel = _expandedLevel == level.level
                                  ? null
                                  : level.level,
                            );
                          },
                          onStart: () => _startVerification(level.level),
                        ),
                        if (level != snapshot.levels.last)
                          const SizedBox(height: 25),
                      ],
                      const SizedBox(height: 29),
                      const _PrivacyCard(),
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

  Future<void> _startVerification(int level) async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() => _submitting = false);
  }

  void _close() {
    goBackOrFallback(context, fallbackPath: AppRoutePaths.profile);
  }
}
