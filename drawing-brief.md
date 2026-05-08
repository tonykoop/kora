# Drawing Brief

## Required Drawing Set

1. `drawings/kora-overview.svg` - whole-instrument orthographic overview with bowl diameter, bowl depth, neck length, bridge height, string length range, centerline, and tail anchor.
2. `drawings/bowl-ring-stack.svg` - segmented bowl profile with 14 rings, 12 segments per ring, 15 deg miter note, and depth datum.
3. `drawings/bridge-geometry.svg` - bridge blank, notch spacing, split-bank concept, foot pad, and warning that exact bank layout needs player review.
4. `drawings/load-path-section.svg` - neck/spine, tail anchor, bridge/head load, and bowl wall bypass.
5. `drawings/head-retention-detail.svg` - tacked, laced, or hoop variants after material choice.
6. `drawings/ergonomic-player-view.svg` - seated playing posture with hand posts and wrist-risk zones.

## Technical Standard

Every build-critical drawing should include:

- title block, date, revision, units in inches
- workbook source cell references
- centerline and bridge/tail datums
- dimensions and tolerances separated into fit-critical, load-critical, and visual
- material assumptions
- validation hold points

## Current Status

The SVG files in `drawings/` are lightweight briefs/placeholders. They are not CNC-ready drawings. Use them to coordinate CAD and shop review, then replace them with dimensioned CAD exports before public release or machining.
