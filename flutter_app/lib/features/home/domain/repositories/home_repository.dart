import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

abstract interface class HomeRepository {
  HomeSnapshot getHome();
}
