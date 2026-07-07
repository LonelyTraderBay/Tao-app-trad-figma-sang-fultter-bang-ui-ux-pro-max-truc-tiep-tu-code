part of '../pages/copy_audit_log_page.dart';

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeCopyAuditLogSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.copyAuditNoticePadding,
      density: VitDensity.compact,
      borderColor: _auditPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: _auditPrimary,
            size: AppSpacing.walletTokenApprovalActionIcon,
          ),
          const SizedBox(width: _auditSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.complianceDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    height: _auditNoticeLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditSearchField extends StatelessWidget {
  const _AuditSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      fieldKey: CopyAuditLogPage.searchFieldKey,
      placeholder: 'Tìm kiếm event, pair, ID...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

