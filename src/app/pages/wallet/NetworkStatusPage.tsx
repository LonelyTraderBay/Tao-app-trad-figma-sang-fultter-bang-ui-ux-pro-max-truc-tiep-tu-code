/**
 * ══════════════════════════════════════════════════════════════
 *  NetworkStatusPage — P3: Blockchain Network Health Monitor
 * ══════════════════════════════════════════════════════════════
 *  Shows real-time status of supported blockchain networks:
 *  congestion level, estimated confirmation time, gas/fee
 *  estimates, and deposit/withdraw availability.
 *  Pattern A — Standard Page
 *  Compliance: §16.4 Charts, §7.4 Feedback
 * ══════════════════════════════════════════════════════════════
 */

import React, { useState, useEffect } from 'react';
import { Header } from '../../components/layout/Header';
import { PageLayout } from '../../components/layout/PageLayout';
import { PageContent } from '../../components/layout/PageContent';
import { useThemeColors } from '../../hooks/useThemeColors';
import { TrCard } from '../../components/ui/TrCard';
import { PullToRefresh } from '../../components/ui/PullToRefresh';
import { useLoadingState } from '../../hooks/useLoadingState';
import { φ } from '../../utils/golden';
import { ALPHA, withAlpha } from '../../constants/colors';
import {
  Wifi, WifiOff, AlertTriangle, CheckCircle, Clock,
  Zap, TrendingUp, RefreshCw, Activity,
} from 'lucide-react';

type NetworkHealth = 'operational' | 'degraded' | 'congested' | 'down';

interface NetworkInfo {
  id: string;
  name: string;
  symbol: string;
  color: string;
  health: NetworkHealth;
  blockHeight: number;
  lastBlock: string;
  avgConfirmTime: string;
  txPending: number;
  gasFee: string;
  congestionPct: number;
  depositEnabled: boolean;
  withdrawEnabled: boolean;
  notes?: string;
}

const HEALTH_CONFIG: Record<NetworkHealth, { label: string; color: string; icon: typeof CheckCircle }> = {
  operational: { label: 'Hoạt động tốt', color: '#10B981', icon: CheckCircle },
  degraded: { label: 'Chậm', color: '#F59E0B', icon: Clock },
  congested: { label: 'Tắc nghẽn', color: '#F97316', icon: AlertTriangle },
  down: { label: 'Bảo trì', color: '#EF4444', icon: WifiOff },
};

function getStatusSurface(accent: string, base: string, alpha: string = ALPHA.muted) {
  return `linear-gradient(180deg, ${withAlpha(accent, alpha)} 0%, ${base} 100%)`;
}

function getStatusBorder(accent: string, alpha: string = ALPHA.border) {
  return withAlpha(accent, alpha);
}

function getCongestionColor(pct: number) {
  if (pct > 70) return HEALTH_CONFIG.congested.color;
  if (pct > 40) return HEALTH_CONFIG.degraded.color;
  return HEALTH_CONFIG.operational.color;
}

const MOCK_NETWORKS: NetworkInfo[] = [
  {
    id: 'btc',
    name: 'Bitcoin',
    symbol: 'BTC',
    color: '#F7931A',
    health: 'operational',
    blockHeight: 886543,
    lastBlock: '2 phút trước',
    avgConfirmTime: '~30 phút',
    txPending: 4521,
    gasFee: '12 sat/vB',
    congestionPct: 25,
    depositEnabled: true,
    withdrawEnabled: true,
  },
  {
    id: 'eth',
    name: 'Ethereum',
    symbol: 'ETH',
    color: '#627EEA',
    health: 'operational',
    blockHeight: 19847231,
    lastBlock: '12 giây trước',
    avgConfirmTime: '~5 phút',
    txPending: 142350,
    gasFee: '28 Gwei',
    congestionPct: 42,
    depositEnabled: true,
    withdrawEnabled: true,
  },
  {
    id: 'trc20',
    name: 'TRON (TRC20)',
    symbol: 'TRX',
    color: '#FF0013',
    health: 'operational',
    blockHeight: 61234567,
    lastBlock: '3 giây trước',
    avgConfirmTime: '~3 phút',
    txPending: 8920,
    gasFee: '27 TRX',
    congestionPct: 15,
    depositEnabled: true,
    withdrawEnabled: true,
  },
  {
    id: 'bsc',
    name: 'BNB Chain (BEP20)',
    symbol: 'BNB',
    color: '#F3BA2F',
    health: 'degraded',
    blockHeight: 38912456,
    lastBlock: '6 giây trước',
    avgConfirmTime: '~8 phút',
    txPending: 52100,
    gasFee: '5 Gwei',
    congestionPct: 65,
    depositEnabled: true,
    withdrawEnabled: true,
    notes: 'Xác nhận chậm hơn bình thường do lưu lượng cao',
  },
  {
    id: 'sol',
    name: 'Solana',
    symbol: 'SOL',
    color: '#9945FF',
    health: 'operational',
    blockHeight: 245678901,
    lastBlock: '400ms trước',
    avgConfirmTime: '~1 giây',
    txPending: 890,
    gasFee: '0.000005 SOL',
    congestionPct: 8,
    depositEnabled: true,
    withdrawEnabled: true,
  },
  {
    id: 'xrp',
    name: 'Ripple',
    symbol: 'XRP',
    color: '#23292F',
    health: 'operational',
    blockHeight: 87654321,
    lastBlock: '4 giây trước',
    avgConfirmTime: '~5 giây',
    txPending: 245,
    gasFee: '0.00001 XRP',
    congestionPct: 3,
    depositEnabled: true,
    withdrawEnabled: true,
  },
  {
    id: 'polygon',
    name: 'Polygon',
    symbol: 'MATIC',
    color: '#8247E5',
    health: 'down',
    blockHeight: 56789012,
    lastBlock: '3 giờ trước',
    avgConfirmTime: 'N/A',
    txPending: 0,
    gasFee: 'N/A',
    congestionPct: 0,
    depositEnabled: false,
    withdrawEnabled: false,
    notes: 'Đang bảo trì hệ thống. Dự kiến hoàn tất: 15:00 UTC',
  },
];

