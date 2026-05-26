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
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PGuidePage extends ConsumerStatefulWidget {
  const P2PGuidePage({super.key, this.shellRenderMode});

  static const tabsKey = Key('sc280_p2p_guide_tabs');
  static const faqListKey = Key('sc280_p2p_guide_faq_list');
  static const buyModeKey = Key('sc280_p2p_guide_buy_mode');
  static const sellModeKey = Key('sc280_p2p_guide_sell_mode');
  static const startKey = Key('sc280_p2p_guide_start');
  static const supportKey = Key('sc280_p2p_guide_support');

  static Key tabKey(String id) => Key('sc280_p2p_guide_tab_$id');
  static Key faqKey(String id) => Key('sc280_p2p_guide_faq_$id');
  static Key videoKey(String id) => Key('sc280_p2p_guide_video_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PGuidePage> createState() => _P2PGuidePageState();
}

class _P2PGuidePageState extends ConsumerState<P2PGuidePage> {
  late String _tab;
  String _mode = 'buy';
  String? _expandedFaqId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getGuide();
    _ensureState(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-280 P2PGuidePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            _GuideTabs(
              tabs: snapshot.tabs,
              active: _tab,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _tab = value);
              },
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
                  child: _GuideBody(
                    snapshot: snapshot,
                    activeTab: _tab,
                    mode: _mode,
                    expandedFaqId: _expandedFaqId,
                    onModeChanged: (value) {
                      HapticFeedback.selectionClick();
                      setState(() => _mode = value);
                    },
                    onFaqToggle: (faqId) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _expandedFaqId = _expandedFaqId == faqId ? null : faqId;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ensureState(P2PGuideSnapshot snapshot) {
    if (_initialized) return;
    _tab = snapshot.defaultTab;
    _expandedFaqId = snapshot.faqItems.isEmpty
        ? null
        : snapshot.faqItems.first.id;
    _initialized = true;
  }
}

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
    return Container(
      key: P2PGuidePage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.contentPad,
        0,
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
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
        Text('Câu hỏi thường gặp', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${snapshot.faqItems.length} câu hỏi',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x5),
        for (var index = 0; index < snapshot.faqItems.length; index++) ...[
          _FaqCard(
            faq: snapshot.faqItems[index],
            expanded: snapshot.faqItems[index].id == expandedFaqId,
            onTap: () => onFaqToggle(snapshot.faqItems[index].id),
          ),
          if (index != snapshot.faqItems.length - 1)
            const SizedBox(height: AppSpacing.x3),
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
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  _RoundIcon(
                    icon: Icons.help_outline_rounded,
                    color: expanded ? AppModuleAccents.p2p : AppColors.text3,
                  ),
                  const SizedBox(width: AppSpacing.x4),
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
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x7,
                0,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: Text(
                faq.answer,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HowItWorksTab extends StatelessWidget {
  const _HowItWorksTab({
    required this.snapshot,
    required this.mode,
    required this.onModeChanged,
  });

  final P2PGuideSnapshot snapshot;
  final String mode;
  final ValueChanged<String> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final steps = mode == 'buy' ? snapshot.buySteps : snapshot.sellSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x1),
          child: Row(
            children: [
              Expanded(
                child: _ModeButton(
                  key: P2PGuidePage.buyModeKey,
                  label: 'Mua Crypto',
                  icon: Icons.account_balance_wallet_outlined,
                  selected: mode == 'buy',
                  color: AppColors.buy,
                  onTap: () => onModeChanged('buy'),
                ),
              ),
              Expanded(
                child: _ModeButton(
                  key: P2PGuidePage.sellModeKey,
                  label: 'Bán Crypto',
                  icon: Icons.description_outlined,
                  selected: mode == 'sell',
                  color: AppColors.sell,
                  onTap: () => onModeChanged('sell'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final step in steps) ...[
          _StepRow(step: step),
          if (step.id != steps.last.id) const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _RoundIcon(icon: Icons.bolt_rounded, color: AppColors.buy),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bắt đầu ngay!', style: AppTextStyles.baseMedium),
                        Text(
                          'Thực hiện giao dịch đầu tiên',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: P2PGuidePage.startKey,
                variant: VitCtaButtonVariant.success,
                onPressed: () => context.go(snapshot.marketRoute),
                child: const Text('Mua crypto ngay'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        _ConceptList(),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.text1 : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.text1 : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final P2PGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.toneKey);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NumberIcon(
          step: step.step,
          icon: _guideIcon(step.iconKey),
          color: color,
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.x1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TonePill(label: 'Bước ${step.step}', color: color),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        step.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetyTab extends StatelessWidget {
  const _SafetyTab({required this.snapshot});

  final P2PGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          borderColor: AppColors.sell20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppColors.sell,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    'An toàn giao dịch',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'VitTrade bảo vệ giao dịch của bạn qua Escrow. Hãy luôn cẩn thận và tuân thủ các nguyên tắc an toàn.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final tip in snapshot.safetyTips) ...[
          _SafetyTipCard(tip: tip),
          const SizedBox(height: AppSpacing.x3),
        ],
        VitCard(
          radius: VitCardRadius.lg,
          borderColor: AppColors.sell20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.sell,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Nghi ngờ lừa đảo?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Nếu bạn nghi ngờ giao dịch có dấu hiệu lừa đảo, hãy mở tranh chấp ngay lập tức. Không giải phóng crypto cho đến khi đã nhận đủ tiền.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                key: P2PGuidePage.supportKey,
                variant: VitCtaButtonVariant.danger,
                onPressed: () => context.go(snapshot.supportRoute),
                child: const Text('Liên hệ hỗ trợ khẩn cấp'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard({required this.tip});

  final P2PGuideTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.toneKey);
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _guideIcon(tip.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoTab extends StatelessWidget {
  const _VideoTab({required this.snapshot});

  final P2PGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Video hướng dẫn', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${snapshot.videos.length} video',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final video in snapshot.videos) ...[
          _VideoCard(video: video),
          const SizedBox(height: AppSpacing.x3),
        ],
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Thêm video đang được cập nhật...',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final P2PGuideVideoDraft video;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(video.toneKey);
    return VitCard(
      key: P2PGuidePage.videoKey(video.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      onTap: HapticFeedback.selectionClick,
      child: Row(
        children: [
          Container(
            width: AppSpacing.x7,
            height: AppSpacing.buttonStandard,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  video.thumb,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: AppSpacing.buttonCompact,
                    height: AppSpacing.buttonCompact,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.text1,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Meta(icon: Icons.schedule_rounded, text: video.duration),
                    _Meta(icon: Icons.visibility_outlined, text: video.views),
                    _TonePill(label: video.level, color: color),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ConceptList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const concepts = [
      (
        'Escrow',
        'Hệ thống ký quỹ tự động khóa crypto cho đến khi giao dịch hoàn tất.',
      ),
      ('Maker', 'Người tạo quảng cáo, đăng offer và được miễn phí giao dịch.'),
      ('Taker', 'Người đặt đơn theo quảng cáo có sẵn, phí 0.1%.'),
      ('KYC', 'Xác minh danh tính để tăng giới hạn giao dịch.'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thuật ngữ quan trọng',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final concept in concepts) ...[
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                children: [
                  TextSpan(
                    text: '${concept.$1}: ',
                    style: const TextStyle(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: concept.$2),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}

class _NumberIcon extends StatelessWidget {
  const _NumberIcon({
    required this.step,
    required this.icon,
    required this.color,
  });

  final int step;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonStandard,
      height: AppSpacing.buttonStandard,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          Positioned(
            right: AppSpacing.x1,
            bottom: AppSpacing.x1,
            child: Text(
              '$step',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Text(text, style: AppTextStyles.micro.copyWith(color: AppColors.text3)),
      ],
    );
  }
}

class _TonePill extends StatelessWidget {
  const _TonePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

IconData _guideIcon(String iconKey) {
  return switch (iconKey) {
    'search' => Icons.search_rounded,
    'payment' => Icons.credit_card_rounded,
    'chat' => Icons.chat_bubble_outline_rounded,
    'wallet' => Icons.account_balance_wallet_outlined,
    'file' => Icons.description_outlined,
    'lock' => Icons.lock_outline_rounded,
    'eye' => Icons.visibility_outlined,
    'check' => Icons.check_circle_outline_rounded,
    'shield' => Icons.shield_outlined,
    'alert' => Icons.report_problem_outlined,
    'users' => Icons.group_outlined,
    _ => Icons.help_outline_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppModuleAccents.p2p,
    _ => AppColors.primary,
  };
}
