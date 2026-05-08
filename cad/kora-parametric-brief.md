# CAD Parametric Brief

## Goal

Build a CAD assembly that keeps the workbook as the source of truth while making the load path visible.

## Parameters To Import

- `bowl_diameter_in = 20.3`
- `bowl_depth_in = 9.8`
- `neck_length_in = 51.2`
- `segments_per_ring = 12`
- `ring_height_in = 0.75`
- `ring_count = 14`
- `rim_segments = 16`
- `bridge_height_in = 6.0`
- `string_count = 21`
- `string_spacing_in = 0.273`

## Required CAD Parts

- segmented bowl ring stack
- rim/head bearing ring
- through-neck or internal spine
- tail anchor and backing block
- bridge with replaceable cap and broad test foot
- hand posts
- optional removable piezo mount

## CAD Warnings

Do not model the shell as load-bearing by default. The string load path should run through the neck/spine and tail anchor. Treat head/head-retention details as provisional until material is chosen.
