# Rim & Crack Reinforcement Plan — Restoration Kora

_Drafted 2026-06-06. Working notes for stabilizing the cracked gourd rim and adding a continuous internal hoop reinforcement around the half-moon crossbar reliefs._

## The problem

The gourd has **two cracks that predate the original build** — evidenced by two reinforcing sutures the original maker sewed in before applying the first cowhide. The serious one **runs from the rim down to the top neck hole**, so it crosses two stress concentrators at once:

- the **bearing edge**, which is under continuous inward pull from the tacked, stretched membrane, and
- the **neck hole**, which carries the leverage of a 51" neck (every bump or lean torques the shell here).

A crack joining those two points is the most likely place for the shell to keep working open over seasons of humidity swings and string tension. It needs (a) a local repair that closes and bonds the crack, and (b) a structural element that carries ongoing **hoop tension** so the crack stops being a hinge.

### Geometry that constrains the fix (from `kora-restoration-measurements.xlsx`, repo-target column)

| Quantity | Value | Source / note |
|---|---|---|
| Gourd OD (widest) | ~20.3 in | B1 |
| Shell depth | ~9.8 in | B4 |
| Rim opening (ID) | **~18 in (confirm — B5 not yet measured)** | estimate from OD minus wall |
| Internal rim circumference | **~57–58 in** at 18.3 in ID | π × ID |
| Target ring bend radius | **~9.0–9.3 in** | ID ÷ 2 |

> Action: measure **B5 (rim ID)**, **B6 (wall thickness)**, and **B7 (rim/bearing width)** before cutting any reinforcement to length. The whole plan keys off the rim ID.

## Material: aluminum flatbar vs. bamboo

Both are sound choices; they trade differently.

**3003 aluminum flatbar — 1/8" × 1" × 72" (McMaster 9134K11).** Your part pick is correct for this job:

- **3003** is the soft, formable alloy — it cold-rolls to a 9" radius without cracking. (5052 is springier but fights you at this radius; 6061 will crack when bent this tight cold. Don't substitute up the strength chart here.)
- 72" length covers the ~58" internal circumference with ~14" to spare for an overlap/scarf joint.
- 1/8" × 1" gives a genuinely stiff hoop; corrosion-proof; bombproof for decades.
- Trade-off: adds mass and stiffness at the rim and can damp shell vibration slightly. At the rim (near a vibration node for the main air resonance) the acoustic penalty is modest, but it is not zero.

**Split/laminated bamboo strips.** The traditional reinforcement seen in the build videos:

- Acoustically closest to the gourd's own impedance — least change to the voice.
- Easy to notch and fit around the reliefs; springy; glues well with epoxy.
- Trade-off: needs **2–3 laminated layers** (bent-lamination over a form) to match the stiffness of the aluminum, is moisture-sensitive, and is fussier to build into a clean full ring.

**Recommendation:** Use the **3003 aluminum ring as the primary hoop**, since the cracked rim is the failure you're actually trying to stop and aluminum is the more reliable structural tie. If you want to protect the voice, you can hold the aluminum **low on the wall** (see Option B below) so it reinforces without sitting right on the bearing edge. Reserve bamboo as the choice only if you decide acoustic purity outranks maximum security — but then commit to a 3-layer lamination.

## The continuity problem: half-moon reliefs

The wooden crossbar is recessed into **two half-moon notches cut into the rim**, so the rim is not a continuous circle — there are two gaps where a full internal ring would collide with the crossbar. Three ways to keep the reinforcement effective:

**Option A — Notch the crossbar, keep the ring continuous (your idea).**
Rout a shallow channel sized to the flatbar cross-section (1/8" deep × 1" wide) into the underside of each crossbar end, so the aluminum ring passes uninterrupted beneath the crossbar.
- ✅ Truly continuous hoop — strongest result.
- ⚠️ Removes material from the crossbar exactly at its bearing points. Mitigated by the fact that you're **re-turning the crossbar anyway** and can leave extra diameter there; and the relief is only 1/8" deep.
- Sequence note: cut these channels **after** you turn the crossbar to final diameter, and dry-fit the ring first.

