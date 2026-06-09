part of '../pages/bot_faq_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      fieldKey: BotFaqPage.searchKey,
      placeholder: 'Search FAQs...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeBotFaqCategory> categories;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final widths = <String, double>{
      'general': 79,
      'safety': 69,
      'technical': 88,
      'strategies': 92,
      'troubleshooting': 126,
    };
    return SizedBox(
      height: 35,
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: 486,
        child: Row(
          children: [
            for (var i = 0; i < categories.length; i++) ...[
              GestureDetector(
                key: BotFaqPage.tabKey(categories[i].id),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(categories[i].id),
                child: Container(
                  width: widths[categories[i].id] ?? 86,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: activeId == categories[i].id
                        ? _faqPrimary.withValues(alpha: .13)
                        : _faqPanel2,
                    border: Border.all(
                      color: activeId == categories[i].id
                          ? _faqPrimary.withValues(alpha: .42)
                          : AppColors.transparent,
                    ),
                    borderRadius: AppRadii.cardRadius,
                  ),
                  child: Text(
                    categories[i].id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: activeId == categories[i].id
                          ? _faqPrimary
                          : AppColors.text3,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              if (i != categories.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
