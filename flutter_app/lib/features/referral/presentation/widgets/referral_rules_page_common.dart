part of '../pages/referral_rules_page.dart';

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
                      height: AppSpacing.referralLineHeightTight,
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
              const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
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
            const Padding(padding: EdgeInsets.only(top: AppSpacing.x3)),
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
