# Kora Root-Mode Design

## Intent

Create a serious build packet for a 21-string kora-inspired hybrid instrument using `kora-design-table.xlsx` as the parametric design source. The intended first build is a learning prototype, not a declaration of traditional authority or a production-ready commercial instrument.

The packet balances six coupled systems:

- string scaling and tension
- tall notched bridge geometry
- hide or membrane-loaded resonator behavior
- neck load path and tail anchoring
- player ergonomics and hand access
- cultural provenance and public-release sensitivity

## Scope Boundary

This packet documents an engineering prototype rooted in measured and parametric assumptions. It does not claim exact acoustic prediction, traditional craft certification, historical completeness, or permission to present the result as an authentic cultural object. The first release should be private until the cultural-review and safety gates in `validation.csv` pass.

## Workbook Source

Source workbook: `kora-design-table.xlsx`, sheet `Kora`.

The workbook is currently a compact formula sheet without visible human-readable row labels. The following interpretations are inferred from cell values and formulas and should be confirmed before CNC or string purchasing:

| Workbook area | Interpreted meaning | Current value or formula |
| --- | --- | --- |
| `B5` | Bowl outside diameter | 20.3 in |
| `B6` | Bowl depth | 9.8 in |
| `B7` | Neck length | 51.2 in |
| `B8:B9` | Shortest and longest string lengths | 8.7 in, 31.1 in |
| `B10:B11` | Target string tension ramp | 8.0 to 14.0 lbf |
| `B12` | Nylon density | 0.04155 lb/in^3 |
| `B13` | Wound-string effective density factor | 2.5x |
| `B14` | Wound-string start index | 18 |
| `B19:B24` | Segmented bowl setup | 12 segments/ring, 0.75 in ring height, 14 rings, 168 segments |
| `B45:B50` | Rim setup | 16 segments, 11.25 deg miter, 0.5 in rim thickness input |
| `B83:B88` | Bridge setup | 2.5 in/6.0 in/0.75 in inputs, 0.125 in slot clearance, 0.273 in spacing |
| Rows `59:79` | 21-string pitch/length/tension schedule | Mersenne-Taylor formulas |

## Cultural Provenance

The kora is widely documented as a West African 21-string bridge-harp/harp-lute associated with Mande/Mandinka traditions and jali/griot musicianship. The Met Museum collection notes describe the kora as a 21-string instrument from the Mande region with a calabash resonator, hide soundboard, long neck, handles, and a tall bridge. Britannica similarly describes a long hardwood neck passing through a hide-covered calabash resonator, with 21 strings over a notched bridge.

Design language for this repo should therefore use terms such as `kora-inspired prototype`, `engineering study`, and `hybrid build packet`. Avoid wording such as `authentic`, `traditional replica`, `master kora`, or `improved kora`.

Background sources:

- https://www.metmuseum.org/art/collection/search/501115
- https://www.britannica.com/art/kora-musical-instrument

## Governing Models

### Strings

Use the Mersenne-Taylor string model:

```text
f = (1 / (2 L)) sqrt(T / mu)
mu = density pi (diameter / 2)^2
diameter = 2 sqrt(T g / (density pi 4 L^2 f^2))
```

Workbook constants:

- `g = 386.4 in/s^2`
- nylon density = `0.04155 lb/in^3`
- assumed nylon breaking stress = `44600 psi`
- wound-string effective density factor = `2.5x`

Important limitation: percent break is independent of diameter in the ideal round-string model. The current workbook schedule calculates several treble strings near or above practical nylon break targets. This is a safety and design-readiness issue, not a cosmetic issue.

### Resonator

The workbook models a segmented wooden bowl replacing a natural calabash. This changes mass, stiffness, damping, and attachment options. Do not treat the bowl as acoustically equivalent to a traditional calabash without measurements.

The first prototype should measure:

- open bowl air resonance before head installation
- head tap modes after skin or synthetic membrane installation
- bridge-loaded head deflection at staged tension
- microphone response before and after optional piezo installation

### Bridge

The bridge is load-bearing and tone-shaping. It must separate two string banks, maintain string notch spacing, transfer load into the head without tearing it, and avoid rocking under asymmetric playing loads.

Workbook bridge hints:

- height: 6.0 in
- width/thickness inputs: 0.75 in and 2.5 in, to confirm by drawing
- slot clearance: 0.125 in
- string spacing formula: `6 / (21 + 1) = 0.273 in`

### Neck And Load Path

