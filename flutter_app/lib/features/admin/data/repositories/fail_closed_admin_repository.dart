import 'package:vit_trade_flutter/features/admin/domain/entities/admin_errors.dart';
import 'package:vit_trade_flutter/features/admin/domain/repositories/admin_repository.dart';

final class FailClosedAdminRepository implements AdminRepository {
  const FailClosedAdminRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const AdminBackendContractMissingException();
  }
}
