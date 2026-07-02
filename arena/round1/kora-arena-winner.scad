// MakerBench Code-CAD Arena: Kora (21-string West African bridge harp)
// Seed: 0
// Parametric assembly of a multi-part kora.
// All dimensions in millimeters.

// --- Parametric Dimensions ---
bowl_diameter_mm = 516;
bowl_depth_mm = 249;
neck_length_mm = 1300;
string_count = 21;

// --- Helper Functions ---
// Euclidean distance for 3D coordinates
function dist(p1, p2) = sqrt((p1[0]-p2[0])*(p1[0]-p2[0]) + (p1[1]-p2[1])*(p1[1]-p2[1]) + (p1[2]-p2[2])*(p1[2]-p2[2]));

// --- Helper Modules ---
// Renders a cylindrical line/string between two points
module draw_string(A, B, r=0.5) {
    dir = B - A;
    h = sqrt(dir[0]*dir[0] + dir[1]*dir[1] + dir[2]*dir[2]);
    if (h > 0) {
        theta = atan2(sqrt(dir[0]*dir[0] + dir[1]*dir[1]), dir[2]);
        phi = atan2(dir[1], dir[0]);
        translate(A) {
            rotate([0, theta, phi]) {
                cylinder(r = r, h = h, $fn = 4);
            }
        }
    }
}

// --- Component Modules ---

// 1. Gourd Resonator Bowl & Soundboard Skin
module bowl(dia=bowl_diameter_mm, dep=bowl_depth_mm) {
    r = dia / 2;
    wall_thickness = 12;
    
    // Hemispherical gourd shell
    color("SaddleBrown") {
        difference() {
            // Outer scaled hemisphere (bowl_depth is slightly shallower than radius)
            scale([dep/r, 1, 1]) {
                difference() {
                    sphere(r = r, $fn = 80);
                    // Slices the sphere to keep only the negative X hemisphere (the bowl body)
                    translate([r, 0, 0]) cube(r * 2, center = true);
                }
            }
            
            // Inner scaled hemisphere for hollowing the shell
            scale([(dep - wall_thickness)/r, (r - wall_thickness)/r, (r - wall_thickness)/r]) {
                difference() {
                    sphere(r = r, $fn = 80);
                    translate([r, 0, 0]) cube(r * 2, center = true);
                }
            }
            
            // Side Soundhole (circular cutout typical of calabash gourds)
            translate([-dep * 0.6, 140, 100]) {
                rotate([0, 90, 45]) {
                    cylinder(r = 45, h = 100, center = true, $fn = 40);
                }
            }
            
            // Neck pass-through cutouts
            translate([-22, 0, 0]) {
                cylinder(r = 19, h = dia * 2, center = true, $fn = 30);
            }
            
            // Handle pass-through cutouts
            translate([-15, -120, 0]) cylinder(r = 12.5, h = dia * 2, center = true, $fn = 20);
            translate([-15, 120, 0]) cylinder(r = 12.5, h = dia * 2, center = true, $fn = 20);
        }
    }
    
    // Skin Soundboard cover (wheat colored animal skin stretched flat over the opening)
    color("Wheat") {
        translate([0, 0, 0]) {
            rotate([0, 90, 0]) {
                cylinder(r = r - 2, h = 3, center = true, $fn = 80);
            }
        }
    }
    
    // Decorative brass tacks holding the skin to the gourd
    color("Gold") {
        tack_count = 38;
        for (i = [0 : tack_count - 1]) {
            angle = i * (360 / tack_count);
            y_pos = (r - 8) * cos(angle);
            z_pos = (r - 8) * sin(angle);
            // Omit tacks near neck exits and soundholes
            if (abs(z_pos) > 35 && (y_pos < 100 || z_pos < 50)) {
                translate([1.5, y_pos, z_pos]) {
                    rotate([0, 90, angle]) {
                        cylinder(r1 = 5, r2 = 3, h = 4, center = true, $fn = 12);
                    }
                }
            }
        }
    }
}

// 2. Neck with Tuning Rings (Konso)
module neck(length=neck_length_mm, diameter=36) {
    r = diameter / 2;
    
    // Main neck pole (runs parallel to the soundboard, offset to pass through the bowl)
    color("Sienna") {
        translate([-22, 0, 300]) {
            translate([0, 0, -650]) {
                cylinder(r = r, h = length, $fn = 40);
            }
        }
    }
    
    // Traditional leather tuning rings (wrapped Konso)
    color("DarkSlateGray") {
        ring_spacing = 25;
        start_z = 350;
        for (i = [0 : 20]) {
            z_pos = start_z + i * ring_spacing;
            translate([-22, 0, z_pos]) {
                rotate([0, 0, i * 17]) {
                    difference() {
                        cylinder(r = r + 6, h = 12, center = true, $fn = 24);
                        cylinder(r = r - 0.5, h = 14, center = true, $fn = 24);
                    }
                }
            }
        }
    }
    
