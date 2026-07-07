import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/help_center_hero_actions.dart';
part '../widgets/help_center_sections.dart';

class HelpCenterPage extends ConsumerStatefulWidget {
  const HelpCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc292_help_content');
  static const searchKey = Key('sc292_help_search');
  static const chatActionKey = Key('sc292_help_chat_action');
  static const ticketActionKey = Key('sc292_help_ticket_action');
  static const categoriesKey = Key('sc292_help_categories');
  static const articlesKey = Key('sc292_help_articles');
  static const emptyKey = Key('sc292_help_empty');
  static const loadingKey = Key('sc292_help_loading');
  static const errorKey = Key('sc292_help_error');
  static const offlineKey = Key('sc292_help_offline');

  static Key categoryKey(String id) => Key('sc292_help_category_$id');
  static Key articleKey(String id) => Key('sc292_help_article_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends ConsumerState<HelpCenterPage> {
  late final TextEditingController _searchController;
  String? _selectedCategoryId;
  String? _expandedArticleId;
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
    final snapshot = ref.watch(supportControllerProvider).getHelpCenter();
    final articles = _filteredArticles(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final showOfflineBanner =
        snapshot.screenState == SupportScreenState.offline &&
        snapshot.articles.isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-292 HelpCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showOfflineBanner)
                Padding(
                  key: HelpCenterPage.offlineKey,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: const VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị bài viết trợ giúp đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: HelpCenterPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.supportScrollPadding(bottomInset),
                    child: VitPageContent(
   rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      gap: VitContentGap.relaxed,
                      children: _helpCenterPageChildren(
                        snapshot: snapshot,
                        articles: articles,
                        searchController: _searchController,
                        query: _query,
                        selectedCategoryId: _selectedCategoryId,
                        expandedArticleId: _expandedArticleId,
                        sectionTitle: _sectionTitle(snapshot, articles.length),
                        onSearchChanged: _updateSearch,
                        onCategorySelected: _selectCategory,
                        onArticleToggle: _toggleArticle,
                        onRetry: () => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<HelpArticleDraft> _filteredArticles(HelpCenterSnapshot snapshot) {
    final query = _query.trim().toLowerCase();
    if (query.isNotEmpty) {
      return snapshot.articles.where((article) {
        return article.title.toLowerCase().contains(query) ||
            article.summary.toLowerCase().contains(query);
      }).toList();
    }
    final categoryId = _selectedCategoryId;
    if (categoryId != null) {
      return snapshot.articles
          .where((article) => article.categoryId == categoryId)
          .toList();
    }
    return snapshot.articles;
  }

  void _updateSearch(String value) {
    setState(() {
      _query = value;
      _selectedCategoryId = null;
      _expandedArticleId = null;
    });
  }

  void _selectCategory(String categoryId) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategoryId = _selectedCategoryId == categoryId
          ? null
          : categoryId;
      _expandedArticleId = null;
    });
  }

  void _toggleArticle(String articleId) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedArticleId = _expandedArticleId == articleId ? null : articleId;
    });
  }

  String _sectionTitle(HelpCenterSnapshot snapshot, int count) {
    if (_query.isNotEmpty) return 'Kết quả ($count)';
    final categoryId = _selectedCategoryId;
    if (categoryId == null) return 'Bài viết phổ biến';
    return snapshot.categories
        .firstWhere((category) => category.id == categoryId)
        .name;
  }
}
