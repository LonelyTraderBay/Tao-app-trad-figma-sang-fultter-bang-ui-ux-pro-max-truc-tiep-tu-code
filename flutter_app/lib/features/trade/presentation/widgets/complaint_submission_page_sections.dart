part of '../pages/complaint_submission_page.dart';

class _ProcessNotice extends StatelessWidget {
  const _ProcessNotice({required this.snapshot});

  final TradeComplaintSubmissionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.complaintSubmissionNoticePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.processTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _submissionLineTight,
                  ),
                ),
                const SizedBox(height: _submissionSpace),
                Text(
                  snapshot.processDescription,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _submissionLineBody,
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

class _CategoryField extends StatelessWidget {
  const _CategoryField({
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  final String? value;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Category *'),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        PopupMenuButton<String>(
          color: _submissionPanel,
          elevation: 8,
          onSelected: onChanged,
          padding: AppSpacing.zeroInsets,
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          itemBuilder: (_) => [
            for (final category in categories)
              PopupMenuItem(
                value: category,
                child: Text(
                  category,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    height: _submissionLineShort,
                  ),
                ),
              ),
          ],
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          child: VitCard(
            key: ComplaintSubmissionPage.categoryKey,
            height: _submissionCategoryHeight,
            variant: VitCardVariant.inner,
            padding: AppSpacing.complaintSubmissionCategoryPadding,
            density: VitDensity.compact,
            borderColor: _submissionBorder.withValues(alpha: .76),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'Select category',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      height: _submissionLineTight,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text1,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TextInputBlock extends StatelessWidget {
  const _TextInputBlock({
    required this.label,
    required this.controller,
    required this.hint,
    required this.maxLength,
    required this.minLength,
    required this.onChanged,
    this.multiline = false,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int minLength;
  final ValueChanged<String> onChanged;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: _submissionSpace),
        if (!multiline)
          VitInput(
            controller: controller,
            fieldKey: ComplaintSubmissionPage.subjectKey,
            hintText: hint,
            inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
            onChanged: onChanged,
          )
        else
          SizedBox(
            height: _submissionMultilineHeight,
            child: TextField(
              key: multiline
                  ? ComplaintSubmissionPage.descriptionKey
                  : ComplaintSubmissionPage.subjectKey,
              controller: controller,
              onChanged: onChanged,
              maxLength: maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLines: multiline ? null : 1,
              expands: multiline,
              textAlignVertical: multiline
                  ? TextAlignVertical.top
                  : TextAlignVertical.center,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                height: multiline ? _submissionLineBody : _submissionLineTight,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: hint,
                hintMaxLines: multiline ? 3 : 1,
                hintStyle: AppTextStyles.base.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                  height: multiline
                      ? _submissionLineHint
                      : _submissionLineTight,
                ),
                filled: true,
                fillColor: _submissionPanel2,
                contentPadding: multiline
                    ? AppSpacing.complaintSubmissionMultilineContentPadding
                    : AppSpacing.complaintSubmissionSingleLineContentPadding,
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          '${controller.text.length}/$maxLength characters (min $minLength)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _submissionLineTight,
          ),
        ),
      ],
    );
  }
}

class _EvidenceUploadCard extends StatelessWidget {
  const _EvidenceUploadCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: AppSpacing.complaintSubmissionEvidencePadding,
      child: SizedBox(
        height: _submissionEvidenceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            const VitCard(
              width: _submissionEvidenceIconSize,
              height: _submissionEvidenceIconSize,
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              alignment: Alignment.center,
              child: Icon(
                Icons.upload_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: _submissionLineTight,
              ),
            ),
            const SizedBox(height: _submissionSmallSpace),
            Text(
              'Screenshots, emails, or other supporting documents',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _submissionLineTight,
              ),
            ),
            const SizedBox(height: _submissionCardSpace),
            const VitAccentPill(
              label: 'Choose Files',
              accentColor: AppColors.text1,
              size: VitStatusPillSize.md,
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({
    required this.snapshot,
    required this.accepted,
    required this.onChanged,
  });

  final TradeComplaintSubmissionSnapshot snapshot;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ComplaintSubmissionPage.acceptKey,
      onTap: () => onChanged(!accepted),
      density: VitDensity.compact,
      padding: AppSpacing.complaintSubmissionTermsPadding,
      borderColor: _submissionBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _submissionCheckboxSize,
            height: _submissionCheckboxSize,
            child: Checkbox(
              value: accepted,
              onChanged: (value) => onChanged(value ?? false),
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: AppColors.text3),
              activeColor: _submissionPrimary,
            ),
          ),
          const SizedBox(width: _submissionCardSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.termsIntro,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    height: _submissionLineReadable,
                  ),
                ),
                const SizedBox(height: _submissionSpace),
                for (final term in snapshot.terms)
                  Text(
                    '- $term',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _submissionLineLong,
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
