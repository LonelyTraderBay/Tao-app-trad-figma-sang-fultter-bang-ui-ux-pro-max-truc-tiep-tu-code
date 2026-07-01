# Headroom — VitTrade (Cursor-only)

Headroom nén output tool dài **trước khi** Cursor Agent đọc, qua MCP `headroom` trong Cursor.

**Không cần** API key Anthropic hay Claude Code — gói Cursor subscription đã đủ.

## Hàng ngày

```powershell
.\scripts\Start-CursorSession.ps1
```

Hoặc chỉ proxy: `.\scripts\headroom\Start-VitTradeHeadroom.ps1`

Mở Cursor → Settings → MCP → `headroom` phải **connected** (restart IDE sau lần setup đầu).

## Scripts

| Script | Mục đích |
|--------|----------|
| `Start-VitTradeHeadroom.ps1` | **Bắt buộc** — proxy `:8787` cho MCP Cursor |
| `Stop-VitTradeHeadroom.ps1` | Dừng proxy |
| `vittrade.headroom.env` | Preset env (copy override → `vittrade.headroom.local.env`) |
| `Launch-ClaudeCode.ps1` | **Optional** — chỉ khi có tài khoản Anthropic riêng |
| `Wrap-ClaudeCode.ps1` | **Optional** — one-time wrap Claude Code |

## Cursor $200 — tối ưu quota

- Model mặc định: **Sonnet** cho migration UI; Opus/thinking chỉ khi debug khó.
- Batch **5–10 file**/turn; chat mới sau mỗi batch.
- GitNexus `impact()` / `query()` trước khi sửa (xem [AGENTS.md](../../AGENTS.md)).
- Agent gọi `headroom_compress` khi log test/analyze >500 dòng (rule: `.cursor/rules/headroom-vittrade.mdc`).

## Giới hạn

Proxy **không** nén traffic Cursor subscription (Agent chạy backend Cursor). Tiết kiệm đến từ MCP + quy trình batch, không phải full proxy như Claude Code.

## Theo dõi

```powershell
headroom perf
headroom dashboard
```

Rollback Claude wrap (nếu từng bật): `headroom unwrap claude`
