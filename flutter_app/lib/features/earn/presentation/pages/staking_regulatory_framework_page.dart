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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_regulatory_framework_hero_licenses.dart';
part '../widgets/staking_regulatory_framework_protection_complaints.dart';
part '../widgets/staking_regulatory_framework_sheet_common.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
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
      ),
    );
  }

  Future<void> _openLicenseSheet(StakingLicenseDraft license) async {
    HapticFeedback.selectionClick();
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.sheetTopLargeRadius,
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: AppSpacing.earnSheetContentPadding,
                child: _LicenseDetailSheet(license: license),
              ),
            ),
          ),
        );
      },
    );
  }
}
