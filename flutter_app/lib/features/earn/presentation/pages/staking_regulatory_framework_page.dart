import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class StakingRegulatoryFrameworkPage extends ConsumerStatefulWidget {
  const StakingRegulatoryFrameworkPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc373_regulatory_hero');
  static const tabsKey = Key('sc373_regulatory_tabs');
  static const licensesKey = Key('sc373_regulatory_licenses');
  static const protectionKey = Key('sc373_regulatory_protection');
  static const complaintsKey = Key('sc373_regulatory_complaints');
  static const footerKey = Key('sc373_regulatory_footer');
  static const detailCtaKey = Key('sc373_license_detail_cta');

  static Key tabKey(String id) => Key('sc373_tab_$id');

  static Key licenseKey(String licenseNumber) =>
      Key('sc373_license_$licenseNumber');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRegulatoryFrameworkPage> createState() =>
      _StakingRegulatoryFrameworkPageState();
}

class _StakingRegulatoryFrameworkPageState
    extends ConsumerState<StakingRegulatoryFrameworkPage> {
  String? _activeTab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRegulatoryFrameworkRepositoryProvider)
        .getFramework();
    _activeTab ??= snapshot.defaultTabId;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-373 StakingRegulatoryFrameworkPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _HeroCard(snapshot: snapshot),
                    _Tabs(
                      tabs: snapshot.tabs,
                      activeTab: _activeTab!,
                      onChanged: (id) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = id);
                      },
                    ),
                    if (_activeTab == 'protection')
                      _ProtectionTab(snapshot: snapshot)
                    else if (_activeTab == 'complaints')
                      _ComplaintsTab(snapshot: snapshot)
                    else
                      _LicensesTab(
                        snapshot: snapshot,
                        onLicenseTap: _openLicenseSheet,
                      ),
                    _FooterNote(text: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLicenseSheet(StakingLicenseDraft license) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _LicenseDetailSheet(license: license),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRegulatoryFrameworkPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingRegulatoryTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: StakingRegulatoryFrameworkPage.tabsKey,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
        activeKey: activeTab,
        onChanged: onChanged,
      ),
    );
  }
}

class _LicensesTab extends StatelessWidget {
  const _LicensesTab({required this.snapshot, required this.onLicenseTap});

  final StakingRegulatoryFrameworkSnapshot snapshot;
  final ValueChanged<StakingLicenseDraft> onLicenseTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.licensesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Global Regulatory Licenses',
          accentColor: AppColors.primarySoft,
          children: [
            Column(
              children: [
                for (final license in snapshot.licenses) ...[
                  _LicenseCard(
                    key: StakingRegulatoryFrameworkPage.licenseKey(
                      license.licenseNumber,
                    ),
                    license: license,
                    onTap: () => onLicenseTap(license),
                  ),
                  if (license != snapshot.licenses.last)
                    const SizedBox(height: AppSpacing.x3),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _InfoNote(text: snapshot.licenseNote, icon: Icons.verified_outlined),
      ],
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({super.key, required this.license, required this.onTap});

  final StakingLicenseDraft license;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: Icons.location_on_outlined, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(license.jurisdiction, style: AppTextStyles.baseMedium),
                    _StatusPill(status: license.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  license.regulator,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  license.licenseNumber,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final scope in license.scope.take(2))
                      _SmallPill(label: scope, color: AppColors.text2),
                    if (license.scope.length > 2)
                      _SmallPill(
                        label: '+${license.scope.length - 2} more',
                        color: AppColors.text3,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtectionTab extends StatelessWidget {
  const _ProtectionTab({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.protectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Investor Protection Schemes',
          accentColor: AppColors.primarySoft,
          children: [
            Column(
              children: [
                for (final scheme in snapshot.protectionSchemes) ...[
                  _ProtectionCard(scheme: scheme),
                  if (scheme != snapshot.protectionSchemes.last)
                    const SizedBox(height: AppSpacing.x3),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _WarningNote(text: snapshot.protectionWarning),
      ],
    );
  }
}

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.scheme});

  final StakingProtectionSchemeDraft scheme;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoundIcon(icon: Icons.shield_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scheme.jurisdiction, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      scheme.scheme,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                scheme.coverage,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Text(
              scheme.description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Eligibility: ${scheme.eligibility}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintsTab extends StatelessWidget {
  const _ComplaintsTab({required this.snapshot});

  final StakingRegulatoryFrameworkSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRegulatoryFrameworkPage.complaintsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Complaint Handling Process',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How to File a Complaint',
                    style: AppTextStyles.baseMedium,
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  for (final step in snapshot.complaintSteps) ...[
                    _ComplaintStep(step: step),
                    if (step != snapshot.complaintSteps.last)
                      const SizedBox(height: AppSpacing.x4),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitPageSection(
          label: 'Regulatory Authority Contacts',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final contact in snapshot.authorityContacts) ...[
                    _AuthorityContact(contact: contact),
                    if (contact != snapshot.authorityContacts.last)
                      const Divider(color: AppColors.divider, height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComplaintStep extends StatelessWidget {
  const _ComplaintStep({required this.step});

  final StakingComplaintStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            child: Center(
              child: Text(
                '${step.step}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.action,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthorityContact extends StatelessWidget {
  const _AuthorityContact({required this.contact});

  final StakingAuthorityContactDraft contact;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contact.email,
            style: AppTextStyles.micro.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            contact.phone,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _LicenseDetailSheet extends StatelessWidget {
  const _LicenseDetailSheet({required this.license});

  final StakingLicenseDraft license;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                license.jurisdiction,
                style: AppTextStyles.sectionTitle,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Regulator',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  _StatusPill(status: license.status),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(license.regulator, style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.x4),
              _SheetRow(label: 'License Number', value: license.licenseNumber),
              _SheetRow(label: 'Issued Date', value: license.issuedDate),
              if (license.expiryDate != null)
                _SheetRow(label: 'Expiry Date', value: license.expiryDate!),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Authorized Scope',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final scope in license.scope) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  scope,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          if (scope != license.scope.last)
            const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: StakingRegulatoryFrameworkPage.detailCtaKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
          trailing: const Icon(Icons.open_in_new_rounded),
          child: Text('Verify on ${license.website}'),
        ),
      ],
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primarySoft, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRegulatoryFrameworkPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StakingLicenseStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return _SmallPill(label: _statusLabel(status), color: color);
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

String _statusLabel(StakingLicenseStatus status) {
  return switch (status) {
    StakingLicenseStatus.active => 'Active',
    StakingLicenseStatus.pending => 'Pending',
    StakingLicenseStatus.expired => 'Expired',
  };
}

Color _statusColor(StakingLicenseStatus status) {
  return switch (status) {
    StakingLicenseStatus.active => AppColors.buy,
    StakingLicenseStatus.pending => AppColors.warn,
    StakingLicenseStatus.expired => AppColors.sell,
  };
}
