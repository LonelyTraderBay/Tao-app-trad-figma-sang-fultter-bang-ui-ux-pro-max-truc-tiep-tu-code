import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _faqBackground = AppColors.bg;
const _faqPanel = AppColors.surface;
const _faqPanel2 = AppColors.surface2;
const _faqPrimary = AppColors.primary;

class BotFaqPage extends ConsumerStatefulWidget {
  const BotFaqPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc132_bot_faq_content');
  static const searchKey = Key('sc132_bot_faq_search');
  static Key tabKey(String id) => Key('sc132_bot_faq_tab_$id');
  static Key questionKey(String id, int index) =>
      Key('sc132_bot_faq_question_${id}_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotFaqPage> createState() => _BotFaqPageState();
}

class _BotFaqPageState extends ConsumerState<BotFaqPage> {
  late final TextEditingController _searchController;
  String _categoryId = 'general';
  int? _expandedIndex;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeReadModelControllerProvider).getBotFaq();
    final category = snapshot.categories.firstWhere(
      (item) => item.id == _categoryId,
      orElse: () => snapshot.categories.first,
    );
    final query = _query.trim().toLowerCase();
    final items = query.isEmpty
        ? category.items
        : category.items
              .where(
                (item) =>
                    item.question.toLowerCase().contains(query) ||
                    item.answer.toLowerCase().contains(query),
              )
              .toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 94
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-132 BotFAQPage',
      child: Material(
        color: _faqBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Trading Bots FAQ',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotFaqPage.contentKey,
                clipBehavior: Clip.none,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {
                        _query = value;
                        _expandedIndex = null;
                      }),
                    ),
                    const SizedBox(height: 32),
                    _CategoryTabs(
                      categories: snapshot.categories,
                      activeId: _categoryId,
                      onChanged: (id) => setState(() {
                        _categoryId = id;
                        _expandedIndex = null;
                      }),
                    ),
                    const SizedBox(height: 17),
                    _SectionLabel('${category.label} (${items.length})'),
                    const SizedBox(height: 10),
                    if (items.isEmpty)
                      const _EmptyFaqs()
                    else
                      for (var i = 0; i < items.length; i++) ...[
                        _FaqCard(
                          categoryId: category.id,
                          index: i,
                          item: items[i],
                          expanded: _expandedIndex == i,
                          onTap: () => setState(() {
                            _expandedIndex = _expandedIndex == i ? null : i;
                          }),
                        ),
                        if (i != items.length - 1) const SizedBox(height: 9),
                      ],
                    const SizedBox(height: 10),
                    _StatsRow(
                      totalFaqs: snapshot.totalFaqs,
                      categories: snapshot.categories.length,
                    ),
                    const SizedBox(height: 17),
                    const _HelpCard(),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _faqPanel,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              key: BotFaqPage.searchKey,
              controller: controller,
              onChanged: onChanged,
              cursorColor: _faqPrimary,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search FAQs...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
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

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.categoryId,
    required this.index,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final String categoryId;
  final int index;
  final TradeBotFaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BotFaqPage.questionKey(categoryId, index),
      decoration: BoxDecoration(
        color: _faqPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: _faqPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.question,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _faqPanel2,
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Text(
                  item.answer,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.65,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.totalFaqs, required this.categories});

  final int totalFaqs;
  final int categories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Total FAQs', value: totalFaqs.toString()),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: _StatCard(label: 'Categories', value: categories.toString()),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _faqPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 25,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _faqPrimary.withValues(alpha: .08),
        border: Border.all(color: _faqPrimary.withValues(alpha: .25)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Still need help?',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Can't find your answer? Our support team is here to help 24/7.",
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _HelpButton(
                  label: 'Live Chat',
                  background: _faqPanel2,
                  foreground: AppColors.text1,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _HelpButton(
                  label: 'Contact Support',
                  background: _faqPrimary,
                  foreground: AppColors.onAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: foreground,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EmptyFaqs extends StatelessWidget {
  const _EmptyFaqs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: AppColors.text3,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No FAQs found',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _faqPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
