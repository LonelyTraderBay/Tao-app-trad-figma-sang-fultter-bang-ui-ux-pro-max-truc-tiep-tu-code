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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

class LaunchpadNotifSoundPage extends ConsumerStatefulWidget {
  const LaunchpadNotifSoundPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc306_launchpad_notif_sound_content');
  static const heroKey = Key('sc306_launchpad_notif_sound_hero');
  static const quickTogglesKey = Key('sc306_launchpad_notif_sound_quick');
  static const categoriesKey = Key('sc306_launchpad_notif_sound_categories');
  static const dndKey = Key('sc306_launchpad_notif_sound_dnd');
  static const infoKey = Key('sc306_launchpad_notif_sound_info');
  static const footerKey = Key('sc306_launchpad_notif_sound_footer');
  static const saveKey = Key('sc306_launchpad_notif_sound_save');

  static Key categoryKey(String id) =>
      Key('sc306_launchpad_notif_sound_category_$id');
  static Key toggleKey(String id) =>
      Key('sc306_launchpad_notif_sound_toggle_$id');
  static Key expandKey(String id) =>
      Key('sc306_launchpad_notif_sound_expand_$id');
  static Key previewKey(String id) =>
      Key('sc306_launchpad_notif_sound_preview_$id');
  static Key soundTypeKey(String id, String type) =>
      Key('sc306_launchpad_notif_sound_type_${id}_$type');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadNotifSoundPage> createState() =>
      _LaunchpadNotifSoundPageState();
}

class _LaunchpadNotifSoundPageState
    extends ConsumerState<LaunchpadNotifSoundPage> {
  var _initialized = false;
  var _masterEnabled = true;
  var _masterVolume = 80.0;
  var _vibrate = true;
  var _doNotDisturb = false;
  var _dndStartHour = 22;
  var _dndEndHour = 7;
  var _hasChanges = false;
  var _saved = false;
  String? _expandedCategoryId;
  String? _playingPreviewId;
  final Map<String, _CategoryState> _categories = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getNotifSound();
    _ensureState(snapshot);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerHeight = _saved ? 118.0 : 92.0;
    final bottomInset =
        navInset + MediaQuery.paddingOf(context).bottom + footerHeight;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-306 LaunchpadNotifSoundPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadNotifSoundPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        _MasterSoundHero(
                          masterEnabled: _masterEnabled,
                          volume: _masterVolume,
                          onToggle: () => _markChanged(() {
                            _masterEnabled = !_masterEnabled;
                          }),
                          onVolumeChanged: (value) => _markChanged(() {
                            _masterVolume = value;
                          }),
                        ),
                        _QuickTogglesCard(
                          vibrate: _vibrate,
                          doNotDisturb: _doNotDisturb,
                          dndStartHour: _dndStartHour,
                          dndEndHour: _dndEndHour,
                          onVibrate: () => _markChanged(() {
                            _vibrate = !_vibrate;
                          }),
                          onDoNotDisturb: () => _markChanged(() {
                            _doNotDisturb = !_doNotDisturb;
                          }),
                        ),
                        if (_doNotDisturb)
                          _DndScheduleCard(
                            startHour: _dndStartHour,
                            endHour: _dndEndHour,
                            onStartChanged: (value) => _markChanged(() {
                              _dndStartHour = value;
                            }),
                            onEndChanged: (value) => _markChanged(() {
                              _dndEndHour = value;
                            }),
                          ),
                        _CategorySoundSection(
                          snapshot: snapshot,
                          masterEnabled: _masterEnabled,
                          categories: _categories,
                          expandedCategoryId: _expandedCategoryId,
                          playingPreviewId: _playingPreviewId,
                          onToggleCategory: _toggleCategory,
                          onExpandCategory: (id) => setState(() {
                            _expandedCategoryId = _expandedCategoryId == id
                                ? null
                                : id;
                          }),
                          onSoundType: _setSoundType,
                          onVolume: _setCategoryVolume,
                          onPreview: _previewSound,
                        ),
                        const _InfoBanner(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: navInset + MediaQuery.paddingOf(context).bottom,
              child: _SaveFooter(
                saved: _saved,
                hasChanges: _hasChanges,
                onSave: _hasChanges || _saved ? _save : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ensureState(LaunchpadNotifSoundSnapshot snapshot) {
    if (_initialized) return;
    _masterEnabled = snapshot.masterEnabled;
    _masterVolume = snapshot.masterVolume.toDouble();
    _vibrate = snapshot.vibrate;
    _doNotDisturb = snapshot.doNotDisturb;
    _dndStartHour = snapshot.dndStartHour;
    _dndEndHour = snapshot.dndEndHour;
    for (final category in snapshot.categories) {
      _categories[category.id] = _CategoryState(
        enabled: category.enabled,
        soundType: category.soundType,
        volume: category.volume.toDouble(),
      );
    }
    _initialized = true;
  }

  void _markChanged(VoidCallback update) {
    HapticFeedback.selectionClick();
    setState(() {
      update();
      _hasChanges = true;
      _saved = false;
    });
  }

  void _toggleCategory(String id) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(enabled: !state.enabled);
    });
  }

  void _setSoundType(String id, String soundType) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(soundType: soundType);
    });
  }

  void _setCategoryVolume(String id, double volume) {
    _markChanged(() {
      final state = _categories[id];
      if (state == null) return;
      _categories[id] = state.copyWith(volume: volume);
    });
  }

  void _previewSound(String id) {
    HapticFeedback.selectionClick();
    setState(() => _playingPreviewId = id);
  }

  void _save() {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasChanges = false;
      _saved = true;
    });
  }
}

