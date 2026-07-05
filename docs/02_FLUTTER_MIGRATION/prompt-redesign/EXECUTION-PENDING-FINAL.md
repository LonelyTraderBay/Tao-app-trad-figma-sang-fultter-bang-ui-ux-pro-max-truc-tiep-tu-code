# VitTrade UI Redesign — Hoàn thiện (prompts theo thứ tự)

**Generated:** 2026-07-05 · **Baseline git:** `dad444ab0` · **Tiến độ:** 66/66 done

> **Cách dùng:** Mỗi block ```text``` = **1 chat Cursor mới**, chạy **Chat 1 → Chat N** liên tiếp.
> Chỉ ghi CSV `status=done` khi prompt ghi **LAST CHAT FOR BATCH**.
> **Chat cuối** = Final gate (sau khi hết batch pending).

Liên quan: [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md) · [REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md)

---

## Tổng quan

| Metric | Value |
| --- | --- |
| Batch còn pending | **0** |
| Màn còn thiếu (chưa diff) | **0** |
| Chat batch (redesign code) | **0** |
| Chat final gate | **1** |
| **Tổng chat** | **0** |

**Quy tắc:** Mỗi TARGET PAGE = file liệt kê trong CSV `page_files`. Sửa `_part_*` hoặc widget con **không** tính xong batch.

## Bảng thứ tự

| Chat | Playbook | Batch | Module | Lần/batch | Màn còn | Màn chat |
| ---: | ---: | --- | --- | ---: | ---: | ---: |

---

## Prompt copy-paste
