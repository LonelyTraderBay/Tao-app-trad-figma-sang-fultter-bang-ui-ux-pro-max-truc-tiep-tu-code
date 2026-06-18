part of '../pages/regulatory_disclosures_page.dart';

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        variant: VitCardVariant.ghost,
        padding: AppSpacing.regulatoryDisclosuresActionPadding,
        borderColor: color,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.regulatoryDisclosuresActionIcon,
            ),
            const SizedBox(width: AppSpacing.regulatoryDisclosuresActionGap),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              color: color,
              size: AppSpacing.regulatoryDisclosuresExternalIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onTap});

  final TradeRegulatoryContact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: RegulatoryDisclosuresPage.contactKey(contact.title),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        padding: AppSpacing.regulatoryDisclosuresContactPadding,
        child: Row(
          children: [
            Icon(
              _contactIcon(contact.icon),
              color: _legalPrimary,
              size: AppSpacing.regulatoryDisclosuresContactIcon,
            ),
            const SizedBox(width: AppSpacing.regulatoryDisclosuresContactGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height:
                          AppSpacing.regulatoryDisclosuresLineHeightCompact,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.regulatoryDisclosuresContactTextGap,
                  ),
                  Text(
                    contact.subtitle,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height:
                          AppSpacing.regulatoryDisclosuresLineHeightCompact,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.text3,
              size: AppSpacing.regulatoryDisclosuresExternalIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document, required this.onTap});

  final TradeRegulatoryDocumentLink document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: VitCard(
        padding: AppSpacing.regulatoryDisclosuresActionPadding,
        child: Row(
          children: [
            Icon(
              _documentIcon(document.icon),
              color: _legalPrimary,
              size: AppSpacing.regulatoryDisclosuresActionIcon,
            ),
            const SizedBox(width: AppSpacing.regulatoryDisclosuresActionGap),
            Expanded(
              child: Text(
                document.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.regulatoryDisclosuresExternalIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegulatoryNoticePanel extends StatelessWidget {
  const _RegulatoryNoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.modalScrim,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitCard(
            padding: AppSpacing.regulatoryDisclosuresNoticePadding,
            radius: VitCardRadius.lg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Regulatory document', style: AppTextStyles.baseMedium),
                const SizedBox(
                  height: AppSpacing.regulatoryDisclosuresNoticeTitleGap,
                ),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(
                  height: AppSpacing.regulatoryDisclosuresNoticeActionGap,
                ),
                VitCtaButton(
                  height: AppSpacing.searchBarCompactHeight,
                  onPressed: onClose,
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData _contactIcon(String icon) {
  return switch (icon) {
    'shield' => Icons.shield_outlined,
    'phone' => Icons.phone_outlined,
    _ => Icons.public_rounded,
  };
}

IconData _documentIcon(String icon) {
  return switch (icon) {
    'lock' => Icons.lock_outline_rounded,
    _ => Icons.description_outlined,
  };
}
