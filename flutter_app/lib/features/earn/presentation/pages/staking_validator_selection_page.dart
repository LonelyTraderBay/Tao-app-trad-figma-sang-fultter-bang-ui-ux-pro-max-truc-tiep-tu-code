import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_detail.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_filters.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_list.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/staking_validator_selection_summary.dart';

class StakingValidatorSelectionPage extends ConsumerStatefulWidget {
  const StakingValidatorSelectionPage({super.key, this.shellRenderMode});

  static const infoKey = StakingValidatorSelectionKeys.info;
  static const summaryKey = StakingValidatorSelectionKeys.summary;
  static const searchKey = StakingValidatorSelectionKeys.search;
  static const filterButtonKey = StakingValidatorSelectionKeys.filterButton;
  static const filterPanelKey = StakingValidatorSelectionKeys.filterPanel;
  static const resultCountKey = StakingValidatorSelectionKeys.resultCount;
  static const detailKey = StakingValidatorSelectionKeys.detail;
  static const footerKey = StakingValidatorSelectionKeys.footer;

  static Key validatorKey(String id) =>
      StakingValidatorSelectionKeys.validator(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorSelectionPage> createState() =>
      _StakingValidatorSelectionPageState();
}

class _StakingValidatorSelectionPageState
    extends ConsumerState<StakingValidatorSelectionPage> {
  final _searchController = TextEditingController();
  StakingValidatorSort _sort = StakingValidatorSort.apy;
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
                    StakingValidatorSelectionInfoBanner(snapshot: snapshot),
                    StakingValidatorSelectionStatsSummary(snapshot: snapshot),
                    StakingValidatorSelectionSearchAndFilter(
                      controller: _searchController,
                      filterActive:
                          _showFilters ||
                          _tierFilter != null ||
                          _sort != StakingValidatorSort.apy,
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
                      StakingValidatorSelectionFilterPanel(
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
                    StakingValidatorSelectionResultsHeader(
                      count: validators.length,
                      total: snapshot.validators.length,
                      filtered:
                          validators.length != snapshot.validators.length ||
                          _query.isNotEmpty,
                      sort: _sort,
                      onClear: _clearFilters,
                    ),
                    if (_selected != null)
                      StakingValidatorSelectionDetailCard(
                        key: StakingValidatorSelectionPage.detailKey,
                        validator: _selected!,
                        onClose: () => setState(() => _selected = null),
                      ),
                    StakingValidatorSelectionValidatorList(
                      validators: validators,
                      onTap: (validator) {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = validator);
                      },
                    ),
                    StakingValidatorSelectionFooterNote(snapshot: snapshot),
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
        StakingValidatorSort.apy => b.apy.compareTo(a.apy),
        StakingValidatorSort.uptime => b.uptime.compareTo(a.uptime),
        StakingValidatorSort.commission => a.commission.compareTo(b.commission),
        StakingValidatorSort.staked => b.totalStaked.compareTo(a.totalStaked),
      };
    });
    return result;
  }

  void _clearFilters() {
    HapticFeedback.selectionClick();
    _searchController.clear();
    setState(() {
      _query = '';
      _sort = StakingValidatorSort.apy;
      _tierFilter = null;
      _selected = null;
    });
  }
}
