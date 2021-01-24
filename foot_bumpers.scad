/**
 * Bumpers for the feet of our dresser, so our Roomba can go underneath.
 *
 * All measurements are in millimeters.
 *
 * Parameters:
 *   - foot_diameter: Diameter of each foot (feet are circular).
 *   - horizontal_thickness: Horizontal thickness.
 *   - base_horizontal_thickness: Base horizontal thickness.
 *   - vertical_thickness: Vertical thickness.
 *   - inlet_depth: Depth of the inlet (for keeping feet centered).
 *   - padding: Padding on each side.
 */

foot_diameter = 27.09;
horizontal_thickness = 5;
base_horizontal_thickness = 10;
vertical_thickness = 15;
inlet_depth = 5;
padding = 1;

difference() {
    cylinder(
        vertical_thickness + inlet_depth,
        d1=foot_diameter + base_horizontal_thickness * 2 + padding * 2,
        d2=foot_diameter + horizontal_thickness * 2 + padding * 2
    );
    translate([0, 0, vertical_thickness])
        cylinder(inlet_depth + padding, d=foot_diameter + padding * 2);
}
