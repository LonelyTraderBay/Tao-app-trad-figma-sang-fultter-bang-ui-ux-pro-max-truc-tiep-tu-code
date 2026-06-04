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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

class StakingFAQPage extends ConsumerStatefulWidget {
  const StakingFAQPage({super.key, this.shellRenderMode});

  static const searchFieldKey = Key('sc370_search_field');
  static const tabsKey = Key('sc370_tabs');
  static const faqListKey = Key('sc370_faq_list');
  static const firstFaqKey = Key('sc370_first_faq');
  static const emptyKey = Key('sc370_empty');
  static const supportKey = Key('sc370_support');

  static Key categoryKey(String id) => Key('sc370_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingFAQPage> createState() => _StakingFAQPageState();
}

class _StakingFAQPageState extends ConsumerState<StakingFAQPage> {
  StakingFAQCategory _category = StakingFAQCategory.general;
  String _query = '';
  final Set<String> _expandedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(stakingFAQRepositoryProvider).getFAQ();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final filtered = _filteredItems(snapshot.items, _category, _query);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-370 StakingFAQPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _SearchField(
                        placeholder: snapshot.searchPlaceholder,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      _CategoryTabs(
                        active: _category,
                        onChanged: (category) {
                          HapticFeedback.selectionClick();
                          setState(() => _category = category);
                        },
                      ),
                      if (_query.trim().isNotEmpty)
                        Text(
                          'Tìm thấy ${filtered.length} kết quả',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      if (filtered.isEmpty)
                        _EmptyResults(
                          onReset: () => setState(() => _query = ''),
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
                      _SupportPanel(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
      key: StakingFAQPage.searchFieldKey,
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

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.active, required this.onChanged});

  final StakingFAQCategory active;
  final ValueChanged<StakingFAQCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingFAQPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x3,
        AppSpacing.x4,
        AppSpacing.x3,
        0,
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active.name,
        onChanged: (key) => onChanged(
          StakingFAQCategory.values.firstWhere(
            (category) => category.name == key,
          ),
        ),
        tabs: [
          for (final category in StakingFAQCategory.values)
            VitTabItem(key: category.name, label: _categoryLabel(category)),
        ],
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

  final List<StakingFAQItemDraft> items;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingFAQPage.faqListKey,
      children: [
        for (final item in items) ...[
          _FAQCard(
            key: item == items.first ? StakingFAQPage.firstFaqKey : null,
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

  final StakingFAQItemDraft item;
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
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    color: color,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      item.question,
                      style: AppTextStyles.baseMedium.copyWith(height: 1.35),
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
              child: Text(
                item.answer,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.65,
                ),
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

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingFAQPage.emptyKey,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Không tìm thấy câu hỏi phù hợp',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            fullWidth: false,
            onPressed: onReset,
            child: const Text('Xóa tìm kiếm'),
          ),
        ],
      ),
    );
  }
}

class _SupportPanel extends StatelessWidget {
  const _SupportPanel({required this.snapshot});

  final StakingFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingFAQPage.supportKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(snapshot.supportTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.supportBody,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.supportRoute);
                  },
                  child: const Text('Live Chat'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.supportRoute);
                  },
                  child: const Text('Email Support'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<StakingFAQItemDraft> _filteredItems(
  List<StakingFAQItemDraft> items,
  StakingFAQCategory category,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  return [
    for (final item in items)
      if (item.category == category &&
          (normalized.isEmpty ||
              item.question.toLowerCase().contains(normalized) ||
              item.answer.toLowerCase().contains(normalized)))
        item,
  ];
}

String _categoryLabel(StakingFAQCategory category) {
  return switch (category) {
    StakingFAQCategory.general => 'Cơ bản',
    StakingFAQCategory.technical => 'Kỹ thuật',
    StakingFAQCategory.fees => 'Phí',
    StakingFAQCategory.risks => 'Rủi ro',
    StakingFAQCategory.advanced => 'Nâng cao',
  };
}

Color _categoryColor(StakingFAQCategory category) {
  return switch (category) {
    StakingFAQCategory.general => AppColors.primarySoft,
    StakingFAQCategory.technical => AppColors.primarySoft,
    StakingFAQCategory.fees => AppColors.warn,
    StakingFAQCategory.risks => AppColors.sell,
    StakingFAQCategory.advanced => AppColors.buy,
  };
}
