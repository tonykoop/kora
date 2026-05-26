# Wolfram Notes

Two notebooks live in this folder + repo root:

- `wolfram-starter.wl` (repo root) — first-pass string and segmented-bowl checks against the workbook string schedule. Workbook-driven.
- `wolfram/kora-acoustic-design.wl` — physics-bounded acoustic design notebook. Computes Helmholtz air resonance, membrane modes, bridge placement coupling, and string schedule from the SolidWorks masterLayout's measured geometry. Use this to sweep chord factor, sound hole size, and bridge offset before committing the masterLayout.

## Running in Wolfram Cloud

1. Open `https://www.wolframcloud.com`, create a new notebook.
2. Paste the contents of `kora-acoustic-design.wl` into a single input cell.
3. Shift+Enter to evaluate. All printouts, tables, and plots render inline.
4. To sweep a parameter, edit the relevant variable in Section 1 (e.g., `chordFactor = 0.50`) and re-evaluate.

## Future notebook exports should include

- revised low-tension mule schedule
- bowl ring geometry table
- measured vs predicted frequency chart
- bridge/head deflection measurements
- post-build tap-test results vs Section 7 predicted Helmholtz and membrane fundamental
