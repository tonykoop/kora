# String Validation Gate - Kora

Status: blocker for full stringing and build-ready claims.

This slice turns the current workbook-derived string schedule into an explicit
validation gate. It does not approve a purchase-ready string set. It records
which rows exceed the practical prototype percent-break target and what must be
measured before the repo can move beyond L2 private review.

## Current Modeled Risk

Source: `design.md` current string schedule, derived from
`kora-design-table.xlsx` and the Mersenne-Taylor model.

- Total planned load from the current 8.0 to 14.0 lbf ramp is 231 lbf.
- Nylon strings 1-8 model above the 70 percent prototype break target.
- Nylon string 9 models at 69.3 percent, close enough to require supplier data
  before approving the set.
- Wound strings 18-21 depend on an effective-density factor, not verified
  manufacturer unit-weight data.
- Wound strings 18, 19, and 21 also model above the 70 percent check, but the
  exact value must not be treated as authoritative until real string data is
  available.

See `string-break-risk.csv` for the row-by-row risk register.

## Hold Points

- Do not order final strings from the current schedule.
- Do not pull all 21 strings to full pitch.
- Do not call the packet build-ready, safe for full stringing, or fabrication
  authoritative.
- Use staged low-tension mule tests with shielding until the string schedule is
  revised and measured or supplier-backed string data exists.

## Promotion Requirements

Before full stringing:

1. Replace the ideal nylon and wound-string model with actual supplier diameter,
   unit weight, recommended tension, and break/tensile data.
2. Revise treble pitch, scale length, material, or target tension until all
   nylon rows sit below the chosen prototype safety target with margin.
3. Replace the wound-string effective-density factor with manufacturer data or
   measured mass-per-length data.
4. Re-run the percent-break table and update `string-break-risk.csv`.
5. Keep the neck/tail/bridge/head proof-load gates in `validation.csv` open
   until physical tests pass.

## Suggested Low-Tension Mule Path

Use `KORA-21-MULE` from `family-spec.csv` as the next safe path. That mule keeps
the geometry visible for bridge/head behavior while reducing the immediate
string-break hazard. Treat any mule stringing as a measurement fixture, not as a
performance instrument.
