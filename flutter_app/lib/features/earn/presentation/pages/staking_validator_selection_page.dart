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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

enum _ValidatorSort { apy, uptime, commission, staked }

class StakingValidatorSelectionPage extends ConsumerStatefulWidget {
  const StakingValidatorSelectionPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc362_info_banner');
  static const summaryKey = Key('sc362_summary_card');
  static const searchKey = Key('sc362_search_field');
  static const filterButtonKey = Key('sc362_filter_button');
  static const filterPanelKey = Key('sc362_filter_panel');
  static const resultCountKey = Key('sc362_result_count');
  static const detailKey = Key('sc362_detail_card');
  static const footerKey = Key('sc362_footer_note');

  static Key validatorKey(String id) => Key('sc362_validator_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorSelectionPage> createState() =>
      _StakingValidatorSelectionPageState();
}

class _StakingValidatorSelectionPageState
    extends ConsumerState<StakingValidatorSelectionPage> {
  final _searchController = TextEditingController();
  _ValidatorSort _sort = _ValidatorSort.apy;
  StakingValidatorTier? _tierFilter;
  String _query = '';
  bool _showFilters = false;
  StakingValidatorDraft? _selected;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingValidatorSelectionRepositoryProvider)
        .getSelection();
    final validators = _filtered(snapshot.validators);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-362 StakingValidatorSelectionPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _StatsSummary(snapshot: snapshot),
                    _SearchAndFilter(
                      controller: _searchController,
                      filterActive:
                          _showFilters ||
                          _tierFilter != null ||
                          _sort != _ValidatorSort.apy,
                      onQueryChanged: (query) => setState(() {
                        _query = query;
                        _selected = null;
                      }),
                      onFilter: () {
                        HapticFeedback.selectionClick();
                        setState(() => _showFilters = !_showFilters);
                      },
                    ),
                    if (_showFilters)
                      _FilterPanel(
                        key: StakingValidatorSelectionPage.filterPanelKey,
                        sort: _sort,
                        tier: _tierFilter,
                        onSortChanged: (sort) {
                          HapticFeedback.selectionClick();
                          setState(() => _sort = sort);
                        },
                        onTierChanged: (tier) {
                          HapticFeedback.selectionClick();
                          setState(() => _tierFilter = tier);
                        },
                        onClear: _clearFilters,
                      ),
                    _ResultsHeader(
                      count: validators.length,
                      total: snapshot.validators.length,
                      filtered:
                          validators.length != snapshot.validators.length ||
                          _query.isNotEmpty,
                      sort: _sort,
                      onClear: _clearFilters,
                    ),
                    if (_selected != null)
                      _ValidatorDetailCard(
                        key: StakingValidatorSelectionPage.detailKey,
                        validator: _selected!,
                        onClose: () => setState(() => _selected = null),
                      ),
                    _ValidatorList(
                      validators: validators,
                      onTap: (validator) {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = validator);
                      },
                    ),
                    _FooterNote(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StakingValidatorDraft> _filtered(
    List<StakingValidatorDraft> validators,
  ) {
    final query = _query.trim().toLowerCase();
    final result = [
      for (final validator in validators)
        if ((_tierFilter == null || validator.tier == _tierFilter) &&
            (query.isEmpty ||
                validator.name.toLowerCase().contains(query) ||
                validator.address.toLowerCase().contains(query)))
          validator,
    ];

    result.sort((a, b) {
      return switch (_sort) {
        _ValidatorSort.apy => b.apy.compareTo(a.apy),
        _ValidatorSort.uptime => b.uptime.compareTo(a.uptime),
        _ValidatorSort.commission => a.commission.compareTo(b.commission),
        _ValidatorSort.staked => b.totalStaked.compareTo(a.totalStaked),
      };
    });
    return result;
  }

  void _clearFilters() {
    HapticFeedback.selectionClick();
    _searchController.clear();
    setState(() {
      _query = '';
      _sort = _ValidatorSort.apy;
      _tierFilter = null;
      _selected = null;
    });
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorSelectionPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
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

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({required this.snapshot});

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final top = snapshot.validators.reduce((a, b) => a.apy >= b.apy ? a : b);
    final avgCommission =
        snapshot.validators.fold<double>(
          0,
          (sum, item) => sum + item.commission,
        ) /
        snapshot.validators.length;
    final avgUptime =
        snapshot.validators.fold<double>(0, (sum, item) => sum + item.uptime) /
        snapshot.validators.length;

    return VitCard(
      key: StakingValidatorSelectionPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              icon: Icons.trending_up_rounded,
              label: 'APY tốt nhất',
              value: '${top.apy.toStringAsFixed(2)}%',
              detail: top.name,
              color: AppColors.buy,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              icon: Icons.schedule_rounded,
              label: 'Uptime TB',
              value: '${avgUptime.toStringAsFixed(2)}%',
              detail: '',
              color: AppColors.primarySoft,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryMetric(
              icon: Icons.group_outlined,
              label: 'Commission TB',
              value: '${avgCommission.toStringAsFixed(1)}%',
              detail: '',
              color: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        if (detail.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({
    required this.controller,
    required this.filterActive,
    required this.onQueryChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool filterActive;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: AppRadii.xlRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.text3,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: TextField(
                      key: StakingValidatorSelectionPage.searchKey,
                      controller: controller,
                      onChanged: onQueryChanged,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'Tìm validator...',
                        hintStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Material(
          color: filterActive ? AppColors.primary : AppColors.surface3,
          borderRadius: AppRadii.xlRadius,
          child: InkWell(
            key: StakingValidatorSelectionPage.filterButtonKey,
            onTap: onFilter,
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: AppSpacing.buttonStandard,
              height: AppSpacing.buttonStandard,
              child: Icon(
                Icons.filter_alt_outlined,
                color: filterActive ? AppColors.onAccent : AppColors.text1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    super.key,
    required this.sort,
    required this.tier,
    required this.onSortChanged,
    required this.onTierChanged,
    required this.onClear,
  });

  final _ValidatorSort sort;
  final StakingValidatorTier? tier;
  final ValueChanged<_ValidatorSort> onSortChanged;
  final ValueChanged<StakingValidatorTier?> onTierChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc & Sắp xếp',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              TextButton(onPressed: onClear, child: const Text('Xóa')),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Sắp xếp theo',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final value in _ValidatorSort.values)
                _FilterChip(
                  label: _sortLabel(value),
                  selected: sort == value,
                  onTap: () => onSortChanged(value),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Tier',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _FilterChip(
                label: 'Tất cả',
                selected: tier == null,
                onTap: () => onTierChanged(null),
              ),
              for (final value in StakingValidatorTier.values)
                _FilterChip(
                  label: _tierLabel(value),
                  selected: tier == value,
                  onTap: () => onTierChanged(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primarySoft : AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.total,
    required this.filtered,
    required this.sort,
    required this.onClear,
  });

  final int count;
  final int total;
  final bool filtered;
  final _ValidatorSort sort;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            filtered
                ? '$count validators (đã lọc từ $total)'
                : '$count validators',
            key: StakingValidatorSelectionPage.resultCountKey,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        if (filtered)
          TextButton(onPressed: onClear, child: const Text('Xóa'))
        else
          Text(
            'Sắp xếp: ${_sortShortLabel(sort)}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _ValidatorList extends StatelessWidget {
  const _ValidatorList({required this.validators, required this.onTap});

  final List<StakingValidatorDraft> validators;
  final ValueChanged<StakingValidatorDraft> onTap;

  @override
  Widget build(BuildContext context) {
    if (validators.isEmpty) {
      return const VitEmptyState(
        icon: Icons.shield_outlined,
        title: 'Không tìm thấy validator',
        message: 'Điều chỉnh bộ lọc hoặc từ khóa để xem validator phù hợp.',
      );
    }

    return Column(
      children: [
        for (var i = 0; i < validators.length; i++) ...[
          _ValidatorCard(
            key: StakingValidatorSelectionPage.validatorKey(validators[i].id),
            validator: validators[i],
            onTap: () => onTap(validators[i]),
          ),
          if (i != validators.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ValidatorCard extends StatelessWidget {
  const _ValidatorCard({
    super.key,
    required this.validator,
    required this.onTap,
  });

  final StakingValidatorDraft validator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _validatorAccent(validator);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ValidatorAvatar(validator: validator, accent: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            validator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (validator.verified) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.buy,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        _TierPill(tier: validator.tier),
                        if (validator.slashingHistory == 0)
                          const _StatusPill(
                            label: 'No Slashing',
                            color: AppColors.buy,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${validator.apy.toStringAsFixed(2)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _ValidatorMetric(
                  label: 'Commission',
                  value: '${validator.commission.toStringAsFixed(0)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Uptime',
                  value: '${validator.uptime.toStringAsFixed(2)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Delegators',
                  value: '${(validator.delegators / 1000).round()}k',
                ),
              ),
            ],
          ),
          if (validator.slashingHistory > 0) ...[
            const SizedBox(height: AppSpacing.x3),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.sell10,
                borderRadius: AppRadii.mdRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.sell,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        '${validator.slashingHistory} slashing event(s) in history',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.medium,
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

class _ValidatorAvatar extends StatelessWidget {
  const _ValidatorAvatar({required this.validator, required this.accent});

  final StakingValidatorDraft validator;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.buttonStandard,
        height: AppSpacing.buttonStandard,
        child: Center(
          child: validator.id == 'v7'
              ? Text(
                  'US',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                )
              : Icon(_validatorIcon(validator), color: accent, size: 24),
        ),
      ),
    );
  }
}

class _ValidatorMetric extends StatelessWidget {
  const _ValidatorMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierPill extends StatelessWidget {
  const _TierPill({required this.tier});

  final StakingValidatorTier tier;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(tier);
    return _StatusPill(label: _tierLabel(tier), color: color);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: 3,
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

class _ValidatorDetailCard extends StatelessWidget {
  const _ValidatorDetailCard({
    super.key,
    required this.validator,
    required this.onClose,
  });

  final StakingValidatorDraft validator;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chi tiết Validator',
                  style: AppTextStyles.baseMedium,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(validator.name, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.x1),
          Text(
            validator.address,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            validator.description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final feature in validator.features)
                _StatusPill(label: feature, color: AppColors.primarySoft),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () {},
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: const Text('Chọn Validator này'),
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Text(
              'Khi chọn validator riêng, bạn chịu rủi ro slashing nếu validator vi phạm. Ưu tiên validator Top Tier hoặc Recommended.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.snapshot});

  final StakingValidatorSelectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorSelectionPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        snapshot.footerNote,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: 1.5,
        ),
      ),
    );
  }
}

String _sortLabel(_ValidatorSort sort) {
  return switch (sort) {
    _ValidatorSort.apy => 'APY cao nhất',
    _ValidatorSort.uptime => 'Uptime cao nhất',
    _ValidatorSort.commission => 'Phí thấp nhất',
    _ValidatorSort.staked => 'Stake nhiều nhất',
  };
}

String _sortShortLabel(_ValidatorSort sort) {
  return switch (sort) {
    _ValidatorSort.apy => 'APY cao',
    _ValidatorSort.uptime => 'Uptime cao',
    _ValidatorSort.commission => 'Phí thấp',
    _ValidatorSort.staked => 'Stake nhiều',
  };
}

String _tierLabel(StakingValidatorTier tier) {
  return switch (tier) {
    StakingValidatorTier.top => 'Top Tier',
    StakingValidatorTier.recommended => 'Recommended',
    StakingValidatorTier.standard => 'Standard',
  };
}

Color _tierColor(StakingValidatorTier tier) {
  return switch (tier) {
    StakingValidatorTier.top => AppColors.buy,
    StakingValidatorTier.recommended => AppColors.primarySoft,
    StakingValidatorTier.standard => AppColors.text3,
  };
}

Color _validatorAccent(StakingValidatorDraft validator) {
  return switch (validator.id) {
    'v1' => AppColors.primarySoft,
    'v2' => AppColors.accent,
    'v3' => AppColors.primary,
    'v4' => AppColors.accent,
    'v5' => AppColors.text2,
    'v6' => AppColors.warn,
    _ => AppColors.text2,
  };
}

IconData _validatorIcon(StakingValidatorDraft validator) {
  return switch (validator.id) {
    'v1' => Icons.diamond_rounded,
    'v2' => Icons.security_rounded,
    'v3' => Icons.bolt_rounded,
    'v4' => Icons.music_note_rounded,
    'v5' => Icons.link_rounded,
    'v6' => Icons.wb_sunny_rounded,
    _ => Icons.shield_outlined,
  };
}
