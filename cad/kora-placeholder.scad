// Kora-inspired prototype placeholder geometry.
// Not a final CAD model. Source values from kora-design-table.xlsx.

bowl_diameter = 20.3;
bowl_depth = 9.8;
neck_length = 51.2;
bridge_height = 6.0;

module bowl_shell() {
  scale([bowl_diameter/2, bowl_diameter/2, bowl_depth])
    difference() {
      sphere(1, $fn=96);
      translate([0,0,0.08]) scale([0.86,0.86,0.86]) sphere(1, $fn=96);
      translate([-2,-2,-2]) cube([4,4,2]);
    }
}

module neck() {
  translate([-0.45,-0.45,-bowl_depth*0.15])
    cube([0.9,0.9,neck_length]);
}

module bridge() {
  translate([2.6,-0.35,0.6])
    linear_extrude(height=0.75)
      polygon(points=[[0,0],[2.5,0],[1.8,bridge_height],[0.7,bridge_height]]);
}

bowl_shell();
neck();
bridge();
