# Review Evidence

- Mode: instrument-maker v4.3 root-mode packet.
- Source reviewed: existing packet files plus `kora-design-table.xlsx`.
- Packet readiness: L2 private-review packet. Cultural review, string-safety revisions, bridge/head load tests, actual string unit weights, and measured acoustic data remain pending.
- Local checks to run before PR: `git diff --check` and `python /home/tony/.codex/skills/instrument-maker-v4/scripts/validate_packet.py --mode root .`.
- Review focus: README/design language keeps the build framed as a kora-inspired engineering prototype, and `validation.csv` keeps public-release and full-stringing gates open.
