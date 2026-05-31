# Kora Root-Mode Build Packet

**Status: L2 V5 build-packet candidate**

This repo is a root-mode v4 instrument packet for a 21-string kora-inspired build. It expands the original bare design-table scaffold into a shop-facing packet with design notes, BOM, sourcing assumptions, cut list, validation plan, drawing briefs, RFQ copy, public-site draft, capstone outline, and print packet.

The design source is `kora-design-table.xlsx`. The workbook currently provides the main parametric anchors: bowl diameter and depth, neck length, string lengths, target string tension ramp, nylon density, wound-string density factor, segmented-bowl ring construction, rim geometry, bridge dimensions, and string spacing. Several cell meanings are inferred from formulas rather than workbook labels, so the generated documents mark those assumptions openly.

## Public Release Status

This packet should stay private pending cultural and build-safety review. The kora is not just a generic harp-like mechanism; it belongs to West African Mande/Mandinka musical traditions and is historically associated with jali/griot musicianship. This repo documents an engineering prototype and does not claim lineage authority, traditional build certification, repertoire authority, or permission to market the instrument as culturally authentic.

Before public release, review the provenance language with a knowledgeable cultural advisor or kora player, replace placeholder visuals with measured shop photos or respectful diagrams, and confirm that licensing terms do not accidentally imply cultural ownership.

## Packet Map

- `design.md` - design intent, workbook interpretation, assumptions, cultural provenance notes, and physics model.
- `family-spec.csv` - root build plus lower-risk study variants for future iteration.
- `bom.csv` - make/buy material and hardware list with estimated costs marked as planning estimates.
- `sourcing.csv` - spec-first sourcing table with live price and availability intentionally not verified.
- `cut-list.csv` - rough/final dimensions for segmented bowl, neck, bridge, handles, fixtures, and templates.
- `validation.csv` - dimensional, string-tension, resonance, bridge, joint, safety, and cultural-review checks.
- `string-validation.md` and `string-break-risk.csv` - explicit string break-risk blocker and row-by-row full-stringing gates.
- `assembly-manual.md` - staged build method with hold points before full tension.
- `supplier-rfq.md` - copy/paste RFQ drafts for wood, hide/head material, strings, metalwork, and pickup parts.
- `drawing-brief.md` and `visual-bom-brief.md` - drawing and visual-resource requirements.
- `kora-starter.wl` - starter calculations for string schedule, segmented bowl geometry, and safety plots.
- `risks.md` - red-team concerns and release controls.
- `photo-shotlist.md` - shop and documentation shot list.
- `capstone-deck.md`, `capstone-manifest.json` - presentation outline and artifact inventory.
- `print-packet.md`, `print-packet.html` - print-friendly packet for shop review.
- `site/index.html` - self-contained public build-log draft, currently marked private-review.
- `drawings/`, `cad/`, `cnc/`, `wolfram/` - lightweight technical placeholders and briefs.
- `review-evidence.md` - PR review evidence, local checks, and readiness summary.

## Workbook Snapshot

Current interpreted values from `kora-design-table.xlsx`:

- Bowl outer diameter: 20.3 in.
- Bowl depth: 9.8 in.
- Neck length: 51.2 in.
- String vibrating lengths: 8.7 to 31.1 in.
- Target tension ramp: 8.0 to 14.0 lbf per string.
- Nylon density: 0.04155 lb/in^3.
- Wound-string effective density factor: 2.5x.
- Segmented bowl: 12 segments per ring, 15 deg miter, 0.75 in ring thickness, 14 rings, 168 total segments.
- Bridge height: 6.0 in, bridge width/thickness inputs around 0.75 and 2.5 in, string spacing about 0.273 in by formula.

The current string schedule computes some treble strings at high percent of nylon break strength under the ideal round-string model. Treat the schedule as a design-study table, not a purchase-ready string prescription.

Round 33C/D string validation adds `string-break-risk.csv`: eight nylon rows currently model above the 70 percent prototype break target, nylon string 9 sits at 69.3 percent, and the wound-bass rows still need manufacturer unit-weight or measured mass-per-length data. Full stringing remains blocked until those rows are revised and rechecked.

## Cultural Provenance Notes

External background sources consulted for the provenance framing include the Met Museum collection notes on Mandinka kora objects and Britannica's kora overview. These sources are used only to avoid careless wording; they do not substitute for community review or living maker/player expertise.

- Met Museum kora object notes: https://www.metmuseum.org/art/collection/search/501115
- Britannica kora overview: https://www.britannica.com/art/kora-musical-instrument

## Build Position

This is a conservative hybrid prototype packet:

- A segmented wooden bowl is documented as a calabash substitute, not a traditional-material claim.
- Hide or synthetic head choices are treated as separate resonance and ethics/sourcing decisions.
- A piezo pickup path is planned as optional and should be mechanically isolated from the head until acoustic behavior is understood.
- The neck/body joint, bridge foot, tail anchoring, and head support are treated as primary safety-critical assemblies.

## Readiness

Status: L2 private-review packet. The docs are broad enough for design review, but the packet should not be treated as L3 until cultural review, string-safety revisions, bridge/head proof testing, and measured prototype data are complete.

## License

[CC BY 4.0](LICENSE) - see `LICENSE` for details. Public sharing should wait until the review gates in `risks.md` and `validation.csv` are resolved.
