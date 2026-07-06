import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn/presentation/widgets/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const _liquidityRingSize = 56.0;
const _liquidityLineHeight = 1.22;
const _disclaimerLineHeight = 1.22;

class LiquidityCard extends StatelessWidget {
  const LiquidityCard({super.key, required this.score, required this.rungs});

  final int score;
  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final color = savingsLadderLiquidityColor(score);
    final label = score >= 70
        ? 'Cao'
        : score >= 40
        ? 'Trung bình'
        : 'Thấp';
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: .25),
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _liquidityRingSize,
                height: _liquidityRingSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      color: color,
                      backgroundColor: AppColors.surface3,
                      strokeWidth: 7,
                    ),
                    Text(
                      '$score',
                      style: AppTextStyles.base.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thanh khoản $label',
                      style: savingsLadderCaptionBoldStyle.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      score >= 70
                          ? 'Ladder được phân bổ tốt, đảm bảo dòng tiền liên tục và linh hoạt.'
                          : score >= 40
                          ? 'Cần thêm bậc ngắn hạn để tăng tính linh hoạt khi cần rút.'
                          : 'Hầu hết vốn bị khóa dài hạn. Cân nhắc thêm bậc 30D.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: _liquidityLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _LiquidityMini(
                  label: 'Ngắn hạn',
                  value: savingsLadderMoney(
                    rungs
                        .where((rung) => rung.lockDays <= 30)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Trung hạn',
                  value: savingsLadderMoney(
                    rungs
                        .where((rung) => rung.lockDays == 60)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _LiquidityMini(
                  label: 'Dài hạn',
                  value: savingsLadderMoney(
                    rungs
                        .where((rung) => rung.lockDays >= 90)
                        .fold<double>(
                          0,
                          (total, rung) => total + rung.amountUsd,
                        ),
                  ),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiquidityMini extends StatelessWidget {
  const _LiquidityMini({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: savingsLadderMicroBoldStyle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class OptimizationTip extends StatelessWidget {
  const OptimizationTip({
    super.key,
    required this.weightedApy,
    required this.liquidityScore,
  });

  final double weightedApy;
  final int liquidityScore;

  @override
  Widget build(BuildContext context) {
    final text = weightedApy < 5
        ? 'Tăng tỷ trọng sản phẩm APY cao để cải thiện lãi suất bình quân.'
        : liquidityScore < 50
        ? 'Thêm bậc 30D để đảm bảo thanh khoản và giảm rủi ro khóa vốn quá lâu.'
        : 'Ladder hiện tại cân bằng tốt giữa lãi suất và thanh khoản. Bật auto-renew để tối ưu liên tục.';
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent20,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accent,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gợi ý tối ưu', style: savingsLadderCaptionBoldStyle),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _disclaimerLineHeight,
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
