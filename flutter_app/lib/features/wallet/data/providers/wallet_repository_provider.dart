import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/data/repository_guard.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/repositories/mock_wallet_repository.dart';

import 'package:vit_trade_flutter/features/wallet/data/repositories/fail_closed_wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => guardedRepository(
    ref,
    featureName: 'Wallet',
    mock: () => const MockWalletRepository(),
    failClosed: () => const FailClosedWalletRepository(),
  ),
);
