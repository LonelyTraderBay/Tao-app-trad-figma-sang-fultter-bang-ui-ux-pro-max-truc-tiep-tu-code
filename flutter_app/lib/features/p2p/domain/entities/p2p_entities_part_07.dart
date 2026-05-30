part of 'p2p_entities.dart';

final class P2PLimitTrackerSnapshot {
  const P2PLimitTrackerSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.usages,
    required this.breakdown,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final List<P2PLimitUsageDraft> usages;
  final List<P2PLimitBreakdownDraft> breakdown;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2PLimitUsageDraft usageFor(String period) {
    return usages.firstWhere(
      (item) => item.period == period,
      orElse: () => usages.first,
    );
  }
}

final class P2PLimitUsageDraft {
  const P2PLimitUsageDraft({
    required this.period,
    required this.label,
    required this.used,
    required this.limit,
    required this.percentage,
  });

  final String period;
  final String label;
  final double used;
  final double limit;
  final int percentage;
}

final class P2PLimitBreakdownDraft {
  const P2PLimitBreakdownDraft({
    required this.date,
    required this.buy,
    required this.sell,
  });

  final String date;
  final double buy;
  final double sell;

  double get total => buy + sell;
}

final class P2PTransactionLimitsSnapshot {
  const P2PTransactionLimitsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.currentTier,
    required this.nextTier,
    required this.usageItems,
    required this.detailItems,
    required this.infoBullets,
    required this.parentRoute,
    required this.trackerRoute,
    required this.kycRequirementsRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2PTransactionLimitTierDraft currentTier;
  final P2PTransactionLimitTierDraft nextTier;
  final List<P2PTransactionLimitUsageDraft> usageItems;
  final List<P2PTransactionLimitDetailDraft> detailItems;
  final List<String> infoBullets;
  final String parentRoute;
  final String trackerRoute;
  final String kycRequirementsRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceOverviewSnapshot {
  const P2PComplianceOverviewSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.items,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final List<P2PComplianceItemDraft> items;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PComplianceItemDraft {
  const P2PComplianceItemDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.status,
    required this.iconKey,
    required this.route,
  });

  final String id;
  final String label;
  final String value;
  final String status;
  final String iconKey;
  final String route;
}

