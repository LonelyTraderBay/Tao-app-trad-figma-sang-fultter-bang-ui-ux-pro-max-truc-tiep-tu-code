import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PFraudPreventionPage extends ConsumerStatefulWidget {
  const P2PFraudPreventionPage({super.key, this.shellRenderMode});

  static const scoreKey = Key('sc260_p2p_fraud_score');
  static const patternsKey = Key('sc260_p2p_fraud_patterns');
  static const checklistKey = Key('sc260_p2p_fraud_checklist');
  static const emergencyKey = Key('sc260_p2p_fraud_emergency');
  static const disclosureKey = Key('sc260_p2p_fraud_disclosure');

  static Key patternKey(String id) => Key('sc260_p2p_fraud_pattern_$id');

  static Key tabKey(String id) => Key('sc260_p2p_fraud_tab_$id');

  static Key checklistItemKey(String id) =>
      Key('sc260_p2p_fraud_checklist_$id');

  static Key actionKey(String id) => Key('sc260_p2p_fraud_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PFraudPreventionPage> createState() =>
      _P2PFraudPreventionPageState();
}

class _P2PFraudPreventionPageState
    extends ConsumerState<P2PFraudPreventionPage> {
  late List<P2PSafetyChecklistItemDraft> _checklist;
  String? _expandedPatternId;
  String _activeCategory = 'before';

  @override
  void initState() {
    super.initState();
    _checklist = List.of(ref.read(p2pFraudPreventionProvider).checklist);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pFraudPreventionProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final checkedCount = _checklist.where((item) => item.checked).length;
    final score = (checkedCount / _checklist.length * 100).round();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-260 P2PFraudPreventionPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Phòng chống gian lận',
              subtitle: 'An toàn · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SafetyScoreCard(
                        score: score,
                        checkedCount: checkedCount,
                        totalCount: _checklist.length,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _PatternSection(
                        patterns: snapshot.patterns,
                        expandedPatternId: _expandedPatternId,
                        onToggle: _togglePattern,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _ChecklistCard(
                        checklist: _checklist,
                        activeCategory: _activeCategory,
                        onCategoryChanged: _setCategory,
                        onToggle: _toggleChecklist,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _EmergencyActions(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _Disclosure(text: snapshot.disclosure),
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

  void _togglePattern(String id) {
    HapticFeedback.selectionClick();
    setState(() => _expandedPatternId = _expandedPatternId == id ? null : id);
  }

  void _setCategory(String category) {
    HapticFeedback.selectionClick();
    setState(() => _activeCategory = category);
  }

  void _toggleChecklist(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _checklist = [
        for (final item in _checklist)
          if (item.id == id) item.copyWith(checked: !item.checked) else item,
      ];
    });
  }
}

class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({
    required this.score,
    required this.checkedCount,
    required this.totalCount,
  });

  final int score;
  final int checkedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);

    return VitCard(
      key: P2PFraudPreventionPage.scoreKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: color, size: 20),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Chỉ số an toàn',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontSize: 28,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            '$checkedCount/$totalCount biện pháp bảo vệ đã áp dụng',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (score < 100) ...[
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warn10,
                borderRadius: AppRadii.lgRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Hoàn thành checklist bên dưới để tăng chỉ số an toàn',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PatternSection extends StatelessWidget {
  const _PatternSection({
    required this.patterns,
    required this.expandedPatternId,
    required this.onToggle,
  });

  final List<P2PScamPatternDraft> patterns;
  final String? expandedPatternId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PFraudPreventionPage.patternsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.gpp_bad_outlined,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Các hình thức gian lận phổ biến',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (var index = 0; index < patterns.length; index++) ...[
          _PatternCard(
            pattern: patterns[index],
            expanded: expandedPatternId == patterns[index].id,
            onTap: () => onToggle(patterns[index].id),
          ),
          if (index != patterns.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({
    required this.pattern,
    required this.expanded,
    required this.onTap,
  });

  final P2PScamPatternDraft pattern;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(pattern.severity);

    return VitCard(
      key: P2PFraudPreventionPage.patternKey(pattern.id),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: AppRadii.lgRadius,
                  ),
                  child: Icon(_patternIcon(pattern.iconKey), color: color),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              pattern.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontSize: 15,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          _SeverityBadge(severity: pattern.severity),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        pattern.description,
                        maxLines: expanded ? null : 2,
                        overflow: expanded ? null : TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedPattern(pattern: pattern),
        ],
      ),
    );
  }
}

class _ExpandedPattern extends StatelessWidget {
  const _ExpandedPattern({required this.pattern});

