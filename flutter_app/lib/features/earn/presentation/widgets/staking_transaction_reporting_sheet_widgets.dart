part of '../pages/staking_transaction_reporting_page.dart';

class _MethodSheet extends StatelessWidget {
  const _MethodSheet({
    required this.methods,
    required this.selected,
    required this.onChanged,
  });

  final List<StakingCostBasisMethodDraft> methods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.methodSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Select Cost Basis Method'),
          const SizedBox(height: AppSpacing.x4),
          for (final method in methods) ...[
            _MethodOption(
              method: method,
              selected: method.value == selected,
              onTap: () => onChanged(method.value),
            ),
            if (method != methods.last) const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Once you choose a method for a tax year, use it consistently. Consult a tax professional for guidance.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.5,
                    ),
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

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final StakingCostBasisMethodDraft method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.methodKey(method.value),
      onTap: onTap,
      borderColor: selected ? AppColors.primary : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.primary : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.label, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  method.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
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

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingTransactionReportingPage.exportSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle(title: 'Export Options'),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(title: 'Tax Forms (PDF)', options: snapshot.taxForms),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(
            title: 'Third-Party Integrations',
            options: snapshot.integrations,
          ),
          const SizedBox(height: AppSpacing.x4),
          _ExportGroup(title: 'Raw Data', options: snapshot.rawDataFormats),
        ],
      ),
    );
  }
}

class _ExportGroup extends StatelessWidget {
  const _ExportGroup({required this.title, required this.options});

  final String title;
  final List<StakingTaxExportOptionDraft> options;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppColors.primarySoft,
      children: [
        for (final option in options)
          VitCard(
            key: StakingTransactionReportingPage.exportOptionKey(option.name),
            onTap: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.name, style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        option.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.text2),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTransactionReportingPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

String _tabLabel(_ReportingTab tab) {
  return switch (tab) {
    _ReportingTab.summary => 'Summary',
    _ReportingTab.transactions => 'Transactions',
    _ReportingTab.export => 'Export',
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'stake' => 'Staked',
    'unstake' => 'Unstaked',
    'reward' => 'Reward',
    _ => type,
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
}