final class P2PAmlScreeningSnapshot {
  const P2PAmlScreeningSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusDescription,
    required this.lastCheckLabel,
    required this.lastCheckAt,
    required this.nextCheckLabel,
    required this.nextCheckAt,
    required this.checks,
    required this.infoTitle,
    required this.infoBody,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String statusDescription;
  final String lastCheckLabel;
  final String lastCheckAt;
  final String nextCheckLabel;
  final String nextCheckAt;
  final List<P2PAmlCheckDraft> checks;
  final String infoTitle;
  final String infoBody;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PAmlCheckDraft {
  const P2PAmlCheckDraft({
    required this.id,
    required this.name,
    required this.status,
    required this.detail,
  });

  final String id;
  final String name;
  final String status;
  final String detail;
}

final class P2PSourceOfFundsSnapshot {
  const P2PSourceOfFundsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.sourceTitle,
    required this.inputLabel,
    required this.inputPlaceholder,
    required this.ctaLabel,
    required this.sources,
    required this.parentRoute,
    required this.successRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroSubtitle;
  final String sourceTitle;
  final String inputLabel;
  final String inputPlaceholder;
  final String ctaLabel;
  final List<P2PFundSourceDraft> sources;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PFundSourceDraft {
  const P2PFundSourceDraft({
    required this.id,
    required this.label,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String iconKey;
}

final class P2PLargeTransactionJustificationSnapshot {
  const P2PLargeTransactionJustificationSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.purposeTitle,
    required this.customPurposeLabel,
    required this.customPurposePlaceholder,
    required this.detailsLabel,
    required this.detailsPlaceholder,
    required this.ctaLabel,
    required this.purposes,
    required this.parentRoute,
    required this.successRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final double amount;
  final String heroTitle;
  final String heroSubtitle;
  final String purposeTitle;
  final String customPurposeLabel;
  final String customPurposePlaceholder;
  final String detailsLabel;
  final String detailsPlaceholder;
  final String ctaLabel;
  final List<String> purposes;
  final String parentRoute;
  final String successRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskAssessmentSnapshot {
  const P2PRiskAssessmentSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.overallRisk,
    required this.score,
    required this.scoreLabel,
    required this.scoreSubtitle,
    required this.infoText,
    required this.factorTitle,
    required this.factors,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final String overallRisk;
  final int score;
  final String scoreLabel;
  final String scoreSubtitle;
  final String infoText;
  final String factorTitle;
  final List<P2PRiskFactorDraft> factors;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PRiskFactorDraft {
  const P2PRiskFactorDraft({
    required this.id,
    required this.label,
    required this.value,
    required this.risk,
    required this.score,
  });

  final String id;
  final String label;
  final String value;
  final String risk;
  final int score;
}

final class P2PTaxReportingSnapshot {
  const P2PTaxReportingSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedYear,
    required this.selectedJurisdiction,
    required this.years,
    required this.jurisdictions,
    required this.summary,
    required this.documents,
    required this.disclaimer,
    required this.parentRoute,
    required this.detailRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final int selectedYear;
  final P2PTaxJurisdictionDraft selectedJurisdiction;
  final List<int> years;
  final List<P2PTaxJurisdictionDraft> jurisdictions;
  final P2PTaxSummaryDraft summary;
  final List<P2PTaxDocumentDraft> documents;
  final String disclaimer;
  final String parentRoute;
  final String detailRoute;
  final String emptyTitle;
  final String contractNotes;
}

final class P2PTaxJurisdictionDraft {
  const P2PTaxJurisdictionDraft({
    required this.code,
    required this.name,
    required this.form,
  });

  final String code;
  final String name;
  final String form;
}

final class P2PTaxSummaryDraft {
  const P2PTaxSummaryDraft({
    required this.totalTransactions,
    required this.totalVolumeLabel,
    required this.capitalGainsLabel,
    required this.capitalLossesLabel,
    required this.netGainsLabel,
    required this.generatedAt,
  });

  final int totalTransactions;
  final String totalVolumeLabel;
  final String capitalGainsLabel;
  final String capitalLossesLabel;
  final String netGainsLabel;
  final String generatedAt;
}

final class P2PTaxDocumentDraft {
  const P2PTaxDocumentDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.format,
    required this.toneKey,
  });

  final String id;
  final String title;
  final String subtitle;
  final String format;
  final String toneKey;
}

final class P2POrderBookSnapshot {
  const P2POrderBookSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.title,
    required this.subtitle,
    required this.selectedAsset,
    required this.markets,
    required this.bids,
    required this.asks,
    required this.parentRoute,
    required this.emptyTitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String title;
  final String subtitle;
  final P2POrderBookMarketDraft selectedAsset;
  final List<P2POrderBookMarketDraft> markets;
  final List<P2POrderBookEntryDraft> bids;
  final List<P2POrderBookEntryDraft> asks;
  final String parentRoute;
  final String emptyTitle;
  final String contractNotes;

  P2POrderBookEntryDraft get bestBid => bids.first;
  P2POrderBookEntryDraft get bestAsk => asks.first;

  double get spreadPercent {
    final spread = bestAsk.priceVnd - bestBid.priceVnd;
    return spread / bestBid.priceVnd * 100;
  }

  double get maxTotal {
    final bidMax = bids
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    final askMax = asks
        .map((item) => item.total)
        .reduce((a, b) => a > b ? a : b);
    return bidMax > askMax ? bidMax : askMax;
  }
}

final class P2POrderBookMarketDraft {
  const P2POrderBookMarketDraft({
    required this.asset,
    required this.lastPriceVnd,
    required this.changePct,
    required this.high24hVnd,
    required this.low24hVnd,
    required this.volume24hLabel,
    required this.trades24h,
  });

  final String asset;
  final double lastPriceVnd;
  final double changePct;
  final double high24hVnd;
  final double low24hVnd;
  final String volume24hLabel;
  final int trades24h;
}

final class P2POrderBookEntryDraft {
  const P2POrderBookEntryDraft({
    required this.priceVnd,
    required this.volume,
    required this.total,
    required this.orders,
  });

  final double priceVnd;
  final double volume;
  final double total;
  final int orders;
}
