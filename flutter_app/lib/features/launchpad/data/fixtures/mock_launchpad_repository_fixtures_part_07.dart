part of '../repositories/mock_launchpad_repository.dart';

const _txSimulations = [
  LaunchpadTxSimulationDraft(
    id: 'sim1',
    functionName: 'stake',
    chain: 'BSC',
    contractAddress: '0x1a2b3c4d5e6f7890abcdef1234567890abcdef12',
    params: {'amount': '2500', 'lockPeriod': '14'},
    status: LaunchpadTxSimulationStatus.success,
    gasEstimate: '120,000',
    gasPrice: '5 Gwei',
    totalCost: r'$0.18',
    expectedOutput: 'Stake 2,500 BNB for 14 days at 48% APY',
    warnings: [],
    stateChanges: [
      'Số dư BNB: 5,000.00 -> 2,500.00',
      'Staked amount: 0.00 -> 2,500.00',
      'Lock until: 20/03/2026',
    ],
  ),
  LaunchpadTxSimulationDraft(
    id: 'sim2',
    functionName: 'approve',
    chain: 'Polygon',
    contractAddress: '0x9876543210abcdef9876543210abcdef98765432',
    params: {'spender': '0x9876...5432', 'amount': 'unlimited'},
    status: LaunchpadTxSimulationStatus.warning,
    gasEstimate: '46,000',
    gasPrice: '30 Gwei',
    totalCost: r'$0.01',
    expectedOutput: 'Approve unlimited USDT spending',
    warnings: [
      'Bạn đang approve không giới hạn. Nên chỉ approve số lượng cần thiết.',
    ],
    stateChanges: ['USDT allowance: 0 -> Unlimited'],
  ),
];
