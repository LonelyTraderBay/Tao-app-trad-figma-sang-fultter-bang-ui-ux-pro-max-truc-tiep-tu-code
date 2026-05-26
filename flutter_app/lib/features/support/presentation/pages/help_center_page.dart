import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';

class HelpCenterPage extends ConsumerStatefulWidget {
  const HelpCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc292_help_content');
  static const searchKey = Key('sc292_help_search');
  static const chatActionKey = Key('sc292_help_chat_action');
  static const ticketActionKey = Key('sc292_help_ticket_action');
  static const categoriesKey = Key('sc292_help_categories');
  static const articlesKey = Key('sc292_help_articles');
  static const emptyKey = Key('sc292_help_empty');

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
    final snapshot = ref.watch(supportRepositoryProvider).getHelpCenter();
    final articles = _filteredArticles(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-292 HelpCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: HelpCenterPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    gap: VitContentGap.relaxed,
                    children: [
                      _HelpHero(
                        snapshot: snapshot,
                        controller: _searchController,
                        onChanged: _updateSearch,
                      ),
                      _QuickActions(
                        chatRoute: snapshot.chatRoute,
                        ticketRoute: snapshot.ticketRoute,
                      ),
                      if (_query.isEmpty)
                        _CategorySection(
                          categories: snapshot.categories,
                          selectedCategoryId: _selectedCategoryId,
                          onSelected: _selectCategory,
                        ),
                      _ArticleSection(
                        title: _sectionTitle(snapshot, articles.length),
                        articles: articles,
                        categories: snapshot.categories,
                        expandedArticleId: _expandedArticleId,
                        onToggle: _toggleArticle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

class _HelpHero extends StatelessWidget {
  const _HelpHero({
    required this.snapshot,
    required this.controller,
    required this.onChanged,
  });

  final HelpCenterSnapshot snapshot;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.support,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitSearchBar(
            key: HelpCenterPage.searchKey,
            controller: controller,
            placeholder: snapshot.searchHint,
            variant: VitSearchBarVariant.compact,
            onChanged: onChanged,
            onClear: () => onChanged(''),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.chatRoute, required this.ticketRoute});

  final String chatRoute;
  final String ticketRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            key: HelpCenterPage.chatActionKey,
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat hỗ trợ',
            color: AppColors.buy,
            onTap: () => context.go(chatRoute),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _QuickActionButton(
            key: HelpCenterPage.ticketActionKey,
            icon: Icons.support_agent_rounded,
            label: 'Gửi ticket',
            color: AppModuleAccents.support,
            onTap: () => context.go(ticketRoute),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<HelpCategoryDraft> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HelpCenterPage.categoriesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Danh mục',
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.9,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryTile(
              category: category,
              selected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final HelpCategoryDraft category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = _categoryColor(category.id);
    return VitCard(
      key: HelpCenterPage.categoryKey(category.id),
      radius: VitCardRadius.sm,
      borderColor: selected ? AppColors.primary40 : null,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_categoryIcon(category.id), color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.x3),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            '${category.count} bài viết',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    required this.title,
    required this.articles,
    required this.categories,
    required this.expandedArticleId,
    required this.onToggle,
  });

  final String title;
  final List<HelpArticleDraft> articles;
  final List<HelpCategoryDraft> categories;
  final String? expandedArticleId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HelpCenterPage.articlesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (articles.isEmpty)
          const VitEmptyState(
            key: HelpCenterPage.emptyKey,
            title: 'Không tìm thấy bài viết',
            message: 'Thử tìm kiếm bằng từ khóa khác hoặc chọn danh mục khác.',
            icon: Icons.search_off_rounded,
          )
        else
          Column(
            children: [
              for (var i = 0; i < articles.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.x3),
                _ArticleTile(
                  article: articles[i],
                  category: categories.firstWhere(
                    (category) => category.id == articles[i].categoryId,
                  ),
                  expanded: expandedArticleId == articles[i].id,
                  onTap: () => onToggle(articles[i].id),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.article,
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final HelpArticleDraft article;
  final HelpCategoryDraft category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = _categoryColor(category.id);
    return VitCard(
      key: HelpCenterPage.articleKey(article.id),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_categoryIcon(category.id), color: iconColor, size: 21),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: AppColors.text3,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      _compactViews(article.views),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    article.summary,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          AnimatedRotation(
            turns: expanded ? .25 : 0,
            duration: const Duration(milliseconds: 160),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _categoryIcon(String id) => switch (id) {
  'getting-started' => Icons.rocket_launch_rounded,
  'trading' => Icons.bar_chart_rounded,
  'deposit-withdraw' => Icons.account_balance_wallet_rounded,
  'security' => Icons.lock_rounded,
  'p2p' => Icons.handshake_rounded,
  'kyc' => Icons.assignment_rounded,
  'fees' => Icons.diamond_rounded,
  'api' => Icons.bolt_rounded,
  _ => Icons.help_outline_rounded,
};

Color _categoryColor(String id) => switch (id) {
  'getting-started' => AppColors.sell,
  'trading' => AppColors.buy,
  'deposit-withdraw' => AppColors.warn,
  'security' => AppModuleAccents.support,
  'p2p' => AppColors.buy,
  'kyc' => AppColors.sell,
  'fees' => AppColors.primarySoft,
  'api' => AppModuleAccents.support,
  _ => AppColors.text2,
};

String _compactViews(int value) {
  if (value >= 1000) {
    final number = value / 1000;
    final text = number.toStringAsFixed(1);
    return '${text.replaceAll('.0', '')}K';
  }
  return '$value';
}
