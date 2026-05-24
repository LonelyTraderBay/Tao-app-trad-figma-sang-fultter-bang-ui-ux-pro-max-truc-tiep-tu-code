import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

const _arenaAccent = AppModuleAccents.arena;

class ArenaStudioPage extends ConsumerStatefulWidget {
  const ArenaStudioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc185_arena_studio_content');
  static const continueKey = Key('sc185_continue');
  static const saveKey = Key('sc185_save');
  static const exportKey = Key('sc185_export');
  static const importKey = Key('sc185_import');
  static const backStepKey = Key('sc185_back_step');

  static Key templateKey(String id) => Key('sc185_template_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaStudioPage> createState() => _ArenaStudioPageState();
}

class _ArenaStudioPageState extends ConsumerState<ArenaStudioPage> {
  int _step = 1;
  String? _templateId;
  String? _statusLabel;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaStudio();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final stickyBottom =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final bottomInset =
        stickyBottom + AppSpacing.ctaHeight + AppSpacing.x7 + AppSpacing.x6;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-185 ArenaStudioPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'Arena Studio',
              subtitle: 'Tạo challenge mới',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: ArenaStudioPage.contentKey,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        customGap: AppSpacing.x5,
                        children: [
                          _StudioStepper(steps: snapshot.steps, step: _step),
                          _PlatformFeeBanner(
                            platformFeePct: snapshot.platformFeePct,
                          ),
                          _StepBody(
                            step: _step,
                            snapshot: snapshot,
                            selectedTemplateId: _templateId,
                            onTemplateSelected: _selectTemplate,
                          ),
                          _CommunityRulesFooter(
                            trustSignals: snapshot.trustSignals,
                            onTapRules: () =>
                                context.go(AppRoutePaths.arenaSafety),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: stickyBottom,
                    child: _StickyStudioFooter(
                      step: _step,
                      totalSteps: snapshot.steps.length,
                      canContinue: _canContinue,
                      statusLabel: _statusLabel,
                      onBack: _step > 1 ? _backStep : null,
                      onContinue: _continue,
                      onSave: () => _markSecondaryAction('Đã lưu bản nháp'),
                      onExport: () =>
                          _markSecondaryAction('Đã chuẩn bị file xuất'),
                      onImport: () =>
                          _markSecondaryAction('Đã sẵn sàng nhập JSON'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canContinue => _step == 1 ? _templateId != null : true;

  void _selectTemplate(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _templateId = id;
      _statusLabel = null;
    });
  }

  void _continue() {
    if (!_canContinue) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_step < 6) {
        _step += 1;
        _statusLabel = null;
      } else {
        _statusLabel = 'Đã gửi kiểm duyệt';
      }
    });
  }

  void _backStep() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_step > 1) _step -= 1;
      _statusLabel = null;
    });
  }

  void _markSecondaryAction(String label) {
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = label);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _StudioStepper extends StatelessWidget {
  const _StudioStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepMarker(item: steps[i], activeStep: step),
            ),
            if (i != steps.length - 1)
              Container(
                width: AppSpacing.x5,
                height: 2,
                margin: const EdgeInsets.only(bottom: AppSpacing.x5),
                decoration: BoxDecoration(
                  color: steps[i].index < step
                      ? AppColors.buy
                      : AppColors.surface3,
                  borderRadius: AppRadii.xsRadius,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final isDone = item.index < activeStep;
    final isActive = item.index == activeStep;
    final fill = isDone
        ? AppColors.buy
        : isActive
        ? _arenaAccent
        : AppColors.surface2;
    final textColor = isActive || isDone
        ? AppColors.navCenterIcon
        : AppColors.text3;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.warn15 : AppColors.borderSolid,
            ),
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.navCenterIcon,
                  size: 14,
                )
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: textColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: isActive
                ? _arenaAccent
                : isDone
                ? AppColors.buy
                : AppColors.text3,
            fontWeight: AppTextStyles.medium,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _PlatformFeeBanner extends StatefulWidget {
  const _PlatformFeeBanner({required this.platformFeePct});

  final int platformFeePct;

  @override
  State<_PlatformFeeBanner> createState() => _PlatformFeeBannerState();
}

