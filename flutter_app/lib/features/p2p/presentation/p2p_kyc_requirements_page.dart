import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PKycRequirementsPage extends ConsumerWidget {
  const P2PKycRequirementsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc247_p2p_kyc_requirements_hero');
  static const noticeKey = Key('sc247_p2p_kyc_requirements_notice');
  static Key tierKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_tier_$tierId');
  static Key upgradeKey(int tierId) =>
      Key('sc247_p2p_kyc_requirements_upgrade_$tierId');
  static const supportKey = Key('sc247_p2p_kyc_requirements_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pRepositoryProvider).getKycRequirements();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-247 P2PKycRequirementsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'P2P KYC Requirements',
              subtitle: 'KYC · P2P',
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
                      _KycHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _KycNotice(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      for (final tier in snapshot.tiers) ...[
                        _KycTierCard(
                          tier: tier,
                          onUpgrade: tier.status == P2PKycTierStatus.available
                              ? () {
                                  HapticFeedback.selectionClick();
                                  context.go(snapshot.verifyRouteFor(tier.id));
                                }
                              : null,
                        ),
                        if (tier != snapshot.tiers.last)
                          const SizedBox(height: AppSpacing.x4),
                      ],
                      const SizedBox(height: AppSpacing.x5),
                      _KycSupportCard(snapshot: snapshot),
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

class _KycHero extends StatelessWidget {
  const _KycHero({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.heroKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: AppColors.primary15,
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
                  snapshot.heroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _KycNotice extends StatelessWidget {
  const _KycNotice({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.noticeKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.noticeTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.noticeBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _KycTierCard extends StatelessWidget {
  const _KycTierCard({required this.tier, required this.onUpgrade});

  final P2PKycTierDraft tier;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(tier);
    return VitCard(
      key: P2PKycRequirementsPage.tierKey(tier.id),
      radius: VitCardRadius.lg,
      borderColor: tier.status == P2PKycTierStatus.current
          ? color
          : AppColors.cardBorder,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.x4),
            decoration: BoxDecoration(color: _tierHeaderBackground(tier)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(
                    _tierIcon(tier.iconKey),
                    color: Colors.white,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.x2,
                        runSpacing: AppSpacing.x2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Tier ${tier.id}',
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: color,
                              fontSize: 24,
                              height: 1.05,
                            ),
                          ),
                          VitStatusPill(
                            label: tier.badge,
                            status: _tierPillStatus(tier),
                            size: VitStatusPillSize.sm,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: AppColors.text3,
                            size: 12,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                          Flexible(
                            child: Text(
                              'Xác minh trong ${tier.verificationTime}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                _TierStatusBadge(tier: tier),
              ],
            ),
          ),
          _TierSection(
            title: 'Yêu cầu xác minh:',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final requirement in tier.requirements) ...[
                  _RequirementRow(requirement: requirement),
                  if (requirement != tier.requirements.last)
                    const SizedBox(height: AppSpacing.x3),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSolid),
          _TierSection(
            title: 'Giới hạn giao dịch:',
            child: _LimitsGrid(limits: tier.limits, color: color),
          ),
          const Divider(height: 1, color: AppColors.borderSolid),
          _TierSection(
            title: 'Quyền lợi:',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final benefit in tier.benefits) ...[
                  _BenefitRow(text: benefit, color: color),
                  if (benefit != tier.benefits.last)
                    const SizedBox(height: AppSpacing.x2),
                ],
              ],
            ),
          ),
          if (onUpgrade != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: VitCtaButton(
                key: P2PKycRequirementsPage.upgradeKey(tier.id),
                variant: tier.status == P2PKycTierStatus.available
                    ? VitCtaButtonVariant.primary
                    : VitCtaButtonVariant.secondary,
                height: 48,
                onPressed: onUpgrade,
                trailing: const Icon(Icons.arrow_forward_rounded),
                child: Text('Nâng cấp lên Tier ${tier.id}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _TierStatusBadge extends StatelessWidget {
  const _TierStatusBadge({required this.tier});

  final P2PKycTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return switch (tier.status) {
      P2PKycTierStatus.current => const VitStatusPill(
        label: 'Đang dùng',
        status: VitStatusPillStatus.success,
        icon: Icons.check_circle_outline_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.pending => const VitStatusPill(
        label: 'Đang xét duyệt',
        status: VitStatusPillStatus.warning,
        icon: Icons.schedule_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.locked => const VitStatusPill(
        label: 'Chưa mở',
        status: VitStatusPillStatus.neutral,
        icon: Icons.lock_outline_rounded,
        size: VitStatusPillSize.sm,
      ),
      P2PKycTierStatus.available => const SizedBox.shrink(),
    };
  }
}

class _TierSection extends StatelessWidget {
  const _TierSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          child,
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.requirement});

  final P2PKycRequirementDraft requirement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: AppRadii.smRadius,
          ),
          child: Icon(
            _requirementIcon(requirement.iconKey),
            color: AppColors.text2,
            size: 13,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            requirement.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}

class _LimitsGrid extends StatelessWidget {
  const _LimitsGrid({required this.limits, required this.color});

  final P2PKycLimitsDraft limits;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: AppSpacing.x4,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: _LimitMetric(
                  label: 'Mua/ngày',
                  value: '${_formatVnd(limits.dailyBuy)} VND',
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _LimitMetric(
                  label: 'Bán/ngày',
                  value: '${_formatVnd(limits.dailySell)} VND',
                  color: color,
                ),
              ),
            ],
          ),
        ),
        _LimitMetric(
          label: 'Tổng/tháng',
          value: '${_formatVnd(limits.monthlyVolume)} VND',
          color: color,
        ),
      ],
    );
  }
}

class _LimitMetric extends StatelessWidget {
  const _LimitMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: color,
            size: 14,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _KycSupportCard extends StatelessWidget {
  const _KycSupportCard({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.supportKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.supportRoute);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Liên hệ Support',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppModuleAccents.p2p,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconSm,
                      ),
                    ],
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

Color _tierColor(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

Color _tierHeaderBackground(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => AppColors.buy10,
    'warning' => AppColors.warn10,
    _ => AppColors.primary12,
  };
}

VitStatusPillStatus _tierPillStatus(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => VitStatusPillStatus.success,
    'warning' => VitStatusPillStatus.warning,
    _ => VitStatusPillStatus.info,
  };
}

IconData _tierIcon(String iconKey) {
  return switch (iconKey) {
    'badge' => Icons.verified_outlined,
    'star' => Icons.star_outline_rounded,
    _ => Icons.shield_outlined,
  };
}

IconData _requirementIcon(String iconKey) {
  return switch (iconKey) {
    'camera' => Icons.photo_camera_outlined,
    'check' => Icons.check_circle_outline_rounded,
    'video' => Icons.videocam_outlined,
    'shield' => Icons.verified_user_outlined,
    _ => Icons.description_outlined,
  };
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
