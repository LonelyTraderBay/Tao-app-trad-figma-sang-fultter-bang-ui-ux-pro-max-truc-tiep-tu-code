/// UI/connectivity state a Discovery screen snapshot supports rendering.
enum DiscoveryScreenState { onlineLive, loading, empty, error, offline }

/// The product surface a [DiscoveryModuleDraft] links to.
enum DiscoveryModuleKind { prediction, arena, topic }

/// The kind of item one unified search result represents.
enum DiscoveryResultKind { prediction, arenaMode, arenaRoom, creator, spot }

/// Data for the unified search screen: trending queries, module
/// shortcuts, and query-matched [results] across product surfaces.
final class UnifiedSearchSnapshot {
  const UnifiedSearchSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.searchHint,
    required this.staleMessage,
    required this.staleDetail,
    required this.trendingQueries,
    required this.modules,
    required this.results,
    required this.query,
    required this.contractNotes,
    required this.supportedStates,
    this.currentState = DiscoveryScreenState.onlineLive,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String searchHint;
  final String staleMessage;
  final String staleDetail;
  final List<DiscoveryTrendingQueryDraft> trendingQueries;
  final List<DiscoveryModuleDraft> modules;
  final DiscoverySearchResults results;
  final String query;
  final String contractNotes;
  final Set<DiscoveryScreenState> supportedStates;
  final DiscoveryScreenState currentState;

  bool get hasQuery => query.trim().isNotEmpty;
  bool get hasCachedContent =>
      trendingQueries.isNotEmpty ||
      modules.isNotEmpty ||
      results.totalCount > 0;
  bool get showOfflineBanner =>
      currentState == DiscoveryScreenState.offline && hasCachedContent;

  UnifiedSearchSnapshot copyWith({DiscoveryScreenState? currentState}) {
    return UnifiedSearchSnapshot(
      endpoint: endpoint,
      actionDraft: actionDraft,
      title: title,
      searchHint: searchHint,
      staleMessage: staleMessage,
      staleDetail: staleDetail,
      trendingQueries: trendingQueries,
      modules: modules,
      results: results,
      query: query,
      contractNotes: contractNotes,
      supportedStates: supportedStates,
      currentState: currentState ?? this.currentState,
    );
  }
}

/// Grouped unified-search matches (predictions, Arena modes/rooms,
/// creators, trading pairs) with a derived total count.
final class DiscoverySearchResults {
  const DiscoverySearchResults({
    required this.predictions,
    required this.arenaModes,
    required this.arenaRooms,
    required this.creators,
    required this.tradingPairs,
  });

  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryCreatorDraft> creators;
  final List<DiscoveryTradingPairDraft> tradingPairs;

  int get totalCount =>
      predictions.length +
      arenaModes.length +
      arenaRooms.length +
      creators.length +
      tradingPairs.length;

  bool get isEmpty => totalCount == 0;
}

/// Data for one topic's discovery hub screen: the [selectedTopic] plus
/// its related predictions, Arena rooms/modes, and creators.
final class TopicHubSnapshot {
  const TopicHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.searchRoute,
    required this.predictionsRoute,
    required this.arenaRoute,
    required this.createArenaRoute,
    required this.staleMessage,
    required this.staleDetail,
    required this.topics,
    required this.selectedTopic,
    required this.predictions,
    required this.arenaRooms,
    required this.arenaModes,
    required this.creators,
    required this.contractNotes,
    required this.supportedStates,
    this.currentState = DiscoveryScreenState.onlineLive,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String searchRoute;
  final String predictionsRoute;
  final String arenaRoute;
  final String createArenaRoute;
  final String staleMessage;
  final String staleDetail;
  final List<DiscoveryTopicDraft> topics;
  final DiscoveryTopicDraft selectedTopic;
  final List<DiscoveryPredictionEventDraft> predictions;
  final List<DiscoveryArenaRoomDraft> arenaRooms;
  final List<DiscoveryArenaModeDraft> arenaModes;
  final List<DiscoveryCreatorDraft> creators;
  final String contractNotes;
  final Set<DiscoveryScreenState> supportedStates;
  final DiscoveryScreenState currentState;

