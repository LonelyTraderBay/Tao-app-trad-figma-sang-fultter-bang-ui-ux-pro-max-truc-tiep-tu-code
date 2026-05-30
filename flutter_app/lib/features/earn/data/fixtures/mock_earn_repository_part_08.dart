part of '../repositories/mock_earn_repository.dart';

final class MockStakingValidatorSelectionRepository
    implements StakingValidatorSelectionRepository {
  const MockStakingValidatorSelectionRepository();

  @override
  StakingValidatorSelectionSnapshot getSelection() {
    return const StakingValidatorSelectionSnapshot(
      endpoint: '/api/mobile/earn/earn-validator-selection',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; PATCH /earn/staking/validator-preference',
      title: 'Chọn Validator',
      backRoute: '/earn/staking',
      infoTitle: 'Tính năng Nâng cao',
      infoBody:
          'Chọn validator riêng để tối ưu APY và kiểm soát rủi ro. Mặc định, chúng tôi tự động phân phối qua nhiều validator uy tín.',
      validators: [
        StakingValidatorDraft(
          id: 'v1',
          name: 'Coinbase Cloud',
          address: '0x1234...5678',
          commission: 8,
          apy: 5.92,
          uptime: 99.98,
          totalStaked: 125000,
          delegators: 45230,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Institutional-grade validator with 24/7 monitoring',
          website: 'coinbase.com/cloud',
          features: ['24/7 Support', 'MEV Protection', 'Auto-compound'],
        ),
        StakingValidatorDraft(
          id: 'v2',
          name: 'Kraken Staking',
          address: '0xabcd...ef12',
          commission: 10,
          apy: 5.80,
          uptime: 99.95,
          totalStaked: 98500,
          delegators: 32150,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Regulated validator with insurance coverage',
          website: 'kraken.com/staking',
          features: ['Insurance', 'Regulated', 'Low Commission'],
        ),
        StakingValidatorDraft(
          id: 'v3',
          name: 'Figment',
          address: '0x9876...5432',
          commission: 5,
          apy: 6.15,
          uptime: 99.99,
          totalStaked: 210000,
          delegators: 68900,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.top,
          description: 'Highest APY with excellent track record',
          website: 'figment.io',
          features: ['Highest APY', 'Open Source', 'Multi-chain'],
        ),
        StakingValidatorDraft(
          id: 'v4',
          name: 'Chorus One',
          address: '0xdef0...9abc',
          commission: 7,
          apy: 6.03,
          uptime: 99.97,
          totalStaked: 150000,
          delegators: 52000,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.recommended,
          description:
              'Community-focused validator with transparent operations',
          features: ['Community Driven', 'Educational', 'Governance Active'],
        ),
        StakingValidatorDraft(
          id: 'v5',
          name: 'P2P Validator',
          address: '0x1111...2222',
          commission: 6,
          apy: 6.08,
          uptime: 99.96,
          totalStaked: 88000,
          delegators: 28500,
          slashingHistory: 0,
          verified: true,
          tier: StakingValidatorTier.recommended,
          description: 'Non-custodial staking with full control',
          features: ['Non-custodial', 'API Access', 'Custom Reports'],
        ),
        StakingValidatorDraft(
          id: 'v6',
          name: 'Everstake',
          address: '0x3333...4444',
          commission: 9,
          apy: 5.85,
          uptime: 99.94,
          totalStaked: 72000,
          delegators: 21000,
          slashingHistory: 0,
          verified: false,
          tier: StakingValidatorTier.standard,
          description: 'Reliable validator with global infrastructure',
          features: ['Global Nodes', 'Backup Validators', 'Analytics'],
        ),
        StakingValidatorDraft(
          id: 'v7',
          name: 'Staked.us',
          address: '0x5555...6666',
          commission: 12,
          apy: 5.68,
          uptime: 99.92,
          totalStaked: 45000,
          delegators: 15000,
          slashingHistory: 1,
          verified: false,
          tier: StakingValidatorTier.standard,
          description: 'US-based validator with compliance focus',
          features: ['US Regulated', 'Tax Reporting', 'Compliance'],
        ),
      ],
      footerNote:
          'Thông tin validator được cập nhật theo thời gian thực từ blockchain. APY có thể thay đổi dựa trên hiệu suất validator và điều kiện mạng. Chúng tôi khuyến nghị chọn validator có uptime >99.9% và không có lịch sử slashing.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, sort/filter state, validator details, and preference update action.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingAutoCompoundRepository
    implements StakingAutoCompoundRepository {
  const MockStakingAutoCompoundRepository();

  @override
  StakingAutoCompoundSnapshot getAutoCompound() {
    return const StakingAutoCompoundSnapshot(
      endpoint: '/api/mobile/earn/earn-auto-compound',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; PATCH /earn/staking/auto-compound-settings',
      title: 'Auto-Compound',
      backRoute: '/earn/staking',
      infoTitle: 'Tự động Tái đầu tư',
      infoBody:
          'Auto-compound tự động thêm phần thưởng vào số lượng stake để tối đa hóa lợi nhuận kép. APY thực tế sẽ cao hơn APY danh nghĩa.',
      frequencies: [
        StakingAutoCompoundFrequencyDraft(
          id: 'daily',
          label: 'Hàng ngày',
          description: 'APY cao nhất',
        ),
        StakingAutoCompoundFrequencyDraft(
          id: 'weekly',
          label: 'Hàng tuần',
          description: 'Cân bằng',
        ),
        StakingAutoCompoundFrequencyDraft(
          id: 'monthly',
          label: 'Hàng tháng',
          description: 'Tiết kiệm gas',
        ),
      ],
      positions: [
        StakingAutoCompoundPositionDraft(
          id: 'p1',
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 2500,
          autoCompound: true,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p2',
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          amount: 0.05,
          autoCompound: false,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p3',
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          amount: 1.5,
          autoCompound: true,
        ),
        StakingAutoCompoundPositionDraft(
          id: 'p4',
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          amount: 50,
          autoCompound: false,
        ),
      ],
      suggestion:
          'Tần suất Daily cho APY tối đa. Weekly cân bằng giữa APY và gas fee. Monthly tiết kiệm gas nhất nhưng APY thấp hơn.',
      footerNote:
          'Auto-compound hoạt động tự động 24/7. Phần thưởng sẽ được tự động thêm vào số lượng stake theo tần suất đã chọn. Bạn có thể tắt bất kỳ lúc nào mà không mất phần thưởng đã tích lũy.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, per-position auto-compound toggles, global frequency, gas optimization, and simulator state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingLiquidStakingRepository
    implements StakingLiquidStakingRepository {
  const MockStakingLiquidStakingRepository();

  @override
  StakingLiquidStakingSnapshot getLiquidStaking() {
    return const StakingLiquidStakingSnapshot(
      endpoint: '/api/mobile/earn/earn-liquid-staking',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/liquid-stake; POST /earn/staking/liquid-swap',
      title: 'Liquid Staking',
      backRoute: '/earn/staking',
      infoTitle: 'Về Liquid Staking',
      infoBody:
          'Stake và nhận liquid token (stToken) có thể giao dịch ngay lập tức. Bạn vẫn nhận phần thưởng staking trong khi giữ thanh khoản 100%.',
      tokens: [
        StakingLiquidTokenDraft(
          id: 'steth',
          name: 'Lido Staked ETH',
          symbol: 'stETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.002,
          apy: 4.2,
          totalSupply: 9500000,
          tvl: 26600000000,
          protocol: 'Lido',
          risks: ['Smart contract risk', 'Slippage khi swap', 'Depegging risk'],
          benefits: [
            'Thanh khoản tức thì',
            'Có thể dùng làm collateral',
            'Nhận rewards liên tục',
          ],
        ),
        StakingLiquidTokenDraft(
          id: 'reth',
          name: 'Rocket Pool ETH',
          symbol: 'rETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.058,
          apy: 4.5,
          totalSupply: 580000,
          tvl: 1624000000,
          protocol: 'Rocket Pool',
          risks: [
            'Phí swap cao hơn',
            'Thanh khoản thấp hơn stETH',
            'Phụ thuộc node operators',
          ],
          benefits: ['Decentralized hơn', 'APY cao hơn', 'Hỗ trợ mini-pool'],
        ),
        StakingLiquidTokenDraft(
          id: 'cbeth',
          name: 'Coinbase Wrapped Staked ETH',
          symbol: 'cbETH',
          underlyingAsset: 'ETH',
          exchangeRate: 1.045,
          apy: 3.8,
          totalSupply: 450000,
          tvl: 1260000000,
          protocol: 'Coinbase',
          risks: ['Centralized (Coinbase custody)', 'Thanh khoản trung bình'],
          benefits: [
            'Uy tín cao (Coinbase)',
            'Dễ dàng onboarding',
            'Regulated',
          ],
        ),
      ],
      swapFromOptions: ['stETH', 'rETH', 'cbETH'],
      swapToOptions: ['ETH', 'stETH', 'rETH', 'cbETH'],
      slippageTolerance: 0.3,
      estimatedGasFee: 2.50,
      holdingsValue: 0,
      riskNote:
          'Liquid token có rủi ro smart contract và depegging (mất peg so với asset gốc). Chỉ stake số lượng bạn có thể chấp nhận rủi ro.',
      swapNote:
          'Swap qua DEX aggregator (1inch, Paraswap) để có rate tốt nhất. Slippage có thể cao hơn trong thời điểm thị trường biến động.',
      benefits: [
        StakingLiquidBenefitDraft(
          icon: 'zap',
          label: 'Thanh khoản tức thì',
          description: 'Swap bất kỳ lúc nào',
        ),
        StakingLiquidBenefitDraft(
          icon: 'trend',
          label: 'Nhận rewards liên tục',
          description: 'APY auto-compound',
        ),
        StakingLiquidBenefitDraft(
          icon: 'shield',
          label: 'Làm collateral',
          description: 'Vay/cho vay DeFi',
        ),
        StakingLiquidBenefitDraft(
          icon: 'swap',
          label: 'Swap dễ dàng',
          description: 'Uniswap, Curve',
        ),
      ],
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, liquid token catalog, stake/swap preview, holdings, and slippage state.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      },
    );
  }
}

final class MockStakingInsuranceRepository
    implements StakingInsuranceRepository {
  const MockStakingInsuranceRepository();

  @override
  StakingInsuranceSnapshot getInsurance() {
    return const StakingInsuranceSnapshot(
      endpoint: '/api/mobile/earn/earn-insurance',
      actionDraft:
          'POST /earn/subscribe|redeem|claim|vote where applicable; POST /earn/staking/insurance/claim; PATCH /earn/staking/insurance-plan',
      title: 'Slashing Insurance',
      backRoute: '/earn/staking',
      infoTitle: 'Bảo vệ Slashing',
      infoBody:
          'Insurance bồi thường 25-75% thiệt hại nếu validator bị slashing. Phí bảo hiểm chỉ 0.5-1.5% APY.',
      plans: [
        StakingInsurancePlanDraft(
          id: 'basic',
          name: 'Basic Coverage',
          coverage: 25,
          premium: 0.5,
          maxClaim: 5000,
          cooldownDays: 7,
          features: [
            'Bồi thường 25% thiệt hại',
            'Claim trong 7 ngày',
            'Tối đa \$5,000/claim',
          ],
        ),
        StakingInsurancePlanDraft(
          id: 'standard',
          name: 'Standard Coverage',
          coverage: 50,
          premium: 1.0,
          maxClaim: 25000,
          cooldownDays: 3,
          features: [
            'Bồi thường 50% thiệt hại',
            'Claim trong 3 ngày',
            'Tối đa \$25,000/claim',
            'Priority support',
          ],
        ),
        StakingInsurancePlanDraft(
          id: 'premium',
          name: 'Premium Coverage',
          coverage: 75,
          premium: 1.5,
          maxClaim: 100000,
          cooldownDays: 1,
          features: [
            'Bồi thường 75% thiệt hại',
            'Claim trong 24 giờ',
            'Tối đa \$100,000/claim',
            'Priority support',
            'Legal assistance',
          ],
        ),
      ],
      positions: [
        StakingInsurancePositionDraft(
          id: 'p1',
          product: 'BTC Fixed 90D',
          asset: 'BTC',
          amount: 0.05,
          usdValue: 3377,
          insured: true,
          insurancePlanId: 'standard',
        ),
        StakingInsurancePositionDraft(
          id: 'p2',
          product: 'USDT Flexible',
          asset: 'USDT',
          amount: 2500,
          usdValue: 2500,
          insured: false,
        ),
        StakingInsurancePositionDraft(
          id: 'p3',
          product: 'ETH Fixed 60D',
          asset: 'ETH',
          amount: 1.5,
          usdValue: 4200,
          insured: true,
          insurancePlanId: 'premium',
        ),
        StakingInsurancePositionDraft(
          id: 'p4',
          product: 'SOL Fixed 30D',
          asset: 'SOL',
          amount: 50,
          usdValue: 6500,
          insured: false,
        ),
      ],
      claims: [
        StakingInsuranceClaimDraft(
          id: 'c1',
          date: '15/02/2026',
          position: 'ETH Fixed 60D',
          reason: 'Validator downtime (48h)',
          loss: 125.50,
          coverage: 50,
          payout: 62.75,
          status: 'approved',
        ),
        StakingInsuranceClaimDraft(
          id: 'c2',
          date: '03/01/2026',
          position: 'BTC Fixed 90D',
          reason: 'Slashing penalty (0.01%)',
          loss: 3.38,
          coverage: 50,
          payout: 1.69,
          status: 'approved',
        ),
      ],
      benefits: [
        StakingInsuranceBenefitDraft(
          icon: 'shield',
          label: 'Bảo vệ vốn',
          description: 'Bồi thường 25-75%',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'clock',
          label: 'Xử lý nhanh',
          description: 'Claim trong 1-7 ngày',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'cost',
          label: 'Phí thấp',
          description: 'Chỉ 0.5-1.5% APY',
        ),
        StakingInsuranceBenefitDraft(
          icon: 'audit',
          label: 'Minh bạch',
          description: 'Smart contract audit',
        ),
      ],
      warningTitle: 'Lưu ý quan trọng',
      warningBullets: [
        'Bảo hiểm KHÔNG cover mất giá asset (market risk)',
        'Chỉ cover slashing penalty, downtime loss, smart contract bug',
        'Phí bảo hiểm được trừ trực tiếp từ APY nhận được',
        'Claim phải có bằng chứng rõ ràng',
      ],
      claimReasons: [
        'Slashing penalty',
        'Validator downtime',
        'Smart contract bug',
        'Khác',
      ],
      claimEvidenceNote:
          'Claim sẽ được xem xét trong vòng 1-7 ngày. Bạn cần cung cấp bằng chứng như transaction hash, screenshot hoặc audit report để hỗ trợ claim.',
      contractNotes:
          'Match screenshot first; wire BE after visual parity. Include earnProducts, stakingPositions, savingsPositions, validators, rewards, riskData, coverage plan catalog, insured position mapping, claim history, claim evidence workflow, and loading/empty/error/offline/submitting/success states.',
      supportedStates: {
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      },
    );
  }
}
