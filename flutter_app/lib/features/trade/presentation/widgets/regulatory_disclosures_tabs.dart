part of '../pages/regulatory_disclosures_page.dart';

class _MifidTab extends StatelessWidget {
  const _MifidTab({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(snapshot.mifidTitle),
        const SizedBox(height: AppSpacing.x3 + AppSpacing.x1),
        for (final article in snapshot.mifidArticles) ...[
          _DisclosureCard(block: article),
          if (article != snapshot.mifidArticles.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
        ],
        const SizedBox(height: AppSpacing.x5 - AppSpacing.formFieldLabelGap),
        _CommitmentCard(text: snapshot.commitmentText),
      ],
    );
  }
}

class _ProtectionTab extends StatelessWidget {
  const _ProtectionTab({required this.protection, required this.onNotice});

  final TradeRegulatoryProtection protection;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Investor Protection Scheme'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        _DisclosureCard(
          block: protection.coverage,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: protection.covered),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: protection.notCovered),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: protection.claimSteps, numbered: true),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _ActionTile(
          title: protection.contactLabel,
          icon: Icons.phone_outlined,
          color: _legalPrimary,
          onTap: () => onNotice('ICS contact details would open here.'),
        ),
      ],
    );
  }
}

class _RestrictionsTab extends StatelessWidget {
  const _RestrictionsTab({required this.restrictions});

  final TradeRegulatoryRestrictions restrictions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Jurisdictional Restrictions'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        _WarningList(
          title: 'Copy Trading Not Available In:',
          items: restrictions.unavailableCountries,
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _LeverageRules(rules: restrictions.leverageRules),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: restrictions.taxReporting),
      ],
    );
  }
}

class _LiabilityTab extends StatelessWidget {
  const _LiabilityTab({required this.liability});

  final TradeRegulatoryLiability liability;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Liability Limitations'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        _DisclosureCard(block: liability.platformRole),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: liability.userResponsibility),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(
          block: liability.indemnification,
          color: AppColors.sell,
          tint: AppColors.sell10,
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _DisclosureCard(block: liability.limitation),
      ],
    );
  }
}

class _ContactTab extends StatelessWidget {
  const _ContactTab({
    required this.contacts,
    required this.whistleblower,
    required this.terms,
    required this.onNotice,
  });

  final List<TradeRegulatoryContact> contacts;
  final TradeRegulatoryDisclosureBlock whistleblower;
  final List<TradeRegulatoryDocumentLink> terms;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Regulatory Contact Information'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        for (final contact in contacts) ...[
          _ContactTile(
            contact: contact,
            onTap: () => onNotice('${contact.title} would open externally.'),
          ),
          if (contact != contacts.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
        const SizedBox(height: AppSpacing.x4 + AppSpacing.x2),
        _SectionLabel('Whistleblower Protection'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        _DisclosureCard(
          block: whistleblower,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        const SizedBox(height: AppSpacing.x4 + AppSpacing.x2),
        _SectionLabel('Terms & Privacy'),
        const SizedBox(height: AppSpacing.x4 - AppSpacing.x1),
        for (final document in terms) ...[
          _DocumentTile(
            document: document,
            onTap: () => onNotice('${document.title} would open here.'),
          ),
          if (document != terms.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}
