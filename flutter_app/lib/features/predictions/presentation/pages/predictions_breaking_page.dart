import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../widgets/predictions_breaking_page_sections.dart';
part '../widgets/predictions_breaking_page_common.dart';

const _predictionPrimary = AppColors.primary;
const _emailPurple = AppColors.accent;
const _breakingSpace = AppSpacing.x2;
const _breakingTinySpace = AppSpacing.x1;
const _breakingVisualScrollClearance = 112.0;
const _breakingNativeScrollClearance = 72.0;
const _breakingIconBox = 34.0;
const _breakingRankBox = 28.0;
const _breakingCtaHeight = 44.0;

class PredictionsBreakingPage extends ConsumerStatefulWidget {
  const PredictionsBreakingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc029_predictions_breaking_content');
  static const allTabKey = Key('sc029_category_all');
  static const cryptoTabKey = Key('sc029_category_crypto');
  static const emailFieldKey = Key('sc029_email_field');
  static const subscribeKey = Key('sc029_subscribe');

  static Key moverKey(String id) => Key('sc029_mover_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsBreakingPage> createState() =>
      _PredictionsBreakingPageState();
}

class _PredictionsBreakingPageState
    extends ConsumerState<PredictionsBreakingPage> {
  final TextEditingController _emailController = TextEditingController();

  String? _category;
  bool _subscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(predictionsReadModelControllerProvider)
        .getBreaking(category: _category);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _breakingVisualScrollClearance
            : _breakingNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-029 PredictionsBreakingPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Breaking Movers',
            subtitle: 'Biến động · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
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
                    key: PredictionsBreakingPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        _MovementSummary(snapshot: snapshot),
                        _CategoryTabs(
                          categories: snapshot.categories,
                          activeCategory: _category,
                          onSelected: (value) => setState(() {
                            _category = value;
                          }),
                        ),
                        if (snapshot.movers.isEmpty)
                          const _BreakingEmptyState()
                        else
                          for (
                            var index = 0;
                            index < snapshot.movers.length;
                            index += 1
                          )
                            _MoverCard(
                              key: PredictionsBreakingPage.moverKey(
                                snapshot.movers[index].id,
                              ),
                              event: snapshot.movers[index],
                              rank: index + 1,
                              onTap: () => context.go(
                                AppRoutePaths.marketsPredictionEvent(
                                  snapshot.movers[index].id,
                                ),
                              ),
                            ),
                        _EmailCta(
                          controller: _emailController,
                          subscribed: _subscribed,
                          onSubscribe: () => setState(() {
                            if (_emailController.text.contains('@')) {
                              _subscribed = true;
                            }
                          }),
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