  bool get hasContent =>
      predictions.isNotEmpty || arenaRooms.isNotEmpty || arenaModes.isNotEmpty;
  bool get showOfflineBanner =>
      currentState == DiscoveryScreenState.offline && hasContent;

  TopicHubSnapshot copyWith({DiscoveryScreenState? currentState}) {
    return TopicHubSnapshot(
      endpoint: endpoint,
      actionDraft: actionDraft,
      title: title,
      searchRoute: searchRoute,
      predictionsRoute: predictionsRoute,
      arenaRoute: arenaRoute,
      createArenaRoute: createArenaRoute,
      staleMessage: staleMessage,
      staleDetail: staleDetail,
      topics: topics,
      selectedTopic: selectedTopic,
      predictions: predictions,
      arenaRooms: arenaRooms,
      arenaModes: arenaModes,
      creators: creators,
      contractNotes: contractNotes,
      supportedStates: supportedStates,
      currentState: currentState ?? this.currentState,
    );
  }
}

/// One trending search suggestion shown on the unified search screen.
final class DiscoveryTrendingQueryDraft {
  const DiscoveryTrendingQueryDraft({
    required this.label,
    required this.iconKey,
  });

  final String label;
  final String iconKey;
}

/// One module shortcut card (title/route/icon/kind) on the unified search
/// screen.
final class DiscoveryModuleDraft {
  const DiscoveryModuleDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.iconKey,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String iconKey;
  final DiscoveryModuleKind kind;
}

/// One selectable topic entry (label, summary, icon) on the discovery
/// topic hub.
final class DiscoveryTopicDraft {
  const DiscoveryTopicDraft({
    required this.id,
    required this.label,
    required this.summary,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String summary;
  final String iconKey;
}

/// One prediction event result surfaced by discovery search/topic hub.
final class DiscoveryPredictionEventDraft {
  const DiscoveryPredictionEventDraft({
    required this.id,
    required this.title,
    required this.category,
    required this.topOutcome,
    required this.chance,
    required this.volumeLabel,
    required this.route,
    required this.searchTerms,
    this.isTrending = false,
  });

  final String id;
  final String title;
  final String category;
  final String topOutcome;
  final int chance;
  final String volumeLabel;
  final String route;
  final List<String> searchTerms;
  final bool isTrending;
}

/// One points-only Arena mode result surfaced by discovery search/topic
/// hub.
final class DiscoveryArenaModeDraft {
  const DiscoveryArenaModeDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.activeChallenges,
    required this.cloneCount,
    required this.fairPlay,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String title;
  final String description;
  final int activeChallenges;
  final int cloneCount;
  final bool fairPlay;
  final String route;
  final List<String> searchTerms;
}

/// One points-only Arena room result surfaced by discovery search/topic
/// hub, with a derived slot-fill percent.
final class DiscoveryArenaRoomDraft {
  const DiscoveryArenaRoomDraft({
    required this.id,
    required this.title,
    required this.format,
    required this.entryPoints,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.creatorName,
    required this.route,
    required this.searchTerms,
    this.statusLabel = 'Trực tiếp',
  });

  final String id;
  final String title;
  final String format;
  final int entryPoints;
  final int slotsFilled;
  final int slotsTotal;
  final String creatorName;
  final String route;
  final List<String> searchTerms;
  final String statusLabel;

  int get fillPercent => ((slotsFilled / slotsTotal) * 100).round();
}

/// One Arena mode creator result surfaced by discovery search/topic hub.
final class DiscoveryCreatorDraft {
  const DiscoveryCreatorDraft({
    required this.id,
    required this.name,
    required this.initials,
    required this.trustScore,
    required this.modesCreated,
    required this.fairPlayBadge,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String name;
  final String initials;
  final int trustScore;
  final int modesCreated;
  final bool fairPlayBadge;
  final String route;
  final List<String> searchTerms;
}

/// One spot trading pair result surfaced by discovery search/topic hub.
final class DiscoveryTradingPairDraft {
  const DiscoveryTradingPairDraft({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.priceLabel,
    required this.change24h,
    required this.route,
    required this.searchTerms,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String priceLabel;
  final double change24h;
  final String route;
  final List<String> searchTerms;
}
