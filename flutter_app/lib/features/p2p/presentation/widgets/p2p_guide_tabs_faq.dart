part of '../pages/p2p_guide_page.dart';

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<P2PGuideTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: P2PGuidePage.tabsKey,
      color: AppColors.surface,
      child: Padding(
        padding: AppSpacing.p2pGuideTabsPadding,
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs)
              VitTabItem(
                key: tab.id,
                label: tab.label,
                widgetKey: P2PGuidePage.tabKey(tab.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _GuideBody extends StatelessWidget {
  const _GuideBody({
    required this.snapshot,
    required this.activeTab,
    required this.mode,
    required this.expandedFaqId,
    required this.onModeChanged,
    required this.onFaqToggle,
  });

  final P2PGuideSnapshot snapshot;
  final String activeTab;
  final String mode;
  final String? expandedFaqId;
  final ValueChanged<String> onModeChanged;
  final ValueChanged<String> onFaqToggle;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      'guide' => _HowItWorksTab(
        snapshot: snapshot,
        mode: mode,
        onModeChanged: onModeChanged,
      ),
      'safety' => _SafetyTab(snapshot: snapshot),
      'video' => _VideoTab(snapshot: snapshot),
      _ => _FaqTab(
        snapshot: snapshot,
        expandedFaqId: expandedFaqId,
        onFaqToggle: onFaqToggle,
      ),
    };
  }
}

class _FaqTab extends StatelessWidget {
  const _FaqTab({
    required this.snapshot,
    required this.expandedFaqId,
    required this.onFaqToggle,
  });

  final P2PGuideSnapshot snapshot;
  final String? expandedFaqId;
  final ValueChanged<String> onFaqToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PGuidePage.faqListKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Câu hỏi thường gặp', style: AppTextStyles.baseMedium),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${snapshot.faqItems.length} câu hỏi',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (var index = 0; index < snapshot.faqItems.length; index++) ...[
          _FaqCard(
            faq: snapshot.faqItems[index],
            expanded: snapshot.faqItems[index].id == expandedFaqId,
            onTap: () => onFaqToggle(snapshot.faqItems[index].id),
          ),
          if (index != snapshot.faqItems.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.faq,
    required this.expanded,
    required this.onTap,
  });

  final P2PGuideFaqDraft faq;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PGuidePage.faqKey(faq.id),
      radius: VitCardRadius.lg,
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.p2pGuideFaqCardPadding,
            child: Row(
              children: [
                _RoundIcon(
                  icon: Icons.help_outline_rounded,
                  color: expanded ? AppModuleAccents.p2p : AppColors.text3,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    faq.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: AppSpacing.p2pGuideFaqAnswerPadding,
              child: Text(
                faq.answer,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
