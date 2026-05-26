(* ============================================================================
   Kora Acoustic Design Notebook
   ----------------------------------------------------------------------------
   Purpose: Physics-bounded design analysis for the 21 in kora master layout.
   Sweeps bowl chord factor, sound hole size, and bridge placement against
   the coupled Helmholtz + membrane + string resonator system. Outputs target
   ranges for each parameter and validates the current geometry choice.

   Source of truth: SolidWorks masterLayout (KOR-000_KoraHarp), measured string
   lengths from 3DSketch1, latest revision 2026-05-15.

   IMPORTANT: All predictions are bounded estimates. Real koras deviate ~20%
   from these calculations due to hide anisotropy, bowl wall stiffness, and
   bridge mass. Use as design guidance; verify on physical prototype.
   ============================================================================ *)

ClearAll["Global`*"];

(* ============================================================================
   SECTION 1 — CONSTANTS AND CURRENT GEOMETRY
   ============================================================================ *)

(* Physical constants *)
gInchPerS2 = 386.4;                (* gravitational accel, in/s^2 *)
cSoundInPerS = 13500;              (* speed of sound in air at 20°C, in/s *)
cSoundMperS = 343;                 (* speed of sound, m/s *)

(* String materials *)
nylonDensity = 0.04155;            (* lb/in^3 *)
woundDensityFactor = 2.5;          (* effective density multiplier for wound strings *)
nylonBreakStressPsi = 44600;       (* psi, nylon breaking stress *)

(* Current SolidWorks master geometry — keep in sync with the CSV *)
bowlDiameterIn = 21.0;
chordFactor = 0.55;                (* sphere-chord-factor; bowl_depth/bowl_diameter *)
bowlDepthIn = bowlDiameterIn * chordFactor;
gourdWallIn = 5/16;                (* membrane mounts on top of this wall *)

soundHoleWIn = 3.12;               (* oval port short axis *)
soundHoleHIn = 5.00;               (* oval port long axis *)

bridgeHeightIn = 6.0;
bridgePadTIn = 0.275;

