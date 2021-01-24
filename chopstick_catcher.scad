/**
 * A catcher for chopsticks for our dishwasher.
 *
 * All measurements are in millimeters.
 *
 * Parameters:
 *   - thickness: Vertical thickness.
 *   - padding: Padding of outer edge.
 *   - slat_size: Size of slats.
 *   - short_length: Short length.
 *   - long_length: Long length.
 *   - height: Height.
 *   - first_indent: Start of first indent.
 *   - second_indent: Start of second indent.
 *   - third_indent: Start of third indent.
 *   - indent_width: Width of indents.
 *   - indent_height: Height of indents.
 */

thickness = 3;
padding = 1;
slat_size = 3;

short_length = 46.36;
long_length = 61.76;
height = 51.76;

first_indent = 15.92;
second_indent = 29.97;
third_indent = 44.44;

indent_width = 1.65;
indent_height = 11.15;

module base() {
    difference() {
        polygon([
            [padding, padding],
            [short_length - padding, padding],
            [long_length - padding, (height / 2) - padding],
            [short_length - padding, height - padding],
            [padding, height - padding],
        ]);
        translate([first_indent - padding, padding])
            square([indent_width + (padding * 2), indent_height]);
        translate([second_indent - padding, padding])
            square([indent_width + (padding * 2), indent_height]);
        translate([third_indent - padding, padding])
            square([indent_width + (padding * 2), indent_height]);
    }
}

linear_extrude(thickness) {
    difference() {
        base();
        intersection() {
            offset(r = -slat_size)
                base();
            for (i = [0 : 2 : 100])
                translate([i * slat_size, 0])
                    rotate([0, 0, 45])
                        square([slat_size * 0.8, long_length * 2]);
        }
    }
}
