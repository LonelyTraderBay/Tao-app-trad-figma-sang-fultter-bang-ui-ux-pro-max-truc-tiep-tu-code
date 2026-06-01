part of '../pages/provider_application_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
      ),
    );
  }
}

class _TogglePanel extends StatelessWidget {
  const _TogglePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.active,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool active;
  final String activeLabel;
  final String inactiveLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(icon: icon, title: title),
            const SizedBox(height: 8),
            Text(description, style: _panelDescriptionStyle),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: active ? _providerGreen : _providerPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                child: Text(active ? activeLabel : inactiveLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberPanel extends StatelessWidget {
  const _NumberPanel({
    required this.title,
    required this.description,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String title;
  final String description;
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: Icons.schedule_rounded, title: title),
          const SizedBox(height: 8),
          Text(description, style: _panelDescriptionStyle),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            key: ProviderApplicationPage.monthsFieldKey,
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            decoration: _inputDecoration('0'),
          ),
        ],
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    this.tileKey,
    required this.checked,
    required this.text,
    required this.onTap,
  });

  final Key? tileKey;
  final bool checked;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tileKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: checked
              ? _providerPrimary.withValues(alpha: .14)
              : _providerPanel,
          border: Border.all(
            color: checked ? _providerPrimary : AppColors.cardBorder,
            width: 1.5,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: checked ? _providerPrimary : AppColors.text3,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: icon, title: title),
          const SizedBox(height: 8),
          Text(description, style: _panelDescriptionStyle),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _providerPrimary, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

TextStyle get _panelDescriptionStyle => AppTextStyles.caption.copyWith(
  color: AppColors.text3,
  fontSize: 11,
  height: 1.45,
);

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: _providerField,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: AppRadii.inputRadius,
    ),
  );
}

IconData _benefitIcon(String iconName) {
  return switch (iconName) {
    'dollar' => Icons.attach_money_rounded,
    'users' => Icons.groups_2_outlined,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.check_rounded,
  };
}
