# String Numbering Analysis — Restoration Kora

_Drafted 2026-06-06, from the measured speaking lengths in the restoration measurements (String Schedule). Addresses the open worry: "I'm not sure I attributed string lengths to the proper number and key."_

## Tony's measuring convention

- 21 strings total: **11 on the left bank (odd numbers 1–21), 10 on the right bank (even numbers 2–20)**.
- Top-left string = #21 (longest), bottom-right = #2.
- Speaking lengths recorded. All strings measured **0.026″** uniform diameter (pitch is set by length/tension, not gauge); material and tuning-ring positions not yet recorded.
- Missing strings: **#1 (D6), #2 (C6), #8 (D5)** — all at the high/short end.

## Measured speaking lengths (inches)

| Bank | Strings → lengths |
|---|---|
| Left (odd) | 1: _missing_, 3: 14.4, 5: 17.25, 7: 19.75, 9: 23, 11: 25, 13: 27.1, 15: 29.2, 17: 30.25, 19: 31, 21: 31.5 |
| Right (even) | 2: _missing_, 4: 10.25, 6: 11.4, 8: _missing_, 10: 13.8, 12: 16, 14: 21.75, 16: 24.4, 18: 26.2, 20: 28.3 |

## Findings

**1. Within each bank, the numbering is internally consistent.**
Both banks increase monotonically in length with string number (Left 14.4→31.5, Right 10.25→28.3). No string sits out of order within its own column. The "top = longest" convention held.

**2. The two banks do NOT interleave into the canonical kora pattern.**
A standard 21-string kora alternates banks evenly by pitch: sorted shortest→longest, the banks read `L R L R L R …`. Tony's instrument, sorted by measured length, reads:

```
R R R L R L L R L R L R L R L L L L      (measured)
L R L R L R L R L R L R L R L R L R L R L (canonical)
```

The right bank clusters at the short end; the left bank clusters at the long end.

**3. The mismatch is systematic, not random — pointing to geometry, not mislabeling.**
Deviation of measured from the reference schedule:

- **Left bank: uniformly longer**, +0.4″ to +6.8″, bowing out to a maximum in the middle of the bank.
- **Right bank: uniformly shorter**, −0.75″ to −3.8″.

A random numbering error would scatter; this smooth, banded offset is the signature of an **asymmetric instrument** — an offset bridge or different tuning-ring heights on the two sides give one bank systematically longer speaking lengths. Consistent with the eBay listing ("Kora-**style** … Tribal Folk Decor"); this piece likely never had a true symmetric Mandé tuning.

## Recommendation

- **Do not back-solve canonical string numbers from the old lengths.** It's restringing with a fresh set, so the reference schedule (Ref Note column, D6→F3) is the *target* — tune the new strings to pitch rather than trying to reconstruct the old assignment.
- **Use the measured old lengths only for geometry**: bridge-notch spacing and tail-anchor order. They are a sanity check, not the authority on numbering.
- **Cover the missing high strings** in the new set: #1 D6, #2 C6, #8 D5.
- **Reference typo resolved → #21 = F2.** The Ref Note column originally listed `F3` for both #20 and #21 (an octave typo). In Mande/Silaba tuning the lowest left-bank string — the *Timbamba* / *Bakumba* — is tuned to the tonic **one octave below the base F3**, i.e. F2, not a further scale step (E3). The physical evidence corroborates: #21 is a heavy **4-strand braid** vs the **2-strand twist** on #20, exactly what an octave-drop bass string needs.

## Data location

The measurements now live as CSV under `kora-restoration-measurements/` (one file per workbook sheet) — text format that survives the file-sync issues the `.xlsx` hit and diffs cleanly in git. `string-schedule.csv` is the current source of truth for string data.

## Open items

- [x] Corrected #21 to F2 (Mande bass tonic); recorded 0.026″ diameters and braid/twist notes in `string-schedule.csv`.
- [ ] Final tuning target on restring: standard Mande/Silaba (F major), restrung so the two banks alternate in the proper zigzag interleaving.
- [ ] On restring, also record material and tuning-ring position per string (still blank).
- [ ] Re-enter any newer Dimensions / Condition-tab edits if they didn't survive the `.xlsx` sync (CSVs were converted from the last good commit).
