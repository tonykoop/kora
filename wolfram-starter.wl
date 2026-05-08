(* Kora root-mode starter notebook code.
   Source: kora-design-table.xlsx, sheet Kora.
   This is a design-study model, not a final string prescription. *)

ClearAll["Global`*"];

g = 386.4; (* in/s^2 *)
nylonDensity = 0.04155; (* lb/in^3 *)
woundDensityFactor = 2.5;
breakStress = 44600; (* psi, nylon reference *)

bowlDiameter = 20.3;
bowlDepth = 9.8;
neckLength = 51.2;
segmentsPerRing = 12;
ringHeight = 0.75;
ringCount = Ceiling[bowlDepth/ringHeight];
totalSegments = ringCount segmentsPerRing;
miterAngle = 180/segmentsPerRing;

stringLengths = {8.7, 9.4, 10.2, 11.0, 12.0, 13.0, 13.8, 15.0, 16.2,
   17.5, 18.5, 19.8, 21.2, 22.5, 24.0, 25.5, 27.0, 28.2, 29.5, 30.5, 31.1};
midi = {86, 84, 82, 81, 79, 77, 76, 74, 72, 70, 69, 67, 65, 64, 62, 60, 58, 57, 55, 53, 53};
freq[n_] := 440 2^((n - 69)/12);
targetTension[i_] := 8 + (i - 1) (14 - 8)/20;
densityFor[i_] := If[i >= 18, nylonDensity woundDensityFactor, nylonDensity];
diameterFor[i_] := 2 Sqrt[targetTension[i] g/(densityFor[i] Pi 4 freq[midi[[i]]]^2 stringLengths[[i]]^2)];
percentBreak[i_] := 100 densityFor[i] 4 freq[midi[[i]]]^2 stringLengths[[i]]^2/(breakStress g);

stringTable = Table[
   <|
    "Index" -> i,
    "MIDI" -> midi[[i]],
    "FrequencyHz" -> N[freq[midi[[i]]], 6],
    "LengthIn" -> stringLengths[[i]],
    "TargetLbf" -> N[targetTension[i], 4],
    "DiameterIn" -> N[diameterFor[i], 5],
    "PercentBreak" -> N[percentBreak[i], 4],
    "MaterialModel" -> If[i >= 18, "Wound effective density", "Nylon"]
    |>,
   {i, 21}
   ];

Dataset[stringTable]

ListLinePlot[
 {stringTable[[All, "PercentBreak"]]},
 PlotRange -> All,
 AxesLabel -> {"String index", "Percent break"},
 PlotLabel -> "Current Workbook String Safety Check",
 Epilog -> {Red, Dashed, Line[{{1, 70}, {21, 70}}]}
 ]

ringSummary = <|
   "BowlDiameterIn" -> bowlDiameter,
   "BowlDepthIn" -> bowlDepth,
   "RingCount" -> ringCount,
   "SegmentsPerRing" -> segmentsPerRing,
   "TotalSegments" -> totalSegments,
   "MiterAngleDeg" -> miterAngle
   |>;

ringSummary
