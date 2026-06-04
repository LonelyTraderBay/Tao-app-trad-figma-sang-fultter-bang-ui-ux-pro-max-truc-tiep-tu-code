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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PDisputeResolutionPage extends ConsumerStatefulWidget {
  const P2PDisputeResolutionPage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc220_p2p_dispute_resolution_content');
  static const appealKey = Key('sc220_p2p_dispute_resolution_appeal');
  static const disputesKey = Key('sc220_p2p_dispute_resolution_disputes');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeResolutionPage> createState() =>
      _P2PDisputeResolutionPageState();
}

class _P2PDisputeResolutionPageState
    extends ConsumerState<P2PDisputeResolutionPage> {
  bool _appealOpened = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pDisputeResolutionProvider(widget.disputeId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-220 P2PDisputeResolutionPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Kết quả giải quyết',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.p2pDisputeDetail(widget.disputeId)),
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
                    key: P2PDisputeResolutionPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DecisionHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _DecisionDetailCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _AppealCard(
                          deadline: snapshot.appealDeadline,
                          appealOpened: _appealOpened,
                          onAppeal: _openAppeal,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        VitCtaButton(
                          key: P2PDisputeResolutionPage.disputesKey,
                          onPressed: () =>
                              context.go(AppRoutePaths.p2pDisputes),
                          child: const Text('Quay về danh sách tranh chấp'),
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

  void _openAppeal() {
    HapticFeedback.mediumImpact();
    setState(() => _appealOpened = true);
  }
}

class _DecisionHero extends StatelessWidget {
  const _DecisionHero({required this.snapshot});

  final P2PDisputeResolutionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy15),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            decoration: const BoxDecoration(
              color: AppColors.buy,
              borderRadius: AppRadii.inputRadius,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.onAccent,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.resultTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.disputeLabel,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionDetailCard extends StatelessWidget {
  const _DecisionDetailCard({required this.snapshot});

  final P2PDisputeResolutionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết quyết định',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _DetailField(
            label: 'Số tiền hoàn trả',
            value: snapshot.refundAmountLabel,
            prominent: true,
          ),
          const SizedBox(height: AppSpacing.x3),
          _DetailField(label: 'Lý do', value: snapshot.reason),
          const SizedBox(height: AppSpacing.x3),
          _DetailField(label: 'Mediator', value: snapshot.mediator),
          const SizedBox(height: AppSpacing.x3),
          _DetailField(label: 'Quyết định lúc', value: snapshot.resolvedAt),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.prominent = false,
  });

  final String label;
  final String value;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style:
              (prominent ? AppTextStyles.sectionTitle : AppTextStyles.caption)
                  .copyWith(
                    color: prominent ? AppColors.text1 : AppColors.text2,
                    fontWeight: prominent
                        ? AppTextStyles.bold
                        : AppTextStyles.normal,
                    fontFeatures: prominent
                        ? AppTextStyles.tabularFigures
                        : null,
                  ),
        ),
      ],
    );
  }
}

class _AppealCard extends StatelessWidget {
  const _AppealCard({
    required this.deadline,
    required this.appealOpened,
    required this.onAppeal,
  });

  final String deadline;
  final bool appealOpened;
  final VoidCallback onAppeal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.warn10,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quyền kháng cáo',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Bạn có thể kháng cáo quyết định này trước $deadline',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                VitCtaButton(
                  key: P2PDisputeResolutionPage.appealKey,
                  onPressed: onAppeal,
                  variant: VitCtaButtonVariant.warning,
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  child: Text(appealOpened ? 'Đang mở kháng cáo' : 'Kháng cáo'),
                ),
                if (appealOpened) ...[
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'Form kháng cáo đã được chuẩn bị. Mock/fail-closed: chưa gửi appeal lên backend.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
