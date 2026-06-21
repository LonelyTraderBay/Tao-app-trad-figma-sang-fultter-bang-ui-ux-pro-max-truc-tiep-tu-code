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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_kyc_status_page_sections.dart';
part '../widgets/p2p_kyc_status_page_common.dart';

class P2PKycStatusPage extends ConsumerWidget {
  const P2PKycStatusPage({super.key, this.shellRenderMode});

  static const statusCardKey = Key('sc248_p2p_kyc_status_card');
  static const timelineKey = Key('sc248_p2p_kyc_status_timeline');
  static Key stepKey(String stepId) => Key('sc248_p2p_kyc_status_step_$stepId');
  static Key actionKey(String stepId) =>
      Key('sc248_p2p_kyc_status_action_$stepId');
  static const supportKey = Key('sc248_p2p_kyc_status_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pKycStatusProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.p2pKycBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.p2pKycBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-248 P2PKycStatusPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'KYC Status',
            subtitle: 'KYC · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppModuleAccents.p2p,
                  backgroundColor: AppColors.surface2,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 120),
                    );
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      padding: AppSpacing.p2pKycScrollPadding(bottomInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _OverallStatusCard(snapshot: snapshot),
                          const SizedBox(height: AppSpacing.x3),
                          Text(
                            'Chi tiết các bước',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          _StatusTimeline(steps: snapshot.steps),
                          const SizedBox(height: AppSpacing.x3),
                          _SupportCard(snapshot: snapshot),
                          VitPageContent(
                            padding: VitContentPadding.compact,
                            customGap: AppSpacing.p2pKycContentGap,
                            children: const [
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'KYC status state review',
                                message:
                                    'Overall status, refresh state, timeline actions, support path, and P2P trading impact remain visible while verification is reviewed.',
                                contractId: 'SC-248',
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
