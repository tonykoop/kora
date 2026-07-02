# Adam plugin → SolidWorks kora assembly (GENERATED — not a measured master)

Native SolidWorks assembly produced by the **Adam plugin driving SolidWorks**
(free-trial credits), prompted by Tony on 2026-07-02 as the third modality in
the Code-CAD Arena pilot series (CLI blind / CADAM image-conditioned / Adam
in-CAD). **This is a generated draft, not a measured master.** Tony's verdict
on first review: *worth keeping, needs changes.*

## Contents

- `Kora_*.SLDPRT` (8 parts: bowl, soundboard, neck, bridge, handle, crossbar,
  tailpiece, strings) + `Kora_Assembly.SLDASM` — native SolidWorks sources
- `Kora_Assembly.STL` — single-file mesh export (millimetres), used for the
  arena objective gate
- `Kora_Assembly.STEP` + per-part `Kora_*.STEP` — neutral-format exports

## Arena scoring

Ingested into `runs/code_cad_arena/round3` (makerbench-hwe) as entrant
`adam-solidworks`, trial `kora__seed0__rep0__adam-solidworks` via
`arena ingest-candidate` (#616). Objective mesh gate: **0.833** — the mesh
arrives as 57 distinct bodies (21 strings + parts) but is not watertight,
which is typical of SolidWorks assembly tessellation rather than a design
error.

Export provenance: STL/STEP were exported headlessly from the running
SolidWorks session via COM (`kora_export.vbs`,
`swSTLComponentsIntoOneFile`), verified in millimetres (bounding box
580 × 1573 × 295 mm).
