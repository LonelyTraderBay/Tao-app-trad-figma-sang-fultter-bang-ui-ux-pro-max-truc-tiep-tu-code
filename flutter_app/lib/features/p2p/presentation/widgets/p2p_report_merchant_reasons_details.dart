part of '../pages/p2p_report_merchant_page.dart';

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
      color: AppColors.transparent,
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
        VitInput(
          fieldKey: P2PReportMerchantPage.detailFieldKey,
          controller: controller,
          semanticLabel: 'P2P merchant report details',
          hintText: hintText,
          textStyle: AppTextStyles.body.copyWith(color: AppColors.text1),
          onChanged: (_) => onChanged(),
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
