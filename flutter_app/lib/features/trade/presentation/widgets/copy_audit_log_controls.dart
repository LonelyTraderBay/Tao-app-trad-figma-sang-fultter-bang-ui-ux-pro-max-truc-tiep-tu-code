part of '../pages/copy_audit_log_page.dart';

class _ExportHeaderButton extends StatelessWidget {
  const _ExportHeaderButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyAuditLogPage.exportActionKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _auditChip,
          borderRadius: AppRadii.mdRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Icon(
          Icons.file_download_outlined,
          color: AppColors.text1,
          size: 21,
        ),
      ),
    );
  }
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice({required this.snapshot});

  final TradeCopyAuditLogSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _auditPrimary.withValues(alpha: .08),
        border: Border.all(color: _auditPrimary),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _auditPrimary, size: 15),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  snapshot.complianceDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _auditPrimary,
                    fontSize: 9,
                    height: 1.35,
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
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _auditChip,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _auditMuted, size: 19),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              key: CopyAuditLogPage.searchFieldKey,
              controller: controller,
              onChanged: onChanged,
              cursorColor: _auditPrimary,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: AppTextStyles.medium,
                height: 1,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Tìm kiếm event, pair, ID...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: _auditMuted,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditFilterTabs extends StatelessWidget {
  const _AuditFilterTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeCopyAuditTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tab in tabs) ...[
          _AuditFilterPill(
            key: CopyAuditLogPage.tabKey(tab.id),
            tab: tab,
            active: tab.id == activeId,
            onTap: () => onChanged(tab.id),
          ),
          if (tab != tabs.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _AuditFilterPill extends StatelessWidget {
  const _AuditFilterPill({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final TradeCopyAuditTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        width: _tabWidth(tab.id),
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _auditPrimary.withValues(alpha: .14) : _auditChip,
          borderRadius: AppRadii.lgRadius,
          border: Border.all(
            color: active ? _auditPrimary : AppColors.transparent,
          ),
        ),
        child: Text(
          tab.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _auditPrimary : _auditMuted,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }

  double _tabWidth(String id) {
    return switch (id) {
      'all' => 69,
      'trade' => 73,
      'config' => 74,
      'risk' => 61,
      'system' => 82,
      _ => 68,
    };
  }
}
