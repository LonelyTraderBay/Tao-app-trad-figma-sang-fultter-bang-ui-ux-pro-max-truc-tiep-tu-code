import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class SavingsFAQPage extends ConsumerStatefulWidget {
  const SavingsFAQPage({super.key, this.shellRenderMode});

  static const searchFieldKey = Key('sc336_search_field');
  static const faqListKey = Key('sc336_faq_list');
  static const firstFaqKey = Key('sc336_first_faq');
  static const supportButtonKey = Key('sc336_support_button');

  static Key categoryKey(String id) => Key('sc336_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsFAQPage> createState() => _SavingsFAQPageState();
}

class _SavingsFAQPageState extends ConsumerState<SavingsFAQPage> {
  String _activeCategoryId = 'all';
  String _query = '';
  final Set<String> _expandedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsFAQRepositoryProvider).getFAQ();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final activeCategory = snapshot.categories.firstWhere(
      (category) => category.id == _activeCategoryId,
      orElse: () => snapshot.categories.first,
    );
    final filtered = _filteredItems(
      snapshot.items,
      activeCategory.category,
      _query,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-336 SavingsFAQPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _HeroCard(snapshot: snapshot),
                    _SearchField(
                      placeholder: snapshot.searchPlaceholder,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    _CategoryScroller(
                      categories: snapshot.categories,
                      activeId: _activeCategoryId,
                      counts: _categoryCounts(snapshot.items),
                      onChanged: (id) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeCategoryId = id);
                      },
                    ),
                    Text(
                      _query.isEmpty
                          ? '${filtered.length} câu hỏi'
                          : '${filtered.length} câu hỏi (đã lọc)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    if (filtered.isEmpty)
                      _EmptyResults(
                        onReset: () => setState(() {
                          _query = '';
                          _activeCategoryId = 'all';
                        }),
                      )
                    else
                      _FAQList(
                        items: filtered,
                        expandedIds: _expandedIds,
                        onToggle: (id) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (!_expandedIds.add(id)) {
                              _expandedIds.remove(id);
                            }
                          });
                        },
                      ),
                    _SupportCard(snapshot: snapshot),
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: SavingsFAQPage.searchFieldKey,
      onChanged: onChanged,
      cursorColor: AppColors.primary,
      style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      decoration: InputDecoration(
        isDense: true,
        hintText: placeholder,
        hintStyle: AppTextStyles.caption.copyWith(
          color: AppColors.searchPlaceholder,
          fontWeight: AppTextStyles.bold,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconMd,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppSpacing.x7,
          minHeight: AppSpacing.x6,
        ),
        filled: true,
        fillColor: AppColors.searchBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.xlRadius,
          borderSide: BorderSide(color: AppColors.searchBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.xlRadius,
          borderSide: BorderSide(color: AppColors.primary30),
        ),
      ),
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({
    required this.categories,
    required this.activeId,
    required this.counts,
    required this.onChanged,
  });

  final List<SavingsFAQCategoryDraft> categories;
  final String activeId;
  final Map<String, int> counts;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final category in categories) ...[
            _CategoryChip(
              key: SavingsFAQPage.categoryKey(category.id),
              category: category,
              count: counts[category.id] ?? 0,
              selected: category.id == activeId,
              onTap: () => onChanged(category.id),
            ),
            if (category != categories.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.category,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final SavingsFAQCategoryDraft category;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x1,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.lgRadius,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                category.label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primary : AppColors.text3,
                  fontWeight: selected
                      ? AppTextStyles.bold
                      : AppTextStyles.normal,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                '$count',
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQList extends StatelessWidget {
  const _FAQList({
    required this.items,
    required this.expandedIds,
    required this.onToggle,
  });

  final List<SavingsFAQItemDraft> items;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsFAQPage.faqListKey,
      children: [
        for (final item in items) ...[
          _FAQCard(
            key: item == items.first ? SavingsFAQPage.firstFaqKey : null,
            item: item,
            expanded: expandedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FAQCard extends StatelessWidget {
  const _FAQCard({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final SavingsFAQItemDraft item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(item.category);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: AppRadii.cardLargeRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x1,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuestionIcon(color: color),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      item.question,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.25,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x7,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.answer,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Text(
                        'Hữu ích?',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      _FeedbackPill(
                        icon: Icons.thumb_up_alt_outlined,
                        label: 'Có',
                        color: AppColors.buy,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      _FeedbackPill(
                        icon: Icons.thumb_down_alt_outlined,
                        label: 'Không',
                        color: AppColors.sell,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(
          Icons.help_outline_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _FeedbackPill extends StatelessWidget {
  const _FeedbackPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text('Không tìm thấy câu hỏi', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thử từ khóa khác hoặc đổi danh mục',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            onPressed: onReset,
            child: const Text('Xóa bộ lọc'),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.snapshot});

  final SavingsFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const _QuestionIcon(color: AppColors.primary),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.supportTitle, style: AppTextStyles.baseMedium),
                Text(
                  snapshot.supportSubtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitCtaButton(
            key: SavingsFAQPage.supportButtonKey,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.supportRoute);
            },
            trailing: const Icon(Icons.open_in_new_rounded),
            child: const Text('Liên hệ'),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<SavingsFAQItemDraft> _filteredItems(
  List<SavingsFAQItemDraft> items,
  SavingsFAQCategory? category,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  return [
    for (final item in items)
      if ((category == null || item.category == category) &&
          (normalized.isEmpty ||
              item.question.toLowerCase().contains(normalized) ||
              item.answer.toLowerCase().contains(normalized)))
        item,
  ];
}

Map<String, int> _categoryCounts(List<SavingsFAQItemDraft> items) {
  final counts = <String, int>{'all': items.length};
  for (final category in SavingsFAQCategory.values) {
    counts[category.name] = items
        .where((item) => item.category == category)
        .length;
  }
  return counts;
}

Color _categoryColor(SavingsFAQCategory category) {
  return switch (category) {
    SavingsFAQCategory.general => AppColors.primary,
    SavingsFAQCategory.products => AppColors.buy,
    SavingsFAQCategory.operations => AppColors.accent,
    SavingsFAQCategory.fees => AppColors.warn,
    SavingsFAQCategory.risks => AppColors.sell,
  };
}
