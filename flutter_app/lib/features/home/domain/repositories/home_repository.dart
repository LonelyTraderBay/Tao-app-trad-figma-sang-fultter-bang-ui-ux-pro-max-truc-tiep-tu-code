import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

/// Repository contract for fetching the home screen's [HomeSnapshot].
abstract interface class HomeRepository {
  Future<HomeSnapshot> fetchHome();
}
