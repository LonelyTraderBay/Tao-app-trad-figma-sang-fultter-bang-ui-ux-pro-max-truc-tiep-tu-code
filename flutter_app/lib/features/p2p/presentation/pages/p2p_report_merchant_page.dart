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
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

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
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getReportMerchant(widget.merchantId);
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

class _MerchantSummaryCard extends StatelessWidget {
  const _MerchantSummaryCard({required this.snapshot});

  final P2PReportMerchantSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final merchant = snapshot.merchant;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _MerchantAvatar(name: merchant.name),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'ID: ${snapshot.merchantId}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppModuleAccents.p2p, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.x6),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first.toUpperCase(),
        style: AppTextStyles.baseMedium.copyWith(
          color: AppColors.navCenterIcon,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ReportActionRow extends StatelessWidget {
  const _ReportActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.foreground,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.cardRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: AppRadii.cardRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Icon(icon, color: foreground, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: foreground,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final P2PReportReasonDraft reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(reason.tone);
    return Material(
      key: P2PReportMerchantPage.reasonKey(reason.id),
      color: Colors.transparent,
      borderRadius: AppRadii.cardRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? tone.withValues(alpha: 0.10) : AppColors.surface2,
          border: Border.all(
            color: selected
                ? tone.withValues(alpha: 0.36)
                : AppColors.borderSolid,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tone.withValues(alpha: 0.12),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _reasonIcon(reason.iconKey),
                    color: tone,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reason.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? tone : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        reason.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _toneColor(P2PReportReasonTone tone) {
    return switch (tone) {
      P2PReportReasonTone.danger => AppColors.sell,
      P2PReportReasonTone.purple => AppColors.accent,
      P2PReportReasonTone.warning => AppColors.warn,
      P2PReportReasonTone.info => AppModuleAccents.p2p,
      P2PReportReasonTone.neutral => AppColors.text3,
    };
  }

  IconData _reasonIcon(String key) {
    return switch (key) {
      'alert' => Icons.warning_amber_rounded,
      'ban' => Icons.block_rounded,
      'message' => Icons.chat_bubble_outline_rounded,
      'currency' => Icons.attach_money_rounded,
      'eye' => Icons.visibility_outlined,
      _ => Icons.flag_outlined,
    };
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc229_detail_field_visible'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chi tiết bổ sung (tuỳ chọn)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid, width: 1.5),
            borderRadius: AppRadii.inputRadius,
          ),
          child: TextField(
            key: P2PReportMerchantPage.detailFieldKey,
            controller: controller,
            minLines: 4,
            maxLines: 4,
            cursorColor: AppColors.primary,
            style: AppTextStyles.body.copyWith(color: AppColors.text1),
            onChanged: (_) => onChanged(),
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.border,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.p2p,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