function CongestionBar({ pct }: { pct: number }) {
  const barColor = getCongestionColor(pct);
  return (
    <div
      className="w-full rounded-full overflow-hidden"
      style={{ height: 5, background: withAlpha(barColor, ALPHA.ghost) }}
    >
      <div
        className="h-full rounded-full transition-all duration-500"
        style={{
          width: `${Math.max(pct, 3)}%`,
          background: `linear-gradient(90deg, ${withAlpha(barColor, ALPHA.muted)} 0%, ${withAlpha(barColor, ALPHA.medium)} 100%)`,
        }}
      />
    </div>
  );
}

export function NetworkStatusPage() {
  const c = useThemeColors();
  const { refresh, lastRefreshedLabel, refreshCount } = useLoadingState({ initialDelay: 400 });

  // Simulate live block height updates
  const [networks, setNetworks] = useState(MOCK_NETWORKS);
  useEffect(() => {
    const timer = setInterval(() => {
      setNetworks(prev => prev.map(n => ({
        ...n,
        blockHeight: n.health !== 'down' ? n.blockHeight + Math.floor(Math.random() * 3) : n.blockHeight,
        txPending: n.health !== 'down' ? Math.max(0, n.txPending + Math.floor((Math.random() - 0.5) * 200)) : 0,
        congestionPct: n.health !== 'down'
          ? Math.max(0, Math.min(100, n.congestionPct + Math.floor((Math.random() - 0.5) * 5)))
          : 0,
      })));
    }, 4000);
    return () => clearInterval(timer);
  }, []);

  const operationalCount = networks.filter(n => n.health === 'operational').length;
  const degradedCount = networks.filter(n => n.health === 'degraded').length;
  const congestedCount = networks.filter(n => n.health === 'congested').length;
  const issueCount = degradedCount + congestedCount;
  const downCount = networks.filter(n => n.health === 'down').length;
  const summaryHealth: NetworkHealth =
    downCount > 0 ? 'down' :
      congestedCount > 0 ? 'congested' :
        degradedCount > 0 ? 'degraded' :
          'operational';
  const summaryConfig = HEALTH_CONFIG[summaryHealth];
  const SummaryIcon = summaryConfig.icon;
  const summaryMessage =
    downCount > 0
      ? `${downCount} mạng đang bảo trì`
      : congestedCount > 0
        ? `${congestedCount} mạng đang tắc nghẽn`
        : degradedCount > 0
          ? `${degradedCount} mạng đang chậm`
          : 'Tất cả mạng hoạt động tốt';

  return (
    <PageLayout>
      <Header title="Trạng thái mạng" back />

      <PageContent gap="default">
        {/* Global status summary */}
        <TrCard
          rounded="lg"
          className="p-5"
          style={{
            background: `linear-gradient(155deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(summaryConfig.color, ALPHA.ghost)} 16%, ${c.surface} 48%, ${c.surface2} 100%)`,
            border: `1px solid ${getStatusBorder(summaryConfig.color, ALPHA.ghost)}`,
            boxShadow: `0 16px 32px rgba(15,23,42,0.06), inset 0 1px 0 rgba(255,255,255,0.55)`,
          }}
        >
          <div className="flex items-center gap-3 mb-4">
            <div
              className="w-11 h-11 rounded-2xl flex items-center justify-center"
              style={{
                background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(summaryConfig.color, ALPHA.ghost)} 100%)`,
                border: `1px solid ${getStatusBorder(summaryConfig.color, ALPHA.hover)}`,
                boxShadow: `inset 0 1px 0 rgba(255,255,255,0.45)`,
              }}
            >
              {summaryHealth === 'operational'
                ? <Wifi size={22} color={summaryConfig.color} />
                : <SummaryIcon size={22} color={summaryConfig.color} />
              }
            </div>
            <div className="flex-1">
              <p style={{ color: c.text1, fontSize: φ.body, fontWeight: 700 }}>
                {summaryMessage}
              </p>
              <p style={{ color: c.text3, fontSize: φ.xs }}>
                Cập nhật tự động mỗi 4 giây
              </p>
            </div>
            <button
              onClick={() => refresh()}
              className="p-2 rounded-xl"
              style={{
                background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${c.surface} 100%)`,
                border: `1px solid ${getStatusBorder(summaryConfig.color, ALPHA.ghost)}`,
                boxShadow: `inset 0 1px 0 rgba(255,255,255,0.55)`,
              }}
            >
              <RefreshCw size={16} color={c.text2} />
            </button>
          </div>

          {/* Quick stats */}
          <div className="grid grid-cols-3 gap-2">
            {[
              { label: 'Hoạt động', value: operationalCount, color: '#10B981' },
              { label: 'Chậm / Tắc', value: issueCount, color: congestedCount > 0 ? '#F97316' : '#F59E0B' },
              { label: 'Bảo trì', value: downCount, color: '#EF4444' },
            ].map(s => (
              <div
                key={s.label}
                className="rounded-xl p-2.5 text-center"
                style={{
                  background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(s.color, ALPHA.ghost)} 10%, ${c.surface} 100%)`,
                  border: `1px solid ${getStatusBorder(s.color, ALPHA.ghost)}`,
                  boxShadow: `inset 0 1px 0 rgba(255,255,255,0.55)`,
                }}
              >
                <p style={{ color: s.color, fontSize: 18, fontWeight: 700 }}>{s.value}</p>
                <p style={{ color: c.text3, fontSize: 9, fontWeight: 600 }}>{s.label}</p>
              </div>
            ))}
          </div>
        </TrCard>

        {/* Network cards */}
        <PullToRefresh onRefresh={refresh} lastRefreshedLabel={lastRefreshedLabel} refreshCount={refreshCount}>
          <div className="flex flex-col gap-3">
            {networks.map(net => {
              const hcfg = HEALTH_CONFIG[net.health];
              const HealthIcon = hcfg.icon;
              const congestionColor = getCongestionColor(net.congestionPct);

              return (
                <TrCard
                  key={net.id}
                  className="p-4"
                  style={{
                    border: `1px solid ${net.health === 'operational' ? c.cardBorder : getStatusBorder(hcfg.color, ALPHA.ghost)}`,
                    boxShadow: `0 10px 24px rgba(15,23,42,0.045)`,
                  }}
                >
                  {/* Header */}
                  <div className="flex items-center gap-3 mb-3">
                    <div
                      className="w-10 h-10 rounded-2xl flex items-center justify-center"
                      style={{
                        background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(net.color, ALPHA.ghost)} 100%)`,
                        border: `1px solid ${getStatusBorder(net.color, ALPHA.ghost)}`,
                      }}
                    >
                      <span style={{ color: net.color, fontSize: 11, fontWeight: 700 }}>{net.symbol}</span>
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <span style={{ color: c.text1, fontSize: 14, fontWeight: 700 }}>{net.name}</span>
                        <span
                          className="px-2 py-0.5 rounded-full"
                          style={{
                            background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(hcfg.color, ALPHA.ghost)} 100%)`,
                            border: `1px solid ${getStatusBorder(hcfg.color, ALPHA.ghost)}`,
                            color: hcfg.color,
                            fontSize: 8.5,
                            fontWeight: 700,
                          }}
                        >
                          {hcfg.label}
                        </span>
                      </div>
                      <p style={{ color: c.text3, fontSize: 10 }}>Block #{net.blockHeight.toLocaleString()}</p>
                    </div>
                    <div
                      className="w-8 h-8 rounded-xl flex items-center justify-center"
                      style={{
                        background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(hcfg.color, ALPHA.ghost)} 100%)`,
                        border: `1px solid ${getStatusBorder(hcfg.color, ALPHA.ghost)}`,
                      }}
                    >
                      <HealthIcon size={16} color={hcfg.color} />
                    </div>
                  </div>

                  {/* Congestion bar */}
                  <div className="mb-3">
                    <div className="flex justify-between mb-1">
                      <span style={{ color: c.text3, fontSize: 10 }}>Mức tải mạng</span>
                      <span style={{
                        color: congestionColor,
                        fontSize: 10, fontWeight: 600,
                      }}>
                        {net.congestionPct}%
                      </span>
                    </div>
                    <CongestionBar pct={net.congestionPct} />
                  </div>

                  {/* Stats grid */}
                  <div className="grid grid-cols-2 gap-2 mb-3">
                    {[
                      { icon: Clock, label: 'Xác nhận', value: net.avgConfirmTime },
                      { icon: Activity, label: 'TX đang chờ', value: net.txPending.toLocaleString() },
                      { icon: Zap, label: 'Gas / Phí', value: net.gasFee },
                      { icon: TrendingUp, label: 'Block mới', value: net.lastBlock },
                    ].map(stat => (
                      <div
                        key={stat.label}
                        className="flex items-center gap-2 rounded-xl px-2.5 py-2"
                        style={{
                          background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${c.surface2} 100%)`,
                          border: `1px solid ${c.divider}`,
                        }}
                      >
                        <stat.icon size={12} color={c.text3} />
                        <div className="flex-1 min-w-0">
                          <p style={{ color: c.text3, fontSize: 9 }}>{stat.label}</p>
                          <p className="truncate" style={{ color: c.text1, fontSize: 11, fontWeight: 600, fontFamily: 'monospace' }}>
                            {stat.value}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Deposit / Withdraw availability */}
                  <div className="flex gap-2">
                    {[
                      { label: 'Nạp', enabled: net.depositEnabled },
                      { label: 'Rút', enabled: net.withdrawEnabled },
                    ].map(action => (
                      <div
                        key={action.label}
                        className="flex-1 flex items-center justify-center gap-1.5 py-1.5 rounded-xl"
                        style={{
                          background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(action.enabled ? c.success : c.error, ALPHA.ghost)} 100%)`,
                          border: `1px solid ${getStatusBorder(action.enabled ? c.success : c.error, ALPHA.ghost)}`,
                        }}
                      >
                        {action.enabled
                          ? <CheckCircle size={11} color="#10B981" />
                          : <WifiOff size={11} color="#EF4444" />
                        }
                        <span style={{
                          color: action.enabled ? '#10B981' : '#EF4444',
                          fontSize: 11,
                          fontWeight: 600,
                        }}>
                          {action.label} {action.enabled ? 'OK' : 'Tạm dừng'}
                        </span>
                      </div>
                    ))}
                  </div>

                  {/* Notes */}
                  {net.notes && (
                    <div
                      className="flex items-start gap-2 mt-2.5 rounded-xl px-3 py-2"
                      style={{
                        background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(c.warning, ALPHA.ghost)} 100%)`,
                        border: `1px solid ${getStatusBorder(c.warning, ALPHA.ghost)}`,
                      }}
                    >
                      <AlertTriangle size={11} color="#F59E0B" className="shrink-0 mt-0.5" />
                      <p style={{ color: c.text2, fontSize: 10, lineHeight: 1.5 }}>{net.notes}</p>
                    </div>
                  )}
                </TrCard>
              );
            })}
          </div>
        </PullToRefresh>

        {/* Legend */}
        <TrCard className="p-4">
          <p style={{ color: c.text2, fontSize: 12, fontWeight: 600, marginBottom: 8 }}>Chú thích trạng thái</p>
          <div className="grid grid-cols-2 gap-2">
            {Object.entries(HEALTH_CONFIG).map(([key, cfg]) => {
              const Icon = cfg.icon;
              return (
                <div key={key} className="flex items-center gap-2">
                  <div
                    className="w-5 h-5 rounded-md flex items-center justify-center"
                    style={{
                      background: `linear-gradient(180deg, ${withAlpha('#FFFFFF', ALPHA.ghost)} 0%, ${withAlpha(cfg.color, ALPHA.ghost)} 100%)`,
                      border: `1px solid ${getStatusBorder(cfg.color, ALPHA.ghost)}`,
                    }}
                  >
                    <Icon size={10} color={cfg.color} />
                  </div>
                  <span style={{ color: c.text2, fontSize: 11 }}>{cfg.label}</span>
                </div>
              );
            })}
          </div>
        </TrCard>

        {/* Disclaimer */}
        <div className="flex items-start gap-2 rounded-2xl px-4 py-3"
          style={{ background: c.primaryAlpha08, border: `1px solid ${c.primaryAlpha15}` }}>
          <AlertTriangle size={13} color={c.primary} className="shrink-0 mt-0.5" />
          <p style={{ color: c.text2, fontSize: 11, lineHeight: 1.6 }}>
            Dữ liệu trạng thái mạng được cập nhật tự động. Thời gian xác nhận thực tế có thể khác
            tùy thuộc vào phí gas và mức tải mạng tại thời điểm giao dịch.
          </p>
        </div>
      </PageContent>
    </PageLayout>
  );
}
