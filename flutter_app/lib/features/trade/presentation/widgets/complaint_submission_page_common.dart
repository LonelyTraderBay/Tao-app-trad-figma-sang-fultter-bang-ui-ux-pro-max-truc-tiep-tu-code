part of '../pages/complaint_submission_page.dart';

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter({required this.enabled, required this.onSubmit});

  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: _submissionFooterHeight,
      radius: VitCardRadius.standard,
      padding: AppSpacing.complaintSubmissionFooterPadding,
      borderColor: _submissionBorder.withValues(alpha: .35),
      child: VitCtaButton(
        key: ComplaintSubmissionPage.submitKey,
        onPressed: enabled ? onSubmit : null,
        variant: VitCtaButtonVariant.primary,
        leading: const Icon(Icons.chat_bubble_outline_rounded),
        child: const Text('Submit Complaint'),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.navLabel.copyWith(
        color: AppColors.text2,
        height: _submissionLineTight,
      ),
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
      accentColor: _submissionPrimary,
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
      density: VitDensity.compact,
      padding: padding,
      borderColor: _submissionBorder.withValues(alpha: .76),
      child: child,
    );
  }
}

final OutlineInputBorder _inputBorder = OutlineInputBorder(
  borderRadius: AppRadii.cardRadius,
  borderSide: BorderSide(color: _submissionBorder.withValues(alpha: .76)),
);
