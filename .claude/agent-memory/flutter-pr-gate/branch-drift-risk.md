---
name: branch-drift-risk
description: How to detect merge-conflict risk from main having advanced past a feature branch's merge-base, and the two-dot vs three-dot git diff pitfall — only relevant when gating a feature branch, not a diff taken directly on main.
metadata:
  type: feedback
---

# Branch lệch main = rủi ro merge-conflict không thấy qua CI riêng nhánh

Chỉ áp dụng khi gate một FEATURE BRANCH (không áp dụng khi diff đang gate
là uncommitted changes trực tiếp trên `main`, vì khi đó không có branch
nào "lệch" main để so).

- Trước khi kết luận READY, chạy `git log HEAD..main --oneline` để biết
  main đã tiến xa hơn merge-base bao nhiêu commit, rồi
  `git show --stat <commit>` từng commit đó để lấy danh sách file. Nếu
  file trùng với file nhánh đang sửa → rủi ro conflict thật khi mở PR/
  rebase, dù CI trên HEAD hiện tại của nhánh đang xanh (CI nhánh không
  biết main đã đổi). Báo cáo rủi ro này tường minh, đừng chỉ dựa
  `git diff main...HEAD` (three-dot, đúng cho scope PR) mà quên check
  `HEAD..main` (số commit main đã vượt lên).
- Lưu ý phụ: `git diff main` (two-dot, so thẳng working tree với main
  TIP) sẽ lẫn cả những gì main đã đổi mà nhánh chưa có — trông như nhánh
  "xoá code" nhưng thực ra là nhánh thiếu commit mới của main. Luôn dùng
  `git diff <merge-base>` hoặc `git diff main...HEAD` (three-dot) để lấy
  đúng scope diff của PR, không dùng two-dot khi main đã tiến xa hơn.
