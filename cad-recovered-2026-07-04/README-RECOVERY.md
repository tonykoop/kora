# Kora CAD recovery — 2026-07-04

Recovered from git history in the `kora` repo. Nothing was lost; the CAD work was
committed on another branch and captured in a stash, and the working tree had been
switched to `maker/kora-doc-refresh` (== origin/main), which is why the files "vanished".

## Sources
- SolidWorks parts/assemblies below: extracted as REAL binaries from commit
  `da5abb8` ("cad") — the tip of branch **sprint/r4-learn-to-play**.
  Same content is also in stash@{0} (`913e0e9`, "On sprint/r4-learn-to-play: kora edits…").
- `cad/neck_cnc/*` (DXF cut files + packet): from branch **sg2/wolfram-embed-epic196**
  (commit `4cb9c47`, "feat(neck): draft CNC packet").

## What's here — the laminate neck assembly you thought disappeared
- KOR-000_KoraNeck.SLDASM      (1,899,508 b)  <- the neck assembly
- KOR-000_KoraNeck.SLDDRW      (1,822,096 b)  <- its drawing
- KOR-000-LaminateNeck.SLDPRT  (256,275 b)    <- 3/4" hardwood laminate layer
- KOR-000-LaminateTop.SLDPRT   (500,793 b)
- KOR-000-LaminateBottom.SLDPRT(183,555 b)
- MirrorKOR-000-LaminateNeck.SLDPRT (213,595 b)
- KOR-000-Neck.SLDPRT          (150,031 b)
- KOR-000_KoraHarp.SLDASM      (3,655,409 b)  <- the updated harp assembly (main has only 855,946 b)
- KOR-000_MasterLayout.SLDPRT  (189,307 b)
- cad/neck_cnc/  KOR-NECK-*.dxf, neck-cnc-packet.md, neck_cnc_gen.py, neck_cnc_preview.png

## Important note on the newer LFS revision
Branch `sg2/wolfram-embed-epic196` also has NEWER saves of the neck files, but stored as
Git-LFS pointers whose binary objects are NOT in the local LFS cache (need `git lfs pull`
from GitHub, only if they were pushed). Sizes differ from the da5abb8 reals, e.g.:
  KOR-000_KoraNeck.SLDASM  LFS=1,400,680 b   vs  da5abb8 real=1,899,508 b
  KOR-000-LaminateNeck     LFS=  230,928 b   vs  da5abb8 real=  256,275 b
If the da5abb8 versions open correctly and look right, use them. If you specifically want
the last LFS save, run `git lfs pull` (or `git lfs fetch --all`) and diff.

## Neck-length note (your "~49in vs ~63in" concern)
In the readable design-table CSV, the `neck_length_in` equation reads **40in** on both
origin/main and the d016df0 re-save — so that parameter itself didn't change between them.
The big difference is in the binary assembly geometry (main 855KB vs da5abb8 3.66MB).
Open KOR-000_KoraHarp.SLDASM here in SolidWorks to confirm the actual neck length; the
da5abb8 save is the most complete CAD state that exists.
