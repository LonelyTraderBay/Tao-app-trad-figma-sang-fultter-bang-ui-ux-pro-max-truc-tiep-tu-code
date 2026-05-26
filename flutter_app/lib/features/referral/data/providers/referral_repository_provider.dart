import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/referral/domain/repositories/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/data/repositories/mock_referral_repository.dart';

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  return const MockReferralRepository();
});
