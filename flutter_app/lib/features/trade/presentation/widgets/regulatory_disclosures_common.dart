part of '../pages/regulatory_disclosures_page.dart';

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitSectionHeader(
      title: text,
      variant: VitSectionHeaderVariant.accentBar,
      accentColor: _legalPrimary,
    );
  }
}
