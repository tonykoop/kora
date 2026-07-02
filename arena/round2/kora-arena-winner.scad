// =====================================================================
// MakerBench Code-CAD Arena — instrument: kora (seed 0)
// 21-string West African bridge harp, multi-part assembly
//
// Parts (each its own module / distinct body):
//   1. bowl()      — hemispherical calabash resonator + flat soundboard
//   2. neck()      — long straight neck, passes through the bowl
//   3. bridge()    — tall vertical notched bridge (21 notch positions:
//                    11 on left edge, 10 on right edge), stands on board
//   4. handles()   — two vertical hand grips flanking the strings
//   5. strings()   — 21 stylized strings, neck -> bridge notches
//
// Envelope check (must fit 1500 x 700 x 700 mm):
//   X: -308 .. 975  = 1283   OK
//   Y: -258 .. 258  =  516   OK
//   Z: -249 .. 256  =  505   OK
// Min wall: bowl shell 8 mm (7.7 mm at pole), board 6 mm, strings d2 mm.
// =====================================================================

// ------------------------- global parameters -------------------------
string_count   = 21;

bowl_dia       = 516;              // outer diameter at the rim
bowl_depth     = 249;              // outer depth below the rim plane
bowl_wall      = 8;                // shell wall thickness
board_th       = 6;                // soundboard thickness (rim plane z=0..6)

neck_len       = 1300;             // straight neck length
neck_d         = 34;               // neck diameter
neck_tilt      = 15;               // rise angle above horizontal (deg)
neck_z0        = -90;              // neck axis height at bowl center (x=0)
neck_s_tail    = -300;             // axis coordinate of tail end
clearance      = 0.75;             // radial gap where parts pass through walls

bridge_x       = 60;               // bridge position on soundboard
bridge_th      = 20;               // plank thickness (X)
bridge_w       = 70;               // plank width (Y) -> notch edges at +/-35
bridge_h       = 250;              // plank height
notch_r        = 3;                // half-round notch radius
notch_z0       = 70;               // lowest notch height above plank base
notch_pitch    = 16;               // vertical pitch within one rank

handle_d       = 28;
handle_x       = 40;
handle_y       = 85;               // +/- offset from centerline
handle_top     = 170;              // top of grip above rim plane
handle_bot     = -120;             // anchored down inside the bowl

string_d       = 2;

$fa = 4; $fs = 1.5;

bowl_r  = bowl_dia/2;                      // 258
zscale  = bowl_depth/bowl_r;               // squash sphere: depth 249 != r 258

// point on the neck axis at arc-length coordinate s (s=0 at bowl center)
function neck_pt(s) = [ s*cos(neck_tilt), 0, neck_z0 + s*sin(neck_tilt) ];

// notch k (0..20): even k -> left rank (11 notches), odd k -> right rank (10)
function notch_side(k) = (k % 2 == 0) ? -1 : 1;
function notch_h(k)    = notch_z0 + k*(notch_pitch/2);   // 70..230, interleaved

// ------------------------------ 1. bowl ------------------------------
module bowl() {
    difference() {
        union() {
            // lower half of a z-squashed spherical shell
            difference() {
                scale([1, 1, zscale]) sphere(r = bowl_r);
                scale([1, 1, zscale]) sphere(r = bowl_r - bowl_wall);
                translate([0, 0, bowl_r + 0.01])
                    cube([3*bowl_r, 3*bowl_r, 2*bowl_r], center = true);
            }
            // flat soundboard capping the rim
            cylinder(h = board_th, r = bowl_r);
        }
        // clearance bore for the neck passing through the shell
        translate([0, 0, neck_z0])
            rotate([0, -neck_tilt, 0])
            translate([neck_s_tail - 30, 0, 0])
            rotate([0, 90, 0])
            cylinder(h = neck_len + 60, d = neck_d + 2*clearance);
        // clearance holes in the soundboard for the two handles
        for (sy = [-1, 1])
            translate([handle_x, sy*handle_y, -10])
                cylinder(h = board_th + 20, d = handle_d + 2*clearance);
        // side sound hole in the calabash
        translate([0, 140, -100])
            rotate([-90, 0, 0])
            cylinder(h = bowl_r + 60, d = 70);
    }
}

// ------------------------------ 2. neck ------------------------------
module neck() {
    translate([0, 0, neck_z0])
        rotate([0, -neck_tilt, 0])
        translate([neck_s_tail, 0, 0])
        rotate([0, 90, 0])
        union() {
            cylinder(h = neck_len, d = neck_d);
            // simple domed head cap at the tuning end
            translate([0, 0, neck_len]) scale([1, 1, 0.5]) sphere(d = neck_d);
        }
}

// ----------------------------- 3. bridge -----------------------------
// Vertical plank, arched base (two feet), 21 half-round string notches
// cut into its left/right vertical edges. Local origin: base center, z up.
module bridge() {
    difference() {
        translate([-bridge_th/2, -bridge_w/2, 0])
            cube([bridge_th, bridge_w, bridge_h]);
        // arch between the two feet
        rotate([0, 90, 0])
            cylinder(h = bridge_th + 4, r = 22, center = true);
        // 21 notch positions
        for (k = [0 : string_count - 1])
            translate([0, notch_side(k)*bridge_w/2, notch_h(k)])
                rotate([0, 90, 0])
                cylinder(h = bridge_th + 4, r = notch_r, center = true);
        // slight top chamfer
        translate([0, 0, bridge_h + 24])
            rotate([45, 0, 0])
            cube([bridge_th + 4, 60, 60], center = true);
    }
}

// ----------------------------- 4. handles ----------------------------
module handles() {
    for (sy = [-1, 1])
        translate([handle_x, sy*handle_y, handle_bot]) {
            cylinder(h = handle_top - handle_bot, d = handle_d);
            translate([0, 0, handle_top - handle_bot]) sphere(d = handle_d);
        }
}

// ----------------------------- 5. strings ----------------------------
module string_seg(p, q) {
    hull() {
        translate(p) sphere(d = string_d, $fn = 12);
        translate(q) sphere(d = string_d, $fn = 12);
    }
}

module strings() {
    for (k = [0 : string_count - 1]) {
        s = 380 + k*27;                       // ring position along the neck
        p = neck_pt(s);                       // emerges from the neck
        q = [ bridge_x,
              notch_side(k)*bridge_w/2,
              board_th + notch_h(k) + notch_r - 1 ];  // seated in its notch
        string_seg(p, q);
    }
}

// --------------------------- top-level assembly ----------------------
// Parts are placed in playing position but NOT fused: each module is a
// distinct body, with clearance where the neck/handles pierce the bowl.
module kora_assembly() {
    bowl();
    neck();
    translate([bridge_x, 0, board_th]) bridge();   // stands on soundboard
    handles();
    strings();
}

kora_assembly();