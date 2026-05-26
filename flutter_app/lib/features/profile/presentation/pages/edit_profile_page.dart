import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';

const _editBackground = AppColors.bg;
const _editPanel = AppColors.surface;
const _editPanel2 = AppColors.surface2;
const _editBorder = AppColors.borderSolid;
const _editPrimary = AppColors.primary;
const _editPurple = AppColors.primaryDark;
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
    final snapshot = const MockProfileRepository().getEditProfile();
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
    final snapshot = ref.watch(profileRepositoryProvider).getEditProfile();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 42
            : DeviceMetrics.nativeBottomChrome + 24) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-157 EditProfilePage',
      child: Material(
        color: _editBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1',
              subtitle: 'Ch\u1EC9nh s\u1EEDa \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: EditProfilePage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 36, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AvatarEditor(
                      initial: snapshot.user.fullName.substring(0, 1),
                      selected: _cameraSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _cameraSelected = !_cameraSelected);
                      },
                    ),
                    const SizedBox(height: 52),
                    _EditProfileField(
                      label: 'H\u1ECC V\u00C0 T\u00CAN',
                      controller: _nameController,
                      keyValue: EditProfilePage.fullNameFieldKey,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    _EditProfileField(
                      label: 'EMAIL',
                      controller: _emailController,
                      readOnly: true,
                      note: 'Email kh\u00F4ng th\u1EC3 thay \u0111\u1ED5i',
                      muted: true,
                    ),
                    const SizedBox(height: 18),
                    _EditProfileField(
                      label: 'S\u1ED0 \u0110I\u1EC6N THO\u1EA0I',
                      controller: _phoneController,
                      keyValue: EditProfilePage.phoneFieldKey,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
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
                  ],
                ),
              ),
            ),
          ],
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
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppRadii.cardLargeRadius,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_editPrimary, _editPurple],
                ),
              ),
              child: Text(
                initial,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              right: -1,
              bottom: 1,
              child: GestureDetector(
                key: EditProfilePage.cameraKey,
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.buy : _editPrimary,
                    borderRadius: AppRadii.mdRadius,
                    border: Border.all(color: _editBackground, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    selected
                        ? Icons.check_rounded
                        : Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Nh\u1EA5n v\u00E0o bi\u1EC3u t\u01B0\u1EE3ng camera \u0111\u1EC3 thay \u0111\u1ED5i',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: _editMuted,
            fontSize: 12,
            height: 1.1,
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
            fontSize: 12,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: muted ? _editPanel : _editPanel2,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: _editBorder, width: 1.2),
          ),
          alignment: Alignment.center,
          child: TextField(
            key: keyValue,
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onChanged: onChanged,
            cursorColor: _editPrimary,
            style: AppTextStyles.baseMedium.copyWith(
              color: muted ? _editMuted : AppColors.text1,
              fontSize: 15,
              height: 1,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 7),
          Text(
            note!,
            style: AppTextStyles.micro.copyWith(
              color: _editMuted,
              fontSize: 11,
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}
