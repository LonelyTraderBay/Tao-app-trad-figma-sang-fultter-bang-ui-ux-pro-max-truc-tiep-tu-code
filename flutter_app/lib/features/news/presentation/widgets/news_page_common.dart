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
        constraints: const BoxConstraints(
          maxWidth: AppSpacing.newsSheetMaxWidth,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.sizeOf(context).height *
                AppSpacing.newsSheetMaxHeightFactor,
          ),
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.bg,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.sheetTopLargeRadius,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: AppSpacing.newsSheetHandleMargin,
                  child: SizedBox(
                    width: AppSpacing.newsSheetHandleWidth,
                    height: _newsSheetHandleHeight,
                    child: DecoratedBox(
                      decoration: const ShapeDecoration(
                        color: AppColors.borderSolid,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.pillRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: AppSpacing.newsSheetPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(type.emoji, style: AppTextStyles.sectionTitle),
                            const SizedBox(width: AppSpacing.x3 + 2),
                            DecoratedBox(
                              decoration: ShapeDecoration(
                                color: type.color.withValues(alpha: .18),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadii.mdRadius,
                                ),
                              ),
                              child: Padding(
                                padding: AppSpacing.newsSheetBadgePadding,
                                child: Text(
                                  type.label,
                                  style: AppTextStyles.captionSm.copyWith(
                                    color: type.color,
                                    fontWeight: AppTextStyles.bold,
                                    height: _newsTightLineHeight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          article.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            height: _newsSheetTitleLineHeight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: AppSpacing.newsSheetCalendarIconSize,
                              color: AppColors.text2,
                            ),
                            const SizedBox(width: AppSpacing.x2 + 1),
                            Text(
                              article.publishedAtLabel,
                              style: AppTextStyles.captionSm.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        VitCard(
                          width: double.infinity,
                          density: VitDensity.compact,
                          variant: VitCardVariant.inner,
                          borderColor: _newsPrimary.withValues(alpha: .12),
                          child: Text(
                            article.summary,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text2,
                              fontStyle: FontStyle.italic,
                              height: _newsSheetSummaryLineHeight,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          article.content,
                          style: AppTextStyles.body.copyWith(
                            height: _newsSheetBodyLineHeight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.newsSectionBreak),
                        Wrap(
                          spacing: AppSpacing.x3,
                          runSpacing: AppSpacing.x3,
                          children: [
                            for (final tag in article.tags)
                              _TagChip(label: tag),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        VitCtaButton(
                          key: NewsPage.closeSheetKey,
                          height: VitDensity.compact.controlHeight,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Đóng',
                            style: AppTextStyles.control.copyWith(
                              color: AppColors.onAccent,
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
      ),
    );
  }
}
