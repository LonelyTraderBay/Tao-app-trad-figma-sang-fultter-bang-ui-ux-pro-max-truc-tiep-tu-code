import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_2fa_settings_page_sections.dart';
part '../widgets/p2p_2fa_settings_page_common.dart';

const double _p2pTwoFactorHeroIconBox = AppSpacing.x6;
const double _p2pTwoFactorMethodIconBox = AppSpacing.x6;
const double _p2pTwoFactorCaptionLineHeight = 1.34;
const double _p2pTwoFactorNoticeLineHeight = 1.35;

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
    final enabledMethods = _methods.where((method) => method.enabled).length;
    final primaryMethod = _methods.firstWhere(
      (method) => method.isPrimary,
      orElse: () => _methods.first,
    );

    return VitP2PFlowScaffold(
      title: '2FA cho P2P',
      subtitle: 'Bảo mật · P2P',
      semanticLabel: 'SC-254 P2P2FASettingsPage',
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(snapshot.parentRoute),
      children: [
        _TwoFactorStatusCard(
          enabledMethods: enabledMethods,
          primaryMethod: primaryMethod.label,
        ),
        _MethodSection(
          methods: _methods,
          onToggle: _toggleMethod,
          onSetPrimary: _setPrimaryMethod,
        ),
        _ThresholdSection(
          thresholds: _thresholds,
          onToggle: _toggleThreshold,
        ),
        _SecurityRecommendation(text: snapshot.recommendation),
        const VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.p2pTwoFactorInnerPadding,
          child: VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Rà soát thay đổi 2FA P2P',
            message:
                'Phương thức bật, yếu tố chính, ngưỡng giao dịch, trạng thái thiết lập và bước bảo mật tiếp theo được rà soát trước khi đổi bảo vệ P2P.',
            contractId: 'SC-254',
          ),
        ),
      ],
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
