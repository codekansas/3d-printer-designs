// OpenSCAD design for a mount to hold red solo cups
// that can attach to my server rack, for holding scraps
// from my 3d printer.

// Measurements
num_screws = 3;
screw_rad = 5;
screw_diff = 15.82;
cup_outer_rad = 49.33;
cup_edge_rad = 4.86;
thickness = 8;
margin = 0.3;

module holder() {
    linear_extrude(thickness) {
        difference() {
            circle(cup_outer_rad + thickness - (cup_edge_rad - margin));
            circle(cup_outer_rad - (cup_edge_rad - margin));
        }
    }
}

module screw_mount() {
    linear_extrude(thickness) {
        difference() {
            square([
                screw_diff + thickness,
                screw_diff * num_screws + thickness,
            ]);
            for (i = [0:num_screws - 1]) {
                translate([(screw_diff + thickness) / 2, i * screw_diff + (screw_diff + thickness) / 2, 0]) {
                    circle(screw_rad);
                }
            }
        }
    }
}

holder();

translate([-(screw_diff + thickness) / 2, -(cup_outer_rad - (cup_edge_rad - margin)), 0]) {
    rotate([90, 0, 0]) {
        screw_mount();
    }
}
