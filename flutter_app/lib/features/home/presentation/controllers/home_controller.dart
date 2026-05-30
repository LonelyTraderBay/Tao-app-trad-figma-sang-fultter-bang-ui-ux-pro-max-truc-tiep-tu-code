import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

export 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

final class HomeController {
  const HomeController({required this.state});

  final HomeViewState state;

  List<HomeCryptoPair> get hotPairs {
    return state.snapshot.pairs
        .where((pair) => pair.isFavorite)
        .take(5)
        .toList();
  }

  List<HomeCryptoPair> get gainers {
    final pairs = [...state.snapshot.pairs];
    pairs.sort((a, b) => b.change24h.compareTo(a.change24h));
    return pairs.take(5).toList();
  }

  List<HomeCryptoPair> get losers {
    final pairs = [...state.snapshot.pairs];
    pairs.sort((a, b) => a.change24h.compareTo(b.change24h));
    return pairs.take(5).toList();
  }

  List<HomeCryptoPair> tabPairs(String marketTab) {
    return switch (marketTab) {
      'gainers' => gainers,
      'losers' => losers,
      'new' => state.snapshot.pairs.reversed.take(5).toList(),
      _ => hotPairs,
    };
  }
}

final class HomeViewState {
  const HomeViewState({required this.snapshot});

  final HomeSnapshot snapshot;
}
