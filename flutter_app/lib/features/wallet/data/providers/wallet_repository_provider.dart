import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/repositories/mock_wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => const MockWalletRepository(),
);
