part of '../pages/help_center_page.dart';

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
      radius: VitCardRadius.large,
      padding: AppSpacing.supportCardPadding,
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
              height: AppSpacing.supportLineHeightBody,
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
      radius: VitCardRadius.standard,
      padding: AppSpacing.supportQuickCardPadding,
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

class _HelpCenterBody extends StatelessWidget {
  const _HelpCenterBody({
    required this.snapshot,
    required this.articles,
    required this.searchController,
    required this.query,
    required this.selectedCategoryId,
    required this.expandedArticleId,
    required this.sectionTitle,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onArticleToggle,
    required this.onRetry,
  });

  final HelpCenterSnapshot snapshot;
  final List<HelpArticleDraft> articles;
  final TextEditingController searchController;
  final String query;
  final String? selectedCategoryId;
  final String? expandedArticleId;
  final String sectionTitle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onArticleToggle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (snapshot.screenState) {
      SupportScreenState.loading => const VitSkeletonList(
        key: HelpCenterPage.loadingKey,
        rows: 4,
      ),
      SupportScreenState.error => VitErrorState(
        key: HelpCenterPage.errorKey,
        title: 'Không tải được trung tâm trợ giúp',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
      SupportScreenState.empty ||
      SupportScreenState.offline when snapshot.articles.isEmpty =>
        const VitEmptyState(
          key: HelpCenterPage.emptyKey,
          title: 'Chưa có bài viết trợ giúp',
          message: 'Nội dung hướng dẫn sẽ được cập nhật tại đây.',
          icon: Icons.menu_book_outlined,
        ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HelpHero(
            snapshot: snapshot,
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          _QuickActions(
            chatRoute: snapshot.chatRoute,
            ticketRoute: snapshot.ticketRoute,
          ),
          if (query.isEmpty)
            _CategorySection(
              categories: snapshot.categories,
              selectedCategoryId: selectedCategoryId,
              onSelected: onCategorySelected,
            ),
          _ArticleSection(
            title: sectionTitle,
            articles: articles,
            categories: snapshot.categories,
            expandedArticleId: expandedArticleId,
            onToggle: onArticleToggle,
          ),
        ],
      ),
    };
  }
}
