import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';

class ReferralRulesPage extends ConsumerStatefulWidget {
  const ReferralRulesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc288_referral_rules_content');
  static const tierTableKey = Key('sc288_tier_table');
  static const rewardTypesKey = Key('sc288_reward_types');
  static const termsKey = Key('sc288_terms');
  static const faqKey = Key('sc288_faq');
  static const disclaimerKey = Key('sc288_disclaimer');

  static Key tierKey(String id) => Key('sc288_tier_$id');
  static Key rewardTypeKey(String id) => Key('sc288_reward_type_$id');
  static Key termKey(int index) => Key('sc288_term_$index');
  static Key faqToggleKey(int index) => Key('sc288_faq_toggle_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralRulesPage> createState() => _ReferralRulesPageState();
}

class _ReferralRulesPageState extends ConsumerState<ReferralRulesPage> {
  int? _openFaqIndex = 0;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(referralControllerProvider).getRules();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-288 ReferralRulesPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ReferralRulesPage.contentKey,
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
                      const _SectionTitle(
                        title: 'Hệ thống hạng',
                        subtitle: 'Mời càng nhiều, thưởng càng lớn',
                        color: AppColors.warn,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _TierTable(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      const _SectionTitle(
                        title: 'Các loại thưởng',
                        color: AppModuleAccents.trade,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _RewardTypes(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      const _SectionTitle(
                        title: 'Điều khoản chương trình',
                        color: AppColors.text2,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _TermsList(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      const _SectionTitle(
                        title: 'Câu hỏi thường gặp',
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _FaqList(
                        snapshot: snapshot,
                        openIndex: _openFaqIndex,
                        onToggle: (index) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _openFaqIndex = _openFaqIndex == index
                                ? null
                                : index;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _Disclaimer(snapshot: snapshot),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.color,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.x1,
          height: subtitle == null ? AppSpacing.x5 : AppSpacing.x6,
          margin: const EdgeInsets.only(top: AppSpacing.x1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.tierTableKey,
      clip: true,
      child: Column(
        children: [
          const _TierHeader(),
          for (var i = 0; i < snapshot.tiers.length; i++) ...[
            _TierRow(
              tier: snapshot.tiers[i],
              current: i == snapshot.currentTierIndex,
            ),
            if (i < snapshot.tiers.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.surface2),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Hạng',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Bạn bè',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Hoa hồng',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Thưởng KYC',
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.current});

  final ReferralTierRuleDraft tier;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tier.id) {
      'bronze' => Icons.workspace_premium_rounded,
      'silver' => Icons.workspace_premium_rounded,
      'gold' => Icons.military_tech_rounded,
      'diamond' => Icons.diamond_rounded,
      _ => Icons.auto_awesome_rounded,
    };

    return Container(
      key: ReferralRulesPage.tierKey(tier.id),
      color: current ? AppColors.primary08 : AppColors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: current ? AppColors.primary : AppColors.text2,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: current ? AppColors.primary : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        tier.nameEn,
                        style: AppTextStyles.micro.copyWith(
                          color: current ? AppColors.primary : AppColors.text3,
                        ),
                      ),
                      if (current)
                        Text(
                          'Hiện tại',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tier.minFriends == 0 ? '0' : '≥ ${tier.minFriends}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${tier.commissionPercent}%',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatUsd(tier.kycBonus),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardTypes extends StatelessWidget {
  const _RewardTypes({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralRulesPage.rewardTypesKey,
      children: [
        for (var i = 0; i < snapshot.rewardTypes.length; i++) ...[
          _RewardTypeCard(rule: snapshot.rewardTypes[i]),
          if (i < snapshot.rewardTypes.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RewardTypeCard extends StatelessWidget {
  const _RewardTypeCard({required this.rule});

  final ReferralRewardTypeRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final isKyc = rule.id == 'kyc_bonus';
    final color = isKyc ? AppColors.primary : AppColors.buy;
    return VitCard(
      key: ReferralRulesPage.rewardTypeKey(rule.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.iconLg + AppSpacing.x3,
            height: AppSpacing.iconLg + AppSpacing.x3,
            decoration: BoxDecoration(
              color: isKyc ? AppColors.primary12 : AppColors.buy10,
              borderRadius: AppRadii.mdRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              isKyc ? Icons.card_giftcard_rounded : Icons.trending_up_rounded,
              color: color,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.body,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x3),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isKyc ? AppColors.primary12 : AppColors.buy10,
                    borderRadius: AppRadii.xlRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x3,
                      vertical: AppSpacing.x2,
                    ),
                    child: Text(
                      rule.highlight,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
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

class _TermsList extends StatelessWidget {
  const _TermsList({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.termsKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (var i = 0; i < snapshot.terms.length; i++) ...[
            Row(
              key: ReferralRulesPage.termKey(i),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.x5,
                  height: AppSpacing.x5,
                  decoration: const BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.xlRadius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    snapshot.terms[i],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (i < snapshot.terms.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.snapshot,
    required this.openIndex,
    required this.onToggle,
  });

  final ReferralRulesSnapshot snapshot;
  final int? openIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralRulesPage.faqKey,
      children: [
        for (var i = 0; i < snapshot.faqs.length; i++) ...[
          _FaqCard(
            faq: snapshot.faqs[i],
            open: openIndex == i,
            onTap: () => onToggle(i),
            index: i,
          ),
          if (i < snapshot.faqs.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.faq,
    required this.open,
    required this.onTap,
    required this.index,
  });

  final ReferralFaqDraft faq;
  final bool open;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          InkWell(
            key: ReferralRulesPage.faqToggleKey(index),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.accent,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      faq.question,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Icon(
                    open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Text(
                  faq.answer,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ),
            crossFadeState: open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.disclaimerKey,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.disclaimer,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatUsd(double value) => '\$${value.toStringAsFixed(2)}';
