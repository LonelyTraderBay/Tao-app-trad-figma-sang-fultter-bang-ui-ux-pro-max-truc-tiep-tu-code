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
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Padding(
              padding: AppSpacing.tradeBotCardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    color: _faqPrimary,
                    size: AppSpacing.tradeBotQuestionIcon,
                  ),
                  const SizedBox(width: AppSpacing.tradeBotCardIconGap),
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
                  const SizedBox(width: AppSpacing.tradeBotRowGap),
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
          ),
          if (expanded)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width:
                      AppSpacing.tradeBotQuestionIconBox +
                      AppSpacing.tradeBotCardIconGap,
                ),
                Expanded(
                  child: VitCard(
                    variant: VitCardVariant.inner,
                    padding: AppSpacing.tradeBotInnerPanelPadding,
                    child: Text(
                      item.answer,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeBotCardGap),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.totalFaqs, required this.categories});

  final int totalFaqs;
  final int categories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Total FAQs', value: totalFaqs.toString()),
        ),
        const SizedBox(width: AppSpacing.tradeBotCardIconGap),
        Expanded(
          child: _StatCard(label: 'Categories', value: categories.toString()),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotControlTall,
      ),
      alignment: Alignment.center,
      borderColor: AppColors.cardBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
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
      padding: AppSpacing.tradeBotCardPaddingLoose,
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
          const SizedBox(height: AppSpacing.tradeBotCardGap),
          Text(
            "Can't find your answer? Our support team is here to help 24/7.",
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.tradeBotRowGap),
          Row(
            children: [
              Expanded(
                child: _HelpButton(
                  label: 'Live Chat',
                  variant: VitCtaButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.tradeBotSmallGap),
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
  const _HelpButton({
    required this.label,
    required this.variant,
  });

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
