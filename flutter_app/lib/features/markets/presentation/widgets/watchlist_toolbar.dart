part of '../pages/watchlist_page.dart';

class _WatchlistToolbar extends StatelessWidget {
  const _WatchlistToolbar({
    required this.controller,
    required this.count,
    required this.onChanged,
    required this.onClear,
    required this.onAddPair,
  });

  final TextEditingController controller;
  final int count;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 13),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ToolbarSearchField(
                    key: WatchlistPage.searchKey,
                    controller: controller,
                    placeholder: 'Tìm kiếm cặp giao dịch...',
                    onChanged: onChanged,
                    onClear: onClear,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  key: WatchlistPage.addPairKey,
                  onTap: onAddPair,
                  borderRadius: AppRadii.lgRadius,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: _marketPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.onAccent,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warn, size: 15),
                const SizedBox(width: 7),
                Text(
                  '$count cặp đang theo dõi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarSearchField extends StatelessWidget {
  const _ToolbarSearchField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        border: Border.all(color: AppColors.searchBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: _marketPrimary,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.body.copyWith(fontSize: 14),
              decoration: InputDecoration.collapsed(
                hintText: placeholder,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.searchPlaceholder,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (hasValue)
            InkWell(
              onTap: () {
                controller.clear();
                onChanged('');
                onClear();
              },
              borderRadius: AppRadii.inputRadius,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text3,
                  size: 17,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
