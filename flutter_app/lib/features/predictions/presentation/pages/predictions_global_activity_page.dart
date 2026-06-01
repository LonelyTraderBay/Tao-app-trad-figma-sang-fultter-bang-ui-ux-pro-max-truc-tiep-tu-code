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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../widgets/predictions_global_activity_widgets.dart';
part '../widgets/predictions_global_activity_feed_widgets.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsGlobalActivityPage extends ConsumerStatefulWidget {
  const PredictionsGlobalActivityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc034_predictions_activity_content');
  static const allFilterKey = Key('sc034_filter_all');
  static const amount100FilterKey = Key('sc034_filter_100');
  static const amount500FilterKey = Key('sc034_filter_500');

  static Key activityKey(String id) => Key('sc034_activity_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsGlobalActivityPage> createState() =>
      _PredictionsGlobalActivityPageState();
}

class _PredictionsGlobalActivityPageState
    extends ConsumerState<PredictionsGlobalActivityPage> {
  double _minAmount = 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getGlobalActivity(minAmount: _minAmount);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-034 PredictionsGlobalActivityPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Global Activity',
              subtitle: 'Hoạt động · Prediction',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.marketsPredictionEvent('pred-1')),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsGlobalActivityPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _LiveStats(snapshot: snapshot),
                      _AmountFilters(
                        active: _minAmount,
                        onSelected: (value) => setState(() {
                          _minAmount = value;
                        }),
                      ),
                      if (snapshot.activities.isEmpty)
                        const VitEmptyState(
                          title: 'No activity found',
                          message: 'Lower the minimum amount filter',
                          icon: Icons.timeline_rounded,
                        )
                      else
                        _ActivityList(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
