import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

part '../widgets/p2p_order_rate_widgets.dart';

const double _p2pOrderRateVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pOrderRateNativeNavClearance =
    _p2pOrderRateVisualNavClearance - AppSpacing.x4;
const double _p2pOrderRateVisualClearance = AppSpacing.x3;
const double _p2pOrderRateNativeClearance = AppSpacing.x2;

class P2POrderRatePage extends ConsumerStatefulWidget {
  const P2POrderRatePage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc213_p2p_order_rate_content');
  static const submitKey = Key('sc213_p2p_order_rate_submit');
  static const skipKey = Key('sc213_p2p_order_rate_skip');
  static const reviewKey = Key('sc213_p2p_order_rate_review');
  static const backToP2PKey = Key('sc213_p2p_order_rate_back_to_p2p');

  static Key starKey(int rating) => Key('sc213_p2p_order_rate_star_$rating');

  static Key tagKey(String label) => Key('sc213_p2p_order_rate_tag_$label');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderRatePage> createState() => _P2POrderRatePageState();
}

class _P2POrderRatePageState extends ConsumerState<P2POrderRatePage> {
  final TextEditingController _reviewController = TextEditingController();
  final Set<String> _selectedTags = {};
  int _rating = 0;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pOrderRateProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pOrderRateVisualNavClearance + _p2pOrderRateVisualClearance
            : _p2pOrderRateNativeNavClearance + _p2pOrderRateNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-213 P2POrderRatePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _submitted ? 'Đánh giá' : 'Đánh giá giao dịch',
            subtitle: 'Đánh giá · P2P',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _submitted
                    ? _SuccessView(
                        title: snapshot.successTitle,
                        message: snapshot.successMessage,
                        onBackToP2P: () => context.go(AppRoutePaths.p2p),
                      )
                    : ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          key: P2POrderRatePage.contentKey,
                          physics: const ClampingScrollPhysics(),
                          padding: AppSpacing.p2pOrderLifecycleScrollPadding(
                            scrollEndPadding,
                          ),
                          child: VitPageContent(
                            rhythm: VitPageRhythm.form,
                            padding: VitContentPadding.compact,
                            children: [
                              _MerchantSummary(order: snapshot.order),
                              _RatingCard(
                                rating: _rating,
                                onRating: _setRating,
                              ),
                              if (_rating > 0)
                                _QuickTags(
                                  tags: snapshot.quickTags,
                                  selectedTags: _selectedTags,
                                  onToggle: _toggleTag,
                                ),
                              if (_rating > 0)
                                _ReviewBox(controller: _reviewController),
                              _ActionRow(
                                enabled: _rating > 0,
                                loading: _isSubmitting,
                                onSkip: () => _close(context),
                                onSubmit: _submit,
                              ),
                              const VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Order rating state review',
                                message:
                                    'Merchant summary, rating selection, quick tags, review text, skip path, disabled submit, submitting state, and success view remain visible before closing feedback.',
                                contractId: 'SC-213',
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

  void _setRating(int value) {
    HapticFeedback.selectionClick();
    setState(() => _rating = value);
  }

  void _toggleTag(String label) {
    HapticFeedback.selectionClick();
    setState(() {
      if (!_selectedTags.add(label)) {
        _selectedTags.remove(label);
      }
    });
  }

  Future<void> _submit() async {
    if (_rating == 0 || _isSubmitting) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

  void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.p2pOrder(widget.orderId));
  }
}
