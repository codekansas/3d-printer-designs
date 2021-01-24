/**
 * A water holder for can planter.
 *
 * All measurements are in millimeters.
 *
 * Parameters:
 *   - can_rad: Radius of the can.
 *   - thickness: Thickness of the holder.
 *   - height: Height of the holder.
 *   - vert_scale: Ratio between horizontal and vertical diameters.
 */

can_rad = (75 / 2) + 2;

thickness = 5;
height = 50;
vert_scale = 0.8;

outer_rad = sqrt(can_rad * can_rad + height * height);
inner_rad = outer_rad - thickness;

base_top = cos(asin(can_rad / inner_rad)) * inner_rad;
base_bot = cos(asin(can_rad / outer_rad)) * outer_rad;

scale([1, 1, vert_scale]) {
    union() {
        difference() {
            sphere(outer_rad);
            sphere(inner_rad);
            translate([0, 0, -outer_rad])
                cylinder(outer_rad * 2, r = can_rad);
        }
        translate([0, 0, -base_top])
            cylinder(thickness, r = can_rad / 2);
        translate([0, 0, -base_bot])
            cylinder(base_bot - base_top, r = can_rad);
    }
}
