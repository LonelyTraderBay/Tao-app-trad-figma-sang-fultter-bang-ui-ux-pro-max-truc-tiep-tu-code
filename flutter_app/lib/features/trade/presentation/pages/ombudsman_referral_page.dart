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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

const _ombudsmanBackground = AppColors.bg;
const _ombudsmanPanel2 = AppColors.surface3;
const _ombudsmanBorder = AppColors.borderSolid;
const _ombudsmanPrimary = AppColors.primary;
const _ombudsmanGreen = AppColors.buy;
const _ombudsmanAmber = AppColors.caution;

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 38
            : DeviceMetrics.nativeBottomChrome + 24) +
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 12,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review ombudsman referral route',
                        message:
                            'Confirm complaint deadline, eligibility, evidence, and next steps before external escalation.',
                      ),
                      _IntroCard(snapshot: snapshot),
                      const _SectionLabel('When Can You Refer?'),
                      _EligibilityCard(items: snapshot.eligibility),
                      const _SectionLabel('Contact Information'),
                      _ContactCard(contacts: snapshot.contacts),
                      const _SectionLabel('How It Works'),
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
            ],
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _ombudsmanGreen.withValues(alpha: .14),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _ombudsmanGreen,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontSize: 16,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    snapshot.infoDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1.4,
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
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      child: Column(
        children: [
          for (final item in items) ...[
            _EligibilityRow(item: item),
            if (item != items.last) const SizedBox(height: 14),
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
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: _ombudsmanGreen,
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.25,
                ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          for (final contact in contacts) ...[
            _ContactRow(contact: contact),
            if (contact != contacts.last) const SizedBox(height: 15),
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
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                contact.value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: contact.icon == TradeOmbudsmanContactIcon.address
                      ? 11
                      : 13,
                  fontWeight: contact.icon == TradeOmbudsmanContactIcon.address
                      ? AppTextStyles.normal
                      : AppTextStyles.bold,
                  height: contact.icon == TradeOmbudsmanContactIcon.address
                      ? 1.4
                      : 1.1,
                ),
              ),
              if (contact.detail != null) ...[
                const SizedBox(height: 5),
                Text(
                  contact.detail!,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1.2,
                  ),
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
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _ombudsmanPanel2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Text(
              '${step.step}',
              style: AppTextStyles.caption.copyWith(
                color: _ombudsmanPrimary,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    step.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.1,
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

class _VisitButton extends StatelessWidget {
  const _VisitButton({required this.snapshot});

  final TradeOmbudsmanReferralSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: OmbudsmanReferralPage.ctaKey,
      onPressed: () {},
      leading: const Icon(Icons.open_in_new_rounded, size: 18),
      child: Text(
        snapshot.ctaLabel,
        style: AppTextStyles.body.copyWith(
          color: AppColors.onAccent,
          fontFamily: 'Roboto',
          fontSize: 14,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _ombudsmanPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
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
