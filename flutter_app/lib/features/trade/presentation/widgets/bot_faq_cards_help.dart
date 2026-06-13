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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: _faqPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,

                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _faqPanel2,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  item.answer,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.65,
                  ),
                ),
              ),
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
        const SizedBox(width: 13),
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
      height: 86,
      alignment: Alignment.center,
      borderColor: AppColors.cardBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: _faqPrimary.withValues(alpha: .25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Still need help?',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Can't find your answer? Our support team is here to help 24/7.",
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _HelpButton(
                  label: 'Live Chat',
                  background: _faqPanel2,
                  foreground: AppColors.text1,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _HelpButton(
                  label: 'Contact Support',
                  background: _faqPrimary,
                  foreground: AppColors.onAccent,
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
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: foreground,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyFaqs extends StatelessWidget {
  const _EmptyFaqs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: AppColors.text3,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No FAQs found',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
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
            color: _faqPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