**Option B — Drop the ring below the reliefs (recommended default).**
Position the aluminum band as a hoop **on the inner wall, below the depth of the relief notches**, so it never intersects the crossbar. The crossbar then ties the rim across the top; the aluminum ring ties the wall just beneath it.
- ✅ No need to compromise the freshly turned crossbar.
- ✅ Keeps metal off the bearing edge → smaller acoustic penalty.
- ✅ Still bridges the lower ~80–90% of the rim-to-neck-hole crack, where it matters most.
- ⚠️ Doesn't reinforce the topmost ~1" of the crack at the bearing edge → handle that locally (see crack repair below).

**Option C — Two C-arcs + crossbar as the tie.**
Run two aluminum arcs that stop short at each relief; let the crossbar span those two gaps as part of the hoop.
- ✅ No crossbar notching, sits at full rim height.
- ⚠️ Load path now depends on the crossbar-to-rim joints being tight — and your reliefs are currently **oversized** for the crossbar, so those joints aren't tight yet. Only viable after the relief gaps are shimmed (see below). Weakest of the three unless the joinery is excellent.

**Pick:** Default to **Option B**. Upgrade to **Option A** only if, after dry-fitting, you decide you want metal right at the bearing edge over the crack. Avoid C unless the crossbar joints end up very tight.

## Crack-specific repair (do this regardless of ring option)

1. **Clean the crack** — work out old glue/dust; lightly key the inner faces.
2. **Close and bond** — work thin epoxy (or thin CA for a hairline) into the crack, clamp/strap it closed, wipe squeeze-out. The original sutures tell you it wants to open — bond it shut before anything else.
3. **Local patch over the crack** — once the planned **interior fiberglass layer** goes in, lay 2–3 extra plies (a "butterfly" patch) bridging the crack on the inside, oriented across the crack line. The full interior glass layer you already planned is itself a continuous reinforcement with no relief problem — it's doing a lot of this work for you.
4. **Top inch of the crack (if Option B):** add a small dedicated patch or a thin glassed-in spline at the bearing edge where the aluminum ring stops short.
5. **Neck-hole end of the crack:** the bushing/collar that fills the 2.25" hole → 1.85" neck gap (below) can be seated to also **clamp the crack closed** at the neck hole. Two birds.

## Fastening the ring

- **Primary bond: epoxy** the aluminum band to the gourd inner wall (scuff and solvent-wipe the aluminum first; West System G/flex or thickened epoxy is forgiving on an irregular gourd wall).
- **Lock the edges** with the interior fiberglass layer lapping over the top and bottom edges of the band — this ties it in far better than fasteners and won't risk splitting the shell.
- **Avoid screws/rivets through the shell** — the gourd wall splits easily and you already have crack problems. If you want mechanical backup, prefer a couple of countersunk brass screws into the **crossbar/neck**, not the shell.
- **Joint in the ring:** scarf or overlap the two ends ~2–3" and bond; locate the overlap **away from the crack and away from the reliefs**.

## Bending the ring (Maker Nexus)

- Roll **1/8" × 1" 3003 the hard way** (1" dimension in the plane of the curve) on the **slip roller** to ~9" radius. 3003 at this thickness rolls easily; sneak up on the radius in passes and check against a plywood template cut to the rim ID.
- Cut a **plywood disc/template to the measured rim ID** first; bend to match it, then dry-fit in the gourd before bonding.

## Related fit gaps (same "fill the mismatch" family — tracked separately)

These aren't reinforcement but the update lumped them in because they're the same shim/bushing problem:

- **Neck hole 2.25" vs. neck shaft 1.85"** → ~0.20" radial gap. Plan: a turned hardwood (or laminated veneer) **collar/bushing** glued to the neck, or a tapered wrap, sized to the hole; seat it to also close the crack at the neck hole.
- **Reliefs oversized for the re-turned crossbar** → same fix: shim the half-moons with thin hardwood pads glued into the notches, or build the crossbar ends up, so the crossbar seats tight (also a prerequisite if you ever consider Option C).

## Open questions / next measurements

- [ ] Measure **B5 rim ID**, **B6 wall thickness**, **B7 rim width** → sets ring length, bend radius, and band height.
- [ ] Decide **Option A vs B** after a dry-fit of the rolled ring.
- [ ] Confirm interior prep order: wire-brush pulp → sand → **crack bond** → fiberglass (with crack butterfly + ring edge-lap) → ring bonded before or during glass?
- [ ] Aluminum vs bamboo final call (defaulting aluminum/Option B).
