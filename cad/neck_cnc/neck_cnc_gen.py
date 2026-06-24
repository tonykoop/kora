#!/usr/bin/env python3
"""
Parametric kora NECK CNC packet generator  (DRAFT).

Mechanical concept (confirmed with Tony):
  - 21 strings enter the FRONT face through small holes, two rows, staggered
    up the neck by speaking length.
  - Each string routes through an internal BACK channel (closed by a cover plate)
    to a SIDE-mounted guitar tuner whose post enters from the side bore.
  - Flat-backed rectangular blank.

UNITS: inches.  String stations seeded from the design.md string schedule
(speaking lengths); reconcile against the real bridge datum before cutting.

!!! TUNER DIMS ARE PLACEHOLDERS !!!  Set POST_D / BUSHING_D / SCREW_OFF /
side-bore depth from Tony's measured tuners, then re-run.
"""
import math, ezdxf

# ------------------------- PARAMETERS (edit me) -----------------------------
IN = 1.0
N          = 21
# speaking lengths (in) from design.md schedule, string 1 (treble) .. 21 (bass)
L = [8.70,9.40,10.20,11.00,12.00,13.00,13.80,15.00,16.20,17.50,18.50,
     19.80,21.20,22.50,24.00,25.50,27.00,28.20,29.50,30.50,31.10]

# neck blank (flat-backed rectangular) -- ASSUMPTION, confirm
W_NECK     = 1.50      # width across face
T_NECK     = 1.25      # thickness front->back
STOCK_LEN  = 52.0      # blank length (string field + tuner run-out + bowl tenon)
DATUM      = 4.0       # station of string #1 hole, up from blank bottom (bowl end)

# front-face string holes
ROW_OFF    = 0.35      # +/- lateral offset of the two rows from centerline
FRONT_D    = 0.16      # front hole diameter (string + knot/bead clearance)

# back routing channel (covered by plate)
CH_W       = 0.75      # channel width
CH_DEPTH   = 0.75      # channel depth from back face (front wall left = T_NECK-CH_DEPTH)
CH_MARGIN  = 1.5       # channel runs DATUM-margin .. last_station+margin

# cover plate
COVER_W    = 0.95
COVER_SCREW_D = 0.110  # #4 pilot
COVER_SCREW_PITCH = 4.0

# side tuner bores  ---- PLACEHOLDERS, set from measured tuners ----
POST_D     = 0.250     # post bore diameter (TBD)
BUSHING_D  = 0.395     # front bushing/ferrule counterbore (TBD)
SCREW_OFF  = 0.50      # mounting-screw offset from post along neck (TBD)
SCREW_D    = 0.090     # tuner mounting screw pilot (TBD)
BORE_Z     = T_NECK-0.40  # bore center depth from FRONT face (into channel)

TOOL_DIA   = 0.25
DEG = 2.0
# ----------------------------------------------------------------------------

stations = [DATUM + (Li - L[0]) for Li in L]          # up-neck position of each hole
# alternate strings to opposite rows/sides: odd->RIGHT(+), even->LEFT(-)
sides = [ +1 if (i % 2 == 0) else -1 for i in range(N) ]   # i=0 is string#1 -> +
right_idx = [i for i in range(N) if sides[i] > 0]     # 11
left_idx  = [i for i in range(N) if sides[i] < 0]     # 10

def new_doc():
    d = ezdxf.new('R2010'); d.units = ezdxf.units.IN
    for lay,c in [('CUT',7),('DRILL',5),('SIDE',2),('CHANNEL',3),('DOGBONE',1),('TEXT',8)]:
        if lay not in d.layers: d.layers.add(lay,color=c)
    return d

def rect(msp, x0,y0,x1,y1, layer='CUT'):
    msp.add_lwpolyline([(x0,y0),(x1,y0),(x1,y1),(x0,y1)], close=True,
                       dxfattribs={'layer':layer})

