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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_report_merchant_summary_actions.dart';
part '../widgets/p2p_report_merchant_reasons_details.dart';

class P2PReportMerchantPage extends ConsumerStatefulWidget {
  const P2PReportMerchantPage({
    super.key,
    required this.merchantId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc229_p2p_report_content');
  static const blockButtonKey = Key('sc229_p2p_report_block');
  static const profileButtonKey = Key('sc229_p2p_report_profile');
  static const detailFieldKey = Key('sc229_p2p_report_detail');
  static const submitButtonKey = Key('sc229_p2p_report_submit');

  static Key reasonKey(String id) => Key('sc229_p2p_report_reason_$id');

  final String merchantId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PReportMerchantPage> createState() =>
      _P2PReportMerchantPageState();
}

class _P2PReportMerchantPageState extends ConsumerState<P2PReportMerchantPage> {
  final TextEditingController _detailController = TextEditingController();

  String _selectedReasonId = '';
  bool _submitting = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pReportMerchantProvider(widget.merchantId));
    final selectedReason = snapshot.reasons.where(
      (reason) => reason.id == _selectedReasonId,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-229 P2PReportMerchantPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Báo cáo & Chặn',
              subtitle: 'An toàn · P2P',
              showBack: true,
              onBack: () => _returnToMerchant(snapshot),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PReportMerchantPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MerchantSummaryCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x2),
                      _ReportActionRow(
                        key: P2PReportMerchantPage.blockButtonKey,
                        icon: Icons.person_remove_alt_1_outlined,
                        title: 'Chặn người dùng',
                        subtitle: 'Không thể giao dịch với bạn',
                        foreground: AppColors.sell,
                        background: AppColors.sell10,
                        borderColor: AppColors.sell20,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(snapshot.blacklistAddRoute);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      _ReportActionRow(
                        key: P2PReportMerchantPage.profileButtonKey,
                        icon: Icons.groups_2_outlined,
                        title: 'Xem profile Merchant',
                        subtitle: 'Đánh giá, lịch sử, thông tin chi tiết',
                        foreground: AppColors.text2,
                        background: AppColors.surface2,
                        borderColor: AppColors.borderSolid,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(snapshot.merchantProfileRoute);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      Text(
                        'Báo cáo vi phạm',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'Chọn lý do báo cáo. Đội ngũ VitTrade sẽ xem xét trong 24-48h.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      for (final reason in snapshot.reasons) ...[
                        _ReasonCard(
                          reason: reason,
                          selected: reason.id == _selectedReasonId,
                          onTap: () => _selectReason(reason.id),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                      ],
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: selectedReason.isEmpty
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.x4,
                                ),
                                child: _DetailField(
                                  controller: _detailController,
                                  hintText: snapshot.detailPrompt,
                                  onChanged: () => setState(() {}),
                                ),
                              ),
                      ),
                      _NoticeCard(text: snapshot.reviewNotice),
                      const SizedBox(height: AppSpacing.x4),
                      VitCtaButton(
                        key: P2PReportMerchantPage.submitButtonKey,
                        variant: VitCtaButtonVariant.danger,
                        loading: _submitting,
                        leading: const Icon(Icons.send_rounded),
                        onPressed: _selectedReasonId.isEmpty
                            ? null
                            : () => _submit(snapshot),
                        child: const Text('Gửi báo cáo'),
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

  void _selectReason(String reasonId) {
    HapticFeedback.selectionClick();
    setState(() => _selectedReasonId = reasonId);
  }

  Future<void> _submit(P2PReportMerchantSnapshot snapshot) async {
    if (_selectedReasonId.isEmpty || _submitting) return;
    HapticFeedback.lightImpact();
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    context.go(snapshot.merchantProfileRoute);
  }

  void _returnToMerchant(P2PReportMerchantSnapshot snapshot) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(snapshot.merchantProfileRoute);
  }
}
