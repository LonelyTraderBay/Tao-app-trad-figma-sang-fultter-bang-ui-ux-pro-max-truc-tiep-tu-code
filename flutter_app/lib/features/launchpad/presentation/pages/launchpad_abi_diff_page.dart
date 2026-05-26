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

class LaunchpadAbiDiffPage extends ConsumerStatefulWidget {
  const LaunchpadAbiDiffPage({
    super.key,
    this.contractId = 'contract001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc308_launchpad_abi_diff_content');
  static const heroKey = Key('sc308_launchpad_abi_diff_hero');
  static const statsKey = Key('sc308_launchpad_abi_diff_stats');
  static const metadataKey = Key('sc308_launchpad_abi_diff_metadata');
  static const functionsOnlyKey = Key(
    'sc308_launchpad_abi_diff_functions_only',
  );
  static const entriesKey = Key('sc308_launchpad_abi_diff_entries');
  static const warningKey = Key('sc308_launchpad_abi_diff_warning');

  static Key statKey(String value) =>
      Key('sc308_launchpad_abi_diff_stat_$value');
  static Key entryKey(String name) =>
      Key('sc308_launchpad_abi_diff_entry_$name');
  static Key expandKey(String name) =>
      Key('sc308_launchpad_abi_diff_expand_$name');
  static Key copyKey(String label) =>
      Key('sc308_launchpad_abi_diff_copy_$label');

  final String contractId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadAbiDiffPage> createState() =>
      _LaunchpadAbiDiffPageState();
}

class _LaunchpadAbiDiffPageState extends ConsumerState<LaunchpadAbiDiffPage> {
  LaunchpadAbiChangeType? _filter;
  var _functionsOnly = false;
  String? _expandedEntry;
  String? _copiedField;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(launchpadRepositoryProvider)
        .getAbiDiff(widget.contractId);
    final diff = snapshot.diff;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final entries = _filteredEntries(diff.entries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-308 LaunchpadABIDiffPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadAbiDiffPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      _RiskHero(diff: diff),
                      _SummaryStats(
                        diff: diff,
                        activeFilter: _filter,
                        onChanged: (filter) => setState(() {
                          _filter = _filter == filter ? null : filter;
                        }),
                      ),
                      _UpgradeMetadata(
                        diff: diff,
                        copiedField: _copiedField,
                        onCopy: _copyField,
                      ),
                      _FilterRow(
                        active: _functionsOnly,
                        count: entries.length,
                        onChanged: () =>
                            setState(() => _functionsOnly = !_functionsOnly),
                      ),
                      VitPageSection(
                        label: 'ABI Changes',
                        accentColor: AppColors.accent,
                        children: [
                          Column(
                            key: LaunchpadAbiDiffPage.entriesKey,
                            children: [
                              for (final entry in entries) ...[
                                _AbiEntryCard(
                                  entry: entry,
                                  expanded: _expandedEntry == entry.name,
                                  onToggle: () => setState(() {
                                    _expandedEntry =
                                        _expandedEntry == entry.name
                                        ? null
                                        : entry.name;
                                  }),
                                ),
                                if (entry != entries.last)
                                  const SizedBox(height: AppSpacing.x3),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const _RiskWarning(),
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

  List<LaunchpadAbiDiffEntryDraft> _filteredEntries(
    List<LaunchpadAbiDiffEntryDraft> entries,
  ) {
    return entries.where((entry) {
      if (_filter != null && entry.changeType != _filter) {
        return false;
      }
      if (_functionsOnly && entry.type != 'function') {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _copyField(String label, String value) async {
    setState(() => _copiedField = label);
    try {
      await Clipboard.setData(ClipboardData(text: value));
    } catch (_) {
      // Test and embedded shells can omit platform clipboard support.
    }
  }
}

class _RiskHero extends StatelessWidget {
  const _RiskHero({required this.diff});

  final LaunchpadAbiDiffResultDraft diff;

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskScoreColor(diff.riskScore);
    return VitCard(
      key: LaunchpadAbiDiffPage.heroKey,
      variant: VitCardVariant.hero,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_tree_outlined,
                color: AppColors.portfolioTextMuted,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Proxy Upgrade Detected',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _RiskScoreRing(score: diff.riskScore, color: riskColor),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Score',
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Trung binh - Co thay doi dang chu y',
                      style: AppTextStyles.caption.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ImplCard(
                  label: 'OLD',
                  title: diff.oldImplLabel,
                  address: _truncateAddress(diff.oldImpl),
                  color: AppColors.sell,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.x3),
                child: Icon(
                  Icons.bolt_rounded,
                  color: AppColors.portfolioTextMuted,
                  size: 16,
                ),
              ),
              Expanded(
                child: _ImplCard(
                  label: 'NEW',
                  title: diff.newImplLabel,
                  address: _truncateAddress(diff.newImpl),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskScoreRing extends StatelessWidget {
  const _RiskScoreRing({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
        color: color.withValues(alpha: .08),
      ),
      child: Text(
        '$score',
        style: AppTextStyles.base.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _ImplCard extends StatelessWidget {
  const _ImplCard({
    required this.label,
    required this.title,
    required this.address,
    required this.color,
  });

  final String label;
  final String title;
  final String address;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .18)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color == AppColors.buy ? color : AppColors.text1,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            address,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({
    required this.diff,
    required this.activeFilter,
    required this.onChanged,
  });

  final LaunchpadAbiDiffResultDraft diff;
  final LaunchpadAbiChangeType? activeFilter;
  final ValueChanged<LaunchpadAbiChangeType> onChanged;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (LaunchpadAbiChangeType.added, diff.added),
      (LaunchpadAbiChangeType.removed, diff.removed),
      (LaunchpadAbiChangeType.modified, diff.modified),
      (LaunchpadAbiChangeType.unchanged, diff.unchanged),
    ];
    return Row(
      key: LaunchpadAbiDiffPage.statsKey,
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: VitCard(
              onTap: () => onChanged(stat.$1),
              borderColor: activeFilter == stat.$1
                  ? stat.$1.color.withValues(alpha: .42)
                  : null,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x2,
                vertical: AppSpacing.x3,
              ),
              child: Column(
                key: LaunchpadAbiDiffPage.statKey(stat.$1.value),
                children: [
                  Icon(stat.$1.icon, color: stat.$1.color, size: 16),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    '${stat.$2}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: FontWeight.w900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    stat.$1.label,
                    style: AppTextStyles.micro.copyWith(
                      color: stat.$1.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (stat != stats.last) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _UpgradeMetadata extends StatelessWidget {
  const _UpgradeMetadata({
    required this.diff,
    required this.copiedField,
    required this.onCopy,
  });

  final LaunchpadAbiDiffResultDraft diff;
  final String? copiedField;
  final void Function(String label, String value) onCopy;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetaRowData(
        'Contract',
        _truncateAddress(diff.contractAddress),
        diff.contractAddress,
      ),
      _MetaRowData('Chain', diff.chain, null),
      _MetaRowData('Block', '#${_formatInt(diff.upgradeBlock)}', null),
      _MetaRowData('Thoi gian', diff.upgradeTimestamp, null),
      _MetaRowData(
        'Tx Hash',
        _truncateAddress(diff.upgradeTxHash),
        diff.upgradeTxHash,
      ),
      _MetaRowData(
        'Functions',
        '${diff.totalFunctionsOld} -> ${diff.totalFunctionsNew}',
        null,
      ),
      _MetaRowData(
        'Events',
        '${diff.totalEventsOld} -> ${diff.totalEventsNew}',
        null,
      ),
    ];
    return VitCard(
      key: LaunchpadAbiDiffPage.metadataKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_rounded, color: AppColors.accent, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thong tin upgrade',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows)
            _MetaRow(
              row: row,
              copied: copiedField == row.label,
              onCopy: row.copyValue == null
                  ? null
                  : () => onCopy(row.label, row.copyValue!),
            ),
        ],
      ),
    );
  }
}

class _MetaRowData {
  const _MetaRowData(this.label, this.value, this.copyValue);

  final String label;
  final String value;
  final String? copyValue;
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.row, required this.copied, this.onCopy});

  final _MetaRowData row;
  final bool copied;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w900,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (onCopy != null) ...[
            const SizedBox(width: AppSpacing.x1),
            InkWell(
              key: LaunchpadAbiDiffPage.copyKey(row.label),
              borderRadius: AppRadii.xsRadius,
              onTap: onCopy,
              child: Icon(
                copied ? Icons.check_rounded : Icons.copy_rounded,
                color: copied ? AppColors.buy : AppColors.text3,
                size: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.active,
    required this.count,
    required this.onChanged,
  });

  final bool active;
  final int count;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          key: LaunchpadAbiDiffPage.functionsOnlyKey,
          borderRadius: AppRadii.inputRadius,
          onTap: onChanged,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            decoration: BoxDecoration(
              color: active ? AppColors.primary12 : AppColors.surface2,
              border: Border.all(
                color: active ? AppColors.primary30 : AppColors.cardBorder,
              ),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.code_rounded,
                  color: active ? AppModuleAccents.launchpad : AppColors.text3,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  'Functions only',
                  style: AppTextStyles.caption.copyWith(
                    color: active
                        ? AppModuleAccents.launchpad
                        : AppColors.text3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text(
          '$count entries',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _AbiEntryCard extends StatelessWidget {
  const _AbiEntryCard({
    required this.entry,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadAbiDiffEntryDraft entry;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final change = entry.changeType;
    final risk = entry.riskLevel;
    return VitCard(
      key: LaunchpadAbiDiffPage.entryKey(entry.name),
      padding: EdgeInsets.zero,
      clip: true,
      borderColor: change.color.withValues(alpha: .30),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 3, color: change.color),
          ),
          Column(
            children: [
              InkWell(
                key: LaunchpadAbiDiffPage.expandKey(entry.name),
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChangeIcon(change: change),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    entry.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.base.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x2),
                                _SmallBadge(
                                  label: entry.type,
                                  color: AppColors.text3,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Wrap(
                              spacing: AppSpacing.x1,
                              runSpacing: AppSpacing.x1,
                              children: [
                                _SmallBadge(
                                  label: change.label.toUpperCase(),
                                  color: change.color,
                                ),
                                if (risk != LaunchpadAbiRiskLevel.none)
                                  _SmallBadge(
                                    label: risk.label,
                                    color: risk.color,
                                    icon: risk.icon,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.text3,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              if (expanded) _AbiEntryDetails(entry: entry),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangeIcon extends StatelessWidget {
  const _ChangeIcon({required this.change});

  final LaunchpadAbiChangeType change;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: change.color.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(change.icon, color: change.color, size: 16),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 10),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbiEntryDetails extends StatelessWidget {
  const _AbiEntryDetails({required this.entry});

  final LaunchpadAbiDiffEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.oldSignature != null)
            _SignatureBlock(
              label: 'Old signature',
              value: entry.oldSignature!,
              color: entry.changeType == LaunchpadAbiChangeType.removed
                  ? AppColors.sell
                  : AppColors.text2,
            ),
          if (entry.newSignature != null)
            _SignatureBlock(
              label: 'New signature',
              value: entry.newSignature!,
              color: entry.changeType == LaunchpadAbiChangeType.added
                  ? AppColors.buy
                  : AppColors.text1,
            ),
          if (entry.oldVisibility != null || entry.newVisibility != null)
            _DetailLine(
              label: 'Visibility',
              value: _compareText(entry.oldVisibility, entry.newVisibility),
            ),
          if (entry.oldStateMutability != null ||
              entry.newStateMutability != null)
            _DetailLine(
              label: 'State mutability',
              value: _compareText(
                entry.oldStateMutability,
                entry.newStateMutability,
              ),
            ),
          if (entry.riskNote != null)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.x2),
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: entry.riskLevel.color.withValues(alpha: .08),
                border: Border.all(
                  color: entry.riskLevel.color.withValues(alpha: .18),
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    entry.riskLevel.icon,
                    color: entry.riskLevel.color,
                    size: 14,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      entry.riskNote!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.35,
                      ),
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

class _SignatureBlock extends StatelessWidget {
  const _SignatureBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.x2),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadAbiDiffPage.warningKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warn15),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Day la so sanh ABI tu dong. Can kiem tra source code thuc te de hieu day du anh huong cua cac thay doi.',
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

extension _AbiChangeUi on LaunchpadAbiChangeType {
  String get value {
    return switch (this) {
      LaunchpadAbiChangeType.added => 'added',
      LaunchpadAbiChangeType.removed => 'removed',
      LaunchpadAbiChangeType.modified => 'modified',
      LaunchpadAbiChangeType.unchanged => 'unchanged',
    };
  }

  String get label {
    return switch (this) {
      LaunchpadAbiChangeType.added => 'Added',
      LaunchpadAbiChangeType.removed => 'Removed',
      LaunchpadAbiChangeType.modified => 'Modified',
      LaunchpadAbiChangeType.unchanged => 'Unchanged',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadAbiChangeType.added => AppColors.buy,
      LaunchpadAbiChangeType.removed => AppColors.sell,
      LaunchpadAbiChangeType.modified => AppColors.warn,
      LaunchpadAbiChangeType.unchanged => AppColors.text2,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadAbiChangeType.added => Icons.add_rounded,
      LaunchpadAbiChangeType.removed => Icons.remove_rounded,
      LaunchpadAbiChangeType.modified => Icons.sync_rounded,
      LaunchpadAbiChangeType.unchanged => Icons.check_rounded,
    };
  }
}

extension _AbiRiskUi on LaunchpadAbiRiskLevel {
  String get label {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => 'None',
      LaunchpadAbiRiskLevel.low => 'Low',
      LaunchpadAbiRiskLevel.medium => 'Medium',
      LaunchpadAbiRiskLevel.high => 'High',
      LaunchpadAbiRiskLevel.critical => 'Critical',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => AppColors.text2,
      LaunchpadAbiRiskLevel.low => AppColors.buy,
      LaunchpadAbiRiskLevel.medium => AppColors.warn,
      LaunchpadAbiRiskLevel.high => AppColors.sell,
      LaunchpadAbiRiskLevel.critical => AppColors.sell,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => Icons.shield_outlined,
      LaunchpadAbiRiskLevel.low => Icons.verified_user_outlined,
      LaunchpadAbiRiskLevel.medium => Icons.shield_outlined,
      LaunchpadAbiRiskLevel.high => Icons.gpp_maybe_outlined,
      LaunchpadAbiRiskLevel.critical => Icons.gpp_bad_outlined,
    };
  }
}

Color _riskScoreColor(int score) {
  if (score >= 80) return AppColors.sell;
  if (score >= 60) return AppColors.warn;
  if (score >= 40) return AppColors.accent;
  return AppColors.buy;
}

String _truncateAddress(String value) {
  if (value.length <= 14) return value;
  return '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
}

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _compareText(String? oldValue, String? newValue) {
  if (oldValue == null) return newValue ?? '-';
  if (newValue == null || oldValue == newValue) return oldValue;
  return '$oldValue -> $newValue';
}