def rrect(msp, x0,y0,x1,y1,r, layer='CHANNEL'):
    pts=[]
    import math
    def arc(cx,cy,a0,a1):
        n=max(1,int(abs(a1-a0)/DEG))
        return [(cx+r*math.cos(math.radians(a0+(a1-a0)*k/n)),
                 cy+r*math.sin(math.radians(a0+(a1-a0)*k/n))) for k in range(n+1)]
    pts+=arc(x1-r,y0+r,-90,0); pts+=arc(x1-r,y1-r,0,90)
    pts+=arc(x0+r,y1-r,90,180); pts+=arc(x0+r,y0+r,180,270)
    msp.add_lwpolyline(pts,close=True,dxfattribs={'layer':layer})

# ============================ FRONT DRILL =================================
d=new_doc(); m=d.modelspace()
rect(m,-W_NECK/2,0,W_NECK/2,STOCK_LEN,'CUT')
for i in range(N):
    x = sides[i]*ROW_OFF; y = stations[i]
    m.add_circle((x,y),FRONT_D/2,dxfattribs={'layer':'DRILL'})
    m.add_text("S%d"%(i+1),height=0.12,dxfattribs={'layer':'TEXT'}).set_placement((x+0.12,y))
d.saveas('KOR-NECK-Front-Drill.dxf')

# ============================ BACK CHANNEL + COVER SCREWS ==================
d=new_doc(); m=d.modelspace()
rect(m,-W_NECK/2,0,W_NECK/2,STOCK_LEN,'CUT')
y0=stations[0]-CH_MARGIN; y1=stations[-1]+CH_MARGIN
rrect(m,-CH_W/2,y0,CH_W/2,y1,CH_W/2-0.05,'CHANNEL')
# cover screw pilots flanking channel
yy=y0
while yy<=y1:
    for sx in (-1,1):
        m.add_circle((sx*(COVER_W/2),yy),COVER_SCREW_D/2,dxfattribs={'layer':'DRILL'})
    yy+=COVER_SCREW_PITCH
d.saveas('KOR-NECK-Back-Channel.dxf')

# ============================ COVER PLATE =================================
d=new_doc(); m=d.modelspace()
rrect(m,-COVER_W/2,y0-0.4,COVER_W/2,y1+0.4,COVER_W/2-0.05,'CUT')
yy=y0
while yy<=y1:
    for sx in (-1,1):
        m.add_circle((sx*(COVER_W/2),yy),COVER_SCREW_D/2,dxfattribs={'layer':'DRILL'})
    yy+=COVER_SCREW_PITCH
d.saveas('KOR-NECK-Cover.dxf')

# ============================ SIDE DRILL (both sides, fixturing ref) =======
# Side elevation: X = up-neck (station), Y = thickness (0 front .. T_NECK back)
for side,idx,tag in ((+1,right_idx,'RIGHT'),(-1,left_idx,'LEFT')):
    d=new_doc(); m=d.modelspace()
    rect(m,0,0,STOCK_LEN,T_NECK,'CUT')
    # channel band shown for reference
    rect(m,y0,T_NECK-CH_DEPTH,y1,T_NECK,'CHANNEL')
    for i in idx:
        st=stations[i]
        m.add_circle((st,BORE_Z),POST_D/2,dxfattribs={'layer':'SIDE'})
        m.add_circle((st,BORE_Z),BUSHING_D/2,dxfattribs={'layer':'SIDE'})
        m.add_circle((st+SCREW_OFF,BORE_Z),SCREW_D/2,dxfattribs={'layer':'DRILL'})
        m.add_text("S%d"%(i+1),height=0.12,dxfattribs={'layer':'TEXT'}).set_placement((st,BORE_Z-0.28))
    d.saveas('KOR-NECK-Side-%s.dxf'%tag)

# summary
print("strings:",N," right(side+):",len(right_idx)," left(side-):",len(left_idx))
print("hole field (in): %.2f .. %.2f  (span %.2f)"%(stations[0],stations[-1],stations[-1]-stations[0]))
print("channel y: %.2f .. %.2f  width %.2f depth %.2f (front wall %.2f)"%(y0,y1,CH_W,CH_DEPTH,T_NECK-CH_DEPTH))
print("DXF: Front-Drill, Back-Channel, Cover, Side-RIGHT, Side-LEFT")
