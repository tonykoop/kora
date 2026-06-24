# Kora Neck — CNC Packet (DRAFT)

CNC machining plan for the new kora neck. Strings enter the **front** face, route
through an internal **back channel** (closed by a cover plate), and wrap
**side-mounted guitar tuner** posts. Flat-backed rectangular blank.

> **Status: DRAFT.** Three inputs must be set before cutting — see *Open variables*.
> Geometry is parametric in `neck_cnc_gen.py`; edit the header and re-run.

## Confirmed from the repo

- **21 strings**, two rows, bridge spacing 0.273 in (`design.md`).
- Strings alternate to opposite rows → **11 on the right, 10 on the left** (adjacent
  pitches on opposite hands, standard kora practice).
- Hole stations seeded from the speaking-length schedule: **S1 (treble) sits low,
  S21 (bass) sits high**, spanning **22.4 in** up the neck.
- `string_count = 21`, `neck_length_in = 40` (MasterLayout equations).

## Operations (5 setups)

1. **Front-face drill** — `KOR-NECK-Front-Drill.dxf`: 21 holes Ø0.16 in, two rows at
   ±0.35 in, at the staggered stations. Drill from the front; they break into the channel.
2. **Back channel rout** — `KOR-NECK-Back-Channel.dxf`: 0.75 in wide × 0.75 in deep
   pocket down the back centerline (leaves a 0.50 in front wall that the string holes
   pass through). Rout in multiple depth passes.
3. **Cover plate** — `KOR-NECK-Cover.dxf`: caps the channel; #4 screws on 4 in pitch.
4. **Side tuner bores L/R** — `KOR-NECK-Side-RIGHT.dxf`, `KOR-NECK-Side-LEFT.dxf`:
   cross-bores from each side into the channel at each string's station (post bore +
   bushing counterbore + mounting-screw pilot). **Dims are placeholders.**
5. Profile/round the blank to final neck shape by hand after machining.

## Open variables (set these, then re-run)

| Variable | Placeholder | Source |
|----------|-------------|--------|
| `POST_D` | 0.250 in | measured tuner post bore |
| `BUSHING_D` | 0.395 in | tuner front bushing/ferrule |
| `SCREW_OFF` / `SCREW_D` | 0.50 / 0.090 in | tuner baseplate screw |
| `BORE_Z` | T−0.40 in | post depth into channel |
| `W_NECK` × `T_NECK` | 1.50 × 1.25 in | your finished neck cross-section |
| `stations[]` | from string lengths | **reconcile to real bridge datum** |

The single most important reconciliation: the hole stations here assume station ≈
speaking length up from a `DATUM` of 4 in. Your `Neck Face` sketch in
`KOR-000_MasterLayout` already carries longitudinal positions — confirm which governs
(measure where each string actually crosses the neck given the real bridge height and
position over the gourd) before committing to drill centers.

## Machining notes

- Do **front holes and side bores before** routing the channel away too much material —
  keep the blank rigid for cross-drilling; or rout channel last from the back.
- Side bores are cross-axis: use an indexed fixture or drill press for the L/R faces;
  the DXFs give you exact station coordinates for a fence stop.
- Flat back simplifies workholding — machine all features on the rectangular blank,
  then shape the rounded neck profile and headstock taper by hand/spokeshave.
- Verify the 0.50 in front wall is enough for your hardwood + string tension; thicken
  by reducing `CH_DEPTH` if the species is soft.

## Regenerate

```
python3 neck_cnc_gen.py     # writes 5 DXFs
```

Files: `neck_cnc_gen.py`, the 5 DXFs, `neck_cnc_preview.png`.
