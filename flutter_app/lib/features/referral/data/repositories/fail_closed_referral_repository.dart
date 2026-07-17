import 'package:vit_trade_flutter/features/referral/domain/entities/referral_errors.dart';
import 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';

final class FailClosedReferralRepository implements ReferralRepository {
  const FailClosedReferralRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const ReferralBackendContractMissingException();
  }
}
