part of '../pages/investor_compensation_page.dart';

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: _compAmber.withValues(alpha: .13),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _compAmber, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _compAmber,
                fontWeight: AppTextStyles.bold,
                height: 1.3,
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
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _EligibilityHeading('Eligible Customers:'),
              const SizedBox(height: 10),
              for (final item in snapshot.eligibleCustomers) ...[
                _Bullet(text: item, color: _compGreen),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 6),
              const _EligibilityHeading('Not Eligible:'),
              const SizedBox(height: 10),
              for (final item in snapshot.ineligibleCustomers) ...[
                _Bullet(text: item, color: _compRed),
                if (item != snapshot.ineligibleCustomers.last)
                  const SizedBox(height: 8),
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
        const SizedBox(height: 12),
        for (final step in snapshot.claimSteps) ...[
          _ClaimStep(step: step),
          if (step != snapshot.claimSteps.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: Text(
              'Visit FSCS Website',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
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
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _compPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.smRadius,
            ),
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.baseMedium.copyWith(
                color: _compPrimary,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
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
        height: 1,
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
          size: 13,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
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
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        key: InvestorCompensationPage.faqKey,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          side: BorderSide(color: _compBorder.withValues(alpha: .72)),
          backgroundColor: _compPanel2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        onPressed: () {},
        child: Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: _compPrimary,
              size: 16,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'FSCS FAQs',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _compPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
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
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _compPanel,
        border: Border.all(color: _compBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}
