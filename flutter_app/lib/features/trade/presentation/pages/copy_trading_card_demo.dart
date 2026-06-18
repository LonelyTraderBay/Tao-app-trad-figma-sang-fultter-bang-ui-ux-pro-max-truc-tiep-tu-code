import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/copy_trading_card_demo_widgets.dart';

part '../widgets/copy_trading_card_demo_sections.dart';
part '../widgets/copy_trading_card_demo_common.dart';

class CopyTradingCardDemo extends ConsumerWidget {
  const CopyTradingCardDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc401_copy_card_content');
  static const analysisKey = Key('sc401_copy_card_analysis');
  static const matrixKey = Key('sc401_copy_card_matrix');
  static const issuesKey = Key('sc401_copy_card_issues');
  static const recommendationKey = Key('sc401_copy_card_recommendation');
  static const guidelinesKey = Key('sc401_copy_card_guidelines');

  static Key variantKey(String id) => Key('sc401_variant_$id');
  static Key cardKey(String id) => CopyTradingCardDemoUiKeys.cardKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopyCardDemo();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-401 CopyTradingCardDemo',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyTradingCardDemo.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.tradeBotCopyDemoScrollPadding(
                    bottomInset,
                  ),
                  child: VitPageContent(
                    gap: VitContentGap.loose,
                    children: [
                      _AnalysisHeader(snapshot: snapshot),
                      for (final variant in snapshot.variants)
                        CopyTradingVariantSection(
                          key: CopyTradingCardDemo.variantKey(variant.id),
                          variant: variant,
                          metrics: snapshot.metrics,
                        ),
                      _ComparisonMatrix(issues: snapshot.issues),
                      _OriginalIssues(issues: snapshot.originalIssues),
                      _Recommendation(snapshot: snapshot),
                      _Guidelines(guidelines: snapshot.guidelines),
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
}
