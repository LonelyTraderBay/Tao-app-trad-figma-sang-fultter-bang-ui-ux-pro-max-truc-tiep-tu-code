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
                    height: AppSpacing.newsSheetHandleHeight,
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
                            VitAccentPill(
                              label: type.label,
                              accentColor: type.color,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          article.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            height: AppSpacing.newsSheetTitleLineHeight,
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
                          borderColor: AppColors.primary.withValues(alpha: .12),
                          child: Text(
                            article.summary,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text2,
                              fontStyle: FontStyle.italic,
                              height: AppSpacing.newsSheetSummaryLineHeight,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          article.content,
                          style: AppTextStyles.body.copyWith(
                            height: AppSpacing.newsSheetBodyLineHeight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.newsSectionBreak),
                        Wrap(
                          spacing: AppSpacing.x3,
                          runSpacing: AppSpacing.x3,
                          children: [
                            for (final tag in article.tags)
                              VitStatusPill(
                                label: tag,
                                status: VitStatusPillStatus.neutral,
                                size: VitStatusPillSize.sm,
                                icon: Icons.sell_outlined,
                              ),
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
