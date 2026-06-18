import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';

const _editBackground = AppColors.bg;
const _editPrimary = AppColors.primary;
const _editMuted = AppColors.text3;

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc157_edit_profile_content');
  static const cameraKey = Key('sc157_edit_profile_camera');
  static const fullNameFieldKey = Key('sc157_edit_profile_full_name');
  static const phoneFieldKey = Key('sc157_edit_profile_phone');
  static const saveKey = Key('sc157_edit_profile_save');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _saving = false;
  bool _cameraSelected = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(profileControllerProvider).getEditProfile();
    _nameController = TextEditingController(text: snapshot.user.fullName);
    _emailController = TextEditingController(text: snapshot.user.email);
    _phoneController = TextEditingController(text: snapshot.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getEditProfile();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.profileEditBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  AppSpacing.profileEditBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-157 EditProfilePage',
      child: Material(
        color: _editBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
            subtitle: 'Ch\u1EC9nh s\u1EEDa \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: EditProfilePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.profileEditScrollPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: AppSpacing.zero,
                    fullBleed: true,
                    children: [
                      VitCard(
                        padding: AppSpacing.zeroInsets,
                        child: _AvatarEditor(
                          initial: snapshot.user.fullName.substring(0, 1),
                          selected: _cameraSelected,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _cameraSelected = !_cameraSelected);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.profileEditAvatarFormGap,
                      ),
                      VitCard(
                        padding: AppSpacing.zeroInsets,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _EditProfileField(
                              label: 'H\u1ECC V\u00C0 T\u00CAN',
                              controller: _nameController,
                              keyValue: EditProfilePage.fullNameFieldKey,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(
                              height: AppSpacing.profileEditFieldGap,
                            ),
                            _EditProfileField(
                              label: 'EMAIL',
                              controller: _emailController,
                              readOnly: true,
                              note:
                                  'Email kh\u00F4ng th\u1EC3 thay \u0111\u1ED5i',
                              muted: true,
                            ),
                            const SizedBox(
                              height: AppSpacing.profileEditFieldGap,
                            ),
                            _EditProfileField(
                              label: 'S\u1ED0 \u0110I\u1EC6N THO\u1EA0I',
                              controller: _phoneController,
                              keyValue: EditProfilePage.phoneFieldKey,
                              keyboardType: TextInputType.phone,
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.profileEditFieldGap),
                      KeyedSubtree(
                        key: EditProfilePage.saveKey,
                        child: VitCtaButton(
                          variant: VitCtaButtonVariant.auth,
                          loading: _saving,
                          onPressed: _canSave ? _save : null,
                          leading: const Icon(Icons.save_rounded),
                          child: Text(
                            _saving
                                ? '\u0110ang l\u01B0u...'
                                : 'L\u01B0u thay \u0111\u1ED5i',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.profileEditRiskGap),
                      const VitCard(
                        padding: AppSpacing.zeroInsets,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Review profile changes',
                          message:
                              'Confirm name, phone number, avatar change, and account notification details before saving.',
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

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      !_saving;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    _close();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.initial,
    required this.selected,
    required this.onTap,
  });

  final String initial;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            VitAssetAvatar(
              label: initial,
              accentColor: _editPrimary,
              size: AppSpacing.profileEditAvatarSize,
              radius: AppRadii.cardLargeRadius,
              border: true,
            ),
            Positioned(
              right: AppSpacing.profileEditCameraOffsetEnd,
              bottom: AppSpacing.profileEditCameraOffsetBottom,
              child: VitIconButton(
                key: EditProfilePage.cameraKey,
                icon: selected
                    ? Icons.check_rounded
                    : Icons.photo_camera_outlined,
                tooltip: 'Change avatar',
                onPressed: onTap,
                variant: selected
                    ? VitIconButtonVariant.success
                    : VitIconButtonVariant.primary,
                size: VitIconButtonSize.sm,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.profileEditAvatarCaptionGap),
        Text(
          'Nh\u1EA5n v\u00E0o bi\u1EC3u t\u01B0\u1EE3ng camera \u0111\u1EC3 thay \u0111\u1ED5i',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: _editMuted,
            height: AppSpacing.profileEditAvatarCaptionLineHeight,
          ),
        ),
      ],
    );
  }
}

class _EditProfileField extends StatelessWidget {
  const _EditProfileField({
    required this.label,
    required this.controller,
    this.keyValue,
    this.note,
    this.readOnly = false,
    this.muted = false,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final Key? keyValue;
  final String? note;
  final bool readOnly;
  final bool muted;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.heavy,
            height: AppSpacing.profileEditTightLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.profileEditFieldLabelGap),
        VitInput(
          fieldKey: keyValue,
          controller: controller,
          semanticLabel: label,
          enabled: !readOnly,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.profileEditFieldNoteGap),
          Text(
            note!,
            style: AppTextStyles.micro.copyWith(
              color: _editMuted,
              height: AppSpacing.profileEditTightLineHeight,
            ),
          ),
        ],
      ],
    );
  }
}
