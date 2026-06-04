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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_faq_search_tabs.dart';
part '../widgets/bot_faq_cards_help.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trading Bots FAQ',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
      ),
    );
  }
}
