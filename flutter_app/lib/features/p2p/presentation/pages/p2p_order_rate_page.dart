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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-213 P2POrderRatePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: _submitted ? 'Danh gia' : 'Danh gia giao dich',
              subtitle: 'Danh gia - P2P',
              showBack: true,
              onBack: () => _close(context),
            ),
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
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: VitPageContent(
                          padding: VitContentPadding.relaxed,
                          customGap: AppSpacing.x6,
                          children: [
                            _MerchantSummary(order: snapshot.order),
                            _RatingCard(rating: _rating, onRating: _setRating),
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

class _MerchantSummary extends StatelessWidget {
  const _MerchantSummary({required this.order});

  final P2POrderRateDraft order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        children: [
          Container(
            width: AppSpacing.x7 + AppSpacing.x3,
            height: AppSpacing.x7 + AppSpacing.x3,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              order.merchant.substring(0, 1),
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            order.merchant,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${order.typeLabel} ${_formatAmount(order.amount)} ${order.asset} - ${_formatVnd(order.totalVnd)}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.rating, required this.onRating});

  final int rating;
  final ValueChanged<int> onRating;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          Text(
            'Ban danh gia merchant nay the nao?',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var value = 1; value <= 5; value++)
                _StarButton(
                  rating: value,
                  selected: value <= rating,
                  onPressed: () => onRating(value),
                ),
            ],
          ),
          if (rating > 0) ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              _ratingLabel(rating),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StarButton extends StatelessWidget {
  const _StarButton({
    required this.rating,
    required this.selected,
    required this.onPressed,
  });

  final int rating;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: P2POrderRatePage.starKey(rating),
      tooltip: '$rating stars',
      onPressed: onPressed,
      icon: Icon(
        selected ? Icons.star_rounded : Icons.star_border_rounded,
        color: selected ? AppColors.warn : AppColors.borderSolid,
        size: AppSpacing.iconLg + AppSpacing.x2,
      ),
    );
  }
}

class _QuickTags extends StatelessWidget {
  const _QuickTags({
    required this.tags,
    required this.selectedTags,
    required this.onToggle,
  });

  final List<P2POrderRateTagDraft> tags;
  final Set<String> selectedTags;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhan xet nhanh',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final tag in tags)
              _TagChip(
                tag: tag,
                selected: selectedTags.contains(tag.label),
                onPressed: () => onToggle(tag.label),
              ),
          ],
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.selected,
    required this.onPressed,
  });

  final P2POrderRateTagDraft tag;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      key: P2POrderRatePage.tagKey(tag.label),
      onPressed: onPressed,
      avatar: Icon(
        _tagIcon(tag.iconKey),
        color: selected ? AppColors.warn : AppColors.text3,
        size: AppSpacing.iconSm,
      ),
      label: Text(tag.label),
      backgroundColor: selected ? AppColors.warn15 : AppColors.surface2,
      side: BorderSide(
        color: selected ? AppColors.warningBorder : AppColors.borderSolid,
      ),
      labelStyle: AppTextStyles.micro.copyWith(
        color: selected ? AppColors.warn : AppColors.text2,
        fontWeight: selected ? AppTextStyles.bold : AppTextStyles.medium,
      ),
    );
  }
}

class _ReviewBox extends StatelessWidget {
  const _ReviewBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhan xet chi tiet (tuy chon)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.inputRadius,
          ),
          child: TextField(
            key: P2POrderRatePage.reviewKey,
            controller: controller,
            minLines: 4,
            maxLines: 4,
            cursorColor: AppColors.primary,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            decoration: InputDecoration(
              hintText: 'Chia se trai nghiem giao dich...',
              hintStyle: AppTextStyles.caption.copyWith(color: AppColors.text3),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.x4),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.enabled,
    required this.loading,
    required this.onSkip,
    required this.onSubmit,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderRatePage.skipKey,
            onPressed: onSkip,
            variant: VitCtaButtonVariant.secondary,
            child: const Text('Bo qua'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2POrderRatePage.submitKey,
            onPressed: enabled ? onSubmit : null,
            loading: loading,
            variant: VitCtaButtonVariant.warning,
            leading: const Icon(Icons.send_outlined),
            child: const Text('Gui danh gia'),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.title,
    required this.message,
    required this.onBackToP2P,
  });

  final String title;
  final String message;
  final VoidCallback onBackToP2P;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.contentPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpacing.x7 + AppSpacing.x5,
              height: AppSpacing.x7 + AppSpacing.x5,
              decoration: BoxDecoration(
                color: AppColors.buy15,
                borderRadius: AppRadii.cardLargeRadius,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(height: AppSpacing.x5),
            VitCtaButton(
              key: P2POrderRatePage.backToP2PKey,
              onPressed: onBackToP2P,
              variant: VitCtaButtonVariant.success,
              child: const Text('Quay lai P2P'),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _tagIcon(String iconKey) {
  return switch (iconKey) {
    'speed' => Icons.bolt_outlined,
    'positive' => Icons.thumb_up_alt_outlined,
    'trust' => Icons.shield_outlined,
    'price' => Icons.payments_outlined,
    'slow' => Icons.schedule_outlined,
    'improve' => Icons.edit_note_outlined,
    _ => Icons.label_outline,
  };
}

String _ratingLabel(int rating) {
  return switch (rating) {
    5 => 'Xuat sac!',
    4 => 'Rat tot',
    3 => 'Tot',
    2 => 'Tam duoc',
    _ => 'Khong hai long',
  };
}

String _formatAmount(double value) {
  return value.toStringAsFixed(4);
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
