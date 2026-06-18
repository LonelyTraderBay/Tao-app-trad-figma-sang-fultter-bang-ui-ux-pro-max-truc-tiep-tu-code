part of '../pages/dispute_resolution_page.dart';

class _FileComplaintTab extends StatelessWidget {
  const _FileComplaintTab({
    required this.snapshot,
    required this.selectedType,
    required this.selectedProviderId,
    required this.subjectController,
    required this.descriptionController,
    required this.evidenceAttached,
    required this.onTypeChanged,
    required this.onProviderChanged,
    required this.onUpload,
  });

  final TradeDisputeResolutionSnapshot snapshot;
  final String? selectedType;
  final String? selectedProviderId;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final bool evidenceAttached;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String?> onProviderChanged;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final uploadTopGap = DeviceMetrics.height > 956
        ? AppSpacing.tradeBotDisputeUploadTallGap
        : AppSpacing.tradeBotDisputeUploadCompactGap;

    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      customGap: AppSpacing.tradeBotCardGap,
      children: [
        _NoticeCard(title: snapshot.noticeTitle, body: snapshot.noticeBody),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Review dispute complaint',
          message:
              'Confirm complaint type, provider, evidence, and issue details before submitting a formal dispute case.',
          contractId: 'Copy trading dispute intake',
        ),
        VitPageSection(
          label: 'Complaint Type',
          customGap: AppSpacing.tradeBotRowGap,
          children: [
            for (final type in snapshot.complaintTypes)
              _ComplaintTypeCard(
                option: type,
                selected: selectedType == type.value,
                onPressed: () => onTypeChanged(type.value),
              ),
          ],
        ),
        VitPageSection(
          label: 'Provider',
          children: [
            _ProviderSelect(
              providers: snapshot.providers,
              selectedProviderId: selectedProviderId,
              onChanged: onProviderChanged,
            ),
          ],
        ),
        VitPageSection(
          label: 'Details',
          customGap: AppSpacing.tradeBotLabelGap,
          children: [
            const _FieldLabel('Subject'),
            _TextFieldShell(
              key: DisputeResolutionPage.subjectKey,
              controller: subjectController,
              hint: 'Brief summary of the issue',
            ),
            const Padding(
              padding: AppSpacing.tradeBotDisputeDescriptionLabelPadding,
              child: _FieldLabel('Description'),
            ),
            _TextFieldShell(
              key: DisputeResolutionPage.descriptionKey,
              controller: descriptionController,
              hint:
                  'Describe the issue in detail. Include dates, trade IDs, amounts, etc.',
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),
        Padding(
          padding: AppSpacing.tradeBotDisputeUploadPadding(uploadTopGap),
          child: _UploadEvidenceButton(
            attached: evidenceAttached,
            onPressed: onUpload,
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      constraints: const BoxConstraints(minHeight: 74),
      padding: AppSpacing.tradeBotDisputeNoticePadding,
      borderColor: _disputePrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _disputePrimary,
            size: AppSpacing.tradeBotSmallIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotSmallGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputePrimary,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightCaption,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotNarrowIconGap),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputePrimary,
                    height: AppSpacing.tradeBotLineHeightMedium,
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

class _ComplaintTypeCard extends StatelessWidget {
  const _ComplaintTypeCard({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final TradeComplaintTypeOption option;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DisputeResolutionPage.complaintTypeKey(option.value),
      variant: VitCardVariant.inner,
      height: AppSpacing.tradeBotDisputeComplaintHeight,
      padding: AppSpacing.tradeBotDisputeComplaintPadding,
      borderColor: selected ? _disputePrimary : _disputeFieldBorder,
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? _disputePrimary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotSmallGap),
          Text(
            option.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? _disputePrimary : AppColors.text3,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSelect extends StatelessWidget {
  const _ProviderSelect({
    required this.providers,
    required this.selectedProviderId,
    required this.onChanged,
  });

  final List<TradeDisputeProviderOption> providers;
  final String? selectedProviderId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DisputeResolutionPage.providerKey,
      variant: VitCardVariant.inner,
      borderColor: _disputeFieldBorder,
      height: AppSpacing.tradeBotDisputeProviderHeight,
      padding: AppSpacing.tradeBotDisputeProviderPadding,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProviderId,
          dropdownColor: _disputeField,
          borderRadius: AppRadii.cardRadius,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: AppSpacing.tradeBotDisputeDropdownIcon,
          ),
          hint: Text(
            'Select provider...',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            height: AppSpacing.tradeBotLineHeightTight,
          ),
          items: [
            for (final provider in providers)
              DropdownMenuItem<String>(
                value: provider.id,
                child: Text(provider.name),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TextFieldShell extends StatelessWidget {
  const _TextFieldShell({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (minLines == 1 && maxLines == 1) {
      return VitInput(
        controller: controller,
        hintText: hint,
        textInputAction: TextInputAction.next,
      );
    }

    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: _disputePrimary,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        height: AppSpacing.tradeBotLineHeightCaption,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.tradeBotLineHeightCaption,
        ),
        filled: true,
        fillColor: _disputeField,
        contentPadding: AppSpacing.tradeBotDisputeTextFieldPadding,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: const BorderSide(color: _disputeFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.cardRadius,
          borderSide: const BorderSide(color: _disputePrimary, width: 1.5),
        ),
      ),
    );
  }
}

class _UploadEvidenceButton extends StatelessWidget {
  const _UploadEvidenceButton({
    required this.attached,
    required this.onPressed,
  });

  final bool attached;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DisputeResolutionPage.uploadKey,
      onPressed: onPressed,
      variant: attached
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.tradeBotDisputeEvidenceHeight,
      leading: Icon(
        attached ? Icons.check_circle_outline_rounded : Icons.upload_rounded,
      ),
      child: Text(
        attached ? 'Evidence attached' : 'Upload Evidence (Optional)',
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DisputeResolutionPage.submitKey,
      onPressed: enabled ? onPressed : null,
      height: AppSpacing.tradeBotSheetActionHeight,
      leading: const Icon(Icons.send_outlined),
      child: const Text('Submit Complaint'),
    );
  }
}
