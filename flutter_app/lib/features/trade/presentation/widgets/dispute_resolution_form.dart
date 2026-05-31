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
    final uploadTopGap = DeviceMetrics.height > 956 ? 82.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoticeCard(title: snapshot.noticeTitle, body: snapshot.noticeBody),
        const SizedBox(height: 26),
        const _SectionLabel('Complaint Type'),
        const SizedBox(height: 9),
        for (final type in snapshot.complaintTypes) ...[
          _ComplaintTypeCard(
            option: type,
            selected: selectedType == type.value,
            onPressed: () => onTypeChanged(type.value),
          ),
          if (type != snapshot.complaintTypes.last) const SizedBox(height: 10),
        ],
        const SizedBox(height: 25),
        const _SectionLabel('Provider'),
        const SizedBox(height: 10),
        _ProviderSelect(
          providers: snapshot.providers,
          selectedProviderId: selectedProviderId,
          onChanged: onProviderChanged,
        ),
        const SizedBox(height: 25),
        const _SectionLabel('Details'),
        const SizedBox(height: 9),
        _FieldLabel('Subject'),
        const SizedBox(height: 7),
        _TextFieldShell(
          key: DisputeResolutionPage.subjectKey,
          controller: subjectController,
          hint: 'Brief summary of the issue',
        ),
        const SizedBox(height: 15),
        _FieldLabel('Description'),
        const SizedBox(height: 7),
        _TextFieldShell(
          key: DisputeResolutionPage.descriptionKey,
          controller: descriptionController,
          hint:
              'Describe the issue in detail. Include dates, trade IDs, amounts, etc.',
          minLines: 3,
          maxLines: 5,
        ),
        SizedBox(height: uploadTopGap),
        _UploadEvidenceButton(attached: evidenceAttached, onPressed: onUpload),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: _disputePrimary.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _disputePrimary, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _disputePrimary,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputePrimary,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(
                    color: _disputePrimary,
                    fontSize: 10.5,
                    height: 1.4,
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
    return InkWell(
      key: DisputeResolutionPage.complaintTypeKey(option.value),
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 62,
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
        decoration: BoxDecoration(
          color: selected
              ? _disputePrimary.withValues(alpha: .13)
              : _disputeField,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: selected ? _disputePrimary : _disputeFieldBorder,
            width: selected ? 2 : 1.5,
          ),
        ),
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
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              option.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: selected ? _disputePrimary : AppColors.text3,
                fontSize: 10,
                height: 1,
              ),
            ),
          ],
        ),
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
    return Container(
      key: DisputeResolutionPage.providerKey,
      height: 46,
      padding: const EdgeInsets.only(left: 16, right: 10),
      decoration: BoxDecoration(
        color: _disputeField,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _disputeFieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProviderId,
          dropdownColor: _disputeField,
          borderRadius: AppRadii.cardRadius,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: 22,
          ),
          hint: Text(
            'Select provider...',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 13,
              height: 1,
            ),
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            height: 1,
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
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: _disputePrimary,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontSize: 13,
        height: 1.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontSize: 13,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
        filled: true,
        fillColor: _disputeField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
    return InkWell(
      key: DisputeResolutionPage.uploadKey,
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _disputeField,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: attached ? AppColors.buy : _disputeFieldBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              attached
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_rounded,
              color: attached ? AppColors.buy : AppColors.text3,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              attached ? 'Evidence attached' : 'Upload Evidence (Optional)',
              style: AppTextStyles.caption.copyWith(
                color: attached ? AppColors.buy : AppColors.text3,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
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
    return InkWell(
      key: DisputeResolutionPage.submitKey,
      onTap: enabled ? onPressed : null,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _disputePrimary : AppColors.surface3,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
              color: enabled ? AppColors.onAccent : AppColors.text3,
              size: 17,
            ),
            const SizedBox(width: 9),
            Text(
              'Submit Complaint',
              style: AppTextStyles.body.copyWith(
                color: enabled ? AppColors.onAccent : AppColors.text3,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