final class _CategoryState {
  const _CategoryState({
    required this.enabled,
    required this.soundType,
    required this.volume,
  });

  final bool enabled;
  final String soundType;
  final double volume;

  _CategoryState copyWith({bool? enabled, String? soundType, double? volume}) {
    return _CategoryState(
      enabled: enabled ?? this.enabled,
      soundType: soundType ?? this.soundType,
      volume: volume ?? this.volume,
    );
  }
}

class _MasterSoundHero extends StatelessWidget {
  const _MasterSoundHero({
    required this.masterEnabled,
    required this.volume,
    required this.onToggle,
    required this.onVolumeChanged,
  });

  final bool masterEnabled;
  final double volume;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBubble(
                icon: masterEnabled
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                accent: masterEnabled
                    ? AppModuleAccents.launchpad
                    : AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Âm thanh tổng',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      masterEnabled ? 'Đang bật' : 'Đã tắt',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                  ],
                ),
              ),
              _SoundSwitch(
                key: LaunchpadNotifSoundPage.toggleKey('master'),
                enabled: masterEnabled,
                onTap: onToggle,
              ),
            ],
          ),
          if (masterEnabled) ...[
            const SizedBox(height: AppSpacing.x5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Âm lượng tổng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextDim,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '${volume.round()}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppModuleAccents.launchpad,
                inactiveTrackColor: AppColors.surface3,
                thumbColor: AppModuleAccents.launchpad,
                overlayColor: AppColors.primary12,
                trackHeight: 4,
              ),
              child: Slider(
                value: volume,
                min: 0,
                max: 100,
                onChanged: onVolumeChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickTogglesCard extends StatelessWidget {
  const _QuickTogglesCard({
    required this.vibrate,
    required this.doNotDisturb,
    required this.dndStartHour,
    required this.dndEndHour,
    required this.onVibrate,
    required this.onDoNotDisturb,
  });

  final bool vibrate;
  final bool doNotDisturb;
  final int dndStartHour;
  final int dndEndHour;
  final VoidCallback onVibrate;
  final VoidCallback onDoNotDisturb;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.quickTogglesKey,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          _QuickToggleRow(
            id: 'vibrate',
            icon: Icons.vibration_rounded,
            accent: AppColors.accent,
            label: 'Rung',
            description: 'Rung kèm âm thanh thông báo',
            enabled: vibrate,
            onTap: onVibrate,
          ),
          const Divider(color: AppColors.divider, height: 1),
          _QuickToggleRow(
            id: 'dnd',
            icon: Icons.nightlight_round,
            accent: AppColors.warn,
            label: 'Không làm phiền',
            description: doNotDisturb
                ? '$dndStartHour:00 - $dndEndHour:00'
                : 'Tắt âm thanh theo lịch',
            enabled: doNotDisturb,
            onTap: onDoNotDisturb,
          ),
        ],
      ),
    );
  }
}

class _QuickToggleRow extends StatelessWidget {
  const _QuickToggleRow({
    required this.id,
    required this.icon,
    required this.accent,
    required this.label,
    required this.description,
    required this.enabled,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final Color accent;
  final String label;
  final String description;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBubble(icon: icon, accent: accent, small: true),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SoundSwitch(
            key: LaunchpadNotifSoundPage.toggleKey(id),
            enabled: enabled,
            onTap: onTap,
            small: true,
          ),
        ],
      ),
    );
  }
}

