import 'package:vit_trade_flutter/features/news/domain/entities/news_errors.dart';
import 'package:vit_trade_flutter/features/news/domain/repositories/news_repository.dart';

final class FailClosedNewsRepository implements NewsRepository {
  const FailClosedNewsRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const NewsBackendContractMissingException();
  }
}
