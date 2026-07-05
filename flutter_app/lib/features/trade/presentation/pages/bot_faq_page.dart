import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_faq_search_tabs.dart';
part '../widgets/bot_faq_cards_help.dart';

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
    return VitTradeHubScaffold(
      title: 'Trading Bots FAQ',
      subtitle: 'Câu hỏi thường gặp về bot giao dịch',
      semanticLabel: 'SC-132 BotFAQPage',
      contentKey: BotFaqPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Câu hỏi',
          primaryValue: '${snapshot.totalFaqs}',
          secondaryLabel: 'Danh mục',
          secondaryValue: '${snapshot.categories.length}',
        ),
        VitTradeSection(
          title: 'Tìm kiếm',
          child: _SearchField(
            controller: _searchController,
            onChanged: (value) => setState(() {
              _query = value;
              _expandedIndex = null;
            }),
          ),
        ),
        VitTradeSection(
          title: 'Danh mục',
          child: _CategoryTabs(
            categories: snapshot.categories,
            activeId: _categoryId,
            onChanged: (id) => setState(() {
              _categoryId = id;
              _expandedIndex = null;
            }),
          ),
        ),
        VitTradeSection(
          title: '${category.label} (${items.length})',
          child: items.isEmpty
              ? const _EmptyFaqs()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      if (i != items.length - 1)
                        const SizedBox(height: AppSpacing.x2),
                    ],
                  ],
                ),
        ),
        VitTradeSection(title: 'Hỗ trợ', child: const _HelpCard()),
        const VitBotRiskDisclaimer(),
      ],
    );
  }
}
