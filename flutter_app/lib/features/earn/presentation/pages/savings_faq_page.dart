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

part '../widgets/savings_faq_page_sections.dart';
part '../widgets/savings_faq_page_common.dart';

class SavingsFAQPage extends ConsumerStatefulWidget {
  const SavingsFAQPage({super.key, this.shellRenderMode});

  static const searchFieldKey = Key('sc336_search_field');
  static const faqListKey = Key('sc336_faq_list');
  static const firstFaqKey = Key('sc336_first_faq');
  static const supportButtonKey = Key('sc336_support_button');

  static Key categoryKey(String id) => Key('sc336_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsFAQPage> createState() => _SavingsFAQPageState();
}

class _SavingsFAQPageState extends ConsumerState<SavingsFAQPage> {
  String _activeCategoryId = 'all';
  String _query = '';
  final Set<String> _expandedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsFAQRepositoryProvider).getFAQ();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final activeCategory = snapshot.categories.firstWhere(
      (category) => category.id == _activeCategoryId,
      orElse: () => snapshot.categories.first,
    );
    final filtered = _filteredItems(
      snapshot.items,
      activeCategory.category,
      _query,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-336 SavingsFAQPage',
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
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _HeroCard(snapshot: snapshot),
                      _SearchField(
                        placeholder: snapshot.searchPlaceholder,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      _CategoryScroller(
                        categories: snapshot.categories,
                        activeId: _activeCategoryId,
                        counts: _categoryCounts(snapshot.items),
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeCategoryId = id);
                        },
                      ),
                      Text(
                        _query.isEmpty
                            ? '${filtered.length} câu hỏi'
                            : '${filtered.length} câu hỏi (đã lọc)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (filtered.isEmpty)
                        _EmptyResults(
                          onReset: () => setState(() {
                            _query = '';
                            _activeCategoryId = 'all';
                          }),
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
                      _SupportCard(snapshot: snapshot),
                      _Disclaimer(text: snapshot.disclaimer),
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
