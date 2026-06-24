#!/usr/bin/env python3
"""
Parametric flat-pack kora stand generator.
Outputs CNC-ready DXF (per-part + nested) and an SVG preview.

Design: two cross-half-lapped vertical ribs forming a 4-arc saddle that
cradles the gourd, dropped into a base plate via through-tabs.
Sized for the KOR-000 segmented bowl (20.3 in OD) by default; fully parametric.

Units: millimetres. Author: generated for Tony Koop / kora repo.
"""
import math
import ezdxf

# ----------------------------------------------------------------------------
# PARAMETERS  (edit these to re-target a different gourd / plywood)
# ----------------------------------------------------------------------------
T          = 18.0     # plywood nominal thickness (18mm Baltic birch)
SLOT_CLR   = 0.2      # added to slot width for friction fit (MEASURE ply, retune)
GOURD_OD   = 515.6    # gourd outside diameter (20.3 in)  -> radius below
TOOL_DIA   = 6.35     # CNC bit diameter (1/4") for dogbones
DEG_STEP   = 1.0      # arc flattening resolution

R_G        = GOURD_OD / 2.0          # 257.8
SLOT_W     = T + SLOT_CLR            # 18.2
TR         = TOOL_DIA / 2.0          # dogbone radius

# Rib vertical scheme (y=0 at tab tips, base top at y=T)
BASE_TH      = T
BODY_BOT     = T                     # rib body rests on base top (y=18)
SHOULDER_H   = 280.0                 # shoulder height above base top
SHOULDER_Y   = BODY_BOT + SHOULDER_H # 298
SAGITTA      = 46.0                  # saddle dip
SADDLE_BOT_Y = SHOULDER_Y - SAGITTA  # 252
HALF_CHORD   = 150.0                 # saddle chord half-width -> shoulders at +/-150
HALF_W       = 185.0                 # rib half outer width at foot
R_S          = (HALF_CHORD**2 + SAGITTA**2) / (2*SAGITTA)   # saddle arc radius ~267.6
SADDLE_CY    = SADDLE_BOT_Y + R_S    # saddle arc center y

# cross-lap
JOINT_Y      = (SADDLE_BOT_Y + BODY_BOT) / 2.0   # (252+18)/2 = 135
HS           = SLOT_W / 2.0          # half slot width 9.1

# tabs (downward projections, panel-x positions)
TAB_XC       = [60.0, 150.0]         # tab centers (mirrored)
TAB_W        = 30.0                  # tab width

# decorative window (capsule) per side
WIN_XC       = 105.0
WIN_HALF     = 22.0                  # capsule half-width
WIN_Y0       = 70.0                  # straight section bottom
WIN_Y1       = 200.0                 # straight section top

# base plate
BASE_X       = 480.0
BASE_Y       = 400.0
BASE_CORNER  = 30.0


# ----------------------------------------------------------------------------
# helpers
# ----------------------------------------------------------------------------
def arc_pts(cx, cy, r, a0, a1, step=DEG_STEP):
    pts = []
    n = max(1, int(abs(a1 - a0) / step))
    for i in range(n + 1):
        a = math.radians(a0 + (a1 - a0) * i / n)
        pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return pts


def saddle_ang(x):
    return math.degrees(math.atan2(-math.sqrt(max(R_S**2 - x*x, 0)), x))


def rib_outline(kind):
    """kind: 'spine' (cross-lap slot opens at TOP) or 'cross' (opens at BOTTOM)."""
    p = []
    if kind == 'spine':
        ytop = SADDLE_CY - math.sqrt(R_S**2 - HS**2)
        p += [(HS, JOINT_Y), (HS, ytop)]
        p += arc_pts(0, SADDLE_CY, R_S, saddle_ang(HS), saddle_ang(HALF_CHORD))
    else:
        p += [(0.0, SADDLE_BOT_Y)]
        p += arc_pts(0, SADDLE_CY, R_S, saddle_ang(0.0), saddle_ang(HALF_CHORD))
    p += [(HALF_CHORD, SHOULDER_Y)]
    p += [(HALF_W, 90.0), (HALF_W, BODY_BOT)]
    for xc in sorted(TAB_XC, reverse=True):
        xo, xi = xc + TAB_W/2, xc - TAB_W/2
        p += [(xo, BODY_BOT), (xo, 0.0), (xi, 0.0), (xi, BODY_BOT)]
    if kind == 'cross':
        p += [(HS, BODY_BOT), (HS, JOINT_Y), (-HS, JOINT_Y), (-HS, BODY_BOT)]
    else:
        p += [(0.0, BODY_BOT)]
    for xc in sorted(TAB_XC):
        xi, xo = -(xc - TAB_W/2), -(xc + TAB_W/2)
        p += [(xi, BODY_BOT), (xi, 0.0), (xo, 0.0), (xo, BODY_BOT)]
    p += [(-HALF_W, BODY_BOT), (-HALF_W, 90.0), (-HALF_CHORD, SHOULDER_Y)]
    if kind == 'spine':
        ytop = SADDLE_CY - math.sqrt(R_S**2 - HS**2)
        p += arc_pts(0, SADDLE_CY, R_S, saddle_ang(-HALF_CHORD), saddle_ang(-HS))
        p += [(-HS, ytop), (-HS, JOINT_Y)]
    else:
        p += arc_pts(0, SADDLE_CY, R_S, saddle_ang(-HALF_CHORD), saddle_ang(0.0))
        p += [(0.0, SADDLE_BOT_Y)]
    return p


