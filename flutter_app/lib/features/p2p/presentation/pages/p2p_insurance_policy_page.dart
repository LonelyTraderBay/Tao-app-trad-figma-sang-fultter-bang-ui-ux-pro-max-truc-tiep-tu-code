import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PInsurancePolicyPage extends ConsumerWidget {
  const P2PInsurancePolicyPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc241_p2p_insurance_policy_hero');
  static const noticeKey = Key('sc241_p2p_insurance_policy_notice');
  static const sectionsKey = Key('sc241_p2p_insurance_policy_sections');
  static const privacyKey = Key('sc241_p2p_insurance_policy_privacy');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pInsurancePolicyProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-241 P2PInsurancePolicyPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Điều khoản Bảo hiểm P2P',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PolicyHeroCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _PolicyNoticeCard(text: snapshot.notice),
                      const SizedBox(height: AppSpacing.x5),
                      _PolicySectionList(sections: snapshot.sections),
                      const SizedBox(height: AppSpacing.x5),
                      _PrivacyNoticeCard(text: snapshot.privacyNotice),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyHeroCard extends StatelessWidget {
  const _PolicyHeroCard({required this.snapshot});

  final P2PInsurancePolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.heroKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  borderRadius: AppRadii.lgRadius,
                  border: Border.all(color: AppColors.primary20),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.subtitle,
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
          Wrap(
            spacing: AppSpacing.x4,
            runSpacing: AppSpacing.x2,
            children: [
              _PolicyMetaChip(
                icon: Icons.description_outlined,
                label: 'Phiên bản ${snapshot.version}',
                color: AppColors.text3,
              ),
              _PolicyMetaChip(
                icon: Icons.check_circle_outline_rounded,
                label: 'Cập nhật: ${snapshot.lastUpdated}',
                color: AppColors.buy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyMetaChip extends StatelessWidget {
  const _PolicyMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PolicyNoticeCard extends StatelessWidget {
  const _PolicyNoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.noticeKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppModuleAccents.p2p,
            size: 17,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppModuleAccents.p2p,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySectionList extends StatelessWidget {
  const _PolicySectionList({required this.sections});

  final List<P2PInsurancePolicySectionDraft> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PInsurancePolicyPage.sectionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          _PolicySectionCard(section: sections[i]),
          if (i != sections.length - 1)
            const SizedBox(height: AppSpacing.sectionGap),
        ],
      ],
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  const _PolicySectionCard({required this.section});

  final P2PInsurancePolicySectionDraft section;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final item in section.content) ...[
            _PolicyBullet(text: item),
            if (item != section.content.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _PolicyBullet extends StatelessWidget {
  const _PolicyBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.x3),
          child: Container(
            width: AppSpacing.x2,
            height: AppSpacing.x2,
            decoration: const BoxDecoration(
              color: AppColors.text3,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyNoticeCard extends StatelessWidget {
  const _PrivacyNoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.privacyKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.text3,
            size: 15,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
