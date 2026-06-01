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
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Icon(Icons.open_in_new_rounded, color: color, size: 14),
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _legalCard,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(_contactIcon(contact.icon), color: _legalPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    contact.subtitle,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.text3,
              size: 14,
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
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _legalCard,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(_documentIcon(document.icon), color: _legalPrimary, size: 16),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                document.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 14,
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
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.modalScrim),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Regulatory document',
                  style: AppTextStyles.baseMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: onClose,
                  borderRadius: AppRadii.inputRadius,
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _legalPrimary,
                      borderRadius: AppRadii.inputRadius,
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
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