The neck is interpreted as 51.2 in long. A traditional neck passes through the resonator; this hybrid packet should preserve a continuous structural load path rather than relying on the bowl wall alone.

Minimum first-build requirement:

- continuous neck or internal spine through the bowl
- separate tail ring or tail bar with mechanical backup
- no full string load until joint proof-load and bridge-foot tests pass

## Current String Schedule

The schedule below is calculated from the workbook formula pattern and current constants. It is a planning table, not a purchase-ready prescription.

| # | Note | MIDI | Freq Hz | Length in | Type | Target lbf | Diameter in | Percent break |
| ---: | --- | ---: | ---: | ---: | --- | ---: | ---: | ---: |
| 1 | D6 | 86 | 1174.66 | 8.70 | Nylon | 8.00 | 0.0151 | 100.7 |
| 2 | C6 | 84 | 1046.50 | 9.40 | Nylon | 8.30 | 0.0159 | 93.3 |
| 3 | A#5 | 82 | 932.33 | 10.20 | Nylon | 8.60 | 0.0168 | 87.2 |
| 4 | A5 | 81 | 880.00 | 11.00 | Nylon | 8.90 | 0.0168 | 90.4 |
| 5 | G5 | 79 | 783.99 | 12.00 | Nylon | 9.20 | 0.0175 | 85.4 |
| 6 | F5 | 77 | 698.46 | 13.00 | Nylon | 9.50 | 0.0185 | 79.5 |
| 7 | E5 | 76 | 659.26 | 13.80 | Nylon | 9.80 | 0.0187 | 79.8 |
| 8 | D5 | 74 | 587.33 | 15.00 | Nylon | 10.10 | 0.0196 | 74.9 |
| 9 | C5 | 72 | 523.25 | 16.20 | Nylon | 10.40 | 0.0207 | 69.3 |
| 10 | A#4 | 70 | 466.16 | 17.50 | Nylon | 10.70 | 0.0218 | 64.2 |
| 11 | A4 | 69 | 440.00 | 18.50 | Nylon | 11.00 | 0.0222 | 63.9 |
| 12 | G4 | 67 | 392.00 | 19.80 | Nylon | 11.30 | 0.0236 | 58.1 |
| 13 | F4 | 65 | 349.23 | 21.20 | Nylon | 11.60 | 0.0250 | 52.9 |
| 14 | E4 | 64 | 329.63 | 22.50 | Nylon | 11.90 | 0.0253 | 53.0 |
| 15 | D4 | 62 | 293.66 | 24.00 | Nylon | 12.20 | 0.0270 | 47.9 |
| 16 | C4 | 60 | 261.63 | 25.50 | Nylon | 12.50 | 0.0288 | 42.9 |
| 17 | A#3 | 58 | 233.08 | 27.00 | Nylon | 12.80 | 0.0309 | 38.2 |
| 18 | A3 | 57 | 220.00 | 28.20 | Wound | 13.10 | 0.0201 | 92.8 |
| 19 | G3 | 55 | 196.00 | 29.50 | Wound | 13.40 | 0.0218 | 80.6 |
| 20 | F3 | 53 | 174.61 | 30.50 | Wound | 13.70 | 0.0239 | 68.4 |
| 21 | F3 | 53 | 174.61 | 31.10 | Wound | 14.00 | 0.0237 | 71.1 |

Action: reduce treble target tension, lengthen treble scale, change material, or revise pitch assignment before stringing to full pitch. `string-break-risk.csv` is the row-by-row blocker register for this schedule, and `string-validation.md` defines the full-stringing hold points.

## Design Assumptions

- The segmented bowl is a practical shop substitute for calabash, not a cultural or acoustic equivalence claim.
- Neck stock is a straight-grained hardwood blank, final species to be selected for strength and workability.
- Head material is either ethically sourced hide or a synthetic membrane selected after supplier review.
- The first bridge is sacrificial and should be built with extra footprint options for testing.
- The first stringing uses a staged low-tension mule schedule before final target pitches.
- Optional piezo pickup is installed only after the acoustic bridge/head behavior is known.

## Done Criteria

- Workbook labels are clarified or a companion cell map is added.
- Bridge and neck load path are drawn with dimensions, tolerances, and proof-load method.
- String schedule passes percent-break and handling checks.
- Head material and attachment method are sourced with ethical and safety notes.
- Cultural review confirms that public wording is respectful and not overclaiming.
- A measured prototype updates `validation.csv` and the workbook.
