import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_2fa_settings_page_sections.dart';
part '../widgets/p2p_2fa_settings_page_common.dart';

const double _p2pTwoFactorVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pTwoFactorNativeNavClearance =
    _p2pTwoFactorVisualNavClearance - AppSpacing.x4;
const double _p2pTwoFactorVisualClearance = AppSpacing.x3;
const double _p2pTwoFactorNativeClearance = AppSpacing.x2;
const double _p2pTwoFactorSectionGap = AppSpacing.x3;
const double _p2pTwoFactorTightGap = AppSpacing.x2;
const double _p2pTwoFactorHeroIconBox = AppSpacing.x6;
const double _p2pTwoFactorMethodIconBox = AppSpacing.x6;
const double _p2pTwoFactorCaptionLineHeight = 1.34;
const double _p2pTwoFactorNoticeLineHeight = 1.35;
const EdgeInsets _p2pTwoFactorScrollPadding = EdgeInsets.fromLTRB(
  AppSpacing.contentPad,
  AppSpacing.x3,
  AppSpacing.contentPad,
  0,
);
const EdgeInsets _p2pTwoFactorCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _p2pTwoFactorInnerPadding = EdgeInsets.all(AppSpacing.x2);

class P2P2FASettingsPage extends ConsumerStatefulWidget {
  const P2P2FASettingsPage({super.key, this.shellRenderMode});

  static const statusKey = Key('sc254_p2p_2fa_status');
  static const methodsKey = Key('sc254_p2p_2fa_methods');
  static const thresholdsKey = Key('sc254_p2p_2fa_thresholds');
  static const recommendationKey = Key('sc254_p2p_2fa_recommendation');

  static Key methodKey(String id) => Key('sc254_p2p_2fa_method_$id');
  static Key methodSwitchKey(String id) =>
      Key('sc254_p2p_2fa_method_switch_$id');
  static Key thresholdKey(String id) => Key('sc254_p2p_2fa_threshold_$id');
  static Key thresholdSwitchKey(String id) =>
      Key('sc254_p2p_2fa_threshold_switch_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2P2FASettingsPage> createState() => _P2P2FASettingsPageState();
}

class _P2P2FASettingsPageState extends ConsumerState<P2P2FASettingsPage> {
  late List<P2PTwoFactorMethodDraft> _methods;
  late List<P2PTransactionThresholdDraft> _thresholds;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(p2pTwoFactorSettingsProvider);
    _methods = List.of(snapshot.methods);
    _thresholds = List.of(snapshot.thresholds);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pTwoFactorSettingsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pTwoFactorVisualNavClearance + _p2pTwoFactorVisualClearance
            : _p2pTwoFactorNativeNavClearance + _p2pTwoFactorNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    final enabledMethods = _methods.where((method) => method.enabled).length;
    final primaryMethod = _methods.firstWhere(
      (method) => method.isPrimary,
      orElse: () => _methods.first,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-254 P2P2FASettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: '2FA cho P2P',
            subtitle: 'Bảo mật · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: _p2pTwoFactorScrollPadding.copyWith(
                      bottom: scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TwoFactorStatusCard(
                          enabledMethods: enabledMethods,
                          primaryMethod: primaryMethod.label,
                        ),
                        const SizedBox(height: _p2pTwoFactorSectionGap),
                        _MethodSection(
                          methods: _methods,
                          onToggle: _toggleMethod,
                          onSetPrimary: _setPrimaryMethod,
                        ),
                        const SizedBox(height: _p2pTwoFactorSectionGap),
                        _ThresholdSection(
                          thresholds: _thresholds,
                          onToggle: _toggleThreshold,
                        ),
                        const SizedBox(height: _p2pTwoFactorSectionGap),
                        _SecurityRecommendation(text: snapshot.recommendation),
                        const SizedBox(height: _p2pTwoFactorTightGap),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: _p2pTwoFactorInnerPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'P2P 2FA change review',
                            message:
                                'Enabled methods, primary factor, transaction thresholds, setup status and next security step are reviewed before P2P protection changes.',
                            contractId: 'p2p-2fa-settings-review',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMethod(String methodId) {
    HapticFeedback.selectionClick();
    setState(() {
      _methods = [
        for (final method in _methods)
          if (method.id == methodId)
            method.copyWith(
              enabled: !method.enabled,
              setupRequired: method.enabled ? method.setupRequired : false,
            )
          else
            method,
      ];
    });
  }

  void _setPrimaryMethod(String methodId) {
    HapticFeedback.selectionClick();
    setState(() {
      _methods = [
        for (final method in _methods)
          method.copyWith(isPrimary: method.id == methodId),
      ];
    });
  }

  void _toggleThreshold(String thresholdId) {
    HapticFeedback.selectionClick();
    setState(() {
      _thresholds = [
        for (final threshold in _thresholds)
          if (threshold.id == thresholdId)
            threshold.copyWith(enabled: !threshold.enabled)
          else
            threshold,
      ];
    });
  }
}
