import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

const _ombudsmanBackground = AppColors.bg;
const _ombudsmanBorder = AppColors.borderSolid;
const _ombudsmanPrimary = AppColors.primary;
const _ombudsmanGreen = AppColors.buy;
const _ombudsmanAmber = AppColors.caution;
const double _ombudsmanFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _ombudsmanNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _ombudsmanIntroIconExtent =
    AppSpacing.buttonCompact + AppSpacing.x4;
const double _ombudsmanContactIconExtent =
    AppSpacing.buttonCompact + AppSpacing.x1;
const double _ombudsmanStepMarkerExtent = AppSpacing.buttonCompact;

class OmbudsmanReferralPage extends ConsumerWidget {
  const OmbudsmanReferralPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc114_ombudsman_content');
  static const ctaKey = Key('sc114_ombudsman_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getOmbudsmanReferral();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _ombudsmanFramedScrollClearance
            : _ombudsmanNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-114 OmbudsmanReferralPage',
      child: Material(
        color: _ombudsmanBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Financial Ombudsman',
            subtitle: 'Independent Dispute Resolution',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyComplaintsHandling),
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Review ombudsman referral route',
                  message:
                      'Confirm complaint deadline, eligibility, evidence, and next steps before external escalation.',
                ),
                _IntroCard(snapshot: snapshot),
                const VitSectionHeader(
                  title: 'When Can You Refer?',
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _ombudsmanPrimary,
                ),
                _EligibilityCard(items: snapshot.eligibility),
                const VitSectionHeader(
                  title: 'Contact Information',
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _ombudsmanPrimary,
                ),
                _ContactCard(contacts: snapshot.contacts),
                const VitSectionHeader(
                  title: 'How It Works',
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _ombudsmanPrimary,
                ),
                for (final step in snapshot.processSteps)
                  _ProcessStepCard(step: step),
                _VisitButton(snapshot: snapshot),
                const TradeBodyReviewSection(
                  title: 'Ombudsman body review',
                  message: 'Ombudsman referral body reviewed',
                  detail:
                      'Eligibility, contact, process, visit CTA, empty, and result states stay visible.',
                  primary:
                      'Eligibility remains above external referral actions.',
                  secondary:
                      'Contact and process steps stay separated for regulated escalation.',
                  tertiary:
                      'Visit CTA remains framed as external dispute resolution.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.snapshot});

  final TradeOmbudsmanReferralSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintCaseCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: _ombudsmanIntroIconExtent,
            height: _ombudsmanIntroIconExtent,
            variant: VitCardVariant.ghost,
            borderColor: _ombudsmanGreen.withValues(alpha: .24),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_outlined,
              color: _ombudsmanGreen,
              size: AppSpacing.iconMd + AppSpacing.x3,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Padding(
              padding: AppSpacing.complaintCaseTitleNudgePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    snapshot.infoDescription,
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.text3,
                    ),
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

class _EligibilityCard extends StatelessWidget {
  const _EligibilityCard({required this.items});

  final List<TradeOmbudsmanEligibility> items;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.ombudsmanEligibilityPadding,
      child: Column(
        children: [
          for (final item in items) ...[
            _EligibilityRow(item: item),
            if (item != items.last) const SizedBox(height: AppSpacing.rowPy),
          ],
        ],
      ),
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({required this.item});

  final TradeOmbudsmanEligibility item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppSpacing.complaintCaseIconNudgePadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: _ombudsmanGreen,
            size: AppSpacing.inputPrefixIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contacts});

  final List<TradeOmbudsmanContact> contacts;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintCaseCardPadding,
      child: Column(
        children: [
          for (final contact in contacts) ...[
            _ContactRow(contact: contact),
            if (contact != contacts.last)
              const SizedBox(height: AppSpacing.sectionGapCompact),
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final TradeOmbudsmanContact contact;

  @override
  Widget build(BuildContext context) {
    final color = switch (contact.icon) {
      TradeOmbudsmanContactIcon.phone => _ombudsmanPrimary,
      TradeOmbudsmanContactIcon.website => _ombudsmanGreen,
      TradeOmbudsmanContactIcon.address => _ombudsmanAmber,
    };
    final icon = switch (contact.icon) {
      TradeOmbudsmanContactIcon.phone => Icons.phone_outlined,
      TradeOmbudsmanContactIcon.website => Icons.open_in_new_rounded,
      TradeOmbudsmanContactIcon.address => Icons.description_outlined,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitCard(
          width: _ombudsmanContactIconExtent,
          height: _ombudsmanContactIconExtent,
          variant: VitCardVariant.ghost,
          borderColor: color.withValues(alpha: .24),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: AppSpacing.inputPrefixIcon),
        ),
        const SizedBox(width: AppSpacing.rowPy),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                contact.value,
                style:
                    (contact.icon == TradeOmbudsmanContactIcon.address
                            ? AppTextStyles.monoCode
                            : AppTextStyles.base)
                        .copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
              ),
              if (contact.detail != null) ...[
                const SizedBox(height: AppSpacing.x2),
                Text(
                  contact.detail!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProcessStepCard extends StatelessWidget {
  const _ProcessStepCard({required this.step});

  final TradeOmbudsmanProcessStep step;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.ombudsmanProcessPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: _ombudsmanStepMarkerExtent,
            height: _ombudsmanStepMarkerExtent,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.caption.copyWith(
                color: _ombudsmanPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Padding(
              padding: AppSpacing.complaintCaseIconNudgePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    step.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

class _VisitButton extends StatelessWidget {
  const _VisitButton({required this.snapshot});

  final TradeOmbudsmanReferralSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: OmbudsmanReferralPage.ctaKey,
      onPressed: () {},
      leading: const Icon(
        Icons.open_in_new_rounded,
        size: AppSpacing.complaintCaseTrailingIcon,
      ),
      child: Text(
        snapshot.ctaLabel,
        style: AppTextStyles.control.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _ombudsmanBorder.withValues(alpha: .76),
      child: child,
    );
  }
}