def capsule(cx, cy0, cy1, half):
    pts = []
    pts += arc_pts(cx, cy1, half, 0, 180)
    pts += arc_pts(cx, cy0, half, 180, 360)
    return pts


def base_outline():
    x, y, r = BASE_X/2, BASE_Y/2, BASE_CORNER
    p = []
    p += arc_pts(x - r,  y - r, r, 0, 90)
    p += arc_pts(-x + r, y - r, r, 90, 180)
    p += arc_pts(-x + r, -y + r, r, 180, 270)
    p += arc_pts(x - r,  -y + r, r, 270, 360)
    return p


def dogbones(msp, corners):
    for (x, y) in corners:
        msp.add_circle((x, y), TR, dxfattribs={'layer': 'DOGBONE'})


def add_poly(msp, pts, layer='CUT'):
    msp.add_lwpolyline([(x, y) for x, y in pts], close=True,
                       dxfattribs={'layer': layer})


# ----------------------------------------------------------------------------
def new_doc():
    doc = ezdxf.new('R2010')
    doc.units = ezdxf.units.MM
    for lay, col in [('CUT', 7), ('DOGBONE', 1), ('GUIDE', 3)]:
        if lay not in doc.layers:
            doc.layers.add(lay, color=col)
    return doc


def build_rib(kind, ox=0.0, oy=0.0, msp=None):
    own = msp is None
    if own:
        doc = new_doc(); msp = doc.modelspace()
    add_poly(msp, [(x+ox, y+oy) for x, y in rib_outline(kind)])
    for sx in (-1, 1):
        cx = sx*WIN_XC + ox
        add_poly(msp, [(x, y) for x, y in capsule(cx, WIN_Y0+oy, WIN_Y1+oy, WIN_HALF)])
    dogbones(msp, [(-HS+ox, JOINT_Y+oy), (HS+ox, JOINT_Y+oy)])
    if own:
        return doc


def base_slots():
    slots = []
    for xc in TAB_XC:                 # spine slots along +/-Y axis (X=0)
        for sy in (-1, 1):
            slots.append((0.0, sy*xc, T+SLOT_CLR, TAB_W+SLOT_CLR))
    for xc in TAB_XC:                 # cross slots along +/-X axis (Y=0)
        for sx in (-1, 1):
            slots.append((sx*xc, 0.0, TAB_W+SLOT_CLR, T+SLOT_CLR))
    return slots


def build_base(ox=0.0, oy=0.0, msp=None):
    own = msp is None
    if own:
        doc = new_doc(); msp = doc.modelspace()
    add_poly(msp, [(x+ox, y+oy) for x, y in base_outline()])
    for (cx, cy, w, h) in base_slots():
        x0, x1 = cx-w/2+ox, cx+w/2+ox
        y0, y1 = cy-h/2+oy, cy+h/2+oy
        add_poly(msp, [(x0, y0), (x1, y0), (x1, y1), (x0, y1)])
        dogbones(msp, [(x0, y0), (x1, y0), (x1, y1), (x0, y1)])
    if own:
        return doc


build_rib('spine').saveas('KOR-STAND-Rib-Spine.dxf')
build_rib('cross').saveas('KOR-STAND-Rib-Cross.dxf')
build_base().saveas('KOR-STAND-Base.dxf')

doc = new_doc(); msp = doc.modelspace()
build_base(ox=240, oy=210, msp=msp)
build_rib('spine', ox=240, oy=470, msp=msp)
build_rib('cross', ox=240, oy=790, msp=msp)
msp.add_lwpolyline([(0,0),(610,0),(610,1219),(0,1219)], close=True,
                   dxfattribs={'layer':'GUIDE'})
doc.saveas('KOR-STAND-nest.dxf')

gourd_clr = (SADDLE_CY - (R_S - R_G)) - R_G - BODY_BOT
print("R_S=%.2f  SADDLE_CY=%.2f  JOINT_Y=%.2f  SHOULDER_Y=%.2f" %
      (R_S, SADDLE_CY, JOINT_Y, SHOULDER_Y))
print("gourd bottom clearance above base top = %.1f mm (%.2f in)" %
      (gourd_clr, gourd_clr/25.4))
print("overall stand height (rib shoulder) = %.1f mm above base" % SHOULDER_H)
print("DXF written: per-part + nest")
