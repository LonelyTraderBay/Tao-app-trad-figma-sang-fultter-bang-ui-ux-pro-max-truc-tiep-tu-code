import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

const _walletPanel = AppColors.surface;
const _walletPanel2 = AppColors.surface2;
const _walletHero = AppColors.surface;
const _walletPrimary = AppColors.primary;
const _walletGreen = AppColors.buy;
const _walletRed = AppColors.sell;
const _walletAmber = AppColors.caution;
const _walletPurple = AppColors.accent;

class WalletBalanceHero extends StatelessWidget {
  const WalletBalanceHero({
    super.key,
    required this.snapshot,
    required this.hidden,
    required this.onToggle,
    required this.onNavigate,
  });

  final WalletSnapshot snapshot;
  final bool hidden;
  final VoidCallback onToggle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 324,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 17),
      decoration: BoxDecoration(
        color: _walletHero,
        border: Border.all(color: _walletPrimary.withValues(alpha: .20)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tài sản ước tính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              GestureDetector(
                key: const Key('sc135_wallet_balance_toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: onToggle,
                child: Icon(
                  hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.text2,
                  size: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hidden ? '••••••' : _formatUsd(snapshot.totalUsd),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 31,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hidden
                ? '•••••• BTC'
                : '≈ ${snapshot.totalBtc.toStringAsFixed(8)} BTC',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              height: 1,
            ),
          ),
          const SizedBox(height: 19),
          _BreakdownRow(snapshot: snapshot, hidden: hidden),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < snapshot.actions.length; i++) ...[
                Expanded(
                  child: _ActionTile(
                    action: snapshot.actions[i],
                    onTap: () => onNavigate(snapshot.actions[i].route),
                  ),
                ),
                if (i != snapshot.actions.length - 1) const SizedBox(width: 12),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.snapshot, required this.hidden});

  final WalletSnapshot snapshot;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Khả dụng',
        snapshot.availableUsd,
        _walletGreen,
        Icons.visibility_outlined,
      ),
      ('Trong lệnh', snapshot.inOrderUsd, _walletAmber, Icons.flag_rounded),
      ('Đóng băng', snapshot.frozenUsd, _walletRed, Icons.lock_outline_rounded),
    ];
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onAccent.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(items[i].$4, color: items[i].$3, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          items[i].$1,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hidden ? '••••' : _formatUsd(items[i].$2),
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 11,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'Roboto',
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1) const SizedBox(width: 2),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final WalletAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(action.colorHex);
    return GestureDetector(
      key: Key('sc135_wallet_action_${action.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.onAccent.withValues(alpha: .10),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              child: Icon(_actionIcon(action.iconKey), color: color, size: 22),
            ),
            const SizedBox(height: 7),
            Text(
              action.label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletDcaCard extends StatelessWidget {
  const WalletDcaCard({super.key, required this.dca});

  final WalletDcaSnapshot dca;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 268,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _walletPanel2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.onAccent.withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _IconCircle(
                icon: Icons.sync_alt_rounded,
                color: _walletPurple,
                size: 37,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            dca.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontSize: 18,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _walletGreen.withValues(alpha: .12),
                            borderRadius: AppRadii.mdRadius,
                          ),
                          child: Text(
                            dca.returnLabel,
                            style: AppTextStyles.micro.copyWith(
                              color: _walletGreen,
                              fontSize: 11,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dca.subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const _IconCircle(
                icon: Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 34,
                muted: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.sync_alt_rounded,
                  iconColor: _walletPurple,
                  label: 'Kế hoạch đang chạy',
                  value: dca.activePlans.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.trending_up_rounded,
                  iconColor: _walletPrimary,
                  label: 'Đã đầu tư',
                  value: _formatVnd(dca.invested),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
            decoration: BoxDecoration(
              color: _walletPanel,
              border: Border.all(
                color: AppColors.onAccent.withValues(alpha: .24),
              ),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                _IconCircle(
                  icon: Icons.schedule_rounded,
                  color: _walletAmber,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Giao dịch tiếp theo',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        dca.nextTrade,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          fontFamily: 'Roboto',
                          height: 1,
                        ),
                      ),
                    ],
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

class _DcaStatCard extends StatelessWidget {
  const _DcaStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _IconCircle(icon: icon, color: iconColor, size: 35),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
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

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
    required this.size,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final double size;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: muted
            ? AppColors.dynamicIslandBg.withValues(alpha: .16)
            : color.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * .56),
    );
  }
}

class WalletToolGrid extends StatelessWidget {
  const WalletToolGrid({
    super.key,
    required this.tools,
    required this.onNavigate,
  });

  final List<WalletTool> tools;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                Expanded(
                  child: _ToolButton(
                    tool: tools[row * 2 + col],
                    onTap: () => onNavigate(tools[row * 2 + col].route),
                  ),
                ),
                if (col == 0) const SizedBox(width: 8),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.tool, required this.onTap});

  final WalletTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(tool.colorHex);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: _walletPanel2,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          children: [
            Icon(_toolIcon(tool.iconKey), color: color, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tool.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletSegmentedTabs extends StatelessWidget {
  const WalletSegmentedTabs({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [('assets', 'Danh sách'), ('chart', 'Phân bổ')];
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _walletPanel2,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: GestureDetector(
                key: Key('sc135_wallet_tab_${tab.$1}'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(tab.$1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active == tab.$1
                        ? _walletPrimary
                        : AppColors.transparent,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    tab.$2,
                    style: AppTextStyles.caption.copyWith(
                      color: active == tab.$1
                          ? AppColors.onAccent
                          : AppColors.text3,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WalletSearchAndFilter extends StatelessWidget {
  const WalletSearchAndFilter({
    super.key,
    required this.controller,
    required this.filterActive,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool filterActive;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: _walletPanel2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: const Key('sc135_wallet_search'),
                    controller: controller,
                    onChanged: onChanged,
                    cursorColor: _walletPrimary,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Tìm tài sản...',
                      hintStyle: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 9),
        GestureDetector(
          key: const Key('sc135_wallet_filter'),
          behavior: HitTestBehavior.opaque,
          onTap: onFilter,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filterActive ? _walletPrimary : _walletPanel2,
              border: Border.all(color: AppColors.borderSolid),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: filterActive ? AppColors.onAccent : AppColors.text3,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}

class WalletAssetHeader extends StatelessWidget {
  const WalletAssetHeader({
    super.key,
    required this.count,
    required this.onNavigate,
  });

  final int count;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count tài sản',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _HeaderButton(
          label: 'Sổ địa chỉ',
          foreground: AppColors.text2,
          background: _walletPanel2,
          onTap: () => onNavigate('/wallet/address-book'),
        ),
        const SizedBox(width: 8),
        _HeaderButton(
          label: 'Phân tích',
          foreground: _walletPrimary,
          background: _walletPrimary.withValues(alpha: .12),
          onTap: () => onNavigate('/wallet/portfolio-analytics'),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: foreground.withValues(alpha: .22)),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: foreground,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class WalletAssetList extends StatelessWidget {
  const WalletAssetList({
    super.key,
    required this.assets,
    required this.hidden,
    required this.onNavigate,
  });

  final List<WalletAsset> assets;
  final bool hidden;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _walletPanel,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          'Không tìm thấy tài sản',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _walletPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++)
            _AssetRow(
              asset: assets[i],
              hidden: hidden,
              last: i == assets.length - 1,
              onTap: () => onNavigate('/wallet/asset/${assets[i].id}'),
            ),
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.hidden,
    required this.last,
    required this.onTap,
  });

  final WalletAsset asset;
  final bool hidden;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    final changeColor = asset.change24h >= 0 ? _walletGreen : _walletRed;
    return GestureDetector(
      key: Key('sc135_wallet_asset_${asset.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: last
                ? BorderSide.none
                : const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: .45)),
              ),
              child: Text(
                asset.symbol.length > 3
                    ? asset.symbol.substring(0, 3)
                    : asset.symbol,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          asset.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 14,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _formatPct(asset.change24h),
                          style: AppTextStyles.micro.copyWith(
                            color: changeColor,
                            fontSize: 10,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset.name,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hidden ? '••••' : _formatAssetAmount(asset.balance),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hidden ? '••••' : '≈ ${_formatUsd(asset.usdValue)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 13),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class WalletAllocationCard extends StatelessWidget {
  const WalletAllocationCard({super.key, required this.assets});

  final List<WalletAsset> assets;

  @override
  Widget build(BuildContext context) {
    final total = assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _walletPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          CustomPaint(
            size: const Size(92, 92),
            painter: _AllocationPainter(assets: assets, total: total),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                for (final asset in assets.take(6)) ...[
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(asset.colorHex),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          asset.symbol,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${(asset.usdValue / total * 100).toStringAsFixed(1)}%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontSize: 12,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  if (asset != assets.take(6).last) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationPainter extends CustomPainter {
  const _AllocationPainter({required this.assets, required this.total});

  final List<WalletAsset> assets;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;
    for (final asset in assets.take(6)) {
      final sweep = (asset.usdValue / total) * math.pi * 2;
      paint.color = Color(asset.colorHex).withValues(alpha: .88);
      canvas.drawArc(rect.deflate(8), start, sweep, false, paint);
      start += sweep;
    }
    final centerPaint = Paint()..color = _walletPanel;
    canvas.drawCircle(rect.center, 22, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _AllocationPainter oldDelegate) => false;
}

IconData _actionIcon(String key) => switch (key) {
  'deposit' => Icons.file_download_outlined,
  'withdraw' => Icons.file_upload_outlined,
  'buy' => Icons.shopping_cart_outlined,
  'transfer' => Icons.swap_vert_rounded,
  'history' => Icons.schedule_rounded,
  _ => Icons.account_balance_wallet_outlined,
};

IconData _toolIcon(String key) => switch (key) {
  'pending' => Icons.south_west_rounded,
  'limits' => Icons.speed_rounded,
  'dust' => Icons.auto_awesome_rounded,
  'network' => Icons.wifi_rounded,
  _ => Icons.account_balance_wallet_outlined,
};

String _formatUsd(double value) {
  final whole = value.truncate();
  final cents = ((value - whole) * 100).round().abs();
  return '\$${_withCommas(whole)}.${cents.toString().padLeft(2, '0')}';
}

String _formatVnd(double value) => _withDots(value.round());

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatAssetAmount(double value) {
  if (value >= 1000) return _withCommas(value.round());
  if (value >= 10) return value.toStringAsFixed(4);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _withCommas(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _withDots(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}