    // Neck top decorative finial
    color("Tan") {
        translate([-22, 0, 950]) {
            cylinder(r1 = r, r2 = r + 4, h = 20, $fn = 24);
            translate([0, 0, 20]) sphere(r = r + 4, $fn = 24);
        }
    }
}

// 3. Vertical Notched Bridge
module bridge(height=180, thickness=10) {
    // Bridge stands on the soundboard (starts at x=0, extends in +x direction)
    // The plate lies along YZ plane with notches carved on left/right outer edges.
    
    color("BurlyWood") {
        difference() {
            // Tapered vertical bridge body
            translate([0, 0, -thickness/2]) {
                linear_extrude(height = thickness) {
                    polygon(points = [
                        [-10, -50], 
                        [0, -45],
                        [height - 30, -35], 
                        [height, -25],
                        [height, 25],
                        [height - 30, 35],  
                        [0, 45],
                        [-10, 50]   
                    ]);
                }
            }
            
            // Central ornamental cutout
            translate([height/2, 0, 0]) {
                cube([height/3, 16, thickness + 2], center = true);
            }
            
            // Left String Notches: 11 notches spaced along the left side
            for (i = [0 : 10]) {
                x_pos = 35 + i * 13;
                y_pos = -35 + i * 0.9;
                translate([x_pos, y_pos, 0]) {
                    cylinder(r = 1.5, h = thickness + 2, center = true, $fn = 8);
                }
            }
            
            // Right String Notches: 10 notches spaced along the right side
            for (i = [0 : 9]) {
                x_pos = 40 + i * 14;
                y_pos = 35 - i * 1.0;
                translate([x_pos, y_pos, 0]) {
                    cylinder(r = 1.5, h = thickness + 2, center = true, $fn = 8);
                }
            }
        }
    }
    
    // Wooden base wedge/pad distributing pressure on the soundboard skin
    color("SaddleBrown") {
        translate([3, 0, 0]) {
            cube([6, 110, 24], center = true);
        }
    }
}

// 4. Handles and Crossbar
module crossbar_or_handles() {
    handle_len = 650;
    handle_rad = 11;
    handle_x = -15;
    handle_y_offset = 120;
    
    // Hand grips: Two parallel sticks passing through the gourd skin
    for (y_dir = [-1, 1]) {
        // Wooden support rods
        color("Sienna") {
            translate([handle_x, y_dir * handle_y_offset, -230]) {
                cylinder(r = handle_rad, h = handle_len, $fn = 30);
            }
        }
        // Leather grip wraps on the handles
        color("DarkRed") {
            translate([handle_x, y_dir * handle_y_offset, 50]) {
                cylinder(r = handle_rad + 1.5, h = 250, $fn = 30);
            }
        }
    }
    
    // Crossbar: Perpendicular bracing rod passing under the neck/handles
    color("Sienna") {
        translate([-32, 0, 60]) {
            rotate([90, 0, 0]) {
                cylinder(r = 10, h = 530, center = true, $fn = 24);
            }
        }
    }
}

// 5. Stylized Strings (21 strings total)
module strings() {
    // Anchor point on the neck below the bowl
    anchor = [-22, 0, -250];
    
    // Base metal anchor collar
    color("Gold") {
        translate([-22, 0, -250]) {
            rotate([0, 90, 0]) {
                rotate_extrude($fn=24) {
                    translate([22, 0, 0]) {
                        circle(r=4, $fn=12);
                    }
                }
            }
        }
    }
    
    // 11 Left Strings
    for (i = [0 : 10]) {
        z_neck = 350 + i * 48;
        // String starts at a neck tuning ring, slightly offset radially
        P_neck = [-22 - 12 * cos(i*10), -18, z_neck];
        // Passes through the bridge notches at z=120
        x_notch = 35 + i * 13;
        y_notch = -35 + i * 0.9;
        P_bridge = [x_notch, y_notch, 120];
        
        color("LightYellow") {
            draw_string(P_neck, P_bridge, r = 0.6);
            draw_string(P_bridge, anchor, r = 0.6);
        }
    }
    
    // 10 Right Strings
    for (j = [0 : 9]) {
        z_neck = 380 + j * 50;
        P_neck = [-22 - 12 * cos(j*10), 18, z_neck];
        x_notch = 40 + j * 14;
        y_notch = 35 - j * 1.0;
        P_bridge = [x_notch, y_notch, 120];
        
        color("LightYellow") {
            draw_string(P_neck, P_bridge, r = 0.6);
            draw_string(P_bridge, anchor, r = 0.6);
        }
    }
}

// --- Top-Level Assembly Module ---
module assembly() {
    // 1. Resonator gourd bowl
    bowl();
    
    // 2. Neck passing through bowl
    neck();
    
    // 3. Hand grips and crossbar
    crossbar_or_handles();
    
    // 4. Vertical bridge standing on soundboard skin
    translate([0, 0, 120]) {
        bridge();
    }
    
    // 5. Stylized strings
    strings();
}

// Render the final assembly
assembly();