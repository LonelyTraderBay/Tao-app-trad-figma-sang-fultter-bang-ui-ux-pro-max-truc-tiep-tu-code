import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _legalPrimary = AppColors.primary;
const _legalBackground = AppColors.bg;
const _legalTabsBackground = AppColors.surface;
const _legalCard = AppColors.surface2;
const _legalGreen = Color(0xFF10B981);
const _legalAmber = Color(0xFFF59E0B);

class RegulatoryDisclosuresPage extends ConsumerStatefulWidget {
  const RegulatoryDisclosuresPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc084_regulatory_disclosures_content');
  static Key tabKey(String id) => Key('sc084_tab_$id');
  static Key contactKey(String title) => Key('sc084_contact_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryDisclosuresPage> createState() =>
      _RegulatoryDisclosuresPageState();
}

class _RegulatoryDisclosuresPageState
    extends ConsumerState<RegulatoryDisclosuresPage> {
  String? _activeTabId;
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getRegulatoryDisclosures();
    _activeTabId ??= snapshot.defaultTabId;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-084 RegulatoryDisclosuresPage',
      child: Material(
        color: _legalBackground,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Regulatory Disclosures',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: RegulatoryDisclosuresPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _LegalHero(snapshot: snapshot),
                        const SizedBox(height: 24),
                        _LegalTabs(
                          tabs: snapshot.tabs,
                          activeId: _activeTabId!,
                          onChanged: (id) => setState(() => _activeTabId = id),
                        ),
                        const SizedBox(height: 27),
                        _LegalTabBody(
                          snapshot: snapshot,
                          activeTabId: _activeTabId!,
                          onNotice: (notice) =>
                              setState(() => _notice = notice),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_notice != null)
              _RegulatoryNoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegalHero extends StatelessWidget {
  const _LegalHero({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _legalPrimary.withValues(alpha: .04),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _legalPrimary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _legalPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.balance_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: _legalPrimary,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  snapshot.heroDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: _legalPrimary,
                    fontSize: 10.5,
                    height: 1.2,
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

class _LegalTabs extends StatelessWidget {
  const _LegalTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeRegulatoryTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      color: _legalTabsBackground,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: RegulatoryDisclosuresPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.id == activeId
                                ? _legalPrimary
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: tab.id == activeId ? 65 : 0,
                      height: 2,
                      color: _legalPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegalTabBody extends StatelessWidget {
  const _LegalTabBody({
    required this.snapshot,
    required this.activeTabId,
    required this.onNotice,
  });

  final TradeRegulatoryDisclosuresSnapshot snapshot;
  final String activeTabId;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return switch (activeTabId) {
      'protection' => _ProtectionTab(
        protection: snapshot.protection,
        onNotice: onNotice,
      ),
      'restrictions' => _RestrictionsTab(restrictions: snapshot.restrictions),
      'liability' => _LiabilityTab(liability: snapshot.liability),
      'contact' => _ContactTab(
        contacts: snapshot.contacts,
        whistleblower: snapshot.whistleblower,
        terms: snapshot.terms,
        onNotice: onNotice,
      ),
      _ => _MifidTab(snapshot: snapshot),
    };
  }
}

class _MifidTab extends StatelessWidget {
  const _MifidTab({required this.snapshot});

  final TradeRegulatoryDisclosuresSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(snapshot.mifidTitle),
        const SizedBox(height: 11),
        for (final article in snapshot.mifidArticles) ...[
          _DisclosureCard(block: article),
          if (article != snapshot.mifidArticles.last)
            const SizedBox(height: 12),
        ],
        const SizedBox(height: 15),
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
        const SizedBox(height: 10),
        _DisclosureCard(
          block: protection.coverage,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        const SizedBox(height: 12),
        _DisclosureCard(block: protection.covered),
        const SizedBox(height: 12),
        _DisclosureCard(block: protection.notCovered),
        const SizedBox(height: 12),
        _DisclosureCard(block: protection.claimSteps, numbered: true),
        const SizedBox(height: 12),
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
        const SizedBox(height: 10),
        _WarningList(
          title: 'Copy Trading Not Available In:',
          items: restrictions.unavailableCountries,
        ),
        const SizedBox(height: 12),
        _LeverageRules(rules: restrictions.leverageRules),
        const SizedBox(height: 12),
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
        const SizedBox(height: 10),
        _DisclosureCard(block: liability.platformRole),
        const SizedBox(height: 12),
        _DisclosureCard(block: liability.userResponsibility),
        const SizedBox(height: 12),
        _DisclosureCard(
          block: liability.indemnification,
          color: AppColors.sell,
          tint: AppColors.sell10,
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 10),
        for (final contact in contacts) ...[
          _ContactTile(
            contact: contact,
            onTap: () => onNotice('${contact.title} would open externally.'),
          ),
          if (contact != contacts.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 18),
        _SectionLabel('Whistleblower Protection'),
        const SizedBox(height: 10),
        _DisclosureCard(
          block: whistleblower,
          color: _legalGreen,
          tint: _legalGreen.withValues(alpha: .13),
        ),
        const SizedBox(height: 18),
        _SectionLabel('Terms & Privacy'),
        const SizedBox(height: 10),
        for (final document in terms) ...[
          _DocumentTile(
            document: document,
            onTap: () => onNotice('${document.title} would open here.'),
          ),
          if (document != terms.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({
    required this.block,
    this.color,
    this.tint,
    this.icon,
    this.numbered = false,
  });

  final TradeRegulatoryDisclosureBlock block;
  final Color? color;
  final Color? tint;
  final IconData? icon;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: tint ?? _legalCard,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: accent, size: 14),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  block.title,
                  style: AppTextStyles.caption.copyWith(
                    color: accent,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          if (block.body.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              block.body,
              style: AppTextStyles.micro.copyWith(
                color: color ?? AppColors.text3,
                fontSize: 10,
                height: 1.45,
              ),
            ),
          ],
          if (block.items.isNotEmpty) ...[
            if (block.body.isNotEmpty) const SizedBox(height: 8),
            for (var index = 0; index < block.items.length; index++) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  numbered || block.items[index].startsWith(RegExp(r'\d\.'))
                      ? block.items[index]
                      : '* ${block.items[index]}',
                  style: AppTextStyles.micro.copyWith(
                    color: color ?? AppColors.text3,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ),
              if (index != block.items.length - 1) const SizedBox(height: 2),
            ],
          ],
        ],
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  const _CommitmentCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: _legalPrimary.withValues(alpha: .06),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _legalPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _legalPrimary,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _legalPrimary,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningList extends StatelessWidget {
  const _WarningList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _legalAmber,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: _legalAmber,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                '* $item',
                style: AppTextStyles.micro.copyWith(
                  color: _legalAmber,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
            if (item != items.last) const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }
}

class _LeverageRules extends StatelessWidget {
  const _LeverageRules({required this.rules});

  final List<TradeRegulatoryDisclosureBlock> rules;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _legalCard,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leverage Restrictions by Region',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 11),
          for (final rule in rules) ...[
            Text(
              rule.title,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              rule.body,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.3,
              ),
            ),
            if (rule != rules.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

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
        decoration: const BoxDecoration(color: Color(0x99000000)),
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
                        color: Colors.white,
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
