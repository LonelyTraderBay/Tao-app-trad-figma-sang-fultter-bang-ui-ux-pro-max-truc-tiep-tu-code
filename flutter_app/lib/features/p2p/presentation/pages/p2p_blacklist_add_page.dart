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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PBlacklistAddPage extends ConsumerStatefulWidget {
  const P2PBlacklistAddPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc276_p2p_blacklist_add_hero');
  static const usernameKey = Key('sc276_p2p_blacklist_add_username');
  static const noteKey = Key('sc276_p2p_blacklist_add_note');
  static const warningKey = Key('sc276_p2p_blacklist_add_warning');
  static const submitKey = Key('sc276_p2p_blacklist_add_submit');

  static Key reasonKey(String id) => Key('sc276_p2p_blacklist_add_reason_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PBlacklistAddPage> createState() =>
      _P2PBlacklistAddPageState();
}

class _P2PBlacklistAddPageState extends ConsumerState<P2PBlacklistAddPage> {
  final _usernameController = TextEditingController();
  final _noteController = TextEditingController();
  String _reasonId = 'scam';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(P2PBlacklistAddSnapshot snapshot) async {
    if (_usernameController.text.trim().isEmpty || _isSubmitting) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    context.go(snapshot.blacklistRoute);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pBlacklistAddProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final canSubmit =
        _usernameController.text.trim().isNotEmpty && !_isSubmitting;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-276 P2PBlacklistAddPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _Hero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        VitInput(
                          controller: _usernameController,
                          fieldKey: P2PBlacklistAddPage.usernameKey,
                          label: snapshot.usernameLabel,
                          hintText: snapshot.usernameHint,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        _ReasonSelector(
                          reasons: snapshot.reasons,
                          selectedReasonId: _reasonId,
                          onChanged: (id) {
                            HapticFeedback.selectionClick();
                            setState(() => _reasonId = id);
                          },
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        _NoteField(
                          controller: _noteController,
                          label: snapshot.noteLabel,
                          hint: snapshot.noteHint,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _WarningCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x3),
                        VitCtaButton(
                          key: P2PBlacklistAddPage.submitKey,
                          variant: VitCtaButtonVariant.danger,
                          loading: _isSubmitting,
                          onPressed: canSubmit ? () => _submit(snapshot) : null,
                          leading: const Icon(Icons.block_rounded),
                          child: Text(snapshot.submitLabel),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: EdgeInsets.all(AppSpacing.x3),
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Blacklist action review',
                            message:
                                'Username, reason, note, warning, submitting state and undo/support next step are reviewed before blocking a merchant.',
                            contractId: 'p2p-blacklist-add-review',
                          ),
                        ),
                      ],
                    ),
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

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final P2PBlacklistAddSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PBlacklistAddPage.heroKey,
      children: [
        Container(
          width: AppSpacing.buttonStandard,
          height: AppSpacing.buttonStandard,
          decoration: BoxDecoration(
            color: AppColors.sell10,
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(
            Icons.person_remove_alt_1_outlined,
            color: AppColors.sell,
            size: AppSpacing.iconLg,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          snapshot.heroTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle.copyWith(fontSize: 24, height: 1.1),
        ),
        const SizedBox(height: AppSpacing.x3),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            snapshot.heroSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({
    required this.reasons,
    required this.selectedReasonId,
    required this.onChanged,
  });

  final List<P2PBlacklistReasonDraft> reasons;
  final String selectedReasonId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lý do chặn *',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final reason in reasons) ...[
          _ReasonTile(
            reason: reason,
            selected: reason.id == selectedReasonId,
            onTap: () => onChanged(reason.id),
          ),
          if (reason != reasons.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final P2PBlacklistReasonDraft reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason.toneKey);
    return Material(
      key: P2PBlacklistAddPage.reasonKey(reason.id),
      color: selected ? color.withValues(alpha: .08) : AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: .46)
                  : AppColors.borderSolid,
              width: 1.5,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Icon(
                  _reasonIcon(reason.iconKey),
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  reason.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: selected ? color : AppColors.text2,
                    fontWeight: selected
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
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

class _NoteField extends StatelessWidget {
  const _NoteField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            border: Border.all(color: AppColors.borderSolid, width: 1.5),
            borderRadius: AppRadii.inputRadius,
          ),
          child: TextField(
            key: P2PBlacklistAddPage.noteKey,
            controller: controller,
            minLines: null,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.primary,
            style: AppTextStyles.body.copyWith(fontSize: 14),
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.text3,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.snapshot});

  final P2PBlacklistAddSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PBlacklistAddPage.warningKey,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              snapshot.warning,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _reasonIcon(String iconKey) {
  return switch (iconKey) {
    'alert' => Icons.report_problem_outlined,
    'clock' => Icons.schedule_rounded,
    'ban' => Icons.block_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'info' => Icons.info_outline_rounded,
    _ => Icons.block_rounded,
  };
}

Color _reasonColor(String toneKey) {
  return switch (toneKey) {
    'danger' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    _ => AppColors.text3,
  };
}
