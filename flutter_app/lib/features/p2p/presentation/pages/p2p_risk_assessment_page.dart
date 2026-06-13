import 'package:flutter/material.dart';
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

class P2PRiskAssessmentPage extends ConsumerWidget {
  const P2PRiskAssessmentPage({super.key, this.shellRenderMode});

  static const scoreHeroKey = Key('sc271_p2p_risk_score_hero');
  static const infoKey = Key('sc271_p2p_risk_info');
  static const factorsKey = Key('sc271_p2p_risk_factors');

  static Key factorKey(String id) => Key('sc271_p2p_risk_factor_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRiskAssessmentProvider);
    final controller = P2PRiskAssessmentController(
      state: P2PRiskAssessmentViewState(snapshot: snapshot),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-271 P2PRiskAssessmentPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _RiskScoreHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _RiskInfo(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x6),
                        Text(
                          snapshot.factorTitle,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _RiskFactorList(factors: controller.materialFactors),
                        const SizedBox(height: AppSpacing.x3),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: EdgeInsets.all(AppSpacing.x3),
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'P2P risk score review',
                            message:
                                'Risk score, factor weights, account signals, limit impact and next review step are checked before P2P exposure changes.',
                            contractId: 'p2p-risk-assessment-review',
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
}

class _RiskScoreHero extends StatelessWidget {
  const _RiskScoreHero({required this.snapshot});

  final P2PRiskAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PRiskAssessmentPage.scoreHeroKey,
      padding: const EdgeInsets.all(AppSpacing.x5),
      decoration: BoxDecoration(
        color: AppColors.buy,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.buy),
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.onAccent.withValues(alpha: .20),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: Text(
                  '${snapshot.score}',
                  style: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            snapshot.scoreLabel,
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.scoreSubtitle,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent.withValues(alpha: .90),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskInfo extends StatelessWidget {
  const _RiskInfo({required this.snapshot});

  final P2PRiskAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PRiskAssessmentPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              snapshot.infoText,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskFactorList extends StatelessWidget {
  const _RiskFactorList({required this.factors});

  final List<P2PRiskFactorDraft> factors;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PRiskAssessmentPage.factorsKey,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < factors.length; index++) ...[
            _RiskFactorRow(factor: factors[index]),
            if (index != factors.length - 1)
              const Divider(height: 1, color: AppColors.borderSolid),
          ],
        ],
      ),
    );
  }
}

class _RiskFactorRow extends StatelessWidget {
  const _RiskFactorRow({required this.factor});

  final P2PRiskFactorDraft factor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2PRiskAssessmentPage.factorKey(factor.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.buy15,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  factor.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            '+${factor.score}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