class _DndScheduleCard extends StatelessWidget {
  const _DndScheduleCard({
    required this.startHour,
    required this.endHour,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  final int startHour;
  final int endHour;
  final ValueChanged<int> onStartChanged;
  final ValueChanged<int> onEndChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.dndKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Lịch không làm phiền',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _HourSelector(
                  label: 'Từ',
                  value: startHour,
                  onChanged: onStartChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HourSelector(
                  label: 'Đến',
                  value: endHour,
                  onChanged: onEndChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HourSelector extends StatelessWidget {
  const _HourSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      dropdownColor: AppColors.surface2,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
        filled: true,
        fillColor: AppColors.surface2,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputRadius,
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputRadius,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      items: [
        for (var hour = 0; hour < 24; hour++)
          DropdownMenuItem(value: hour, child: Text(_hourLabel(hour))),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _CategorySoundSection extends StatelessWidget {
  const _CategorySoundSection({
    required this.snapshot,
    required this.masterEnabled,
    required this.categories,
    required this.expandedCategoryId,
    required this.playingPreviewId,
    required this.onToggleCategory,
    required this.onExpandCategory,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundSnapshot snapshot;
  final bool masterEnabled;
  final Map<String, _CategoryState> categories;
  final String? expandedCategoryId;
  final String? playingPreviewId;
  final ValueChanged<String> onToggleCategory;
  final ValueChanged<String> onExpandCategory;
  final void Function(String id, String soundType) onSoundType;
  final void Function(String id, double volume) onVolume;
  final ValueChanged<String> onPreview;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: LaunchpadNotifSoundPage.categoriesKey,
      label: 'Âm thanh theo loại',
      accentColor: AppModuleAccents.launchpad,
      children: [
        Column(
          children: [
            for (var i = 0; i < snapshot.categories.length; i++) ...[
              _CategoryCard(
                category: snapshot.categories[i],
                soundTypes: snapshot.soundTypes,
                state: categories[snapshot.categories[i].id]!,
                masterEnabled: masterEnabled,
                expanded: expandedCategoryId == snapshot.categories[i].id,
                playingPreview: playingPreviewId == snapshot.categories[i].id,
                onToggle: () => onToggleCategory(snapshot.categories[i].id),
                onExpand: () => onExpandCategory(snapshot.categories[i].id),
                onSoundType: (soundType) =>
                    onSoundType(snapshot.categories[i].id, soundType),
                onVolume: (value) => onVolume(snapshot.categories[i].id, value),
                onPreview: () => onPreview(snapshot.categories[i].id),
              ),
              if (i != snapshot.categories.length - 1)
                const SizedBox(height: AppSpacing.x3),
            ],
          ],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.soundTypes,
    required this.state,
    required this.masterEnabled,
    required this.expanded,
    required this.playingPreview,
    required this.onToggle,
    required this.onExpand,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundCategoryDraft category;
  final List<LaunchpadSoundTypeDraft> soundTypes;
  final _CategoryState state;
  final bool masterEnabled;
  final bool expanded;
  final bool playingPreview;
  final VoidCallback onToggle;
  final VoidCallback onExpand;
  final ValueChanged<String> onSoundType;
  final ValueChanged<double> onVolume;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final enabled = state.enabled && masterEnabled;
    return VitCard(
      key: LaunchpadNotifSoundPage.categoryKey(category.id),
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                _IconBubble(
                  icon: _categoryIcon(category.iconKey),
                  accent: category.accent,
                  small: true,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        category.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                _SoundSwitch(
                  key: LaunchpadNotifSoundPage.toggleKey(category.id),
                  enabled: enabled,
                  onTap: onToggle,
                  small: true,
                ),
                const SizedBox(width: AppSpacing.x2),
                InkWell(
                  key: LaunchpadNotifSoundPage.expandKey(category.id),
                  onTap: onExpand,
                  borderRadius: AppRadii.smRadius,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.x1),
                    child: Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedCategorySettings(
              category: category,
              soundTypes: soundTypes,
              state: state,
              playingPreview: playingPreview,
              onSoundType: onSoundType,
              onVolume: onVolume,
              onPreview: onPreview,
            ),
        ],
      ),
    );
  }
}

class _ExpandedCategorySettings extends StatelessWidget {
  const _ExpandedCategorySettings({
    required this.category,
    required this.soundTypes,
    required this.state,
    required this.playingPreview,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundCategoryDraft category;
  final List<LaunchpadSoundTypeDraft> soundTypes;
  final _CategoryState state;
  final bool playingPreview;
  final ValueChanged<String> onSoundType;
  final ValueChanged<double> onVolume;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x3,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kiểu âm thanh',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final soundType in soundTypes)
                _SoundTypeChip(
                  categoryId: category.id,
                  soundType: soundType,
                  active: state.soundType == soundType.value,
                  accent: category.accent,
                  onTap: () => onSoundType(soundType.value),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Âm lượng',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${state.volume.round()}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: category.accent,
              inactiveTrackColor: AppColors.surface2,
              thumbColor: category.accent,
              overlayColor: category.accent.withValues(alpha: .12),
              trackHeight: 4,
            ),
            child: Slider(
              value: state.volume,
              min: 0,
              max: 100,
              onChanged: onVolume,
            ),
          ),
          InkWell(
            key: LaunchpadNotifSoundPage.previewKey(category.id),
            onTap: onPreview,
            borderRadius: AppRadii.inputRadius,
            child: Container(
              height: AppSpacing.ctaHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                children: [
                  Icon(
                    playingPreview
                        ? Icons.check_circle_outline_rounded
                        : Icons.play_arrow_rounded,
                    color: playingPreview ? AppColors.buy : category.accent,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    playingPreview ? 'Đang phát...' : 'Nghe thử',
                    style: AppTextStyles.caption.copyWith(
                      color: playingPreview ? AppColors.buy : AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  if (playingPreview) ...[
                    const Spacer(),
                    for (var i = 0; i < 4; i++)
                      Container(
                        width: 3,
                        height: 8 + i * 2,
                        margin: const EdgeInsets.only(left: AppSpacing.x1),
                        decoration: BoxDecoration(
                          color: category.accent,
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundTypeChip extends StatelessWidget {
  const _SoundTypeChip({
    required this.categoryId,
    required this.soundType,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final String categoryId;
  final LaunchpadSoundTypeDraft soundType;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadNotifSoundPage.soundTypeKey(categoryId, soundType.value),
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: .12) : AppColors.surface2,
          border: Border.all(
            color: active
                ? accent.withValues(alpha: .35)
                : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          soundType.label,
          style: AppTextStyles.micro.copyWith(
            color: active ? accent : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadNotifSoundPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.launchpad,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Âm thanh chỉ phát khi ứng dụng đang hoạt động. Thông báo push ngoài app sử dụng cài đặt hệ thống thiết bị.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveFooter extends StatelessWidget {
  const _SaveFooter({
    required this.saved,
    required this.hasChanges,
    required this.onSave,
  });

  final bool saved;
  final bool hasChanges;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return VitStickyFooter(
      key: LaunchpadNotifSoundPage.footerKey,
      backgroundColor: AppColors.surface.withValues(alpha: .94),
      child: Column(
        children: [
          if (saved) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Đã lưu cài đặt',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          VitCtaButton(
            key: LaunchpadNotifSoundPage.saveKey,
            onPressed: onSave,
            leading: const Icon(Icons.notifications_none_rounded),
            child: Text(
              saved
                  ? 'Lưu cài đặt âm thanh'
                  : hasChanges
                  ? 'Lưu cài đặt âm thanh'
                  : 'Lưu cài đặt âm thanh',
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundSwitch extends StatelessWidget {
  const _SoundSwitch({
    super.key,
    required this.enabled,
    required this.onTap,
    this.small = false,
  });

  final bool enabled;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final width = small ? 38.0 : 46.0;
    final height = small ? 22.0 : 26.0;
    final knob = small ? 18.0 : 22.0;
    return Semantics(
      button: true,
      toggled: enabled,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: width,
          height: height,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: enabled ? AppModuleAccents.launchpad : AppColors.surface3,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(
              color: enabled
                  ? AppModuleAccents.launchpad
                  : AppColors.borderSolid,
            ),
          ),
          child: Align(
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knob,
              height: knob,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.accent,
    this.small = false,
  });

  final IconData icon;
  final Color accent;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? AppSpacing.x6 : AppSpacing.x7;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .12),
        borderRadius: small ? AppRadii.mdRadius : AppRadii.lgRadius,
      ),
      child: Icon(
        icon,
        color: accent,
        size: small ? AppSpacing.iconSm : AppSpacing.iconMd,
      ),
    );
  }
}

IconData _categoryIcon(String iconKey) {
  return switch (iconKey) {
    'chart' => Icons.query_stats_rounded,
    'check' => Icons.check_box_rounded,
    'unlock' => Icons.lock_open_rounded,
    'bridge' => Icons.compare_arrows_rounded,
    'gift' => Icons.card_giftcard_rounded,
    'shield' => Icons.shield_outlined,
    'chat' => Icons.chat_bubble_outline_rounded,
    'settings' => Icons.settings_rounded,
    _ => Icons.notifications_none_rounded,
  };
}

String _hourLabel(int hour) {
  return '${hour.toString().padLeft(2, '0')}:00';
}