  final P2PScamPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailList(
              title: 'CÁCH THỨC HOẠT ĐỘNG',
              items: pattern.howItWorks,
              color: AppColors.text2,
              numbered: true,
            ),
            const SizedBox(height: AppSpacing.x4),
            _DetailList(
              title: 'DẤU HIỆU NHẬN BIẾT',
              items: pattern.redFlags,
              color: AppColors.sell,
              icon: Icons.error_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.x4),
            _DetailList(
              title: 'CÁCH PHÒNG TRÁNH',
              items: pattern.prevention,
              color: AppColors.buy,
              icon: Icons.check_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailList extends StatelessWidget {
  const _DetailList({
    required this.title,
    required this.items,
    required this.color,
    this.numbered = false,
    this.icon,
  });

  final String title;
  final List<String> items;
  final Color color;
  final bool numbered;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (var index = 0; index < items.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numbered)
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surface2,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                )
              else
                Icon(icon, color: color, size: 13),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  items[index],
                  style: AppTextStyles.caption.copyWith(
                    color: color == AppColors.text2 ? AppColors.text2 : color,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({
    required this.checklist,
    required this.activeCategory,
    required this.onCategoryChanged,
    required this.onToggle,
  });

  final List<P2PSafetyChecklistItemDraft> checklist;
  final String activeCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final categories = ['before', 'during', 'after'];
    final activeItems = checklist
        .where((item) => item.category == activeCategory)
        .toList(growable: false);

    return VitCard(
      key: P2PFraudPreventionPage.checklistKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Checklist an toàn',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (var index = 0; index < categories.length; index++) ...[
                Expanded(
                  child: _CategoryTab(
                    category: categories[index],
                    selected: activeCategory == categories[index],
                    items: checklist
                        .where((item) => item.category == categories[index])
                        .toList(growable: false),
                    onTap: () => onCategoryChanged(categories[index]),
                  ),
                ),
                if (index != categories.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var index = 0; index < activeItems.length; index++) ...[
            _ChecklistItem(item: activeItems[index], onTap: onToggle),
            if (index != activeItems.length - 1)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.category,
    required this.selected,
    required this.items,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final List<P2PSafetyChecklistItemDraft> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final checked = items.where((item) => item.checked).length;

    return Material(
      key: P2PFraudPreventionPage.tabKey(category),
      color: selected ? AppModuleAccents.p2p : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x3,
          ),
          child: Column(
            children: [
              Text(
                _categoryLabel(category),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.onAccent : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$checked/${items.length}',
                style: AppTextStyles.micro.copyWith(
                  color: selected
                      ? AppColors.onAccent.withValues(alpha: .72)
                      : AppColors.text3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.item, required this.onTap});

  final P2PSafetyChecklistItemDraft item;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: P2PFraudPreventionPage.checklistItemKey(item.id),
        onTap: () => onTap(item.id),
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.checked ? AppColors.buy : AppColors.transparent,
                  borderRadius: AppRadii.smRadius,
                  border: Border.all(
                    color: item.checked ? AppColors.buy : AppColors.borderSolid,
                  ),
                ),
                child: item.checked
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.onAccent,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: AppTextStyles.caption.copyWith(
                        color: item.checked ? AppColors.buy : AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        decoration: item.checked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.buy,
                      ),
                    ),
                    Text(
                      item.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyActions extends StatelessWidget {
  const _EmergencyActions({required this.snapshot});

  final P2PFraudPreventionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PFraudPreventionPage.emergencyKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Bạn đang bị lừa đảo?',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (
            var index = 0;
            index < snapshot.emergencyActions.length;
            index++
          ) ...[
            _EmergencyButton(action: snapshot.emergencyActions[index]),
            if (index != snapshot.emergencyActions.length - 1)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  const _EmergencyButton({required this.action});

  final P2PFraudEmergencyActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(action.toneKey);

    return Material(
      key: P2PFraudPreventionPage.actionKey(action.id),
      color: color.withValues(alpha: .08),
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(action.route);
        },
        borderRadius: AppRadii.lgRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            children: [
              Icon(_actionIcon(action.iconKey), color: color, size: 18),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  action.label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _Disclosure extends StatelessWidget {
  const _Disclosure({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PFraudPreventionPage.disclosureKey,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          _severityLabel(severity),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(String category) {
  return switch (category) {
    'during' => 'Trong giao dịch',
    'after' => 'Sau giao dịch',
    _ => 'Trước giao dịch',
  };
}

String _severityLabel(String severity) {
  return switch (severity) {
    'medium' => 'Trung bình',
    'high' => 'Cao',
    _ => 'Nguy hiểm',
  };
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.buy;
  if (score >= 50) return AppColors.warn;
  return AppColors.sell;
}

Color _severityColor(String severity) {
  return switch (severity) {
    'medium' => AppModuleAccents.p2p,
    'high' => AppColors.warn,
    _ => AppColors.sell,
  };
}

Color _actionColor(String toneKey) {
  return switch (toneKey) {
    'warning' => AppColors.warn,
    'muted' => AppColors.text2,
    _ => AppColors.sell,
  };
}

IconData _patternIcon(String iconKey) {
  return switch (iconKey) {
    'globe' => Icons.public_rounded,
    'bank' => Icons.account_balance_wallet_outlined,
    'user' => Icons.person_off_outlined,
    'triangle' => Icons.report_gmailerrorred_rounded,
    _ => Icons.credit_card_off_outlined,
  };
}

IconData _actionIcon(String iconKey) {
  return switch (iconKey) {
    'phone' => Icons.phone_outlined,
    'flag' => Icons.flag_outlined,
    _ => Icons.shield_outlined,
  };
}
