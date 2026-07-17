export 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
export 'package:vit_trade_flutter/features/p2p/domain/repositories/p2p_repository.dart';

import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/features/p2p/domain/entities/p2p_entities.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/controllers/p2p_flow_status.dart';

export 'p2p_flow_status.dart';

part 'p2p_payment_method_controllers.dart';
part 'p2p_order_dispute_controllers.dart';

final class P2PCreateAdViewState {
  const P2PCreateAdViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PCreateAdSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PCreateAdDraft {
  const P2PCreateAdDraft({
    required this.adType,
    required this.asset,
    required this.currency,
    required this.priceType,
    required this.paymentWindow,
    required this.tradingHours,
    required this.requireKyc,
    required this.requiredKycLevel,
    required this.selectedPayments,
    required this.priceText,
    required this.marginText,
    required this.totalText,
    required this.minLimitText,
    required this.maxLimitText,
  });

  final P2PTradeType adType;
  final String asset;
  final String currency;
  final String priceType;
  final int paymentWindow;
  final String tradingHours;
  final bool requireKyc;
  final String requiredKycLevel;
  final Set<String> selectedPayments;
  final String priceText;
  final String marginText;
  final String totalText;
  final String minLimitText;
  final String maxLimitText;
}

final class P2PCreateAdPreview {
  const P2PCreateAdPreview({
    required this.marketPrice,
    required this.effectivePrice,
    required this.priceDiffPercent,
    required this.canPublish,
    required this.typeLabel,
    required this.publishLabel,
    required this.marketPriceLabel,
    required this.priceLabel,
    required this.priceDiffLabel,
    required this.totalAmountLabel,
    required this.paymentSummary,
    required this.limitSummary,
    required this.feeReviewLabel,
    required this.riskReviewLabel,
    required this.escrowReviewLabel,
  });

  final int marketPrice;
  final int effectivePrice;
  final double priceDiffPercent;
  final bool canPublish;
  final String typeLabel;
  final String publishLabel;
  final String marketPriceLabel;
  final String priceLabel;
  final String priceDiffLabel;
  final String totalAmountLabel;
  final String paymentSummary;
  final String limitSummary;
  final String feeReviewLabel;
  final String riskReviewLabel;
  final String escrowReviewLabel;
}

final class P2PCreateAdController {
  const P2PCreateAdController({required this.state});

  final P2PCreateAdViewState state;

  P2PCreateAdPreview preview(P2PCreateAdDraft draft) {
    final marketPrice = state.snapshot.marketPrices[draft.asset] ?? 25300;
    final effectivePrice = _effectivePrice(draft, marketPrice);
    final priceDiffPercent = effectivePrice <= 0
        ? 0.0
        : ((effectivePrice - marketPrice) / marketPrice) * 100;
    final total = _parseP2PNum(draft.totalText);
    final blockers = _publishBlockers(
      draft: draft,
      effectivePrice: effectivePrice,
      total: total,
    );
    final typeLabel = draft.adType == P2PTradeType.buy ? 'MUA' : 'BÁN';
    final paymentSummary = draft.selectedPayments.isEmpty
        ? 'Chưa chọn'
        : draft.selectedPayments.join(', ');
    final minLimit = draft.minLimitText.trim().isEmpty
        ? 'Chưa đặt'
        : draft.minLimitText.trim();
    final maxLimit = draft.maxLimitText.trim().isEmpty
        ? 'Chưa đặt'
        : draft.maxLimitText.trim();

    return P2PCreateAdPreview(
      marketPrice: marketPrice,
      effectivePrice: effectivePrice,
      priceDiffPercent: priceDiffPercent,
      canPublish: blockers.isEmpty,
      typeLabel: typeLabel,
      publishLabel: 'Đăng quảng cáo $typeLabel ${draft.asset}',
      marketPriceLabel: _formatP2PFiat(marketPrice),
      priceLabel: '${_formatP2PFiat(effectivePrice)} ${draft.currency}',
      priceDiffLabel:
          '${priceDiffPercent >= 0 ? 'Tăng' : 'Giảm'} ${priceDiffPercent.abs().toStringAsFixed(2)}% so với thị trường',
      totalAmountLabel: '${draft.totalText.trim()} ${draft.asset}',
      paymentSummary: paymentSummary,
      limitSummary: 'Min $minLimit / Max $maxLimit ${draft.currency}',
      feeReviewLabel:
          'Fee review: no listing fee in mock; order fees must be checked before escrow.',
      riskReviewLabel: state.snapshot.warningNote,
      escrowReviewLabel: state.snapshot.escrowNote,
    );
  }

  Set<String> toggledPayments(Set<String> current, String payment) {
    final next = Set<String>.of(current);
    if (next.contains(payment)) {
      next.remove(payment);
    } else if (next.length < 5) {
      next.add(payment);
    }
    return next;
  }

  List<String> publishBlockers(P2PCreateAdDraft draft) {
    final marketPrice = state.snapshot.marketPrices[draft.asset] ?? 25300;
    final effectivePrice = _effectivePrice(draft, marketPrice);
    final total = _parseP2PNum(draft.totalText);
    return _publishBlockers(
      draft: draft,
      effectivePrice: effectivePrice,
      total: total,
    );
  }

  int _effectivePrice(P2PCreateAdDraft draft, int marketPrice) {
    if (draft.priceType == 'fixed') {
      return _parseP2PNum(draft.priceText).round();
    }
    final margin = _parseP2PNum(draft.marginText);
    return (marketPrice * (1 + margin / 100)).round();
  }

  List<String> _publishBlockers({
    required P2PCreateAdDraft draft,
    required int effectivePrice,
    required num total,
  }) {
    final blockers = <String>[];
    final hasExplicitPrice = draft.priceType == 'fixed'
        ? _parseP2PNum(draft.priceText) > 0
        : draft.marginText.trim().isNotEmpty && effectivePrice > 0;
    if (!hasExplicitPrice) {
      blockers.add(
        draft.priceType == 'fixed' ? 'Nhap gia' : 'Nhap bien do gia',
      );
    }
    if (total <= 0) {
      blockers.add('Nhap tong ${draft.asset}');
    }
    if (draft.selectedPayments.isEmpty) {
      blockers.add('Chon phuong thuc thanh toan');
    }
    if (state.status == P2PHighRiskFlowStatus.offline) {
      blockers.add('Ket noi lai truoc khi dang');
    } else if (state.status.isBusy) {
      blockers.add('Dang xu ly yeu cau');
    }
    return blockers;
  }
}