(* Bridge placement on membrane — what we're trying to design *)
bridgeOffsetFromCenterIn = 3.5;    (* toward player, on membrane centerline *)

(* String lengths measured from SolidWorks 3DSketch1, sorted treble->bass *)
stringLengthsIn = {21.92, 23.01, 23.83, 25.00, 25.90, 27.08, 28.13, 29.34,
                   30.48, 31.81, 32.99, 34.36, 35.68, 37.13, 38.53, 40.02,
                   41.66, 43.35, 44.75, 46.63, 48.11};

(* ============================================================================
   SECTION 2 — BOWL CAVITY GEOMETRY
   Spherical-cap volume from chord factor.
   ============================================================================ *)

(* For a sphere-cap bowl: opening diameter D, depth h.
   Sphere radius R = (D^2/4 + h^2) / (2h).
   Cap volume V = (pi h^2 / 3) (3 R - h). *)

sphereRadius[d_, h_] := (d^2/4 + h^2) / (2 h);
capVolume[d_, h_] := (Pi h^2 / 3) (3 sphereRadius[d, h] - h);

(* Current bowl *)
currentSphereR = sphereRadius[bowlDiameterIn, bowlDepthIn];
currentVolumeIn3 = capVolume[bowlDiameterIn, bowlDepthIn];
currentVolumeL = currentVolumeIn3 * 0.01639;  (* in^3 to liters *)

Print["=== BOWL GEOMETRY ==="];
Print["Bowl diameter: ", bowlDiameterIn, " in"];
Print["Bowl depth: ", N[bowlDepthIn, 4], " in (chord factor ", chordFactor, ")"];
Print["Implied sphere radius: ", N[currentSphereR, 4], " in"];
Print["Cavity volume: ", N[currentVolumeIn3, 4], " in^3 (", N[currentVolumeL, 4], " L)"];

(* Volume table across chord factors *)
chordFactorTable = Table[
   With[{h = bowlDiameterIn * cf},
    <|
     "ChordFactor" -> cf,
     "DepthIn" -> N[h, 4],
     "VolumeIn3" -> N[capVolume[bowlDiameterIn, h], 4],
     "VolumeL" -> N[capVolume[bowlDiameterIn, h] * 0.01639, 3]
     |>],
   {cf, {0.40, 0.45, 0.50, 0.55, 0.60}}];

Print[""];
Print["=== VOLUME vs CHORD FACTOR (21 in bowl) ==="];
Dataset[chordFactorTable]

(* ============================================================================
   SECTION 3 — HELMHOLTZ AIR RESONANCE
   f_H = (c / 2 pi) sqrt(A / (V * L_eff))
   ============================================================================ *)

(* Effective port length: wall thickness + 1.7 r for unflanged hole.
   For oval port, use area-equivalent circular radius. *)

portArea[w_, h_] := Pi * w * h / 4;            (* ellipse area *)
portEffRadius[w_, h_] := Sqrt[portArea[w, h] / Pi];
portEffLength[w_, h_, t_] := t + 1.7 * portEffRadius[w, h];

helmholtzHz[a_, v_, leff_] := (cSoundInPerS / (2 Pi)) Sqrt[a / (v leff)];

(* Current configuration *)
currentPortA = portArea[soundHoleWIn, soundHoleHIn];
currentPortLeff = portEffLength[soundHoleWIn, soundHoleHIn, gourdWallIn];
currentHelmholtz = helmholtzHz[currentPortA, currentVolumeIn3, currentPortLeff];

Print[""];
Print["=== HELMHOLTZ AIR RESONANCE — CURRENT GEOMETRY ==="];
Print["Port area: ", N[currentPortA, 4], " in^2"];
Print["Effective port length: ", N[currentPortLeff, 4], " in"];
Print["Air resonance frequency: ", N[currentHelmholtz, 4], " Hz"];
Print["  -> approximate pitch: ",
 SoundNote[Round[12 Log[2, currentHelmholtz/440] + 69] - 69]];

(* Helmholtz sweep across chord factor at fixed port *)
helmholtzVsChord = Table[
   With[{h = bowlDiameterIn * cf,
     v = capVolume[bowlDiameterIn, bowlDiameterIn * cf]},
    <|
     "ChordFactor" -> cf,
     "VolumeIn3" -> N[v, 4],
     "F_H_Hz" -> N[helmholtzHz[currentPortA, v, currentPortLeff], 4]
     |>],
   {cf, 0.40, 0.60, 0.025}];

Print[""];
Print["=== HELMHOLTZ vs CHORD FACTOR (fixed port 3.12 x 5.0 in oval) ==="];
Dataset[helmholtzVsChord]

helmholtzChordPlot = ListLinePlot[
  Table[{cf, helmholtzHz[currentPortA,
     capVolume[bowlDiameterIn, bowlDiameterIn * cf], currentPortLeff]},
   {cf, 0.40, 0.60, 0.005}],
  PlotRange -> All,
  Frame -> True,
  FrameLabel -> {"Chord factor (depth/diameter)", "Helmholtz frequency (Hz)"},
  PlotLabel -> "Air resonance vs bowl chord factor",
  GridLines -> Automatic,
  Epilog -> {
    Red, Dashed, Line[{{chordFactor, 0}, {chordFactor, 200}}],
    Black, Text["current 0.55", {chordFactor + 0.01, 130}, {-1, 0}]}
  ];

(* Helmholtz sweep across port diameter (circular equivalent) at fixed bowl *)
helmholtzVsPort = Table[
   With[{a = Pi (dPort/2)^2,
     leff = gourdWallIn + 1.7 (dPort/2)},
    <|
     "PortDiaIn" -> dPort,
     "PortAreaIn2" -> N[a, 4],
     "F_H_Hz" -> N[helmholtzHz[a, currentVolumeIn3, leff], 4]
     |>],
   {dPort, 1.5, 6.0, 0.5}];

Print[""];
Print["=== HELMHOLTZ vs PORT DIAMETER (circular equivalent, current bowl) ==="];
Dataset[helmholtzVsPort]

helmholtzPortPlot = ListLinePlot[
  Table[{dPort,
    helmholtzHz[Pi (dPort/2)^2, currentVolumeIn3,
     gourdWallIn + 1.7 (dPort/2)]},
   {dPort, 1.0, 7.0, 0.05}],
  PlotRange -> All,
  Frame -> True,
  FrameLabel -> {"Port diameter (in, circular equivalent)",
    "Helmholtz frequency (Hz)"},
  PlotLabel -> "Air resonance vs port size (chord factor 0.55)",
  GridLines -> Automatic,
  Epilog -> {
    Red, Dashed,
    Line[{{2 portEffRadius[soundHoleWIn, soundHoleHIn], 0},
      {2 portEffRadius[soundHoleWIn, soundHoleHIn], 250}}],
    Black, Text["current d_eff = 3.95 in",
     {2 portEffRadius[soundHoleWIn, soundHoleHIn] + 0.1, 200}, {-1, 0}]}
  ];

(* ============================================================================
   SECTION 4 — MEMBRANE VIBRATION MODES
   Circular membrane: f_mn = (c_m / 2 pi) (alpha_mn / R_m)
   where c_m = sqrt(T_per_length / sigma).
   ============================================================================ *)

(* Membrane physical parameters — estimates, refine after prototype tap test *)
membraneTensionNperM = 3000;        (* tension per unit length, N/m — hide range 1000-5000 *)
membraneDensityKgM2 = 1.2;          (* surface density, kg/m^2 — hide ~0.7-2.0 *)

membraneRadiusM = bowlDiameterIn * 0.0254 / 2;
membraneWaveSpeed = Sqrt[membraneTensionNperM / membraneDensityKgM2];

(* Bessel-root frequencies. Mode (m,n) uses the n-th positive root of J_m. *)
modeFreq[m_, n_, R_, cm_] := (cm / (2 Pi)) (BesselJZero[m, n] / R);

(* Lowest 8 modes *)
modeList = {{0, 1}, {1, 1}, {2, 1}, {0, 2}, {3, 1}, {1, 2}, {4, 1}, {2, 2}};

membraneModeTable = Table[
   <|
    "Mode" -> StringJoin["(", ToString[m], ",", ToString[n], ")"],
    "BesselRoot" -> N[BesselJZero[m, n], 5],
    "FreqHz" -> N[modeFreq[m, n, membraneRadiusM, membraneWaveSpeed], 4],
    "RatioToFundamental" ->
     N[BesselJZero[m, n] / BesselJZero[0, 1], 4]
    |>,
   {mn, modeList}, {m, mn[[1]]}, {n, mn[[2]]}];
membraneModeTable = Flatten[membraneModeTable];

Print[""];
Print["=== MEMBRANE MODES ==="];
Print["Membrane radius: ", N[membraneRadiusM, 4], " m"];
Print["Wave speed (T = ", membraneTensionNperM, " N/m, sigma = ",
  membraneDensityKgM2, " kg/m^2): ", N[membraneWaveSpeed, 4], " m/s"];
Dataset[membraneModeTable]

(* Mode shape visualization — first 6 modes *)
modeShapeOf[m_, n_, r_, theta_] :=
  BesselJ[m, BesselJZero[m, n] r] Cos[m theta];

membraneShapePlots = Table[
   DensityPlot[
    Evaluate[modeShapeOf[mn[[1]], mn[[2]], Sqrt[x^2 + y^2], ArcTan[x, y]]],
    {x, -1, 1}, {y, -1, 1},
    RegionFunction -> Function[{x, y}, x^2 + y^2 <= 1],
    PlotLabel -> StringJoin["(", ToString[mn[[1]]], ",", ToString[mn[[2]]], ") "],
    ColorFunction -> "TemperatureMap",
    PlotPoints -> 40,
    Frame -> False,
    PlotLegends -> None,
    AspectRatio -> 1,
    ImageSize -> 180
    ],
   {mn, modeList[[1 ;; 6]]}];

(* ============================================================================
   SECTION 5 — BRIDGE PLACEMENT ANALYSIS
   For a bridge at (r_b, theta_b = 0) on a circular membrane, the coupling
   strength to mode (m,n) is |J_m(alpha_mn r_b / R)|. Bridge sits on a node
   if this value is near zero.
   ============================================================================ *)

bridgeRadiusRatio = bridgeOffsetFromCenterIn / (bowlDiameterIn / 2);

bridgeCoupling[m_, n_, rRatio_] :=
  Abs[BesselJ[m, BesselJZero[m, n] rRatio]];

bridgeCouplingTable = Table[
   With[{mode = StringJoin["(", ToString[mn[[1]]], ",", ToString[mn[[2]]], ")"]},
    <|
     "Mode" -> mode,
     "FreqHz" -> N[modeFreq[mn[[1]], mn[[2]], membraneRadiusM, membraneWaveSpeed], 4],
     "BridgeCoupling" -> N[bridgeCoupling[mn[[1]], mn[[2]], bridgeRadiusRatio], 4],
     "NearNode" ->
      If[bridgeCoupling[mn[[1]], mn[[2]], bridgeRadiusRatio] < 0.1,
       "YES - bridge near node, mode killed",
       If[bridgeCoupling[mn[[1]], mn[[2]], bridgeRadiusRatio] < 0.3,
        "weak coupling", "good coupling"]]
     |>],
   {mn, modeList}];

Print[""];
Print["=== BRIDGE PLACEMENT — MODE COUPLING ==="];
Print["Bridge offset from membrane center: ", bridgeOffsetFromCenterIn, " in"];
Print["Radial position ratio (r/R): ", N[bridgeRadiusRatio, 4]];
Dataset[bridgeCouplingTable]

(* Bridge coupling sweep across offset *)
bridgeSweepPlot = Plot[
  Evaluate[
   Table[bridgeCoupling[mn[[1]], mn[[2]], rRatio],
    {mn, modeList[[1 ;; 6]]}]],
  {rRatio, 0, 1},
  PlotRange -> {0, 1.05},
  Frame -> True,
  FrameLabel -> {"Bridge offset / membrane radius", "Mode coupling |J_m|"},
  PlotLabel -> "Bridge placement vs mode coupling — avoid coupling near zero",
  PlotLegends ->
   StringJoin["(", ToString[#[[1]]], ",", ToString[#[[2]]], ")"] & /@
    modeList[[1 ;; 6]],
  GridLines -> Automatic,
  Epilog -> {
    Red, Dashed,
    Line[{{bridgeRadiusRatio, 0}, {bridgeRadiusRatio, 1.05}}],
    Black, Text[
     StringJoin["current ", ToString[N[bridgeRadiusRatio, 3]]],
     {bridgeRadiusRatio + 0.02, 0.95}, {-1, 0}]}
  ];

(* Recommended bridge zone: r/R in 0.25 to 0.45, avoiding the (0,2) node at 0.436 *)
recommendedBridgeZoneIn = {0.25, 0.40} * (bowlDiameterIn / 2);
Print[""];
Print["=== RECOMMENDED BRIDGE PLACEMENT ZONE ==="];
Print["r/R range: 0.25 to 0.40 (avoids (0,2) node at r/R = 0.436)"];
Print["Inches from center: ",
 N[recommendedBridgeZoneIn[[1]], 3], " to ",
 N[recommendedBridgeZoneIn[[2]], 3]];

(* ============================================================================
   SECTION 6 — STRING ACOUSTIC SCHEDULE
   Using measured 3DSketch1 lengths, derive required string gauges + tensions
   for a target tuning.
   ============================================================================ *)

(* Tuning: F major heptatonic, 21 strings F3 (string 21) to E6 (string 1).
   For traditional kora tunings (Tomoraba, etc.) substitute the MIDI list. *)

(* Strings indexed 1=treble, 21=bass — matches sorted stringLengthsIn order *)
midiF3toE6 = {88, 86, 84, 82, 81, 79, 77, 76, 74, 72,
              70, 69, 67, 65, 64, 62, 60, 58, 57, 55, 53};
(* Treble E6=88 ... Bass F3=53 *)

(* Frequency from MIDI *)
freqFromMidi[n_] := 440. * 2^((n - 69)/12);

(* Tension ramp — 8 lbf at treble, 14 lbf at bass, linear *)
targetTensionLbf[i_] := 8.0 + (i - 1) * (14.0 - 8.0) / 20.0;

(* Wound strings on lowest 4 *)
isWound[i_] := i >= 18;
effDensity[i_] := If[isWound[i], nylonDensity * woundDensityFactor, nylonDensity];

(* From f = (1/2L) sqrt(T g / mu), where mu = rho pi (d/2)^2:
   d = 2 sqrt( T g / (rho pi (2 L f)^2 ) ) *)
diameterIn[i_] :=
  2 Sqrt[targetTensionLbf[i] gInchPerS2 /
    (effDensity[i] Pi (2 stringLengthsIn[[i]] freqFromMidi[midiF3toE6[[i]]])^2)];

stressPsiOf[i_] :=
  targetTensionLbf[i] / (Pi (diameterIn[i]/2)^2);

percentBreakOf[i_] :=
  100 * stressPsiOf[i] / nylonBreakStressPsi;

safetyFlag[i_] := Which[
   percentBreakOf[i] > 100, "BREAKS",
   percentBreakOf[i] > 85, "UNSAFE",
   percentBreakOf[i] > 70, "MARGINAL",
   True, "OK"];

stringScheduleTable = Table[
   <|
    "Idx" -> i,
    "MIDI" -> midiF3toE6[[i]],
    "Note" ->
     {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}[[
       Mod[midiF3toE6[[i]], 12] + 1]] <>
      ToString[Quotient[midiF3toE6[[i]], 12] - 1],
    "FreqHz" -> N[freqFromMidi[midiF3toE6[[i]]], 5],
    "LengthIn" -> stringLengthsIn[[i]],
    "TargetLbf" -> N[targetTensionLbf[i], 3],
    "Material" -> If[isWound[i], "Wound (2.5x)", "Nylon"],
    "DiaIn" -> N[diameterIn[i], 4],
    "PercentBreak" -> N[percentBreakOf[i], 4],
    "Status" -> safetyFlag[i]
    |>,
   {i, 21}];

Print[""];
Print["=== STRING SCHEDULE (F major, F3-E6, 21 strings) ==="];
Dataset[stringScheduleTable]

stringBreakPlot = ListLinePlot[
  Table[percentBreakOf[i], {i, 21}],
  PlotRange -> {0, 250},
  Frame -> True,
  FrameLabel -> {"String index (1=treble, 21=bass)", "Percent of break stress"},
  PlotLabel -> "String safety check — values above 70 are risky",
  GridLines -> Automatic,
  PlotMarkers -> Automatic,
  Epilog -> {
    Red, Dashed, Line[{{1, 100}, {21, 100}}],
    Orange, Dashed, Line[{{1, 85}, {21, 85}}],
    Yellow, Dashed, Line[{{1, 70}, {21, 70}}],
    Black,
    Text["BREAK (100%)", {19, 105}, {1, 0}],
    Text["UNSAFE (85%)", {19, 90}, {1, 0}],
    Text["MARGINAL (70%)", {19, 75}, {1, 0}]}
  ];

(* ============================================================================
   SECTION 7 — VALIDATION SUMMARY
   ============================================================================ *)

Print[""];
Print["==============================================================="];
Print["ACOUSTIC DESIGN SUMMARY — 21 in kora, chord 0.55"];
Print["==============================================================="];

helmholtzNote = With[{midi = Round[12 Log[2, currentHelmholtz/440] + 69]},
   StringJoin[
    {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}[[
      Mod[midi, 12] + 1]],
    ToString[Quotient[midi, 12] - 1]]];

m01Freq = modeFreq[0, 1, membraneRadiusM, membraneWaveSpeed];
m01Note = With[{midi = Round[12 Log[2, m01Freq/440] + 69]},
   StringJoin[
    {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}[[
      Mod[midi, 12] + 1]],
    ToString[Quotient[midi, 12] - 1]]];

summary = <|
   "Bowl_diameter_in" -> bowlDiameterIn,
   "Chord_factor" -> chordFactor,
   "Bowl_depth_in" -> N[bowlDepthIn, 4],
   "Volume_in3" -> N[currentVolumeIn3, 4],
   "Volume_L" -> N[currentVolumeL, 4],
   "Port_area_in2" -> N[currentPortA, 4],
   "Port_d_eff_in" -> N[2 portEffRadius[soundHoleWIn, soundHoleHIn], 4],
   "Helmholtz_Hz" -> N[currentHelmholtz, 4],
   "Helmholtz_note" -> helmholtzNote,
   "Membrane_fundamental_Hz" -> N[m01Freq, 4],
   "Membrane_fundamental_note" -> m01Note,
   "Bridge_offset_in" -> bridgeOffsetFromCenterIn,
   "Bridge_r_over_R" -> N[bridgeRadiusRatio, 4],
   "Bridge_node_check" ->
    If[AllTrue[modeList, bridgeCoupling[#[[1]], #[[2]], bridgeRadiusRatio] > 0.1 &],
     "PASS — bridge couples to all first 8 modes",
     "FAIL — bridge near a node, see coupling table"],
   "String_lowest_Hz" -> N[freqFromMidi[Min[midiF3toE6]], 4],
   "String_highest_Hz" -> N[freqFromMidi[Max[midiF3toE6]], 4],
   "Strings_in_break" -> Count[Range[21], _?(percentBreakOf[#] > 100 &)],
   "Strings_unsafe" ->
    Count[Range[21], _?(70 < percentBreakOf[#] <= 100 &)],
   "Strings_ok" -> Count[Range[21], _?(percentBreakOf[#] <= 70 &)]
   |>;

Dataset[summary]

Print[""];
Print["NEXT STEPS:"];
Print["  1. If 'Strings_in_break' or 'Strings_unsafe' > 0, revise the tuning"];
Print["     (lower the top pitch) or revise the bridge geometry to make"];
Print["     treble strings physically shorter."];
Print["  2. After prototype build, tap-test the membrane and compare measured"];
Print["     fundamental against predicted ", N[m01Freq, 3], " Hz."];
Print["  3. Tap-test the bowl with port covered and uncovered to confirm"];
Print["     Helmholtz frequency near ", N[currentHelmholtz, 3], " Hz."];
Print["  4. Sweep chord factor and port size in this notebook to find the"];
Print["     combination that puts Helmholtz where you want it relative to"];
Print["     the bass tuning."];

(* ============================================================================
   Display all plots in a grid
   ============================================================================ *)

Print[""];
Print["=== PLOTS ==="];

GraphicsGrid[{
   {helmholtzChordPlot, helmholtzPortPlot},
   {bridgeSweepPlot, stringBreakPlot}
   }, ImageSize -> 1100]

Print[""];
Print["=== MEMBRANE MODE SHAPES (first 6 modes) ==="];
GraphicsGrid[{membraneShapePlots[[1 ;; 3]], membraneShapePlots[[4 ;; 6]]},
  ImageSize -> 800]
