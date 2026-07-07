part of '../pages/bot_faq_page.dart';

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.categoryId,
    required this.index,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final String categoryId;
  final int index;
  final TradeBotFaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotFaqPage.questionKey(categoryId, index),
      borderColor: AppColors.cardBorder,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.tradeBotCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.help_outline_rounded,
                  color: _faqPrimary,
                  size: AppSpacing.tradeBotQuestionIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.tradeBotQuestionIconBox + AppSpacing.x3,
                0,
                AppSpacing.x3,
                AppSpacing.x3,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadii.smRadius,
                ),
                child: Padding(
                  padding: AppSpacing.tradeBotInnerPanelPadding,
                  child: Text(
                    item.answer,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCompactCardPadding,
      borderColor: _faqPrimary.withValues(alpha: .25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Still need help?',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            "Can't find your answer? Our support team is here to help 24/7.",
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HelpButton(
                  label: 'Live Chat',
                  variant: VitCtaButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Expanded(
                child: _HelpButton(
                  label: 'Contact Support',
                  variant: VitCtaButtonVariant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.label, required this.variant});

  final String label;
  final VitCtaButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      height: AppSpacing.buttonCompact,
      variant: variant,
      onPressed: () {},
      padding: AppSpacing.tradeBotChipPadding,
      child: Text(label),
    );
  }
}

class _EmptyFaqs extends StatelessWidget {
  const _EmptyFaqs();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'No FAQs found',
      icon: Icons.help_outline_rounded,
    );
  }
}
