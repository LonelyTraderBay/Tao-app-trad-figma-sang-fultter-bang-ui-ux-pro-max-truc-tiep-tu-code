part of '../pages/news_page.dart';

class _ArticleSheet extends StatelessWidget {
  const _ArticleSheet({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.borderSolid,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            type.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: type.color.withValues(alpha: .18),
                              borderRadius: AppRadii.mdRadius,
                            ),
                            child: Text(
                              type.label,
                              style: AppTextStyles.caption.copyWith(
                                color: type.color,
                                fontSize: 12,
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 22,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: AppColors.text2,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            article.publishedAtLabel,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _newsPrimary.withValues(alpha: .06),
                          border: Border.all(
                            color: _newsPrimary.withValues(alpha: .12),
                          ),
                          borderRadius: AppRadii.lgRadius,
                        ),
                        child: Text(
                          article.summary,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                            fontStyle: FontStyle.italic,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        article.content,
                        style: AppTextStyles.body.copyWith(height: 1.7),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in article.tags) _TagChip(label: tag),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.inputHeight,
                        child: FilledButton(
                          key: NewsPage.closeSheetKey,
                          onPressed: () => Navigator.of(context).pop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: _newsPrimary,
                            foregroundColor: AppColors.onAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.lgRadius,
                            ),
                          ),
                          child: Text(
                            'Đóng',
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.onAccent,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
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
