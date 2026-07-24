import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_account_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_marketplace_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_orders_repository.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_trust_repository.dart';

export 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_account_repository.dart';
export 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_marketplace_repository.dart';
export 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_orders_repository.dart';
export 'package:vit_trade_flutter/features/p2p_core/domain/repositories/p2p_trust_repository.dart';

/// Composite P2P data-access contract; mock / fail-closed implement this facade.
///
/// Sibling-owned slices live as [P2PMarketplaceRepository], [P2POrdersRepository],
/// [P2PAccountRepository], and [P2PTrustRepository] inside `p2p_core` (ADR-012
/// wave-1b) so typed providers stay leaf-safe without core→sibling edges.
/// Entity types remain on the four sibling interfaces (imported via those files).
abstract interface class P2PRepository
    implements
        P2PMarketplaceRepository,
        P2POrdersRepository,
        P2PAccountRepository,
        P2PTrustRepository {}
