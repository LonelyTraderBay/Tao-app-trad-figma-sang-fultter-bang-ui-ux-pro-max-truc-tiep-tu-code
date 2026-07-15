part of '../../pages/settings/bot_faq_page.dart';

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
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
      onPressed: () => _showComingSoon(context),
      padding: TradeSpacingTokens.tradeBotChipPadding,
      child: Text(label),
    );
  }

  void _showComingSoon(BuildContext context) {
    HapticFeedback.selectionClick();
    showVitNoticeSheet(
      context: context,
      title: label,
      message: '$label sẽ sớm ra mắt',
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
