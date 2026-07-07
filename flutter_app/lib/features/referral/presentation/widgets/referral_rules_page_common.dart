part of '../pages/referral_rules_page.dart';

class _TermsList extends StatelessWidget {
  const _TermsList({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.termsKey,
      padding: AppSpacing.referralCardPadding,
      child: Column(
        children: [
          for (var i = 0; i < snapshot.terms.length; i++) ...[
            Row(
              key: ReferralRulesPage.termKey(i),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: AppSpacing.x5,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: AppColors.surface2,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.xlRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                          height: AppSpacing.referralLineHeightTight,
                        ),
                      ),
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
              const SizedBox(height: AppSpacing.rowGap),
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
            const SizedBox(height: AppSpacing.rowGap),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: ReferralRulesPage.faqToggleKey(index),
              onTap: onTap,
              child: Padding(
                padding: AppSpacing.referralCardPadding,
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
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: AppSpacing.referralFaqAnswerPadding,
              child: Text(
                faq.answer,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
    return VitBanner(
      key: ReferralRulesPage.disclaimerKey,
      variant: VitBannerVariant.warning,
      icon: Icons.info_outline_rounded,
      message: 'Lưu ý chương trình',
      detail: snapshot.disclaimer,
    );
  }
}

String _formatUsd(double value) => '\$${value.toStringAsFixed(2)}';
