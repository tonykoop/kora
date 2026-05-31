# `cad/` — CAD assets for the kora-inspired 21-string prototype

## What's here

### SolidWorks source
| File | What it is |
| --- | --- |
| `KOR-000_MasterLayout.SLDPRT` | Parametric MasterLayout part. Source of truth for every driven dimension; design table lives in `KOR-000_MasterLayout.xlsx`. |
| `KOR-000_MasterLayout.xlsx` | Design table (read by SolidWorks). |
| `KOR-000_KoraHarp.SLDASM` | Assembly tying MasterLayout to the part files below. |
| `KOR-000_KoraHarp_ALL_CONFIGS_dimensions.csv` | Flat export of every driven dimension across all configurations. |
| `KOR-000-Gourd.SLDPRT` | Segmented hardwood bowl (168-stave substitute for calabash). |
| `KOR-000-Neck.SLDPRT` | Through-neck spine — continuous structural load path. |
| `KOR-000-Crossbar.SLDPRT` | Neck-to-rim cross brace. |
| `KOR-000-Handle.SLDPRT` | Player hand post (instanced twice in the assembly). |
| `KOR-000-Membrane.SLDPRT` | Hide or synthetic head. |
| `KOR-000-BridgePad.SLDPRT` | Bridge foot pad / cushion against membrane. |
| `KOR-000-Bridge.SLDPRT` | 6.0″ tall notched bridge, two string banks. |
| `KOR-000-Eyebolt.SLDPRT` | Tail anchor (load-rated, rounded contact surfaces). |
| `7815K21_Multipurpose Flanged Sleeve Bearing.SLDPRT` | McMaster-Carr sleeve bearing (×2). |
| `7815K24_High-Strength 932 Bronze Flanged Sleeve Bearing.SLDPRT` | Alternate sleeve bearing for upgrade path. |
| `3032T43_316 Stainless Steel Eyebolt with Nut.SLDPRT` | Stock eyebolt for reference / sourcing. |
| `KOR-000-BasePartTemplate.SLDPRT` | Base part template used to spawn new instances. |
| `kora-parametric-brief.md` | Plain-English brief listing parameters to import from the workbook + CAD warnings. |
| `kora-placeholder.scad` | OpenSCAD placeholder kept for cross-tool reference. |
| `~$…` files | SolidWorks lockfiles — leave alone, they vanish when SW closes the file. |

### glTF export (for the web explorer)
| File / path | What it is |
| --- | --- |
| `KOR-000_KoraHarp/KOR-000_KoraHarp.gltf` | glTF 2.0 JSON metadata. The web explorer (`../explorer.html`) loads this directly via `<model-viewer>`. |
| `KOR-000_KoraHarp/0-N-<part>-N.bin` | One binary buffer per assembly component — 11 buffers total, one per assembly instance (Neck, Gourd, both Handles, Membrane, BridgePad, Bridge, Crossbar, Eyebolt, two Sleeve Bearings). |
| `KOR-000_KoraHarp/leather.jpg` | Texture map for the membrane part. |

## How `explorer.html` consumes the glTF

`explorer.html` (one level up at the repo root) inline-embeds the model as a base64 data URI so the page is fully self-contained — double-click works, no localhost server required.

The packed `KOR-000_KoraHarp.glb` (~971 KB, DRACO-compressed; ~1.3 MB once base64-encoded) lives in a `<script id="kora-glb-data">` tag at the top of the body, and a small `injectCADModel()` function assigns it as the `<model-viewer>` element's `src` on boot. The `images/SolidWorks QuadView.png` four-view shot displays as the poster until the model finishes decoding.

This is the inline-first arrangement (chose 2026-05-17 to make `explorer.html` work as a portable single file). Trade-off: the HTML is ~1.4 MB instead of ~80 KB. Acceptable since the explorer is already not pure-offline (the Wolfram embed iframe + the `model-viewer` JS itself load from CDNs).

If the inline embed gets too heavy later, fall back to either:
- Reference the `.glb` as an external file: `<model-viewer src="cad/KOR-000_KoraHarp.glb">` — requires localhost serving (`python -m http.server 8000` from the kora dir), but trims the HTML back to ~80 KB.
- Reference the multi-buffer glTF directly: `<model-viewer src="cad/KOR-000_KoraHarp/KOR-000_KoraHarp.gltf">` — also requires localhost serving, plus 12 same-origin fetches.

## Re-exporting from SolidWorks → re-packing → re-embedding

When the assembly changes (final details still to come per the v4.3 challenge run), the round-trip is:

1. Open `KOR-000_KoraHarp.SLDASM` in SolidWorks (2024+ has glTF export built in; older versions need an add-in).
2. **File → Save As → glTF 2.0 (`*.gltf`)**. Save into `cad/KOR-000_KoraHarp/` and overwrite the existing files. (`.glb` direct from SolidWorks also works but skips the DRACO-compression step below.)
3. Re-pack the multi-buffer glTF into a single DRACO-compressed `.glb`:
   ```bash
   npx -p gltf-pipeline gltf-pipeline \
       -i cad/KOR-000_KoraHarp/KOR-000_KoraHarp.gltf \
       -o cad/KOR-000_KoraHarp.glb -b -d
   ```
   The `-b` flag asks for a single binary `.glb`; `-d` adds DRACO compression (typically 60–70 % size reduction).
4. Re-base64-embed the new `.glb` into `explorer.html`. Until the instrument-maker skill's generator pass lands, this is a small Python script:
   ```python
   import base64, pathlib
   glb = pathlib.Path("cad/KOR-000_KoraHarp.glb").read_bytes()
   uri = "data:model/gltf-binary;base64," + base64.b64encode(glb).decode()
   src = pathlib.Path("explorer.html").read_text(encoding="utf-8")
   # Replace whatever URI is between the kora-glb-data script tags.
   import re
   src = re.sub(r'(__KORA_GLB_DATA_URI__ = ")[^"]+(")', r'\1' + uri + r'\2', src, count=1)
   pathlib.Path("explorer.html").write_text(src, encoding="utf-8")
   ```
   Once the generator ships, this becomes `python scripts/generate_explorer.py kora`.

## TODOs (non-blocking)

- **Reduce buffer count.** SolidWorks emits one .bin per assembly instance. A `.glb` re-export or a downstream `gltf-pipeline` pass would pack everything into a single binary — smaller wire size, simpler serving.
- **Material assignments.** Current export uses default materials (the only custom map is `leather.jpg` on the membrane). Worth a pass to assign walnut / cedar / brass / nylon-strings PBR materials in SolidWorks Appearances before re-export, so the in-browser model matches the build palette.
- **String geometry.** Strings are present as edges in the SolidWorks model but may render thin / unlit in glTF. A `gltf-pipeline` thicken pass or an explicit cylinder swap would help.
- **Desktop-Wolfram re-author pass.** Independent of CAD, but tracked alongside: `kora-starter.wl` is authored on the WSL Wolfram Engine CLI. A future re-author pass in Wolfram 14.3 desktop (Windows side) could give richer `Manipulate` output before the `wolfram-cloud-sync` Public-Execute publish step.