class _PlatformFeeBannerState extends State<_PlatformFeeBanner> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: _arenaAccent,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Phí vận hành platform',
                          style: AppTextStyles.base.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        VitStatusPill(
                          label: '${widget.platformFeePct}%',
                          status: VitStatusPillStatus.orange,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Mọi challenge đều được trích ${widget.platformFeePct}% tổng pool để duy trì hệ thống. Phần này được hiển thị công khai cho tất cả người tham gia.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _expanded = !_expanded);
            },
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: _arenaAccent,
                    size: 13,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    _expanded ? 'Ẩn chi tiết phí' : 'Phí bao gồm những gì?',
                    style: AppTextStyles.micro.copyWith(
                      color: _arenaAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _arenaAccent,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.x2),
            const _FeeDetailRow(
              icon: Icons.verified_user_outlined,
              label: 'Kiểm duyệt tự động',
              value: '3%',
            ),
            const _FeeDetailRow(
              icon: Icons.lock_outline_rounded,
              label: 'Escrow & bảo mật',
              value: '3%',
            ),
            const _FeeDetailRow(
              icon: Icons.balance_outlined,
              label: 'Dispute resolution',
              value: '2%',
            ),
            const _FeeDetailRow(
              icon: Icons.dns_outlined,
              label: 'Hạ tầng & vận hành',
              value: '2%',
            ),
          ],
        ],
      ),
    );
  }
}

class _FeeDetailRow extends StatelessWidget {
  const _FeeDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          Icon(icon, color: _arenaAccent, size: 14),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: _arenaAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.step,
    required this.snapshot,
    required this.selectedTemplateId,
    required this.onTemplateSelected,
  });

  final int step;
  final ArenaStudioSnapshot snapshot;
  final String? selectedTemplateId;
  final ValueChanged<String> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    if (step == 1) {
      return _TemplateStep(
        templates: snapshot.templates,
        selectedTemplateId: selectedTemplateId,
        onTemplateSelected: onTemplateSelected,
      );
    }

    final title = switch (step) {
      2 => 'Cấu trúc trận đấu',
      3 => 'Luật chơi',
      4 => 'Kết quả',
      5 => 'Points',
      _ => 'Review',
    };
    final description = switch (step) {
      2 => 'Chọn format, số slot tối đa và kiểu tham gia trước khi mở room.',
      3 => 'Viết tiêu đề, mô tả, điều kiện thắng và quy tắc xử lý hòa.',
      4 => 'Chọn nguồn kết quả, referee hoặc cơ chế xác nhận cộng đồng.',
      5 => 'Thiết lập entry points, bonus pool và cách chia thưởng.',
      _ => 'Kiểm tra lại phí, luật chơi và boundary Points-only trước khi gửi.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(title: title, accentColor: _arenaAccent),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(
                  _stepIcon(step),
                  color: _arenaAccent,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    const VitStatusPill(
                      label: 'Mock data',
                      status: VitStatusPillStatus.neutral,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _stepIcon(int step) {
    return switch (step) {
      2 => Icons.account_tree_outlined,
      3 => Icons.rule_folder_outlined,
      4 => Icons.fact_check_outlined,
      5 => Icons.toll_outlined,
      _ => Icons.checklist_rtl_rounded,
    };
  }
}

class _TemplateStep extends StatelessWidget {
  const _TemplateStep({
    required this.templates,
    required this.selectedTemplateId,
    required this.onTemplateSelected,
  });

  final List<ArenaStudioTemplateDraft> templates;
  final String? selectedTemplateId;
  final ValueChanged<String> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Chọn template',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            selected: selectedTemplateId == template.id,
            onTap: () => onTemplateSelected(template.id),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final ArenaStudioTemplateDraft template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaStudioPage.templateKey(template.id),
      borderColor: selected ? _arenaAccent : null,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: template.verifiedOnly ? null : onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _templateAccent(template.kind).withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              _templateIcon(template.kind),
              color: _templateAccent(template.kind),
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        template.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: selected ? _arenaAccent : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: _arenaAccent,
                        size: 17,
                      )
                    else if (template.verifiedOnly)
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.text3,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  template.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final tag in template.formatTags)
                      VitStatusPill(
                        label: tag,
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    VitStatusPill(
                      label: template.complexity,
                      status: template.complexity == 'Nâng cao'
                          ? VitStatusPillStatus.error
                          : template.complexity == 'Dễ'
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                    const VitStatusPill(
                      label: 'Points-only',
                      status: VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                    if (template.verifiedOnly)
                      const VitStatusPill(
                        label: 'Verified only',
                        status: VitStatusPillStatus.purple,
                        icon: Icons.lock_outline_rounded,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _templateIcon(ArenaTemplateKind kind) {
    return switch (kind) {
      ArenaTemplateKind.prediction => Icons.track_changes_rounded,
      ArenaTemplateKind.closestGuess => Icons.looks_one_outlined,
      ArenaTemplateKind.teamBattle => Icons.groups_2_outlined,
      ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
      ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
      ArenaTemplateKind.proof => Icons.photo_camera_outlined,
    };
  }

  Color _templateAccent(ArenaTemplateKind kind) {
    return switch (kind) {
      ArenaTemplateKind.prediction => AppColors.accent,
      ArenaTemplateKind.closestGuess => AppColors.primarySoft,
      ArenaTemplateKind.teamBattle => AppColors.sell,
      ArenaTemplateKind.bracket => _arenaAccent,
      ArenaTemplateKind.vote => AppColors.buy,
      ArenaTemplateKind.proof => AppColors.primary,
    };
  }
}

class _CommunityRulesFooter extends StatelessWidget {
  const _CommunityRulesFooter({
    required this.trustSignals,
    required this.onTapRules,
  });

  final List<ArenaTrustSignalDraft> trustSignals;
  final VoidCallback onTapRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: onTapRules,
          icon: const Icon(Icons.menu_book_outlined, size: 16),
          label: const Text('Quy tắc cộng đồng'),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _arenaAccent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          alignment: WrapAlignment.center,
          children: [
            for (final signal in trustSignals)
              VitStatusPill(
                label: signal.value,
                status: VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
          ],
        ),
      ],
    );
  }
}

