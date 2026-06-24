# Kora Flat-Pack Stand — CNC Design Packet

Interlocking plywood cradle stand for the kora, modeled on the reference photo
(`inspiration for kora stand.png`). Designed for the **Maker Nexus wood CNC
router** in **18 mm Baltic birch**. Holds the gourd in a 4-point saddle cradle;
works as a playing cradle and a display stand (convertible — see *Orientation*).

Sized to the **KOR-000 segmented bowl, 20.3 in (515.6 mm) OD**. Fully parametric:
edit the header of `kora_stand_gen.py` and re-run to retarget the real calabash on
the restoration kora, or a different plywood thickness.

## Parts (3 unique, cut from one 24×48 in half-sheet)

| Part | File | Qty | Notes |
|------|------|-----|-------|
| Rib — Spine | `KOR-STAND-Rib-Spine.dxf` | 1 | Cross-lap slot opens at **top** |
| Rib — Cross | `KOR-STAND-Rib-Cross.dxf` | 1 | Cross-lap slot opens at **bottom** |
| Base | `KOR-STAND-Base.dxf` | 1 | 8 tab slots in a + pattern |
| (nested) | `KOR-STAND-nest.dxf` | — | All 3 on a 610×1219 mm sheet |

The two ribs share an identical outer profile and saddle; they differ **only** in
which edge the central cross-lap slot opens from, so they mate into a `+` in plan.

## Key dimensions (mm)

- Gourd cradled: 515.6 OD → saddle arc radius **267.6** (≈10 mm clearance over the bowl).
- Saddle chord 300 wide, dip (sagitta) 46 → 4 contact points at ~±34° from bottom.
- Rib: 370 wide × 298 tall. Shoulder height above base **280**. Cross-lap joint line at y=135.
- Gourd bottom sits **234 mm (9.2 in)** above the base top — matches the photo.
- Tabs: 30 wide × 18 deep, at panel-x ±60 and ±150 (4 per rib, 8 total).
- Base: 480 × 400, 30 mm corner radius, footprint feet span 300 mm each axis.
- Slot width = thickness + **0.2 mm** friction clearance (`SLOT_CLR`).

## CNC notes (read before cutting)

1. **Measure your plywood first.** 18 mm Baltic birch commonly runs 17.3–17.8 mm.
   Set `T` to the *measured* value and re-run, or the cross-lap and tabs will be
   loose. `SLOT_CLR=0.2` targets a snug hand-press fit; loosen to 0.3 for a mallet-free fit.
2. **Dogbones are included** (red `DOGBONE` layer) at every inner slot corner, sized
   for a **1/4 in (6.35 mm) bit**. If you cut with a different tool, change `TOOL_DIA`
   and re-run so the relief matches — otherwise panels won't seat fully into square corners.
3. Layers: `CUT` (profiles/holes/tabs), `DOGBONE` (corner relief), `GUIDE` (sheet
   boundary, do not cut). In CAM, cut DOGBONE + CUT, ignore GUIDE.
4. Tabs and slots are **through cuts**. Add CAM tabs/onion-skin to hold parts in the
   sheet; climb-cut the visible outer profiles for the cleanest edge on birch.
5. Cut the decorative windows and interior slots **before** the outer profile.

## Assembly

1. Stand the **Spine** rib upright (its slot opening points up).
2. Lower the **Cross** rib from above; its solid upper-center drops into the spine's
   top slot while its bottom slot receives the spine's lower column. They lock into a `+`.
3. Set the joined ribs onto the **Base** so all 8 tabs drop through the 8 slots.
4. Optional knockdown locking: a thin wedge or a #8 × 1 in screw up through the base
   into each tab. For a permanent stand, glue the tabs (Titebond III).

## Orientation (convertible)

The saddle is symmetric, so the kora's lean is set by how you seat the gourd:
rotate it so the neck stands near-vertical for **display**, or tip it back a few
degrees toward the player for a **playing cradle**. The ribs contact only the lower
wooden bowl, well below the hide and tacks, so nothing touches the playing surface.

## Stability

Gourd center of mass rides ~490 mm high and the neck adds a fore/aft moment.
The 480×400 base keeps the empty-cradle CoM well inside the footprint, but with the
full neck installed for **display**, add ballast (a 2–3 kg sandbag or steel plate on
the base between the feet) or widen the base to 540×440 (`BASE_X/BASE_Y`) and re-run.
For playing you hold the neck, so this isn't a concern.

## Regenerate

```
pip install ezdxf
python3 kora_stand_gen.py      # writes the 4 DXFs
```

Files in this folder: `kora_stand_gen.py` (source of truth),
the 4 DXFs, `kora_stand_preview.png` (this design), `inspiration for kora stand.png` (reference).
