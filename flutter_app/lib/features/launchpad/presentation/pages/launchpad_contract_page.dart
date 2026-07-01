import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

class LaunchpadContractPage extends ConsumerWidget {
  const LaunchpadContractPage({
    super.key,
    this.projectId = 'sample',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc300_launchpad_contract_content');
  static const notFoundKey = Key('sc300_launchpad_contract_not_found');

  final String projectId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(launchpadControllerProvider)
        .getContract(projectId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-300 LaunchpadContractPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: bottomInset,
          semanticLabel: 'SC-300 LaunchpadContractPage scroll surface',
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: SingleChildScrollView(
            key: contentKey,
            physics: const ClampingScrollPhysics(),
            child: VitPageContent(
              padding: VitContentPadding.defaultPadding,
              children: [
                if (snapshot.project == null)
                  const _ContractProjectNotFound()
                else
                  _ContractProjectSummary(snapshot: snapshot),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContractProjectNotFound extends StatelessWidget {
  const _ContractProjectNotFound();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadContractPage.notFoundKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.launchpadEmptyStatePadding,
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Dự án không tồn tại',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractProjectSummary extends StatelessWidget {
  const _ContractProjectSummary({required this.snapshot});

  final LaunchpadContractSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final project = snapshot.project!;
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: project.accent.withValues(alpha: .12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      project.logo,
                      style: AppTextStyles.caption.copyWith(
                        color: project.accent,
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${project.name} Contract',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${snapshot.functions.length} functions · ${snapshot.networks.length} networks',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => context.go(snapshot.abiDiffRoute),
            leading: const Icon(Icons.difference_outlined),
            child: const Text('ABI Diff'),
          ),
        ],
      ),
    );
  }
}
