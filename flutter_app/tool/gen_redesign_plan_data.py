#!/usr/bin/env python3
"""Helper: print module screen groups for redesign plan authoring."""

import csv
import re
from collections import defaultdict
from pathlib import Path

CSV = (
    Path(__file__).resolve().parent.parent.parent
    / "docs/02_FLUTTER_MIGRATION/VitTrade-Screen-Redesign-Checklist.csv"
)

MODULE_ORDER = [
    "home",
    "auth",
    "onboarding",
    "markets",
    "trade",
    "wallet",
    "profile",
    "p2p",
    "earn",
    "dca",
    "predictions",
    "arena",
    "launchpad",
    "discovery",
    "news",
    "notifications",
    "referral",
    "support",
    "rewards",
    "cross_module",
    "enterprise_states",
    "admin",
    "dev",
]

# Logical batch groupings for large modules (sc_id prefixes / themes)
TRADE_BATCHES = [
    ("RD-T01", "Hub giao dịch cốt lõi", ["sc048", "sc049", "sc052", "sc053", "sc054", "sc055", "sc056", "sc057", "sc058"]),
    ("RD-T02", "Hub Trading Bots", ["sc059"]),
    ("RD-T03", "Bot vận hành & analytics", ["sc117", "sc118", "sc119", "sc120", "sc121", "sc122", "sc123", "sc124", "sc125", "sc126", "sc127", "sc128", "sc129", "sc130"]),
    ("RD-T04", "Bot guide & API", ["sc131", "sc132", "sc133", "sc134"]),
    ("RD-T05", "Copy trading hub", ["sc063", "sc064", "sc065", "sc066", "sc067", "sc068", "sc079", "sc083"]),
    ("RD-T06", "Copy provider flow", ["sc069", "sc070", "sc071", "sc072", "sc073", "sc074", "sc075", "sc076", "sc077", "sc078", "sc081", "sc082", "sc084", "sc412"]),
    ("RD-T07", "Margin & trader", ["sc085", "sc086", "sc087", "sc088", "sc090"]),
    ("RD-T08", "Market data & analytics", ["sc060", "sc061", "sc062", "sc089", "sc091", "sc092"]),
    ("RD-T09", "Compliance & regulatory (1)", ["sc093", "sc094", "sc095", "sc096", "sc097", "sc098", "sc099", "sc100", "sc101", "sc102", "sc103", "sc104"]),
    ("RD-T10", "Compliance & regulatory (2)", ["sc105", "sc106", "sc107", "sc108", "sc109", "sc110", "sc111", "sc112", "sc113", "sc114", "sc115", "sc116", "sc411", "sc415", "sc416"]),
    ("RD-T11", "Orders & receipts", ["sc050", "sc051", "sc414"]),
]

P2P_BATCHES = [
    ("RD-P01", "Hub & dashboard", ["sc282", "sc274", "sc273", "sc281", "sc279", "sc280"]),
    ("RD-P02", "Express & orders", ["sc210", "sc211", "sc212", "sc213", "sc214", "sc215", "sc216", "sc217"]),
    ("RD-P03", "Ads & merchant", ["sc223", "sc224", "sc225", "sc226", "sc227", "sc228", "sc229", "sc230", "sc231"]),
    ("RD-P04", "Payment methods", ["sc232", "sc233", "sc234", "sc235", "sc236", "sc237"]),
    ("RD-P05", "Insurance & escrow", ["sc238", "sc239", "sc240", "sc241", "sc242", "sc243", "sc244", "sc245", "sc246"]),
    ("RD-P06", "KYC & verification", ["sc247", "sc248", "sc249", "sc250", "sc251", "sc252", "sc402", "sc403", "sc404"]),
    ("RD-P07", "Security center", ["sc253", "sc254", "sc255", "sc256", "sc257", "sc258", "sc259", "sc260"]),
    ("RD-P08", "Wallet & limits P2P", ["sc261", "sc262", "sc263", "sc264", "sc265", "sc266"]),
    ("RD-P09", "Compliance & tax", ["sc267", "sc268", "sc269", "sc270", "sc271", "sc272", "sc407"]),
    ("RD-P10", "Disputes", ["sc218", "sc219", "sc220", "sc221", "sc222"]),
    ("RD-P11", "Social & settings", ["sc275", "sc276", "sc277", "sc278"]),
]

EARN_BATCHES = [
    ("RD-E01", "Staking entry & dashboard", ["sc327", "sc328", "sc358", "sc359", "sc360", "sc361"]),
    ("RD-E02", "Staking operations", ["sc362", "sc363", "sc364", "sc365", "sc366", "sc367", "sc368"]),
    ("RD-E03", "Staking legal & risk", ["sc353", "sc354", "sc355", "sc356", "sc357", "sc376", "sc381", "sc385", "sc386"]),
    ("RD-E04", "Staking compliance & reports", ["sc373", "sc374", "sc375", "sc377", "sc378", "sc379", "sc380", "sc382", "sc383", "sc384"]),
    ("RD-E05", "Staking community & dev", ["sc369", "sc370", "sc371", "sc372", "sc387", "sc388", "sc389", "sc390", "sc391", "sc392", "sc393", "sc394", "sc395", "sc396"]),
    ("RD-E06", "Savings entry & portfolio", ["sc329", "sc330", "sc331", "sc332", "sc333", "sc334"]),
    ("RD-E07", "Savings tools & analytics", ["sc335", "sc336", "sc337", "sc338", "sc339", "sc340", "sc341", "sc342", "sc343", "sc344", "sc345", "sc346", "sc347", "sc348", "sc349", "sc350", "sc351", "sc352"]),
]

def main() -> None:
    rows = list(csv.DictReader(CSV.open(encoding="utf-8-sig")))
    by_mod = defaultdict(list)
    by_sc = {r["sc_id"]: r for r in rows}
    for r in rows:
        by_mod[r["module"]].append(r)

    for mod in MODULE_ORDER:
        lst = sorted(by_mod.get(mod, []), key=lambda x: int(re.match(r"sc(\d+)", x["sc_id"]).group(1)))
        print(f"MODULE {mod} count={len(lst)}")


if __name__ == "__main__":
    main()
