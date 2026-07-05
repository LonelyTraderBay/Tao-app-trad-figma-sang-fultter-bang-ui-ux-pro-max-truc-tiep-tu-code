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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

const _p2pVideoVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const _p2pVideoNativeNavClearance = _p2pVideoVisualNavClearance - AppSpacing.x4;
const _p2pVideoVisualClearance = AppSpacing.x3;
const _p2pVideoNativeClearance = AppSpacing.x2;
const _p2pVideoMajorGap = AppSpacing.x3;
const _p2pVideoSectionGap = AppSpacing.x2;
const _p2pVideoTightGap = AppSpacing.x1;
const _p2pVideoIconBox = AppSpacing.searchBarCompactHeight;

class P2PVideoVerificationPage extends ConsumerStatefulWidget {
  const P2PVideoVerificationPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc252_p2p_video_hero');
  static const preparationKey = Key('sc252_p2p_video_preparation');
  static const slotsKey = Key('sc252_p2p_video_slots');
  static Key slotKey(String id) => Key('sc252_p2p_video_slot_$id');
  static const submitKey = Key('sc252_p2p_video_submit');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PVideoVerificationPage> createState() =>
      _P2PVideoVerificationPageState();
}

class _P2PVideoVerificationPageState
    extends ConsumerState<P2PVideoVerificationPage> {
  String? _selectedSlotId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pVideoVerificationProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pVideoVisualNavClearance + _p2pVideoVisualClearance
            : _p2pVideoNativeNavClearance + _p2pVideoNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-252 P2PVideoVerificationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Xác minh video',
            subtitle: 'KYC · P2P',
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
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.p2pVideoScrollPadding(scrollEndPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _VideoHero(snapshot: snapshot),
                        const SizedBox(height: _p2pVideoMajorGap),
                        _PreparationCard(snapshot: snapshot),
                        const SizedBox(height: _p2pVideoMajorGap),
                        _SlotPicker(
                          slots: snapshot.timeSlots,
                          selectedSlotId: _selectedSlotId,
                          onSelected: (slot) {
                            if (!slot.available) return;
                            HapticFeedback.selectionClick();
                            setState(() => _selectedSlotId = slot.id);
                          },
                        ),
                        const SizedBox(height: _p2pVideoMajorGap),
                        VitCtaButton(
                          key: P2PVideoVerificationPage.submitKey,
                          onPressed: _selectedSlotId == null
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  context.go(snapshot.statusRoute);
                                },
                          trailing: const Icon(Icons.chevron_right_rounded),
                          child: const Text('Đặt lịch'),
                        ),
                        const SizedBox(height: _p2pVideoSectionGap),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: AppSpacing.p2pVideoCompactCardPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Video verification review',
                            message:
                                'Preparation checklist, slot availability, selected time, verification status route and next KYC step are reviewed before booking.',
                            contractId: 'p2p-video-verification-review',
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

class _VideoHero extends StatelessWidget {
  const _VideoHero({required this.snapshot});

  final P2PVideoVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PVideoVerificationPage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: AppSpacing.p2pVideoCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Material(
            color: AppColors.primary15,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
              side: BorderSide(color: AppColors.primary20),
            ),
            child: SizedBox(
              width: _p2pVideoIconBox,
              height: _p2pVideoIconBox,
              child: Icon(
                Icons.videocam_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: _p2pVideoMajorGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitleXs.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: _p2pVideoTightGap),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.p2pComplianceReadableLineHeight,
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

class _PreparationCard extends StatelessWidget {
  const _PreparationCard({required this.snapshot});

  final P2PVideoVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PVideoVerificationPage.preparationKey,
      radius: VitCardRadius.standard,
      padding: AppSpacing.p2pVideoCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'Chuẩn bị',
            iconColor: AppModuleAccents.p2p,
            accentColor: AppModuleAccents.p2p,
          ),
          const SizedBox(height: _p2pVideoSectionGap),
          for (final item in snapshot.preparationItems) ...[
            _ChecklistRow(text: item),
            if (item != snapshot.preparationItems.last)
              const SizedBox(height: _p2pVideoTightGap),
          ],
        ],
      ),
    );
  }
}

class _SlotPicker extends StatelessWidget {
  const _SlotPicker({
    required this.slots,
    required this.selectedSlotId,
    required this.onSelected,
  });

  final List<P2PVideoTimeSlotDraft> slots;
  final String? selectedSlotId;
  final ValueChanged<P2PVideoTimeSlotDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PVideoVerificationPage.slotsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn khung giờ',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pVideoSectionGap),
        for (final slot in slots) ...[
          _SlotCard(
            slot: slot,
            selected: selectedSlotId == slot.id,
            onTap: () => onSelected(slot),
          ),
          if (slot != slots.last) const SizedBox(height: _p2pVideoSectionGap),
        ],
      ],
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final P2PVideoTimeSlotDraft slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: slot.available ? 1 : .48,
      child: VitCard(
        key: P2PVideoVerificationPage.slotKey(slot.id),
        radius: VitCardRadius.large,
        variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
        borderColor: selected ? AppColors.primary20 : AppColors.borderSolid,
        padding: AppSpacing.p2pVideoCardPadding,
        onTap: slot.available ? onTap : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: _p2pVideoSectionGap),
                Expanded(
                  child: Text(
                    slot.date,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: selected ? AppModuleAccents.p2p : AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: _p2pVideoSectionGap),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: _p2pVideoSectionGap),
                Expanded(
                  child: Text(
                    slot.time,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                if (!slot.available)
                  const VitStatusPill(
                    label: 'Hết chỗ',
                    status: VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppSpacing.p2pComplianceChecklistIconPadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.p2pComplianceChecklistIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppSpacing.p2pComplianceReadableLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}
