part of '../pages/complaint_submission_page.dart';

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter({required this.enabled, required this.onSubmit});

  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 3),
      decoration: BoxDecoration(
        color: _submissionBackground.withValues(alpha: .94),
        border: Border(
          top: BorderSide(color: _submissionBorder.withValues(alpha: .35)),
        ),
      ),
      child: SizedBox(
        height: AppSpacing.inputHeight,
        child: FilledButton(
          key: ComplaintSubmissionPage.submitKey,
          style: FilledButton.styleFrom(
            backgroundColor: enabled ? _submissionPrimary : _submissionPanel2,
            foregroundColor: enabled ? AppColors.onAccent : AppColors.text3,
            disabledBackgroundColor: _submissionPanel2,
            disabledForegroundColor: AppColors.text3,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
          ),
          onPressed: enabled ? onSubmit : null,
          child: Opacity(
            opacity: enabled ? 1 : .52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                const SizedBox(width: 9),
                Text(
                  'Submit Complaint',
                  style: AppTextStyles.caption.copyWith(
                    color: enabled ? AppColors.onAccent : AppColors.text3,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
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
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontSize: 11,
        height: 1,
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
          height: 15,
          decoration: BoxDecoration(
            color: _submissionPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
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
        color: _submissionPanel,
        border: Border.all(color: _submissionBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

final OutlineInputBorder _inputBorder = OutlineInputBorder(
  borderRadius: AppRadii.cardRadius,
  borderSide: BorderSide(color: _submissionBorder.withValues(alpha: .76)),
);
