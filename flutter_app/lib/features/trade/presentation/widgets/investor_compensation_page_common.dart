part of '../pages/investor_compensation_page.dart';

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCompactCardPadding,
      variant: VitCardVariant.ghost,
      borderColor: _compAmber.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _compAmber,
            size: AppSpacing.statusPillIconSizeLg,
          ),
          const SizedBox(width: AppSpacing.tradeBotSmallGap),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _compAmber,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.tradeBotLineHeightBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eligibility extends StatelessWidget {
  const _Eligibility({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Who Is Eligible?'),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _Card(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _EligibilityHeading('Eligible Customers:'),
              const SizedBox(height: AppSpacing.tradeBotRowGap),
              for (final item in snapshot.eligibleCustomers) ...[
                _Bullet(text: item, color: _compGreen),
                const SizedBox(height: AppSpacing.tradeBotSmallGap),
              ],
              const SizedBox(height: AppSpacing.formFieldLabelGap),
              const _EligibilityHeading('Not Eligible:'),
              const SizedBox(height: AppSpacing.tradeBotRowGap),
              for (final item in snapshot.ineligibleCustomers) ...[
                _Bullet(text: item, color: _compRed),
                if (item != snapshot.ineligibleCustomers.last)
                  const SizedBox(height: AppSpacing.tradeBotSmallGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ClaimGuide extends StatelessWidget {
  const _ClaimGuide({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('How to Make a Claim'),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        for (final step in snapshot.claimSteps) ...[
          _ClaimStep(step: step),
          if (step != snapshot.claimSteps.last)
            const SizedBox(height: AppSpacing.tradeBotCardGap),
        ],
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        VitCtaButton(
          height: AppSpacing.searchBarCompactHeight,
          onPressed: () {},
          leading: const Icon(Icons.open_in_new_rounded),
          child: const Text('Visit FSCS Website'),
        ),
      ],
    );
  }
}

class _ClaimStep extends StatelessWidget {
  const _ClaimStep({required this.step});

  final TradeInvestorCompensationClaimStep step;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.tradeBotAttributionPanelPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitCard(
            width: AppSpacing.statusPillHeightLg,
            height: AppSpacing.statusPillHeightLg,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.sm,
            borderColor: _compPrimary.withValues(alpha: .24),
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.baseMedium.copyWith(
                color: _compPrimary,
                height: AppSpacing.tradeBotLineHeightTight,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.formFieldLabelGap),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightBody,
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

class _EligibilityHeading extends StatelessWidget {
  const _EligibilityHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
        height: AppSpacing.tradeBotLineHeightTight,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          color == _compGreen
              ? Icons.check_circle_outline
              : Icons.error_outline_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.tradeBotSmallGap),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.tradeBotLineHeightBody,
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqButton extends StatelessWidget {
  const _FaqButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: InvestorCompensationPage.faqKey,
      height: AppSpacing.searchBarCompactHeight,
      variant: VitCtaButtonVariant.secondary,
      onPressed: () {},
      leading: const Icon(Icons.help_outline_rounded),
      trailing: const Icon(Icons.chevron_right_rounded),
      child: const Text('FSCS FAQs'),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: text,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _compPrimary,
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
      borderColor: _compBorder.withValues(alpha: .72),
      child: child,
    );
  }
}