class _StickyStudioFooter extends StatelessWidget {
  const _StickyStudioFooter({
    required this.step,
    required this.totalSteps,
    required this.canContinue,
    required this.onContinue,
    required this.onSave,
    required this.onExport,
    required this.onImport,
    this.onBack,
    this.statusLabel,
  });

  final int step;
  final int totalSteps;
  final bool canContinue;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final VoidCallback onExport;
  final VoidCallback onImport;
  final VoidCallback? onBack;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x4,
          AppSpacing.x5,
          AppSpacing.x3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (onBack != null) ...[
                  SizedBox(
                    width: AppSpacing.ctaHeight,
                    height: AppSpacing.ctaHeight,
                    child: VitCtaButton(
                      key: ArenaStudioPage.backStepKey,
                      onPressed: onBack,
                      variant: VitCtaButtonVariant.secondary,
                      fullWidth: false,
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                ],
                Expanded(
                  child: VitCtaButton(
                    key: ArenaStudioPage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    fullWidth: true,
                    trailing: Icon(
                      step == totalSteps
                          ? Icons.send_outlined
                          : Icons.chevron_right_rounded,
                    ),
                    child: Text(step == totalSteps ? 'Mở phòng' : 'Tiếp tục'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                _FooterToolButton(
                  key: ArenaStudioPage.saveKey,
                  icon: Icons.save_outlined,
                  label: 'Lưu',
                  onTap: onSave,
                ),
                _FooterToolButton(
                  key: ArenaStudioPage.exportKey,
                  icon: Icons.download_outlined,
                  label: 'Xuất',
                  onTap: onExport,
                ),
                _FooterToolButton(
                  key: ArenaStudioPage.importKey,
                  icon: Icons.upload_outlined,
                  label: 'Nhập',
                  onTap: onImport,
                ),
                const Spacer(),
                if (statusLabel != null) ...[
                  Flexible(
                    child: Text(
                      statusLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  'Bước $step / $totalSteps',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterToolButton extends StatelessWidget {
  const _FooterToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
